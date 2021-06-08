Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279153A02AB
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbhFHTHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237822AbhFHTFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:05:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72A716142D;
        Tue,  8 Jun 2021 18:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178003;
        bh=4cpJrC+qDZ4i+XOG+qq41pqPN2GzUACvaDFGJms1hMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9IU4Q8dodrahBBtbmghn1McdL4GeDarlS86A5bQLGabEj3AdTf+L64cQnQAqLDus
         JXHYXYS9azslHUW+AuWWDI0hxz2GMA9VSnZdCV83LuL2J7eIpSOkkfxhRGY2G4yjwS
         Bg1Js/VjzkJBNzu+kqVPYZ0uAHgZZ+XiKCymtdBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Israel Rukshin <israelr@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 039/161] nvmet: fix freeing unallocated p2pmem
Date:   Tue,  8 Jun 2021 20:26:09 +0200
Message-Id: <20210608175946.783576152@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

[ Upstream commit bcd9a0797d73eeff659582f23277e7ab6e5f18f3 ]

In case p2p device was found but the p2p pool is empty, the nvme target
is still trying to free the sgl from the p2p pool instead of the
regular sgl pool and causing a crash (BUG() is called). Instead, assign
the p2p_dev for the request only if it was allocated from p2p pool.

This is the crash that was caused:

[Sun May 30 19:13:53 2021] ------------[ cut here ]------------
[Sun May 30 19:13:53 2021] kernel BUG at lib/genalloc.c:518!
[Sun May 30 19:13:53 2021] invalid opcode: 0000 [#1] SMP PTI
...
[Sun May 30 19:13:53 2021] kernel BUG at lib/genalloc.c:518!
...
[Sun May 30 19:13:53 2021] RIP: 0010:gen_pool_free_owner+0xa8/0xb0
...
[Sun May 30 19:13:53 2021] Call Trace:
[Sun May 30 19:13:53 2021] ------------[ cut here ]------------
[Sun May 30 19:13:53 2021]  pci_free_p2pmem+0x2b/0x70
[Sun May 30 19:13:53 2021]  pci_p2pmem_free_sgl+0x4f/0x80
[Sun May 30 19:13:53 2021]  nvmet_req_free_sgls+0x1e/0x80 [nvmet]
[Sun May 30 19:13:53 2021] kernel BUG at lib/genalloc.c:518!
[Sun May 30 19:13:53 2021]  nvmet_rdma_release_rsp+0x4e/0x1f0 [nvmet_rdma]
[Sun May 30 19:13:53 2021]  nvmet_rdma_send_done+0x1c/0x60 [nvmet_rdma]

Fixes: c6e3f1339812 ("nvmet: add metadata support for block devices")
Reviewed-by: Israel Rukshin <israelr@nvidia.com>
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 348057fdc568..7d16cb4cd8ac 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -999,19 +999,23 @@ static unsigned int nvmet_data_transfer_len(struct nvmet_req *req)
 	return req->transfer_len - req->metadata_len;
 }
 
-static int nvmet_req_alloc_p2pmem_sgls(struct nvmet_req *req)
+static int nvmet_req_alloc_p2pmem_sgls(struct pci_dev *p2p_dev,
+		struct nvmet_req *req)
 {
-	req->sg = pci_p2pmem_alloc_sgl(req->p2p_dev, &req->sg_cnt,
+	req->sg = pci_p2pmem_alloc_sgl(p2p_dev, &req->sg_cnt,
 			nvmet_data_transfer_len(req));
 	if (!req->sg)
 		goto out_err;
 
 	if (req->metadata_len) {
-		req->metadata_sg = pci_p2pmem_alloc_sgl(req->p2p_dev,
+		req->metadata_sg = pci_p2pmem_alloc_sgl(p2p_dev,
 				&req->metadata_sg_cnt, req->metadata_len);
 		if (!req->metadata_sg)
 			goto out_free_sg;
 	}
+
+	req->p2p_dev = p2p_dev;
+
 	return 0;
 out_free_sg:
 	pci_p2pmem_free_sgl(req->p2p_dev, req->sg);
@@ -1019,25 +1023,19 @@ out_err:
 	return -ENOMEM;
 }
 
-static bool nvmet_req_find_p2p_dev(struct nvmet_req *req)
+static struct pci_dev *nvmet_req_find_p2p_dev(struct nvmet_req *req)
 {
-	if (!IS_ENABLED(CONFIG_PCI_P2PDMA))
-		return false;
-
-	if (req->sq->ctrl && req->sq->qid && req->ns) {
-		req->p2p_dev = radix_tree_lookup(&req->sq->ctrl->p2p_ns_map,
-						 req->ns->nsid);
-		if (req->p2p_dev)
-			return true;
-	}
-
-	req->p2p_dev = NULL;
-	return false;
+	if (!IS_ENABLED(CONFIG_PCI_P2PDMA) ||
+	    !req->sq->ctrl || !req->sq->qid || !req->ns)
+		return NULL;
+	return radix_tree_lookup(&req->sq->ctrl->p2p_ns_map, req->ns->nsid);
 }
 
 int nvmet_req_alloc_sgls(struct nvmet_req *req)
 {
-	if (nvmet_req_find_p2p_dev(req) && !nvmet_req_alloc_p2pmem_sgls(req))
+	struct pci_dev *p2p_dev = nvmet_req_find_p2p_dev(req);
+
+	if (p2p_dev && !nvmet_req_alloc_p2pmem_sgls(p2p_dev, req))
 		return 0;
 
 	req->sg = sgl_alloc(nvmet_data_transfer_len(req), GFP_KERNEL,
@@ -1066,6 +1064,7 @@ void nvmet_req_free_sgls(struct nvmet_req *req)
 		pci_p2pmem_free_sgl(req->p2p_dev, req->sg);
 		if (req->metadata_sg)
 			pci_p2pmem_free_sgl(req->p2p_dev, req->metadata_sg);
+		req->p2p_dev = NULL;
 	} else {
 		sgl_free(req->sg);
 		if (req->metadata_sg)
-- 
2.30.2




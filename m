Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2233934C809
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhC2IT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233348AbhC2ISf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:18:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FAB061878;
        Mon, 29 Mar 2021 08:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005915;
        bh=aozgTVH3HTG6JxHeF/viQWKnhix4qY/2AgcsbmddK/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elsZZ2CV6XCIf1QV8kNQgk6AqZ5hwozmeaLRyDI23ZfWdYLXyb/kHTtOOmVN+RvWn
         myAH51LS9ZebmzGSP2/w1HVv6UwG13WJNqdaOUqudIAuDcYeUVAv3dMNrFKGFH9o9/
         KfR14QcFAyuTJP/MD5EF983f6hbKuwj2hiAynIRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/221] nvme-rdma: Fix a use after free in nvmet_rdma_write_data_done
Date:   Mon, 29 Mar 2021 09:56:21 +0200
Message-Id: <20210329075630.849373096@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit abec6561fc4e0fbb19591a0b35676d8c783b5493 ]

In nvmet_rdma_write_data_done, rsp is recoverd by wc->wr_cqe and freed by
nvmet_rdma_release_rsp(). But after that, pr_info() used the freed
chunk's member object and could leak the freed chunk address with
wc->wr_cqe by computing the offset.

Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 06b6b742bb21..6c1f3ab7649c 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -802,9 +802,8 @@ static void nvmet_rdma_write_data_done(struct ib_cq *cq, struct ib_wc *wc)
 		nvmet_req_uninit(&rsp->req);
 		nvmet_rdma_release_rsp(rsp);
 		if (wc->status != IB_WC_WR_FLUSH_ERR) {
-			pr_info("RDMA WRITE for CQE 0x%p failed with status %s (%d).\n",
-				wc->wr_cqe, ib_wc_status_msg(wc->status),
-				wc->status);
+			pr_info("RDMA WRITE for CQE failed with status %s (%d).\n",
+				ib_wc_status_msg(wc->status), wc->status);
 			nvmet_rdma_error_comp(queue);
 		}
 		return;
-- 
2.30.1




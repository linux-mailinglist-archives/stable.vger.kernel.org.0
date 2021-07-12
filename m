Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9993C4DDA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241768AbhGLHPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240994AbhGLHNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:13:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B814F61351;
        Mon, 12 Jul 2021 07:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073858;
        bh=uuKmpCSMOIyf+X32OEQma9nrd/E4Grl5m1jxhRxj3oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XhFSqWqwHgVS6x8ampLoJLqAaI3XF09npJREDUB+lK6kPovUtqKlKKNOtHxsiTKAC
         RQjiyifVMYjfA8o+uvZ69zXfuQ8j+jzleqjHrKiNbxdQiHIVwRuB+Jw5verGx0IUpd
         Ixi97xCDBQx6+4Q9xnqEbVa3qnanTgW9CETsxQ34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 382/700] RDMA/srp: Fix a recently introduced memory leak
Date:   Mon, 12 Jul 2021 08:07:45 +0200
Message-Id: <20210712061017.012064722@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 7ec2e27a3afff64c96bfe7a77685c33619db84be ]

Only allocate a memory registration list if it will be used and if it will
be freed.

Link: https://lore.kernel.org/r/20210524041211.9480-5-bvanassche@acm.org
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Fixes: f273ad4f8d90 ("RDMA/srp: Remove support for FMR memory registration")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 31f8aa2c40ed..168705c88e2f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -998,7 +998,6 @@ static int srp_alloc_req_data(struct srp_rdma_ch *ch)
 	struct srp_device *srp_dev = target->srp_host->srp_dev;
 	struct ib_device *ibdev = srp_dev->dev;
 	struct srp_request *req;
-	void *mr_list;
 	dma_addr_t dma_addr;
 	int i, ret = -ENOMEM;
 
@@ -1009,12 +1008,12 @@ static int srp_alloc_req_data(struct srp_rdma_ch *ch)
 
 	for (i = 0; i < target->req_ring_size; ++i) {
 		req = &ch->req_ring[i];
-		mr_list = kmalloc_array(target->mr_per_cmd, sizeof(void *),
-					GFP_KERNEL);
-		if (!mr_list)
-			goto out;
-		if (srp_dev->use_fast_reg)
-			req->fr_list = mr_list;
+		if (srp_dev->use_fast_reg) {
+			req->fr_list = kmalloc_array(target->mr_per_cmd,
+						sizeof(void *), GFP_KERNEL);
+			if (!req->fr_list)
+				goto out;
+		}
 		req->indirect_desc = kmalloc(target->indirect_size, GFP_KERNEL);
 		if (!req->indirect_desc)
 			goto out;
-- 
2.30.2




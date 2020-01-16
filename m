Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D76B13F78B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387621AbgAPQ74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:59:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387618AbgAPQ7y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:59:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DAA020728;
        Thu, 16 Jan 2020 16:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193993;
        bh=oRd0E7SCdWtugFrhZ95B+IDGaaAgSbq3cQIPybCl4JM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y9r0CW0Qf50pFq0rVdYuNurUre/SudPkrBWBZHGvL5ypL5Mi+ohZW5OJo3s2+IGB8
         mvxRD6/qMFU58fvMPD7439V9C0tbmKMxCQU/C5aefZ5zp8g5HZnNYyH0w7GD9sVKGD
         zr2a4eMOu1Sietf3q/s6vjshcLrZiuRQ0dguM3mg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 123/671] IB/iser: Pass the correct number of entries for dma mapped SGL
Date:   Thu, 16 Jan 2020 11:50:32 -0500
Message-Id: <20200116165940.10720-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Israel Rukshin <israelr@mellanox.com>

[ Upstream commit 57b26497fabe1b9379b59fbc7e35e608e114df16 ]

ib_dma_map_sg() augments the SGL into a 'dma mapped SGL'. This process may
change the number of entries and the lengths of each entry.

Code that touches dma_address is iterating over the 'dma mapped SGL' and
must use dma_nents which returned from ib_dma_map_sg().

ib_sg_to_pages() and ib_map_mr_sg() are using dma_address so they must use
dma_nents.

Fixes: 39405885005a ("IB/iser: Port to new fast registration API")
Fixes: bfe066e256d5 ("IB/iser: Reuse ib_sg_to_pages")
Signed-off-by: Israel Rukshin <israelr@mellanox.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Acked-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 009be8889d71..379bc0dfc388 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -240,8 +240,8 @@ int iser_fast_reg_fmr(struct iscsi_iser_task *iser_task,
 	page_vec->npages = 0;
 	page_vec->fake_mr.page_size = SIZE_4K;
 	plen = ib_sg_to_pages(&page_vec->fake_mr, mem->sg,
-			      mem->size, NULL, iser_set_page);
-	if (unlikely(plen < mem->size)) {
+			      mem->dma_nents, NULL, iser_set_page);
+	if (unlikely(plen < mem->dma_nents)) {
 		iser_err("page vec too short to hold this SG\n");
 		iser_data_buf_dump(mem, device->ib_device);
 		iser_dump_page_vec(page_vec);
@@ -451,10 +451,10 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 
 	ib_update_fast_reg_key(mr, ib_inc_rkey(mr->rkey));
 
-	n = ib_map_mr_sg(mr, mem->sg, mem->size, NULL, SIZE_4K);
-	if (unlikely(n != mem->size)) {
+	n = ib_map_mr_sg(mr, mem->sg, mem->dma_nents, NULL, SIZE_4K);
+	if (unlikely(n != mem->dma_nents)) {
 		iser_err("failed to map sg (%d/%d)\n",
-			 n, mem->size);
+			 n, mem->dma_nents);
 		return n < 0 ? n : -EINVAL;
 	}
 
-- 
2.20.1


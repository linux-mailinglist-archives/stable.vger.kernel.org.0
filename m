Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D492E14BA91
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730096AbgA1OQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:16:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730323AbgA1OQd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:16:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2220021739;
        Tue, 28 Jan 2020 14:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220992;
        bh=SgJWTW4n7ASg2yHjYEkALQkHjY6x8z5LrjxxF7dd860=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhYcfPJRX+7Lfye1XwMqlRKaXBk56BKCWkYK1a3eia7ysSqHM0/kZOhLJEvOsfu++
         aXxR9Q0ww03N+UkZ9wSN6BpVevN58POv4FpOK2471AMTFeBk0Xp086g2dTNGXI0sUy
         n2LZZKCAeDReh0HvHFSCjANOkFT0y+5Xfz4o3Cf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 046/271] IB/iser: Pass the correct number of entries for dma mapped SGL
Date:   Tue, 28 Jan 2020 15:03:15 +0100
Message-Id: <20200128135856.072520674@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9c3e9ab53a415..759c2fe033e71 100644
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
@@ -450,10 +450,10 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 
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




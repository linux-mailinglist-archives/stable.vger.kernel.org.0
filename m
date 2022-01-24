Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073B8499667
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346861AbiAXVDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350425AbiAXU5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:57:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2076C110F33;
        Mon, 24 Jan 2022 11:18:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5191A60918;
        Mon, 24 Jan 2022 19:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F0CC340E5;
        Mon, 24 Jan 2022 19:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051907;
        bh=I5g32WXKgHPSR8SEIEeB0HviWhU+yo4ohTjx1FEUO9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDrCgavj08fU8wtHvmDBD7op80DCQqCWzr8BQS6w1bFO6J2MGCV6IEHiY3F26rzVD
         vBuDQLULRdNw3WHi0MD93rSwIodCGZ9l6qijFXTSAMhn00Mw2FWAyuVi0eGi5OgRcj
         PFVpS1cyPv24M0MTBqOYhzH3GB+rwz66w/4mZC08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Hector Martin <marcan@marcan.st>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 108/239] iommu/io-pgtable-arm: Fix table descriptor paddr formatting
Date:   Mon, 24 Jan 2022 19:42:26 +0100
Message-Id: <20220124183946.539996444@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 9abe2ac834851a7d0b0756e295cf7a292c45ca53 ]

Table descriptors were being installed without properly formatting the
address using paddr_to_iopte, which does not match up with the
iopte_deref in __arm_lpae_map. This is incorrect for the LPAE pte
format, as it does not handle the high bits properly.

This was found on Apple T6000 DARTs, which require a new pte format
(different shift); adding support for that to
paddr_to_iopte/iopte_to_paddr caused it to break badly, as even <48-bit
addresses would end up incorrect in that case.

Fixes: 6c89928ff7a0 ("iommu/io-pgtable-arm: Support 52-bit physical address")
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
Link: https://lore.kernel.org/r/20211120031343.88034-1-marcan@marcan.st
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/io-pgtable-arm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 2f79efd16a052..4bd2dd70acaec 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -346,11 +346,12 @@ static int arm_lpae_init_pte(struct arm_lpae_io_pgtable *data,
 static arm_lpae_iopte arm_lpae_install_table(arm_lpae_iopte *table,
 					     arm_lpae_iopte *ptep,
 					     arm_lpae_iopte curr,
-					     struct io_pgtable_cfg *cfg)
+					     struct arm_lpae_io_pgtable *data)
 {
 	arm_lpae_iopte old, new;
+	struct io_pgtable_cfg *cfg = &data->iop.cfg;
 
-	new = __pa(table) | ARM_LPAE_PTE_TYPE_TABLE;
+	new = paddr_to_iopte(__pa(table), data) | ARM_LPAE_PTE_TYPE_TABLE;
 	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_NS)
 		new |= ARM_LPAE_PTE_NSTABLE;
 
@@ -402,7 +403,7 @@ static int __arm_lpae_map(struct arm_lpae_io_pgtable *data, unsigned long iova,
 		if (!cptep)
 			return -ENOMEM;
 
-		pte = arm_lpae_install_table(cptep, ptep, 0, cfg);
+		pte = arm_lpae_install_table(cptep, ptep, 0, data);
 		if (pte)
 			__arm_lpae_free_pages(cptep, tblsz, cfg);
 	} else if (!(cfg->quirks & IO_PGTABLE_QUIRK_NO_DMA) &&
@@ -562,7 +563,7 @@ static size_t arm_lpae_split_blk_unmap(struct arm_lpae_io_pgtable *data,
 		__arm_lpae_init_pte(data, blk_paddr, pte, lvl, &tablep[i]);
 	}
 
-	pte = arm_lpae_install_table(tablep, ptep, blk_pte, cfg);
+	pte = arm_lpae_install_table(tablep, ptep, blk_pte, data);
 	if (pte != blk_pte) {
 		__arm_lpae_free_pages(tablep, tablesz, cfg);
 		/*
-- 
2.34.1




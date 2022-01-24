Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA3F499B57
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575149AbiAXVvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572919AbiAXVmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:42:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BAAC0419E4;
        Mon, 24 Jan 2022 12:31:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C4F1B8122A;
        Mon, 24 Jan 2022 20:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9AAC340E5;
        Mon, 24 Jan 2022 20:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056291;
        bh=eXld64SAj0/uBme7zFW+YGIPcTAU5bs5ccJa8NjUrcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PFa/bKqaiiTCuV1Nm4uJBgsMe5xpOLNQs90GzjX8Jy8GsA0h25LCb8g5zzKHDHr/U
         QXMdLYBcqVJ+zrM4do8j9IW6nCWl7XTle47NLCqHnrcpfLCfOJXgv5JeEtNioAhDeL
         bntFawLvzwG5XOLC1xlFflBmKb/QpX1gvWl3SMCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Hector Martin <marcan@marcan.st>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 403/846] iommu/io-pgtable-arm: Fix table descriptor paddr formatting
Date:   Mon, 24 Jan 2022 19:38:40 +0100
Message-Id: <20220124184114.869565607@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index dd9e47189d0d9..94ff319ae8acc 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -315,11 +315,12 @@ static int arm_lpae_init_pte(struct arm_lpae_io_pgtable *data,
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
 
@@ -380,7 +381,7 @@ static int __arm_lpae_map(struct arm_lpae_io_pgtable *data, unsigned long iova,
 		if (!cptep)
 			return -ENOMEM;
 
-		pte = arm_lpae_install_table(cptep, ptep, 0, cfg);
+		pte = arm_lpae_install_table(cptep, ptep, 0, data);
 		if (pte)
 			__arm_lpae_free_pages(cptep, tblsz, cfg);
 	} else if (!cfg->coherent_walk && !(pte & ARM_LPAE_PTE_SW_SYNC)) {
@@ -592,7 +593,7 @@ static size_t arm_lpae_split_blk_unmap(struct arm_lpae_io_pgtable *data,
 		__arm_lpae_init_pte(data, blk_paddr, pte, lvl, 1, &tablep[i]);
 	}
 
-	pte = arm_lpae_install_table(tablep, ptep, blk_pte, cfg);
+	pte = arm_lpae_install_table(tablep, ptep, blk_pte, data);
 	if (pte != blk_pte) {
 		__arm_lpae_free_pages(tablep, tablesz, cfg);
 		/*
-- 
2.34.1




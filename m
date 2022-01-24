Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C25D499047
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353122AbiAXT73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:59:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40434 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351647AbiAXTyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:54:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 868ABB810AF;
        Mon, 24 Jan 2022 19:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBF2C340E5;
        Mon, 24 Jan 2022 19:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054050;
        bh=d07dzSUvA2+iSjIdp5m4YqSXELfzyQug44lKx6iS7Tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XrQwhDlvh4mkF6gjGvCAp0rIqH1BhkTCtOHcCocjg0KmOlT90kP68YRkmj4MpF2DF
         Wmv5vnpTjCMQLKaGAtZEOn/lRbnRqgo8V3dqifLbGWiYto8TBRDHtFn37IFMCaLSgP
         TLdewOS4TE1eKbwqA/hphEcq6XHqoz0WoZkjBecI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Hector Martin <marcan@marcan.st>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 263/563] iommu/io-pgtable-arm: Fix table descriptor paddr formatting
Date:   Mon, 24 Jan 2022 19:40:28 +0100
Message-Id: <20220124184033.530803695@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index bcfbd0e44a4a0..e1cd31c0e3c19 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -302,11 +302,12 @@ static int arm_lpae_init_pte(struct arm_lpae_io_pgtable *data,
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
 
@@ -357,7 +358,7 @@ static int __arm_lpae_map(struct arm_lpae_io_pgtable *data, unsigned long iova,
 		if (!cptep)
 			return -ENOMEM;
 
-		pte = arm_lpae_install_table(cptep, ptep, 0, cfg);
+		pte = arm_lpae_install_table(cptep, ptep, 0, data);
 		if (pte)
 			__arm_lpae_free_pages(cptep, tblsz, cfg);
 	} else if (!cfg->coherent_walk && !(pte & ARM_LPAE_PTE_SW_SYNC)) {
@@ -546,7 +547,7 @@ static size_t arm_lpae_split_blk_unmap(struct arm_lpae_io_pgtable *data,
 		__arm_lpae_init_pte(data, blk_paddr, pte, lvl, &tablep[i]);
 	}
 
-	pte = arm_lpae_install_table(tablep, ptep, blk_pte, cfg);
+	pte = arm_lpae_install_table(tablep, ptep, blk_pte, data);
 	if (pte != blk_pte) {
 		__arm_lpae_free_pages(tablep, tablesz, cfg);
 		/*
-- 
2.34.1




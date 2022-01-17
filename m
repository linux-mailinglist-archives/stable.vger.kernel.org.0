Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6062490D2A
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiAQRBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241418AbiAQRA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:00:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B62FC06175E;
        Mon, 17 Jan 2022 09:00:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34438B81148;
        Mon, 17 Jan 2022 17:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A44BC36B01;
        Mon, 17 Jan 2022 17:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438825;
        bh=qYDOpIwbffRx83ZsylOR2lWYM5jvsut86DHKdCbumBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/AFOLhdHjb7Glf7wP/3Tb5Y/cJYHM30CIVOLepO6C6+EHcC2X1SWbTXC1QO9PWQE
         AkcAVSq3I3O7QzGdKwVX9Xdjoshocktg/2+AVipjng5UPp4w1hsYN0r+DnLTiELDua
         U9pTEzLNEQRAQlLRVayt8qtUXQb/Lo5bALuPNc9vVP/fObTP3BMWGJM7Z483+vIpxV
         BMe6q7JDrcw5mhas2d4e6D23R4cYaViJSDWM8ZeTcfgmYhFqVEqK1+Jo6gODk/87HS
         NnL4arR+ecVR+Jbq0LPYFB4mDn3iA/lRfcyQotAi1mwOyHmK/PTtb3vhoTrAOpF0p5
         SzastE5/9ZvHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Jay Chen <jkchen@linux.alibaba.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de
Subject: [PATCH AUTOSEL 5.16 34/52] irqchip/gic-v4: Disable redistributors' view of the VPE table at boot time
Date:   Mon, 17 Jan 2022 11:58:35 -0500
Message-Id: <20220117165853.1470420-34-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 79a7f77b9b154d572bd9d2f1eecf58c4d018d8e2 ]

Jay Chen reported that using a kdump kernel on a GICv4.1 system
results in a RAS error being delivered when the secondary kernel
configures the ITS's view of the new VPE table.

As it turns out, that's because each RD still has a pointer to
the previous instance of the VPE table, and that particular
implementation is very upset by seeing two bits of the HW that
should point to the same table with different values.

To solve this, let's invalidate any reference that any RD has to
the VPE table when discovering the RDs. The ITS can then be
programmed as expected.

Reported-by: Jay Chen <jkchen@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Link: https://lore.kernel.org/r/20211214064716.21407-1-jkchen@linux.alibaba.com
Link: https://lore.kernel.org/r/20211216144804.1578566-1-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index daec3309b014d..86397522e7864 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -920,6 +920,22 @@ static int __gic_update_rdist_properties(struct redist_region *region,
 {
 	u64 typer = gic_read_typer(ptr + GICR_TYPER);
 
+	/* Boot-time cleanip */
+	if ((typer & GICR_TYPER_VLPIS) && (typer & GICR_TYPER_RVPEID)) {
+		u64 val;
+
+		/* Deactivate any present vPE */
+		val = gicr_read_vpendbaser(ptr + SZ_128K + GICR_VPENDBASER);
+		if (val & GICR_VPENDBASER_Valid)
+			gicr_write_vpendbaser(GICR_VPENDBASER_PendingLast,
+					      ptr + SZ_128K + GICR_VPENDBASER);
+
+		/* Mark the VPE table as invalid */
+		val = gicr_read_vpropbaser(ptr + SZ_128K + GICR_VPROPBASER);
+		val &= ~GICR_VPROPBASER_4_1_VALID;
+		gicr_write_vpropbaser(val, ptr + SZ_128K + GICR_VPROPBASER);
+	}
+
 	gic_data.rdists.has_vlpis &= !!(typer & GICR_TYPER_VLPIS);
 
 	/* RVPEID implies some form of DirectLPI, no matter what the doc says... :-/ */
-- 
2.34.1


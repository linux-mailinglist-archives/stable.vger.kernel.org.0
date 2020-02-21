Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 543141677FB
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgBUHvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:51:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729688AbgBUHvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:51:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F8E324653;
        Fri, 21 Feb 2020 07:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271469;
        bh=uGPoaQq5sIQF55e4UpMPnmFtF7DSigxvWVTWul9hHJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTLPKGl/GrOdhnCjSGY7sO2TNg19ZBjJqMA087T9Lier+urJisSuSSnmrV/QLJPfu
         dEV9F/K9F3P9/JE0uG4vgdHueO3cjCXAMDTeW5ZcVwXwuL6ryoeibreJgux8q/rZ9+
         hu1xyNZI95HmD1ghpsslJH6HcAE4psPmOuW53Lh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 178/399] iommu/amd: Check feature support bit before accessing MSI capability registers
Date:   Fri, 21 Feb 2020 08:38:23 +0100
Message-Id: <20200221072420.022833137@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

[ Upstream commit 813071438e83d338ba5cfe98b3b26c890dc0a6c0 ]

The IOMMU MMIO access to MSI capability registers is available only if
the EFR[MsiCapMmioSup] is set. Current implementation assumes this bit
is set if the EFR[XtSup] is set, which might not be the case.

Fix by checking the EFR[MsiCapMmioSup] before accessing the MSI address
low/high and MSI data registers via the MMIO.

Fixes: 66929812955b ('iommu/amd: Add support for X2APIC IOMMU interrupts')
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu_init.c  | 17 ++++++++++++-----
 drivers/iommu/amd_iommu_types.h |  1 +
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 483f7bc379fa8..61628c906ce11 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -147,7 +147,7 @@ bool amd_iommu_dump;
 bool amd_iommu_irq_remap __read_mostly;
 
 int amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_VAPIC;
-static int amd_iommu_xt_mode = IRQ_REMAP_X2APIC_MODE;
+static int amd_iommu_xt_mode = IRQ_REMAP_XAPIC_MODE;
 
 static bool amd_iommu_detected;
 static bool __initdata amd_iommu_disabled;
@@ -1534,8 +1534,15 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 			iommu->mmio_phys_end = MMIO_CNTR_CONF_OFFSET;
 		if (((h->efr_reg & (0x1 << IOMMU_EFR_GASUP_SHIFT)) == 0))
 			amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_LEGACY;
-		if (((h->efr_reg & (0x1 << IOMMU_EFR_XTSUP_SHIFT)) == 0))
-			amd_iommu_xt_mode = IRQ_REMAP_XAPIC_MODE;
+		/*
+		 * Note: Since iommu_update_intcapxt() leverages
+		 * the IOMMU MMIO access to MSI capability block registers
+		 * for MSI address lo/hi/data, we need to check both
+		 * EFR[XtSup] and EFR[MsiCapMmioSup] for x2APIC support.
+		 */
+		if ((h->efr_reg & BIT(IOMMU_EFR_XTSUP_SHIFT)) &&
+		    (h->efr_reg & BIT(IOMMU_EFR_MSICAPMMIOSUP_SHIFT)))
+			amd_iommu_xt_mode = IRQ_REMAP_X2APIC_MODE;
 		break;
 	default:
 		return -EINVAL;
@@ -1996,8 +2003,8 @@ static int iommu_init_intcapxt(struct amd_iommu *iommu)
 	struct irq_affinity_notify *notify = &iommu->intcapxt_notify;
 
 	/**
-	 * IntCapXT requires XTSup=1, which can be inferred
-	 * amd_iommu_xt_mode.
+	 * IntCapXT requires XTSup=1 and MsiCapMmioSup=1,
+	 * which can be inferred from amd_iommu_xt_mode.
 	 */
 	if (amd_iommu_xt_mode != IRQ_REMAP_X2APIC_MODE)
 		return 0;
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index f52f59d5c6bd4..f8a7945f3df90 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -383,6 +383,7 @@
 /* IOMMU Extended Feature Register (EFR) */
 #define IOMMU_EFR_XTSUP_SHIFT	2
 #define IOMMU_EFR_GASUP_SHIFT	7
+#define IOMMU_EFR_MSICAPMMIOSUP_SHIFT	46
 
 #define MAX_DOMAIN_ID 65536
 
-- 
2.20.1




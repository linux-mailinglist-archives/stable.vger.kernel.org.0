Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD5E49A96D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322573AbiAYDWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:22:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36486 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384916AbiAXUax (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:30:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E30D6B8122C;
        Mon, 24 Jan 2022 20:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B569C340E5;
        Mon, 24 Jan 2022 20:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056250;
        bh=fK6DkSfpEookxk1QDIkJ4mjhD5RwifwdmlHDTA/FB7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRJua+Hr5ajqi0H2JSxlJgMXyJ901SABVP+FOei/NJ0u5xxuwNdbICmA5oh3F81vR
         jxL1E0BXL7QGgc+gaE0CdPBiVRbrj65jDgZohD56rKC7utbtg6Uonq8+rMIxLRWt11
         +Lz5Bl/lD1NuI13zevoAL4NkC9wMNqQ7yoloMZJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 421/846] iommu/amd: X2apic mode: setup the INTX registers on mask/unmask
Date:   Mon, 24 Jan 2022 19:38:58 +0100
Message-Id: <20220124184115.507422168@linuxfoundation.org>
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

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 4691f79d62a637958f7b5f55c232a65399500b7a ]

This is more logically correct and will also allow us to
to use mask/unmask logic to restore INTX setttings after
the resume from s3/s4.

Fixes: 66929812955bb ("iommu/amd: Add support for X2APIC IOMMU interrupts")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20211123161038.48009-4-mlevitsk@redhat.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 65 ++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index c1d4e66d2747b..a826de8c99c45 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2012,48 +2012,18 @@ union intcapxt {
 	};
 } __attribute__ ((packed));
 
-/*
- * There isn't really any need to mask/unmask at the irqchip level because
- * the 64-bit INTCAPXT registers can be updated atomically without tearing
- * when the affinity is being updated.
- */
-static void intcapxt_unmask_irq(struct irq_data *data)
-{
-}
-
-static void intcapxt_mask_irq(struct irq_data *data)
-{
-}
 
 static struct irq_chip intcapxt_controller;
 
 static int intcapxt_irqdomain_activate(struct irq_domain *domain,
 				       struct irq_data *irqd, bool reserve)
 {
-	struct amd_iommu *iommu = irqd->chip_data;
-	struct irq_cfg *cfg = irqd_cfg(irqd);
-	union intcapxt xt;
-
-	xt.capxt = 0ULL;
-	xt.dest_mode_logical = apic->dest_mode_logical;
-	xt.vector = cfg->vector;
-	xt.destid_0_23 = cfg->dest_apicid & GENMASK(23, 0);
-	xt.destid_24_31 = cfg->dest_apicid >> 24;
-
-	/**
-	 * Current IOMMU implemtation uses the same IRQ for all
-	 * 3 IOMMU interrupts.
-	 */
-	writeq(xt.capxt, iommu->mmio_base + MMIO_INTCAPXT_EVT_OFFSET);
-	writeq(xt.capxt, iommu->mmio_base + MMIO_INTCAPXT_PPR_OFFSET);
-	writeq(xt.capxt, iommu->mmio_base + MMIO_INTCAPXT_GALOG_OFFSET);
 	return 0;
 }
 
 static void intcapxt_irqdomain_deactivate(struct irq_domain *domain,
 					  struct irq_data *irqd)
 {
-	intcapxt_mask_irq(irqd);
 }
 
 
@@ -2087,6 +2057,38 @@ static void intcapxt_irqdomain_free(struct irq_domain *domain, unsigned int virq
 	irq_domain_free_irqs_top(domain, virq, nr_irqs);
 }
 
+
+static void intcapxt_unmask_irq(struct irq_data *irqd)
+{
+	struct amd_iommu *iommu = irqd->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(irqd);
+	union intcapxt xt;
+
+	xt.capxt = 0ULL;
+	xt.dest_mode_logical = apic->dest_mode_logical;
+	xt.vector = cfg->vector;
+	xt.destid_0_23 = cfg->dest_apicid & GENMASK(23, 0);
+	xt.destid_24_31 = cfg->dest_apicid >> 24;
+
+	/**
+	 * Current IOMMU implementation uses the same IRQ for all
+	 * 3 IOMMU interrupts.
+	 */
+	writeq(xt.capxt, iommu->mmio_base + MMIO_INTCAPXT_EVT_OFFSET);
+	writeq(xt.capxt, iommu->mmio_base + MMIO_INTCAPXT_PPR_OFFSET);
+	writeq(xt.capxt, iommu->mmio_base + MMIO_INTCAPXT_GALOG_OFFSET);
+}
+
+static void intcapxt_mask_irq(struct irq_data *irqd)
+{
+	struct amd_iommu *iommu = irqd->chip_data;
+
+	writeq(0, iommu->mmio_base + MMIO_INTCAPXT_EVT_OFFSET);
+	writeq(0, iommu->mmio_base + MMIO_INTCAPXT_PPR_OFFSET);
+	writeq(0, iommu->mmio_base + MMIO_INTCAPXT_GALOG_OFFSET);
+}
+
+
 static int intcapxt_set_affinity(struct irq_data *irqd,
 				 const struct cpumask *mask, bool force)
 {
@@ -2096,8 +2098,7 @@ static int intcapxt_set_affinity(struct irq_data *irqd,
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	if (ret < 0 || ret == IRQ_SET_MASK_OK_DONE)
 		return ret;
-
-	return intcapxt_irqdomain_activate(irqd->domain, irqd, false);
+	return 0;
 }
 
 static struct irq_chip intcapxt_controller = {
-- 
2.34.1




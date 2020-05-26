Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39971B7531
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgDXMbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727914AbgDXMXS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DBD021473;
        Fri, 24 Apr 2020 12:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587730997;
        bh=lyI0+Mu1PRAf/o+M/pK5/AH1tWLKUVIyPjv3SlZ48XA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlAz3TggemoEVysZxYgXExrAc4YwXX5nQwdMZ/YHj6CvCY6tZGZOIpsPpQL8jXaMF
         P+8o1jJf3NbkLUkfVNHlRJXWrUtm6bYBgkmZLlKi3WCkAxhM9Q2dFtFG0bIbciD+5Z
         0356ZMMbD0HX3HsrWZHqtTV+JtiMkYH+41RMZl94=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 35/38] irqchip/gic-v4.1: Add support for VPENDBASER's Dirty+Valid signaling
Date:   Fri, 24 Apr 2020 08:22:33 -0400
Message-Id: <20200424122237.9831-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122237.9831-1-sashal@kernel.org>
References: <20200424122237.9831-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 96806229ca033f85310bc5c203410189f8a1d2ee ]

When a vPE is made resident, the GIC starts parsing the virtual pending
table to deliver pending interrupts. This takes place asynchronously,
and can at times take a long while. Long enough that the vcpu enters
the guest and hits WFI before any interrupt has been signaled yet.
The vcpu then exits, blocks, and now gets a doorbell. Rince, repeat.

In order to avoid the above, a (optional on GICv4, mandatory on v4.1)
feature allows the GIC to feedback to the hypervisor whether it is
done parsing the VPT by clearing the GICR_VPENDBASER.Dirty bit.
The hypervisor can then wait until the GIC is ready before actually
running the vPE.

Plug the detection code as well as polling on vPE schedule. While
at it, tidy-up the kernel message that displays the GICv4 optional
features.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 19 +++++++++++++++++++
 drivers/irqchip/irq-gic-v3.c       | 11 +++++++----
 include/linux/irqchip/arm-gic-v3.h |  2 ++
 3 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 7c8f65c9c32de..381513e053029 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -14,6 +14,7 @@
 #include <linux/dma-iommu.h>
 #include <linux/efi.h>
 #include <linux/interrupt.h>
+#include <linux/iopoll.h>
 #include <linux/irqdomain.h>
 #include <linux/list.h>
 #include <linux/log2.h>
@@ -3516,6 +3517,20 @@ static int its_vpe_set_affinity(struct irq_data *d,
 	return IRQ_SET_MASK_OK_DONE;
 }
 
+static void its_wait_vpt_parse_complete(void)
+{
+	void __iomem *vlpi_base = gic_data_rdist_vlpi_base();
+	u64 val;
+
+	if (!gic_rdists->has_vpend_valid_dirty)
+		return;
+
+	WARN_ON_ONCE(readq_relaxed_poll_timeout(vlpi_base + GICR_VPENDBASER,
+						val,
+						!(val & GICR_VPENDBASER_Dirty),
+						10, 500));
+}
+
 static void its_vpe_schedule(struct its_vpe *vpe)
 {
 	void __iomem *vlpi_base = gic_data_rdist_vlpi_base();
@@ -3546,6 +3561,8 @@ static void its_vpe_schedule(struct its_vpe *vpe)
 	val |= vpe->idai ? GICR_VPENDBASER_IDAI : 0;
 	val |= GICR_VPENDBASER_Valid;
 	gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
+
+	its_wait_vpt_parse_complete();
 }
 
 static void its_vpe_deschedule(struct its_vpe *vpe)
@@ -3752,6 +3769,8 @@ static void its_vpe_4_1_schedule(struct its_vpe *vpe,
 	val |= FIELD_PREP(GICR_VPENDBASER_4_1_VPEID, vpe->vpe_id);
 
 	gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
+
+	its_wait_vpt_parse_complete();
 }
 
 static void its_vpe_4_1_deschedule(struct its_vpe *vpe,
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 1eec9d4649d51..71a84f9c56965 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -866,6 +866,7 @@ static int __gic_update_rdist_properties(struct redist_region *region,
 	gic_data.rdists.has_rvpeid &= !!(typer & GICR_TYPER_RVPEID);
 	gic_data.rdists.has_direct_lpi &= (!!(typer & GICR_TYPER_DirectLPIS) |
 					   gic_data.rdists.has_rvpeid);
+	gic_data.rdists.has_vpend_valid_dirty &= !!(typer & GICR_TYPER_DIRTY);
 
 	/* Detect non-sensical configurations */
 	if (WARN_ON_ONCE(gic_data.rdists.has_rvpeid && !gic_data.rdists.has_vlpis)) {
@@ -886,10 +887,11 @@ static void gic_update_rdist_properties(void)
 	if (WARN_ON(gic_data.ppi_nr == UINT_MAX))
 		gic_data.ppi_nr = 0;
 	pr_info("%d PPIs implemented\n", gic_data.ppi_nr);
-	pr_info("%sVLPI support, %sdirect LPI support, %sRVPEID support\n",
-		!gic_data.rdists.has_vlpis ? "no " : "",
-		!gic_data.rdists.has_direct_lpi ? "no " : "",
-		!gic_data.rdists.has_rvpeid ? "no " : "");
+	if (gic_data.rdists.has_vlpis)
+		pr_info("GICv4 features: %s%s%s\n",
+			gic_data.rdists.has_direct_lpi ? "DirectLPI " : "",
+			gic_data.rdists.has_rvpeid ? "RVPEID " : "",
+			gic_data.rdists.has_vpend_valid_dirty ? "Valid+Dirty " : "");
 }
 
 /* Check whether it's single security state view */
@@ -1614,6 +1616,7 @@ static int __init gic_init_bases(void __iomem *dist_base,
 	gic_data.rdists.has_rvpeid = true;
 	gic_data.rdists.has_vlpis = true;
 	gic_data.rdists.has_direct_lpi = true;
+	gic_data.rdists.has_vpend_valid_dirty = true;
 
 	if (WARN_ON(!gic_data.domain) || WARN_ON(!gic_data.rdists.rdist)) {
 		err = -ENOMEM;
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 83439bfb6c5b0..7613a84a2466b 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -241,6 +241,7 @@
 
 #define GICR_TYPER_PLPIS		(1U << 0)
 #define GICR_TYPER_VLPIS		(1U << 1)
+#define GICR_TYPER_DIRTY		(1U << 2)
 #define GICR_TYPER_DirectLPIS		(1U << 3)
 #define GICR_TYPER_LAST			(1U << 4)
 #define GICR_TYPER_RVPEID		(1U << 7)
@@ -665,6 +666,7 @@ struct rdists {
 	bool			has_vlpis;
 	bool			has_rvpeid;
 	bool			has_direct_lpi;
+	bool			has_vpend_valid_dirty;
 };
 
 struct irq_domain;
-- 
2.20.1


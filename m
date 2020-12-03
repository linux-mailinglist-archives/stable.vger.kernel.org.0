Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779072CD750
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 14:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389166AbgLCNdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 08:33:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:48820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436894AbgLCNbL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 08:31:11 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xu Qiang <xuqiang36@huawei.com>, Marc Zyngier <maz@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 09/14] irqchip/gic-v3-its: Unconditionally save/restore the ITS state on suspend
Date:   Thu,  3 Dec 2020 08:30:05 -0500
Message-Id: <20201203133010.931600-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203133010.931600-1-sashal@kernel.org>
References: <20201203133010.931600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Qiang <xuqiang36@huawei.com>

[ Upstream commit 74cde1a53368aed4f2b4b54bf7030437f64a534b ]

On systems without HW-based collections (i.e. anything except GIC-500),
we rely on firmware to perform the ITS save/restore. This doesn't
really work, as although FW can properly save everything, it cannot
fully restore the state of the command queue (the read-side is reset
to the head of the queue). This results in the ITS consuming previously
processed commands, potentially corrupting the state.

Instead, let's always save the ITS state on suspend, disabling it in the
process, and restore the full state on resume. This saves us from broken
FW as long as it doesn't enable the ITS by itself (for which we can't do
anything).

This amounts to simply dropping the ITS_FLAGS_SAVE_SUSPEND_STATE.

Signed-off-by: Xu Qiang <xuqiang36@huawei.com>
[maz: added warning on resume, rewrote commit message]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201107104226.14282-1-xuqiang36@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index d5cc32e80f5e2..cd58c123f547e 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -49,7 +49,6 @@
 #define ITS_FLAGS_CMDQ_NEEDS_FLUSHING		(1ULL << 0)
 #define ITS_FLAGS_WORKAROUND_CAVIUM_22375	(1ULL << 1)
 #define ITS_FLAGS_WORKAROUND_CAVIUM_23144	(1ULL << 2)
-#define ITS_FLAGS_SAVE_SUSPEND_STATE		(1ULL << 3)
 
 #define RDIST_FLAGS_PROPBASE_NEEDS_FLUSHING	(1 << 0)
 
@@ -3240,9 +3239,6 @@ static int its_save_disable(void)
 	list_for_each_entry(its, &its_nodes, entry) {
 		void __iomem *base;
 
-		if (!(its->flags & ITS_FLAGS_SAVE_SUSPEND_STATE))
-			continue;
-
 		base = its->base;
 		its->ctlr_save = readl_relaxed(base + GITS_CTLR);
 		err = its_force_quiescent(base);
@@ -3261,9 +3257,6 @@ static int its_save_disable(void)
 		list_for_each_entry_continue_reverse(its, &its_nodes, entry) {
 			void __iomem *base;
 
-			if (!(its->flags & ITS_FLAGS_SAVE_SUSPEND_STATE))
-				continue;
-
 			base = its->base;
 			writel_relaxed(its->ctlr_save, base + GITS_CTLR);
 		}
@@ -3283,9 +3276,6 @@ static void its_restore_enable(void)
 		void __iomem *base;
 		int i;
 
-		if (!(its->flags & ITS_FLAGS_SAVE_SUSPEND_STATE))
-			continue;
-
 		base = its->base;
 
 		/*
@@ -3293,7 +3283,10 @@ static void its_restore_enable(void)
 		 * don't restore it since writing to CBASER or BASER<n>
 		 * registers is undefined according to the GIC v3 ITS
 		 * Specification.
+		 *
+		 * Firmware resuming with the ITS enabled is terminally broken.
 		 */
+		WARN_ON(readl_relaxed(base + GITS_CTLR) & GITS_CTLR_ENABLE);
 		ret = its_force_quiescent(base);
 		if (ret) {
 			pr_err("ITS@%pa: failed to quiesce on resume: %d\n",
@@ -3558,9 +3551,6 @@ static int __init its_probe_one(struct resource *res,
 		ctlr |= GITS_CTLR_ImDe;
 	writel_relaxed(ctlr, its->base + GITS_CTLR);
 
-	if (GITS_TYPER_HCC(typer))
-		its->flags |= ITS_FLAGS_SAVE_SUSPEND_STATE;
-
 	err = its_init_domain(handle, its);
 	if (err)
 		goto out_free_tables;
-- 
2.27.0


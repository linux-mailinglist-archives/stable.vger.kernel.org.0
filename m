Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD53309463
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 11:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhA3KWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 05:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbhA3A1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 19:27:06 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEE0C061573;
        Fri, 29 Jan 2021 16:25:51 -0800 (PST)
Date:   Sat, 30 Jan 2021 00:25:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611966346;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+O2w7S5EIr+xgRrn3lyGkiuObLVFWzLYI3jLm0zSy/U=;
        b=ja8CJybGquWcD7wxc/usJyM56b3UFxypqDDDtDspDxVrMoVoYvlT5Q0s7At0cqXOM3roEP
        R3Rl/+CUltc1hsSR7kfK06bfQEkjriHOkot/CEr5Y3SH+dG5QIPU06cy4TEXHycMX99Sf4
        Jjc/Z+u2BAx/gn1nfjZouSA779XKP/rbST2724j7U8jgwUzmudwcmpdpIr3MWIBZ88zyb0
        9aKO65qBI+JQeyshoA9+3AEEPQnszDykyifcWOS0qIvzb2uFfCkvx5pgH4+6Hg93rXGZv5
        3OmkwTcES8xRF2+3FvDx6fZJAJ2X/HfRTChoWhXTjW/pLzxRU9sHr+8VICahCg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611966346;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+O2w7S5EIr+xgRrn3lyGkiuObLVFWzLYI3jLm0zSy/U=;
        b=MRBubB14FDQzEGB0tTRGQtmEY00BfkciJEEtiWpfLIpBuQm87AJOg+c8d5+4nbzsCAU8qc
        m7rtiZT71xnxkXDw==
From:   "tip-bot2 for Marc Zyngier" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] genirq/msi: Activate Multi-MSI early when
 MSI_FLAG_ACTIVATE_EARLY is set
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210123122759.1781359-1-maz@kernel.org>
References: <20210123122759.1781359-1-maz@kernel.org>
MIME-Version: 1.0
Message-ID: <161196634552.23325.925660465209901325.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     4c457e8cb75eda91906a4f89fc39bde3f9a43922
Gitweb:        https://git.kernel.org/tip/4c457e8cb75eda91906a4f89fc39bde3f9a43922
Author:        Marc Zyngier <maz@kernel.org>
AuthorDate:    Sat, 23 Jan 2021 12:27:59 
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Sat, 30 Jan 2021 01:22:31 +01:00

genirq/msi: Activate Multi-MSI early when MSI_FLAG_ACTIVATE_EARLY is set

When MSI_FLAG_ACTIVATE_EARLY is set (which is the case for PCI),
__msi_domain_alloc_irqs() performs the activation of the interrupt (which
in the case of PCI results in the endpoint being programmed) as soon as the
interrupt is allocated.

But it appears that this is only done for the first vector, introducing an
inconsistent behaviour for PCI Multi-MSI.

Fix it by iterating over the number of vectors allocated to each MSI
descriptor. This is easily achieved by introducing a new
"for_each_msi_vector" iterator, together with a tiny bit of refactoring.

Fixes: f3b0946d629c ("genirq/msi: Make sure PCI MSIs are activated early")
Reported-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210123122759.1781359-1-maz@kernel.org

---
 include/linux/msi.h |  6 ++++++-
 kernel/irq/msi.c    | 44 ++++++++++++++++++++------------------------
 2 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index 360a0a7..aef35fd 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -178,6 +178,12 @@ struct msi_desc {
 	list_for_each_entry((desc), dev_to_msi_list((dev)), list)
 #define for_each_msi_entry_safe(desc, tmp, dev)	\
 	list_for_each_entry_safe((desc), (tmp), dev_to_msi_list((dev)), list)
+#define for_each_msi_vector(desc, __irq, dev)				\
+	for_each_msi_entry((desc), (dev))				\
+		if ((desc)->irq)					\
+			for (__irq = (desc)->irq;			\
+			     __irq < ((desc)->irq + (desc)->nvec_used);	\
+			     __irq++)
 
 #ifdef CONFIG_IRQ_MSI_IOMMU
 static inline const void *msi_desc_get_iommu_cookie(struct msi_desc *desc)
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index dc0e2d7..b338d62 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -436,22 +436,22 @@ int __msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 
 	can_reserve = msi_check_reservation_mode(domain, info, dev);
 
-	for_each_msi_entry(desc, dev) {
-		virq = desc->irq;
-		if (desc->nvec_used == 1)
-			dev_dbg(dev, "irq %d for MSI\n", virq);
-		else
+	/*
+	 * This flag is set by the PCI layer as we need to activate
+	 * the MSI entries before the PCI layer enables MSI in the
+	 * card. Otherwise the card latches a random msi message.
+	 */
+	if (!(info->flags & MSI_FLAG_ACTIVATE_EARLY))
+		goto skip_activate;
+
+	for_each_msi_vector(desc, i, dev) {
+		if (desc->irq == i) {
+			virq = desc->irq;
 			dev_dbg(dev, "irq [%d-%d] for MSI\n",
 				virq, virq + desc->nvec_used - 1);
-		/*
-		 * This flag is set by the PCI layer as we need to activate
-		 * the MSI entries before the PCI layer enables MSI in the
-		 * card. Otherwise the card latches a random msi message.
-		 */
-		if (!(info->flags & MSI_FLAG_ACTIVATE_EARLY))
-			continue;
+		}
 
-		irq_data = irq_domain_get_irq_data(domain, desc->irq);
+		irq_data = irq_domain_get_irq_data(domain, i);
 		if (!can_reserve) {
 			irqd_clr_can_reserve(irq_data);
 			if (domain->flags & IRQ_DOMAIN_MSI_NOMASK_QUIRK)
@@ -462,28 +462,24 @@ int __msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 			goto cleanup;
 	}
 
+skip_activate:
 	/*
 	 * If these interrupts use reservation mode, clear the activated bit
 	 * so request_irq() will assign the final vector.
 	 */
 	if (can_reserve) {
-		for_each_msi_entry(desc, dev) {
-			irq_data = irq_domain_get_irq_data(domain, desc->irq);
+		for_each_msi_vector(desc, i, dev) {
+			irq_data = irq_domain_get_irq_data(domain, i);
 			irqd_clr_activated(irq_data);
 		}
 	}
 	return 0;
 
 cleanup:
-	for_each_msi_entry(desc, dev) {
-		struct irq_data *irqd;
-
-		if (desc->irq == virq)
-			break;
-
-		irqd = irq_domain_get_irq_data(domain, desc->irq);
-		if (irqd_is_activated(irqd))
-			irq_domain_deactivate_irq(irqd);
+	for_each_msi_vector(desc, i, dev) {
+		irq_data = irq_domain_get_irq_data(domain, i);
+		if (irqd_is_activated(irq_data))
+			irq_domain_deactivate_irq(irq_data);
 	}
 	msi_domain_free_irqs(domain, dev);
 	return ret;

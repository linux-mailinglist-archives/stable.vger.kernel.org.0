Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63A43137F1
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhBHPdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:33:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233044AbhBHP3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:29:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C371064F30;
        Mon,  8 Feb 2021 15:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797408;
        bh=nKEKEMpkRM4NdzLi1m2M6eBfvwlq3zXdHAI6at0QUSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJxQgWSk3s6atOgjGPiQFysABFoglYfS6DcoGkv1svwhEg3rIbV3j4GpkPtQ+6OdB
         AlEg0KqdazN+svkjktC9Vnz7JQNOgqmzz+Mq8F/347WTBZTKiFIbQ0LTEFVKq73Irh
         Bw/IYdrlyzZXoq9z3NRdAR+grBGlJb5NMnwC/3i0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 067/120] genirq/msi: Activate Multi-MSI early when MSI_FLAG_ACTIVATE_EARLY is set
Date:   Mon,  8 Feb 2021 16:00:54 +0100
Message-Id: <20210208145821.086356658@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 4c457e8cb75eda91906a4f89fc39bde3f9a43922 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/msi.h |    6 ++++++
 kernel/irq/msi.c    |   44 ++++++++++++++++++++------------------------
 2 files changed, 26 insertions(+), 24 deletions(-)

--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -139,6 +139,12 @@ struct msi_desc {
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
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -436,22 +436,22 @@ int __msi_domain_alloc_irqs(struct irq_d
 
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
@@ -462,28 +462,24 @@ int __msi_domain_alloc_irqs(struct irq_d
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



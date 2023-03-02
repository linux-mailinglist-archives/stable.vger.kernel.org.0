Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D40B6A87C9
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 18:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjCBRWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 12:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCBRWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 12:22:24 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CF26E8B;
        Thu,  2 Mar 2023 09:22:23 -0800 (PST)
Date:   Thu, 02 Mar 2023 17:22:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677777741;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rZUI0Dp1XgfC+LUatB+59tfCAoLSvynVlofrlVu+tNI=;
        b=lncaqsIrMNsB/08yz8YPUB+RSess4cdNNeDmCfvGOZP3pVxaYGFe0q+5uXXHuR++bsU4zR
        jg+v7vk71GKO/Y13gVk9xU3s7TfzPC2Cqww5eo7o0ECzMM9pln8qsqcv23oZ7/EEEXkYTL
        2qY6AEunP1SgJka+TuVHjDzG/FnLwjMITkHKXfEjqeoW57/fV1Zh68cnyo3mXpRaWBHaMq
        G41b6EHT7H1wghlL79E+Tpd3v2z130vzmT14iLnGPLTKzjoijOzNN7k1Cn+Fi0HCo8O+eH
        DPXS0uGnzL4/d1VJZSinWrjG31fzIUvvYMIKcQYuFfGoUvVhGEml9HOyykiq9g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677777741;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rZUI0Dp1XgfC+LUatB+59tfCAoLSvynVlofrlVu+tNI=;
        b=IJhnM0bvuDtH3jMNeIDH8L+Acw3hVeQg+54WEZwkEvojSKUkCzJ3MsvsXju/KAvXYX1FnX
        k9q6i5OZFNy0bQDw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] genirq/msi, platform-msi: Ensure that MSI
 descriptors are unreferenced
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org
In-Reply-To: <87mt4wkwnv.ffs@tglx>
References: <87mt4wkwnv.ffs@tglx>
MIME-Version: 1.0
Message-ID: <167777774038.5837.12233642737394455533.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     0fb7fb713461e44b12e72c292bf90ee300f40710
Gitweb:        https://git.kernel.org/tip/0fb7fb713461e44b12e72c292bf90ee300f40710
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Wed, 01 Mar 2023 22:07:48 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 02 Mar 2023 18:09:44 +01:00

genirq/msi, platform-msi: Ensure that MSI descriptors are unreferenced

Miquel reported a warning in the MSI core which is triggered when
interrupts are freed via platform_msi_device_domain_free().

This code got reworked to use core functions for freeing the MSI
descriptors, but nothing took care to clear the msi_desc->irq entry, which
then triggers the warning in msi_free_msi_desc() which uses desc->irq to
validate that the descriptor has been torn down. The same issue exists in
msi_domain_populate_irqs().

Up to the point that msi_free_msi_descs() grew a warning for this case,
this went un-noticed.

Provide the counterpart of msi_domain_populate_irqs() and invoke it in
platform_msi_device_domain_free() before freeing the interrupts and MSI
descriptors and also in the error path of msi_domain_populate_irqs().

Fixes: 2f2940d16823 ("genirq/msi: Remove filter from msi_free_descs_free_range()")
Reported-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87mt4wkwnv.ffs@tglx
---
 drivers/base/platform-msi.c |  1 +
 include/linux/msi.h         |  2 ++
 kernel/irq/msi.c            | 23 ++++++++++++++++++++++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
index 5883e76..f37ad34 100644
--- a/drivers/base/platform-msi.c
+++ b/drivers/base/platform-msi.c
@@ -324,6 +324,7 @@ void platform_msi_device_domain_free(struct irq_domain *domain, unsigned int vir
 	struct platform_msi_priv_data *data = domain->host_data;
 
 	msi_lock_descs(data->dev);
+	msi_domain_depopulate_descs(data->dev, virq, nr_irqs);
 	irq_domain_free_irqs_common(domain, virq, nr_irqs);
 	msi_free_msi_descs_range(data->dev, virq, virq + nr_irqs - 1);
 	msi_unlock_descs(data->dev);
diff --git a/include/linux/msi.h b/include/linux/msi.h
index a112b91..15dd718 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -631,6 +631,8 @@ int msi_domain_prepare_irqs(struct irq_domain *domain, struct device *dev,
 			    int nvec, msi_alloc_info_t *args);
 int msi_domain_populate_irqs(struct irq_domain *domain, struct device *dev,
 			     int virq, int nvec, msi_alloc_info_t *args);
+void msi_domain_depopulate_descs(struct device *dev, int virq, int nvec);
+
 struct irq_domain *
 __platform_msi_create_device_domain(struct device *dev,
 				    unsigned int nvec,
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index efd21b7..d169ee0 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -1109,14 +1109,35 @@ int msi_domain_populate_irqs(struct irq_domain *domain, struct device *dev,
 	return 0;
 
 fail:
-	for (--virq; virq >= virq_base; virq--)
+	for (--virq; virq >= virq_base; virq--) {
+		msi_domain_depopulate_descs(dev, virq, 1);
 		irq_domain_free_irqs_common(domain, virq, 1);
+	}
 	msi_domain_free_descs(dev, &ctrl);
 unlock:
 	msi_unlock_descs(dev);
 	return ret;
 }
 
+void msi_domain_depopulate_descs(struct device *dev, int virq_base, int nvec)
+{
+	struct msi_ctrl ctrl = {
+		.domid	= MSI_DEFAULT_DOMAIN,
+		.first  = virq_base,
+		.last	= virq_base + nvec - 1,
+	};
+	struct msi_desc *desc;
+	struct xarray *xa;
+	unsigned long idx;
+
+	if (!msi_ctrl_valid(dev, &ctrl))
+		return;
+
+	xa = &dev->msi.data->__domains[ctrl.domid].store;
+	xa_for_each_range(xa, idx, desc, ctrl.first, ctrl.last)
+		desc->irq = 0;
+}
+
 /*
  * Carefully check whether the device can use reservation mode. If
  * reservation mode is enabled then the early activation will assign a

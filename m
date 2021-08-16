Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4476A3ECFE6
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 10:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbhHPIFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 04:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234619AbhHPIFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 04:05:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EF2361AEF;
        Mon, 16 Aug 2021 08:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629101070;
        bh=vJ0s310t5SOA2KarEyw8RqNxqxeNc4nm9IKZLimt4ZQ=;
        h=Subject:To:Cc:From:Date:From;
        b=b+9i7+IA0rB55nRN1y7WpmFU7EV0/sGUc4d6pmpgQs5pQRoEkSNGjFKvcYPy6Sspd
         inpNhC/B8psMhLn6zM/a9DTLMEIP4UssTk0lOJaqCHvp89kcmn4pWSxhXx2ZLM5tn9
         ZHZJt9LzCvqjcmQz2SXtttc5EwJMIUsNQ6/eSo5w=
Subject: FAILED: patch "[PATCH] genirq/msi: Ensure deactivation on teardown" failed to apply to 4.4-stable tree
To:     cuibixuan@huawei.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Aug 2021 10:04:28 +0200
Message-ID: <1629101068175190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dbbc93576e03fbe24b365fab0e901eb442237a8a Mon Sep 17 00:00:00 2001
From: Bixuan Cui <cuibixuan@huawei.com>
Date: Tue, 18 May 2021 11:31:17 +0800
Subject: [PATCH] genirq/msi: Ensure deactivation on teardown

msi_domain_alloc_irqs() invokes irq_domain_activate_irq(), but
msi_domain_free_irqs() does not enforce deactivation before tearing down
the interrupts.

This happens when PCI/MSI interrupts are set up and never used before being
torn down again, e.g. in error handling pathes. The only place which cleans
that up is the error handling path in msi_domain_alloc_irqs().

Move the cleanup from msi_domain_alloc_irqs() into msi_domain_free_irqs()
to cure that.

Fixes: f3b0946d629c ("genirq/msi: Make sure PCI MSIs are activated early")
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210518033117.78104-1-cuibixuan@huawei.com

diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index c41965e348b5..85df3ca03efe 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -476,11 +476,6 @@ int __msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 	return 0;
 
 cleanup:
-	for_each_msi_vector(desc, i, dev) {
-		irq_data = irq_domain_get_irq_data(domain, i);
-		if (irqd_is_activated(irq_data))
-			irq_domain_deactivate_irq(irq_data);
-	}
 	msi_domain_free_irqs(domain, dev);
 	return ret;
 }
@@ -505,7 +500,15 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 
 void __msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
 {
+	struct irq_data *irq_data;
 	struct msi_desc *desc;
+	int i;
+
+	for_each_msi_vector(desc, i, dev) {
+		irq_data = irq_domain_get_irq_data(domain, i);
+		if (irqd_is_activated(irq_data))
+			irq_domain_deactivate_irq(irq_data);
+	}
 
 	for_each_msi_entry(desc, dev) {
 		/*


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DED3E5C69
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 15:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhHJOAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhHJOAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 10:00:08 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898ECC0A887F;
        Tue, 10 Aug 2021 06:59:46 -0700 (PDT)
Date:   Tue, 10 Aug 2021 13:59:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628603982;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+kgB85hbwoSGFaz51vxFO2dKhNt4cSN8a7gmxkX1+HU=;
        b=lwDxD4c2ZqWR3W+o6GdEI4aAsdQsHrVbF1Nwk8KKwyJjrDgrbqF9oxDux+788XYhCHaRXh
        dJHN04IPmx57IuuZcHsUaQoiulFEGwjElNCUB18qSvG/5OsgmN+PckqQwq4hgD1GYnP58i
        Qreba5h21H1qYZ6jHVPj5acCx36euFayqHX0DbzdooM0TI5vxfF56ppucNjBfyJt8knzyZ
        5n68iv77O8GI7Y4Q2eLaNyISIVQFp5Kl7VUTxgFuA+/LlX5TPnL+lR7TPddIzFQzni/1bU
        qQZHFuoyHCDKni908qD7iKCgeBl6ahVCP5pyGvI8+Q49PNZW9Gmm2gOzvWGVog==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628603982;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+kgB85hbwoSGFaz51vxFO2dKhNt4cSN8a7gmxkX1+HU=;
        b=DvPNOhw3BwIW2tUV9PcHn/2v3/U6RsXlOxCN6s+dJFBmqd7kFskyNXeaDWeGIYs6DFwTmW
        9uTqD3NAaDhptSAw==
From:   "tip-bot2 for Bixuan Cui" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] genirq/msi: Ensure deactivation on teardown
Cc:     Bixuan Cui <cuibixuan@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org
In-Reply-To: <20210518033117.78104-1-cuibixuan@huawei.com>
References: <20210518033117.78104-1-cuibixuan@huawei.com>
MIME-Version: 1.0
Message-ID: <162860398138.395.5636562018420787103.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     dbbc93576e03fbe24b365fab0e901eb442237a8a
Gitweb:        https://git.kernel.org/tip/dbbc93576e03fbe24b365fab0e901eb442237a8a
Author:        Bixuan Cui <cuibixuan@huawei.com>
AuthorDate:    Tue, 18 May 2021 11:31:17 +08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 10 Aug 2021 15:55:19 +02:00

genirq/msi: Ensure deactivation on teardown

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

---
 kernel/irq/msi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index c41965e..85df3ca 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -476,11 +476,6 @@ skip_activate:
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

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099B4242740
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 11:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgHLJNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 05:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbgHLJNd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 05:13:33 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F13AC06174A;
        Wed, 12 Aug 2020 02:13:33 -0700 (PDT)
Date:   Wed, 12 Aug 2020 09:13:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597223610;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YtQguOBpLy+ZK3wfcPbucBpUN9YGIesOWZl+59cOgmA=;
        b=XDYJH3L/fJTg0uZURUWOUU+FVEp4y9Q5horXSNMatMdefHd1jv+UgT8Le2M/w/RfOP9MSJ
        SI1rfnZJTuHqhu5fIU4MXl2rOgPuwrqj2g9V7BcODpkjuC6lYhX2mgMO2XujCjMJBzV3WZ
        wOhRNZ0i7aqJMhdrZ9PO5UXsTxvaMQDmd9E71ytH6nTqRSYbFlXctNMYfPlw44HsxA37YQ
        b1YZXQwb9RNZidSjbQ2t/onmpxzv8YxhawVjc8nrm/n2elte8y1UR7JK2rF4vjb//chuDJ
        cacpm0uABDmad0SoVanJHuYST8qezvU621x3Ge+jZ7USxpOq+jGxD4y3aNUFNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597223610;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YtQguOBpLy+ZK3wfcPbucBpUN9YGIesOWZl+59cOgmA=;
        b=AyPrIXC4Sk8jefmqeGtnO19FKendAy/6eDAGN/BqMdNGtcNNVfBVkUiiP2Lia3qO3Xustq
        7Sa1+e0IWXKs6MDA==
From:   "tip-bot2 for Guenter Roeck" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] genirq/PM: Always unlock IRQ descriptor in rearm_wake_irq()
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200811180001.80203-1-linux@roeck-us.net>
References: <20200811180001.80203-1-linux@roeck-us.net>
MIME-Version: 1.0
Message-ID: <159722360956.3192.16144465573431608980.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     e27b1636e9337d1a1d174b191e53d0f86421a822
Gitweb:        https://git.kernel.org/tip/e27b1636e9337d1a1d174b191e53d0f86421a822
Author:        Guenter Roeck <linux@roeck-us.net>
AuthorDate:    Tue, 11 Aug 2020 11:00:01 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 12 Aug 2020 11:04:05 +02:00

genirq/PM: Always unlock IRQ descriptor in rearm_wake_irq()

rearm_wake_irq() does not unlock the irq descriptor if the interrupt
is not suspended or if wakeup is not enabled on it.

Restucture the exit conditions so the unlock is always ensured.

Fixes: 3a79bc63d9075 ("PCI: irq: Introduce rearm_wake_irq()")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200811180001.80203-1-linux@roeck-us.net

---
 kernel/irq/pm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 8f557fa..c6c7e18 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -185,14 +185,18 @@ void rearm_wake_irq(unsigned int irq)
 	unsigned long flags;
 	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
 
-	if (!desc || !(desc->istate & IRQS_SUSPENDED) ||
-	    !irqd_is_wakeup_set(&desc->irq_data))
+	if (!desc)
 		return;
 
+	if (!(desc->istate & IRQS_SUSPENDED) ||
+	    !irqd_is_wakeup_set(&desc->irq_data))
+		goto unlock;
+
 	desc->istate &= ~IRQS_SUSPENDED;
 	irqd_set(&desc->irq_data, IRQD_WAKEUP_ARMED);
 	__enable_irq(desc);
 
+unlock:
 	irq_put_desc_busunlock(desc, flags);
 }
 

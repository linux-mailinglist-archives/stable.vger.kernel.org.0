Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE7724B230
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgHTJZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727012AbgHTJYr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:24:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFDED22CB2;
        Thu, 20 Aug 2020 09:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915487;
        bh=9wY0bvHnP823z5bTKju7vuT8yhn2NEW7Ay9LUlzPZQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xtf+QhCVAV5fezBQecZMjExnYqdz6T2hesFw+BWbMIFzALlSkYuFExWdWck5RcmZe
         +zyTujgN/phdClKqyYv0ZLoYaJBTUroMLNtRGekJhlsxyvpxWVOwUbNJmyEUsOypXp
         bp/nsWZhE2djhzKxPaVBVShCqY/RbMCq0QRy6kE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.8 006/232] genirq/PM: Always unlock IRQ descriptor in rearm_wake_irq()
Date:   Thu, 20 Aug 2020 11:17:37 +0200
Message-Id: <20200820091613.009974772@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit e27b1636e9337d1a1d174b191e53d0f86421a822 upstream.

rearm_wake_irq() does not unlock the irq descriptor if the interrupt
is not suspended or if wakeup is not enabled on it.

Restucture the exit conditions so the unlock is always ensured.

Fixes: 3a79bc63d9075 ("PCI: irq: Introduce rearm_wake_irq()")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200811180001.80203-1-linux@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/pm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

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
 



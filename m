Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54CA24B50A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbgHTKQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:16:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728737AbgHTKQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:16:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE0A020658;
        Thu, 20 Aug 2020 10:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918612;
        bh=tIzoCSSLRjt/w8J6hFho8GNxLkMCM5XbRXm84eMaaeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJ4e3MItFu35AoG6AK3JdeWfIXREpuR8vJufPXjytZSmEGOBHk2ZceJ8hvtHcF3HU
         vg0csJ5zuPRlIGx2tMc3eLA80rpiEIYwXvm4EZLjbfGJyYjdIUA03TPDcX5r8wmi4I
         P6evo7ca+zhLrydc8xb/yfUA9UrXn6hjdW3UGVX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ali Saidi <alisaidi@amazon.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 4.14 222/228] genirq/affinity: Handle affinity setting on inactive interrupts correctly
Date:   Thu, 20 Aug 2020 11:23:17 +0200
Message-Id: <20200820091618.608293206@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit baedb87d1b53532f81b4bd0387f83b05d4f7eb9a upstream.

Setting interrupt affinity on inactive interrupts is inconsistent when
hierarchical irq domains are enabled. The core code should just store the
affinity and not call into the irq chip driver for inactive interrupts
because the chip drivers may not be in a state to handle such requests.

X86 has a hacky workaround for that but all other irq chips have not which
causes problems e.g. on GIC V3 ITS.

Instead of adding more ugly hacks all over the place, solve the problem in
the core code. If the affinity is set on an inactive interrupt then:

    - Store it in the irq descriptors affinity mask
    - Update the effective affinity to reflect that so user space has
      a consistent view
    - Don't call into the irq chip driver

This is the core equivalent of the X86 workaround and works correctly
because the affinity setting is established in the irq chip when the
interrupt is activated later on.

Note, that this is only effective when hierarchical irq domains are enabled
by the architecture. Doing it unconditionally would break legacy irq chip
implementations.

For hierarchial irq domains this works correctly as none of the drivers can
have a dependency on affinity setting in inactive state by design.

Remove the X86 workaround as it is not longer required.

Fixes: 02edee152d6e ("x86/apic/vector: Ignore set_affinity call for inactive interrupts")
Reported-by: Ali Saidi <alisaidi@amazon.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Ali Saidi <alisaidi@amazon.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200529015501.15771-1-alisaidi@amazon.com
Link: https://lkml.kernel.org/r/877dv2rv25.fsf@nanos.tec.linutronix.de
[fllinden@amazon.com - 4.14 never had the x86 workaround, so skip x86 changes]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/manage.c |   37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -168,9 +168,9 @@ void irq_set_thread_affinity(struct irq_
 			set_bit(IRQTF_AFFINITY, &action->thread_flags);
 }
 
+#ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
 static void irq_validate_effective_affinity(struct irq_data *data)
 {
-#ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
 	const struct cpumask *m = irq_data_get_effective_affinity_mask(data);
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 
@@ -178,9 +178,19 @@ static void irq_validate_effective_affin
 		return;
 	pr_warn_once("irq_chip %s did not update eff. affinity mask of irq %u\n",
 		     chip->name, data->irq);
-#endif
 }
 
+static inline void irq_init_effective_affinity(struct irq_data *data,
+					       const struct cpumask *mask)
+{
+	cpumask_copy(irq_data_get_effective_affinity_mask(data), mask);
+}
+#else
+static inline void irq_validate_effective_affinity(struct irq_data *data) { }
+static inline void irq_init_effective_affinity(struct irq_data *data,
+					       const struct cpumask *mask) { }
+#endif
+
 int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			bool force)
 {
@@ -205,6 +215,26 @@ int irq_do_set_affinity(struct irq_data
 	return ret;
 }
 
+static bool irq_set_affinity_deactivated(struct irq_data *data,
+					 const struct cpumask *mask, bool force)
+{
+	struct irq_desc *desc = irq_data_to_desc(data);
+
+	/*
+	 * If the interrupt is not yet activated, just store the affinity
+	 * mask and do not call the chip driver at all. On activation the
+	 * driver has to make sure anyway that the interrupt is in a
+	 * useable state so startup works.
+	 */
+	if (!IS_ENABLED(CONFIG_IRQ_DOMAIN_HIERARCHY) || irqd_is_activated(data))
+		return false;
+
+	cpumask_copy(desc->irq_common_data.affinity, mask);
+	irq_init_effective_affinity(data, mask);
+	irqd_set(data, IRQD_AFFINITY_SET);
+	return true;
+}
+
 int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
 			    bool force)
 {
@@ -215,6 +245,9 @@ int irq_set_affinity_locked(struct irq_d
 	if (!chip || !chip->irq_set_affinity)
 		return -EINVAL;
 
+	if (irq_set_affinity_deactivated(data, mask, force))
+		return 0;
+
 	if (irq_can_move_pcntxt(data)) {
 		ret = irq_do_set_affinity(data, mask, force);
 	} else {



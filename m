Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF9224117C
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 22:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgHJUMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 16:12:14 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:44775 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbgHJUME (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 16:12:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597090324; x=1628626324;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=McX9OjANjGf5MpW6m/yKJUWw5S095Zl13HRuULQZsFU=;
  b=ugUcQe+dRJxuHu5nGmvDe4QT28Z0yAP/stO5aQ9rKYJpaX3pkzHtRetl
   MQyUmw5hO+OQ2ulHxbipiFRXbwoc063UAv45cWeljcIAi0HcyucSa/Fuk
   68KaBkSHte6lCKxpWbrckYCnsjbGPeNbu/2iT/wQOZox5ndzg2XFppf59
   g=;
IronPort-SDR: GFLjByfURk0W3KYFqIGvvw6v347dQQzqKns19jv2H9FpVJKKyhyhrTvb5/yRUynUqVBhxgAK7b
 hUgGue3jgigw==
X-IronPort-AV: E=Sophos;i="5.75,458,1589241600"; 
   d="scan'208";a="65718728"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-60ce1996.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 10 Aug 2020 20:11:47 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-60ce1996.us-west-2.amazon.com (Postfix) with ESMTPS id D0772A08E4
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 20:11:46 +0000 (UTC)
Received: from EX13D13UWA001.ant.amazon.com (10.43.160.136) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 20:11:46 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D13UWA001.ant.amazon.com (10.43.160.136) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 20:11:45 +0000
Received: from dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com
 (172.23.141.97) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Mon, 10 Aug 2020 20:11:44 +0000
Received: by dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com (Postfix, from userid 6262777)
        id C2EBAC1424; Mon, 10 Aug 2020 20:11:44 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <fllinden@amazon.com>
Subject: [PATCH 4.14 1/2] genirq/affinity: Handle affinity setting on inactive interrupts correctly
Date:   Mon, 10 Aug 2020 20:11:43 +0000
Message-ID: <20200810201144.20618-1-fllinden@amazon.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
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
---
 kernel/irq/manage.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 5277949e82e0..ce6fba446814 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -168,9 +168,9 @@ void irq_set_thread_affinity(struct irq_desc *desc)
 			set_bit(IRQTF_AFFINITY, &action->thread_flags);
 }
 
+#ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
 static void irq_validate_effective_affinity(struct irq_data *data)
 {
-#ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
 	const struct cpumask *m = irq_data_get_effective_affinity_mask(data);
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 
@@ -178,9 +178,19 @@ static void irq_validate_effective_affinity(struct irq_data *data)
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
@@ -205,6 +215,26 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
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
@@ -215,6 +245,9 @@ int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
 	if (!chip || !chip->irq_set_affinity)
 		return -EINVAL;
 
+	if (irq_set_affinity_deactivated(data, mask, force))
+		return 0;
+
 	if (irq_can_move_pcntxt(data)) {
 		ret = irq_do_set_affinity(data, mask, force);
 	} else {
-- 
2.17.2


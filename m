Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B04D5EFF0A
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 23:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiI2VIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 17:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiI2VIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 17:08:00 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833071B913E;
        Thu, 29 Sep 2022 14:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664485679; x=1696021679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7ISFbYYRDxr1/mXtnOCqoR2jsfb1I4SQ8DP09zVscdM=;
  b=HIyhxwZTMHr28QQ/6IjqLihVvYCn7MF4hw095fMcXMDDpWcN9ceO0RgO
   oooIfFkzO9gJG///RtyrlGOOQkx0ULfkh9ftV0AR2YQL6lHKzpA9+WQui
   I+a92WcOML6Sh+7/xD0q3XOk/RgYxvzuD5lZVVddkuL/wXq425YQsdgXw
   M=;
X-IronPort-AV: E=Sophos;i="5.93,356,1654560000"; 
   d="scan'208";a="1059419660"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-b48bc93b.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 21:07:57 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-b48bc93b.us-east-1.amazon.com (Postfix) with ESMTPS id 25D5BC0886;
        Thu, 29 Sep 2022 21:07:53 +0000 (UTC)
Received: from EX19D021UWA003.ant.amazon.com (10.13.139.74) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 29 Sep 2022 21:07:53 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D021UWA003.ant.amazon.com (10.13.139.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.12; Thu, 29 Sep 2022 21:07:53 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Thu, 29 Sep 2022 21:07:53
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 26386286B; Thu, 29 Sep 2022 21:07:52 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <benh@amazon.com>,
        <mbacco@amazon.com>, Robert Hodaszi <Robert.Hodaszi@digi.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 6/6] x86/ioapic: Implement irq_get_irqchip_state() callback
Date:   Thu, 29 Sep 2022 21:06:51 +0000
Message-ID: <20220929210651.12308-7-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220929210651.12308-1-risbhat@amazon.com>
References: <20220929210651.12308-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-12.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit dfe0cf8b51b07e56ded571e3de0a4a9382517231 upstream.

When an interrupt is shut down in free_irq() there might be an inflight
interrupt pending in the IO-APIC remote IRR which is not yet serviced. That
means the interrupt has been sent to the target CPUs local APIC, but the
target CPU is in a state which delays the servicing.

So free_irq() would proceed to free resources and to clear the vector
because synchronize_hardirq() does not see an interrupt handler in
progress.

That can trigger a spurious interrupt warning, which is harmless and just
confuses users, but it also can leave the remote IRR in a stale state
because once the handler is invoked the interrupt resources might be freed
already and therefore acknowledgement is not possible anymore.

Implement the irq_get_irqchip_state() callback for the IO-APIC irq chip. The
callback is invoked from free_irq() via __synchronize_hardirq(). Check the
remote IRR bit of the interrupt and return 'in flight' if it is set and the
interrupt is configured in level mode. For edge mode the remote IRR has no
meaning.

As this is only meaningful for level triggered interrupts this won't cure
the potential spurious interrupt warning for edge triggered interrupts, but
the edge trigger case does not result in stale hardware state. This has to
be addressed at the vector/interrupt entry level seperately.

Fixes: 464d12309e1b ("x86/vector: Switch IOAPIC to global reservation mode")
Reported-by: Robert Hodaszi <Robert.Hodaszi@digi.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Link: https://lkml.kernel.org/r/20190628111440.370295517@linutronix.de
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 arch/x86/kernel/apic/io_apic.c | 46 ++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index de74bca6a8ff..7d1d393298d0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1860,6 +1860,50 @@ static int ioapic_set_affinity(struct irq_data *irq_data,
 	return ret;
 }
 
+/*
+ * Interrupt shutdown masks the ioapic pin, but the interrupt might already
+ * be in flight, but not yet serviced by the target CPU. That means
+ * __synchronize_hardirq() would return and claim that everything is calmed
+ * down. So free_irq() would proceed and deactivate the interrupt and free
+ * resources.
+ *
+ * Once the target CPU comes around to service it it will find a cleared
+ * vector and complain. While the spurious interrupt is harmless, the full
+ * release of resources might prevent the interrupt from being acknowledged
+ * which keeps the hardware in a weird state.
+ *
+ * Verify that the corresponding Remote-IRR bits are clear.
+ */
+static int ioapic_irq_get_chip_state(struct irq_data *irqd,
+				   enum irqchip_irq_state which,
+				   bool *state)
+{
+	struct mp_chip_data *mcd = irqd->chip_data;
+	struct IO_APIC_route_entry rentry;
+	struct irq_pin_list *p;
+
+	if (which != IRQCHIP_STATE_ACTIVE)
+		return -EINVAL;
+
+	*state = false;
+	raw_spin_lock(&ioapic_lock);
+	for_each_irq_pin(p, mcd->irq_2_pin) {
+		rentry = __ioapic_read_entry(p->apic, p->pin);
+		/*
+		 * The remote IRR is only valid in level trigger mode. It's
+		 * meaning is undefined for edge triggered interrupts and
+		 * irrelevant because the IO-APIC treats them as fire and
+		 * forget.
+		 */
+		if (rentry.irr && rentry.trigger) {
+			*state = true;
+			break;
+		}
+	}
+	raw_spin_unlock(&ioapic_lock);
+	return 0;
+}
+
 static struct irq_chip ioapic_chip __read_mostly = {
 	.name			= "IO-APIC",
 	.irq_startup		= startup_ioapic_irq,
@@ -1869,6 +1913,7 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.irq_eoi		= ioapic_ack_level,
 	.irq_set_affinity	= ioapic_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_get_irqchip_state	= ioapic_irq_get_chip_state,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -1881,6 +1926,7 @@ static struct irq_chip ioapic_ir_chip __read_mostly = {
 	.irq_eoi		= ioapic_ir_ack_level,
 	.irq_set_affinity	= ioapic_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_get_irqchip_state	= ioapic_irq_get_chip_state,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
-- 
2.37.1


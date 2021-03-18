Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38406340E3F
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 20:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhCRT37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 15:29:59 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:59832 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbhCRT3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 15:29:41 -0400
Message-Id: <20210318192819.636943062@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616095780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=LfvI7sCW2SL4HbRRF+idaLPXpqpsqiBF/HoysWbs8SA=;
        b=TzEdTLH5JAloAauoEfeJktlYnl3lZLEv+7H6OxsasCteyOwrhnLIrVCeFJIDlo1pRpthvI
        ByTs4iUAWETp6SujHhFTYSiiVHIvGnnZditikDYKH+y8dj/gtoWWts5fnMHz4M6ll0ycl6
        xIxfbEpRcFJ54y2ghRnlxh4CilMYVxs4gMmsN83k1BTG3274wPHAvlAQhuFrhdRJZsumFr
        xP0lFHXmTZzPGMEQx94a3bYPXMwu60uHLEpSPp6TbIq/Fv9/Vp/zohzGWIcCPYQz9hpVZa
        DkFFzXWeZv+yoYlyetdjWA+rsLDIapb1UXK1C/kvsSqZuRyda+sIRD6zjnnl1g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616095780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=LfvI7sCW2SL4HbRRF+idaLPXpqpsqiBF/HoysWbs8SA=;
        b=PHOEWM1FMf8d70QCLFHRA/TLlem9UR/LhjviL32rVh//25p3oExPUsIk62PTL9L9tnjA7t
        zonQkNaHxw8r4IBQ==
Date:   Thu, 18 Mar 2021 20:26:47 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        stable@vger.kernel.org
Subject: [patch 1/2] x86/ioapic: Ignore IRQ2 again
References: <20210318192646.868059483@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vitali ran into an issue with hotplugging CPU0 on an Amazon instance where
the matrix allocator claimed to be out of vectors. He analyzed it down to
the point that IRQ2, the PIC cascade interrupt, which is supposed to be not
ever routed to the IO/APIC ended up having an interrupt vector assigned
which got moved during unplug of CPU0.

The underlying issue is that IRQ2 for various reasons (see commit
af174783b925 ("x86: I/O APIC: Never configure IRQ2" for details) is treated
as a reserved system vector by the vector core code and is not accounted as
a regular vector. The Amazon BIOS has an routing entry of pin2 to IRQ2
which causes the IO/APIC setup to claim that interrupt which is granted by
the vector domain because there is no sanity check. As a consequence the
allocation counter of CPU0 underflows which causes a subsequent unplug to
fail with:

  [ ... ] CPU 0 has 4294967295 vectors, 589 available. Cannot disable CPU

There is another sanity check missing in the matrix allocator, but the
underlying root cause is that the IO/APIC code lost the IRQ2 ignore logic
during the conversion to irqdomains.

For almost 6 years nobody complained about this wreckage, which might
indicate that this requirement could be lifted, but for any system which
actually has a PIC IRQ2 is unusable by design so any routing entry has no
effect and the interrupt cannot be connected to a device anyway.

Due to that and due to history biased paranoia reasons restore the IRQ2
ignore logic and treat it as non existent despite a routing entry claiming
otherwise.

Fixes: d32932d02e18 ("x86/irq: Convert IOAPIC to use hierarchical irqdomain interfaces")
Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/874kh9xuid.fsf@nanos.tec.linutronix.de

---
 arch/x86/kernel/apic/io_apic.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1032,6 +1032,16 @@ static int mp_map_pin_to_irq(u32 gsi, in
 	if (idx >= 0 && test_bit(mp_irqs[idx].srcbus, mp_bus_not_pci)) {
 		irq = mp_irqs[idx].srcbusirq;
 		legacy = mp_is_legacy_irq(irq);
+		/*
+		 * IRQ2 is unusable for historical reasons on systems which
+		 * have a legacy PIC. See the comment vs. IRQ2 further down.
+		 *
+		 * If this gets removed at some point then the related code
+		 * in lapic_assign_system_vectors() needs to be adjusted as
+		 * well.
+		 */
+		if (legacy && irq == PIC_CASCADE_IR)
+			return -EINVAL;
 	}
 
 	mutex_lock(&ioapic_mutex);


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83134344350
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhCVMtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232403AbhCVMrn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:47:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8172619C5;
        Mon, 22 Mar 2021 12:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417006;
        bh=MbOJOWx5LcDC8jcj/QLIm3rwzeMlpcGLz1TH6BnDdHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkmuk8JVORaotPSYQY4N3p/zdlFo6jg0GEsHWz92mUyQuZFdfeHQHIa2w7Esa0Hph
         sz+sc6B+/JeAu2OLXVeSVavFei4iMI0Th2rO+mF9GaLuFk4IEw9tABIzkWdCL152OM
         TWpBoxxxjb5uAvgh1E2Zv7UNbPizU26bv1aYIJkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 50/60] x86/ioapic: Ignore IRQ2 again
Date:   Mon, 22 Mar 2021 13:28:38 +0100
Message-Id: <20210322121924.040214796@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit a501b048a95b79e1e34f03cac3c87ff1e9f229ad upstream.

Vitaly ran into an issue with hotplugging CPU0 on an Amazon instance where
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
Link: https://lore.kernel.org/r/20210318192819.636943062@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/apic/io_apic.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1046,6 +1046,16 @@ static int mp_map_pin_to_irq(u32 gsi, in
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



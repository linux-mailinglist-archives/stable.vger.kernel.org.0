Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42071341BC6
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 12:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhCSLue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 07:50:34 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36404 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCSLuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 07:50:23 -0400
Date:   Fri, 19 Mar 2021 11:50:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616154622;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zpxq5otX4TnUbF2LFQlIqJoCztRsOCqmv9aM1qH31Is=;
        b=ARxMWfnjA5zHVEfQtBcaf3Ub0akswX+qkt5qJxgAGCsQ/33Oy/g87wRQpkphT6HODiI2P4
        U3tVxS1Izq5iE894x32c1CYr8FBRcPbFSyrZU0v4yzk1vxDZ0zE9bkZVWK6OQ0HcT+ocRH
        muVxi1jnwW+a5rolnpB1VW98/FGVwWvujwaQRtXeG/QzAISycqnIPwEH9RMw8ko0dwWpWs
        /XXSfetR2UCmDxdkNqek2y0BR94IUDXzy2yxwoEv0OtE+ezCa/q3TzsOn8hV3FvfWR10eT
        fZC6izYUOkjbNwOdn//ci5P1Iz7+35Zex+0pBdItd4Wc7Um4ByEY33U0qzCX4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616154622;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zpxq5otX4TnUbF2LFQlIqJoCztRsOCqmv9aM1qH31Is=;
        b=t+0e/lK1UR5mqC8zxBzgkUhdBCDWgkpOTl3VEDtsQb3T0QUXxrKO4CNwbqDOKT8JnRjxGi
        TZKROOyRrYeQUUBw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/ioapic: Ignore IRQ2 again
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210318192819.636943062@linutronix.de>
References: <20210318192819.636943062@linutronix.de>
MIME-Version: 1.0
Message-ID: <161615462121.398.1632881583538961240.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     a501b048a95b79e1e34f03cac3c87ff1e9f229ad
Gitweb:        https://git.kernel.org/tip/a501b048a95b79e1e34f03cac3c87ff1e9f229ad
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 18 Mar 2021 20:26:47 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 19 Mar 2021 12:43:41 +01:00

x86/ioapic: Ignore IRQ2 again

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


---
 arch/x86/kernel/apic/io_apic.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c3b60c3..73ff4dd 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1032,6 +1032,16 @@ static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
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

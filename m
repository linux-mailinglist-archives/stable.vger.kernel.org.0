Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA6C3A0386
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237931AbhFHTSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234654AbhFHTQF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:16:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FEF86147D;
        Tue,  8 Jun 2021 18:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178261;
        bh=yKzWz/R93n/W8c2XN8ADQg4urha27y9n3kqVabXUgts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqrfxdi2lpbAwbTrsbR/nrc3o3xfCPrXfTTudL2OqczLQOz4xWfOjYjetrDR68tT3
         tvDRo1mZV9+RmmimbOHHGDyencxzeqnETlr/s0OqXbbvq3Zd8Yjyso1pjeES4/oxeW
         3qQFlzbeyArw0S1yR4QSHm62wbcD5ehCjNKzvTUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Imran Khan <imran.f.khan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.12 137/161] x86/apic: Mark _all_ legacy interrupts when IO/APIC is missing
Date:   Tue,  8 Jun 2021 20:27:47 +0200
Message-Id: <20210608175950.077416297@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 7d65f9e80646c595e8c853640a9d0768a33e204c upstream.

PIC interrupts do not support affinity setting and they can end up on
any online CPU. Therefore, it's required to mark the associated vectors
as system-wide reserved. Otherwise, the corresponding irq descriptors
are copied to the secondary CPUs but the vectors are not marked as
assigned or reserved. This works correctly for the IO/APIC case.

When the IO/APIC is disabled via config, kernel command line or lack of
enumeration then all legacy interrupts are routed through the PIC, but
nothing marks them as system-wide reserved vectors.

As a consequence, a subsequent allocation on a secondary CPU can result in
allocating one of these vectors, which triggers the BUG() in
apic_update_vector() because the interrupt descriptor slot is not empty.

Imran tried to work around that by marking those interrupts as allocated
when a CPU comes online. But that's wrong in case that the IO/APIC is
available and one of the legacy interrupts, e.g. IRQ0, has been switched to
PIC mode because then marking them as allocated will fail as they are
already marked as system vectors.

Stay consistent and update the legacy vectors after attempting IO/APIC
initialization and mark them as system vectors in case that no IO/APIC is
available.

Fixes: 69cde0004a4b ("x86/vector: Use matrix allocator for vector assignment")
Reported-by: Imran Khan <imran.f.khan@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210519233928.2157496-1-imran.f.khan@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/apic.h   |    1 +
 arch/x86/kernel/apic/apic.c   |    1 +
 arch/x86/kernel/apic/vector.c |   20 ++++++++++++++++++++
 3 files changed, 22 insertions(+)

--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -174,6 +174,7 @@ static inline int apic_is_clustered_box(
 extern int setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask);
 extern void lapic_assign_system_vectors(void);
 extern void lapic_assign_legacy_vector(unsigned int isairq, bool replace);
+extern void lapic_update_legacy_vectors(void);
 extern void lapic_online(void);
 extern void lapic_offline(void);
 extern bool apic_needs_pit(void);
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2604,6 +2604,7 @@ static void __init apic_bsp_setup(bool u
 	end_local_APIC_setup();
 	irq_remap_enable_fault_handling();
 	setup_IO_APIC();
+	lapic_update_legacy_vectors();
 }
 
 #ifdef CONFIG_UP_LATE_INIT
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -730,6 +730,26 @@ void lapic_assign_legacy_vector(unsigned
 	irq_matrix_assign_system(vector_matrix, ISA_IRQ_VECTOR(irq), replace);
 }
 
+void __init lapic_update_legacy_vectors(void)
+{
+	unsigned int i;
+
+	if (IS_ENABLED(CONFIG_X86_IO_APIC) && nr_ioapics > 0)
+		return;
+
+	/*
+	 * If the IO/APIC is disabled via config, kernel command line or
+	 * lack of enumeration then all legacy interrupts are routed
+	 * through the PIC. Make sure that they are marked as legacy
+	 * vectors. PIC_CASCADE_IRQ has already been marked in
+	 * lapic_assign_system_vectors().
+	 */
+	for (i = 0; i < nr_legacy_irqs(); i++) {
+		if (i != PIC_CASCADE_IR)
+			lapic_assign_legacy_vector(i, true);
+	}
+}
+
 void __init lapic_assign_system_vectors(void)
 {
 	unsigned int i, vector = 0;



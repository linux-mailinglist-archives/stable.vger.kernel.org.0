Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CB2394C09
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 13:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhE2L2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 07:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhE2L2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 07:28:41 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD87DC061574;
        Sat, 29 May 2021 04:27:04 -0700 (PDT)
Date:   Sat, 29 May 2021 11:27:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622287622;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wllJsNcibiIvAJWRjtmQE4qKSzwtR0YphipOcEnQVVU=;
        b=sy7dCbmJMq4uZCGBTegkwtgM6tQduWwfU77ptvLe3u9abNosiHMihwbghFiWQ+MC80kW/f
        Xxd+zD16jVey5GFbNHZ4DJF5ZxrY1CjDCnWtPgtL4GJqrtmAPi3aKN+5yrxuntSfrr9689
        vMSNjENKynOCxXRCLZPqZPwnEj8Kya0nyF2bspGNR2M92NGLjzuSHxStkUAQvvSfUnW856
        gV+N6nI2fYPSpuxPP3J618BhQVirBUKLtKEmJRUfhrRaG3tXh+9E2NY/fequ0cbqehepgQ
        FRKRGIlGCwo86TCBFJHrX49tmi9VEopCQ7Cc4LfE/8OqXSr9xUR9HY5HWO4tHQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622287622;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wllJsNcibiIvAJWRjtmQE4qKSzwtR0YphipOcEnQVVU=;
        b=aNKGUi+h+JZmDcEr5YM5NtkAtQUbkHlcPd6vWwG8YPyLwh6g7vV9rx5FlZbosEIgjT/677
        vY2yrXdTp78LVaDA==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/apic: Mark _all_ legacy interrupts when IO/APIC
 is missing
Cc:     Imran Khan <imran.f.khan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210519233928.2157496-1-imran.f.khan@oracle.com>
References: <20210519233928.2157496-1-imran.f.khan@oracle.com>
MIME-Version: 1.0
Message-ID: <162228762181.29796.12251794167483746232.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     7d65f9e80646c595e8c853640a9d0768a33e204c
Gitweb:        https://git.kernel.org/tip/7d65f9e80646c595e8c853640a9d0768a33e204c
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Tue, 25 May 2021 13:08:41 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Sat, 29 May 2021 11:41:14 +02:00

x86/apic: Mark _all_ legacy interrupts when IO/APIC is missing

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
---
 arch/x86/include/asm/apic.h   |  1 +
 arch/x86/kernel/apic/apic.c   |  1 +
 arch/x86/kernel/apic/vector.c | 20 ++++++++++++++++++++
 3 files changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 412b51e..48067af 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -174,6 +174,7 @@ static inline int apic_is_clustered_box(void)
 extern int setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask);
 extern void lapic_assign_system_vectors(void);
 extern void lapic_assign_legacy_vector(unsigned int isairq, bool replace);
+extern void lapic_update_legacy_vectors(void);
 extern void lapic_online(void);
 extern void lapic_offline(void);
 extern bool apic_needs_pit(void);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 4a39fb4..d262811 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2604,6 +2604,7 @@ static void __init apic_bsp_setup(bool upmode)
 	end_local_APIC_setup();
 	irq_remap_enable_fault_handling();
 	setup_IO_APIC();
+	lapic_update_legacy_vectors();
 }
 
 #ifdef CONFIG_UP_LATE_INIT
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 6dbdc7c..fb67ed5 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -738,6 +738,26 @@ void lapic_assign_legacy_vector(unsigned int irq, bool replace)
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

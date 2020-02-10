Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD56E1576BD
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730081AbgBJMlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728430AbgBJMlv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:51 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B89A92051A;
        Mon, 10 Feb 2020 12:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338510;
        bh=ecMcaR6yCQLXN2zxnLeHZ2Py8kmvxAIR+L1XSOKoxZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cc/qGtCSidcn6TeJtTELsUrrNgcclCZ3ciLNnCsCIstAAQxO3A/nZkwUXW9Deevb+
         XQwtjhnzfw3SJUOiREfIcc7/9X1u9hOyLYwFZxJutzR6oEE1hpHmqRKDo7RkO917sC
         TXJMaP1E+keu2MRXiVvEWcNJouMdPItEx0AMdQtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anthony Buckley <tony.buckley000@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Daniel Drake <drake@endlessm.com>
Subject: [PATCH 5.5 315/367] x86/timer: Dont skip PIT setup when APIC is disabled or in legacy mode
Date:   Mon, 10 Feb 2020 04:33:48 -0800
Message-Id: <20200210122452.274883979@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 979923871f69a4dc926658f9f9a1a4c1bde57552 upstream.

Tony reported a boot regression caused by the recent workaround for systems
which have a disabled (clock gate off) PIT.

On his machine the kernel fails to initialize the PIT because
apic_needs_pit() does not take into account whether the local APIC
interrupt delivery mode will actually allow to setup and use the local
APIC timer. This should be easy to reproduce with acpi=off on the
command line which also disables HPET.

Due to the way the PIT/HPET and APIC setup ordering works (APIC setup can
require working PIT/HPET) the information is not available at the point
where apic_needs_pit() makes this decision.

To address this, split out the interrupt mode selection from
apic_intr_mode_init(), invoke the selection before making the decision
whether PIT is required or not, and add the missing checks into
apic_needs_pit().

Fixes: c8c4076723da ("x86/timer: Skip PIT initialization on modern chipsets")
Reported-by: Anthony Buckley <tony.buckley000@gmail.com>
Tested-by: Anthony Buckley <tony.buckley000@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Daniel Drake <drake@endlessm.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206125
Link: https://lore.kernel.org/r/87sgk6tmk2.fsf@nanos.tec.linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/apic.h     |    2 ++
 arch/x86/include/asm/x86_init.h |    2 ++
 arch/x86/kernel/apic/apic.c     |   23 ++++++++++++++++++-----
 arch/x86/kernel/time.c          |   12 ++++++++++--
 arch/x86/kernel/x86_init.c      |    1 +
 arch/x86/xen/enlighten_pv.c     |    1 +
 6 files changed, 34 insertions(+), 7 deletions(-)

--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -140,6 +140,7 @@ extern void apic_soft_disable(void);
 extern void lapic_shutdown(void);
 extern void sync_Arb_IDs(void);
 extern void init_bsp_APIC(void);
+extern void apic_intr_mode_select(void);
 extern void apic_intr_mode_init(void);
 extern void init_apic_mappings(void);
 void register_lapic_address(unsigned long address);
@@ -188,6 +189,7 @@ static inline void disable_local_APIC(vo
 # define setup_secondary_APIC_clock x86_init_noop
 static inline void lapic_update_tsc_freq(void) { }
 static inline void init_bsp_APIC(void) { }
+static inline void apic_intr_mode_select(void) { }
 static inline void apic_intr_mode_init(void) { }
 static inline void lapic_assign_system_vectors(void) { }
 static inline void lapic_assign_legacy_vector(unsigned int i, bool r) { }
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -51,12 +51,14 @@ struct x86_init_resources {
  *				are set up.
  * @intr_init:			interrupt init code
  * @trap_init:			platform specific trap setup
+ * @intr_mode_select:		interrupt delivery mode selection
  * @intr_mode_init:		interrupt delivery mode setup
  */
 struct x86_init_irqs {
 	void (*pre_vector_init)(void);
 	void (*intr_init)(void);
 	void (*trap_init)(void);
+	void (*intr_mode_select)(void);
 	void (*intr_mode_init)(void);
 };
 
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -830,8 +830,17 @@ bool __init apic_needs_pit(void)
 	if (!tsc_khz || !cpu_khz)
 		return true;
 
-	/* Is there an APIC at all? */
-	if (!boot_cpu_has(X86_FEATURE_APIC))
+	/* Is there an APIC at all or is it disabled? */
+	if (!boot_cpu_has(X86_FEATURE_APIC) || disable_apic)
+		return true;
+
+	/*
+	 * If interrupt delivery mode is legacy PIC or virtual wire without
+	 * configuration, the local APIC timer wont be set up. Make sure
+	 * that the PIT is initialized.
+	 */
+	if (apic_intr_mode == APIC_PIC ||
+	    apic_intr_mode == APIC_VIRTUAL_WIRE_NO_CONFIG)
 		return true;
 
 	/* Virt guests may lack ARAT, but still have DEADLINE */
@@ -1322,7 +1331,7 @@ void __init sync_Arb_IDs(void)
 
 enum apic_intr_mode_id apic_intr_mode __ro_after_init;
 
-static int __init apic_intr_mode_select(void)
+static int __init __apic_intr_mode_select(void)
 {
 	/* Check kernel option */
 	if (disable_apic) {
@@ -1384,6 +1393,12 @@ static int __init apic_intr_mode_select(
 	return APIC_SYMMETRIC_IO;
 }
 
+/* Select the interrupt delivery mode for the BSP */
+void __init apic_intr_mode_select(void)
+{
+	apic_intr_mode = __apic_intr_mode_select();
+}
+
 /*
  * An initial setup of the virtual wire mode.
  */
@@ -1440,8 +1455,6 @@ void __init apic_intr_mode_init(void)
 {
 	bool upmode = IS_ENABLED(CONFIG_UP_LATE_INIT);
 
-	apic_intr_mode = apic_intr_mode_select();
-
 	switch (apic_intr_mode) {
 	case APIC_PIC:
 		pr_info("APIC: Keep in PIC mode(8259)\n");
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -91,10 +91,18 @@ void __init hpet_time_init(void)
 
 static __init void x86_late_time_init(void)
 {
+	/*
+	 * Before PIT/HPET init, select the interrupt mode. This is required
+	 * to make the decision whether PIT should be initialized correct.
+	 */
+	x86_init.irqs.intr_mode_select();
+
+	/* Setup the legacy timers */
 	x86_init.timers.timer_init();
+
 	/*
-	 * After PIT/HPET timers init, select and setup
-	 * the final interrupt mode for delivering IRQs.
+	 * After PIT/HPET timers init, set up the final interrupt mode for
+	 * delivering IRQs.
 	 */
 	x86_init.irqs.intr_mode_init();
 	tsc_init();
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -80,6 +80,7 @@ struct x86_init_ops x86_init __initdata
 		.pre_vector_init	= init_ISA_irqs,
 		.intr_init		= native_init_IRQ,
 		.trap_init		= x86_init_noop,
+		.intr_mode_select	= apic_intr_mode_select,
 		.intr_mode_init		= apic_intr_mode_init
 	},
 
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1205,6 +1205,7 @@ asmlinkage __visible void __init xen_sta
 	x86_platform.get_nmi_reason = xen_get_nmi_reason;
 
 	x86_init.resources.memory_setup = xen_memory_setup;
+	x86_init.irqs.intr_mode_select	= x86_init_noop;
 	x86_init.irqs.intr_mode_init	= x86_init_noop;
 	x86_init.oem.arch_setup = xen_arch_setup;
 	x86_init.oem.banner = xen_banner;



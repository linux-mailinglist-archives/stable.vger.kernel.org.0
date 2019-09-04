Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2589A8E49
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732741AbfIDR5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732466AbfIDR5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:57:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFB1B22CEA;
        Wed,  4 Sep 2019 17:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619828;
        bh=XDar3pNO6Ku97W5wpjz5l7QgJ9xJKmczy9FsV8SALVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDUVDDyXthnLpzbxztQdNk8yarScA80ZLprTv/zHAyeR2TvYjUsVgwZS4wikozA8m
         ULqu6k9tMzLmgqIniOLeSXM8cfkApl+fNPER1cC+41R3ecjF0ZRtu7Ncs8+0dXDtsu
         5OoPix2boD1E3/3GP3WUMR9TOG14ZCNio+f8+Q58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Yu <yu.c.chen@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Andy Lutomirski <luto@amacapital.net>,
        Borislav Petkov <bp@alien8.de>,
        Brian Gerst <brgerst@gmail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, bp@suse.de,
        len.brown@intel.com, linux@horizon.com, luto@kernel.org,
        rjw@rjwysocki.net, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Marcin Kaszewski <marcin.kaszewski@intel.com>
Subject: [PATCH 4.4 48/77] x86/pm: Introduce quirk framework to save/restore extra MSR registers around suspend/resume
Date:   Wed,  4 Sep 2019 19:53:35 +0200
Message-Id: <20190904175308.033519314@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7a9c2dd08eadd5c6943115dbbec040c38d2e0822 ]

A bug was reported that on certain Broadwell platforms, after
resuming from S3, the CPU is running at an anomalously low
speed.

It turns out that the BIOS has modified the value of the
THERM_CONTROL register during S3, and changed it from 0 to 0x10,
thus enabled clock modulation(bit4), but with undefined CPU Duty
Cycle(bit1:3) - which causes the problem.

Here is a simple scenario to reproduce the issue:

 1. Boot up the system
 2. Get MSR 0x19a, it should be 0
 3. Put the system into sleep, then wake it up
 4. Get MSR 0x19a, it shows 0x10, while it should be 0

Although some BIOSen want to change the CPU Duty Cycle during
S3, in our case we don't want the BIOS to do any modification.

Fix this issue by introducing a more generic x86 framework to
save/restore specified MSR registers(THERM_CONTROL in this case)
for suspend/resume. This allows us to fix similar bugs in a much
simpler way in the future.

When the kernel wants to protect certain MSRs during suspending,
we simply add a quirk entry in msr_save_dmi_table, and customize
the MSR registers inside the quirk callback, for example:

  u32 msr_id_need_to_save[] = {MSR_ID0, MSR_ID1, MSR_ID2...};

and the quirk mechanism ensures that, once resumed from suspend,
the MSRs indicated by these IDs will be restored to their
original, pre-suspend values.

Since both 64-bit and 32-bit kernels are affected, this patch
covers the common 64/32-bit suspend/resume code path. And
because the MSRs specified by the user might not be available or
readable in any situation, we use rdmsrl_safe() to safely save
these MSRs.

Reported-and-tested-by: Marcin Kaszewski <marcin.kaszewski@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: bp@suse.de
Cc: len.brown@intel.com
Cc: linux@horizon.com
Cc: luto@kernel.org
Cc: rjw@rjwysocki.net
Link: http://lkml.kernel.org/r/c9abdcbc173dd2f57e8990e304376f19287e92ba.1448382971.git.yu.c.chen@intel.com
[ More edits to the naming of data structures. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/msr.h        | 10 ++++
 arch/x86/include/asm/suspend_32.h |  1 +
 arch/x86/include/asm/suspend_64.h |  1 +
 arch/x86/power/cpu.c              | 92 +++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 5a10ac8c131ea..20f822fec8af0 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -32,6 +32,16 @@ struct msr_regs_info {
 	int err;
 };
 
+struct saved_msr {
+	bool valid;
+	struct msr_info info;
+};
+
+struct saved_msrs {
+	unsigned int num;
+	struct saved_msr *array;
+};
+
 static inline unsigned long long native_read_tscp(unsigned int *aux)
 {
 	unsigned long low, high;
diff --git a/arch/x86/include/asm/suspend_32.h b/arch/x86/include/asm/suspend_32.h
index d1793f06854d2..8e9dbe7b73a1f 100644
--- a/arch/x86/include/asm/suspend_32.h
+++ b/arch/x86/include/asm/suspend_32.h
@@ -15,6 +15,7 @@ struct saved_context {
 	unsigned long cr0, cr2, cr3, cr4;
 	u64 misc_enable;
 	bool misc_enable_saved;
+	struct saved_msrs saved_msrs;
 	struct desc_ptr gdt_desc;
 	struct desc_ptr idt;
 	u16 ldt;
diff --git a/arch/x86/include/asm/suspend_64.h b/arch/x86/include/asm/suspend_64.h
index 7ebf0ebe4e687..6136a18152af2 100644
--- a/arch/x86/include/asm/suspend_64.h
+++ b/arch/x86/include/asm/suspend_64.h
@@ -24,6 +24,7 @@ struct saved_context {
 	unsigned long cr0, cr2, cr3, cr4, cr8;
 	u64 misc_enable;
 	bool misc_enable_saved;
+	struct saved_msrs saved_msrs;
 	unsigned long efer;
 	u16 gdt_pad; /* Unused */
 	struct desc_ptr gdt_desc;
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 9ab52791fed59..d5f64996394a9 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -23,6 +23,7 @@
 #include <asm/debugreg.h>
 #include <asm/cpu.h>
 #include <asm/mmu_context.h>
+#include <linux/dmi.h>
 
 #ifdef CONFIG_X86_32
 __visible unsigned long saved_context_ebx;
@@ -32,6 +33,29 @@ __visible unsigned long saved_context_eflags;
 #endif
 struct saved_context saved_context;
 
+static void msr_save_context(struct saved_context *ctxt)
+{
+	struct saved_msr *msr = ctxt->saved_msrs.array;
+	struct saved_msr *end = msr + ctxt->saved_msrs.num;
+
+	while (msr < end) {
+		msr->valid = !rdmsrl_safe(msr->info.msr_no, &msr->info.reg.q);
+		msr++;
+	}
+}
+
+static void msr_restore_context(struct saved_context *ctxt)
+{
+	struct saved_msr *msr = ctxt->saved_msrs.array;
+	struct saved_msr *end = msr + ctxt->saved_msrs.num;
+
+	while (msr < end) {
+		if (msr->valid)
+			wrmsrl(msr->info.msr_no, msr->info.reg.q);
+		msr++;
+	}
+}
+
 /**
  *	__save_processor_state - save CPU registers before creating a
  *		hibernation image and before restoring the memory state from it
@@ -111,6 +135,7 @@ static void __save_processor_state(struct saved_context *ctxt)
 #endif
 	ctxt->misc_enable_saved = !rdmsrl_safe(MSR_IA32_MISC_ENABLE,
 					       &ctxt->misc_enable);
+	msr_save_context(ctxt);
 }
 
 /* Needed by apm.c */
@@ -229,6 +254,7 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
 	x86_platform.restore_sched_clock_state();
 	mtrr_bp_restore();
 	perf_restore_debug_store();
+	msr_restore_context(ctxt);
 }
 
 /* Needed by apm.c */
@@ -320,3 +346,69 @@ static int __init bsp_pm_check_init(void)
 }
 
 core_initcall(bsp_pm_check_init);
+
+static int msr_init_context(const u32 *msr_id, const int total_num)
+{
+	int i = 0;
+	struct saved_msr *msr_array;
+
+	if (saved_context.saved_msrs.array || saved_context.saved_msrs.num > 0) {
+		pr_err("x86/pm: MSR quirk already applied, please check your DMI match table.\n");
+		return -EINVAL;
+	}
+
+	msr_array = kmalloc_array(total_num, sizeof(struct saved_msr), GFP_KERNEL);
+	if (!msr_array) {
+		pr_err("x86/pm: Can not allocate memory to save/restore MSRs during suspend.\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < total_num; i++) {
+		msr_array[i].info.msr_no	= msr_id[i];
+		msr_array[i].valid		= false;
+		msr_array[i].info.reg.q		= 0;
+	}
+	saved_context.saved_msrs.num	= total_num;
+	saved_context.saved_msrs.array	= msr_array;
+
+	return 0;
+}
+
+/*
+ * The following section is a quirk framework for problematic BIOSen:
+ * Sometimes MSRs are modified by the BIOSen after suspended to
+ * RAM, this might cause unexpected behavior after wakeup.
+ * Thus we save/restore these specified MSRs across suspend/resume
+ * in order to work around it.
+ *
+ * For any further problematic BIOSen/platforms,
+ * please add your own function similar to msr_initialize_bdw.
+ */
+static int msr_initialize_bdw(const struct dmi_system_id *d)
+{
+	/* Add any extra MSR ids into this array. */
+	u32 bdw_msr_id[] = { MSR_IA32_THERM_CONTROL };
+
+	pr_info("x86/pm: %s detected, MSR saving is needed during suspending.\n", d->ident);
+	return msr_init_context(bdw_msr_id, ARRAY_SIZE(bdw_msr_id));
+}
+
+static struct dmi_system_id msr_save_dmi_table[] = {
+	{
+	 .callback = msr_initialize_bdw,
+	 .ident = "BROADWELL BDX_EP",
+	 .matches = {
+		DMI_MATCH(DMI_PRODUCT_NAME, "GRANTLEY"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "E63448-400"),
+		},
+	},
+	{}
+};
+
+static int pm_check_save_msr(void)
+{
+	dmi_check_system(msr_save_dmi_table);
+	return 0;
+}
+
+device_initcall(pm_check_save_msr);
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF51D1F2E47
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgFIAka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729206AbgFHXNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D77AF208C7;
        Mon,  8 Jun 2020 23:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657981;
        bh=ykA2/1B6WlQZ3TXxlaaNUqKEm5FMxSR7j0S3cwhJ6Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADKYFVZe8XuzibmgVvYqd1ZF5DH2wVEwOI0JxgwuwfXbvwsi9eGV1qS40aH1c7dmM
         FZd3oAHFc9KjMGAxMooxYYNDrEVa1KZ0sgdG89IcweTqUMpIXcU6mjWOamVrsp2bxc
         XpaMxvHc6ahoV5zdcWtxb1AG/GEbuczUvr1XaZzM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        xen-devel@lists.xenproject.org, linux-sparse@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 042/606] x86: Fix early boot crash on gcc-10, third try
Date:   Mon,  8 Jun 2020 19:02:47 -0400
Message-Id: <20200608231211.3363633-42-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit a9a3ed1eff3601b63aea4fb462d8b3b92c7c1e7e upstream.

... or the odyssey of trying to disable the stack protector for the
function which generates the stack canary value.

The whole story started with Sergei reporting a boot crash with a kernel
built with gcc-10:

  Kernel panic — not syncing: stack-protector: Kernel stack is corrupted in: start_secondary
  CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.6.0-rc5—00235—gfffb08b37df9 #139
  Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./H77M—D3H, BIOS F12 11/14/2013
  Call Trace:
    dump_stack
    panic
    ? start_secondary
    __stack_chk_fail
    start_secondary
    secondary_startup_64
  -—-[ end Kernel panic — not syncing: stack—protector: Kernel stack is corrupted in: start_secondary

This happens because gcc-10 tail-call optimizes the last function call
in start_secondary() - cpu_startup_entry() - and thus emits a stack
canary check which fails because the canary value changes after the
boot_init_stack_canary() call.

To fix that, the initial attempt was to mark the one function which
generates the stack canary with:

  __attribute__((optimize("-fno-stack-protector"))) ... start_secondary(void *unused)

however, using the optimize attribute doesn't work cumulatively
as the attribute does not add to but rather replaces previously
supplied optimization options - roughly all -fxxx options.

The key one among them being -fno-omit-frame-pointer and thus leading to
not present frame pointer - frame pointer which the kernel needs.

The next attempt to prevent compilers from tail-call optimizing
the last function call cpu_startup_entry(), shy of carving out
start_secondary() into a separate compilation unit and building it with
-fno-stack-protector, was to add an empty asm("").

This current solution was short and sweet, and reportedly, is supported
by both compilers but we didn't get very far this time: future (LTO?)
optimization passes could potentially eliminate this, which leads us
to the third attempt: having an actual memory barrier there which the
compiler cannot ignore or move around etc.

That should hold for a long time, but hey we said that about the other
two solutions too so...

Reported-by: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Kalle Valo <kvalo@codeaurora.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200314164451.346497-1-slyfox@gentoo.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/stackprotector.h | 7 ++++++-
 arch/x86/kernel/smpboot.c             | 8 ++++++++
 arch/x86/xen/smp_pv.c                 | 1 +
 include/linux/compiler.h              | 6 ++++++
 init/main.c                           | 2 ++
 5 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
index 91e29b6a86a5..9804a7957f4e 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -55,8 +55,13 @@
 /*
  * Initialize the stackprotector canary value.
  *
- * NOTE: this must only be called from functions that never return,
+ * NOTE: this must only be called from functions that never return
  * and it must always be inlined.
+ *
+ * In addition, it should be called from a compilation unit for which
+ * stack protector is disabled. Alternatively, the caller should not end
+ * with a function call which gets tail-call optimized as that would
+ * lead to checking a modified canary value.
  */
 static __always_inline void boot_init_stack_canary(void)
 {
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 69881b2d446c..9674321ce3a3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -262,6 +262,14 @@ static void notrace start_secondary(void *unused)
 
 	wmb();
 	cpu_startup_entry(CPUHP_AP_ONLINE_IDLE);
+
+	/*
+	 * Prevent tail call to cpu_startup_entry() because the stack protector
+	 * guard has been changed a couple of function calls up, in
+	 * boot_init_stack_canary() and must not be checked before tail calling
+	 * another function.
+	 */
+	prevent_tail_call_optimization();
 }
 
 /**
diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
index 802ee5bba66c..0cebe5db691d 100644
--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -92,6 +92,7 @@ asmlinkage __visible void cpu_bringup_and_idle(void)
 	cpu_bringup();
 	boot_init_stack_canary();
 	cpu_startup_entry(CPUHP_AP_ONLINE_IDLE);
+	prevent_tail_call_optimization();
 }
 
 void xen_smp_intr_free_pv(unsigned int cpu)
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 034b0a644efc..448c91bf543b 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -356,4 +356,10 @@ static inline void *offset_to_ptr(const int *off)
 /* &a[0] degrades to a pointer: a different type from an array */
 #define __must_be_array(a)	BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
 
+/*
+ * This is needed in functions which generate the stack canary, see
+ * arch/x86/kernel/smpboot.c::start_secondary() for an example.
+ */
+#define prevent_tail_call_optimization()	mb()
+
 #endif /* __LINUX_COMPILER_H */
diff --git a/init/main.c b/init/main.c
index 8ee04f875b21..6bcad75d60ad 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1032,6 +1032,8 @@ asmlinkage __visible void __init start_kernel(void)
 
 	/* Do the rest non-__init'ed, we're now alive */
 	arch_call_rest_init();
+
+	prevent_tail_call_optimization();
 }
 
 /* Call all constructor functions linked into the kernel. */
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059E4419C62
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237826AbhI0R2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:28:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236568AbhI0R0R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:26:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1DB861157;
        Mon, 27 Sep 2021 17:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762996;
        bh=nF4tYFCGbBcq9OnzxHtMrTvaPMOB0MOgDMZS6RCA+3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Dl8rr2y1XzEimZBIqjIa7lu4GUPME9K9egVQAOMXY7Z/7FreEMVELTjCn6YKdR9B
         s97ehmcdHtS6hjvHdlYtMneejeyI74N+t/XJSkCnmf5oznL8Ji8D5bOw4oo1I4LgTF
         ChxizN1kIHAfccfKPrGZ3XCImuWDZV6ZLiXYOZAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jiashuo Liang <liangjs@pku.edu.cn>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 097/162] x86/fault: Fix wrong signal when vsyscall fails with pkey
Date:   Mon, 27 Sep 2021 19:02:23 +0200
Message-Id: <20210927170236.803732537@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiashuo Liang <liangjs@pku.edu.cn>

[ Upstream commit d4ffd5df9d18031b6a53f934388726775b4452d3 ]

The function __bad_area_nosemaphore() calls kernelmode_fixup_or_oops()
with the parameter @signal being actually @pkey, which will send a
signal numbered with the argument in @pkey.

This bug can be triggered when the kernel fails to access user-given
memory pages that are protected by a pkey, so it can go down the
do_user_addr_fault() path and pass the !user_mode() check in
__bad_area_nosemaphore().

Most cases will simply run the kernel fixup code to make an -EFAULT. But
when another condition current->thread.sig_on_uaccess_err is met, which
is only used to emulate vsyscall, the kernel will generate the wrong
signal.

Add a new parameter @pkey to kernelmode_fixup_or_oops() to fix this.

 [ bp: Massage commit message, fix build error as reported by the 0day
   bot: https://lkml.kernel.org/r/202109202245.APvuT8BX-lkp@intel.com ]

Fixes: 5042d40a264c ("x86/fault: Bypass no_context() for implicit kernel faults from usermode")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jiashuo Liang <liangjs@pku.edu.cn>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lkml.kernel.org/r/20210730030152.249106-1-liangjs@pku.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/pkeys.h |  2 --
 arch/x86/mm/fault.c          | 26 ++++++++++++++++++--------
 include/linux/pkeys.h        |  2 ++
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/pkeys.h b/arch/x86/include/asm/pkeys.h
index 5c7bcaa79623..1d5f14aff5f6 100644
--- a/arch/x86/include/asm/pkeys.h
+++ b/arch/x86/include/asm/pkeys.h
@@ -2,8 +2,6 @@
 #ifndef _ASM_X86_PKEYS_H
 #define _ASM_X86_PKEYS_H
 
-#define ARCH_DEFAULT_PKEY	0
-
 /*
  * If more than 16 keys are ever supported, a thorough audit
  * will be necessary to ensure that the types that store key
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index b2eefdefc108..84a2c8c4af73 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -710,7 +710,8 @@ oops:
 
 static noinline void
 kernelmode_fixup_or_oops(struct pt_regs *regs, unsigned long error_code,
-			 unsigned long address, int signal, int si_code)
+			 unsigned long address, int signal, int si_code,
+			 u32 pkey)
 {
 	WARN_ON_ONCE(user_mode(regs));
 
@@ -735,8 +736,12 @@ kernelmode_fixup_or_oops(struct pt_regs *regs, unsigned long error_code,
 
 			set_signal_archinfo(address, error_code);
 
-			/* XXX: hwpoison faults will set the wrong code. */
-			force_sig_fault(signal, si_code, (void __user *)address);
+			if (si_code == SEGV_PKUERR) {
+				force_sig_pkuerr((void __user *)address, pkey);
+			} else {
+				/* XXX: hwpoison faults will set the wrong code. */
+				force_sig_fault(signal, si_code, (void __user *)address);
+			}
 		}
 
 		/*
@@ -798,7 +803,8 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 	struct task_struct *tsk = current;
 
 	if (!user_mode(regs)) {
-		kernelmode_fixup_or_oops(regs, error_code, address, pkey, si_code);
+		kernelmode_fixup_or_oops(regs, error_code, address,
+					 SIGSEGV, si_code, pkey);
 		return;
 	}
 
@@ -930,7 +936,8 @@ do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 {
 	/* Kernel mode? Handle exceptions or die: */
 	if (!user_mode(regs)) {
-		kernelmode_fixup_or_oops(regs, error_code, address, SIGBUS, BUS_ADRERR);
+		kernelmode_fixup_or_oops(regs, error_code, address,
+					 SIGBUS, BUS_ADRERR, ARCH_DEFAULT_PKEY);
 		return;
 	}
 
@@ -1396,7 +1403,8 @@ good_area:
 		 */
 		if (!user_mode(regs))
 			kernelmode_fixup_or_oops(regs, error_code, address,
-						 SIGBUS, BUS_ADRERR);
+						 SIGBUS, BUS_ADRERR,
+						 ARCH_DEFAULT_PKEY);
 		return;
 	}
 
@@ -1416,7 +1424,8 @@ good_area:
 		return;
 
 	if (fatal_signal_pending(current) && !user_mode(regs)) {
-		kernelmode_fixup_or_oops(regs, error_code, address, 0, 0);
+		kernelmode_fixup_or_oops(regs, error_code, address,
+					 0, 0, ARCH_DEFAULT_PKEY);
 		return;
 	}
 
@@ -1424,7 +1433,8 @@ good_area:
 		/* Kernel mode? Handle exceptions or die: */
 		if (!user_mode(regs)) {
 			kernelmode_fixup_or_oops(regs, error_code, address,
-						 SIGSEGV, SEGV_MAPERR);
+						 SIGSEGV, SEGV_MAPERR,
+						 ARCH_DEFAULT_PKEY);
 			return;
 		}
 
diff --git a/include/linux/pkeys.h b/include/linux/pkeys.h
index 6beb26b7151d..86be8bf27b41 100644
--- a/include/linux/pkeys.h
+++ b/include/linux/pkeys.h
@@ -4,6 +4,8 @@
 
 #include <linux/mm.h>
 
+#define ARCH_DEFAULT_PKEY	0
+
 #ifdef CONFIG_ARCH_HAS_PKEYS
 #include <asm/pkeys.h>
 #else /* ! CONFIG_ARCH_HAS_PKEYS */
-- 
2.33.0




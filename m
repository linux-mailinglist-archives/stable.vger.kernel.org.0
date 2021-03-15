Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D19333B5A9
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhCONy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:54:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231526AbhCONye (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CFB464EB6;
        Mon, 15 Mar 2021 13:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816474;
        bh=T7ZrGeX8hsbf+v85uuoBIHKdHNf/WAAoIPNnPoTbO94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ui3oZurA5PbccnPAa38m1pdibZHEpbT2X+OcGjuNvGDBWurYqnkt4o60vt98VQjG5
         Li3voRXll0mBLL4WES7ZKxVw3utY4wpuKhS29/Z1Ih8+JjOZdZJ3Xa8Xa1fRH9bOq+
         T/GE4gb/Sn297sYYhWfDsMMpYQHWTAm5T9Z98fzc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 65/75] alpha: move exports to actual definitions
Date:   Mon, 15 Mar 2021 14:52:19 +0100
Message-Id: <20210315135210.385306659@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Al Viro <viro@zeniv.linux.org.uk>

commit 00fc0e0dda6286407f3854cd71a125f519a5689c upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/include/asm/Kbuild        |    1 
 arch/alpha/kernel/Makefile           |    2 
 arch/alpha/kernel/alpha_ksyms.c      |  102 -----------------------------------
 arch/alpha/kernel/machvec_impl.h     |    6 +-
 arch/alpha/kernel/setup.c            |    1 
 arch/alpha/lib/callback_srm.S        |    5 +
 arch/alpha/lib/checksum.c            |    3 +
 arch/alpha/lib/clear_page.S          |    3 -
 arch/alpha/lib/clear_user.S          |    2 
 arch/alpha/lib/copy_page.S           |    3 -
 arch/alpha/lib/copy_user.S           |    3 +
 arch/alpha/lib/csum_ipv6_magic.S     |    2 
 arch/alpha/lib/csum_partial_copy.c   |    2 
 arch/alpha/lib/dec_and_lock.c        |    2 
 arch/alpha/lib/divide.S              |    3 +
 arch/alpha/lib/ev6-clear_page.S      |    3 -
 arch/alpha/lib/ev6-clear_user.S      |    3 -
 arch/alpha/lib/ev6-copy_page.S       |    3 -
 arch/alpha/lib/ev6-copy_user.S       |    3 -
 arch/alpha/lib/ev6-csum_ipv6_magic.S |    2 
 arch/alpha/lib/ev6-divide.S          |    3 +
 arch/alpha/lib/ev6-memchr.S          |    3 -
 arch/alpha/lib/ev6-memcpy.S          |    3 -
 arch/alpha/lib/ev6-memset.S          |    7 ++
 arch/alpha/lib/ev67-strcat.S         |    3 -
 arch/alpha/lib/ev67-strchr.S         |    3 -
 arch/alpha/lib/ev67-strlen.S         |    3 -
 arch/alpha/lib/ev67-strncat.S        |    3 -
 arch/alpha/lib/ev67-strrchr.S        |    3 -
 arch/alpha/lib/fpreg.c               |    7 ++
 arch/alpha/lib/memchr.S              |    3 -
 arch/alpha/lib/memcpy.c              |    5 -
 arch/alpha/lib/memmove.S             |    3 -
 arch/alpha/lib/memset.S              |    7 ++
 arch/alpha/lib/strcat.S              |    2 
 arch/alpha/lib/strchr.S              |    3 -
 arch/alpha/lib/strcpy.S              |    3 -
 arch/alpha/lib/strlen.S              |    3 -
 arch/alpha/lib/strncat.S             |    3 -
 arch/alpha/lib/strncpy.S             |    3 -
 arch/alpha/lib/strrchr.S             |    3 -
 41 files changed, 99 insertions(+), 131 deletions(-)
 delete mode 100644 arch/alpha/kernel/alpha_ksyms.c

--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -3,6 +3,7 @@
 generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += exec.h
+generic-y += export.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += mm-arch-hooks.h
--- a/arch/alpha/kernel/Makefile
+++ b/arch/alpha/kernel/Makefile
@@ -8,7 +8,7 @@ ccflags-y	:= -Wno-sign-compare
 
 obj-y    := entry.o traps.o process.o osf_sys.o irq.o \
 	    irq_alpha.o signal.o setup.o ptrace.o time.o \
-	    alpha_ksyms.o systbls.o err_common.o io.o
+	    systbls.o err_common.o io.o
 
 obj-$(CONFIG_VGA_HOSE)	+= console.o
 obj-$(CONFIG_SMP)	+= smp.o
--- a/arch/alpha/kernel/alpha_ksyms.c
+++ /dev/null
@@ -1,102 +0,0 @@
-/*
- * linux/arch/alpha/kernel/alpha_ksyms.c
- *
- * Export the alpha-specific functions that are needed for loadable
- * modules.
- */
-
-#include <linux/module.h>
-#include <asm/console.h>
-#include <asm/uaccess.h>
-#include <asm/checksum.h>
-#include <asm/fpu.h>
-#include <asm/machvec.h>
-
-#include <linux/syscalls.h>
-
-/* these are C runtime functions with special calling conventions: */
-extern void __divl (void);
-extern void __reml (void);
-extern void __divq (void);
-extern void __remq (void);
-extern void __divlu (void);
-extern void __remlu (void);
-extern void __divqu (void);
-extern void __remqu (void);
-
-EXPORT_SYMBOL(alpha_mv);
-EXPORT_SYMBOL(callback_getenv);
-EXPORT_SYMBOL(callback_setenv);
-EXPORT_SYMBOL(callback_save_env);
-
-/* platform dependent support */
-EXPORT_SYMBOL(strcat);
-EXPORT_SYMBOL(strcpy);
-EXPORT_SYMBOL(strlen);
-EXPORT_SYMBOL(strncpy);
-EXPORT_SYMBOL(strncat);
-EXPORT_SYMBOL(strchr);
-EXPORT_SYMBOL(strrchr);
-EXPORT_SYMBOL(memmove);
-EXPORT_SYMBOL(__memcpy);
-EXPORT_SYMBOL(__memset);
-EXPORT_SYMBOL(___memset);
-EXPORT_SYMBOL(__memsetw);
-EXPORT_SYMBOL(__constant_c_memset);
-EXPORT_SYMBOL(copy_page);
-EXPORT_SYMBOL(clear_page);
-
-EXPORT_SYMBOL(alpha_read_fp_reg);
-EXPORT_SYMBOL(alpha_read_fp_reg_s);
-EXPORT_SYMBOL(alpha_write_fp_reg);
-EXPORT_SYMBOL(alpha_write_fp_reg_s);
-
-/* Networking helper routines. */
-EXPORT_SYMBOL(csum_tcpudp_magic);
-EXPORT_SYMBOL(ip_compute_csum);
-EXPORT_SYMBOL(ip_fast_csum);
-EXPORT_SYMBOL(csum_partial_copy_nocheck);
-EXPORT_SYMBOL(csum_partial_copy_from_user);
-EXPORT_SYMBOL(csum_ipv6_magic);
-
-#ifdef CONFIG_MATHEMU_MODULE
-extern long (*alpha_fp_emul_imprecise)(struct pt_regs *, unsigned long);
-extern long (*alpha_fp_emul) (unsigned long pc);
-EXPORT_SYMBOL(alpha_fp_emul_imprecise);
-EXPORT_SYMBOL(alpha_fp_emul);
-#endif
-
-/*
- * The following are specially called from the uaccess assembly stubs.
- */
-EXPORT_SYMBOL(__copy_user);
-EXPORT_SYMBOL(__do_clear_user);
-
-/* 
- * SMP-specific symbols.
- */
-
-#ifdef CONFIG_SMP
-EXPORT_SYMBOL(_atomic_dec_and_lock);
-#endif /* CONFIG_SMP */
-
-/*
- * The following are special because they're not called
- * explicitly (the C compiler or assembler generates them in
- * response to division operations).  Fortunately, their
- * interface isn't gonna change any time soon now, so it's OK
- * to leave it out of version control.
- */
-# undef memcpy
-# undef memset
-EXPORT_SYMBOL(__divl);
-EXPORT_SYMBOL(__divlu);
-EXPORT_SYMBOL(__divq);
-EXPORT_SYMBOL(__divqu);
-EXPORT_SYMBOL(__reml);
-EXPORT_SYMBOL(__remlu);
-EXPORT_SYMBOL(__remq);
-EXPORT_SYMBOL(__remqu);
-EXPORT_SYMBOL(memcpy);
-EXPORT_SYMBOL(memset);
-EXPORT_SYMBOL(memchr);
--- a/arch/alpha/kernel/machvec_impl.h
+++ b/arch/alpha/kernel/machvec_impl.h
@@ -144,9 +144,11 @@
    else beforehand.  Fine.  We'll do it ourselves.  */
 #if 0
 #define ALIAS_MV(system) \
-  struct alpha_machine_vector alpha_mv __attribute__((alias(#system "_mv")));
+  struct alpha_machine_vector alpha_mv __attribute__((alias(#system "_mv"))); \
+  EXPORT_SYMBOL(alpha_mv);
 #else
 #define ALIAS_MV(system) \
-  asm(".global alpha_mv\nalpha_mv = " #system "_mv");
+  asm(".global alpha_mv\nalpha_mv = " #system "_mv"); \
+  EXPORT_SYMBOL(alpha_mv);
 #endif
 #endif /* GENERIC */
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -115,6 +115,7 @@ unsigned long alpha_agpgart_size = DEFAU
 
 #ifdef CONFIG_ALPHA_GENERIC
 struct alpha_machine_vector alpha_mv;
+EXPORT_SYMBOL(alpha_mv);
 #endif
 
 #ifndef alpha_using_srm
--- a/arch/alpha/lib/callback_srm.S
+++ b/arch/alpha/lib/callback_srm.S
@@ -3,6 +3,7 @@
  */
 
 #include <asm/console.h>
+#include <asm/export.h>
 
 .text
 #define HWRPB_CRB_OFFSET 0xc0
@@ -92,6 +93,10 @@ CALLBACK(reset_env, CCB_RESET_ENV, 4)
 CALLBACK(save_env, CCB_SAVE_ENV, 1)
 CALLBACK(pswitch, CCB_PSWITCH, 3)
 CALLBACK(bios_emul, CCB_BIOS_EMUL, 5)
+
+EXPORT_SYMBOL(callback_getenv)
+EXPORT_SYMBOL(callback_setenv)
+EXPORT_SYMBOL(callback_save_env)
 	
 .data
 __alpha_using_srm:		# For use by bootpheader
--- a/arch/alpha/lib/checksum.c
+++ b/arch/alpha/lib/checksum.c
@@ -50,6 +50,7 @@ __sum16 csum_tcpudp_magic(__be32 saddr,
 		(__force u64)saddr + (__force u64)daddr +
 		(__force u64)sum + ((len + proto) << 8));
 }
+EXPORT_SYMBOL(csum_tcpudp_magic);
 
 __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
 				   unsigned short len,
@@ -148,6 +149,7 @@ __sum16 ip_fast_csum(const void *iph, un
 {
 	return (__force __sum16)~do_csum(iph,ihl*4);
 }
+EXPORT_SYMBOL(ip_fast_csum);
 
 /*
  * computes the checksum of a memory block at buff, length len,
@@ -182,3 +184,4 @@ __sum16 ip_compute_csum(const void *buff
 {
 	return (__force __sum16)~from64to16(do_csum(buff,len));
 }
+EXPORT_SYMBOL(ip_compute_csum);
--- a/arch/alpha/lib/clear_page.S
+++ b/arch/alpha/lib/clear_page.S
@@ -3,7 +3,7 @@
  *
  * Zero an entire page.
  */
-
+#include <asm/export.h>
 	.text
 	.align 4
 	.global clear_page
@@ -37,3 +37,4 @@ clear_page:
 	nop
 
 	.end clear_page
+	EXPORT_SYMBOL(clear_page)
--- a/arch/alpha/lib/clear_user.S
+++ b/arch/alpha/lib/clear_user.S
@@ -24,6 +24,7 @@
  * Clobbers:
  *	$1,$2,$3,$4,$5,$6
  */
+#include <asm/export.h>
 
 /* Allow an exception for an insn; exit if we get one.  */
 #define EX(x,y...)			\
@@ -111,3 +112,4 @@ $exception:
 	ret	$31, ($28), 1	# .. e1 :
 
 	.end __do_clear_user
+	EXPORT_SYMBOL(__do_clear_user)
--- a/arch/alpha/lib/copy_page.S
+++ b/arch/alpha/lib/copy_page.S
@@ -3,7 +3,7 @@
  *
  * Copy an entire page.
  */
-
+#include <asm/export.h>
 	.text
 	.align 4
 	.global copy_page
@@ -47,3 +47,4 @@ copy_page:
 	nop
 
 	.end copy_page
+	EXPORT_SYMBOL(copy_page)
--- a/arch/alpha/lib/copy_user.S
+++ b/arch/alpha/lib/copy_user.S
@@ -26,6 +26,8 @@
  *	$1,$2,$3,$4,$5,$6,$7
  */
 
+#include <asm/export.h>
+
 /* Allow an exception for an insn; exit if we get one.  */
 #define EXI(x,y...)			\
 	99: x,##y;			\
@@ -143,3 +145,4 @@ $101:
 	ret $31,($28),1
 
 	.end __copy_user
+EXPORT_SYMBOL(__copy_user)
--- a/arch/alpha/lib/csum_ipv6_magic.S
+++ b/arch/alpha/lib/csum_ipv6_magic.S
@@ -12,6 +12,7 @@
  * added by Ivan Kokshaysky <ink@jurassic.park.msu.ru>
  */
 
+#include <asm/export.h>
 	.globl csum_ipv6_magic
 	.align 4
 	.ent csum_ipv6_magic
@@ -113,3 +114,4 @@ csum_ipv6_magic:
 	ret			# .. e1 :
 
 	.end csum_ipv6_magic
+	EXPORT_SYMBOL(csum_ipv6_magic)
--- a/arch/alpha/lib/csum_partial_copy.c
+++ b/arch/alpha/lib/csum_partial_copy.c
@@ -374,6 +374,7 @@ csum_partial_copy_from_user(const void _
 	}
 	return (__force __wsum)checksum;
 }
+EXPORT_SYMBOL(csum_partial_copy_from_user);
 
 __wsum
 csum_partial_copy_nocheck(const void *src, void *dst, int len, __wsum sum)
@@ -386,3 +387,4 @@ csum_partial_copy_nocheck(const void *sr
 	set_fs(oldfs);
 	return checksum;
 }
+EXPORT_SYMBOL(csum_partial_copy_nocheck);
--- a/arch/alpha/lib/dec_and_lock.c
+++ b/arch/alpha/lib/dec_and_lock.c
@@ -7,6 +7,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/atomic.h>
+#include <linux/export.h>
 
   asm (".text					\n\
 	.global _atomic_dec_and_lock		\n\
@@ -39,3 +40,4 @@ static int __used atomic_dec_and_lock_1(
 	spin_unlock(lock);
 	return 0;
 }
+EXPORT_SYMBOL(_atomic_dec_and_lock);
--- a/arch/alpha/lib/divide.S
+++ b/arch/alpha/lib/divide.S
@@ -45,6 +45,7 @@
  *	$28 - compare status
  */
 
+#include <asm/export.h>
 #define halt .long 0
 
 /*
@@ -151,6 +152,7 @@ ufunction:
 	addq	$30,STACK,$30
 	ret	$31,($23),1
 	.end	ufunction
+EXPORT_SYMBOL(ufunction)
 
 /*
  * Uhh.. Ugly signed division. I'd rather not have it at all, but
@@ -193,3 +195,4 @@ sfunction:
 	addq	$30,STACK,$30
 	ret	$31,($23),1
 	.end	sfunction
+EXPORT_SYMBOL(sfunction)
--- a/arch/alpha/lib/ev6-clear_page.S
+++ b/arch/alpha/lib/ev6-clear_page.S
@@ -3,7 +3,7 @@
  *
  * Zero an entire page.
  */
-
+#include <asm/export.h>
         .text
         .align 4
         .global clear_page
@@ -52,3 +52,4 @@ clear_page:
 	nop
 
 	.end clear_page
+	EXPORT_SYMBOL(clear_page)
--- a/arch/alpha/lib/ev6-clear_user.S
+++ b/arch/alpha/lib/ev6-clear_user.S
@@ -43,6 +43,7 @@
  *	want to leave a hole (and we also want to avoid repeating lots of work)
  */
 
+#include <asm/export.h>
 /* Allow an exception for an insn; exit if we get one.  */
 #define EX(x,y...)			\
 	99: x,##y;			\
@@ -222,4 +223,4 @@ $exception:			# Destination for exceptio
 	nop			# .. E  .. ..	:
 	ret	$31, ($28), 1	# L0 .. .. ..	: L U L U
 	.end __do_clear_user
-
+	EXPORT_SYMBOL(__do_clear_user)
--- a/arch/alpha/lib/ev6-copy_page.S
+++ b/arch/alpha/lib/ev6-copy_page.S
@@ -56,7 +56,7 @@
    destination pages are in the dcache, but it is my guess that this is
    less important than the dcache miss case.  */
 
-
+#include <asm/export.h>
 	.text
 	.align 4
 	.global copy_page
@@ -201,3 +201,4 @@ copy_page:
 	nop
 
 	.end copy_page
+	EXPORT_SYMBOL(copy_page)
--- a/arch/alpha/lib/ev6-copy_user.S
+++ b/arch/alpha/lib/ev6-copy_user.S
@@ -37,6 +37,7 @@
  *	L	- lower subcluster; L0 - subcluster L0; L1 - subcluster L1
  */
 
+#include <asm/export.h>
 /* Allow an exception for an insn; exit if we get one.  */
 #define EXI(x,y...)			\
 	99: x,##y;			\
@@ -256,4 +257,4 @@ $101:
 	ret $31,($28),1		# L0
 
 	.end __copy_user
-
+	EXPORT_SYMBOL(__copy_user)
--- a/arch/alpha/lib/ev6-csum_ipv6_magic.S
+++ b/arch/alpha/lib/ev6-csum_ipv6_magic.S
@@ -52,6 +52,7 @@
  * may cause additional delay in rare cases (load-load replay traps).
  */
 
+#include <asm/export.h>
 	.globl csum_ipv6_magic
 	.align 4
 	.ent csum_ipv6_magic
@@ -148,3 +149,4 @@ csum_ipv6_magic:
 	ret			# L0 : L U L U
 
 	.end csum_ipv6_magic
+	EXPORT_SYMBOL(csum_ipv6_magic)
--- a/arch/alpha/lib/ev6-divide.S
+++ b/arch/alpha/lib/ev6-divide.S
@@ -55,6 +55,7 @@
  * Try not to change the actual algorithm if possible for consistency.
  */
 
+#include <asm/export.h>
 #define halt .long 0
 
 /*
@@ -205,6 +206,7 @@ ufunction:
 	addq	$30,STACK,$30		# E :
 	ret	$31,($23),1		# L0 : L U U L
 	.end	ufunction
+EXPORT_SYMBOL(ufunction)
 
 /*
  * Uhh.. Ugly signed division. I'd rather not have it at all, but
@@ -257,3 +259,4 @@ sfunction:
 	addq	$30,STACK,$30		# E :
 	ret	$31,($23),1		# L0 : L U U L
 	.end	sfunction
+EXPORT_SYMBOL(sfunction)
--- a/arch/alpha/lib/ev6-memchr.S
+++ b/arch/alpha/lib/ev6-memchr.S
@@ -27,7 +27,7 @@
  *	L	- lower subcluster; L0 - subcluster L0; L1 - subcluster L1
  * Try not to change the actual algorithm if possible for consistency.
  */
-
+#include <asm/export.h>
         .set noreorder
         .set noat
 
@@ -189,3 +189,4 @@ $not_found:
 	ret			# L0 :
 
         .end memchr
+	EXPORT_SYMBOL(memchr)
--- a/arch/alpha/lib/ev6-memcpy.S
+++ b/arch/alpha/lib/ev6-memcpy.S
@@ -19,7 +19,7 @@
  * Temp usage notes:
  *	$1,$2,		- scratch
  */
-
+#include <asm/export.h>
 	.set noreorder
 	.set noat
 
@@ -242,6 +242,7 @@ $nomoredata:
 	nop				# E :
 
 	.end memcpy
+	EXPORT_SYMBOL(memcpy)
 
 /* For backwards module compatibility.  */
 __memcpy = memcpy
--- a/arch/alpha/lib/ev6-memset.S
+++ b/arch/alpha/lib/ev6-memset.S
@@ -26,7 +26,7 @@
  * as fixes will need to be made in multiple places.  The performance gain
  * is worth it.
  */
-
+#include <asm/export.h>
 	.set noat
 	.set noreorder
 .text
@@ -229,6 +229,7 @@ end_b:
 	nop
 	ret $31,($26),1		# L0 :
 	.end ___memset
+	EXPORT_SYMBOL(___memset)
 
 	/*
 	 * This is the original body of code, prior to replication and
@@ -406,6 +407,7 @@ end:
 	nop
 	ret $31,($26),1		# L0 :
 	.end __constant_c_memset
+	EXPORT_SYMBOL(__constant_c_memset)
 
 	/*
 	 * This is a replicant of the __constant_c_memset code, rescheduled
@@ -594,6 +596,9 @@ end_w:
 	ret $31,($26),1		# L0 :
 
 	.end __memsetw
+	EXPORT_SYMBOL(__memsetw)
 
 memset = ___memset
 __memset = ___memset
+	EXPORT_SYMBOL(memset)
+	EXPORT_SYMBOL(__memset)
--- a/arch/alpha/lib/ev67-strcat.S
+++ b/arch/alpha/lib/ev67-strcat.S
@@ -19,7 +19,7 @@
  * string once.
  */
 
-
+#include <asm/export.h>
 	.text
 
 	.align 4
@@ -52,3 +52,4 @@ $found:	cttz	$2, $3		# U0 :
 	br	__stxcpy	# L0 :
 
 	.end strcat
+	EXPORT_SYMBOL(strcat)
--- a/arch/alpha/lib/ev67-strchr.S
+++ b/arch/alpha/lib/ev67-strchr.S
@@ -15,7 +15,7 @@
  *	L	- lower subcluster; L0 - subcluster L0; L1 - subcluster L1
  * Try not to change the actual algorithm if possible for consistency.
  */
-
+#include <asm/export.h>
 #include <asm/regdef.h>
 
 	.set noreorder
@@ -86,3 +86,4 @@ $found:	negq    t0, t1		# E : clear all
 	ret			# L0 :
 
 	.end strchr
+	EXPORT_SYMBOL(strchr)
--- a/arch/alpha/lib/ev67-strlen.S
+++ b/arch/alpha/lib/ev67-strlen.S
@@ -17,7 +17,7 @@
  *	U	- upper subcluster; U0 - subcluster U0; U1 - subcluster U1
  *	L	- lower subcluster; L0 - subcluster L0; L1 - subcluster L1
  */
-
+#include <asm/export.h>
 	.set noreorder
 	.set noat
 
@@ -47,3 +47,4 @@ $found:
 	ret	$31, ($26)	# L0 :
 
 	.end	strlen
+	EXPORT_SYMBOL(strlen)
--- a/arch/alpha/lib/ev67-strncat.S
+++ b/arch/alpha/lib/ev67-strncat.S
@@ -20,7 +20,7 @@
  * Try not to change the actual algorithm if possible for consistency.
  */
 
-
+#include <asm/export.h>
 	.text
 
 	.align 4
@@ -92,3 +92,4 @@ $zerocount:
 	ret			# L0 :
 
 	.end strncat
+	EXPORT_SYMBOL(strncat)
--- a/arch/alpha/lib/ev67-strrchr.S
+++ b/arch/alpha/lib/ev67-strrchr.S
@@ -18,7 +18,7 @@
  *	L	- lower subcluster; L0 - subcluster L0; L1 - subcluster L1
  */
 
-
+#include <asm/export.h>
 #include <asm/regdef.h>
 
 	.set noreorder
@@ -107,3 +107,4 @@ $eos:
 	nop
 
 	.end strrchr
+	EXPORT_SYMBOL(strrchr)
--- a/arch/alpha/lib/fpreg.c
+++ b/arch/alpha/lib/fpreg.c
@@ -4,6 +4,9 @@
  * (C) Copyright 1998 Linus Torvalds
  */
 
+#include <linux/compiler.h>
+#include <linux/export.h>
+
 #if defined(CONFIG_ALPHA_EV6) || defined(CONFIG_ALPHA_EV67)
 #define STT(reg,val)  asm volatile ("ftoit $f"#reg",%0" : "=r"(val));
 #else
@@ -52,6 +55,7 @@ alpha_read_fp_reg (unsigned long reg)
 	}
 	return val;
 }
+EXPORT_SYMBOL(alpha_read_fp_reg);
 
 #if defined(CONFIG_ALPHA_EV6) || defined(CONFIG_ALPHA_EV67)
 #define LDT(reg,val)  asm volatile ("itoft %0,$f"#reg : : "r"(val));
@@ -97,6 +101,7 @@ alpha_write_fp_reg (unsigned long reg, u
 	      case 31: LDT(31, val); break;
 	}
 }
+EXPORT_SYMBOL(alpha_write_fp_reg);
 
 #if defined(CONFIG_ALPHA_EV6) || defined(CONFIG_ALPHA_EV67)
 #define STS(reg,val)  asm volatile ("ftois $f"#reg",%0" : "=r"(val));
@@ -146,6 +151,7 @@ alpha_read_fp_reg_s (unsigned long reg)
 	}
 	return val;
 }
+EXPORT_SYMBOL(alpha_read_fp_reg_s);
 
 #if defined(CONFIG_ALPHA_EV6) || defined(CONFIG_ALPHA_EV67)
 #define LDS(reg,val)  asm volatile ("itofs %0,$f"#reg : : "r"(val));
@@ -191,3 +197,4 @@ alpha_write_fp_reg_s (unsigned long reg,
 	      case 31: LDS(31, val); break;
 	}
 }
+EXPORT_SYMBOL(alpha_write_fp_reg_s);
--- a/arch/alpha/lib/memchr.S
+++ b/arch/alpha/lib/memchr.S
@@ -31,7 +31,7 @@ For correctness consider that:
       - only minimum number of quadwords may be accessed
       - the third argument is an unsigned long
 */
-
+#include <asm/export.h>
         .set noreorder
         .set noat
 
@@ -162,3 +162,4 @@ $not_found:
 	ret			# .. e1 :
 
         .end memchr
+	EXPORT_SYMBOL(memchr)
--- a/arch/alpha/lib/memcpy.c
+++ b/arch/alpha/lib/memcpy.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/export.h>
 
 /*
  * This should be done in one go with ldq_u*2/mask/stq_u. Do it
@@ -158,6 +159,4 @@ void * memcpy(void * dest, const void *s
 	__memcpy_unaligned_up ((unsigned long) dest, (unsigned long) src, n);
 	return dest;
 }
-
-/* For backward modules compatibility, define __memcpy.  */
-asm("__memcpy = memcpy; .globl __memcpy");
+EXPORT_SYMBOL(memcpy);
--- a/arch/alpha/lib/memmove.S
+++ b/arch/alpha/lib/memmove.S
@@ -6,7 +6,7 @@
  * This is hand-massaged output from the original memcpy.c.  We defer to
  * memcpy whenever possible; the backwards copy loops are not unrolled.
  */
-        
+#include <asm/export.h>
 	.set noat
 	.set noreorder
 	.text
@@ -179,3 +179,4 @@ $egress:
 	nop
 
 	.end memmove
+	EXPORT_SYMBOL(memmove)
--- a/arch/alpha/lib/memset.S
+++ b/arch/alpha/lib/memset.S
@@ -13,7 +13,7 @@
  * The scheduling comments are according to the EV5 documentation (and done by 
  * hand, so they might well be incorrect, please do tell me about it..)
  */
-
+#include <asm/export.h>
 	.set noat
 	.set noreorder
 .text
@@ -106,6 +106,8 @@ within_one_quad:
 end:
 	ret $31,($26),1		/* E1 */
 	.end ___memset
+EXPORT_SYMBOL(___memset)
+EXPORT_SYMBOL(__constant_c_memset)
 
 	.align 5
 	.ent __memsetw
@@ -122,6 +124,9 @@ __memsetw:
 	br __constant_c_memset	/* .. E1 */
 
 	.end __memsetw
+EXPORT_SYMBOL(__memsetw)
 
 memset = ___memset
 __memset = ___memset
+	EXPORT_SYMBOL(memset)
+	EXPORT_SYMBOL(__memset)
--- a/arch/alpha/lib/strcat.S
+++ b/arch/alpha/lib/strcat.S
@@ -4,6 +4,7 @@
  *
  * Append a null-terminated string from SRC to DST.
  */
+#include <asm/export.h>
 
 	.text
 
@@ -50,3 +51,4 @@ $found:	negq    $2, $3		# clear all but
 	br	__stxcpy
 
 	.end strcat
+EXPORT_SYMBOL(strcat);
--- a/arch/alpha/lib/strchr.S
+++ b/arch/alpha/lib/strchr.S
@@ -5,7 +5,7 @@
  * Return the address of a given character within a null-terminated
  * string, or null if it is not found.
  */
-
+#include <asm/export.h>
 #include <asm/regdef.h>
 
 	.set noreorder
@@ -68,3 +68,4 @@ $retnull:
 	ret			# .. e1 :
 
 	.end strchr
+	EXPORT_SYMBOL(strchr)
--- a/arch/alpha/lib/strcpy.S
+++ b/arch/alpha/lib/strcpy.S
@@ -5,7 +5,7 @@
  * Copy a null-terminated string from SRC to DST.  Return a pointer
  * to the null-terminator in the source.
  */
-
+#include <asm/export.h>
 	.text
 
 	.align 3
@@ -21,3 +21,4 @@ strcpy:
 	br	__stxcpy	# do the copy
 
 	.end strcpy
+	EXPORT_SYMBOL(strcpy)
--- a/arch/alpha/lib/strlen.S
+++ b/arch/alpha/lib/strlen.S
@@ -11,7 +11,7 @@
  *	  do this instead of the 9 instructions that
  *	  binary search needs).
  */
-
+#include <asm/export.h>
 	.set noreorder
 	.set noat
 
@@ -55,3 +55,4 @@ done:	subq	$0, $16, $0
 	ret	$31, ($26)
 
 	.end	strlen
+	EXPORT_SYMBOL(strlen)
--- a/arch/alpha/lib/strncat.S
+++ b/arch/alpha/lib/strncat.S
@@ -9,7 +9,7 @@
  * past count, whereas libc may write to count+1.  This follows the generic
  * implementation in lib/string.c and is, IMHO, more sensible.
  */
-
+#include <asm/export.h>
 	.text
 
 	.align 3
@@ -82,3 +82,4 @@ $zerocount:
 	ret
 
 	.end strncat
+	EXPORT_SYMBOL(strncat)
--- a/arch/alpha/lib/strncpy.S
+++ b/arch/alpha/lib/strncpy.S
@@ -10,7 +10,7 @@
  * version has cropped that bit o' nastiness as well as assuming that
  * __stxncpy is in range of a branch.
  */
-
+#include <asm/export.h>
 	.set noat
 	.set noreorder
 
@@ -79,3 +79,4 @@ $zerolen:
 	ret
 
 	.end	strncpy
+	EXPORT_SYMBOL(strncpy)
--- a/arch/alpha/lib/strrchr.S
+++ b/arch/alpha/lib/strrchr.S
@@ -5,7 +5,7 @@
  * Return the address of the last occurrence of a given character
  * within a null-terminated string, or null if it is not found.
  */
-
+#include <asm/export.h>
 #include <asm/regdef.h>
 
 	.set noreorder
@@ -85,3 +85,4 @@ $retnull:
 	ret			# .. e1 :
 
 	.end strrchr
+	EXPORT_SYMBOL(strrchr)



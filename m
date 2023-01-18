Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA5D671B14
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 12:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjARLpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 06:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjARLoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 06:44:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BA065EF3;
        Wed, 18 Jan 2023 03:05:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1089161785;
        Wed, 18 Jan 2023 11:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959DEC433D2;
        Wed, 18 Jan 2023 11:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674039920;
        bh=PqlOUcb6kMsC/l9XsrOc1kEtUk9H+bqRXAuJk9gRdYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0QPMzONn9BsGNurdsSU3L8aZFD9Kn2FcgUwlk9ehwiitPWG6eaSaDE8xJ+QDdvC48
         NebXuhVdOp2gBsHrAvT7qSHaNT5ZQAhi06A1IGHOlQkjrE3o3FYOjsle9NSGnYG5gE
         TmRF5ep5Yqcqs1pbNnS87E5EWq4T3xO6HDyPx0OE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.164
Date:   Wed, 18 Jan 2023 12:05:09 +0100
Message-Id: <1674039908235111@kroah.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <1674039908216189@kroah.com>
References: <1674039908216189@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index f577c29f2093..eb437d659f2c 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2103,24 +2103,57 @@
 
 	ivrs_ioapic	[HW,X86-64]
 			Provide an override to the IOAPIC-ID<->DEVICE-ID
-			mapping provided in the IVRS ACPI table. For
-			example, to map IOAPIC-ID decimal 10 to
-			PCI device 00:14.0 write the parameter as:
+			mapping provided in the IVRS ACPI table.
+			By default, PCI segment is 0, and can be omitted.
+
+			For example, to map IOAPIC-ID decimal 10 to
+			PCI segment 0x1 and PCI device 00:14.0,
+			write the parameter as:
+				ivrs_ioapic=10@0001:00:14.0
+
+			Deprecated formats:
+			* To map IOAPIC-ID decimal 10 to PCI device 00:14.0
+			  write the parameter as:
 				ivrs_ioapic[10]=00:14.0
+			* To map IOAPIC-ID decimal 10 to PCI segment 0x1 and
+			  PCI device 00:14.0 write the parameter as:
+				ivrs_ioapic[10]=0001:00:14.0
 
 	ivrs_hpet	[HW,X86-64]
 			Provide an override to the HPET-ID<->DEVICE-ID
-			mapping provided in the IVRS ACPI table. For
-			example, to map HPET-ID decimal 0 to
-			PCI device 00:14.0 write the parameter as:
+			mapping provided in the IVRS ACPI table.
+			By default, PCI segment is 0, and can be omitted.
+
+			For example, to map HPET-ID decimal 10 to
+			PCI segment 0x1 and PCI device 00:14.0,
+			write the parameter as:
+				ivrs_hpet=10@0001:00:14.0
+
+			Deprecated formats:
+			* To map HPET-ID decimal 0 to PCI device 00:14.0
+			  write the parameter as:
 				ivrs_hpet[0]=00:14.0
+			* To map HPET-ID decimal 10 to PCI segment 0x1 and
+			  PCI device 00:14.0 write the parameter as:
+				ivrs_ioapic[10]=0001:00:14.0
 
 	ivrs_acpihid	[HW,X86-64]
 			Provide an override to the ACPI-HID:UID<->DEVICE-ID
-			mapping provided in the IVRS ACPI table. For
-			example, to map UART-HID:UID AMD0020:0 to
-			PCI device 00:14.5 write the parameter as:
+			mapping provided in the IVRS ACPI table.
+			By default, PCI segment is 0, and can be omitted.
+
+			For example, to map UART-HID:UID AMD0020:0 to
+			PCI segment 0x1 and PCI device ID 00:14.5,
+			write the parameter as:
+				ivrs_acpihid=AMD0020:0@0001:00:14.5
+
+			Deprecated formats:
+			* To map UART-HID:UID AMD0020:0 to PCI segment is 0,
+			  PCI device ID 00:14.5, write the parameter as:
 				ivrs_acpihid[00:14.5]=AMD0020:0
+			* To map UART-HID:UID AMD0020:0 to PCI segment 0x1 and
+			  PCI device ID 00:14.5, write the parameter as:
+				ivrs_acpihid[0001:00:14.5]=AMD0020:0
 
 	js=		[HW,JOY] Analog joystick
 			See Documentation/input/joydev/joystick.rst.
diff --git a/Documentation/sphinx/load_config.py b/Documentation/sphinx/load_config.py
index eeb394b39e2c..8b416bfd75ac 100644
--- a/Documentation/sphinx/load_config.py
+++ b/Documentation/sphinx/load_config.py
@@ -3,7 +3,7 @@
 
 import os
 import sys
-from sphinx.util.pycompat import execfile_
+from sphinx.util.osutil import fs_encoding
 
 # ------------------------------------------------------------------------------
 def loadConfig(namespace):
@@ -48,7 +48,9 @@ def loadConfig(namespace):
             sys.stdout.write("load additional sphinx-config: %s\n" % config_file)
             config = namespace.copy()
             config['__file__'] = config_file
-            execfile_(config_file, config)
+            with open(config_file, 'rb') as f:
+                code = compile(f.read(), fs_encoding, 'exec')
+                exec(code, config)
             del config['__file__']
             namespace.update(config)
         else:
diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index cd8a58556804..2b4b64797191 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6398,3 +6398,63 @@ When enabled, KVM will disable paravirtual features provided to the
 guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
 (0x40000001). Otherwise, a guest may use the paravirtual features
 regardless of what has actually been exposed through the CPUID leaf.
+
+9. Known KVM API problems
+=========================
+
+In some cases, KVM's API has some inconsistencies or common pitfalls
+that userspace need to be aware of.  This section details some of
+these issues.
+
+Most of them are architecture specific, so the section is split by
+architecture.
+
+9.1. x86
+--------
+
+``KVM_GET_SUPPORTED_CPUID`` issues
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+In general, ``KVM_GET_SUPPORTED_CPUID`` is designed so that it is possible
+to take its result and pass it directly to ``KVM_SET_CPUID2``.  This section
+documents some cases in which that requires some care.
+
+Local APIC features
+~~~~~~~~~~~~~~~~~~~
+
+CPU[EAX=1]:ECX[21] (X2APIC) is reported by ``KVM_GET_SUPPORTED_CPUID``,
+but it can only be enabled if ``KVM_CREATE_IRQCHIP`` or
+``KVM_ENABLE_CAP(KVM_CAP_IRQCHIP_SPLIT)`` are used to enable in-kernel emulation of
+the local APIC.
+
+The same is true for the ``KVM_FEATURE_PV_UNHALT`` paravirtualized feature.
+
+CPU[EAX=1]:ECX[24] (TSC_DEADLINE) is not reported by ``KVM_GET_SUPPORTED_CPUID``.
+It can be enabled if ``KVM_CAP_TSC_DEADLINE_TIMER`` is present and the kernel
+has enabled in-kernel emulation of the local APIC.
+
+CPU topology
+~~~~~~~~~~~~
+
+Several CPUID values include topology information for the host CPU:
+0x0b and 0x1f for Intel systems, 0x8000001e for AMD systems.  Different
+versions of KVM return different values for this information and userspace
+should not rely on it.  Currently they return all zeroes.
+
+If userspace wishes to set up a guest topology, it should be careful that
+the values of these three leaves differ for each CPU.  In particular,
+the APIC ID is found in EDX for all subleaves of 0x0b and 0x1f, and in EAX
+for 0x8000001e; the latter also encodes the core id and node id in bits
+7:0 of EBX and ECX respectively.
+
+Obsolete ioctls and capabilities
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+KVM_CAP_DISABLE_QUIRKS does not let userspace know which quirks are actually
+available.  Use ``KVM_CHECK_EXTENSION(KVM_CAP_DISABLE_QUIRKS2)`` instead if
+available.
+
+Ordering of KVM_GET_*/KVM_SET_* ioctls
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+TBD
diff --git a/Makefile b/Makefile
index 98fc6e7fd41d..68fd49d8d436 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 163
+SUBLEVEL = 164
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h
index 13869b76b58c..abd302e521c0 100644
--- a/arch/arm64/include/asm/atomic_ll_sc.h
+++ b/arch/arm64/include/asm/atomic_ll_sc.h
@@ -12,19 +12,6 @@
 
 #include <linux/stringify.h>
 
-#ifdef CONFIG_ARM64_LSE_ATOMICS
-#define __LL_SC_FALLBACK(asm_ops)					\
-"	b	3f\n"							\
-"	.subsection	1\n"						\
-"3:\n"									\
-asm_ops "\n"								\
-"	b	4f\n"							\
-"	.previous\n"							\
-"4:\n"
-#else
-#define __LL_SC_FALLBACK(asm_ops) asm_ops
-#endif
-
 #ifndef CONFIG_CC_HAS_K_CONSTRAINT
 #define K
 #endif
@@ -43,12 +30,11 @@ __ll_sc_atomic_##op(int i, atomic_t *v)					\
 	int result;							\
 									\
 	asm volatile("// atomic_" #op "\n"				\
-	__LL_SC_FALLBACK(						\
-"	prfm	pstl1strm, %2\n"					\
-"1:	ldxr	%w0, %2\n"						\
-"	" #asm_op "	%w0, %w0, %w3\n"				\
-"	stxr	%w1, %w0, %2\n"						\
-"	cbnz	%w1, 1b\n")						\
+	"	prfm	pstl1strm, %2\n"				\
+	"1:	ldxr	%w0, %2\n"					\
+	"	" #asm_op "	%w0, %w0, %w3\n"			\
+	"	stxr	%w1, %w0, %2\n"					\
+	"	cbnz	%w1, 1b\n"					\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
 	: __stringify(constraint) "r" (i));				\
 }
@@ -61,13 +47,12 @@ __ll_sc_atomic_##op##_return##name(int i, atomic_t *v)			\
 	int result;							\
 									\
 	asm volatile("// atomic_" #op "_return" #name "\n"		\
-	__LL_SC_FALLBACK(						\
-"	prfm	pstl1strm, %2\n"					\
-"1:	ld" #acq "xr	%w0, %2\n"					\
-"	" #asm_op "	%w0, %w0, %w3\n"				\
-"	st" #rel "xr	%w1, %w0, %2\n"					\
-"	cbnz	%w1, 1b\n"						\
-"	" #mb )								\
+	"	prfm	pstl1strm, %2\n"				\
+	"1:	ld" #acq "xr	%w0, %2\n"				\
+	"	" #asm_op "	%w0, %w0, %w3\n"			\
+	"	st" #rel "xr	%w1, %w0, %2\n"				\
+	"	cbnz	%w1, 1b\n"					\
+	"	" #mb							\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
 	: __stringify(constraint) "r" (i)				\
 	: cl);								\
@@ -83,13 +68,12 @@ __ll_sc_atomic_fetch_##op##name(int i, atomic_t *v)			\
 	int val, result;						\
 									\
 	asm volatile("// atomic_fetch_" #op #name "\n"			\
-	__LL_SC_FALLBACK(						\
-"	prfm	pstl1strm, %3\n"					\
-"1:	ld" #acq "xr	%w0, %3\n"					\
-"	" #asm_op "	%w1, %w0, %w4\n"				\
-"	st" #rel "xr	%w2, %w1, %3\n"					\
-"	cbnz	%w2, 1b\n"						\
-"	" #mb )								\
+	"	prfm	pstl1strm, %3\n"				\
+	"1:	ld" #acq "xr	%w0, %3\n"				\
+	"	" #asm_op "	%w1, %w0, %w4\n"			\
+	"	st" #rel "xr	%w2, %w1, %3\n"				\
+	"	cbnz	%w2, 1b\n"					\
+	"	" #mb							\
 	: "=&r" (result), "=&r" (val), "=&r" (tmp), "+Q" (v->counter)	\
 	: __stringify(constraint) "r" (i)				\
 	: cl);								\
@@ -142,12 +126,11 @@ __ll_sc_atomic64_##op(s64 i, atomic64_t *v)				\
 	unsigned long tmp;						\
 									\
 	asm volatile("// atomic64_" #op "\n"				\
-	__LL_SC_FALLBACK(						\
-"	prfm	pstl1strm, %2\n"					\
-"1:	ldxr	%0, %2\n"						\
-"	" #asm_op "	%0, %0, %3\n"					\
-"	stxr	%w1, %0, %2\n"						\
-"	cbnz	%w1, 1b")						\
+	"	prfm	pstl1strm, %2\n"				\
+	"1:	ldxr	%0, %2\n"					\
+	"	" #asm_op "	%0, %0, %3\n"				\
+	"	stxr	%w1, %0, %2\n"					\
+	"	cbnz	%w1, 1b"					\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
 	: __stringify(constraint) "r" (i));				\
 }
@@ -160,13 +143,12 @@ __ll_sc_atomic64_##op##_return##name(s64 i, atomic64_t *v)		\
 	unsigned long tmp;						\
 									\
 	asm volatile("// atomic64_" #op "_return" #name "\n"		\
-	__LL_SC_FALLBACK(						\
-"	prfm	pstl1strm, %2\n"					\
-"1:	ld" #acq "xr	%0, %2\n"					\
-"	" #asm_op "	%0, %0, %3\n"					\
-"	st" #rel "xr	%w1, %0, %2\n"					\
-"	cbnz	%w1, 1b\n"						\
-"	" #mb )								\
+	"	prfm	pstl1strm, %2\n"				\
+	"1:	ld" #acq "xr	%0, %2\n"				\
+	"	" #asm_op "	%0, %0, %3\n"				\
+	"	st" #rel "xr	%w1, %0, %2\n"				\
+	"	cbnz	%w1, 1b\n"					\
+	"	" #mb							\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
 	: __stringify(constraint) "r" (i)				\
 	: cl);								\
@@ -176,19 +158,18 @@ __ll_sc_atomic64_##op##_return##name(s64 i, atomic64_t *v)		\
 
 #define ATOMIC64_FETCH_OP(name, mb, acq, rel, cl, op, asm_op, constraint)\
 static inline long							\
-__ll_sc_atomic64_fetch_##op##name(s64 i, atomic64_t *v)		\
+__ll_sc_atomic64_fetch_##op##name(s64 i, atomic64_t *v)			\
 {									\
 	s64 result, val;						\
 	unsigned long tmp;						\
 									\
 	asm volatile("// atomic64_fetch_" #op #name "\n"		\
-	__LL_SC_FALLBACK(						\
-"	prfm	pstl1strm, %3\n"					\
-"1:	ld" #acq "xr	%0, %3\n"					\
-"	" #asm_op "	%1, %0, %4\n"					\
-"	st" #rel "xr	%w2, %1, %3\n"					\
-"	cbnz	%w2, 1b\n"						\
-"	" #mb )								\
+	"	prfm	pstl1strm, %3\n"				\
+	"1:	ld" #acq "xr	%0, %3\n"				\
+	"	" #asm_op "	%1, %0, %4\n"				\
+	"	st" #rel "xr	%w2, %1, %3\n"				\
+	"	cbnz	%w2, 1b\n"					\
+	"	" #mb							\
 	: "=&r" (result), "=&r" (val), "=&r" (tmp), "+Q" (v->counter)	\
 	: __stringify(constraint) "r" (i)				\
 	: cl);								\
@@ -240,15 +221,14 @@ __ll_sc_atomic64_dec_if_positive(atomic64_t *v)
 	unsigned long tmp;
 
 	asm volatile("// atomic64_dec_if_positive\n"
-	__LL_SC_FALLBACK(
-"	prfm	pstl1strm, %2\n"
-"1:	ldxr	%0, %2\n"
-"	subs	%0, %0, #1\n"
-"	b.lt	2f\n"
-"	stlxr	%w1, %0, %2\n"
-"	cbnz	%w1, 1b\n"
-"	dmb	ish\n"
-"2:")
+	"	prfm	pstl1strm, %2\n"
+	"1:	ldxr	%0, %2\n"
+	"	subs	%0, %0, #1\n"
+	"	b.lt	2f\n"
+	"	stlxr	%w1, %0, %2\n"
+	"	cbnz	%w1, 1b\n"
+	"	dmb	ish\n"
+	"2:"
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
 	:
 	: "cc", "memory");
@@ -274,7 +254,6 @@ __ll_sc__cmpxchg_case_##name##sz(volatile void *ptr,			\
 		old = (u##sz)old;					\
 									\
 	asm volatile(							\
-	__LL_SC_FALLBACK(						\
 	"	prfm	pstl1strm, %[v]\n"				\
 	"1:	ld" #acq "xr" #sfx "\t%" #w "[oldval], %[v]\n"		\
 	"	eor	%" #w "[tmp], %" #w "[oldval], %" #w "[old]\n"	\
@@ -282,7 +261,7 @@ __ll_sc__cmpxchg_case_##name##sz(volatile void *ptr,			\
 	"	st" #rel "xr" #sfx "\t%w[tmp], %" #w "[new], %[v]\n"	\
 	"	cbnz	%w[tmp], 1b\n"					\
 	"	" #mb "\n"						\
-	"2:")								\
+	"2:"								\
 	: [tmp] "=&r" (tmp), [oldval] "=&r" (oldval),			\
 	  [v] "+Q" (*(u##sz *)ptr)					\
 	: [old] __stringify(constraint) "r" (old), [new] "r" (new)	\
@@ -326,7 +305,6 @@ __ll_sc__cmpxchg_double##name(unsigned long old1,			\
 	unsigned long tmp, ret;						\
 									\
 	asm volatile("// __cmpxchg_double" #name "\n"			\
-	__LL_SC_FALLBACK(						\
 	"	prfm	pstl1strm, %2\n"				\
 	"1:	ldxp	%0, %1, %2\n"					\
 	"	eor	%0, %0, %3\n"					\
@@ -336,8 +314,8 @@ __ll_sc__cmpxchg_double##name(unsigned long old1,			\
 	"	st" #rel "xp	%w0, %5, %6, %2\n"			\
 	"	cbnz	%w0, 1b\n"					\
 	"	" #mb "\n"						\
-	"2:")								\
-	: "=&r" (tmp), "=&r" (ret), "+Q" (*(unsigned long *)ptr)	\
+	"2:"								\
+	: "=&r" (tmp), "=&r" (ret), "+Q" (*(__uint128_t *)ptr)		\
 	: "r" (old1), "r" (old2), "r" (new1), "r" (new2)		\
 	: cl);								\
 									\
diff --git a/arch/arm64/include/asm/atomic_lse.h b/arch/arm64/include/asm/atomic_lse.h
index da3280f639cd..28e96118c1e5 100644
--- a/arch/arm64/include/asm/atomic_lse.h
+++ b/arch/arm64/include/asm/atomic_lse.h
@@ -11,11 +11,11 @@
 #define __ASM_ATOMIC_LSE_H
 
 #define ATOMIC_OP(op, asm_op)						\
-static inline void __lse_atomic_##op(int i, atomic_t *v)			\
+static inline void __lse_atomic_##op(int i, atomic_t *v)		\
 {									\
 	asm volatile(							\
 	__LSE_PREAMBLE							\
-"	" #asm_op "	%w[i], %[v]\n"					\
+	"	" #asm_op "	%w[i], %[v]\n"				\
 	: [i] "+r" (i), [v] "+Q" (v->counter)				\
 	: "r" (v));							\
 }
@@ -32,7 +32,7 @@ static inline int __lse_atomic_fetch_##op##name(int i, atomic_t *v)	\
 {									\
 	asm volatile(							\
 	__LSE_PREAMBLE							\
-"	" #asm_op #mb "	%w[i], %w[i], %[v]"				\
+	"	" #asm_op #mb "	%w[i], %w[i], %[v]"			\
 	: [i] "+r" (i), [v] "+Q" (v->counter)				\
 	: "r" (v)							\
 	: cl);								\
@@ -130,7 +130,7 @@ static inline int __lse_atomic_sub_return##name(int i, atomic_t *v)	\
 	"	add	%w[i], %w[i], %w[tmp]"				\
 	: [i] "+&r" (i), [v] "+Q" (v->counter), [tmp] "=&r" (tmp)	\
 	: "r" (v)							\
-	: cl);							\
+	: cl);								\
 									\
 	return i;							\
 }
@@ -168,7 +168,7 @@ static inline void __lse_atomic64_##op(s64 i, atomic64_t *v)		\
 {									\
 	asm volatile(							\
 	__LSE_PREAMBLE							\
-"	" #asm_op "	%[i], %[v]\n"					\
+	"	" #asm_op "	%[i], %[v]\n"				\
 	: [i] "+r" (i), [v] "+Q" (v->counter)				\
 	: "r" (v));							\
 }
@@ -185,7 +185,7 @@ static inline long __lse_atomic64_fetch_##op##name(s64 i, atomic64_t *v)\
 {									\
 	asm volatile(							\
 	__LSE_PREAMBLE							\
-"	" #asm_op #mb "	%[i], %[i], %[v]"				\
+	"	" #asm_op #mb "	%[i], %[i], %[v]"			\
 	: [i] "+r" (i), [v] "+Q" (v->counter)				\
 	: "r" (v)							\
 	: cl);								\
@@ -272,7 +272,7 @@ static inline void __lse_atomic64_sub(s64 i, atomic64_t *v)
 }
 
 #define ATOMIC64_OP_SUB_RETURN(name, mb, cl...)				\
-static inline long __lse_atomic64_sub_return##name(s64 i, atomic64_t *v)	\
+static inline long __lse_atomic64_sub_return##name(s64 i, atomic64_t *v)\
 {									\
 	unsigned long tmp;						\
 									\
@@ -403,7 +403,7 @@ __lse__cmpxchg_double##name(unsigned long old1,				\
 	"	eor	%[old2], %[old2], %[oldval2]\n"			\
 	"	orr	%[old1], %[old1], %[old2]"			\
 	: [old1] "+&r" (x0), [old2] "+&r" (x1),				\
-	  [v] "+Q" (*(unsigned long *)ptr)				\
+	  [v] "+Q" (*(__uint128_t *)ptr)				\
 	: [new1] "r" (x2), [new2] "r" (x3), [ptr] "r" (x4),		\
 	  [oldval1] "r" (oldval1), [oldval2] "r" (oldval2)		\
 	: cl);								\
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 472122d731b0..4bca3d10ab0e 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -382,8 +382,26 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vcpu_abt_iss1tw(vcpu))
-		return true;
+	if (kvm_vcpu_abt_iss1tw(vcpu)) {
+		/*
+		 * Only a permission fault on a S1PTW should be
+		 * considered as a write. Otherwise, page tables baked
+		 * in a read-only memslot will result in an exception
+		 * being delivered in the guest.
+		 *
+		 * The drawback is that we end-up faulting twice if the
+		 * guest is using any of HW AF/DB: a translation fault
+		 * to map the page containing the PT (read only at
+		 * first), then a permission fault to allow the flags
+		 * to be set.
+		 */
+		switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
+		case ESR_ELx_FSC_PERM:
+			return true;
+		default:
+			return false;
+		}
+	}
 
 	if (kvm_vcpu_trap_is_iabt(vcpu))
 		return false;
diff --git a/arch/powerpc/include/asm/imc-pmu.h b/arch/powerpc/include/asm/imc-pmu.h
index 4f897993b710..699a88584ae1 100644
--- a/arch/powerpc/include/asm/imc-pmu.h
+++ b/arch/powerpc/include/asm/imc-pmu.h
@@ -137,7 +137,7 @@ struct imc_pmu {
  * are inited.
  */
 struct imc_pmu_ref {
-	struct mutex lock;
+	spinlock_t lock;
 	unsigned int id;
 	int refc;
 };
diff --git a/arch/powerpc/perf/imc-pmu.c b/arch/powerpc/perf/imc-pmu.c
index e8074d7f2401..e42c2fe3dd36 100644
--- a/arch/powerpc/perf/imc-pmu.c
+++ b/arch/powerpc/perf/imc-pmu.c
@@ -13,6 +13,7 @@
 #include <asm/cputhreads.h>
 #include <asm/smp.h>
 #include <linux/string.h>
+#include <linux/spinlock.h>
 
 /* Nest IMC data structures and variables */
 
@@ -20,7 +21,7 @@
  * Used to avoid races in counting the nest-pmu units during hotplug
  * register and unregister
  */
-static DEFINE_MUTEX(nest_init_lock);
+static DEFINE_SPINLOCK(nest_init_lock);
 static DEFINE_PER_CPU(struct imc_pmu_ref *, local_nest_imc_refc);
 static struct imc_pmu **per_nest_pmu_arr;
 static cpumask_t nest_imc_cpumask;
@@ -49,7 +50,7 @@ static int trace_imc_mem_size;
  * core and trace-imc
  */
 static struct imc_pmu_ref imc_global_refc = {
-	.lock = __MUTEX_INITIALIZER(imc_global_refc.lock),
+	.lock = __SPIN_LOCK_INITIALIZER(imc_global_refc.lock),
 	.id = 0,
 	.refc = 0,
 };
@@ -393,7 +394,7 @@ static int ppc_nest_imc_cpu_offline(unsigned int cpu)
 				       get_hard_smp_processor_id(cpu));
 		/*
 		 * If this is the last cpu in this chip then, skip the reference
-		 * count mutex lock and make the reference count on this chip zero.
+		 * count lock and make the reference count on this chip zero.
 		 */
 		ref = get_nest_pmu_ref(cpu);
 		if (!ref)
@@ -455,15 +456,15 @@ static void nest_imc_counters_release(struct perf_event *event)
 	/*
 	 * See if we need to disable the nest PMU.
 	 * If no events are currently in use, then we have to take a
-	 * mutex to ensure that we don't race with another task doing
+	 * lock to ensure that we don't race with another task doing
 	 * enable or disable the nest counters.
 	 */
 	ref = get_nest_pmu_ref(event->cpu);
 	if (!ref)
 		return;
 
-	/* Take the mutex lock for this node and then decrement the reference count */
-	mutex_lock(&ref->lock);
+	/* Take the lock for this node and then decrement the reference count */
+	spin_lock(&ref->lock);
 	if (ref->refc == 0) {
 		/*
 		 * The scenario where this is true is, when perf session is
@@ -475,7 +476,7 @@ static void nest_imc_counters_release(struct perf_event *event)
 		 * an OPAL call to disable the engine in that node.
 		 *
 		 */
-		mutex_unlock(&ref->lock);
+		spin_unlock(&ref->lock);
 		return;
 	}
 	ref->refc--;
@@ -483,7 +484,7 @@ static void nest_imc_counters_release(struct perf_event *event)
 		rc = opal_imc_counters_stop(OPAL_IMC_COUNTERS_NEST,
 					    get_hard_smp_processor_id(event->cpu));
 		if (rc) {
-			mutex_unlock(&ref->lock);
+			spin_unlock(&ref->lock);
 			pr_err("nest-imc: Unable to stop the counters for core %d\n", node_id);
 			return;
 		}
@@ -491,7 +492,7 @@ static void nest_imc_counters_release(struct perf_event *event)
 		WARN(1, "nest-imc: Invalid event reference count\n");
 		ref->refc = 0;
 	}
-	mutex_unlock(&ref->lock);
+	spin_unlock(&ref->lock);
 }
 
 static int nest_imc_event_init(struct perf_event *event)
@@ -550,26 +551,25 @@ static int nest_imc_event_init(struct perf_event *event)
 
 	/*
 	 * Get the imc_pmu_ref struct for this node.
-	 * Take the mutex lock and then increment the count of nest pmu events
-	 * inited.
+	 * Take the lock and then increment the count of nest pmu events inited.
 	 */
 	ref = get_nest_pmu_ref(event->cpu);
 	if (!ref)
 		return -EINVAL;
 
-	mutex_lock(&ref->lock);
+	spin_lock(&ref->lock);
 	if (ref->refc == 0) {
 		rc = opal_imc_counters_start(OPAL_IMC_COUNTERS_NEST,
 					     get_hard_smp_processor_id(event->cpu));
 		if (rc) {
-			mutex_unlock(&ref->lock);
+			spin_unlock(&ref->lock);
 			pr_err("nest-imc: Unable to start the counters for node %d\n",
 									node_id);
 			return rc;
 		}
 	}
 	++ref->refc;
-	mutex_unlock(&ref->lock);
+	spin_unlock(&ref->lock);
 
 	event->destroy = nest_imc_counters_release;
 	return 0;
@@ -605,9 +605,8 @@ static int core_imc_mem_init(int cpu, int size)
 		return -ENOMEM;
 	mem_info->vbase = page_address(page);
 
-	/* Init the mutex */
 	core_imc_refc[core_id].id = core_id;
-	mutex_init(&core_imc_refc[core_id].lock);
+	spin_lock_init(&core_imc_refc[core_id].lock);
 
 	rc = opal_imc_counters_init(OPAL_IMC_COUNTERS_CORE,
 				__pa((void *)mem_info->vbase),
@@ -696,9 +695,8 @@ static int ppc_core_imc_cpu_offline(unsigned int cpu)
 		perf_pmu_migrate_context(&core_imc_pmu->pmu, cpu, ncpu);
 	} else {
 		/*
-		 * If this is the last cpu in this core then, skip taking refernce
-		 * count mutex lock for this core and directly zero "refc" for
-		 * this core.
+		 * If this is the last cpu in this core then skip taking reference
+		 * count lock for this core and directly zero "refc" for this core.
 		 */
 		opal_imc_counters_stop(OPAL_IMC_COUNTERS_CORE,
 				       get_hard_smp_processor_id(cpu));
@@ -713,11 +711,11 @@ static int ppc_core_imc_cpu_offline(unsigned int cpu)
 		 * last cpu in this core and core-imc event running
 		 * in this cpu.
 		 */
-		mutex_lock(&imc_global_refc.lock);
+		spin_lock(&imc_global_refc.lock);
 		if (imc_global_refc.id == IMC_DOMAIN_CORE)
 			imc_global_refc.refc--;
 
-		mutex_unlock(&imc_global_refc.lock);
+		spin_unlock(&imc_global_refc.lock);
 	}
 	return 0;
 }
@@ -732,7 +730,7 @@ static int core_imc_pmu_cpumask_init(void)
 
 static void reset_global_refc(struct perf_event *event)
 {
-		mutex_lock(&imc_global_refc.lock);
+		spin_lock(&imc_global_refc.lock);
 		imc_global_refc.refc--;
 
 		/*
@@ -744,7 +742,7 @@ static void reset_global_refc(struct perf_event *event)
 			imc_global_refc.refc = 0;
 			imc_global_refc.id = 0;
 		}
-		mutex_unlock(&imc_global_refc.lock);
+		spin_unlock(&imc_global_refc.lock);
 }
 
 static void core_imc_counters_release(struct perf_event *event)
@@ -757,17 +755,17 @@ static void core_imc_counters_release(struct perf_event *event)
 	/*
 	 * See if we need to disable the IMC PMU.
 	 * If no events are currently in use, then we have to take a
-	 * mutex to ensure that we don't race with another task doing
+	 * lock to ensure that we don't race with another task doing
 	 * enable or disable the core counters.
 	 */
 	core_id = event->cpu / threads_per_core;
 
-	/* Take the mutex lock and decrement the refernce count for this core */
+	/* Take the lock and decrement the refernce count for this core */
 	ref = &core_imc_refc[core_id];
 	if (!ref)
 		return;
 
-	mutex_lock(&ref->lock);
+	spin_lock(&ref->lock);
 	if (ref->refc == 0) {
 		/*
 		 * The scenario where this is true is, when perf session is
@@ -779,7 +777,7 @@ static void core_imc_counters_release(struct perf_event *event)
 		 * an OPAL call to disable the engine in that core.
 		 *
 		 */
-		mutex_unlock(&ref->lock);
+		spin_unlock(&ref->lock);
 		return;
 	}
 	ref->refc--;
@@ -787,7 +785,7 @@ static void core_imc_counters_release(struct perf_event *event)
 		rc = opal_imc_counters_stop(OPAL_IMC_COUNTERS_CORE,
 					    get_hard_smp_processor_id(event->cpu));
 		if (rc) {
-			mutex_unlock(&ref->lock);
+			spin_unlock(&ref->lock);
 			pr_err("IMC: Unable to stop the counters for core %d\n", core_id);
 			return;
 		}
@@ -795,7 +793,7 @@ static void core_imc_counters_release(struct perf_event *event)
 		WARN(1, "core-imc: Invalid event reference count\n");
 		ref->refc = 0;
 	}
-	mutex_unlock(&ref->lock);
+	spin_unlock(&ref->lock);
 
 	reset_global_refc(event);
 }
@@ -833,7 +831,6 @@ static int core_imc_event_init(struct perf_event *event)
 	if ((!pcmi->vbase))
 		return -ENODEV;
 
-	/* Get the core_imc mutex for this core */
 	ref = &core_imc_refc[core_id];
 	if (!ref)
 		return -EINVAL;
@@ -841,22 +838,22 @@ static int core_imc_event_init(struct perf_event *event)
 	/*
 	 * Core pmu units are enabled only when it is used.
 	 * See if this is triggered for the first time.
-	 * If yes, take the mutex lock and enable the core counters.
+	 * If yes, take the lock and enable the core counters.
 	 * If not, just increment the count in core_imc_refc struct.
 	 */
-	mutex_lock(&ref->lock);
+	spin_lock(&ref->lock);
 	if (ref->refc == 0) {
 		rc = opal_imc_counters_start(OPAL_IMC_COUNTERS_CORE,
 					     get_hard_smp_processor_id(event->cpu));
 		if (rc) {
-			mutex_unlock(&ref->lock);
+			spin_unlock(&ref->lock);
 			pr_err("core-imc: Unable to start the counters for core %d\n",
 									core_id);
 			return rc;
 		}
 	}
 	++ref->refc;
-	mutex_unlock(&ref->lock);
+	spin_unlock(&ref->lock);
 
 	/*
 	 * Since the system can run either in accumulation or trace-mode
@@ -867,7 +864,7 @@ static int core_imc_event_init(struct perf_event *event)
 	 * to know whether any other trace/thread imc
 	 * events are running.
 	 */
-	mutex_lock(&imc_global_refc.lock);
+	spin_lock(&imc_global_refc.lock);
 	if (imc_global_refc.id == 0 || imc_global_refc.id == IMC_DOMAIN_CORE) {
 		/*
 		 * No other trace/thread imc events are running in
@@ -876,10 +873,10 @@ static int core_imc_event_init(struct perf_event *event)
 		imc_global_refc.id = IMC_DOMAIN_CORE;
 		imc_global_refc.refc++;
 	} else {
-		mutex_unlock(&imc_global_refc.lock);
+		spin_unlock(&imc_global_refc.lock);
 		return -EBUSY;
 	}
-	mutex_unlock(&imc_global_refc.lock);
+	spin_unlock(&imc_global_refc.lock);
 
 	event->hw.event_base = (u64)pcmi->vbase + (config & IMC_EVENT_OFFSET_MASK);
 	event->destroy = core_imc_counters_release;
@@ -951,10 +948,10 @@ static int ppc_thread_imc_cpu_offline(unsigned int cpu)
 	mtspr(SPRN_LDBAR, (mfspr(SPRN_LDBAR) & (~(1UL << 63))));
 
 	/* Reduce the refc if thread-imc event running on this cpu */
-	mutex_lock(&imc_global_refc.lock);
+	spin_lock(&imc_global_refc.lock);
 	if (imc_global_refc.id == IMC_DOMAIN_THREAD)
 		imc_global_refc.refc--;
-	mutex_unlock(&imc_global_refc.lock);
+	spin_unlock(&imc_global_refc.lock);
 
 	return 0;
 }
@@ -994,7 +991,7 @@ static int thread_imc_event_init(struct perf_event *event)
 	if (!target)
 		return -EINVAL;
 
-	mutex_lock(&imc_global_refc.lock);
+	spin_lock(&imc_global_refc.lock);
 	/*
 	 * Check if any other trace/core imc events are running in the
 	 * system, if not set the global id to thread-imc.
@@ -1003,10 +1000,10 @@ static int thread_imc_event_init(struct perf_event *event)
 		imc_global_refc.id = IMC_DOMAIN_THREAD;
 		imc_global_refc.refc++;
 	} else {
-		mutex_unlock(&imc_global_refc.lock);
+		spin_unlock(&imc_global_refc.lock);
 		return -EBUSY;
 	}
-	mutex_unlock(&imc_global_refc.lock);
+	spin_unlock(&imc_global_refc.lock);
 
 	event->pmu->task_ctx_nr = perf_sw_context;
 	event->destroy = reset_global_refc;
@@ -1128,25 +1125,25 @@ static int thread_imc_event_add(struct perf_event *event, int flags)
 	/*
 	 * imc pmus are enabled only when it is used.
 	 * See if this is triggered for the first time.
-	 * If yes, take the mutex lock and enable the counters.
+	 * If yes, take the lock and enable the counters.
 	 * If not, just increment the count in ref count struct.
 	 */
 	ref = &core_imc_refc[core_id];
 	if (!ref)
 		return -EINVAL;
 
-	mutex_lock(&ref->lock);
+	spin_lock(&ref->lock);
 	if (ref->refc == 0) {
 		if (opal_imc_counters_start(OPAL_IMC_COUNTERS_CORE,
 		    get_hard_smp_processor_id(smp_processor_id()))) {
-			mutex_unlock(&ref->lock);
+			spin_unlock(&ref->lock);
 			pr_err("thread-imc: Unable to start the counter\
 				for core %d\n", core_id);
 			return -EINVAL;
 		}
 	}
 	++ref->refc;
-	mutex_unlock(&ref->lock);
+	spin_unlock(&ref->lock);
 	return 0;
 }
 
@@ -1163,12 +1160,12 @@ static void thread_imc_event_del(struct perf_event *event, int flags)
 		return;
 	}
 
-	mutex_lock(&ref->lock);
+	spin_lock(&ref->lock);
 	ref->refc--;
 	if (ref->refc == 0) {
 		if (opal_imc_counters_stop(OPAL_IMC_COUNTERS_CORE,
 		    get_hard_smp_processor_id(smp_processor_id()))) {
-			mutex_unlock(&ref->lock);
+			spin_unlock(&ref->lock);
 			pr_err("thread-imc: Unable to stop the counters\
 				for core %d\n", core_id);
 			return;
@@ -1176,7 +1173,7 @@ static void thread_imc_event_del(struct perf_event *event, int flags)
 	} else if (ref->refc < 0) {
 		ref->refc = 0;
 	}
-	mutex_unlock(&ref->lock);
+	spin_unlock(&ref->lock);
 
 	/* Set bit 0 of LDBAR to zero, to stop posting updates to memory */
 	mtspr(SPRN_LDBAR, (mfspr(SPRN_LDBAR) & (~(1UL << 63))));
@@ -1217,9 +1214,8 @@ static int trace_imc_mem_alloc(int cpu_id, int size)
 		}
 	}
 
-	/* Init the mutex, if not already */
 	trace_imc_refc[core_id].id = core_id;
-	mutex_init(&trace_imc_refc[core_id].lock);
+	spin_lock_init(&trace_imc_refc[core_id].lock);
 
 	mtspr(SPRN_LDBAR, 0);
 	return 0;
@@ -1239,10 +1235,10 @@ static int ppc_trace_imc_cpu_offline(unsigned int cpu)
 	 * Reduce the refc if any trace-imc event running
 	 * on this cpu.
 	 */
-	mutex_lock(&imc_global_refc.lock);
+	spin_lock(&imc_global_refc.lock);
 	if (imc_global_refc.id == IMC_DOMAIN_TRACE)
 		imc_global_refc.refc--;
-	mutex_unlock(&imc_global_refc.lock);
+	spin_unlock(&imc_global_refc.lock);
 
 	return 0;
 }
@@ -1364,17 +1360,17 @@ static int trace_imc_event_add(struct perf_event *event, int flags)
 	}
 
 	mtspr(SPRN_LDBAR, ldbar_value);
-	mutex_lock(&ref->lock);
+	spin_lock(&ref->lock);
 	if (ref->refc == 0) {
 		if (opal_imc_counters_start(OPAL_IMC_COUNTERS_TRACE,
 				get_hard_smp_processor_id(smp_processor_id()))) {
-			mutex_unlock(&ref->lock);
+			spin_unlock(&ref->lock);
 			pr_err("trace-imc: Unable to start the counters for core %d\n", core_id);
 			return -EINVAL;
 		}
 	}
 	++ref->refc;
-	mutex_unlock(&ref->lock);
+	spin_unlock(&ref->lock);
 	return 0;
 }
 
@@ -1407,19 +1403,19 @@ static void trace_imc_event_del(struct perf_event *event, int flags)
 		return;
 	}
 
-	mutex_lock(&ref->lock);
+	spin_lock(&ref->lock);
 	ref->refc--;
 	if (ref->refc == 0) {
 		if (opal_imc_counters_stop(OPAL_IMC_COUNTERS_TRACE,
 				get_hard_smp_processor_id(smp_processor_id()))) {
-			mutex_unlock(&ref->lock);
+			spin_unlock(&ref->lock);
 			pr_err("trace-imc: Unable to stop the counters for core %d\n", core_id);
 			return;
 		}
 	} else if (ref->refc < 0) {
 		ref->refc = 0;
 	}
-	mutex_unlock(&ref->lock);
+	spin_unlock(&ref->lock);
 
 	trace_imc_event_stop(event, flags);
 }
@@ -1441,7 +1437,7 @@ static int trace_imc_event_init(struct perf_event *event)
 	 * no other thread is running any core/thread imc
 	 * events
 	 */
-	mutex_lock(&imc_global_refc.lock);
+	spin_lock(&imc_global_refc.lock);
 	if (imc_global_refc.id == 0 || imc_global_refc.id == IMC_DOMAIN_TRACE) {
 		/*
 		 * No core/thread imc events are running in the
@@ -1450,10 +1446,10 @@ static int trace_imc_event_init(struct perf_event *event)
 		imc_global_refc.id = IMC_DOMAIN_TRACE;
 		imc_global_refc.refc++;
 	} else {
-		mutex_unlock(&imc_global_refc.lock);
+		spin_unlock(&imc_global_refc.lock);
 		return -EBUSY;
 	}
-	mutex_unlock(&imc_global_refc.lock);
+	spin_unlock(&imc_global_refc.lock);
 
 	event->hw.idx = -1;
 
@@ -1525,10 +1521,10 @@ static int init_nest_pmu_ref(void)
 	i = 0;
 	for_each_node(nid) {
 		/*
-		 * Mutex lock to avoid races while tracking the number of
+		 * Take the lock to avoid races while tracking the number of
 		 * sessions using the chip's nest pmu units.
 		 */
-		mutex_init(&nest_imc_refc[i].lock);
+		spin_lock_init(&nest_imc_refc[i].lock);
 
 		/*
 		 * Loop to init the "id" with the node_id. Variable "i" initialized to
@@ -1625,7 +1621,7 @@ static void imc_common_mem_free(struct imc_pmu *pmu_ptr)
 static void imc_common_cpuhp_mem_free(struct imc_pmu *pmu_ptr)
 {
 	if (pmu_ptr->domain == IMC_DOMAIN_NEST) {
-		mutex_lock(&nest_init_lock);
+		spin_lock(&nest_init_lock);
 		if (nest_pmus == 1) {
 			cpuhp_remove_state(CPUHP_AP_PERF_POWERPC_NEST_IMC_ONLINE);
 			kfree(nest_imc_refc);
@@ -1635,7 +1631,7 @@ static void imc_common_cpuhp_mem_free(struct imc_pmu *pmu_ptr)
 
 		if (nest_pmus > 0)
 			nest_pmus--;
-		mutex_unlock(&nest_init_lock);
+		spin_unlock(&nest_init_lock);
 	}
 
 	/* Free core_imc memory */
@@ -1792,11 +1788,11 @@ int init_imc_pmu(struct device_node *parent, struct imc_pmu *pmu_ptr, int pmu_id
 		* rest. To handle the cpuhotplug callback unregister, we track
 		* the number of nest pmus in "nest_pmus".
 		*/
-		mutex_lock(&nest_init_lock);
+		spin_lock(&nest_init_lock);
 		if (nest_pmus == 0) {
 			ret = init_nest_pmu_ref();
 			if (ret) {
-				mutex_unlock(&nest_init_lock);
+				spin_unlock(&nest_init_lock);
 				kfree(per_nest_pmu_arr);
 				per_nest_pmu_arr = NULL;
 				goto err_free_mem;
@@ -1804,7 +1800,7 @@ int init_imc_pmu(struct device_node *parent, struct imc_pmu *pmu_ptr, int pmu_id
 			/* Register for cpu hotplug notification. */
 			ret = nest_pmu_cpumask_init();
 			if (ret) {
-				mutex_unlock(&nest_init_lock);
+				spin_unlock(&nest_init_lock);
 				kfree(nest_imc_refc);
 				kfree(per_nest_pmu_arr);
 				per_nest_pmu_arr = NULL;
@@ -1812,7 +1808,7 @@ int init_imc_pmu(struct device_node *parent, struct imc_pmu *pmu_ptr, int pmu_id
 			}
 		}
 		nest_pmus++;
-		mutex_unlock(&nest_init_lock);
+		spin_unlock(&nest_init_lock);
 		break;
 	case IMC_DOMAIN_CORE:
 		ret = core_imc_pmu_cpumask_init();
diff --git a/arch/s390/include/asm/cpu_mf.h b/arch/s390/include/asm/cpu_mf.h
index 0d90cbeb89b4..a0914bc6c9bd 100644
--- a/arch/s390/include/asm/cpu_mf.h
+++ b/arch/s390/include/asm/cpu_mf.h
@@ -128,19 +128,21 @@ struct hws_combined_entry {
 	struct hws_diag_entry	diag;	/* Diagnostic-sampling data entry */
 } __packed;
 
-struct hws_trailer_entry {
-	union {
-		struct {
-			unsigned int f:1;	/* 0 - Block Full Indicator   */
-			unsigned int a:1;	/* 1 - Alert request control  */
-			unsigned int t:1;	/* 2 - Timestamp format	      */
-			unsigned int :29;	/* 3 - 31: Reserved	      */
-			unsigned int bsdes:16;	/* 32-47: size of basic SDE   */
-			unsigned int dsdes:16;	/* 48-63: size of diagnostic SDE */
-		};
-		unsigned long long flags;	/* 0 - 63: All indicators     */
+union hws_trailer_header {
+	struct {
+		unsigned int f:1;	/* 0 - Block Full Indicator   */
+		unsigned int a:1;	/* 1 - Alert request control  */
+		unsigned int t:1;	/* 2 - Timestamp format	      */
+		unsigned int :29;	/* 3 - 31: Reserved	      */
+		unsigned int bsdes:16;	/* 32-47: size of basic SDE   */
+		unsigned int dsdes:16;	/* 48-63: size of diagnostic SDE */
+		unsigned long long overflow; /* 64 - Overflow Count   */
 	};
-	unsigned long long overflow;	 /* 64 - sample Overflow count	      */
+	__uint128_t val;
+};
+
+struct hws_trailer_entry {
+	union hws_trailer_header header; /* 0 - 15 Flags + Overflow Count     */
 	unsigned char timestamp[16];	 /* 16 - 31 timestamp		      */
 	unsigned long long reserved1;	 /* 32 -Reserved		      */
 	unsigned long long reserved2;	 /*				      */
@@ -287,14 +289,11 @@ static inline unsigned long sample_rate_to_freq(struct hws_qsi_info_block *qsi,
 	return USEC_PER_SEC * qsi->cpu_speed / rate;
 }
 
-#define SDB_TE_ALERT_REQ_MASK	0x4000000000000000UL
-#define SDB_TE_BUFFER_FULL_MASK 0x8000000000000000UL
-
 /* Return TOD timestamp contained in an trailer entry */
 static inline unsigned long long trailer_timestamp(struct hws_trailer_entry *te)
 {
 	/* TOD in STCKE format */
-	if (te->t)
+	if (te->header.t)
 		return *((unsigned long long *) &te->timestamp[1]);
 
 	/* TOD in STCK format */
diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index 918f0ba4f4d2..5e26e2c4641b 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -31,7 +31,7 @@
 	pcp_op_T__ *ptr__;						\
 	preempt_disable_notrace();					\
 	ptr__ = raw_cpu_ptr(&(pcp));					\
-	prev__ = *ptr__;						\
+	prev__ = READ_ONCE(*ptr__);					\
 	do {								\
 		old__ = prev__;						\
 		new__ = old__ op (val);					\
diff --git a/arch/s390/kernel/machine_kexec_file.c b/arch/s390/kernel/machine_kexec_file.c
index 53da174754d9..bf0596749ebd 100644
--- a/arch/s390/kernel/machine_kexec_file.c
+++ b/arch/s390/kernel/machine_kexec_file.c
@@ -185,8 +185,6 @@ static int kexec_file_add_ipl_report(struct kimage *image,
 
 	data->memsz = ALIGN(data->memsz, PAGE_SIZE);
 	buf.mem = data->memsz;
-	if (image->type == KEXEC_TYPE_CRASH)
-		buf.mem += crashk_res.start;
 
 	ptr = (void *)ipl_cert_list_addr;
 	end = ptr + ipl_cert_list_size;
@@ -223,6 +221,9 @@ static int kexec_file_add_ipl_report(struct kimage *image,
 		data->kernel_buf + offsetof(struct lowcore, ipl_parmblock_ptr);
 	*lc_ipl_parmblock_ptr = (__u32)buf.mem;
 
+	if (image->type == KEXEC_TYPE_CRASH)
+		buf.mem += crashk_res.start;
+
 	ret = kexec_add_buffer(&buf);
 out:
 	return ret;
diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index 19cd7b961c45..bcd31e0b4edb 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -163,14 +163,15 @@ static void free_sampling_buffer(struct sf_buffer *sfb)
 
 static int alloc_sample_data_block(unsigned long *sdbt, gfp_t gfp_flags)
 {
-	unsigned long sdb, *trailer;
+	struct hws_trailer_entry *te;
+	unsigned long sdb;
 
 	/* Allocate and initialize sample-data-block */
 	sdb = get_zeroed_page(gfp_flags);
 	if (!sdb)
 		return -ENOMEM;
-	trailer = trailer_entry_ptr(sdb);
-	*trailer = SDB_TE_ALERT_REQ_MASK;
+	te = (struct hws_trailer_entry *)trailer_entry_ptr(sdb);
+	te->header.a = 1;
 
 	/* Link SDB into the sample-data-block-table */
 	*sdbt = sdb;
@@ -1206,7 +1207,7 @@ static void hw_collect_samples(struct perf_event *event, unsigned long *sdbt,
 					    "%s: Found unknown"
 					    " sampling data entry: te->f %i"
 					    " basic.def %#4x (%p)\n", __func__,
-					    te->f, sample->def, sample);
+					    te->header.f, sample->def, sample);
 			/* Sample slot is not yet written or other record.
 			 *
 			 * This condition can occur if the buffer was reused
@@ -1217,7 +1218,7 @@ static void hw_collect_samples(struct perf_event *event, unsigned long *sdbt,
 			 * that are not full.  Stop processing if the first
 			 * invalid format was detected.
 			 */
-			if (!te->f)
+			if (!te->header.f)
 				break;
 		}
 
@@ -1227,6 +1228,16 @@ static void hw_collect_samples(struct perf_event *event, unsigned long *sdbt,
 	}
 }
 
+static inline __uint128_t __cdsg(__uint128_t *ptr, __uint128_t old, __uint128_t new)
+{
+	asm volatile(
+		"	cdsg	%[old],%[new],%[ptr]\n"
+		: [old] "+d" (old), [ptr] "+QS" (*ptr)
+		: [new] "d" (new)
+		: "memory", "cc");
+	return old;
+}
+
 /* hw_perf_event_update() - Process sampling buffer
  * @event:	The perf event
  * @flush_all:	Flag to also flush partially filled sample-data-blocks
@@ -1243,10 +1254,11 @@ static void hw_collect_samples(struct perf_event *event, unsigned long *sdbt,
  */
 static void hw_perf_event_update(struct perf_event *event, int flush_all)
 {
+	unsigned long long event_overflow, sampl_overflow, num_sdb;
+	union hws_trailer_header old, prev, new;
 	struct hw_perf_event *hwc = &event->hw;
 	struct hws_trailer_entry *te;
 	unsigned long *sdbt;
-	unsigned long long event_overflow, sampl_overflow, num_sdb, te_flags;
 	int done;
 
 	/*
@@ -1266,25 +1278,25 @@ static void hw_perf_event_update(struct perf_event *event, int flush_all)
 		te = (struct hws_trailer_entry *) trailer_entry_ptr(*sdbt);
 
 		/* Leave loop if no more work to do (block full indicator) */
-		if (!te->f) {
+		if (!te->header.f) {
 			done = 1;
 			if (!flush_all)
 				break;
 		}
 
 		/* Check the sample overflow count */
-		if (te->overflow)
+		if (te->header.overflow)
 			/* Account sample overflows and, if a particular limit
 			 * is reached, extend the sampling buffer.
 			 * For details, see sfb_account_overflows().
 			 */
-			sampl_overflow += te->overflow;
+			sampl_overflow += te->header.overflow;
 
 		/* Timestamps are valid for full sample-data-blocks only */
 		debug_sprintf_event(sfdbg, 6, "%s: sdbt %#lx "
 				    "overflow %llu timestamp %#llx\n",
-				    __func__, (unsigned long)sdbt, te->overflow,
-				    (te->f) ? trailer_timestamp(te) : 0ULL);
+				    __func__, (unsigned long)sdbt, te->header.overflow,
+				    (te->header.f) ? trailer_timestamp(te) : 0ULL);
 
 		/* Collect all samples from a single sample-data-block and
 		 * flag if an (perf) event overflow happened.  If so, the PMU
@@ -1294,12 +1306,16 @@ static void hw_perf_event_update(struct perf_event *event, int flush_all)
 		num_sdb++;
 
 		/* Reset trailer (using compare-double-and-swap) */
+		/* READ_ONCE() 16 byte header */
+		prev.val = __cdsg(&te->header.val, 0, 0);
 		do {
-			te_flags = te->flags & ~SDB_TE_BUFFER_FULL_MASK;
-			te_flags |= SDB_TE_ALERT_REQ_MASK;
-		} while (!cmpxchg_double(&te->flags, &te->overflow,
-					 te->flags, te->overflow,
-					 te_flags, 0ULL));
+			old.val = prev.val;
+			new.val = prev.val;
+			new.f = 0;
+			new.a = 1;
+			new.overflow = 0;
+			prev.val = __cdsg(&te->header.val, old.val, new.val);
+		} while (prev.val != old.val);
 
 		/* Advance to next sample-data-block */
 		sdbt++;
@@ -1384,7 +1400,7 @@ static void aux_output_end(struct perf_output_handle *handle)
 	range_scan = AUX_SDB_NUM_ALERT(aux);
 	for (i = 0, idx = aux->head; i < range_scan; i++, idx++) {
 		te = aux_sdb_trailer(aux, idx);
-		if (!(te->flags & SDB_TE_BUFFER_FULL_MASK))
+		if (!te->header.f)
 			break;
 	}
 	/* i is num of SDBs which are full */
@@ -1392,7 +1408,7 @@ static void aux_output_end(struct perf_output_handle *handle)
 
 	/* Remove alert indicators in the buffer */
 	te = aux_sdb_trailer(aux, aux->alert_mark);
-	te->flags &= ~SDB_TE_ALERT_REQ_MASK;
+	te->header.a = 0;
 
 	debug_sprintf_event(sfdbg, 6, "%s: SDBs %ld range %ld head %ld\n",
 			    __func__, i, range_scan, aux->head);
@@ -1437,9 +1453,9 @@ static int aux_output_begin(struct perf_output_handle *handle,
 		idx = aux->empty_mark + 1;
 		for (i = 0; i < range_scan; i++, idx++) {
 			te = aux_sdb_trailer(aux, idx);
-			te->flags &= ~(SDB_TE_BUFFER_FULL_MASK |
-				       SDB_TE_ALERT_REQ_MASK);
-			te->overflow = 0;
+			te->header.f = 0;
+			te->header.a = 0;
+			te->header.overflow = 0;
 		}
 		/* Save the position of empty SDBs */
 		aux->empty_mark = aux->head + range - 1;
@@ -1448,7 +1464,7 @@ static int aux_output_begin(struct perf_output_handle *handle,
 	/* Set alert indicator */
 	aux->alert_mark = aux->head + range/2 - 1;
 	te = aux_sdb_trailer(aux, aux->alert_mark);
-	te->flags = te->flags | SDB_TE_ALERT_REQ_MASK;
+	te->header.a = 1;
 
 	/* Reset hardware buffer head */
 	head = AUX_SDB_INDEX(aux, aux->head);
@@ -1475,14 +1491,17 @@ static int aux_output_begin(struct perf_output_handle *handle,
 static bool aux_set_alert(struct aux_buffer *aux, unsigned long alert_index,
 			  unsigned long long *overflow)
 {
-	unsigned long long orig_overflow, orig_flags, new_flags;
+	union hws_trailer_header old, prev, new;
 	struct hws_trailer_entry *te;
 
 	te = aux_sdb_trailer(aux, alert_index);
+	/* READ_ONCE() 16 byte header */
+	prev.val = __cdsg(&te->header.val, 0, 0);
 	do {
-		orig_flags = te->flags;
-		*overflow = orig_overflow = te->overflow;
-		if (orig_flags & SDB_TE_BUFFER_FULL_MASK) {
+		old.val = prev.val;
+		new.val = prev.val;
+		*overflow = old.overflow;
+		if (old.f) {
 			/*
 			 * SDB is already set by hardware.
 			 * Abort and try to set somewhere
@@ -1490,10 +1509,10 @@ static bool aux_set_alert(struct aux_buffer *aux, unsigned long alert_index,
 			 */
 			return false;
 		}
-		new_flags = orig_flags | SDB_TE_ALERT_REQ_MASK;
-	} while (!cmpxchg_double(&te->flags, &te->overflow,
-				 orig_flags, orig_overflow,
-				 new_flags, 0ULL));
+		new.a = 1;
+		new.overflow = 0;
+		prev.val = __cdsg(&te->header.val, old.val, new.val);
+	} while (prev.val != old.val);
 	return true;
 }
 
@@ -1522,8 +1541,9 @@ static bool aux_set_alert(struct aux_buffer *aux, unsigned long alert_index,
 static bool aux_reset_buffer(struct aux_buffer *aux, unsigned long range,
 			     unsigned long long *overflow)
 {
-	unsigned long long orig_overflow, orig_flags, new_flags;
 	unsigned long i, range_scan, idx, idx_old;
+	union hws_trailer_header old, prev, new;
+	unsigned long long orig_overflow;
 	struct hws_trailer_entry *te;
 
 	debug_sprintf_event(sfdbg, 6, "%s: range %ld head %ld alert %ld "
@@ -1554,17 +1574,20 @@ static bool aux_reset_buffer(struct aux_buffer *aux, unsigned long range,
 	idx_old = idx = aux->empty_mark + 1;
 	for (i = 0; i < range_scan; i++, idx++) {
 		te = aux_sdb_trailer(aux, idx);
+		/* READ_ONCE() 16 byte header */
+		prev.val = __cdsg(&te->header.val, 0, 0);
 		do {
-			orig_flags = te->flags;
-			orig_overflow = te->overflow;
-			new_flags = orig_flags & ~SDB_TE_BUFFER_FULL_MASK;
+			old.val = prev.val;
+			new.val = prev.val;
+			orig_overflow = old.overflow;
+			new.f = 0;
+			new.overflow = 0;
 			if (idx == aux->alert_mark)
-				new_flags |= SDB_TE_ALERT_REQ_MASK;
+				new.a = 1;
 			else
-				new_flags &= ~SDB_TE_ALERT_REQ_MASK;
-		} while (!cmpxchg_double(&te->flags, &te->overflow,
-					 orig_flags, orig_overflow,
-					 new_flags, 0ULL));
+				new.a = 0;
+			prev.val = __cdsg(&te->header.val, old.val, new.val);
+		} while (prev.val != old.val);
 		*overflow += orig_overflow;
 	}
 
diff --git a/arch/x86/boot/bioscall.S b/arch/x86/boot/bioscall.S
index 5521ea12f44e..aa9b96457584 100644
--- a/arch/x86/boot/bioscall.S
+++ b/arch/x86/boot/bioscall.S
@@ -32,7 +32,7 @@ intcall:
 	movw	%dx, %si
 	movw	%sp, %di
 	movw	$11, %cx
-	rep; movsd
+	rep; movsl
 
 	/* Pop full state from the stack */
 	popal
@@ -67,7 +67,7 @@ intcall:
 	jz	4f
 	movw	%sp, %si
 	movw	$11, %cx
-	rep; movsd
+	rep; movsl
 4:	addw	$44, %sp
 
 	/* Restore state and return */
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 5a59e3315b34..ff26de11b3f1 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -577,8 +577,10 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
 	/*
 	 * Ensure the task's closid and rmid are written before determining if
 	 * the task is current that will decide if it will be interrupted.
+	 * This pairs with the full barrier between the rq->curr update and
+	 * resctrl_sched_in() during context switch.
 	 */
-	barrier();
+	smp_mb();
 
 	/*
 	 * By now, the task's closid and rmid are set. If the task is current
@@ -2313,19 +2315,23 @@ static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
 			t->closid = to->closid;
 			t->rmid = to->mon.rmid;
 
-#ifdef CONFIG_SMP
 			/*
-			 * This is safe on x86 w/o barriers as the ordering
-			 * of writing to task_cpu() and t->on_cpu is
-			 * reverse to the reading here. The detection is
-			 * inaccurate as tasks might move or schedule
-			 * before the smp function call takes place. In
-			 * such a case the function call is pointless, but
+			 * Order the closid/rmid stores above before the loads
+			 * in task_curr(). This pairs with the full barrier
+			 * between the rq->curr update and resctrl_sched_in()
+			 * during context switch.
+			 */
+			smp_mb();
+
+			/*
+			 * If the task is on a CPU, set the CPU in the mask.
+			 * The detection is inaccurate as tasks might move or
+			 * schedule before the smp function call takes place.
+			 * In such a case the function call is pointless, but
 			 * there is no other side effect.
 			 */
-			if (mask && t->on_cpu)
+			if (IS_ENABLED(CONFIG_SMP) && mask && task_curr(t))
 				cpumask_set_cpu(task_cpu(t), mask);
-#endif
 		}
 	}
 	read_unlock(&tasklist_lock);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 06a776fdb90c..de4b171cb76b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -511,16 +511,22 @@ struct kvm_cpuid_array {
 	int nent;
 };
 
+static struct kvm_cpuid_entry2 *get_next_cpuid(struct kvm_cpuid_array *array)
+{
+	if (array->nent >= array->maxnent)
+		return NULL;
+
+	return &array->entries[array->nent++];
+}
+
 static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
 					      u32 function, u32 index)
 {
-	struct kvm_cpuid_entry2 *entry;
+	struct kvm_cpuid_entry2 *entry = get_next_cpuid(array);
 
-	if (array->nent >= array->maxnent)
+	if (!entry)
 		return NULL;
 
-	entry = &array->entries[array->nent++];
-
 	entry->function = function;
 	entry->index = index;
 	entry->flags = 0;
@@ -698,22 +704,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->edx = edx.full;
 		break;
 	}
-	/*
-	 * Per Intel's SDM, the 0x1f is a superset of 0xb,
-	 * thus they can be handled by common code.
-	 */
 	case 0x1f:
 	case 0xb:
 		/*
-		 * Populate entries until the level type (ECX[15:8]) of the
-		 * previous entry is zero.  Note, CPUID EAX.{0x1f,0xb}.0 is
-		 * the starting entry, filled by the primary do_host_cpuid().
+		 * No topology; a valid topology is indicated by the presence
+		 * of subleaf 1.
 		 */
-		for (i = 1; entry->ecx & 0xff00; ++i) {
-			entry = do_host_cpuid(array, function, i);
-			if (!entry)
-				goto out;
-		}
+		entry->eax = entry->ebx = entry->ecx = 0;
 		break;
 	case 0xd:
 		entry->eax &= supported_xcr0;
@@ -866,6 +863,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->ebx = entry->ecx = entry->edx = 0;
 		break;
 	case 0x8000001e:
+		/* Do not return host topology information.  */
+		entry->eax = entry->ebx = entry->ecx = 0;
+		entry->edx = 0; /* reserved */
 		break;
 	/* Support memory encryption cpuid if host supports it */
 	case 0x8000001F:
diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index 044dcdd723a7..7d69b740b9f9 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -298,7 +298,8 @@ int mhi_pm_m0_transition(struct mhi_controller *mhi_cntrl)
 		read_lock_irq(&mhi_chan->lock);
 
 		/* Only ring DB if ring is not empty */
-		if (tre_ring->base && tre_ring->wp  != tre_ring->rp)
+		if (tre_ring->base && tre_ring->wp  != tre_ring->rp &&
+		    mhi_chan->ch_state == MHI_CH_STATE_ENABLED)
 			mhi_ring_chan_db(mhi_cntrl, mhi_chan);
 		read_unlock_irq(&mhi_chan->lock);
 	}
diff --git a/drivers/clk/imx/clk-imx8mp.c b/drivers/clk/imx/clk-imx8mp.c
index 36e8d619e334..72592e35836b 100644
--- a/drivers/clk/imx/clk-imx8mp.c
+++ b/drivers/clk/imx/clk-imx8mp.c
@@ -17,6 +17,7 @@
 
 static u32 share_count_nand;
 static u32 share_count_media;
+static u32 share_count_usb;
 
 static const char * const pll_ref_sels[] = { "osc_24m", "dummy", "dummy", "dummy", };
 static const char * const audio_pll1_bypass_sels[] = {"audio_pll1", "audio_pll1_ref_sel", };
@@ -362,7 +363,7 @@ static const char * const imx8mp_media_mipi_phy1_ref_sels[] = {"osc_24m", "sys_p
 							       "clk_ext2", "audio_pll2_out",
 							       "video_pll1_out", };
 
-static const char * const imx8mp_media_disp1_pix_sels[] = {"osc_24m", "video_pll1_out", "audio_pll2_out",
+static const char * const imx8mp_media_disp_pix_sels[] = {"osc_24m", "video_pll1_out", "audio_pll2_out",
 							   "audio_pll1_out", "sys_pll1_800m",
 							   "sys_pll2_1000m", "sys_pll3_out", "clk_ext4", };
 
@@ -411,6 +412,11 @@ static const char * const imx8mp_sai7_sels[] = {"osc_24m", "audio_pll1_out", "au
 
 static const char * const imx8mp_dram_core_sels[] = {"dram_pll_out", "dram_alt_root", };
 
+static const char * const imx8mp_clkout_sels[] = {"audio_pll1_out", "audio_pll2_out", "video_pll1_out",
+						  "dummy", "dummy", "gpu_pll_out", "vpu_pll_out",
+						  "arm_pll_out", "sys_pll1", "sys_pll2", "sys_pll3",
+						  "dummy", "dummy", "osc_24m", "dummy", "osc_32k"};
+
 static struct clk_hw **hws;
 static struct clk_hw_onecell_data *clk_hw_data;
 
@@ -532,6 +538,15 @@ static int imx8mp_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MP_SYS_PLL2_500M] = imx_clk_hw_fixed_factor("sys_pll2_500m", "sys_pll2_500m_cg", 1, 2);
 	hws[IMX8MP_SYS_PLL2_1000M] = imx_clk_hw_fixed_factor("sys_pll2_1000m", "sys_pll2_out", 1, 1);
 
+	hws[IMX8MP_CLK_CLKOUT1_SEL] = imx_clk_hw_mux2("clkout1_sel", anatop_base + 0x128, 4, 4,
+						      imx8mp_clkout_sels, ARRAY_SIZE(imx8mp_clkout_sels));
+	hws[IMX8MP_CLK_CLKOUT1_DIV] = imx_clk_hw_divider("clkout1_div", "clkout1_sel", anatop_base + 0x128, 0, 4);
+	hws[IMX8MP_CLK_CLKOUT1] = imx_clk_hw_gate("clkout1", "clkout1_div", anatop_base + 0x128, 8);
+	hws[IMX8MP_CLK_CLKOUT2_SEL] = imx_clk_hw_mux2("clkout2_sel", anatop_base + 0x128, 20, 4,
+						      imx8mp_clkout_sels, ARRAY_SIZE(imx8mp_clkout_sels));
+	hws[IMX8MP_CLK_CLKOUT2_DIV] = imx_clk_hw_divider("clkout2_div", "clkout2_sel", anatop_base + 0x128, 16, 4);
+	hws[IMX8MP_CLK_CLKOUT2] = imx_clk_hw_gate("clkout2", "clkout2_div", anatop_base + 0x128, 24);
+
 	hws[IMX8MP_CLK_A53_DIV] = imx8m_clk_hw_composite_core("arm_a53_div", imx8mp_a53_sels, ccm_base + 0x8000);
 	hws[IMX8MP_CLK_A53_SRC] = hws[IMX8MP_CLK_A53_DIV];
 	hws[IMX8MP_CLK_A53_CG] = hws[IMX8MP_CLK_A53_DIV];
@@ -566,6 +581,7 @@ static int imx8mp_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MP_CLK_AHB] = imx8m_clk_hw_composite_bus_critical("ahb_root", imx8mp_ahb_sels, ccm_base + 0x9000);
 	hws[IMX8MP_CLK_AUDIO_AHB] = imx8m_clk_hw_composite_bus("audio_ahb", imx8mp_audio_ahb_sels, ccm_base + 0x9100);
 	hws[IMX8MP_CLK_MIPI_DSI_ESC_RX] = imx8m_clk_hw_composite_bus("mipi_dsi_esc_rx", imx8mp_mipi_dsi_esc_rx_sels, ccm_base + 0x9200);
+	hws[IMX8MP_CLK_MEDIA_DISP2_PIX] = imx8m_clk_hw_composite("media_disp2_pix", imx8mp_media_disp_pix_sels, ccm_base + 0x9300);
 
 	hws[IMX8MP_CLK_IPG_ROOT] = imx_clk_hw_divider2("ipg_root", "ahb_root", ccm_base + 0x9080, 0, 1);
 	hws[IMX8MP_CLK_IPG_AUDIO_ROOT] = imx_clk_hw_divider2("ipg_audio_root", "audio_ahb", ccm_base + 0x9180, 0, 1);
@@ -630,7 +646,7 @@ static int imx8mp_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MP_CLK_USDHC3] = imx8m_clk_hw_composite("usdhc3", imx8mp_usdhc3_sels, ccm_base + 0xbc80);
 	hws[IMX8MP_CLK_MEDIA_CAM1_PIX] = imx8m_clk_hw_composite("media_cam1_pix", imx8mp_media_cam1_pix_sels, ccm_base + 0xbd00);
 	hws[IMX8MP_CLK_MEDIA_MIPI_PHY1_REF] = imx8m_clk_hw_composite("media_mipi_phy1_ref", imx8mp_media_mipi_phy1_ref_sels, ccm_base + 0xbd80);
-	hws[IMX8MP_CLK_MEDIA_DISP1_PIX] = imx8m_clk_hw_composite("media_disp1_pix", imx8mp_media_disp1_pix_sels, ccm_base + 0xbe00);
+	hws[IMX8MP_CLK_MEDIA_DISP1_PIX] = imx8m_clk_hw_composite("media_disp1_pix", imx8mp_media_disp_pix_sels, ccm_base + 0xbe00);
 	hws[IMX8MP_CLK_MEDIA_CAM2_PIX] = imx8m_clk_hw_composite("media_cam2_pix", imx8mp_media_cam2_pix_sels, ccm_base + 0xbe80);
 	hws[IMX8MP_CLK_MEDIA_LDB] = imx8m_clk_hw_composite("media_ldb", imx8mp_media_ldb_sels, ccm_base + 0xbf00);
 	hws[IMX8MP_CLK_MEMREPAIR] = imx8m_clk_hw_composite_critical("mem_repair", imx8mp_memrepair_sels, ccm_base + 0xbf80);
@@ -691,7 +707,8 @@ static int imx8mp_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MP_CLK_UART2_ROOT] = imx_clk_hw_gate4("uart2_root_clk", "uart2", ccm_base + 0x44a0, 0);
 	hws[IMX8MP_CLK_UART3_ROOT] = imx_clk_hw_gate4("uart3_root_clk", "uart3", ccm_base + 0x44b0, 0);
 	hws[IMX8MP_CLK_UART4_ROOT] = imx_clk_hw_gate4("uart4_root_clk", "uart4", ccm_base + 0x44c0, 0);
-	hws[IMX8MP_CLK_USB_ROOT] = imx_clk_hw_gate4("usb_root_clk", "hsio_axi", ccm_base + 0x44d0, 0);
+	hws[IMX8MP_CLK_USB_ROOT] = imx_clk_hw_gate2_shared2("usb_root_clk", "hsio_axi", ccm_base + 0x44d0, 0, &share_count_usb);
+	hws[IMX8MP_CLK_USB_SUSP] = imx_clk_hw_gate2_shared2("usb_suspend_clk", "osc_32k", ccm_base + 0x44d0, 0, &share_count_usb);
 	hws[IMX8MP_CLK_USB_PHY_ROOT] = imx_clk_hw_gate4("usb_phy_root_clk", "usb_phy_ref", ccm_base + 0x44f0, 0);
 	hws[IMX8MP_CLK_USDHC1_ROOT] = imx_clk_hw_gate4("usdhc1_root_clk", "usdhc1", ccm_base + 0x4510, 0);
 	hws[IMX8MP_CLK_USDHC2_ROOT] = imx_clk_hw_gate4("usdhc2_root_clk", "usdhc2", ccm_base + 0x4520, 0);
diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index 8c4d947fb848..8220ce5b87ca 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -424,17 +424,16 @@ static void edac_device_workq_teardown(struct edac_device_ctl_info *edac_dev)
  *	Then restart the workq on the new delay
  */
 void edac_device_reset_delay_period(struct edac_device_ctl_info *edac_dev,
-					unsigned long value)
+				    unsigned long msec)
 {
-	unsigned long jiffs = msecs_to_jiffies(value);
-
-	if (value == 1000)
-		jiffs = round_jiffies_relative(value);
-
-	edac_dev->poll_msec = value;
-	edac_dev->delay	    = jiffs;
+	edac_dev->poll_msec = msec;
+	edac_dev->delay	    = msecs_to_jiffies(msec);
 
-	edac_mod_work(&edac_dev->work, jiffs);
+	/* See comment in edac_device_workq_setup() above */
+	if (edac_dev->poll_msec == 1000)
+		edac_mod_work(&edac_dev->work, round_jiffies_relative(edac_dev->delay));
+	else
+		edac_mod_work(&edac_dev->work, edac_dev->delay);
 }
 
 int edac_device_alloc_index(void)
diff --git a/drivers/edac/edac_module.h b/drivers/edac/edac_module.h
index aa1f91688eb8..841d238bc3f1 100644
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -56,7 +56,7 @@ bool edac_stop_work(struct delayed_work *work);
 bool edac_mod_work(struct delayed_work *work, unsigned long delay);
 
 extern void edac_device_reset_delay_period(struct edac_device_ctl_info
-					   *edac_dev, unsigned long value);
+					   *edac_dev, unsigned long msec);
 extern void edac_mc_reset_delay_period(unsigned long value);
 
 extern void *edac_align_ptr(void **p, unsigned size, int n_elems);
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index ba03f5a4b30c..a2765d668856 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -385,8 +385,8 @@ static int __init efisubsys_init(void)
 	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
 	if (!efi_kobj) {
 		pr_err("efi: Firmware registration failed.\n");
-		destroy_workqueue(efi_rts_wq);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_destroy_wq;
 	}
 
 	if (efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE |
@@ -429,7 +429,10 @@ static int __init efisubsys_init(void)
 		generic_ops_unregister();
 err_put:
 	kobject_put(efi_kobj);
-	destroy_workqueue(efi_rts_wq);
+err_destroy_wq:
+	if (efi_rts_wq)
+		destroy_workqueue(efi_rts_wq);
+
 	return error;
 }
 
diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.h b/drivers/gpu/drm/msm/adreno/adreno_gpu.h
index c3775f79525a..4656e707fe27 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.h
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.h
@@ -28,11 +28,9 @@ enum {
 	ADRENO_FW_MAX,
 };
 
-enum adreno_quirks {
-	ADRENO_QUIRK_TWO_PASS_USE_WFI = 1,
-	ADRENO_QUIRK_FAULT_DETECT_MASK = 2,
-	ADRENO_QUIRK_LMLOADKILL_DISABLE = 3,
-};
+#define ADRENO_QUIRK_TWO_PASS_USE_WFI		BIT(0)
+#define ADRENO_QUIRK_FAULT_DETECT_MASK		BIT(1)
+#define ADRENO_QUIRK_LMLOADKILL_DISABLE		BIT(2)
 
 struct adreno_rev {
 	uint8_t  core;
@@ -62,7 +60,7 @@ struct adreno_info {
 	const char *name;
 	const char *fw[ADRENO_FW_MAX];
 	uint32_t gmem;
-	enum adreno_quirks quirks;
+	u64 quirks;
 	struct msm_gpu *(*init)(struct drm_device *dev);
 	const char *zapfw;
 	u32 inactive_period;
diff --git a/drivers/gpu/drm/msm/dp/dp_aux.c b/drivers/gpu/drm/msm/dp/dp_aux.c
index 19b35ae3e927..a73a2b28a70a 100644
--- a/drivers/gpu/drm/msm/dp/dp_aux.c
+++ b/drivers/gpu/drm/msm/dp/dp_aux.c
@@ -423,6 +423,10 @@ void dp_aux_isr(struct drm_dp_aux *dp_aux)
 
 	aux->isr = dp_catalog_aux_get_irq(aux->catalog);
 
+	/* no interrupts pending, return immediately */
+	if (!aux->isr)
+		return;
+
 	if (!aux->cmd_busy)
 		return;
 
diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 33b8ebab178a..36efa273155d 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -279,10 +279,18 @@ static int virtio_gpu_resource_create_ioctl(struct drm_device *dev, void *data,
 		drm_gem_object_release(obj);
 		return ret;
 	}
-	drm_gem_object_put(obj);
 
 	rc->res_handle = qobj->hw_res_handle; /* similiar to a VM address */
 	rc->bo_handle = handle;
+
+	/*
+	 * The handle owns the reference now.  But we must drop our
+	 * remaining reference *after* we no longer need to dereference
+	 * the obj.  Otherwise userspace could guess the handle and
+	 * race closing it from another thread.
+	 */
+	drm_gem_object_put(obj);
+
 	return 0;
 }
 
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 310ab24d003a..ce822347f747 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -85,6 +85,10 @@
 #define ACPI_DEVFLAG_ATSDIS             0x10000000
 
 #define LOOP_TIMEOUT	2000000
+
+#define IVRS_GET_SBDF_ID(seg, bus, dev, fd)	(((seg & 0xffff) << 16) | ((bus & 0xff) << 8) \
+						 | ((dev & 0x1f) << 3) | (fn & 0x7))
+
 /*
  * ACPI table definitions
  *
@@ -3046,24 +3050,32 @@ static int __init parse_amd_iommu_options(char *str)
 
 static int __init parse_ivrs_ioapic(char *str)
 {
-	unsigned int bus, dev, fn;
-	int ret, id, i;
-	u16 devid;
+	u32 seg = 0, bus, dev, fn;
+	int id, i;
+	u32 devid;
 
-	ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
+	if (sscanf(str, "=%d@%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "=%d@%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5)
+		goto found;
 
-	if (ret != 4) {
-		pr_err("Invalid command line: ivrs_ioapic%s\n", str);
-		return 1;
+	if (sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5) {
+		pr_warn("ivrs_ioapic%s option format deprecated; use ivrs_ioapic=%d@%04x:%02x:%02x.%d instead\n",
+			str, id, seg, bus, dev, fn);
+		goto found;
 	}
 
+	pr_err("Invalid command line: ivrs_ioapic%s\n", str);
+	return 1;
+
+found:
 	if (early_ioapic_map_size == EARLY_MAP_SIZE) {
 		pr_err("Early IOAPIC map overflow - ignoring ivrs_ioapic%s\n",
 			str);
 		return 1;
 	}
 
-	devid = ((bus & 0xff) << 8) | ((dev & 0x1f) << 3) | (fn & 0x7);
+	devid = IVRS_GET_SBDF_ID(seg, bus, dev, fn);
 
 	cmdline_maps			= true;
 	i				= early_ioapic_map_size++;
@@ -3076,24 +3088,32 @@ static int __init parse_ivrs_ioapic(char *str)
 
 static int __init parse_ivrs_hpet(char *str)
 {
-	unsigned int bus, dev, fn;
-	int ret, id, i;
-	u16 devid;
+	u32 seg = 0, bus, dev, fn;
+	int id, i;
+	u32 devid;
 
-	ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
+	if (sscanf(str, "=%d@%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "=%d@%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5)
+		goto found;
 
-	if (ret != 4) {
-		pr_err("Invalid command line: ivrs_hpet%s\n", str);
-		return 1;
+	if (sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5) {
+		pr_warn("ivrs_hpet%s option format deprecated; use ivrs_hpet=%d@%04x:%02x:%02x.%d instead\n",
+			str, id, seg, bus, dev, fn);
+		goto found;
 	}
 
+	pr_err("Invalid command line: ivrs_hpet%s\n", str);
+	return 1;
+
+found:
 	if (early_hpet_map_size == EARLY_MAP_SIZE) {
 		pr_err("Early HPET map overflow - ignoring ivrs_hpet%s\n",
 			str);
 		return 1;
 	}
 
-	devid = ((bus & 0xff) << 8) | ((dev & 0x1f) << 3) | (fn & 0x7);
+	devid = IVRS_GET_SBDF_ID(seg, bus, dev, fn);
 
 	cmdline_maps			= true;
 	i				= early_hpet_map_size++;
@@ -3106,17 +3126,37 @@ static int __init parse_ivrs_hpet(char *str)
 
 static int __init parse_ivrs_acpihid(char *str)
 {
-	u32 bus, dev, fn;
-	char *hid, *uid, *p;
+	u32 seg = 0, bus, dev, fn;
+	char *hid, *uid, *p, *addr;
 	char acpiid[ACPIHID_UID_LEN + ACPIHID_HID_LEN] = {0};
-	int ret, i;
+	int i;
 
-	ret = sscanf(str, "[%x:%x.%x]=%s", &bus, &dev, &fn, acpiid);
-	if (ret != 4) {
-		pr_err("Invalid command line: ivrs_acpihid(%s)\n", str);
-		return 1;
+	addr = strchr(str, '@');
+	if (!addr) {
+		if (sscanf(str, "[%x:%x.%x]=%s", &bus, &dev, &fn, acpiid) == 4 ||
+		    sscanf(str, "[%x:%x:%x.%x]=%s", &seg, &bus, &dev, &fn, acpiid) == 5) {
+			pr_warn("ivrs_acpihid%s option format deprecated; use ivrs_acpihid=%s@%04x:%02x:%02x.%d instead\n",
+				str, acpiid, seg, bus, dev, fn);
+			goto found;
+		}
+		goto not_found;
 	}
 
+	/* We have the '@', make it the terminator to get just the acpiid */
+	*addr++ = 0;
+
+	if (sscanf(str, "=%s", acpiid) != 1)
+		goto not_found;
+
+	if (sscanf(addr, "%x:%x.%x", &bus, &dev, &fn) == 3 ||
+	    sscanf(addr, "%x:%x:%x.%x", &seg, &bus, &dev, &fn) == 4)
+		goto found;
+
+not_found:
+	pr_err("Invalid command line: ivrs_acpihid%s\n", str);
+	return 1;
+
+found:
 	p = acpiid;
 	hid = strsep(&p, ":");
 	uid = p;
@@ -3136,8 +3176,7 @@ static int __init parse_ivrs_acpihid(char *str)
 	i = early_acpihid_map_size++;
 	memcpy(early_acpihid_map[i].hid, hid, strlen(hid));
 	memcpy(early_acpihid_map[i].uid, uid, strlen(uid));
-	early_acpihid_map[i].devid =
-		((bus & 0xff) << 8) | ((dev & 0x1f) << 3) | (fn & 0x7);
+	early_acpihid_map[i].devid = IVRS_GET_SBDF_ID(seg, bus, dev, fn);
 	early_acpihid_map[i].cmd_line	= true;
 
 	return 1;
diff --git a/drivers/iommu/mtk_iommu_v1.c b/drivers/iommu/mtk_iommu_v1.c
index 82ddfe9170d4..2abbdd71d8d9 100644
--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -618,18 +618,34 @@ static int mtk_iommu_probe(struct platform_device *pdev)
 	ret = iommu_device_sysfs_add(&data->iommu, &pdev->dev, NULL,
 				     dev_name(&pdev->dev));
 	if (ret)
-		return ret;
+		goto out_clk_unprepare;
 
 	iommu_device_set_ops(&data->iommu, &mtk_iommu_ops);
 
 	ret = iommu_device_register(&data->iommu);
 	if (ret)
-		return ret;
+		goto out_sysfs_remove;
 
-	if (!iommu_present(&platform_bus_type))
-		bus_set_iommu(&platform_bus_type,  &mtk_iommu_ops);
+	if (!iommu_present(&platform_bus_type)) {
+		ret = bus_set_iommu(&platform_bus_type,  &mtk_iommu_ops);
+		if (ret)
+			goto out_dev_unreg;
+	}
 
-	return component_master_add_with_match(dev, &mtk_iommu_com_ops, match);
+	ret = component_master_add_with_match(dev, &mtk_iommu_com_ops, match);
+	if (ret)
+		goto out_bus_set_null;
+	return ret;
+
+out_bus_set_null:
+	bus_set_iommu(&platform_bus_type, NULL);
+out_dev_unreg:
+	iommu_device_unregister(&data->iommu);
+out_sysfs_remove:
+	iommu_device_sysfs_remove(&data->iommu);
+out_clk_unprepare:
+	clk_disable_unprepare(data->bclk);
+	return ret;
 }
 
 static int mtk_iommu_remove(struct platform_device *pdev)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
index fc389eecdd2b..b0413904b798 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
@@ -851,9 +851,11 @@ static struct pci_dev *ixgbe_get_first_secondary_devfn(unsigned int devfn)
 	rp_pdev = pci_get_domain_bus_and_slot(0, 0, devfn);
 	if (rp_pdev && rp_pdev->subordinate) {
 		bus = rp_pdev->subordinate->number;
+		pci_dev_put(rp_pdev);
 		return pci_get_domain_bus_and_slot(0, bus, 0);
 	}
 
+	pci_dev_put(rp_pdev);
 	return NULL;
 }
 
@@ -870,6 +872,7 @@ static bool ixgbe_x550em_a_has_mii(struct ixgbe_hw *hw)
 	struct ixgbe_adapter *adapter = hw->back;
 	struct pci_dev *pdev = adapter->pdev;
 	struct pci_dev *func0_pdev;
+	bool has_mii = false;
 
 	/* For the C3000 family of SoCs (x550em_a) the internal ixgbe devices
 	 * are always downstream of root ports @ 0000:00:16.0 & 0000:00:17.0
@@ -880,15 +883,16 @@ static bool ixgbe_x550em_a_has_mii(struct ixgbe_hw *hw)
 	func0_pdev = ixgbe_get_first_secondary_devfn(PCI_DEVFN(0x16, 0));
 	if (func0_pdev) {
 		if (func0_pdev == pdev)
-			return true;
-		else
-			return false;
+			has_mii = true;
+		goto out;
 	}
 	func0_pdev = ixgbe_get_first_secondary_devfn(PCI_DEVFN(0x17, 0));
 	if (func0_pdev == pdev)
-		return true;
+		has_mii = true;
 
-	return false;
+out:
+	pci_dev_put(func0_pdev);
+	return has_mii;
 }
 
 /**
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index fc27a40202c6..c0a0a31272cc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -145,6 +145,16 @@ int cgx_get_cgxid(void *cgxd)
 	return cgx->cgx_id;
 }
 
+u8 cgx_lmac_get_p2x(int cgx_id, int lmac_id)
+{
+	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
+	u64 cfg;
+
+	cfg = cgx_read(cgx_dev, lmac_id, CGXX_CMRX_CFG);
+
+	return (cfg & CMR_P2X_SEL_MASK) >> CMR_P2X_SEL_SHIFT;
+}
+
 /* Ensure the required lock for event queue(where asynchronous events are
  * posted) is acquired before calling this API. Else an asynchronous event(with
  * latest link status) can reach the destination before this function returns
@@ -340,9 +350,9 @@ int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable)
 
 	cfg = cgx_read(cgx, lmac_id, CGXX_CMRX_CFG);
 	if (enable)
-		cfg |= CMR_EN | DATA_PKT_RX_EN | DATA_PKT_TX_EN;
+		cfg |= DATA_PKT_RX_EN | DATA_PKT_TX_EN;
 	else
-		cfg &= ~(CMR_EN | DATA_PKT_RX_EN | DATA_PKT_TX_EN);
+		cfg &= ~(DATA_PKT_RX_EN | DATA_PKT_TX_EN);
 	cgx_write(cgx, lmac_id, CGXX_CMRX_CFG, cfg);
 	return 0;
 }
@@ -814,8 +824,7 @@ static int cgx_lmac_verify_fwi_version(struct cgx *cgx)
 	minor_ver = FIELD_GET(RESP_MINOR_VER, resp);
 	dev_dbg(dev, "Firmware command interface version = %d.%d\n",
 		major_ver, minor_ver);
-	if (major_ver != CGX_FIRMWARE_MAJOR_VER ||
-	    minor_ver != CGX_FIRMWARE_MINOR_VER)
+	if (major_ver != CGX_FIRMWARE_MAJOR_VER)
 		return -EIO;
 	else
 		return 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 27ca3291682b..e176a6c654ef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -27,7 +27,10 @@
 
 /* Registers */
 #define CGXX_CMRX_CFG			0x00
-#define CMR_EN				BIT_ULL(55)
+#define CMR_P2X_SEL_MASK		GENMASK_ULL(61, 59)
+#define CMR_P2X_SEL_SHIFT		59ULL
+#define CMR_P2X_SEL_NIX0		1ULL
+#define CMR_P2X_SEL_NIX1		2ULL
 #define DATA_PKT_TX_EN			BIT_ULL(53)
 #define DATA_PKT_RX_EN			BIT_ULL(54)
 #define CGX_LMAC_TYPE_SHIFT		40
@@ -142,5 +145,6 @@ int cgx_lmac_get_pause_frm(void *cgxd, int lmac_id,
 int cgx_lmac_set_pause_frm(void *cgxd, int lmac_id,
 			   u8 tx_pause, u8 rx_pause);
 void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable);
+u8 cgx_lmac_get_p2x(int cgx_id, int lmac_id);
 
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index c26652436c53..acbc67074f59 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -316,31 +316,36 @@ static void rvu_update_rsrc_map(struct rvu *rvu, struct rvu_pfvf *pfvf,
 
 	block->fn_map[lf] = attach ? pcifunc : 0;
 
-	switch (block->type) {
-	case BLKTYPE_NPA:
+	switch (block->addr) {
+	case BLKADDR_NPA:
 		pfvf->npalf = attach ? true : false;
 		num_lfs = pfvf->npalf;
 		break;
-	case BLKTYPE_NIX:
+	case BLKADDR_NIX0:
+	case BLKADDR_NIX1:
 		pfvf->nixlf = attach ? true : false;
 		num_lfs = pfvf->nixlf;
 		break;
-	case BLKTYPE_SSO:
+	case BLKADDR_SSO:
 		attach ? pfvf->sso++ : pfvf->sso--;
 		num_lfs = pfvf->sso;
 		break;
-	case BLKTYPE_SSOW:
+	case BLKADDR_SSOW:
 		attach ? pfvf->ssow++ : pfvf->ssow--;
 		num_lfs = pfvf->ssow;
 		break;
-	case BLKTYPE_TIM:
+	case BLKADDR_TIM:
 		attach ? pfvf->timlfs++ : pfvf->timlfs--;
 		num_lfs = pfvf->timlfs;
 		break;
-	case BLKTYPE_CPT:
+	case BLKADDR_CPT0:
 		attach ? pfvf->cptlfs++ : pfvf->cptlfs--;
 		num_lfs = pfvf->cptlfs;
 		break;
+	case BLKADDR_CPT1:
+		attach ? pfvf->cpt1_lfs++ : pfvf->cpt1_lfs--;
+		num_lfs = pfvf->cpt1_lfs;
+		break;
 	}
 
 	reg = is_pf ? block->pf_lfcnt_reg : block->vf_lfcnt_reg;
@@ -1035,7 +1040,30 @@ int rvu_mbox_handler_ready(struct rvu *rvu, struct msg_req *req,
 /* Get current count of a RVU block's LF/slots
  * provisioned to a given RVU func.
  */
-static u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blktype)
+u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blkaddr)
+{
+	switch (blkaddr) {
+	case BLKADDR_NPA:
+		return pfvf->npalf ? 1 : 0;
+	case BLKADDR_NIX0:
+	case BLKADDR_NIX1:
+		return pfvf->nixlf ? 1 : 0;
+	case BLKADDR_SSO:
+		return pfvf->sso;
+	case BLKADDR_SSOW:
+		return pfvf->ssow;
+	case BLKADDR_TIM:
+		return pfvf->timlfs;
+	case BLKADDR_CPT0:
+		return pfvf->cptlfs;
+	case BLKADDR_CPT1:
+		return pfvf->cpt1_lfs;
+	}
+	return 0;
+}
+
+/* Return true if LFs of block type are attached to pcifunc */
+static bool is_blktype_attached(struct rvu_pfvf *pfvf, int blktype)
 {
 	switch (blktype) {
 	case BLKTYPE_NPA:
@@ -1043,15 +1071,16 @@ static u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blktype)
 	case BLKTYPE_NIX:
 		return pfvf->nixlf ? 1 : 0;
 	case BLKTYPE_SSO:
-		return pfvf->sso;
+		return !!pfvf->sso;
 	case BLKTYPE_SSOW:
-		return pfvf->ssow;
+		return !!pfvf->ssow;
 	case BLKTYPE_TIM:
-		return pfvf->timlfs;
+		return !!pfvf->timlfs;
 	case BLKTYPE_CPT:
-		return pfvf->cptlfs;
+		return pfvf->cptlfs || pfvf->cpt1_lfs;
 	}
-	return 0;
+
+	return false;
 }
 
 bool is_pffunc_map_valid(struct rvu *rvu, u16 pcifunc, int blktype)
@@ -1064,7 +1093,7 @@ bool is_pffunc_map_valid(struct rvu *rvu, u16 pcifunc, int blktype)
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
 
 	/* Check if this PFFUNC has a LF of type blktype attached */
-	if (!rvu_get_rsrc_mapcount(pfvf, blktype))
+	if (!is_blktype_attached(pfvf, blktype))
 		return false;
 
 	return true;
@@ -1105,7 +1134,7 @@ static void rvu_detach_block(struct rvu *rvu, int pcifunc, int blktype)
 
 	block = &hw->block[blkaddr];
 
-	num_lfs = rvu_get_rsrc_mapcount(pfvf, block->type);
+	num_lfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
 	if (!num_lfs)
 		return;
 
@@ -1179,6 +1208,58 @@ int rvu_mbox_handler_detach_resources(struct rvu *rvu,
 	return rvu_detach_rsrcs(rvu, detach, detach->hdr.pcifunc);
 }
 
+static int rvu_get_nix_blkaddr(struct rvu *rvu, u16 pcifunc)
+{
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	int blkaddr = BLKADDR_NIX0, vf;
+	struct rvu_pfvf *pf;
+
+	/* All CGX mapped PFs are set with assigned NIX block during init */
+	if (is_pf_cgxmapped(rvu, rvu_get_pf(pcifunc))) {
+		pf = rvu_get_pfvf(rvu, pcifunc & ~RVU_PFVF_FUNC_MASK);
+		blkaddr = pf->nix_blkaddr;
+	} else if (is_afvf(pcifunc)) {
+		vf = pcifunc - 1;
+		/* Assign NIX based on VF number. All even numbered VFs get
+		 * NIX0 and odd numbered gets NIX1
+		 */
+		blkaddr = (vf & 1) ? BLKADDR_NIX1 : BLKADDR_NIX0;
+		/* NIX1 is not present on all silicons */
+		if (!is_block_implemented(rvu->hw, BLKADDR_NIX1))
+			blkaddr = BLKADDR_NIX0;
+	}
+
+	switch (blkaddr) {
+	case BLKADDR_NIX1:
+		pfvf->nix_blkaddr = BLKADDR_NIX1;
+		break;
+	case BLKADDR_NIX0:
+	default:
+		pfvf->nix_blkaddr = BLKADDR_NIX0;
+		break;
+	}
+
+	return pfvf->nix_blkaddr;
+}
+
+static int rvu_get_attach_blkaddr(struct rvu *rvu, int blktype, u16 pcifunc)
+{
+	int blkaddr;
+
+	switch (blktype) {
+	case BLKTYPE_NIX:
+		blkaddr = rvu_get_nix_blkaddr(rvu, pcifunc);
+		break;
+	default:
+		return rvu_get_blkaddr(rvu, blktype, 0);
+	};
+
+	if (is_block_implemented(rvu->hw, blkaddr))
+		return blkaddr;
+
+	return -ENODEV;
+}
+
 static void rvu_attach_block(struct rvu *rvu, int pcifunc,
 			     int blktype, int num_lfs)
 {
@@ -1192,7 +1273,7 @@ static void rvu_attach_block(struct rvu *rvu, int pcifunc,
 	if (!num_lfs)
 		return;
 
-	blkaddr = rvu_get_blkaddr(rvu, blktype, 0);
+	blkaddr = rvu_get_attach_blkaddr(rvu, blktype, pcifunc);
 	if (blkaddr < 0)
 		return;
 
@@ -1221,12 +1302,12 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 				       struct rsrc_attach *req, u16 pcifunc)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	int free_lfs, mappedlfs, blkaddr;
 	struct rvu_hwinfo *hw = rvu->hw;
 	struct rvu_block *block;
-	int free_lfs, mappedlfs;
 
 	/* Only one NPA LF can be attached */
-	if (req->npalf && !rvu_get_rsrc_mapcount(pfvf, BLKTYPE_NPA)) {
+	if (req->npalf && !is_blktype_attached(pfvf, BLKTYPE_NPA)) {
 		block = &hw->block[BLKADDR_NPA];
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (!free_lfs)
@@ -1239,8 +1320,11 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 	}
 
 	/* Only one NIX LF can be attached */
-	if (req->nixlf && !rvu_get_rsrc_mapcount(pfvf, BLKTYPE_NIX)) {
-		block = &hw->block[BLKADDR_NIX0];
+	if (req->nixlf && !is_blktype_attached(pfvf, BLKTYPE_NIX)) {
+		blkaddr = rvu_get_attach_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+		if (blkaddr < 0)
+			return blkaddr;
+		block = &hw->block[blkaddr];
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (!free_lfs)
 			goto fail;
@@ -1260,7 +1344,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 				 pcifunc, req->sso, block->lf.max);
 			return -EINVAL;
 		}
-		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->type);
+		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		/* Check if additional resources are available */
 		if (req->sso > mappedlfs &&
@@ -1276,7 +1360,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 				 pcifunc, req->sso, block->lf.max);
 			return -EINVAL;
 		}
-		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->type);
+		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (req->ssow > mappedlfs &&
 		    ((req->ssow - mappedlfs) > free_lfs))
@@ -1291,7 +1375,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 				 pcifunc, req->timlfs, block->lf.max);
 			return -EINVAL;
 		}
-		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->type);
+		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (req->timlfs > mappedlfs &&
 		    ((req->timlfs - mappedlfs) > free_lfs))
@@ -1306,7 +1390,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 				 pcifunc, req->cptlfs, block->lf.max);
 			return -EINVAL;
 		}
-		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->type);
+		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (req->cptlfs > mappedlfs &&
 		    ((req->cptlfs - mappedlfs) > free_lfs))
@@ -1942,7 +2026,7 @@ static void rvu_blklf_teardown(struct rvu *rvu, u16 pcifunc, u8 blkaddr)
 
 	block = &rvu->hw->block[blkaddr];
 	num_lfs = rvu_get_rsrc_mapcount(rvu_get_pfvf(rvu, pcifunc),
-					block->type);
+					block->addr);
 	if (!num_lfs)
 		return;
 	for (slot = 0; slot < num_lfs; slot++) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 90eed3160915..fc6d785b98dd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -137,6 +137,7 @@ struct rvu_pfvf {
 	u16		ssow;
 	u16		cptlfs;
 	u16		timlfs;
+	u16		cpt1_lfs;
 	u8		cgx_lmac;
 
 	/* Block LF's MSIX vector info */
@@ -182,6 +183,8 @@ struct rvu_pfvf {
 
 	bool	cgx_in_use; /* this PF/VF using CGX? */
 	int	cgx_users;  /* number of cgx users - used only by PFs */
+
+	u8	nix_blkaddr; /* BLKADDR_NIX0/1 assigned to this PF */
 };
 
 struct nix_txsch {
@@ -420,6 +423,7 @@ void rvu_free_rsrc(struct rsrc_bmap *rsrc, int id);
 int rvu_rsrc_free_count(struct rsrc_bmap *rsrc);
 int rvu_alloc_rsrc_contig(struct rsrc_bmap *rsrc, int nrsrc);
 bool rvu_rsrc_check_contig(struct rsrc_bmap *rsrc, int nrsrc);
+u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blkaddr);
 int rvu_get_pf(u16 pcifunc);
 struct rvu_pfvf *rvu_get_pfvf(struct rvu *rvu, int pcifunc);
 void rvu_get_pf_numvfs(struct rvu *rvu, int pf, int *numvfs, int *hwvf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index f4ecc755eaff..6c6b411e78fd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -74,6 +74,20 @@ void *rvu_cgx_pdata(u8 cgx_id, struct rvu *rvu)
 	return rvu->cgx_idmap[cgx_id];
 }
 
+/* Based on P2X connectivity find mapped NIX block for a PF */
+static void rvu_map_cgx_nix_block(struct rvu *rvu, int pf,
+				  int cgx_id, int lmac_id)
+{
+	struct rvu_pfvf *pfvf = &rvu->pf[pf];
+	u8 p2x;
+
+	p2x = cgx_lmac_get_p2x(cgx_id, lmac_id);
+	/* Firmware sets P2X_SELECT as either NIX0 or NIX1 */
+	pfvf->nix_blkaddr = BLKADDR_NIX0;
+	if (p2x == CMR_P2X_SEL_NIX1)
+		pfvf->nix_blkaddr = BLKADDR_NIX1;
+}
+
 static int rvu_map_cgx_lmac_pf(struct rvu *rvu)
 {
 	struct npc_pkind *pkind = &rvu->hw->pkind;
@@ -117,6 +131,7 @@ static int rvu_map_cgx_lmac_pf(struct rvu *rvu)
 			rvu->cgxlmac2pf_map[CGX_OFFSET(cgx) + lmac] = 1 << pf;
 			free_pkind = rvu_alloc_rsrc(&pkind->rsrc);
 			pkind->pfchan_map[free_pkind] = ((pf) & 0x3F) << 16;
+			rvu_map_cgx_nix_block(rvu, pf, cgx, lmac);
 			rvu->cgx_mapped_pfs++;
 		}
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index f6a3cf3e6f23..9886a30e9723 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -187,8 +187,8 @@ static bool is_valid_txschq(struct rvu *rvu, int blkaddr,
 static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	int pkind, pf, vf, lbkid;
 	u8 cgx_id, lmac_id;
-	int pkind, pf, vf;
 	int err;
 
 	pf = rvu_get_pf(pcifunc);
@@ -221,13 +221,24 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 	case NIX_INTF_TYPE_LBK:
 		vf = (pcifunc & RVU_PFVF_FUNC_MASK) - 1;
 
+		/* If NIX1 block is present on the silicon then NIXes are
+		 * assigned alternatively for lbk interfaces. NIX0 should
+		 * send packets on lbk link 1 channels and NIX1 should send
+		 * on lbk link 0 channels for the communication between
+		 * NIX0 and NIX1.
+		 */
+		lbkid = 0;
+		if (rvu->hw->lbk_links > 1)
+			lbkid = vf & 0x1 ? 0 : 1;
+
 		/* Note that AF's VFs work in pairs and talk over consecutive
 		 * loopback channels.Therefore if odd number of AF VFs are
 		 * enabled then the last VF remains with no pair.
 		 */
-		pfvf->rx_chan_base = NIX_CHAN_LBK_CHX(0, vf);
-		pfvf->tx_chan_base = vf & 0x1 ? NIX_CHAN_LBK_CHX(0, vf - 1) :
-						NIX_CHAN_LBK_CHX(0, vf + 1);
+		pfvf->rx_chan_base = NIX_CHAN_LBK_CHX(lbkid, vf);
+		pfvf->tx_chan_base = vf & 0x1 ?
+					NIX_CHAN_LBK_CHX(lbkid, vf - 1) :
+					NIX_CHAN_LBK_CHX(lbkid, vf + 1);
 		pfvf->rx_chan_cnt = 1;
 		pfvf->tx_chan_cnt = 1;
 		rvu_npc_install_promisc_entry(rvu, pcifunc, nixlf,
@@ -3157,7 +3168,7 @@ int rvu_nix_init(struct rvu *rvu)
 	hw->cgx = (cfg >> 12) & 0xF;
 	hw->lmac_per_cgx = (cfg >> 8) & 0xF;
 	hw->cgx_links = hw->cgx * hw->lmac_per_cgx;
-	hw->lbk_links = 1;
+	hw->lbk_links = (cfg >> 24) & 0xF;
 	hw->sdp_links = 1;
 
 	/* Initialize admin queue */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index 038a0f1cecec..e44281ae570d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -88,6 +88,8 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
 	struct udphdr *udp = (struct udphdr *)(buf);
 	struct vxlanhdr *vxh;
 
+	if (tun_key->tun_flags & TUNNEL_VXLAN_OPT)
+		return -EOPNOTSUPP;
 	vxh = (struct vxlanhdr *)((char *)udp + sizeof(struct udphdr));
 	*ip_proto = IPPROTO_UDP;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index c70c1f0ca0c1..44a434b1178b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -440,7 +440,7 @@ static int mlx5_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 static const struct ptp_clock_info mlx5_ptp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "mlx5_ptp",
-	.max_adj	= 100000000,
+	.max_adj	= 50000000,
 	.n_alarm	= 0,
 	.n_ext_ts	= 0,
 	.n_per_out	= 0,
diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index 84f2983bf384..57b07446bb76 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -153,10 +153,17 @@ static int pn533_usb_send_ack(struct pn533 *dev, gfp_t flags)
 	return usb_submit_urb(phy->ack_urb, flags);
 }
 
+struct pn533_out_arg {
+	struct pn533_usb_phy *phy;
+	struct completion done;
+};
+
 static int pn533_usb_send_frame(struct pn533 *dev,
 				struct sk_buff *out)
 {
 	struct pn533_usb_phy *phy = dev->phy;
+	struct pn533_out_arg arg;
+	void *cntx;
 	int rc;
 
 	if (phy->priv == NULL)
@@ -168,10 +175,17 @@ static int pn533_usb_send_frame(struct pn533 *dev,
 	print_hex_dump_debug("PN533 TX: ", DUMP_PREFIX_NONE, 16, 1,
 			     out->data, out->len, false);
 
+	init_completion(&arg.done);
+	cntx = phy->out_urb->context;
+	phy->out_urb->context = &arg;
+
 	rc = usb_submit_urb(phy->out_urb, GFP_KERNEL);
 	if (rc)
 		return rc;
 
+	wait_for_completion(&arg.done);
+	phy->out_urb->context = cntx;
+
 	if (dev->protocol_type == PN533_PROTO_REQ_RESP) {
 		/* request for response for sent packet directly */
 		rc = pn533_submit_urb_for_response(phy, GFP_KERNEL);
@@ -412,7 +426,31 @@ static int pn533_acr122_poweron_rdr(struct pn533_usb_phy *phy)
 	return arg.rc;
 }
 
-static void pn533_send_complete(struct urb *urb)
+static void pn533_out_complete(struct urb *urb)
+{
+	struct pn533_out_arg *arg = urb->context;
+	struct pn533_usb_phy *phy = arg->phy;
+
+	switch (urb->status) {
+	case 0:
+		break; /* success */
+	case -ECONNRESET:
+	case -ENOENT:
+		dev_dbg(&phy->udev->dev,
+			"The urb has been stopped (status %d)\n",
+			urb->status);
+		break;
+	case -ESHUTDOWN:
+	default:
+		nfc_err(&phy->udev->dev,
+			"Urb failure (status %d)\n",
+			urb->status);
+	}
+
+	complete(&arg->done);
+}
+
+static void pn533_ack_complete(struct urb *urb)
 {
 	struct pn533_usb_phy *phy = urb->context;
 
@@ -500,10 +538,10 @@ static int pn533_usb_probe(struct usb_interface *interface,
 
 	usb_fill_bulk_urb(phy->out_urb, phy->udev,
 			  usb_sndbulkpipe(phy->udev, out_endpoint),
-			  NULL, 0, pn533_send_complete, phy);
+			  NULL, 0, pn533_out_complete, phy);
 	usb_fill_bulk_urb(phy->ack_urb, phy->udev,
 			  usb_sndbulkpipe(phy->udev, out_endpoint),
-			  NULL, 0, pn533_send_complete, phy);
+			  NULL, 0, pn533_ack_complete, phy);
 
 	switch (id->driver_info) {
 	case PN533_DEVICE_STD:
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index e5a1b5533408..f070e4eb74f4 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1892,14 +1892,21 @@ static int sony_nc_kbd_backlight_setup(struct platform_device *pd,
 		break;
 	}
 
-	ret = sony_call_snc_handle(handle, probe_base, &result);
-	if (ret)
-		return ret;
+	/*
+	 * Only probe if there is a separate probe_base, otherwise the probe call
+	 * is equivalent to __sony_nc_kbd_backlight_mode_set(0), resulting in
+	 * the keyboard backlight being turned off.
+	 */
+	if (probe_base) {
+		ret = sony_call_snc_handle(handle, probe_base, &result);
+		if (ret)
+			return ret;
 
-	if ((handle == 0x0137 && !(result & 0x02)) ||
-			!(result & 0x01)) {
-		dprintk("no backlight keyboard found\n");
-		return 0;
+		if ((handle == 0x0137 && !(result & 0x02)) ||
+				!(result & 0x01)) {
+			dprintk("no backlight keyboard found\n");
+			return 0;
+		}
 	}
 
 	kbdbl_ctl = kzalloc(sizeof(*kbdbl_ctl), GFP_KERNEL);
diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
index e01b32d1fa17..00828f5baa97 100644
--- a/drivers/regulator/da9211-regulator.c
+++ b/drivers/regulator/da9211-regulator.c
@@ -498,6 +498,12 @@ static int da9211_i2c_probe(struct i2c_client *i2c)
 
 	chip->chip_irq = i2c->irq;
 
+	ret = da9211_regulator_init(chip);
+	if (ret < 0) {
+		dev_err(chip->dev, "Failed to initialize regulator: %d\n", ret);
+		return ret;
+	}
+
 	if (chip->chip_irq != 0) {
 		ret = devm_request_threaded_irq(chip->dev, chip->chip_irq, NULL,
 					da9211_irq_handler,
@@ -512,11 +518,6 @@ static int da9211_i2c_probe(struct i2c_client *i2c)
 		dev_warn(chip->dev, "No IRQ configured\n");
 	}
 
-	ret = da9211_regulator_init(chip);
-
-	if (ret < 0)
-		dev_err(chip->dev, "Failed to initialize regulator: %d\n", ret);
-
 	return ret;
 }
 
diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 7948660e042f..6f387a4fd96a 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -52,17 +52,22 @@ static DEFINE_SPINLOCK(xencons_lock);
 
 static struct xencons_info *vtermno_to_xencons(int vtermno)
 {
-	struct xencons_info *entry, *n, *ret = NULL;
+	struct xencons_info *entry, *ret = NULL;
+	unsigned long flags;
 
-	if (list_empty(&xenconsoles))
-			return NULL;
+	spin_lock_irqsave(&xencons_lock, flags);
+	if (list_empty(&xenconsoles)) {
+		spin_unlock_irqrestore(&xencons_lock, flags);
+		return NULL;
+	}
 
-	list_for_each_entry_safe(entry, n, &xenconsoles, list) {
+	list_for_each_entry(entry, &xenconsoles, list) {
 		if (entry->vtermno == vtermno) {
 			ret  = entry;
 			break;
 		}
 	}
+	spin_unlock_irqrestore(&xencons_lock, flags);
 
 	return ret;
 }
@@ -223,7 +228,7 @@ static int xen_hvm_console_init(void)
 {
 	int r;
 	uint64_t v = 0;
-	unsigned long gfn;
+	unsigned long gfn, flags;
 	struct xencons_info *info;
 
 	if (!xen_hvm_domain())
@@ -258,9 +263,9 @@ static int xen_hvm_console_init(void)
 		goto err;
 	info->vtermno = HVC_COOKIE;
 
-	spin_lock(&xencons_lock);
+	spin_lock_irqsave(&xencons_lock, flags);
 	list_add_tail(&info->list, &xenconsoles);
-	spin_unlock(&xencons_lock);
+	spin_unlock_irqrestore(&xencons_lock, flags);
 
 	return 0;
 err:
@@ -283,6 +288,7 @@ static int xencons_info_pv_init(struct xencons_info *info, int vtermno)
 static int xen_pv_console_init(void)
 {
 	struct xencons_info *info;
+	unsigned long flags;
 
 	if (!xen_pv_domain())
 		return -ENODEV;
@@ -299,9 +305,9 @@ static int xen_pv_console_init(void)
 		/* already configured */
 		return 0;
 	}
-	spin_lock(&xencons_lock);
+	spin_lock_irqsave(&xencons_lock, flags);
 	xencons_info_pv_init(info, HVC_COOKIE);
-	spin_unlock(&xencons_lock);
+	spin_unlock_irqrestore(&xencons_lock, flags);
 
 	return 0;
 }
@@ -309,6 +315,7 @@ static int xen_pv_console_init(void)
 static int xen_initial_domain_console_init(void)
 {
 	struct xencons_info *info;
+	unsigned long flags;
 
 	if (!xen_initial_domain())
 		return -ENODEV;
@@ -323,9 +330,9 @@ static int xen_initial_domain_console_init(void)
 	info->irq = bind_virq_to_irq(VIRQ_CONSOLE, 0, false);
 	info->vtermno = HVC_COOKIE;
 
-	spin_lock(&xencons_lock);
+	spin_lock_irqsave(&xencons_lock, flags);
 	list_add_tail(&info->list, &xenconsoles);
-	spin_unlock(&xencons_lock);
+	spin_unlock_irqrestore(&xencons_lock, flags);
 
 	return 0;
 }
@@ -380,10 +387,12 @@ static void xencons_free(struct xencons_info *info)
 
 static int xen_console_remove(struct xencons_info *info)
 {
+	unsigned long flags;
+
 	xencons_disconnect_backend(info);
-	spin_lock(&xencons_lock);
+	spin_lock_irqsave(&xencons_lock, flags);
 	list_del(&info->list);
-	spin_unlock(&xencons_lock);
+	spin_unlock_irqrestore(&xencons_lock, flags);
 	if (info->xbdev != NULL)
 		xencons_free(info);
 	else {
@@ -464,6 +473,7 @@ static int xencons_probe(struct xenbus_device *dev,
 {
 	int ret, devid;
 	struct xencons_info *info;
+	unsigned long flags;
 
 	devid = dev->nodename[strlen(dev->nodename) - 1] - '0';
 	if (devid == 0)
@@ -482,9 +492,9 @@ static int xencons_probe(struct xenbus_device *dev,
 	ret = xencons_connect_backend(dev, info);
 	if (ret < 0)
 		goto error;
-	spin_lock(&xencons_lock);
+	spin_lock_irqsave(&xencons_lock, flags);
 	list_add_tail(&info->list, &xenconsoles);
-	spin_unlock(&xencons_lock);
+	spin_unlock_irqrestore(&xencons_lock, flags);
 
 	return 0;
 
@@ -583,10 +593,12 @@ static int __init xen_hvc_init(void)
 
 	info->hvc = hvc_alloc(HVC_COOKIE, info->irq, ops, 256);
 	if (IS_ERR(info->hvc)) {
+		unsigned long flags;
+
 		r = PTR_ERR(info->hvc);
-		spin_lock(&xencons_lock);
+		spin_lock_irqsave(&xencons_lock, flags);
 		list_del(&info->list);
-		spin_unlock(&xencons_lock);
+		spin_unlock_irqrestore(&xencons_lock, flags);
 		if (info->irq)
 			unbind_from_irqhandler(info->irq, NULL);
 		kfree(info);
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index d1a42300ae58..a8a9addb4d25 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1003,6 +1003,8 @@ int xhci_alloc_virt_device(struct xhci_hcd *xhci, int slot_id,
 	if (!dev)
 		return 0;
 
+	dev->slot_id = slot_id;
+
 	/* Allocate the (output) device context that will be used in the HC. */
 	dev->out_ctx = xhci_alloc_container_ctx(xhci, XHCI_CTX_TYPE_DEVICE, flags);
 	if (!dev->out_ctx)
@@ -1021,6 +1023,8 @@ int xhci_alloc_virt_device(struct xhci_hcd *xhci, int slot_id,
 
 	/* Initialize the cancellation list and watchdog timers for each ep */
 	for (i = 0; i < 31; i++) {
+		dev->eps[i].ep_index = i;
+		dev->eps[i].vdev = dev;
 		xhci_init_endpoint_timer(xhci, &dev->eps[i]);
 		INIT_LIST_HEAD(&dev->eps[i].cancelled_td_list);
 		INIT_LIST_HEAD(&dev->eps[i].bw_endpoint_list);
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index fa3a7ac15f82..ead42fc3e16d 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -773,6 +773,101 @@ static void xhci_unmap_td_bounce_buffer(struct xhci_hcd *xhci,
 	seg->bounce_offs = 0;
 }
 
+static int xhci_td_cleanup(struct xhci_hcd *xhci, struct xhci_td *td,
+			   struct xhci_ring *ep_ring, int status)
+{
+	struct urb *urb = NULL;
+
+	/* Clean up the endpoint's TD list */
+	urb = td->urb;
+
+	/* if a bounce buffer was used to align this td then unmap it */
+	xhci_unmap_td_bounce_buffer(xhci, ep_ring, td);
+
+	/* Do one last check of the actual transfer length.
+	 * If the host controller said we transferred more data than the buffer
+	 * length, urb->actual_length will be a very big number (since it's
+	 * unsigned).  Play it safe and say we didn't transfer anything.
+	 */
+	if (urb->actual_length > urb->transfer_buffer_length) {
+		xhci_warn(xhci, "URB req %u and actual %u transfer length mismatch\n",
+			  urb->transfer_buffer_length, urb->actual_length);
+		urb->actual_length = 0;
+		status = 0;
+	}
+	list_del_init(&td->td_list);
+	/* Was this TD slated to be cancelled but completed anyway? */
+	if (!list_empty(&td->cancelled_td_list))
+		list_del_init(&td->cancelled_td_list);
+
+	inc_td_cnt(urb);
+	/* Giveback the urb when all the tds are completed */
+	if (last_td_in_urb(td)) {
+		if ((urb->actual_length != urb->transfer_buffer_length &&
+		     (urb->transfer_flags & URB_SHORT_NOT_OK)) ||
+		    (status != 0 && !usb_endpoint_xfer_isoc(&urb->ep->desc)))
+			xhci_dbg(xhci, "Giveback URB %p, len = %d, expected = %d, status = %d\n",
+				 urb, urb->actual_length,
+				 urb->transfer_buffer_length, status);
+
+		/* set isoc urb status to 0 just as EHCI, UHCI, and OHCI */
+		if (usb_pipetype(urb->pipe) == PIPE_ISOCHRONOUS)
+			status = 0;
+		xhci_giveback_urb_in_irq(xhci, td, status);
+	}
+
+	return 0;
+}
+
+static int xhci_reset_halted_ep(struct xhci_hcd *xhci, unsigned int slot_id,
+				unsigned int ep_index, enum xhci_ep_reset_type reset_type)
+{
+	struct xhci_command *command;
+	int ret = 0;
+
+	command = xhci_alloc_command(xhci, false, GFP_ATOMIC);
+	if (!command) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	ret = xhci_queue_reset_ep(xhci, command, slot_id, ep_index, reset_type);
+done:
+	if (ret)
+		xhci_err(xhci, "ERROR queuing reset endpoint for slot %d ep_index %d, %d\n",
+			 slot_id, ep_index, ret);
+	return ret;
+}
+
+static void xhci_handle_halted_endpoint(struct xhci_hcd *xhci,
+				struct xhci_virt_ep *ep, unsigned int stream_id,
+				struct xhci_td *td,
+				enum xhci_ep_reset_type reset_type)
+{
+	unsigned int slot_id = ep->vdev->slot_id;
+	int err;
+
+	/*
+	 * Avoid resetting endpoint if link is inactive. Can cause host hang.
+	 * Device will be reset soon to recover the link so don't do anything
+	 */
+	if (ep->vdev->flags & VDEV_PORT_ERROR)
+		return;
+
+	ep->ep_state |= EP_HALTED;
+
+	err = xhci_reset_halted_ep(xhci, slot_id, ep->ep_index, reset_type);
+	if (err)
+		return;
+
+	if (reset_type == EP_HARD_RESET) {
+		ep->ep_state |= EP_HARD_CLEAR_TOGGLE;
+		xhci_cleanup_stalled_ring(xhci, slot_id, ep->ep_index, stream_id,
+					  td);
+	}
+	xhci_ring_cmd_db(xhci);
+}
+
 /*
  * When we get a command completion for a Stop Endpoint Command, we need to
  * unlink any cancelled TDs from the ring.  There are two ways to do that:
@@ -1924,37 +2019,6 @@ static void xhci_clear_hub_tt_buffer(struct xhci_hcd *xhci, struct xhci_td *td,
 	}
 }
 
-static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
-		unsigned int slot_id, unsigned int ep_index,
-		unsigned int stream_id, struct xhci_td *td,
-		enum xhci_ep_reset_type reset_type)
-{
-	struct xhci_virt_ep *ep = &xhci->devs[slot_id]->eps[ep_index];
-	struct xhci_command *command;
-
-	/*
-	 * Avoid resetting endpoint if link is inactive. Can cause host hang.
-	 * Device will be reset soon to recover the link so don't do anything
-	 */
-	if (xhci->devs[slot_id]->flags & VDEV_PORT_ERROR)
-		return;
-
-	command = xhci_alloc_command(xhci, false, GFP_ATOMIC);
-	if (!command)
-		return;
-
-	ep->ep_state |= EP_HALTED;
-
-	xhci_queue_reset_ep(xhci, command, slot_id, ep_index, reset_type);
-
-	if (reset_type == EP_HARD_RESET) {
-		ep->ep_state |= EP_HARD_CLEAR_TOGGLE;
-		xhci_cleanup_stalled_ring(xhci, slot_id, ep_index, stream_id,
-					  td);
-	}
-	xhci_ring_cmd_db(xhci);
-}
-
 /* Check if an error has halted the endpoint ring.  The class driver will
  * cleanup the halt for a non-default control endpoint if we indicate a stall.
  * However, a babble and other errors also halt the endpoint ring, and the class
@@ -1995,68 +2059,15 @@ int xhci_is_vendor_info_code(struct xhci_hcd *xhci, unsigned int trb_comp_code)
 	return 0;
 }
 
-static int xhci_td_cleanup(struct xhci_hcd *xhci, struct xhci_td *td,
-		struct xhci_ring *ep_ring, int *status)
-{
-	struct urb *urb = NULL;
-
-	/* Clean up the endpoint's TD list */
-	urb = td->urb;
-
-	/* if a bounce buffer was used to align this td then unmap it */
-	xhci_unmap_td_bounce_buffer(xhci, ep_ring, td);
-
-	/* Do one last check of the actual transfer length.
-	 * If the host controller said we transferred more data than the buffer
-	 * length, urb->actual_length will be a very big number (since it's
-	 * unsigned).  Play it safe and say we didn't transfer anything.
-	 */
-	if (urb->actual_length > urb->transfer_buffer_length) {
-		xhci_warn(xhci, "URB req %u and actual %u transfer length mismatch\n",
-			  urb->transfer_buffer_length, urb->actual_length);
-		urb->actual_length = 0;
-		*status = 0;
-	}
-	list_del_init(&td->td_list);
-	/* Was this TD slated to be cancelled but completed anyway? */
-	if (!list_empty(&td->cancelled_td_list))
-		list_del_init(&td->cancelled_td_list);
-
-	inc_td_cnt(urb);
-	/* Giveback the urb when all the tds are completed */
-	if (last_td_in_urb(td)) {
-		if ((urb->actual_length != urb->transfer_buffer_length &&
-		     (urb->transfer_flags & URB_SHORT_NOT_OK)) ||
-		    (*status != 0 && !usb_endpoint_xfer_isoc(&urb->ep->desc)))
-			xhci_dbg(xhci, "Giveback URB %p, len = %d, expected = %d, status = %d\n",
-				 urb, urb->actual_length,
-				 urb->transfer_buffer_length, *status);
-
-		/* set isoc urb status to 0 just as EHCI, UHCI, and OHCI */
-		if (usb_pipetype(urb->pipe) == PIPE_ISOCHRONOUS)
-			*status = 0;
-		xhci_giveback_urb_in_irq(xhci, td, *status);
-	}
-
-	return 0;
-}
-
 static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
-	struct xhci_transfer_event *event,
-	struct xhci_virt_ep *ep, int *status)
+	struct xhci_transfer_event *event, struct xhci_virt_ep *ep)
 {
-	struct xhci_virt_device *xdev;
 	struct xhci_ep_ctx *ep_ctx;
 	struct xhci_ring *ep_ring;
-	unsigned int slot_id;
 	u32 trb_comp_code;
-	int ep_index;
 
-	slot_id = TRB_TO_SLOT_ID(le32_to_cpu(event->flags));
-	xdev = xhci->devs[slot_id];
-	ep_index = TRB_TO_EP_ID(le32_to_cpu(event->flags)) - 1;
 	ep_ring = xhci_dma_to_transfer_ring(ep, le64_to_cpu(event->buffer));
-	ep_ctx = xhci_get_ep_ctx(xhci, xdev->out_ctx, ep_index);
+	ep_ctx = xhci_get_ep_ctx(xhci, ep->vdev->out_ctx, ep->ep_index);
 	trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
 
 	if (trb_comp_code == COMP_STOPPED_LENGTH_INVALID ||
@@ -2081,10 +2092,11 @@ static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		 * stall later. Hub TT buffer should only be cleared for FS/LS
 		 * devices behind HS hubs for functional stalls.
 		 */
-		if ((ep_index != 0) || (trb_comp_code != COMP_STALL_ERROR))
+		if ((ep->ep_index != 0) || (trb_comp_code != COMP_STALL_ERROR))
 			xhci_clear_hub_tt_buffer(xhci, td, ep);
-		xhci_cleanup_halted_endpoint(xhci, slot_id, ep_index,
-					ep_ring->stream_id, td, EP_HARD_RESET);
+
+		xhci_handle_halted_endpoint(xhci, ep, ep_ring->stream_id, td,
+					     EP_HARD_RESET);
 	} else {
 		/* Update ring dequeue pointer */
 		while (ep_ring->dequeue != td->last_trb)
@@ -2092,7 +2104,7 @@ static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		inc_deq(xhci, ep_ring);
 	}
 
-	return xhci_td_cleanup(xhci, td, ep_ring, status);
+	return xhci_td_cleanup(xhci, td, ep_ring, td->status);
 }
 
 /* sum trb lengths from ring dequeue up to stop_trb, _excluding_ stop_trb */
@@ -2115,21 +2127,15 @@ static int sum_trb_lengths(struct xhci_hcd *xhci, struct xhci_ring *ring,
  */
 static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	union xhci_trb *ep_trb, struct xhci_transfer_event *event,
-	struct xhci_virt_ep *ep, int *status)
+	struct xhci_virt_ep *ep)
 {
-	struct xhci_virt_device *xdev;
-	unsigned int slot_id;
-	int ep_index;
 	struct xhci_ep_ctx *ep_ctx;
 	u32 trb_comp_code;
 	u32 remaining, requested;
 	u32 trb_type;
 
 	trb_type = TRB_FIELD_TO_TYPE(le32_to_cpu(ep_trb->generic.field[3]));
-	slot_id = TRB_TO_SLOT_ID(le32_to_cpu(event->flags));
-	xdev = xhci->devs[slot_id];
-	ep_index = TRB_TO_EP_ID(le32_to_cpu(event->flags)) - 1;
-	ep_ctx = xhci_get_ep_ctx(xhci, xdev->out_ctx, ep_index);
+	ep_ctx = xhci_get_ep_ctx(xhci, ep->vdev->out_ctx, ep->ep_index);
 	trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
 	requested = td->urb->transfer_buffer_length;
 	remaining = EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
@@ -2139,13 +2145,13 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		if (trb_type != TRB_STATUS) {
 			xhci_warn(xhci, "WARN: Success on ctrl %s TRB without IOC set?\n",
 				  (trb_type == TRB_DATA) ? "data" : "setup");
-			*status = -ESHUTDOWN;
+			td->status = -ESHUTDOWN;
 			break;
 		}
-		*status = 0;
+		td->status = 0;
 		break;
 	case COMP_SHORT_PACKET:
-		*status = 0;
+		td->status = 0;
 		break;
 	case COMP_STOPPED_SHORT_PACKET:
 		if (trb_type == TRB_DATA || trb_type == TRB_NORMAL)
@@ -2177,7 +2183,7 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 						       ep_ctx, trb_comp_code))
 			break;
 		xhci_dbg(xhci, "TRB error %u, halted endpoint index = %u\n",
-			 trb_comp_code, ep_index);
+			 trb_comp_code, ep->ep_index);
 		fallthrough;
 	case COMP_STALL_ERROR:
 		/* Did we transfer part of the data (middle) phase? */
@@ -2209,7 +2215,7 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		td->urb->actual_length = requested;
 
 finish_td:
-	return finish_td(xhci, td, event, ep, status);
+	return finish_td(xhci, td, event, ep);
 }
 
 /*
@@ -2217,9 +2223,8 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
  */
 static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	union xhci_trb *ep_trb, struct xhci_transfer_event *event,
-	struct xhci_virt_ep *ep, int *status)
+	struct xhci_virt_ep *ep)
 {
-	struct xhci_ring *ep_ring;
 	struct urb_priv *urb_priv;
 	int idx;
 	struct usb_iso_packet_descriptor *frame;
@@ -2228,7 +2233,6 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	u32 remaining, requested, ep_trb_len;
 	int short_framestatus;
 
-	ep_ring = xhci_dma_to_transfer_ring(ep, le64_to_cpu(event->buffer));
 	trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
 	urb_priv = td->urb->hcpriv;
 	idx = urb_priv->num_tds_done;
@@ -2289,26 +2293,23 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	}
 
 	if (sum_trbs_for_length)
-		frame->actual_length = sum_trb_lengths(xhci, ep_ring, ep_trb) +
+		frame->actual_length = sum_trb_lengths(xhci, ep->ring, ep_trb) +
 			ep_trb_len - remaining;
 	else
 		frame->actual_length = requested;
 
 	td->urb->actual_length += frame->actual_length;
 
-	return finish_td(xhci, td, event, ep, status);
+	return finish_td(xhci, td, event, ep);
 }
 
 static int skip_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
-			struct xhci_transfer_event *event,
-			struct xhci_virt_ep *ep, int *status)
+			struct xhci_virt_ep *ep, int status)
 {
-	struct xhci_ring *ep_ring;
 	struct urb_priv *urb_priv;
 	struct usb_iso_packet_descriptor *frame;
 	int idx;
 
-	ep_ring = xhci_dma_to_transfer_ring(ep, le64_to_cpu(event->buffer));
 	urb_priv = td->urb->hcpriv;
 	idx = urb_priv->num_tds_done;
 	frame = &td->urb->iso_frame_desc[idx];
@@ -2320,11 +2321,11 @@ static int skip_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	frame->actual_length = 0;
 
 	/* Update ring dequeue pointer */
-	while (ep_ring->dequeue != td->last_trb)
-		inc_deq(xhci, ep_ring);
-	inc_deq(xhci, ep_ring);
+	while (ep->ring->dequeue != td->last_trb)
+		inc_deq(xhci, ep->ring);
+	inc_deq(xhci, ep->ring);
 
-	return xhci_td_cleanup(xhci, td, ep_ring, status);
+	return xhci_td_cleanup(xhci, td, ep->ring, status);
 }
 
 /*
@@ -2332,18 +2333,14 @@ static int skip_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
  */
 static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	union xhci_trb *ep_trb, struct xhci_transfer_event *event,
-	struct xhci_virt_ep *ep, int *status)
+	struct xhci_virt_ep *ep)
 {
 	struct xhci_slot_ctx *slot_ctx;
 	struct xhci_ring *ep_ring;
 	u32 trb_comp_code;
 	u32 remaining, requested, ep_trb_len;
-	unsigned int slot_id;
-	int ep_index;
 
-	slot_id = TRB_TO_SLOT_ID(le32_to_cpu(event->flags));
-	slot_ctx = xhci_get_slot_ctx(xhci, xhci->devs[slot_id]->out_ctx);
-	ep_index = TRB_TO_EP_ID(le32_to_cpu(event->flags)) - 1;
+	slot_ctx = xhci_get_slot_ctx(xhci, ep->vdev->out_ctx);
 	ep_ring = xhci_dma_to_transfer_ring(ep, le64_to_cpu(event->buffer));
 	trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
 	remaining = EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
@@ -2352,7 +2349,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 
 	switch (trb_comp_code) {
 	case COMP_SUCCESS:
-		ep_ring->err_count = 0;
+		ep->err_count = 0;
 		/* handle success with untransferred data as short packet */
 		if (ep_trb != td->last_trb || remaining) {
 			xhci_warn(xhci, "WARN Successful completion on short TX\n");
@@ -2360,13 +2357,13 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 				 td->urb->ep->desc.bEndpointAddress,
 				 requested, remaining);
 		}
-		*status = 0;
+		td->status = 0;
 		break;
 	case COMP_SHORT_PACKET:
 		xhci_dbg(xhci, "ep %#x - asked for %d bytes, %d bytes untransferred\n",
 			 td->urb->ep->desc.bEndpointAddress,
 			 requested, remaining);
-		*status = 0;
+		td->status = 0;
 		break;
 	case COMP_STOPPED_SHORT_PACKET:
 		td->urb->actual_length = remaining;
@@ -2378,12 +2375,14 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		break;
 	case COMP_USB_TRANSACTION_ERROR:
 		if (xhci->quirks & XHCI_NO_SOFT_RETRY ||
-		    (ep_ring->err_count++ > MAX_SOFT_RETRY) ||
+		    (ep->err_count++ > MAX_SOFT_RETRY) ||
 		    le32_to_cpu(slot_ctx->tt_info) & TT_SLOT)
 			break;
-		*status = 0;
-		xhci_cleanup_halted_endpoint(xhci, slot_id, ep_index,
-					ep_ring->stream_id, td, EP_SOFT_RESET);
+
+		td->status = 0;
+
+		xhci_handle_halted_endpoint(xhci, ep, ep_ring->stream_id, td,
+					    EP_SOFT_RESET);
 		return 0;
 	default:
 		/* do nothing */
@@ -2402,7 +2401,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 			  remaining);
 		td->urb->actual_length = 0;
 	}
-	return finish_td(xhci, td, event, ep, status);
+	return finish_td(xhci, td, event, ep);
 }
 
 /*
@@ -2458,8 +2457,14 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		case COMP_USB_TRANSACTION_ERROR:
 		case COMP_INVALID_STREAM_TYPE_ERROR:
 		case COMP_INVALID_STREAM_ID_ERROR:
-			xhci_cleanup_halted_endpoint(xhci, slot_id, ep_index, 0,
-						     NULL, EP_SOFT_RESET);
+			xhci_dbg(xhci, "Stream transaction error ep %u no id\n",
+				 ep_index);
+			if (ep->err_count++ > MAX_SOFT_RETRY)
+				xhci_handle_halted_endpoint(xhci, ep, 0, NULL,
+							    EP_HARD_RESET);
+			else
+				xhci_handle_halted_endpoint(xhci, ep, 0, NULL,
+							    EP_SOFT_RESET);
 			goto cleanup;
 		case COMP_RING_UNDERRUN:
 		case COMP_RING_OVERRUN:
@@ -2642,11 +2647,10 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 			if (trb_comp_code == COMP_STALL_ERROR ||
 			    xhci_requires_manual_halt_cleanup(xhci, ep_ctx,
 							      trb_comp_code)) {
-				xhci_cleanup_halted_endpoint(xhci, slot_id,
-							     ep_index,
-							     ep_ring->stream_id,
-							     NULL,
-							     EP_HARD_RESET);
+				xhci_handle_halted_endpoint(xhci, ep,
+							    ep_ring->stream_id,
+							    NULL,
+							    EP_HARD_RESET);
 			}
 			goto cleanup;
 		}
@@ -2705,7 +2709,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 				return -ESHUTDOWN;
 			}
 
-			skip_isoc_td(xhci, td, event, ep, &status);
+			skip_isoc_td(xhci, td, ep, status);
 			goto cleanup;
 		}
 		if (trb_comp_code == COMP_SHORT_PACKET)
@@ -2733,25 +2737,26 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		 * endpoint. Otherwise, the endpoint remains stalled
 		 * indefinitely.
 		 */
+
 		if (trb_is_noop(ep_trb)) {
 			if (trb_comp_code == COMP_STALL_ERROR ||
 			    xhci_requires_manual_halt_cleanup(xhci, ep_ctx,
 							      trb_comp_code))
-				xhci_cleanup_halted_endpoint(xhci, slot_id,
-							     ep_index,
-							     ep_ring->stream_id,
-							     td, EP_HARD_RESET);
+				xhci_handle_halted_endpoint(xhci, ep,
+							    ep_ring->stream_id,
+							    td, EP_HARD_RESET);
 			goto cleanup;
 		}
 
+		td->status = status;
+
 		/* update the urb's actual_length and give back to the core */
 		if (usb_endpoint_xfer_control(&td->urb->ep->desc))
-			process_ctrl_td(xhci, td, ep_trb, event, ep, &status);
+			process_ctrl_td(xhci, td, ep_trb, event, ep);
 		else if (usb_endpoint_xfer_isoc(&td->urb->ep->desc))
-			process_isoc_td(xhci, td, ep_trb, event, ep, &status);
+			process_isoc_td(xhci, td, ep_trb, event, ep);
 		else
-			process_bulk_intr_td(xhci, td, ep_trb, event, ep,
-					     &status);
+			process_bulk_intr_td(xhci, td, ep_trb, event, ep);
 cleanup:
 		handling_skipped_tds = ep->skip &&
 			trb_comp_code != COMP_MISSED_SERVICE_ERROR &&
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 059050f13522..ac09b171b783 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -924,6 +924,8 @@ struct xhci_bw_info {
 #define SS_BW_RESERVED		10
 
 struct xhci_virt_ep {
+	struct xhci_virt_device		*vdev;	/* parent */
+	unsigned int			ep_index;
 	struct xhci_ring		*ring;
 	/* Related to endpoints that are configured to use stream IDs only */
 	struct xhci_stream_info		*stream_info;
@@ -931,6 +933,7 @@ struct xhci_virt_ep {
 	 * have to restore the device state to the previous state
 	 */
 	struct xhci_ring		*new_ring;
+	unsigned int			err_count;
 	unsigned int			ep_state;
 #define SET_DEQ_PENDING		(1 << 0)
 #define EP_HALTED		(1 << 1)	/* For stall handling */
@@ -1002,6 +1005,7 @@ struct xhci_interval_bw_table {
 #define EP_CTX_PER_DEV		31
 
 struct xhci_virt_device {
+	int				slot_id;
 	struct usb_device		*udev;
 	/*
 	 * Commands to the hardware are passed an "input context" that
@@ -1541,6 +1545,7 @@ struct xhci_segment {
 struct xhci_td {
 	struct list_head	td_list;
 	struct list_head	cancelled_td_list;
+	int			status;
 	struct urb		*urb;
 	struct xhci_segment	*start_seg;
 	union xhci_trb		*first_trb;
@@ -1612,7 +1617,6 @@ struct xhci_ring {
 	 * if we own the TRB (if we are the consumer).  See section 4.9.1.
 	 */
 	u32			cycle_state;
-	unsigned int            err_count;
 	unsigned int		stream_id;
 	unsigned int		num_segs;
 	unsigned int		num_trbs_free;
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 85d30fef98a2..4fc6eb8e786d 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -471,6 +471,7 @@ smb3_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	oparms.disposition = FILE_CREATE;
 	oparms.fid = &fid;
 	oparms.reconnect = false;
+	oparms.mode = 0644;
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       NULL, NULL);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 935589579b8f..e940fb07ef2e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1279,6 +1279,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 		return NULL;
 
 	inode_set_iversion(&ei->vfs_inode, 1);
+	ei->i_flags = 0;
 	spin_lock_init(&ei->i_raw_lock);
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	atomic_set(&ei->i_prealloc_active, 0);
diff --git a/include/dt-bindings/clock/imx8mp-clock.h b/include/dt-bindings/clock/imx8mp-clock.h
index e8d68fbb6e3f..d7e513243dd2 100644
--- a/include/dt-bindings/clock/imx8mp-clock.h
+++ b/include/dt-bindings/clock/imx8mp-clock.h
@@ -321,8 +321,16 @@
 #define IMX8MP_CLK_AUDIO_AXI			310
 #define IMX8MP_CLK_HSIO_AXI			311
 #define IMX8MP_CLK_MEDIA_ISP			312
+#define IMX8MP_CLK_MEDIA_DISP2_PIX		313
+#define IMX8MP_CLK_CLKOUT1_SEL			314
+#define IMX8MP_CLK_CLKOUT1_DIV			315
+#define IMX8MP_CLK_CLKOUT1			316
+#define IMX8MP_CLK_CLKOUT2_SEL			317
+#define IMX8MP_CLK_CLKOUT2_DIV			318
+#define IMX8MP_CLK_CLKOUT2			319
+#define IMX8MP_CLK_USB_SUSP			320
 
-#define IMX8MP_CLK_END				313
+#define IMX8MP_CLK_END				321
 
 #define IMX8MP_CLK_AUDIOMIX_SAI1_IPG		0
 #define IMX8MP_CLK_AUDIOMIX_SAI1_MCLK1		1
diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
index 20c0ff54b7a0..7d68a5cc5881 100644
--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -198,8 +198,8 @@ static __always_inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *ev
 	 * The loop below will unmap these fields if the log is larger than
 	 * one page, so save them here for reference:
 	 */
-	count = READ_ONCE(event->count);
-	event_type = READ_ONCE(event->event_type);
+	count = event->count;
+	event_type = event->event_type;
 
 	/* Verify that it's the log header */
 	if (event_header->pcr_idx != 0 ||
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 6031fb319d87..87bc38b47103 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1217,6 +1217,12 @@ static void io_wq_cancel_tw_create(struct io_wq *wq)
 
 		worker = container_of(cb, struct io_worker, create_work);
 		io_worker_cancel_cb(worker);
+		/*
+		 * Only the worker continuation helper has worker allocated and
+		 * hence needs freeing.
+		 */
+		if (cb->func == create_worker_cont)
+			kfree(worker);
 	}
 }
 
diff --git a/mm/memblock.c b/mm/memblock.c
index f72d53957033..f6a4dffb9a88 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1597,7 +1597,13 @@ void __init __memblock_free_late(phys_addr_t base, phys_addr_t size)
 	end = PFN_DOWN(base + size);
 
 	for (; cursor < end; cursor++) {
-		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
+		/*
+		 * Reserved pages are always initialized by the end of
+		 * memblock_free_all() (by memmap_init() and, if deferred
+		 * initialization is enabled, memmap_init_reserved_pages()), so
+		 * these pages can be released directly to the buddy allocator.
+		 */
+		__free_pages_core(pfn_to_page(cursor), 0);
 		totalram_pages_inc();
 	}
 }
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 31eb54e92b3f..110254f44a46 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -539,6 +539,7 @@ static int rawv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 static int rawv6_push_pending_frames(struct sock *sk, struct flowi6 *fl6,
 				     struct raw6_sock *rp)
 {
+	struct ipv6_txoptions *opt;
 	struct sk_buff *skb;
 	int err = 0;
 	int offset;
@@ -556,6 +557,9 @@ static int rawv6_push_pending_frames(struct sock *sk, struct flowi6 *fl6,
 
 	offset = rp->offset;
 	total_len = inet_sk(sk)->cork.base.length;
+	opt = inet6_sk(sk)->cork.opt;
+	total_len -= opt ? opt->opt_flen : 0;
+
 	if (offset >= total_len - 1) {
 		err = -EINVAL;
 		ip6_flush_pending_frames(sk);
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index a8ce04a4bb72..e4fa00abde6a 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -308,8 +308,8 @@ bitmap_ip_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 			return -IPSET_ERR_BITMAP_RANGE;
 
 		pr_debug("mask_bits %u, netmask %u\n", mask_bits, netmask);
-		hosts = 2 << (32 - netmask - 1);
-		elements = 2 << (netmask - mask_bits - 1);
+		hosts = 2U << (32 - netmask - 1);
+		elements = 2UL << (netmask - mask_bits - 1);
 	}
 	if (elements > IPSET_BITMAP_MAX_RANGE + 1)
 		return -IPSET_ERR_BITMAP_RANGE_SIZE;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 551e0d6cf63d..74c220eeec1a 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -62,7 +62,7 @@ nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
 			return false;
 
 		if (offset + len > VLAN_ETH_HLEN + vlan_hlen)
-			ethlen -= offset + len - VLAN_ETH_HLEN + vlan_hlen;
+			ethlen -= offset + len - VLAN_ETH_HLEN - vlan_hlen;
 
 		memcpy(dst_u8, vlanh + offset - vlan_hlen, ethlen);
 
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index d1486ea496a2..09799412b248 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -133,6 +133,11 @@ static int valid_label(const struct nlattr *attr,
 {
 	const u32 *label = nla_data(attr);
 
+	if (nla_len(attr) != sizeof(*label)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid MPLS label length");
+		return -EINVAL;
+	}
+
 	if (*label & ~MPLS_LABEL_MASK || *label == MPLS_LABEL_IMPLNULL) {
 		NL_SET_ERR_MSG_MOD(extack, "MPLS label out of range");
 		return -EINVAL;
@@ -144,7 +149,8 @@ static int valid_label(const struct nlattr *attr,
 static const struct nla_policy mpls_policy[TCA_MPLS_MAX + 1] = {
 	[TCA_MPLS_PARMS]	= NLA_POLICY_EXACT_LEN(sizeof(struct tc_mpls)),
 	[TCA_MPLS_PROTO]	= { .type = NLA_U16 },
-	[TCA_MPLS_LABEL]	= NLA_POLICY_VALIDATE_FN(NLA_U32, valid_label),
+	[TCA_MPLS_LABEL]	= NLA_POLICY_VALIDATE_FN(NLA_BINARY,
+							 valid_label),
 	[TCA_MPLS_TC]		= NLA_POLICY_RANGE(NLA_U8, 0, 7),
 	[TCA_MPLS_TTL]		= NLA_POLICY_MIN(NLA_U8, 1),
 	[TCA_MPLS_BOS]		= NLA_POLICY_RANGE(NLA_U8, 0, 1),
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 7589f2ac6fd0..38f61dccb855 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1152,8 +1152,9 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 	bool addr_match = false;
 	bool sign_match = false;
 	bool link_up = false;
+	bool link_is_reset = false;
 	bool accept_addr = false;
-	bool reset = true;
+	bool reset = false;
 	char *if_name;
 	unsigned long intv;
 	u16 session;
@@ -1173,14 +1174,14 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 	/* Prepare to validate requesting node's signature and media address */
 	l = le->link;
 	link_up = l && tipc_link_is_up(l);
+	link_is_reset = l && tipc_link_is_reset(l);
 	addr_match = l && !memcmp(&le->maddr, maddr, sizeof(*maddr));
 	sign_match = (signature == n->signature);
 
 	/* These three flags give us eight permutations: */
 
 	if (sign_match && addr_match && link_up) {
-		/* All is fine. Do nothing. */
-		reset = false;
+		/* All is fine. Ignore requests. */
 		/* Peer node is not a container/local namespace */
 		if (!n->peer_hash_mix)
 			n->peer_hash_mix = hash_mixes;
@@ -1205,6 +1206,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		 */
 		accept_addr = true;
 		*respond = true;
+		reset = true;
 	} else if (!sign_match && addr_match && link_up) {
 		/* Peer node rebooted. Two possibilities:
 		 *  - Delayed re-discovery; this link endpoint has already
@@ -1236,6 +1238,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		n->signature = signature;
 		accept_addr = true;
 		*respond = true;
+		reset = true;
 	}
 
 	if (!accept_addr)
@@ -1264,6 +1267,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		tipc_link_fsm_evt(l, LINK_RESET_EVT);
 		if (n->state == NODE_FAILINGOVER)
 			tipc_link_fsm_evt(l, LINK_FAILOVER_BEGIN_EVT);
+		link_is_reset = tipc_link_is_reset(l);
 		le->link = l;
 		n->link_cnt++;
 		tipc_node_calculate_timer(n, l);
@@ -1276,7 +1280,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 	memcpy(&le->maddr, maddr, sizeof(*maddr));
 exit:
 	tipc_node_write_unlock(n);
-	if (reset && l && !tipc_link_is_reset(l))
+	if (reset && !link_is_reset)
 		tipc_node_link_down(n, b->identity, false);
 	tipc_node_put(n);
 }
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index d9841f44487f..c6bf3898d1bf 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1920,6 +1920,7 @@ static int xfrm_notify_userpolicy(struct net *net)
 	int len = NLMSG_ALIGN(sizeof(*up));
 	struct nlmsghdr *nlh;
 	struct sk_buff *skb;
+	int err;
 
 	skb = nlmsg_new(len, GFP_ATOMIC);
 	if (skb == NULL)
@@ -1938,7 +1939,11 @@ static int xfrm_notify_userpolicy(struct net *net)
 
 	nlmsg_end(skb, nlh);
 
-	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_POLICY);
+	rcu_read_lock();
+	err = xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_POLICY);
+	rcu_read_unlock();
+
+	return err;
 }
 
 static bool xfrm_userpolicy_is_valid(__u8 policy)
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index b2c9cdfb83e6..eb7dd457ef5a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4581,6 +4581,16 @@ static void alc285_fixup_hp_coef_micmute_led(struct hda_codec *codec,
 	}
 }
 
+static void alc285_fixup_hp_gpio_micmute_led(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		spec->micmute_led_polarity = 1;
+	alc_fixup_hp_gpio_led(codec, action, 0, 0x04);
+}
+
 static void alc236_fixup_hp_coef_micmute_led(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)
 {
@@ -4602,6 +4612,13 @@ static void alc285_fixup_hp_mute_led(struct hda_codec *codec,
 	alc285_fixup_hp_coef_micmute_led(codec, fix, action);
 }
 
+static void alc285_fixup_hp_spectre_x360_mute_led(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	alc285_fixup_hp_mute_led_coefbit(codec, fix, action);
+	alc285_fixup_hp_gpio_micmute_led(codec, fix, action);
+}
+
 static void alc236_fixup_hp_mute_led(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)
 {
@@ -6856,6 +6873,7 @@ enum {
 	ALC285_FIXUP_ASUS_G533Z_PINS,
 	ALC285_FIXUP_HP_GPIO_LED,
 	ALC285_FIXUP_HP_MUTE_LED,
+	ALC285_FIXUP_HP_SPECTRE_X360_MUTE_LED,
 	ALC236_FIXUP_HP_GPIO_LED,
 	ALC236_FIXUP_HP_MUTE_LED,
 	ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF,
@@ -8224,6 +8242,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_hp_mute_led,
 	},
+	[ALC285_FIXUP_HP_SPECTRE_X360_MUTE_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_hp_spectre_x360_mute_led,
+	},
 	[ALC236_FIXUP_HP_GPIO_LED] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc236_fixup_hp_gpio_led,
@@ -8936,6 +8958,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x86e7, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x86e8, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
+	SND_PCI_QUIRK(0x103c, 0x86f9, "HP Spectre x360 13-aw0xxx", ALC285_FIXUP_HP_SPECTRE_X360_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8716, "HP Elite Dragonfly G2 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8720, "HP EliteBook x360 1040 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8724, "HP EliteBook 850 G7", ALC285_FIXUP_HP_GPIO_LED),
diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index 1c360bae5652..cc96c9bdff41 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -697,6 +697,7 @@ static int out_pga_event(struct snd_soc_dapm_widget *w,
 	int dcs_mask;
 	int dcs_l, dcs_r;
 	int dcs_l_reg, dcs_r_reg;
+	int an_out_reg;
 	int timeout;
 	int pwr_reg;
 
@@ -712,6 +713,7 @@ static int out_pga_event(struct snd_soc_dapm_widget *w,
 		dcs_mask = WM8904_DCS_ENA_CHAN_0 | WM8904_DCS_ENA_CHAN_1;
 		dcs_r_reg = WM8904_DC_SERVO_8;
 		dcs_l_reg = WM8904_DC_SERVO_9;
+		an_out_reg = WM8904_ANALOGUE_OUT1_LEFT;
 		dcs_l = 0;
 		dcs_r = 1;
 		break;
@@ -720,6 +722,7 @@ static int out_pga_event(struct snd_soc_dapm_widget *w,
 		dcs_mask = WM8904_DCS_ENA_CHAN_2 | WM8904_DCS_ENA_CHAN_3;
 		dcs_r_reg = WM8904_DC_SERVO_6;
 		dcs_l_reg = WM8904_DC_SERVO_7;
+		an_out_reg = WM8904_ANALOGUE_OUT2_LEFT;
 		dcs_l = 2;
 		dcs_r = 3;
 		break;
@@ -792,6 +795,10 @@ static int out_pga_event(struct snd_soc_dapm_widget *w,
 		snd_soc_component_update_bits(component, reg,
 				    WM8904_HPL_ENA_OUTP | WM8904_HPR_ENA_OUTP,
 				    WM8904_HPL_ENA_OUTP | WM8904_HPR_ENA_OUTP);
+
+		/* Update volume, requires PGA to be powered */
+		val = snd_soc_component_read(component, an_out_reg);
+		snd_soc_component_write(component, an_out_reg, val);
 		break;
 
 	case SND_SOC_DAPM_POST_PMU:
diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index ecd6c049ace2..9e70c193d7f4 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -816,10 +816,11 @@ static void of_lpass_cpu_parse_dai_data(struct device *dev,
 					struct lpass_data *data)
 {
 	struct device_node *node;
-	int ret, id;
+	int ret, i, id;
 
 	/* Allow all channels by default for backwards compatibility */
-	for (id = 0; id < data->variant->num_dai; id++) {
+	for (i = 0; i < data->variant->num_dai; i++) {
+		id = data->variant->dai_driver[i].id;
 		data->mi2s_playback_sd_mode[id] = LPAIF_I2SCTL_MODE_8CH;
 		data->mi2s_capture_sd_mode[id] = LPAIF_I2SCTL_MODE_8CH;
 	}
diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index d96e86ddd2c5..18452f12510c 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -2449,7 +2449,7 @@ static int find_dso_sym(struct dso *dso, const char *sym_name, u64 *start,
 				*size = sym->start - *start;
 			if (idx > 0) {
 				if (*size)
-					return 1;
+					return 0;
 			} else if (dso_sym_match(sym, sym_name, &cnt, idx)) {
 				print_duplicate_syms(dso, sym_name);
 				return -EINVAL;

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC72671B1C
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 12:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjARLqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 06:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjARLoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 06:44:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A90966CC3;
        Wed, 18 Jan 2023 03:05:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10321B81C52;
        Wed, 18 Jan 2023 11:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04EEC433F0;
        Wed, 18 Jan 2023 11:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674039923;
        bh=uWyPobMLNXR7kjjbO2AxjrfJuJBJXz8W05xrMe38zkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YczJIcsjYpE0v/S04TUUyfmitk4gaLIqgjuanztd1tQG4Ux8gXAJi3E7TqLZSJ9Jj
         epx+EeHN7XksSp/O2xWya+ZTSHIYQGaJglladCyi/YMH9OIXuGh+EYBX48zdIGTbLH
         Ej/h6tlBCj6LnrzolTdl8vN91PPPA+toSoU7nAr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.89
Date:   Wed, 18 Jan 2023 12:05:14 +0100
Message-Id: <167403991312510@kroah.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <167403991380253@kroah.com>
References: <167403991380253@kroah.com>
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

diff --git a/Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml b/Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml
index 35426fde8610..283a12cd3e14 100644
--- a/Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml
+++ b/Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml
@@ -31,7 +31,7 @@ properties:
       - description: Display byte clock
       - description: Display byte interface clock
       - description: Display pixel clock
-      - description: Display escape clock
+      - description: Display core clock
       - description: Display AHB clock
       - description: Display AXI clock
 
@@ -135,8 +135,6 @@ required:
   - phy-names
   - assigned-clocks
   - assigned-clock-parents
-  - power-domains
-  - operating-points-v2
   - ports
 
 additionalProperties: false
diff --git a/Documentation/devicetree/bindings/display/msm/dsi-phy-10nm.yaml b/Documentation/devicetree/bindings/display/msm/dsi-phy-10nm.yaml
index 4399715953e1..4dd5eed50506 100644
--- a/Documentation/devicetree/bindings/display/msm/dsi-phy-10nm.yaml
+++ b/Documentation/devicetree/bindings/display/msm/dsi-phy-10nm.yaml
@@ -39,7 +39,6 @@ required:
   - compatible
   - reg
   - reg-names
-  - vdds-supply
 
 unevaluatedProperties: false
 
diff --git a/Documentation/devicetree/bindings/display/msm/dsi-phy-14nm.yaml b/Documentation/devicetree/bindings/display/msm/dsi-phy-14nm.yaml
index 064df50e21a5..23355ac67d3d 100644
--- a/Documentation/devicetree/bindings/display/msm/dsi-phy-14nm.yaml
+++ b/Documentation/devicetree/bindings/display/msm/dsi-phy-14nm.yaml
@@ -37,7 +37,6 @@ required:
   - compatible
   - reg
   - reg-names
-  - vcca-supply
 
 unevaluatedProperties: false
 
diff --git a/Documentation/devicetree/bindings/display/msm/dsi-phy-28nm.yaml b/Documentation/devicetree/bindings/display/msm/dsi-phy-28nm.yaml
index 69eecaa64b18..ddb0ac4c29d4 100644
--- a/Documentation/devicetree/bindings/display/msm/dsi-phy-28nm.yaml
+++ b/Documentation/devicetree/bindings/display/msm/dsi-phy-28nm.yaml
@@ -34,6 +34,10 @@ properties:
   vddio-supply:
     description: Phandle to vdd-io regulator device node.
 
+  qcom,dsi-phy-regulator-ldo-mode:
+    type: boolean
+    description: Indicates if the LDO mode PHY regulator is wanted.
+
 required:
   - compatible
   - reg
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
index a6729c8cf063..b550f43214c7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7265,3 +7265,63 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
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
index f7ff35b0cf6f..9ebe9ddb8641 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 88
+SUBLEVEL = 89
 EXTRAVERSION =
 NAME = Trick or Treat
 
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
index fd418955e31e..64f8a90d3327 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -366,8 +366,26 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 
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
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 8d741f71377f..964c2134ea1e 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -83,6 +83,10 @@ quiet_cmd_hypcopy = HYPCOPY $@
 # Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
 # This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotations.
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_CFI), $(KBUILD_CFLAGS))
+# Starting from 13.0.0 llvm emits SHT_REL section '.llvm.call-graph-profile'
+# when profile optimization is applied. gen-hyprel does not support SHT_REL and
+# causes a build failure. Remove profile optimization flags.
+KBUILD_CFLAGS := $(filter-out -fprofile-sample-use=% -fprofile-use=%, $(KBUILD_CFLAGS))
 
 # KVM nVHE code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
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
index e7583fbcc8fa..6ec93eec03ea 100644
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
 
@@ -1526,10 +1522,10 @@ static int init_nest_pmu_ref(void)
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
@@ -1626,7 +1622,7 @@ static void imc_common_mem_free(struct imc_pmu *pmu_ptr)
 static void imc_common_cpuhp_mem_free(struct imc_pmu *pmu_ptr)
 {
 	if (pmu_ptr->domain == IMC_DOMAIN_NEST) {
-		mutex_lock(&nest_init_lock);
+		spin_lock(&nest_init_lock);
 		if (nest_pmus == 1) {
 			cpuhp_remove_state(CPUHP_AP_PERF_POWERPC_NEST_IMC_ONLINE);
 			kfree(nest_imc_refc);
@@ -1636,7 +1632,7 @@ static void imc_common_cpuhp_mem_free(struct imc_pmu *pmu_ptr)
 
 		if (nest_pmus > 0)
 			nest_pmus--;
-		mutex_unlock(&nest_init_lock);
+		spin_unlock(&nest_init_lock);
 	}
 
 	/* Free core_imc memory */
@@ -1793,11 +1789,11 @@ int init_imc_pmu(struct device_node *parent, struct imc_pmu *pmu_ptr, int pmu_id
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
@@ -1805,7 +1801,7 @@ int init_imc_pmu(struct device_node *parent, struct imc_pmu *pmu_ptr, int pmu_id
 			/* Register for cpu hotplug notification. */
 			ret = nest_pmu_cpumask_init();
 			if (ret) {
-				mutex_unlock(&nest_init_lock);
+				spin_unlock(&nest_init_lock);
 				kfree(nest_imc_refc);
 				kfree(per_nest_pmu_arr);
 				per_nest_pmu_arr = NULL;
@@ -1813,7 +1809,7 @@ int init_imc_pmu(struct device_node *parent, struct imc_pmu *pmu_ptr, int pmu_id
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
index cb5fc0690435..081837b391e3 100644
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
index 3459362c54ac..c7fd81851289 100644
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
index db62def4ef28..4e6fadaeaa1a 100644
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
index b57b3db9a6a7..4f5d79e658cd 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -580,8 +580,10 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
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
@@ -2363,6 +2365,14 @@ static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
 			WRITE_ONCE(t->closid, to->closid);
 			WRITE_ONCE(t->rmid, to->mon.rmid);
 
+			/*
+			 * Order the closid/rmid stores above before the loads
+			 * in task_curr(). This pairs with the full barrier
+			 * between the rq->curr update and resctrl_sched_in()
+			 * during context switch.
+			 */
+			smp_mb();
+
 			/*
 			 * If the task is on a CPU, set the CPU in the mask.
 			 * The detection is inaccurate as tasks might move or
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 05b27b4a54c9..528437e3e2f3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -567,16 +567,22 @@ struct kvm_cpuid_array {
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
@@ -755,22 +761,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
@@ -962,6 +959,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->ebx = entry->ecx = entry->edx = 0;
 		break;
 	case 0x8000001e:
+		/* Do not return host topology information.  */
+		entry->eax = entry->ebx = entry->ecx = 0;
+		entry->edx = 0; /* reserved */
 		break;
 	case 0x8000001F:
 		if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {
diff --git a/block/blk-merge.c b/block/blk-merge.c
index bb26db93ad1d..d1435b657297 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -348,11 +348,13 @@ void __blk_queue_split(struct bio **bio, unsigned int *nr_segs)
 			break;
 		}
 		split = blk_bio_segment_split(q, *bio, &q->bio_split, nr_segs);
+		if (IS_ERR(split))
+			*bio = split = NULL;
 		break;
 	}
 
 	if (split) {
-		/* there isn't chance to merge the splitted bio */
+		/* there isn't chance to merge the split bio */
 		split->bi_opf |= REQ_NOMERGE;
 
 		bio_chain(split, *bio);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1a28ba9017ed..9f53b4caf977 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2193,6 +2193,8 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio)
 
 	blk_queue_bounce(q, &bio);
 	__blk_queue_split(&bio, &nr_segs);
+	if (!bio)
+		goto queue_exit;
 
 	if (!bio_integrity_prep(bio))
 		goto queue_exit;
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 47e0d105b462..4281dc847bc2 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1602,6 +1602,8 @@ blk_qc_t drbd_submit_bio(struct bio *bio)
 	struct drbd_device *device = bio->bi_bdev->bd_disk->private_data;
 
 	blk_queue_split(&bio);
+	if (!bio)
+		return BLK_QC_T_NONE;
 
 	/*
 	 * what we "blindly" assume:
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 0f26b2510a75..ca2ab977ef8e 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2407,6 +2407,8 @@ static blk_qc_t pkt_submit_bio(struct bio *bio)
 	struct bio *split;
 
 	blk_queue_split(&bio);
+	if (!bio)
+		return BLK_QC_T_NONE;
 
 	pd = bio->bi_bdev->bd_disk->queue->queuedata;
 	if (!pd) {
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index c7b19e128b03..c79aa4d8ccf7 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -587,6 +587,8 @@ static blk_qc_t ps3vram_submit_bio(struct bio *bio)
 	dev_dbg(&dev->core, "%s\n", __func__);
 
 	blk_queue_split(&bio);
+	if (!bio)
+		return BLK_QC_T_NONE;
 
 	spin_lock_irq(&priv->lock);
 	busy = !bio_list_empty(&priv->list);
diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index 1cc40b0ea761..6b253d99bc48 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -127,6 +127,8 @@ static blk_qc_t rsxx_submit_bio(struct bio *bio)
 	blk_status_t st = BLK_STS_IOERR;
 
 	blk_queue_split(&bio);
+	if (!bio)
+		return BLK_QC_T_NONE;
 
 	might_sleep();
 
diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index 1020268a075a..1a87b9c6c2f8 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -297,7 +297,8 @@ int mhi_pm_m0_transition(struct mhi_controller *mhi_cntrl)
 		read_lock_irq(&mhi_chan->lock);
 
 		/* Only ring DB if ring is not empty */
-		if (tre_ring->base && tre_ring->wp  != tre_ring->rp)
+		if (tre_ring->base && tre_ring->wp  != tre_ring->rp &&
+		    mhi_chan->ch_state == MHI_CH_STATE_ENABLED)
 			mhi_ring_chan_db(mhi_cntrl, mhi_chan);
 		read_unlock_irq(&mhi_chan->lock);
 	}
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
 
diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c b/drivers/gpu/drm/i915/gt/intel_reset.c
index 18b0e57c58c1..9dc244b70ce4 100644
--- a/drivers/gpu/drm/i915/gt/intel_reset.c
+++ b/drivers/gpu/drm/i915/gt/intel_reset.c
@@ -271,6 +271,7 @@ static int ilk_do_reset(struct intel_gt *gt, intel_engine_mask_t engine_mask,
 static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
 {
 	struct intel_uncore *uncore = gt->uncore;
+	int loops = 2;
 	int err;
 
 	/*
@@ -278,18 +279,39 @@ static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
 	 * for fifo space for the write or forcewake the chip for
 	 * the read
 	 */
-	intel_uncore_write_fw(uncore, GEN6_GDRST, hw_domain_mask);
+	do {
+		intel_uncore_write_fw(uncore, GEN6_GDRST, hw_domain_mask);
 
-	/* Wait for the device to ack the reset requests */
-	err = __intel_wait_for_register_fw(uncore,
-					   GEN6_GDRST, hw_domain_mask, 0,
-					   500, 0,
-					   NULL);
+		/*
+		 * Wait for the device to ack the reset requests.
+		 *
+		 * On some platforms, e.g. Jasperlake, we see that the
+		 * engine register state is not cleared until shortly after
+		 * GDRST reports completion, causing a failure as we try
+		 * to immediately resume while the internal state is still
+		 * in flux. If we immediately repeat the reset, the second
+		 * reset appears to serialise with the first, and since
+		 * it is a no-op, the registers should retain their reset
+		 * value. However, there is still a concern that upon
+		 * leaving the second reset, the internal engine state
+		 * is still in flux and not ready for resuming.
+		 */
+		err = __intel_wait_for_register_fw(uncore, GEN6_GDRST,
+						   hw_domain_mask, 0,
+						   2000, 0,
+						   NULL);
+	} while (err == 0 && --loops);
 	if (err)
 		GT_TRACE(gt,
 			 "Wait for 0x%08x engines reset failed\n",
 			 hw_domain_mask);
 
+	/*
+	 * As we have observed that the engine state is still volatile
+	 * after GDRST is acked, impose a small delay to let everything settle.
+	 */
+	udelay(50);
+
 	return err;
 }
 
diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.h b/drivers/gpu/drm/msm/adreno/adreno_gpu.h
index 225c277a6223..588722e824f6 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.h
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.h
@@ -29,11 +29,9 @@ enum {
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
@@ -65,7 +63,7 @@ struct adreno_info {
 	const char *name;
 	const char *fw[ADRENO_FW_MAX];
 	uint32_t gmem;
-	enum adreno_quirks quirks;
+	u64 quirks;
 	struct msm_gpu *(*init)(struct drm_device *dev);
 	const char *zapfw;
 	u32 inactive_period;
diff --git a/drivers/gpu/drm/msm/dp/dp_aux.c b/drivers/gpu/drm/msm/dp/dp_aux.c
index 6d36f63c3338..7b8d4ba868eb 100644
--- a/drivers/gpu/drm/msm/dp/dp_aux.c
+++ b/drivers/gpu/drm/msm/dp/dp_aux.c
@@ -406,6 +406,10 @@ void dp_aux_isr(struct drm_dp_aux *dp_aux)
 
 	isr = dp_catalog_aux_get_irq(aux->catalog);
 
+	/* no interrupts pending, return immediately */
+	if (!isr)
+		return;
+
 	if (!aux->cmd_busy)
 		return;
 
diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 15c3e63db396..3c750ba6ba1f 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -292,10 +292,18 @@ static int virtio_gpu_resource_create_ioctl(struct drm_device *dev, void *data,
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
 
@@ -656,11 +664,18 @@ static int virtio_gpu_resource_create_blob_ioctl(struct drm_device *dev,
 		drm_gem_object_release(obj);
 		return ret;
 	}
-	drm_gem_object_put(obj);
 
 	rc_blob->res_handle = bo->hw_res_handle;
 	rc_blob->bo_handle = handle;
 
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
 
diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index cae5a73ff518..0835f32e040a 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -252,7 +252,7 @@ static int __alloc_and_insert_iova_range(struct iova_domain *iovad,
 
 	curr = __get_cached_rbnode(iovad, limit_pfn);
 	curr_iova = to_iova(curr);
-	retry_pfn = curr_iova->pfn_hi + 1;
+	retry_pfn = curr_iova->pfn_hi;
 
 retry:
 	do {
@@ -266,7 +266,7 @@ static int __alloc_and_insert_iova_range(struct iova_domain *iovad,
 	if (high_pfn < size || new_pfn < low_pfn) {
 		if (low_pfn == iovad->start_pfn && retry_pfn < limit_pfn) {
 			high_pfn = limit_pfn;
-			low_pfn = retry_pfn;
+			low_pfn = retry_pfn + 1;
 			curr = iova_find_limit(iovad, limit_pfn);
 			curr_iova = to_iova(curr);
 			goto retry;
diff --git a/drivers/iommu/mtk_iommu_v1.c b/drivers/iommu/mtk_iommu_v1.c
index 254530ad6c48..fe1c3123a7e7 100644
--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -655,7 +655,7 @@ static int mtk_iommu_probe(struct platform_device *pdev)
 	ret = iommu_device_sysfs_add(&data->iommu, &pdev->dev, NULL,
 				     dev_name(&pdev->dev));
 	if (ret)
-		return ret;
+		goto out_clk_unprepare;
 
 	ret = iommu_device_register(&data->iommu, &mtk_iommu_ops, dev);
 	if (ret)
@@ -678,6 +678,8 @@ static int mtk_iommu_probe(struct platform_device *pdev)
 	iommu_device_unregister(&data->iommu);
 out_sysfs_remove:
 	iommu_device_sysfs_remove(&data->iommu);
+out_clk_unprepare:
+	clk_disable_unprepare(data->bclk);
 	return ret;
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 59ab99844df8..9e54b865f30d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -458,6 +458,8 @@ static blk_qc_t md_submit_bio(struct bio *bio)
 	}
 
 	blk_queue_split(&bio);
+	if (!bio)
+		return BLK_QC_T_NONE;
 
 	if (mddev->ro == 1 && unlikely(rw == WRITE)) {
 		if (bio_sectors(bio) != 0)
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index f171bc99e58c..60d0ca69ceca 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -469,7 +469,9 @@
 #define IGC_TSAUXC_EN_TT0	BIT(0)  /* Enable target time 0. */
 #define IGC_TSAUXC_EN_TT1	BIT(1)  /* Enable target time 1. */
 #define IGC_TSAUXC_EN_CLK0	BIT(2)  /* Enable Configurable Frequency Clock 0. */
+#define IGC_TSAUXC_ST0		BIT(4)  /* Start Clock 0 Toggle on Target Time 0. */
 #define IGC_TSAUXC_EN_CLK1	BIT(5)  /* Enable Configurable Frequency Clock 1. */
+#define IGC_TSAUXC_ST1		BIT(7)  /* Start Clock 1 Toggle on Target Time 1. */
 #define IGC_TSAUXC_EN_TS0	BIT(8)  /* Enable hardware timestamp 0. */
 #define IGC_TSAUXC_AUTT0	BIT(9)  /* Auxiliary Timestamp Taken. */
 #define IGC_TSAUXC_EN_TS1	BIT(10) /* Enable hardware timestamp 0. */
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 8e521f99b80a..fbde7826927b 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -323,7 +323,7 @@ static int igc_ptp_feature_enable_i225(struct ptp_clock_info *ptp,
 		ts = ns_to_timespec64(ns);
 		if (rq->perout.index == 1) {
 			if (use_freq) {
-				tsauxc_mask = IGC_TSAUXC_EN_CLK1;
+				tsauxc_mask = IGC_TSAUXC_EN_CLK1 | IGC_TSAUXC_ST1;
 				tsim_mask = 0;
 			} else {
 				tsauxc_mask = IGC_TSAUXC_EN_TT1;
@@ -334,7 +334,7 @@ static int igc_ptp_feature_enable_i225(struct ptp_clock_info *ptp,
 			freqout = IGC_FREQOUT1;
 		} else {
 			if (use_freq) {
-				tsauxc_mask = IGC_TSAUXC_EN_CLK0;
+				tsauxc_mask = IGC_TSAUXC_EN_CLK0 | IGC_TSAUXC_ST0;
 				tsim_mask = 0;
 			} else {
 				tsauxc_mask = IGC_TSAUXC_EN_TT0;
@@ -348,10 +348,12 @@ static int igc_ptp_feature_enable_i225(struct ptp_clock_info *ptp,
 		tsauxc = rd32(IGC_TSAUXC);
 		tsim = rd32(IGC_TSIM);
 		if (rq->perout.index == 1) {
-			tsauxc &= ~(IGC_TSAUXC_EN_TT1 | IGC_TSAUXC_EN_CLK1);
+			tsauxc &= ~(IGC_TSAUXC_EN_TT1 | IGC_TSAUXC_EN_CLK1 |
+				    IGC_TSAUXC_ST1);
 			tsim &= ~IGC_TSICR_TT1;
 		} else {
-			tsauxc &= ~(IGC_TSAUXC_EN_TT0 | IGC_TSAUXC_EN_CLK0);
+			tsauxc &= ~(IGC_TSAUXC_EN_TT0 | IGC_TSAUXC_EN_CLK0 |
+				    IGC_TSAUXC_ST0);
 			tsim &= ~IGC_TSICR_TT0;
 		}
 		if (on) {
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
index 24aa97f993ca..123dca9ce468 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
@@ -855,9 +855,11 @@ static struct pci_dev *ixgbe_get_first_secondary_devfn(unsigned int devfn)
 	rp_pdev = pci_get_domain_bus_and_slot(0, 0, devfn);
 	if (rp_pdev && rp_pdev->subordinate) {
 		bus = rp_pdev->subordinate->number;
+		pci_dev_put(rp_pdev);
 		return pci_get_domain_bus_and_slot(0, bus, 0);
 	}
 
+	pci_dev_put(rp_pdev);
 	return NULL;
 }
 
@@ -874,6 +876,7 @@ static bool ixgbe_x550em_a_has_mii(struct ixgbe_hw *hw)
 	struct ixgbe_adapter *adapter = hw->back;
 	struct pci_dev *pdev = adapter->pdev;
 	struct pci_dev *func0_pdev;
+	bool has_mii = false;
 
 	/* For the C3000 family of SoCs (x550em_a) the internal ixgbe devices
 	 * are always downstream of root ports @ 0000:00:16.0 & 0000:00:17.0
@@ -884,15 +887,16 @@ static bool ixgbe_x550em_a_has_mii(struct ixgbe_hw *hw)
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
index 6b335139abe7..fd0a31bf94fe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -695,9 +695,9 @@ int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable)
 
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
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index ab1e4abdea38..5714280a4252 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -30,7 +30,6 @@
 #define CMR_P2X_SEL_SHIFT		59ULL
 #define CMR_P2X_SEL_NIX0		1ULL
 #define CMR_P2X_SEL_NIX1		2ULL
-#define CMR_EN				BIT_ULL(55)
 #define DATA_PKT_TX_EN			BIT_ULL(53)
 #define DATA_PKT_RX_EN			BIT_ULL(54)
 #define CGX_LMAC_TYPE_SHIFT		40
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index 4267f3a1059e..78b1a6ddd967 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -88,6 +88,8 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
 	struct udphdr *udp = (struct udphdr *)(buf);
 	struct vxlanhdr *vxh;
 
+	if (tun_key->tun_flags & TUNNEL_VXLAN_OPT)
+		return -EOPNOTSUPP;
 	vxh = (struct vxlanhdr *)((char *)udp + sizeof(struct udphdr));
 	*ip_proto = IPPROTO_UDP;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 8f2f99689aba..9ea4281a55b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3597,7 +3597,8 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 			if (err)
 				return err;
 
-			action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			attr->dest_chain = act->chain_index;
 			break;
 		case FLOW_ACTION_CT:
@@ -3632,12 +3633,9 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 
 	attr->action = action;
 
-	if (attr->dest_chain) {
-		if (attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
-			NL_SET_ERR_MSG(extack, "Mirroring goto chain rules isn't supported");
-			return -EOPNOTSUPP;
-		}
-		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	if (attr->dest_chain && parse_attr->mirred_ifindex[0]) {
+		NL_SET_ERR_MSG(extack, "Mirroring goto chain rules isn't supported");
+		return -EOPNOTSUPP;
 	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
@@ -4146,7 +4144,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			if (err)
 				return err;
 
-			action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			attr->dest_chain = act->chain_index;
 			break;
 		case FLOW_ACTION_CT:
@@ -4218,24 +4217,18 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
 		return -EOPNOTSUPP;
 
-	if (attr->dest_chain) {
-		if (decap) {
-			/* It can be supported if we'll create a mapping for
-			 * the tunnel device only (without tunnel), and set
-			 * this tunnel id with this decap flow.
-			 *
-			 * On restore (miss), we'll just set this saved tunnel
-			 * device.
-			 */
-
-			NL_SET_ERR_MSG(extack,
-				       "Decap with goto isn't supported");
-			netdev_warn(priv->netdev,
-				    "Decap with goto isn't supported");
-			return -EOPNOTSUPP;
-		}
+	if (attr->dest_chain && decap) {
+		/* It can be supported if we'll create a mapping for
+		 * the tunnel device only (without tunnel), and set
+		 * this tunnel id with this decap flow.
+		 *
+		 * On restore (miss), we'll just set this saved tunnel
+		 * device.
+		 */
 
-		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+		NL_SET_ERR_MSG(extack, "Decap with goto isn't supported");
+		netdev_warn(priv->netdev, "Decap with goto isn't supported");
+		return -EOPNOTSUPP;
 	}
 
 	if (esw_attr->split_count > 0 && !mlx5_esw_has_fwd_fdb(priv->mdev)) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 91e806c1aa21..8490c0cf80a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -599,7 +599,7 @@ static int mlx5_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 static const struct ptp_clock_info mlx5_ptp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "mlx5_ptp",
-	.max_adj	= 100000000,
+	.max_adj	= 50000000,
 	.n_alarm	= 0,
 	.n_ext_ts	= 0,
 	.n_per_out	= 0,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index ac8bc1c8614d..487418ef9b4f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -229,7 +229,10 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
 		}
 		writel(acr_value, ptpaddr + PTP_ACR);
 		mutex_unlock(&priv->aux_ts_lock);
-		ret = 0;
+		/* wait for auxts fifo clear to finish */
+		ret = readl_poll_timeout(ptpaddr + PTP_ACR, acr_value,
+					 !(acr_value & PTP_ACR_ATSFC),
+					 10, 10000);
 		break;
 
 	default:
diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index bd7f7478d189..62ad26e4299d 100644
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
@@ -408,7 +422,31 @@ static int pn533_acr122_poweron_rdr(struct pn533_usb_phy *phy)
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
 
@@ -496,10 +534,10 @@ static int pn533_usb_probe(struct usb_interface *interface,
 
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
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index fe199d568a4a..8d97b942de01 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -329,6 +329,8 @@ static blk_qc_t nvme_ns_head_submit_bio(struct bio *bio)
 	 * pool from the original queue to allocate the bvecs from.
 	 */
 	blk_queue_split(&bio);
+	if (!bio)
+		return BLK_QC_T_NONE;
 
 	srcu_idx = srcu_read_lock(&head->srcu);
 	ns = nvme_find_path(head);
diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 5c4acf2308d4..52d1fe5ec3e7 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -627,13 +627,15 @@ static bool do_amd_gpio_irq_handler(int irq, void *dev_id)
 		/* Each status bit covers four pins */
 		for (i = 0; i < 4; i++) {
 			regval = readl(regs + i);
-			/* caused wake on resume context for shared IRQ */
-			if (irq < 0 && (regval & BIT(WAKE_STS_OFF))) {
+
+			if (regval & PIN_IRQ_PENDING)
 				dev_dbg(&gpio_dev->pdev->dev,
-					"Waking due to GPIO %d: 0x%x",
+					"GPIO %d is active: 0x%x",
 					irqnr + i, regval);
+
+			/* caused wake on resume context for shared IRQ */
+			if (irq < 0 && (regval & BIT(WAKE_STS_OFF)))
 				return true;
-			}
 
 			if (!(regval & PIN_IRQ_PENDING) ||
 			    !(regval & BIT(INTERRUPT_MASK_OFF)))
diff --git a/drivers/platform/surface/aggregator/controller.c b/drivers/platform/surface/aggregator/controller.c
index b8c377b3f932..f23f7128cf2b 100644
--- a/drivers/platform/surface/aggregator/controller.c
+++ b/drivers/platform/surface/aggregator/controller.c
@@ -1700,8 +1700,10 @@ int ssam_request_sync(struct ssam_controller *ctrl,
 		return status;
 
 	status = ssam_request_sync_init(rqst, spec->flags);
-	if (status)
+	if (status) {
+		ssam_request_sync_free(rqst);
 		return status;
+	}
 
 	ssam_request_sync_set_resp(rqst, rsp);
 
diff --git a/drivers/platform/surface/aggregator/ssh_request_layer.c b/drivers/platform/surface/aggregator/ssh_request_layer.c
index 790f7f0eee98..7c0b637c91fc 100644
--- a/drivers/platform/surface/aggregator/ssh_request_layer.c
+++ b/drivers/platform/surface/aggregator/ssh_request_layer.c
@@ -916,6 +916,20 @@ static void ssh_rtl_rx_command(struct ssh_ptl *p, const struct ssam_span *data)
 	if (sshp_parse_command(dev, data, &command, &command_data))
 		return;
 
+	/*
+	 * Check if the message was intended for us. If not, drop it.
+	 *
+	 * Note: We will need to change this to handle debug messages. On newer
+	 * generation devices, these seem to be sent to tid_out=0x03. We as
+	 * host can still receive them as they can be forwarded via an override
+	 * option on SAM, but doing so does not change tid_out=0x00.
+	 */
+	if (command->tid_out != 0x00) {
+		rtl_warn(rtl, "rtl: dropping message not intended for us (tid = %#04x)\n",
+			 command->tid_out);
+		return;
+	}
+
 	if (ssh_rqid_is_event(get_unaligned_le16(&command->rqid)))
 		ssh_rtl_rx_event(rtl, command, &command_data);
 	else
diff --git a/drivers/platform/x86/dell/dell-wmi-privacy.c b/drivers/platform/x86/dell/dell-wmi-privacy.c
index 074b7e68c227..7b79e987ca08 100644
--- a/drivers/platform/x86/dell/dell-wmi-privacy.c
+++ b/drivers/platform/x86/dell/dell-wmi-privacy.c
@@ -61,7 +61,7 @@ static const struct key_entry dell_wmi_keymap_type_0012[] = {
 	/* privacy mic mute */
 	{ KE_KEY, 0x0001, { KEY_MICMUTE } },
 	/* privacy camera mute */
-	{ KE_SW,  0x0002, { SW_CAMERA_LENS_COVER } },
+	{ KE_VSW, 0x0002, { SW_CAMERA_LENS_COVER } },
 	{ KE_END, 0},
 };
 
@@ -115,11 +115,15 @@ bool dell_privacy_process_event(int type, int code, int status)
 
 	switch (code) {
 	case DELL_PRIVACY_AUDIO_EVENT: /* Mic mute */
-	case DELL_PRIVACY_CAMERA_EVENT: /* Camera mute */
 		priv->last_status = status;
 		sparse_keymap_report_entry(priv->input_dev, key, 1, true);
 		ret = true;
 		break;
+	case DELL_PRIVACY_CAMERA_EVENT: /* Camera mute */
+		priv->last_status = status;
+		sparse_keymap_report_entry(priv->input_dev, key, !(status & CAMERA_STATUS), false);
+		ret = true;
+		break;
 	default:
 		dev_dbg(&priv->wdev->dev, "unknown event type 0x%04x 0x%04x\n", type, code);
 	}
@@ -295,7 +299,7 @@ static int dell_privacy_wmi_probe(struct wmi_device *wdev, const void *context)
 {
 	struct privacy_wmi_data *priv;
 	struct key_entry *keymap;
-	int ret, i;
+	int ret, i, j;
 
 	ret = wmi_has_guid(DELL_PRIVACY_GUID);
 	if (!ret)
@@ -307,6 +311,11 @@ static int dell_privacy_wmi_probe(struct wmi_device *wdev, const void *context)
 
 	dev_set_drvdata(&wdev->dev, priv);
 	priv->wdev = wdev;
+
+	ret = get_current_status(priv->wdev);
+	if (ret)
+		return ret;
+
 	/* create evdev passing interface */
 	priv->input_dev = devm_input_allocate_device(&wdev->dev);
 	if (!priv->input_dev)
@@ -321,9 +330,20 @@ static int dell_privacy_wmi_probe(struct wmi_device *wdev, const void *context)
 	/* remap the keymap code with Dell privacy key type 0x12 as prefix
 	 * KEY_MICMUTE scancode will be reported as 0x120001
 	 */
-	for (i = 0; i < ARRAY_SIZE(dell_wmi_keymap_type_0012); i++) {
-		keymap[i] = dell_wmi_keymap_type_0012[i];
-		keymap[i].code |= (0x0012 << 16);
+	for (i = 0, j = 0; i < ARRAY_SIZE(dell_wmi_keymap_type_0012); i++) {
+		/*
+		 * Unlike keys where only presses matter, userspace may act
+		 * on switches in both of their positions. Only register
+		 * SW_CAMERA_LENS_COVER if it is actually there.
+		 */
+		if (dell_wmi_keymap_type_0012[i].type == KE_VSW &&
+		    dell_wmi_keymap_type_0012[i].sw.code == SW_CAMERA_LENS_COVER &&
+		    !(priv->features_present & BIT(DELL_PRIVACY_TYPE_CAMERA)))
+			continue;
+
+		keymap[j] = dell_wmi_keymap_type_0012[i];
+		keymap[j].code |= (0x0012 << 16);
+		j++;
 	}
 	ret = sparse_keymap_setup(priv->input_dev, keymap, NULL);
 	kfree(keymap);
@@ -334,11 +354,12 @@ static int dell_privacy_wmi_probe(struct wmi_device *wdev, const void *context)
 	priv->input_dev->name = "Dell Privacy Driver";
 	priv->input_dev->id.bustype = BUS_HOST;
 
-	ret = input_register_device(priv->input_dev);
-	if (ret)
-		return ret;
+	/* Report initial camera-cover status */
+	if (priv->features_present & BIT(DELL_PRIVACY_TYPE_CAMERA))
+		input_report_switch(priv->input_dev, SW_CAMERA_LENS_COVER,
+				    !(priv->last_status & CAMERA_STATUS));
 
-	ret = get_current_status(priv->wdev);
+	ret = input_register_device(priv->input_dev);
 	if (ret)
 		return ret;
 
diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 7c553581e870..e75b09a144a3 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1493,6 +1493,12 @@ static const struct dmi_system_id set_fn_lock_led_list[] = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo Legion R7000P2020H"),
 		}
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo Legion 5 15ARH05"),
+		}
+	},
 	{}
 };
 
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 704813374922..336dee9485d4 100644
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
 
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 5be3d1c39a78..54176c073547 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -866,6 +866,8 @@ dcssblk_submit_bio(struct bio *bio)
 	unsigned long bytes_done;
 
 	blk_queue_split(&bio);
+	if (!bio)
+		return BLK_QC_T_NONE;
 
 	bytes_done = 0;
 	dev_info = bio->bi_bdev->bd_disk->private_data;
diff --git a/drivers/scsi/mpi3mr/Makefile b/drivers/scsi/mpi3mr/Makefile
index 7c2063e04c81..7ebca0ba538d 100644
--- a/drivers/scsi/mpi3mr/Makefile
+++ b/drivers/scsi/mpi3mr/Makefile
@@ -1,4 +1,4 @@
 # mpi3mr makefile
-obj-m += mpi3mr.o
+obj-$(CONFIG_SCSI_MPI3MR) += mpi3mr.o
 mpi3mr-y +=  mpi3mr_os.o     \
 		mpi3mr_fw.o \
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index be024b2b6bd4..766c3a59a900 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2594,12 +2594,8 @@ _base_check_pcie_native_sgl(struct MPT3SAS_ADAPTER *ioc,
 
 	/* Get the SG list pointer and info. */
 	sges_left = scsi_dma_map(scmd);
-	if (sges_left < 0) {
-		sdev_printk(KERN_ERR, scmd->device,
-			"scsi_dma_map failed: request for %d bytes!\n",
-			scsi_bufflen(scmd));
+	if (sges_left < 0)
 		return 1;
-	}
 
 	/* Check if we need to build a native SG list. */
 	if (!base_is_prp_possible(ioc, pcie_device,
@@ -2706,12 +2702,8 @@ _base_build_sg_scmd(struct MPT3SAS_ADAPTER *ioc,
 
 	sg_scmd = scsi_sglist(scmd);
 	sges_left = scsi_dma_map(scmd);
-	if (sges_left < 0) {
-		sdev_printk(KERN_ERR, scmd->device,
-		 "scsi_dma_map failed: request for %d bytes!\n",
-		 scsi_bufflen(scmd));
+	if (sges_left < 0)
 		return -ENOMEM;
-	}
 
 	sg_local = &mpi_request->SGL;
 	sges_in_segment = ioc->max_sges_in_main_message;
@@ -2854,12 +2846,8 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
 
 	sg_scmd = scsi_sglist(scmd);
 	sges_left = scsi_dma_map(scmd);
-	if (sges_left < 0) {
-		sdev_printk(KERN_ERR, scmd->device,
-			"scsi_dma_map failed: request for %d bytes!\n",
-			scsi_bufflen(scmd));
+	if (sges_left < 0)
 		return -ENOMEM;
-	}
 
 	sg_local = &mpi_request->SGL;
 	sges_in_segment = (ioc->request_sz -
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a428b8145dcc..0b06223f5714 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2700,6 +2700,12 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	if (!down_read_trylock(&hba->clk_scaling_lock))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
+	/*
+	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
+	 * calls.
+	 */
+	rcu_read_lock();
+
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
 	case UFSHCD_STATE_EH_SCHEDULED_NON_FATAL:
@@ -2766,7 +2772,10 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	}
 
 	ufshcd_send_command(hba, tag);
+
 out:
+	rcu_read_unlock();
+
 	up_read(&hba->clk_scaling_lock);
 
 	if (ufs_trigger_eh()) {
@@ -5900,6 +5909,14 @@ static inline void ufshcd_schedule_eh_work(struct ufs_hba *hba)
 	}
 }
 
+static void ufshcd_force_error_recovery(struct ufs_hba *hba)
+{
+	spin_lock_irq(hba->host->host_lock);
+	hba->force_reset = true;
+	ufshcd_schedule_eh_work(hba);
+	spin_unlock_irq(hba->host->host_lock);
+}
+
 static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
 {
 	down_write(&hba->clk_scaling_lock);
@@ -5952,8 +5969,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 	}
 	ufshcd_scsi_block_requests(hba);
 	/* Drain ufshcd_queuecommand() */
-	down_write(&hba->clk_scaling_lock);
-	up_write(&hba->clk_scaling_lock);
+	synchronize_rcu();
 	cancel_work_sync(&hba->eeh_work);
 }
 
@@ -8767,6 +8783,15 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 		if (!hba->dev_info.b_rpm_dev_flush_capable) {
 			ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
+			if (ret && pm_op != UFS_SHUTDOWN_PM) {
+				/*
+				 * If return err in suspend flow, IO will hang.
+				 * Trigger error handler and break suspend for
+				 * error recovery.
+				 */
+				ufshcd_force_error_recovery(hba);
+				ret = -EBUSY;
+			}
 			if (ret)
 				goto enable_scaling;
 		}
@@ -8778,6 +8803,15 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	 */
 	check_for_bkops = !ufshcd_is_ufs_dev_deepsleep(hba);
 	ret = ufshcd_link_state_transition(hba, req_link_state, check_for_bkops);
+	if (ret && pm_op != UFS_SHUTDOWN_PM) {
+		/*
+		 * If return err in suspend flow, IO will hang.
+		 * Trigger error handler and break suspend for
+		 * error recovery.
+		 */
+		ufshcd_force_error_recovery(hba);
+		ret = -EBUSY;
+	}
 	if (ret)
 		goto set_dev_active;
 
diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 8ee7ce120692..609a51137e96 100644
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
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index bbdf3281559c..4308b27ba346 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -459,6 +459,7 @@ smb3_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	oparms.disposition = FILE_CREATE;
 	oparms.fid = &fid;
 	oparms.reconnect = false;
+	oparms.mode = 0644;
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       NULL, NULL);
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
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c587221a289c..9a01188ff45a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2477,12 +2477,26 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 	io_init_req_batch(&rb);
 	while (!list_empty(done)) {
+		struct io_uring_cqe *cqe;
+		unsigned cflags;
+
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
-
-		io_fill_cqe_req(req, req->result, io_put_rw_kbuf(req));
+		cflags = io_put_rw_kbuf(req);
 		(*nr_events)++;
 
+		cqe = io_get_cqe(ctx);
+		if (cqe) {
+			WRITE_ONCE(cqe->user_data, req->user_data);
+			WRITE_ONCE(cqe->res, req->result);
+			WRITE_ONCE(cqe->flags, cflags);
+		} else {
+			spin_lock(&ctx->completion_lock);
+			io_cqring_event_overflow(ctx, req->user_data,
+							req->result, cflags);
+			spin_unlock(&ctx->completion_lock);
+		}
+
 		if (req_ref_put_and_test(req))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bb684fe1b96e..2bd5e235d078 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2501,14 +2501,43 @@ void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src,
 		      int node)
 {
-	if (!src->user_cpus_ptr)
+	cpumask_t *user_mask;
+	unsigned long flags;
+
+	/*
+	 * Always clear dst->user_cpus_ptr first as their user_cpus_ptr's
+	 * may differ by now due to racing.
+	 */
+	dst->user_cpus_ptr = NULL;
+
+	/*
+	 * This check is racy and losing the race is a valid situation.
+	 * It is not worth the extra overhead of taking the pi_lock on
+	 * every fork/clone.
+	 */
+	if (data_race(!src->user_cpus_ptr))
 		return 0;
 
-	dst->user_cpus_ptr = kmalloc_node(cpumask_size(), GFP_KERNEL, node);
-	if (!dst->user_cpus_ptr)
+	user_mask = kmalloc_node(cpumask_size(), GFP_KERNEL, node);
+	if (!user_mask)
 		return -ENOMEM;
 
-	cpumask_copy(dst->user_cpus_ptr, src->user_cpus_ptr);
+	/*
+	 * Use pi_lock to protect content of user_cpus_ptr
+	 *
+	 * Though unlikely, user_cpus_ptr can be reset to NULL by a concurrent
+	 * do_set_cpus_allowed().
+	 */
+	raw_spin_lock_irqsave(&src->pi_lock, flags);
+	if (src->user_cpus_ptr) {
+		swap(dst->user_cpus_ptr, user_mask);
+		cpumask_copy(dst->user_cpus_ptr, src->user_cpus_ptr);
+	}
+	raw_spin_unlock_irqrestore(&src->pi_lock, flags);
+
+	if (unlikely(user_mask))
+		kfree(user_mask);
+
 	return 0;
 }
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 2b7397781c99..838d59a74c65 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1615,7 +1615,13 @@ void __init __memblock_free_late(phys_addr_t base, phys_addr_t size)
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
index c51d5ce3711c..c68020b8de89 100644
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
index da652c21368e..208a6f59281d 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -63,7 +63,7 @@ nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
 			return false;
 
 		if (offset + len > VLAN_ETH_HLEN + vlan_hlen)
-			ethlen -= offset + len - VLAN_ETH_HLEN + vlan_hlen;
+			ethlen -= offset + len - VLAN_ETH_HLEN - vlan_hlen;
 
 		memcpy(dst_u8, vlanh + offset - vlan_hlen, ethlen);
 
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index e4529b428cf4..db0ef0486309 100644
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
index 49ddc484c4fe..5e000fde8067 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1179,8 +1179,9 @@ void tipc_node_check_dest(struct net *net, u32 addr,
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
@@ -1200,14 +1201,14 @@ void tipc_node_check_dest(struct net *net, u32 addr,
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
@@ -1232,6 +1233,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		 */
 		accept_addr = true;
 		*respond = true;
+		reset = true;
 	} else if (!sign_match && addr_match && link_up) {
 		/* Peer node rebooted. Two possibilities:
 		 *  - Delayed re-discovery; this link endpoint has already
@@ -1263,6 +1265,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		n->signature = signature;
 		accept_addr = true;
 		*respond = true;
+		reset = true;
 	}
 
 	if (!accept_addr)
@@ -1291,6 +1294,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		tipc_link_fsm_evt(l, LINK_RESET_EVT);
 		if (n->state == NODE_FAILINGOVER)
 			tipc_link_fsm_evt(l, LINK_FAILOVER_BEGIN_EVT);
+		link_is_reset = tipc_link_is_reset(l);
 		le->link = l;
 		n->link_cnt++;
 		tipc_node_calculate_timer(n, l);
@@ -1303,7 +1307,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 	memcpy(&le->maddr, maddr, sizeof(*maddr));
 exit:
 	tipc_node_write_unlock(n);
-	if (reset && l && !tipc_link_is_reset(l))
+	if (reset && !link_is_reset)
 		tipc_node_link_down(n, b->identity, false);
 	tipc_node_put(n);
 }
diff --git a/sound/core/control_led.c b/sound/core/control_led.c
index a95332b2b90b..3eb1c5af82ad 100644
--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -530,12 +530,11 @@ static ssize_t set_led_id(struct snd_ctl_led_card *led_card, const char *buf, si
 			  bool attach)
 {
 	char buf2[256], *s, *os;
-	size_t len = max(sizeof(s) - 1, count);
 	struct snd_ctl_elem_id id;
 	int err;
 
-	strncpy(buf2, buf, len);
-	buf2[len] = '\0';
+	if (strscpy(buf2, buf, sizeof(buf2)) < 0)
+		return -E2BIG;
 	memset(&id, 0, sizeof(id));
 	id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
 	s = buf2;
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 47fdf7dc2472..c7321f5842b3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3558,6 +3558,15 @@ static void alc256_init(struct hda_codec *codec)
 	hda_nid_t hp_pin = alc_get_hp_pin(spec);
 	bool hp_pin_sense;
 
+	if (spec->ultra_low_power) {
+		alc_update_coef_idx(codec, 0x03, 1<<1, 1<<1);
+		alc_update_coef_idx(codec, 0x08, 3<<2, 3<<2);
+		alc_update_coef_idx(codec, 0x08, 7<<4, 0);
+		alc_update_coef_idx(codec, 0x3b, 1<<15, 0);
+		alc_update_coef_idx(codec, 0x0e, 7<<6, 7<<6);
+		msleep(30);
+	}
+
 	if (!hp_pin)
 		hp_pin = 0x21;
 
@@ -3569,14 +3578,6 @@ static void alc256_init(struct hda_codec *codec)
 		msleep(2);
 
 	alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x1); /* Low power */
-	if (spec->ultra_low_power) {
-		alc_update_coef_idx(codec, 0x03, 1<<1, 1<<1);
-		alc_update_coef_idx(codec, 0x08, 3<<2, 3<<2);
-		alc_update_coef_idx(codec, 0x08, 7<<4, 0);
-		alc_update_coef_idx(codec, 0x3b, 1<<15, 0);
-		alc_update_coef_idx(codec, 0x0e, 7<<6, 7<<6);
-		msleep(30);
-	}
 
 	snd_hda_codec_write(codec, hp_pin, 0,
 			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
@@ -3707,6 +3708,13 @@ static void alc225_init(struct hda_codec *codec)
 	hda_nid_t hp_pin = alc_get_hp_pin(spec);
 	bool hp1_pin_sense, hp2_pin_sense;
 
+	if (spec->ultra_low_power) {
+		alc_update_coef_idx(codec, 0x08, 0x0f << 2, 3<<2);
+		alc_update_coef_idx(codec, 0x0e, 7<<6, 7<<6);
+		alc_update_coef_idx(codec, 0x33, 1<<11, 0);
+		msleep(30);
+	}
+
 	if (spec->codec_variant != ALC269_TYPE_ALC287 &&
 		spec->codec_variant != ALC269_TYPE_ALC245)
 		/* required only at boot or S3 and S4 resume time */
@@ -3728,12 +3736,6 @@ static void alc225_init(struct hda_codec *codec)
 		msleep(2);
 
 	alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x1); /* Low power */
-	if (spec->ultra_low_power) {
-		alc_update_coef_idx(codec, 0x08, 0x0f << 2, 3<<2);
-		alc_update_coef_idx(codec, 0x0e, 7<<6, 7<<6);
-		alc_update_coef_idx(codec, 0x33, 1<<11, 0);
-		msleep(30);
-	}
 
 	if (hp1_pin_sense || spec->ultra_low_power)
 		snd_hda_codec_write(codec, hp_pin, 0,
@@ -4637,6 +4639,16 @@ static void alc285_fixup_hp_coef_micmute_led(struct hda_codec *codec,
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
@@ -4658,6 +4670,13 @@ static void alc285_fixup_hp_mute_led(struct hda_codec *codec,
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
@@ -6911,6 +6930,7 @@ enum {
 	ALC285_FIXUP_ASUS_G533Z_PINS,
 	ALC285_FIXUP_HP_GPIO_LED,
 	ALC285_FIXUP_HP_MUTE_LED,
+	ALC285_FIXUP_HP_SPECTRE_X360_MUTE_LED,
 	ALC236_FIXUP_HP_GPIO_LED,
 	ALC236_FIXUP_HP_MUTE_LED,
 	ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF,
@@ -8280,6 +8300,10 @@ static const struct hda_fixup alc269_fixups[] = {
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
@@ -8998,6 +9022,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x86e7, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x86e8, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
+	SND_PCI_QUIRK(0x103c, 0x86f9, "HP Spectre x360 13-aw0xxx", ALC285_FIXUP_HP_SPECTRE_X360_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8716, "HP Elite Dragonfly G2 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8720, "HP EliteBook x360 1040 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8724, "HP EliteBook 850 G7", ALC285_FIXUP_HP_GPIO_LED),
diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index a02a77fef360..6759ce7e09ff 100644
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
index 5e8d045c1a06..9f5e3e1dfd94 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -851,10 +851,11 @@ static void of_lpass_cpu_parse_dai_data(struct device *dev,
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
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index b6cd43c5ea3e..87a30be64324 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -525,6 +525,8 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 		if (snd_usb_endpoint_compatible(chip, subs->data_endpoint,
 						fmt, hw_params))
 			goto unlock;
+		if (stop_endpoints(subs, false))
+			sync_pending_stops(subs);
 		close_endpoints(chip, subs);
 	}
 
@@ -907,8 +909,13 @@ get_sync_ep_from_substream(struct snd_usb_substream *subs)
 			continue;
 		/* for the implicit fb, check the sync ep as well */
 		ep = snd_usb_get_endpoint(chip, fp->sync_ep);
-		if (ep && ep->cur_audiofmt)
-			return ep;
+		if (ep && ep->cur_audiofmt) {
+			/* ditto, if the sync (data) ep is used by others,
+			 * this stream is restricted by the sync ep
+			 */
+			if (ep != subs->sync_endpoint || ep->opened > 1)
+				return ep;
+		}
 	}
 	return NULL;
 }
diff --git a/tools/include/nolibc/arch-aarch64.h b/tools/include/nolibc/arch-aarch64.h
new file mode 100644
index 000000000000..2dbd80d633cb
--- /dev/null
+++ b/tools/include/nolibc/arch-aarch64.h
@@ -0,0 +1,199 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * AARCH64 specific definitions for NOLIBC
+ * Copyright (C) 2017-2022 Willy Tarreau <w@1wt.eu>
+ */
+
+#ifndef _NOLIBC_ARCH_AARCH64_H
+#define _NOLIBC_ARCH_AARCH64_H
+
+/* O_* macros for fcntl/open are architecture-specific */
+#define O_RDONLY            0
+#define O_WRONLY            1
+#define O_RDWR              2
+#define O_CREAT          0x40
+#define O_EXCL           0x80
+#define O_NOCTTY        0x100
+#define O_TRUNC         0x200
+#define O_APPEND        0x400
+#define O_NONBLOCK      0x800
+#define O_DIRECTORY    0x4000
+
+/* The struct returned by the newfstatat() syscall. Differs slightly from the
+ * x86_64's stat one by field ordering, so be careful.
+ */
+struct sys_stat_struct {
+	unsigned long   st_dev;
+	unsigned long   st_ino;
+	unsigned int    st_mode;
+	unsigned int    st_nlink;
+	unsigned int    st_uid;
+	unsigned int    st_gid;
+
+	unsigned long   st_rdev;
+	unsigned long   __pad1;
+	long            st_size;
+	int             st_blksize;
+	int             __pad2;
+
+	long            st_blocks;
+	long            st_atime;
+	unsigned long   st_atime_nsec;
+	long            st_mtime;
+
+	unsigned long   st_mtime_nsec;
+	long            st_ctime;
+	unsigned long   st_ctime_nsec;
+	unsigned int    __unused[2];
+};
+
+/* Syscalls for AARCH64 :
+ *   - registers are 64-bit
+ *   - stack is 16-byte aligned
+ *   - syscall number is passed in x8
+ *   - arguments are in x0, x1, x2, x3, x4, x5
+ *   - the system call is performed by calling svc 0
+ *   - syscall return comes in x0.
+ *   - the arguments are cast to long and assigned into the target registers
+ *     which are then simply passed as registers to the asm code, so that we
+ *     don't have to experience issues with register constraints.
+ *
+ * On aarch64, select() is not implemented so we have to use pselect6().
+ */
+#define __ARCH_WANT_SYS_PSELECT6
+
+#define my_syscall0(num)                                                      \
+({                                                                            \
+	register long _num  asm("x8") = (num);                                \
+	register long _arg1 asm("x0");                                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall1(num, arg1)                                                \
+({                                                                            \
+	register long _num  asm("x8") = (num);                                \
+	register long _arg1 asm("x0") = (long)(arg1);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_arg1),                                                 \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall2(num, arg1, arg2)                                          \
+({                                                                            \
+	register long _num  asm("x8") = (num);                                \
+	register long _arg1 asm("x0") = (long)(arg1);                         \
+	register long _arg2 asm("x1") = (long)(arg2);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_arg1), "r"(_arg2),                                     \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall3(num, arg1, arg2, arg3)                                    \
+({                                                                            \
+	register long _num  asm("x8") = (num);                                \
+	register long _arg1 asm("x0") = (long)(arg1);                         \
+	register long _arg2 asm("x1") = (long)(arg2);                         \
+	register long _arg3 asm("x2") = (long)(arg3);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
+({                                                                            \
+	register long _num  asm("x8") = (num);                                \
+	register long _arg1 asm("x0") = (long)(arg1);                         \
+	register long _arg2 asm("x1") = (long)(arg2);                         \
+	register long _arg3 asm("x2") = (long)(arg3);                         \
+	register long _arg4 asm("x3") = (long)(arg4);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
+({                                                                            \
+	register long _num  asm("x8") = (num);                                \
+	register long _arg1 asm("x0") = (long)(arg1);                         \
+	register long _arg2 asm("x1") = (long)(arg2);                         \
+	register long _arg3 asm("x2") = (long)(arg3);                         \
+	register long _arg4 asm("x3") = (long)(arg4);                         \
+	register long _arg5 asm("x4") = (long)(arg5);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r" (_arg1)                                                \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall6(num, arg1, arg2, arg3, arg4, arg5, arg6)                  \
+({                                                                            \
+	register long _num  asm("x8") = (num);                                \
+	register long _arg1 asm("x0") = (long)(arg1);                         \
+	register long _arg2 asm("x1") = (long)(arg2);                         \
+	register long _arg3 asm("x2") = (long)(arg3);                         \
+	register long _arg4 asm("x3") = (long)(arg4);                         \
+	register long _arg5 asm("x4") = (long)(arg5);                         \
+	register long _arg6 asm("x5") = (long)(arg6);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r" (_arg1)                                                \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
+		  "r"(_arg6), "r"(_num)                                       \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+/* startup code */
+asm(".section .text\n"
+    ".weak _start\n"
+    "_start:\n"
+    "ldr x0, [sp]\n"              // argc (x0) was in the stack
+    "add x1, sp, 8\n"             // argv (x1) = sp
+    "lsl x2, x0, 3\n"             // envp (x2) = 8*argc ...
+    "add x2, x2, 8\n"             //           + 8 (skip null)
+    "add x2, x2, x1\n"            //           + argv
+    "and sp, x1, -16\n"           // sp must be 16-byte aligned in the callee
+    "bl main\n"                   // main() returns the status code, we'll exit with it.
+    "mov x8, 93\n"                // NR_exit == 93
+    "svc #0\n"
+    "");
+
+#endif // _NOLIBC_ARCH_AARCH64_H
diff --git a/tools/include/nolibc/arch-arm.h b/tools/include/nolibc/arch-arm.h
new file mode 100644
index 000000000000..1191395b5acd
--- /dev/null
+++ b/tools/include/nolibc/arch-arm.h
@@ -0,0 +1,204 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * ARM specific definitions for NOLIBC
+ * Copyright (C) 2017-2022 Willy Tarreau <w@1wt.eu>
+ */
+
+#ifndef _NOLIBC_ARCH_ARM_H
+#define _NOLIBC_ARCH_ARM_H
+
+/* O_* macros for fcntl/open are architecture-specific */
+#define O_RDONLY            0
+#define O_WRONLY            1
+#define O_RDWR              2
+#define O_CREAT          0x40
+#define O_EXCL           0x80
+#define O_NOCTTY        0x100
+#define O_TRUNC         0x200
+#define O_APPEND        0x400
+#define O_NONBLOCK      0x800
+#define O_DIRECTORY    0x4000
+
+/* The struct returned by the stat() syscall, 32-bit only, the syscall returns
+ * exactly 56 bytes (stops before the unused array). In big endian, the format
+ * differs as devices are returned as short only.
+ */
+struct sys_stat_struct {
+#if defined(__ARMEB__)
+	unsigned short st_dev;
+	unsigned short __pad1;
+#else
+	unsigned long  st_dev;
+#endif
+	unsigned long  st_ino;
+	unsigned short st_mode;
+	unsigned short st_nlink;
+	unsigned short st_uid;
+	unsigned short st_gid;
+
+#if defined(__ARMEB__)
+	unsigned short st_rdev;
+	unsigned short __pad2;
+#else
+	unsigned long  st_rdev;
+#endif
+	unsigned long  st_size;
+	unsigned long  st_blksize;
+	unsigned long  st_blocks;
+
+	unsigned long  st_atime;
+	unsigned long  st_atime_nsec;
+	unsigned long  st_mtime;
+	unsigned long  st_mtime_nsec;
+
+	unsigned long  st_ctime;
+	unsigned long  st_ctime_nsec;
+	unsigned long  __unused[2];
+};
+
+/* Syscalls for ARM in ARM or Thumb modes :
+ *   - registers are 32-bit
+ *   - stack is 8-byte aligned
+ *     ( http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.faqs/ka4127.html)
+ *   - syscall number is passed in r7
+ *   - arguments are in r0, r1, r2, r3, r4, r5
+ *   - the system call is performed by calling svc #0
+ *   - syscall return comes in r0.
+ *   - only lr is clobbered.
+ *   - the arguments are cast to long and assigned into the target registers
+ *     which are then simply passed as registers to the asm code, so that we
+ *     don't have to experience issues with register constraints.
+ *   - the syscall number is always specified last in order to allow to force
+ *     some registers before (gcc refuses a %-register at the last position).
+ *
+ * Also, ARM supports the old_select syscall if newselect is not available
+ */
+#define __ARCH_WANT_SYS_OLD_SELECT
+
+#define my_syscall0(num)                                                      \
+({                                                                            \
+	register long _num asm("r7") = (num);                                 \
+	register long _arg1 asm("r0");                                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_num)                                                   \
+		: "memory", "cc", "lr"                                        \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall1(num, arg1)                                                \
+({                                                                            \
+	register long _num asm("r7") = (num);                                 \
+	register long _arg1 asm("r0") = (long)(arg1);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_arg1),                                                 \
+		  "r"(_num)                                                   \
+		: "memory", "cc", "lr"                                        \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall2(num, arg1, arg2)                                          \
+({                                                                            \
+	register long _num asm("r7") = (num);                                 \
+	register long _arg1 asm("r0") = (long)(arg1);                         \
+	register long _arg2 asm("r1") = (long)(arg2);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_arg1), "r"(_arg2),                                     \
+		  "r"(_num)                                                   \
+		: "memory", "cc", "lr"                                        \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall3(num, arg1, arg2, arg3)                                    \
+({                                                                            \
+	register long _num asm("r7") = (num);                                 \
+	register long _arg1 asm("r0") = (long)(arg1);                         \
+	register long _arg2 asm("r1") = (long)(arg2);                         \
+	register long _arg3 asm("r2") = (long)(arg3);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
+		  "r"(_num)                                                   \
+		: "memory", "cc", "lr"                                        \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
+({                                                                            \
+	register long _num asm("r7") = (num);                                 \
+	register long _arg1 asm("r0") = (long)(arg1);                         \
+	register long _arg2 asm("r1") = (long)(arg2);                         \
+	register long _arg3 asm("r2") = (long)(arg3);                         \
+	register long _arg4 asm("r3") = (long)(arg4);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r"(_arg1)                                                 \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
+		  "r"(_num)                                                   \
+		: "memory", "cc", "lr"                                        \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
+({                                                                            \
+	register long _num asm("r7") = (num);                                 \
+	register long _arg1 asm("r0") = (long)(arg1);                         \
+	register long _arg2 asm("r1") = (long)(arg2);                         \
+	register long _arg3 asm("r2") = (long)(arg3);                         \
+	register long _arg4 asm("r3") = (long)(arg4);                         \
+	register long _arg5 asm("r4") = (long)(arg5);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"svc #0\n"                                                    \
+		: "=r" (_arg1)                                                \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
+		  "r"(_num)                                                   \
+		: "memory", "cc", "lr"                                        \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+/* startup code */
+asm(".section .text\n"
+    ".weak _start\n"
+    "_start:\n"
+#if defined(__THUMBEB__) || defined(__THUMBEL__)
+    /* We enter here in 32-bit mode but if some previous functions were in
+     * 16-bit mode, the assembler cannot know, so we need to tell it we're in
+     * 32-bit now, then switch to 16-bit (is there a better way to do it than
+     * adding 1 by hand ?) and tell the asm we're now in 16-bit mode so that
+     * it generates correct instructions. Note that we do not support thumb1.
+     */
+    ".code 32\n"
+    "add     r0, pc, #1\n"
+    "bx      r0\n"
+    ".code 16\n"
+#endif
+    "pop {%r0}\n"                 // argc was in the stack
+    "mov %r1, %sp\n"              // argv = sp
+    "add %r2, %r1, %r0, lsl #2\n" // envp = argv + 4*argc ...
+    "add %r2, %r2, $4\n"          //        ... + 4
+    "and %r3, %r1, $-8\n"         // AAPCS : sp must be 8-byte aligned in the
+    "mov %sp, %r3\n"              //         callee, an bl doesn't push (lr=pc)
+    "bl main\n"                   // main() returns the status code, we'll exit with it.
+    "movs r7, $1\n"               // NR_exit == 1
+    "svc $0x00\n"
+    "");
+
+#endif // _NOLIBC_ARCH_ARM_H
diff --git a/tools/include/nolibc/arch-i386.h b/tools/include/nolibc/arch-i386.h
new file mode 100644
index 000000000000..125a691fc631
--- /dev/null
+++ b/tools/include/nolibc/arch-i386.h
@@ -0,0 +1,196 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * i386 specific definitions for NOLIBC
+ * Copyright (C) 2017-2022 Willy Tarreau <w@1wt.eu>
+ */
+
+#ifndef _NOLIBC_ARCH_I386_H
+#define _NOLIBC_ARCH_I386_H
+
+/* O_* macros for fcntl/open are architecture-specific */
+#define O_RDONLY            0
+#define O_WRONLY            1
+#define O_RDWR              2
+#define O_CREAT          0x40
+#define O_EXCL           0x80
+#define O_NOCTTY        0x100
+#define O_TRUNC         0x200
+#define O_APPEND        0x400
+#define O_NONBLOCK      0x800
+#define O_DIRECTORY   0x10000
+
+/* The struct returned by the stat() syscall, 32-bit only, the syscall returns
+ * exactly 56 bytes (stops before the unused array).
+ */
+struct sys_stat_struct {
+	unsigned long  st_dev;
+	unsigned long  st_ino;
+	unsigned short st_mode;
+	unsigned short st_nlink;
+	unsigned short st_uid;
+	unsigned short st_gid;
+
+	unsigned long  st_rdev;
+	unsigned long  st_size;
+	unsigned long  st_blksize;
+	unsigned long  st_blocks;
+
+	unsigned long  st_atime;
+	unsigned long  st_atime_nsec;
+	unsigned long  st_mtime;
+	unsigned long  st_mtime_nsec;
+
+	unsigned long  st_ctime;
+	unsigned long  st_ctime_nsec;
+	unsigned long  __unused[2];
+};
+
+/* Syscalls for i386 :
+ *   - mostly similar to x86_64
+ *   - registers are 32-bit
+ *   - syscall number is passed in eax
+ *   - arguments are in ebx, ecx, edx, esi, edi, ebp respectively
+ *   - all registers are preserved (except eax of course)
+ *   - the system call is performed by calling int $0x80
+ *   - syscall return comes in eax
+ *   - the arguments are cast to long and assigned into the target registers
+ *     which are then simply passed as registers to the asm code, so that we
+ *     don't have to experience issues with register constraints.
+ *   - the syscall number is always specified last in order to allow to force
+ *     some registers before (gcc refuses a %-register at the last position).
+ *
+ * Also, i386 supports the old_select syscall if newselect is not available
+ */
+#define __ARCH_WANT_SYS_OLD_SELECT
+
+#define my_syscall0(num)                                                      \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num asm("eax") = (num);                                \
+	                                                                      \
+	asm volatile (                                                        \
+		"int $0x80\n"                                                 \
+		: "=a" (_ret)                                                 \
+		: "0"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall1(num, arg1)                                                \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num asm("eax") = (num);                                \
+	register long _arg1 asm("ebx") = (long)(arg1);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"int $0x80\n"                                                 \
+		: "=a" (_ret)                                                 \
+		: "r"(_arg1),                                                 \
+		  "0"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall2(num, arg1, arg2)                                          \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num asm("eax") = (num);                                \
+	register long _arg1 asm("ebx") = (long)(arg1);                        \
+	register long _arg2 asm("ecx") = (long)(arg2);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"int $0x80\n"                                                 \
+		: "=a" (_ret)                                                 \
+		: "r"(_arg1), "r"(_arg2),                                     \
+		  "0"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall3(num, arg1, arg2, arg3)                                    \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num asm("eax") = (num);                                \
+	register long _arg1 asm("ebx") = (long)(arg1);                        \
+	register long _arg2 asm("ecx") = (long)(arg2);                        \
+	register long _arg3 asm("edx") = (long)(arg3);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"int $0x80\n"                                                 \
+		: "=a" (_ret)                                                 \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
+		  "0"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num asm("eax") = (num);                                \
+	register long _arg1 asm("ebx") = (long)(arg1);                        \
+	register long _arg2 asm("ecx") = (long)(arg2);                        \
+	register long _arg3 asm("edx") = (long)(arg3);                        \
+	register long _arg4 asm("esi") = (long)(arg4);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"int $0x80\n"                                                 \
+		: "=a" (_ret)                                                 \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
+		  "0"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num asm("eax") = (num);                                \
+	register long _arg1 asm("ebx") = (long)(arg1);                        \
+	register long _arg2 asm("ecx") = (long)(arg2);                        \
+	register long _arg3 asm("edx") = (long)(arg3);                        \
+	register long _arg4 asm("esi") = (long)(arg4);                        \
+	register long _arg5 asm("edi") = (long)(arg5);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"int $0x80\n"                                                 \
+		: "=a" (_ret)                                                 \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
+		  "0"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+/* startup code */
+/*
+ * i386 System V ABI mandates:
+ * 1) last pushed argument must be 16-byte aligned.
+ * 2) The deepest stack frame should be set to zero
+ *
+ */
+asm(".section .text\n"
+    ".weak _start\n"
+    "_start:\n"
+    "pop %eax\n"                // argc   (first arg, %eax)
+    "mov %esp, %ebx\n"          // argv[] (second arg, %ebx)
+    "lea 4(%ebx,%eax,4),%ecx\n" // then a NULL then envp (third arg, %ecx)
+    "xor %ebp, %ebp\n"          // zero the stack frame
+    "and $-16, %esp\n"          // x86 ABI : esp must be 16-byte aligned before
+    "sub $4, %esp\n"            // the call instruction (args are aligned)
+    "push %ecx\n"               // push all registers on the stack so that we
+    "push %ebx\n"               // support both regparm and plain stack modes
+    "push %eax\n"
+    "call main\n"               // main() returns the status code in %eax
+    "mov %eax, %ebx\n"          // retrieve exit code (32-bit int)
+    "movl $1, %eax\n"           // NR_exit == 1
+    "int $0x80\n"               // exit now
+    "hlt\n"                     // ensure it does not
+    "");
+
+#endif // _NOLIBC_ARCH_I386_H
diff --git a/tools/include/nolibc/arch-mips.h b/tools/include/nolibc/arch-mips.h
new file mode 100644
index 000000000000..5d647afa42e6
--- /dev/null
+++ b/tools/include/nolibc/arch-mips.h
@@ -0,0 +1,217 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * MIPS specific definitions for NOLIBC
+ * Copyright (C) 2017-2022 Willy Tarreau <w@1wt.eu>
+ */
+
+#ifndef _NOLIBC_ARCH_MIPS_H
+#define _NOLIBC_ARCH_MIPS_H
+
+/* O_* macros for fcntl/open are architecture-specific */
+#define O_RDONLY            0
+#define O_WRONLY            1
+#define O_RDWR              2
+#define O_APPEND       0x0008
+#define O_NONBLOCK     0x0080
+#define O_CREAT        0x0100
+#define O_TRUNC        0x0200
+#define O_EXCL         0x0400
+#define O_NOCTTY       0x0800
+#define O_DIRECTORY   0x10000
+
+/* The struct returned by the stat() syscall. 88 bytes are returned by the
+ * syscall.
+ */
+struct sys_stat_struct {
+	unsigned int  st_dev;
+	long          st_pad1[3];
+	unsigned long st_ino;
+	unsigned int  st_mode;
+	unsigned int  st_nlink;
+	unsigned int  st_uid;
+	unsigned int  st_gid;
+	unsigned int  st_rdev;
+	long          st_pad2[2];
+	long          st_size;
+	long          st_pad3;
+
+	long          st_atime;
+	long          st_atime_nsec;
+	long          st_mtime;
+	long          st_mtime_nsec;
+
+	long          st_ctime;
+	long          st_ctime_nsec;
+	long          st_blksize;
+	long          st_blocks;
+	long          st_pad4[14];
+};
+
+/* Syscalls for MIPS ABI O32 :
+ *   - WARNING! there's always a delayed slot!
+ *   - WARNING again, the syntax is different, registers take a '$' and numbers
+ *     do not.
+ *   - registers are 32-bit
+ *   - stack is 8-byte aligned
+ *   - syscall number is passed in v0 (starts at 0xfa0).
+ *   - arguments are in a0, a1, a2, a3, then the stack. The caller needs to
+ *     leave some room in the stack for the callee to save a0..a3 if needed.
+ *   - Many registers are clobbered, in fact only a0..a2 and s0..s8 are
+ *     preserved. See: https://www.linux-mips.org/wiki/Syscall as well as
+ *     scall32-o32.S in the kernel sources.
+ *   - the system call is performed by calling "syscall"
+ *   - syscall return comes in v0, and register a3 needs to be checked to know
+ *     if an error occurred, in which case errno is in v0.
+ *   - the arguments are cast to long and assigned into the target registers
+ *     which are then simply passed as registers to the asm code, so that we
+ *     don't have to experience issues with register constraints.
+ */
+
+#define my_syscall0(num)                                                      \
+({                                                                            \
+	register long _num asm("v0") = (num);                                 \
+	register long _arg4 asm("a3");                                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"addiu $sp, $sp, -32\n"                                       \
+		"syscall\n"                                                   \
+		"addiu $sp, $sp, 32\n"                                        \
+		: "=r"(_num), "=r"(_arg4)                                     \
+		: "r"(_num)                                                   \
+		: "memory", "cc", "at", "v1", "hi", "lo",                     \
+	          "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
+	);                                                                    \
+	_arg4 ? -_num : _num;                                                 \
+})
+
+#define my_syscall1(num, arg1)                                                \
+({                                                                            \
+	register long _num asm("v0") = (num);                                 \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg4 asm("a3");                                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"addiu $sp, $sp, -32\n"                                       \
+		"syscall\n"                                                   \
+		"addiu $sp, $sp, 32\n"                                        \
+		: "=r"(_num), "=r"(_arg4)                                     \
+		: "0"(_num),                                                  \
+		  "r"(_arg1)                                                  \
+		: "memory", "cc", "at", "v1", "hi", "lo",                     \
+	          "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
+	);                                                                    \
+	_arg4 ? -_num : _num;                                                 \
+})
+
+#define my_syscall2(num, arg1, arg2)                                          \
+({                                                                            \
+	register long _num asm("v0") = (num);                                 \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+	register long _arg4 asm("a3");                                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"addiu $sp, $sp, -32\n"                                       \
+		"syscall\n"                                                   \
+		"addiu $sp, $sp, 32\n"                                        \
+		: "=r"(_num), "=r"(_arg4)                                     \
+		: "0"(_num),                                                  \
+		  "r"(_arg1), "r"(_arg2)                                      \
+		: "memory", "cc", "at", "v1", "hi", "lo",                     \
+	          "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
+	);                                                                    \
+	_arg4 ? -_num : _num;                                                 \
+})
+
+#define my_syscall3(num, arg1, arg2, arg3)                                    \
+({                                                                            \
+	register long _num asm("v0")  = (num);                                \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+	register long _arg3 asm("a2") = (long)(arg3);                         \
+	register long _arg4 asm("a3");                                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"addiu $sp, $sp, -32\n"                                       \
+		"syscall\n"                                                   \
+		"addiu $sp, $sp, 32\n"                                        \
+		: "=r"(_num), "=r"(_arg4)                                     \
+		: "0"(_num),                                                  \
+		  "r"(_arg1), "r"(_arg2), "r"(_arg3)                          \
+		: "memory", "cc", "at", "v1", "hi", "lo",                     \
+	          "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
+	);                                                                    \
+	_arg4 ? -_num : _num;                                                 \
+})
+
+#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
+({                                                                            \
+	register long _num asm("v0") = (num);                                 \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+	register long _arg3 asm("a2") = (long)(arg3);                         \
+	register long _arg4 asm("a3") = (long)(arg4);                         \
+	                                                                      \
+	asm volatile (                                                        \
+		"addiu $sp, $sp, -32\n"                                       \
+		"syscall\n"                                                   \
+		"addiu $sp, $sp, 32\n"                                        \
+		: "=r" (_num), "=r"(_arg4)                                    \
+		: "0"(_num),                                                  \
+		  "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4)              \
+		: "memory", "cc", "at", "v1", "hi", "lo",                     \
+	          "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
+	);                                                                    \
+	_arg4 ? -_num : _num;                                                 \
+})
+
+#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
+({                                                                            \
+	register long _num asm("v0") = (num);                                 \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+	register long _arg3 asm("a2") = (long)(arg3);                         \
+	register long _arg4 asm("a3") = (long)(arg4);                         \
+	register long _arg5 = (long)(arg5);                                   \
+	                                                                      \
+	asm volatile (                                                        \
+		"addiu $sp, $sp, -32\n"                                       \
+		"sw %7, 16($sp)\n"                                            \
+		"syscall\n  "                                                 \
+		"addiu $sp, $sp, 32\n"                                        \
+		: "=r" (_num), "=r"(_arg4)                                    \
+		: "0"(_num),                                                  \
+		  "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5)  \
+		: "memory", "cc", "at", "v1", "hi", "lo",                     \
+	          "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
+	);                                                                    \
+	_arg4 ? -_num : _num;                                                 \
+})
+
+/* startup code, note that it's called __start on MIPS */
+asm(".section .text\n"
+    ".weak __start\n"
+    ".set nomips16\n"
+    ".set push\n"
+    ".set    noreorder\n"
+    ".option pic0\n"
+    ".ent __start\n"
+    "__start:\n"
+    "lw $a0,($sp)\n"              // argc was in the stack
+    "addiu  $a1, $sp, 4\n"        // argv = sp + 4
+    "sll $a2, $a0, 2\n"           // a2 = argc * 4
+    "add   $a2, $a2, $a1\n"       // envp = argv + 4*argc ...
+    "addiu $a2, $a2, 4\n"         //        ... + 4
+    "li $t0, -8\n"
+    "and $sp, $sp, $t0\n"         // sp must be 8-byte aligned
+    "addiu $sp,$sp,-16\n"         // the callee expects to save a0..a3 there!
+    "jal main\n"                  // main() returns the status code, we'll exit with it.
+    "nop\n"                       // delayed slot
+    "move $a0, $v0\n"             // retrieve 32-bit exit code from v0
+    "li $v0, 4001\n"              // NR_exit == 4001
+    "syscall\n"
+    ".end __start\n"
+    ".set pop\n"
+    "");
+
+#endif // _NOLIBC_ARCH_MIPS_H
diff --git a/tools/include/nolibc/arch-riscv.h b/tools/include/nolibc/arch-riscv.h
new file mode 100644
index 000000000000..8c0cb1abb29f
--- /dev/null
+++ b/tools/include/nolibc/arch-riscv.h
@@ -0,0 +1,204 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * RISCV (32 and 64) specific definitions for NOLIBC
+ * Copyright (C) 2017-2022 Willy Tarreau <w@1wt.eu>
+ */
+
+#ifndef _NOLIBC_ARCH_RISCV_H
+#define _NOLIBC_ARCH_RISCV_H
+
+/* O_* macros for fcntl/open are architecture-specific */
+#define O_RDONLY            0
+#define O_WRONLY            1
+#define O_RDWR              2
+#define O_CREAT          0x40
+#define O_EXCL           0x80
+#define O_NOCTTY        0x100
+#define O_TRUNC         0x200
+#define O_APPEND        0x400
+#define O_NONBLOCK      0x800
+#define O_DIRECTORY   0x10000
+
+struct sys_stat_struct {
+	unsigned long	st_dev;		/* Device.  */
+	unsigned long	st_ino;		/* File serial number.  */
+	unsigned int	st_mode;	/* File mode.  */
+	unsigned int	st_nlink;	/* Link count.  */
+	unsigned int	st_uid;		/* User ID of the file's owner.  */
+	unsigned int	st_gid;		/* Group ID of the file's group. */
+	unsigned long	st_rdev;	/* Device number, if device.  */
+	unsigned long	__pad1;
+	long		st_size;	/* Size of file, in bytes.  */
+	int		st_blksize;	/* Optimal block size for I/O.  */
+	int		__pad2;
+	long		st_blocks;	/* Number 512-byte blocks allocated. */
+	long		st_atime;	/* Time of last access.  */
+	unsigned long	st_atime_nsec;
+	long		st_mtime;	/* Time of last modification.  */
+	unsigned long	st_mtime_nsec;
+	long		st_ctime;	/* Time of last status change.  */
+	unsigned long	st_ctime_nsec;
+	unsigned int	__unused4;
+	unsigned int	__unused5;
+};
+
+#if   __riscv_xlen == 64
+#define PTRLOG "3"
+#define SZREG  "8"
+#elif __riscv_xlen == 32
+#define PTRLOG "2"
+#define SZREG  "4"
+#endif
+
+/* Syscalls for RISCV :
+ *   - stack is 16-byte aligned
+ *   - syscall number is passed in a7
+ *   - arguments are in a0, a1, a2, a3, a4, a5
+ *   - the system call is performed by calling ecall
+ *   - syscall return comes in a0
+ *   - the arguments are cast to long and assigned into the target
+ *     registers which are then simply passed as registers to the asm code,
+ *     so that we don't have to experience issues with register constraints.
+ *
+ * On riscv, select() is not implemented so we have to use pselect6().
+ */
+#define __ARCH_WANT_SYS_PSELECT6
+
+#define my_syscall0(num)                                                      \
+({                                                                            \
+	register long _num  asm("a7") = (num);                                \
+	register long _arg1 asm("a0");                                        \
+									      \
+	asm volatile (                                                        \
+		"ecall\n\t"                                                   \
+		: "=r"(_arg1)                                                 \
+		: "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall1(num, arg1)                                                \
+({                                                                            \
+	register long _num  asm("a7") = (num);                                \
+	register long _arg1 asm("a0") = (long)(arg1);		              \
+									      \
+	asm volatile (                                                        \
+		"ecall\n"                                                     \
+		: "+r"(_arg1)                                                 \
+		: "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall2(num, arg1, arg2)                                          \
+({                                                                            \
+	register long _num  asm("a7") = (num);                                \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+									      \
+	asm volatile (                                                        \
+		"ecall\n"                                                     \
+		: "+r"(_arg1)                                                 \
+		: "r"(_arg2),                                                 \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall3(num, arg1, arg2, arg3)                                    \
+({                                                                            \
+	register long _num  asm("a7") = (num);                                \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+	register long _arg3 asm("a2") = (long)(arg3);                         \
+									      \
+	asm volatile (                                                        \
+		"ecall\n\t"                                                   \
+		: "+r"(_arg1)                                                 \
+		: "r"(_arg2), "r"(_arg3),                                     \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
+({                                                                            \
+	register long _num  asm("a7") = (num);                                \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+	register long _arg3 asm("a2") = (long)(arg3);                         \
+	register long _arg4 asm("a3") = (long)(arg4);                         \
+									      \
+	asm volatile (                                                        \
+		"ecall\n"                                                     \
+		: "+r"(_arg1)                                                 \
+		: "r"(_arg2), "r"(_arg3), "r"(_arg4),                         \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
+({                                                                            \
+	register long _num  asm("a7") = (num);                                \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+	register long _arg3 asm("a2") = (long)(arg3);                         \
+	register long _arg4 asm("a3") = (long)(arg4);                         \
+	register long _arg5 asm("a4") = (long)(arg5);                         \
+									      \
+	asm volatile (                                                        \
+		"ecall\n"                                                     \
+		: "+r"(_arg1)                                                 \
+		: "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5),             \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+#define my_syscall6(num, arg1, arg2, arg3, arg4, arg5, arg6)                  \
+({                                                                            \
+	register long _num  asm("a7") = (num);                                \
+	register long _arg1 asm("a0") = (long)(arg1);                         \
+	register long _arg2 asm("a1") = (long)(arg2);                         \
+	register long _arg3 asm("a2") = (long)(arg3);                         \
+	register long _arg4 asm("a3") = (long)(arg4);                         \
+	register long _arg5 asm("a4") = (long)(arg5);                         \
+	register long _arg6 asm("a5") = (long)(arg6);                         \
+									      \
+	asm volatile (                                                        \
+		"ecall\n"                                                     \
+		: "+r"(_arg1)                                                 \
+		: "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), "r"(_arg6), \
+		  "r"(_num)                                                   \
+		: "memory", "cc"                                              \
+	);                                                                    \
+	_arg1;                                                                \
+})
+
+/* startup code */
+asm(".section .text\n"
+    ".weak _start\n"
+    "_start:\n"
+    ".option push\n"
+    ".option norelax\n"
+    "lla   gp, __global_pointer$\n"
+    ".option pop\n"
+    "ld    a0, 0(sp)\n"          // argc (a0) was in the stack
+    "add   a1, sp, "SZREG"\n"    // argv (a1) = sp
+    "slli  a2, a0, "PTRLOG"\n"   // envp (a2) = SZREG*argc ...
+    "add   a2, a2, "SZREG"\n"    //             + SZREG (skip null)
+    "add   a2,a2,a1\n"           //             + argv
+    "andi  sp,a1,-16\n"          // sp must be 16-byte aligned
+    "call  main\n"               // main() returns the status code, we'll exit with it.
+    "li a7, 93\n"                // NR_exit == 93
+    "ecall\n"
+    "");
+
+#endif // _NOLIBC_ARCH_RISCV_H
diff --git a/tools/include/nolibc/arch-x86_64.h b/tools/include/nolibc/arch-x86_64.h
new file mode 100644
index 000000000000..b1af63ce1cb0
--- /dev/null
+++ b/tools/include/nolibc/arch-x86_64.h
@@ -0,0 +1,215 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * x86_64 specific definitions for NOLIBC
+ * Copyright (C) 2017-2022 Willy Tarreau <w@1wt.eu>
+ */
+
+#ifndef _NOLIBC_ARCH_X86_64_H
+#define _NOLIBC_ARCH_X86_64_H
+
+/* O_* macros for fcntl/open are architecture-specific */
+#define O_RDONLY            0
+#define O_WRONLY            1
+#define O_RDWR              2
+#define O_CREAT          0x40
+#define O_EXCL           0x80
+#define O_NOCTTY        0x100
+#define O_TRUNC         0x200
+#define O_APPEND        0x400
+#define O_NONBLOCK      0x800
+#define O_DIRECTORY   0x10000
+
+/* The struct returned by the stat() syscall, equivalent to stat64(). The
+ * syscall returns 116 bytes and stops in the middle of __unused.
+ */
+struct sys_stat_struct {
+	unsigned long st_dev;
+	unsigned long st_ino;
+	unsigned long st_nlink;
+	unsigned int  st_mode;
+	unsigned int  st_uid;
+
+	unsigned int  st_gid;
+	unsigned int  __pad0;
+	unsigned long st_rdev;
+	long          st_size;
+	long          st_blksize;
+
+	long          st_blocks;
+	unsigned long st_atime;
+	unsigned long st_atime_nsec;
+	unsigned long st_mtime;
+
+	unsigned long st_mtime_nsec;
+	unsigned long st_ctime;
+	unsigned long st_ctime_nsec;
+	long          __unused[3];
+};
+
+/* Syscalls for x86_64 :
+ *   - registers are 64-bit
+ *   - syscall number is passed in rax
+ *   - arguments are in rdi, rsi, rdx, r10, r8, r9 respectively
+ *   - the system call is performed by calling the syscall instruction
+ *   - syscall return comes in rax
+ *   - rcx and r11 are clobbered, others are preserved.
+ *   - the arguments are cast to long and assigned into the target registers
+ *     which are then simply passed as registers to the asm code, so that we
+ *     don't have to experience issues with register constraints.
+ *   - the syscall number is always specified last in order to allow to force
+ *     some registers before (gcc refuses a %-register at the last position).
+ *   - see also x86-64 ABI section A.2 AMD64 Linux Kernel Conventions, A.2.1
+ *     Calling Conventions.
+ *
+ * Link x86-64 ABI: https://gitlab.com/x86-psABIs/x86-64-ABI/-/wikis/x86-64-psABI
+ *
+ */
+
+#define my_syscall0(num)                                                      \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num  asm("rax") = (num);                               \
+	                                                                      \
+	asm volatile (                                                        \
+		"syscall\n"                                                   \
+		: "=a"(_ret)                                                  \
+		: "0"(_num)                                                   \
+		: "rcx", "r11", "memory", "cc"                                \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall1(num, arg1)                                                \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num  asm("rax") = (num);                               \
+	register long _arg1 asm("rdi") = (long)(arg1);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"syscall\n"                                                   \
+		: "=a"(_ret)                                                  \
+		: "r"(_arg1),                                                 \
+		  "0"(_num)                                                   \
+		: "rcx", "r11", "memory", "cc"                                \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall2(num, arg1, arg2)                                          \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num  asm("rax") = (num);                               \
+	register long _arg1 asm("rdi") = (long)(arg1);                        \
+	register long _arg2 asm("rsi") = (long)(arg2);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"syscall\n"                                                   \
+		: "=a"(_ret)                                                  \
+		: "r"(_arg1), "r"(_arg2),                                     \
+		  "0"(_num)                                                   \
+		: "rcx", "r11", "memory", "cc"                                \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall3(num, arg1, arg2, arg3)                                    \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num  asm("rax") = (num);                               \
+	register long _arg1 asm("rdi") = (long)(arg1);                        \
+	register long _arg2 asm("rsi") = (long)(arg2);                        \
+	register long _arg3 asm("rdx") = (long)(arg3);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"syscall\n"                                                   \
+		: "=a"(_ret)                                                  \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
+		  "0"(_num)                                                   \
+		: "rcx", "r11", "memory", "cc"                                \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num  asm("rax") = (num);                               \
+	register long _arg1 asm("rdi") = (long)(arg1);                        \
+	register long _arg2 asm("rsi") = (long)(arg2);                        \
+	register long _arg3 asm("rdx") = (long)(arg3);                        \
+	register long _arg4 asm("r10") = (long)(arg4);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"syscall\n"                                                   \
+		: "=a"(_ret)                                                  \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
+		  "0"(_num)                                                   \
+		: "rcx", "r11", "memory", "cc"                                \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num  asm("rax") = (num);                               \
+	register long _arg1 asm("rdi") = (long)(arg1);                        \
+	register long _arg2 asm("rsi") = (long)(arg2);                        \
+	register long _arg3 asm("rdx") = (long)(arg3);                        \
+	register long _arg4 asm("r10") = (long)(arg4);                        \
+	register long _arg5 asm("r8")  = (long)(arg5);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"syscall\n"                                                   \
+		: "=a"(_ret)                                                  \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
+		  "0"(_num)                                                   \
+		: "rcx", "r11", "memory", "cc"                                \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+#define my_syscall6(num, arg1, arg2, arg3, arg4, arg5, arg6)                  \
+({                                                                            \
+	long _ret;                                                            \
+	register long _num  asm("rax") = (num);                               \
+	register long _arg1 asm("rdi") = (long)(arg1);                        \
+	register long _arg2 asm("rsi") = (long)(arg2);                        \
+	register long _arg3 asm("rdx") = (long)(arg3);                        \
+	register long _arg4 asm("r10") = (long)(arg4);                        \
+	register long _arg5 asm("r8")  = (long)(arg5);                        \
+	register long _arg6 asm("r9")  = (long)(arg6);                        \
+	                                                                      \
+	asm volatile (                                                        \
+		"syscall\n"                                                   \
+		: "=a"(_ret)                                                  \
+		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
+		  "r"(_arg6), "0"(_num)                                       \
+		: "rcx", "r11", "memory", "cc"                                \
+	);                                                                    \
+	_ret;                                                                 \
+})
+
+/* startup code */
+/*
+ * x86-64 System V ABI mandates:
+ * 1) %rsp must be 16-byte aligned right before the function call.
+ * 2) The deepest stack frame should be zero (the %rbp).
+ *
+ */
+asm(".section .text\n"
+    ".weak _start\n"
+    "_start:\n"
+    "pop %rdi\n"                // argc   (first arg, %rdi)
+    "mov %rsp, %rsi\n"          // argv[] (second arg, %rsi)
+    "lea 8(%rsi,%rdi,8),%rdx\n" // then a NULL then envp (third arg, %rdx)
+    "xor %ebp, %ebp\n"          // zero the stack frame
+    "and $-16, %rsp\n"          // x86 ABI : esp must be 16-byte aligned before call
+    "call main\n"               // main() returns the status code, we'll exit with it.
+    "mov %eax, %edi\n"          // retrieve exit code (32 bit)
+    "mov $60, %eax\n"           // NR_exit == 60
+    "syscall\n"                 // really exit
+    "hlt\n"                     // ensure it does not return
+    "");
+
+#endif // _NOLIBC_ARCH_X86_64_H
diff --git a/tools/include/nolibc/arch.h b/tools/include/nolibc/arch.h
new file mode 100644
index 000000000000..4c6992321b0d
--- /dev/null
+++ b/tools/include/nolibc/arch.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * Copyright (C) 2017-2022 Willy Tarreau <w@1wt.eu>
+ */
+
+/* Below comes the architecture-specific code. For each architecture, we have
+ * the syscall declarations and the _start code definition. This is the only
+ * global part. On all architectures the kernel puts everything in the stack
+ * before jumping to _start just above us, without any return address (_start
+ * is not a function but an entry pint). So at the stack pointer we find argc.
+ * Then argv[] begins, and ends at the first NULL. Then we have envp which
+ * starts and ends with a NULL as well. So envp=argv+argc+1.
+ */
+
+#ifndef _NOLIBC_ARCH_H
+#define _NOLIBC_ARCH_H
+
+#if defined(__x86_64__)
+#include "arch-x86_64.h"
+#elif defined(__i386__) || defined(__i486__) || defined(__i586__) || defined(__i686__)
+#include "arch-i386.h"
+#elif defined(__ARM_EABI__)
+#include "arch-arm.h"
+#elif defined(__aarch64__)
+#include "arch-aarch64.h"
+#elif defined(__mips__) && defined(_ABIO32)
+#include "arch-mips.h"
+#elif defined(__riscv)
+#include "arch-riscv.h"
+#endif
+
+#endif /* _NOLIBC_ARCH_H */
diff --git a/tools/include/nolibc/nolibc.h b/tools/include/nolibc/nolibc.h
index d64020c1922c..d272b721dc51 100644
--- a/tools/include/nolibc/nolibc.h
+++ b/tools/include/nolibc/nolibc.h
@@ -81,13 +81,21 @@
  *
  */
 
+/* standard type definitions */
+#include "std.h"
+
+/* system includes */
 #include <asm/unistd.h>
+#include <asm/signal.h>  // for SIGCHLD
 #include <asm/ioctls.h>
 #include <asm/errno.h>
 #include <linux/fs.h>
 #include <linux/loop.h>
 #include <linux/time.h>
+#include "arch.h"
+#include "types.h"
 
+/* Used by programs to avoid std includes */
 #define NOLIBC
 
 /* this way it will be removed if unused */
@@ -104,1329 +112,6 @@ static int errno;
  */
 #define MAX_ERRNO 4095
 
-/* Declare a few quite common macros and types that usually are in stdlib.h,
- * stdint.h, ctype.h, unistd.h and a few other common locations.
- */
-
-#define NULL ((void *)0)
-
-/* stdint types */
-typedef unsigned char       uint8_t;
-typedef   signed char        int8_t;
-typedef unsigned short     uint16_t;
-typedef   signed short      int16_t;
-typedef unsigned int       uint32_t;
-typedef   signed int        int32_t;
-typedef unsigned long long uint64_t;
-typedef   signed long long  int64_t;
-typedef unsigned long        size_t;
-typedef   signed long       ssize_t;
-typedef unsigned long     uintptr_t;
-typedef   signed long      intptr_t;
-typedef   signed long     ptrdiff_t;
-
-/* for stat() */
-typedef unsigned int          dev_t;
-typedef unsigned long         ino_t;
-typedef unsigned int         mode_t;
-typedef   signed int          pid_t;
-typedef unsigned int          uid_t;
-typedef unsigned int          gid_t;
-typedef unsigned long       nlink_t;
-typedef   signed long         off_t;
-typedef   signed long     blksize_t;
-typedef   signed long      blkcnt_t;
-typedef   signed long        time_t;
-
-/* for poll() */
-struct pollfd {
-	int fd;
-	short int events;
-	short int revents;
-};
-
-/* for getdents64() */
-struct linux_dirent64 {
-	uint64_t       d_ino;
-	int64_t        d_off;
-	unsigned short d_reclen;
-	unsigned char  d_type;
-	char           d_name[];
-};
-
-/* commonly an fd_set represents 256 FDs */
-#define FD_SETSIZE 256
-typedef struct { uint32_t fd32[FD_SETSIZE/32]; } fd_set;
-
-/* needed by wait4() */
-struct rusage {
-	struct timeval ru_utime;
-	struct timeval ru_stime;
-	long   ru_maxrss;
-	long   ru_ixrss;
-	long   ru_idrss;
-	long   ru_isrss;
-	long   ru_minflt;
-	long   ru_majflt;
-	long   ru_nswap;
-	long   ru_inblock;
-	long   ru_oublock;
-	long   ru_msgsnd;
-	long   ru_msgrcv;
-	long   ru_nsignals;
-	long   ru_nvcsw;
-	long   ru_nivcsw;
-};
-
-/* stat flags (WARNING, octal here) */
-#define S_IFDIR       0040000
-#define S_IFCHR       0020000
-#define S_IFBLK       0060000
-#define S_IFREG       0100000
-#define S_IFIFO       0010000
-#define S_IFLNK       0120000
-#define S_IFSOCK      0140000
-#define S_IFMT        0170000
-
-#define S_ISDIR(mode)  (((mode) & S_IFDIR) == S_IFDIR)
-#define S_ISCHR(mode)  (((mode) & S_IFCHR) == S_IFCHR)
-#define S_ISBLK(mode)  (((mode) & S_IFBLK) == S_IFBLK)
-#define S_ISREG(mode)  (((mode) & S_IFREG) == S_IFREG)
-#define S_ISFIFO(mode) (((mode) & S_IFIFO) == S_IFIFO)
-#define S_ISLNK(mode)  (((mode) & S_IFLNK) == S_IFLNK)
-#define S_ISSOCK(mode) (((mode) & S_IFSOCK) == S_IFSOCK)
-
-#define DT_UNKNOWN 0
-#define DT_FIFO    1
-#define DT_CHR     2
-#define DT_DIR     4
-#define DT_BLK     6
-#define DT_REG     8
-#define DT_LNK    10
-#define DT_SOCK   12
-
-/* all the *at functions */
-#ifndef AT_FDCWD
-#define AT_FDCWD             -100
-#endif
-
-/* lseek */
-#define SEEK_SET        0
-#define SEEK_CUR        1
-#define SEEK_END        2
-
-/* reboot */
-#define LINUX_REBOOT_MAGIC1         0xfee1dead
-#define LINUX_REBOOT_MAGIC2         0x28121969
-#define LINUX_REBOOT_CMD_HALT       0xcdef0123
-#define LINUX_REBOOT_CMD_POWER_OFF  0x4321fedc
-#define LINUX_REBOOT_CMD_RESTART    0x01234567
-#define LINUX_REBOOT_CMD_SW_SUSPEND 0xd000fce2
-
-
-/* The format of the struct as returned by the libc to the application, which
- * significantly differs from the format returned by the stat() syscall flavours.
- */
-struct stat {
-	dev_t     st_dev;     /* ID of device containing file */
-	ino_t     st_ino;     /* inode number */
-	mode_t    st_mode;    /* protection */
-	nlink_t   st_nlink;   /* number of hard links */
-	uid_t     st_uid;     /* user ID of owner */
-	gid_t     st_gid;     /* group ID of owner */
-	dev_t     st_rdev;    /* device ID (if special file) */
-	off_t     st_size;    /* total size, in bytes */
-	blksize_t st_blksize; /* blocksize for file system I/O */
-	blkcnt_t  st_blocks;  /* number of 512B blocks allocated */
-	time_t    st_atime;   /* time of last access */
-	time_t    st_mtime;   /* time of last modification */
-	time_t    st_ctime;   /* time of last status change */
-};
-
-#define WEXITSTATUS(status)   (((status) & 0xff00) >> 8)
-#define WIFEXITED(status)     (((status) & 0x7f) == 0)
-
-/* for SIGCHLD */
-#include <asm/signal.h>
-
-/* Below comes the architecture-specific code. For each architecture, we have
- * the syscall declarations and the _start code definition. This is the only
- * global part. On all architectures the kernel puts everything in the stack
- * before jumping to _start just above us, without any return address (_start
- * is not a function but an entry pint). So at the stack pointer we find argc.
- * Then argv[] begins, and ends at the first NULL. Then we have envp which
- * starts and ends with a NULL as well. So envp=argv+argc+1.
- */
-
-#if defined(__x86_64__)
-/* Syscalls for x86_64 :
- *   - registers are 64-bit
- *   - syscall number is passed in rax
- *   - arguments are in rdi, rsi, rdx, r10, r8, r9 respectively
- *   - the system call is performed by calling the syscall instruction
- *   - syscall return comes in rax
- *   - rcx and r8..r11 may be clobbered, others are preserved.
- *   - the arguments are cast to long and assigned into the target registers
- *     which are then simply passed as registers to the asm code, so that we
- *     don't have to experience issues with register constraints.
- *   - the syscall number is always specified last in order to allow to force
- *     some registers before (gcc refuses a %-register at the last position).
- */
-
-#define my_syscall0(num)                                                      \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num  asm("rax") = (num);                               \
-									      \
-	asm volatile (                                                        \
-		"syscall\n"                                                   \
-		: "=a" (_ret)                                                 \
-		: "0"(_num)                                                   \
-		: "rcx", "r8", "r9", "r10", "r11", "memory", "cc"             \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall1(num, arg1)                                                \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num  asm("rax") = (num);                               \
-	register long _arg1 asm("rdi") = (long)(arg1);                        \
-									      \
-	asm volatile (                                                        \
-		"syscall\n"                                                   \
-		: "=a" (_ret)                                                 \
-		: "r"(_arg1),                                                 \
-		  "0"(_num)                                                   \
-		: "rcx", "r8", "r9", "r10", "r11", "memory", "cc"             \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall2(num, arg1, arg2)                                          \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num  asm("rax") = (num);                               \
-	register long _arg1 asm("rdi") = (long)(arg1);                        \
-	register long _arg2 asm("rsi") = (long)(arg2);                        \
-									      \
-	asm volatile (                                                        \
-		"syscall\n"                                                   \
-		: "=a" (_ret)                                                 \
-		: "r"(_arg1), "r"(_arg2),                                     \
-		  "0"(_num)                                                   \
-		: "rcx", "r8", "r9", "r10", "r11", "memory", "cc"             \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall3(num, arg1, arg2, arg3)                                    \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num  asm("rax") = (num);                               \
-	register long _arg1 asm("rdi") = (long)(arg1);                        \
-	register long _arg2 asm("rsi") = (long)(arg2);                        \
-	register long _arg3 asm("rdx") = (long)(arg3);                        \
-									      \
-	asm volatile (                                                        \
-		"syscall\n"                                                   \
-		: "=a" (_ret)                                                 \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
-		  "0"(_num)                                                   \
-		: "rcx", "r8", "r9", "r10", "r11", "memory", "cc"             \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num  asm("rax") = (num);                               \
-	register long _arg1 asm("rdi") = (long)(arg1);                        \
-	register long _arg2 asm("rsi") = (long)(arg2);                        \
-	register long _arg3 asm("rdx") = (long)(arg3);                        \
-	register long _arg4 asm("r10") = (long)(arg4);                        \
-									      \
-	asm volatile (                                                        \
-		"syscall\n"                                                   \
-		: "=a" (_ret), "=r"(_arg4)                                    \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
-		  "0"(_num)                                                   \
-		: "rcx", "r8", "r9", "r11", "memory", "cc"                    \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num  asm("rax") = (num);                               \
-	register long _arg1 asm("rdi") = (long)(arg1);                        \
-	register long _arg2 asm("rsi") = (long)(arg2);                        \
-	register long _arg3 asm("rdx") = (long)(arg3);                        \
-	register long _arg4 asm("r10") = (long)(arg4);                        \
-	register long _arg5 asm("r8")  = (long)(arg5);                        \
-									      \
-	asm volatile (                                                        \
-		"syscall\n"                                                   \
-		: "=a" (_ret), "=r"(_arg4), "=r"(_arg5)                       \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
-		  "0"(_num)                                                   \
-		: "rcx", "r9", "r11", "memory", "cc"                          \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall6(num, arg1, arg2, arg3, arg4, arg5, arg6)                  \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num  asm("rax") = (num);                               \
-	register long _arg1 asm("rdi") = (long)(arg1);                        \
-	register long _arg2 asm("rsi") = (long)(arg2);                        \
-	register long _arg3 asm("rdx") = (long)(arg3);                        \
-	register long _arg4 asm("r10") = (long)(arg4);                        \
-	register long _arg5 asm("r8")  = (long)(arg5);                        \
-	register long _arg6 asm("r9")  = (long)(arg6);                        \
-									      \
-	asm volatile (                                                        \
-		"syscall\n"                                                   \
-		: "=a" (_ret), "=r"(_arg4), "=r"(_arg5)                       \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
-		  "r"(_arg6), "0"(_num)                                       \
-		: "rcx", "r11", "memory", "cc"                                \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-/* startup code */
-/*
- * x86-64 System V ABI mandates:
- * 1) %rsp must be 16-byte aligned right before the function call.
- * 2) The deepest stack frame should be zero (the %rbp).
- *
- */
-asm(".section .text\n"
-    ".global _start\n"
-    "_start:\n"
-    "pop %rdi\n"                // argc   (first arg, %rdi)
-    "mov %rsp, %rsi\n"          // argv[] (second arg, %rsi)
-    "lea 8(%rsi,%rdi,8),%rdx\n" // then a NULL then envp (third arg, %rdx)
-    "xor %ebp, %ebp\n"          // zero the stack frame
-    "and $-16, %rsp\n"          // x86 ABI : esp must be 16-byte aligned before call
-    "call main\n"               // main() returns the status code, we'll exit with it.
-    "mov %eax, %edi\n"          // retrieve exit code (32 bit)
-    "mov $60, %rax\n"           // NR_exit == 60
-    "syscall\n"                 // really exit
-    "hlt\n"                     // ensure it does not return
-    "");
-
-/* fcntl / open */
-#define O_RDONLY            0
-#define O_WRONLY            1
-#define O_RDWR              2
-#define O_CREAT          0x40
-#define O_EXCL           0x80
-#define O_NOCTTY        0x100
-#define O_TRUNC         0x200
-#define O_APPEND        0x400
-#define O_NONBLOCK      0x800
-#define O_DIRECTORY   0x10000
-
-/* The struct returned by the stat() syscall, equivalent to stat64(). The
- * syscall returns 116 bytes and stops in the middle of __unused.
- */
-struct sys_stat_struct {
-	unsigned long st_dev;
-	unsigned long st_ino;
-	unsigned long st_nlink;
-	unsigned int  st_mode;
-	unsigned int  st_uid;
-
-	unsigned int  st_gid;
-	unsigned int  __pad0;
-	unsigned long st_rdev;
-	long          st_size;
-	long          st_blksize;
-
-	long          st_blocks;
-	unsigned long st_atime;
-	unsigned long st_atime_nsec;
-	unsigned long st_mtime;
-
-	unsigned long st_mtime_nsec;
-	unsigned long st_ctime;
-	unsigned long st_ctime_nsec;
-	long          __unused[3];
-};
-
-#elif defined(__i386__) || defined(__i486__) || defined(__i586__) || defined(__i686__)
-/* Syscalls for i386 :
- *   - mostly similar to x86_64
- *   - registers are 32-bit
- *   - syscall number is passed in eax
- *   - arguments are in ebx, ecx, edx, esi, edi, ebp respectively
- *   - all registers are preserved (except eax of course)
- *   - the system call is performed by calling int $0x80
- *   - syscall return comes in eax
- *   - the arguments are cast to long and assigned into the target registers
- *     which are then simply passed as registers to the asm code, so that we
- *     don't have to experience issues with register constraints.
- *   - the syscall number is always specified last in order to allow to force
- *     some registers before (gcc refuses a %-register at the last position).
- *
- * Also, i386 supports the old_select syscall if newselect is not available
- */
-#define __ARCH_WANT_SYS_OLD_SELECT
-
-#define my_syscall0(num)                                                      \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num asm("eax") = (num);                                \
-									      \
-	asm volatile (                                                        \
-		"int $0x80\n"                                                 \
-		: "=a" (_ret)                                                 \
-		: "0"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall1(num, arg1)                                                \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num asm("eax") = (num);                                \
-	register long _arg1 asm("ebx") = (long)(arg1);                        \
-									      \
-	asm volatile (                                                        \
-		"int $0x80\n"                                                 \
-		: "=a" (_ret)                                                 \
-		: "r"(_arg1),                                                 \
-		  "0"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall2(num, arg1, arg2)                                          \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num asm("eax") = (num);                                \
-	register long _arg1 asm("ebx") = (long)(arg1);                        \
-	register long _arg2 asm("ecx") = (long)(arg2);                        \
-									      \
-	asm volatile (                                                        \
-		"int $0x80\n"                                                 \
-		: "=a" (_ret)                                                 \
-		: "r"(_arg1), "r"(_arg2),                                     \
-		  "0"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall3(num, arg1, arg2, arg3)                                    \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num asm("eax") = (num);                                \
-	register long _arg1 asm("ebx") = (long)(arg1);                        \
-	register long _arg2 asm("ecx") = (long)(arg2);                        \
-	register long _arg3 asm("edx") = (long)(arg3);                        \
-									      \
-	asm volatile (                                                        \
-		"int $0x80\n"                                                 \
-		: "=a" (_ret)                                                 \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
-		  "0"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num asm("eax") = (num);                                \
-	register long _arg1 asm("ebx") = (long)(arg1);                        \
-	register long _arg2 asm("ecx") = (long)(arg2);                        \
-	register long _arg3 asm("edx") = (long)(arg3);                        \
-	register long _arg4 asm("esi") = (long)(arg4);                        \
-									      \
-	asm volatile (                                                        \
-		"int $0x80\n"                                                 \
-		: "=a" (_ret)                                                 \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
-		  "0"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
-({                                                                            \
-	long _ret;                                                            \
-	register long _num asm("eax") = (num);                                \
-	register long _arg1 asm("ebx") = (long)(arg1);                        \
-	register long _arg2 asm("ecx") = (long)(arg2);                        \
-	register long _arg3 asm("edx") = (long)(arg3);                        \
-	register long _arg4 asm("esi") = (long)(arg4);                        \
-	register long _arg5 asm("edi") = (long)(arg5);                        \
-									      \
-	asm volatile (                                                        \
-		"int $0x80\n"                                                 \
-		: "=a" (_ret)                                                 \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
-		  "0"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_ret;                                                                 \
-})
-
-/* startup code */
-/*
- * i386 System V ABI mandates:
- * 1) last pushed argument must be 16-byte aligned.
- * 2) The deepest stack frame should be set to zero
- *
- */
-asm(".section .text\n"
-    ".global _start\n"
-    "_start:\n"
-    "pop %eax\n"                // argc   (first arg, %eax)
-    "mov %esp, %ebx\n"          // argv[] (second arg, %ebx)
-    "lea 4(%ebx,%eax,4),%ecx\n" // then a NULL then envp (third arg, %ecx)
-    "xor %ebp, %ebp\n"          // zero the stack frame
-    "and $-16, %esp\n"          // x86 ABI : esp must be 16-byte aligned before
-    "sub $4, %esp\n"            // the call instruction (args are aligned)
-    "push %ecx\n"               // push all registers on the stack so that we
-    "push %ebx\n"               // support both regparm and plain stack modes
-    "push %eax\n"
-    "call main\n"               // main() returns the status code in %eax
-    "mov %eax, %ebx\n"          // retrieve exit code (32-bit int)
-    "movl $1, %eax\n"           // NR_exit == 1
-    "int $0x80\n"               // exit now
-    "hlt\n"                     // ensure it does not
-    "");
-
-/* fcntl / open */
-#define O_RDONLY            0
-#define O_WRONLY            1
-#define O_RDWR              2
-#define O_CREAT          0x40
-#define O_EXCL           0x80
-#define O_NOCTTY        0x100
-#define O_TRUNC         0x200
-#define O_APPEND        0x400
-#define O_NONBLOCK      0x800
-#define O_DIRECTORY   0x10000
-
-/* The struct returned by the stat() syscall, 32-bit only, the syscall returns
- * exactly 56 bytes (stops before the unused array).
- */
-struct sys_stat_struct {
-	unsigned long  st_dev;
-	unsigned long  st_ino;
-	unsigned short st_mode;
-	unsigned short st_nlink;
-	unsigned short st_uid;
-	unsigned short st_gid;
-
-	unsigned long  st_rdev;
-	unsigned long  st_size;
-	unsigned long  st_blksize;
-	unsigned long  st_blocks;
-
-	unsigned long  st_atime;
-	unsigned long  st_atime_nsec;
-	unsigned long  st_mtime;
-	unsigned long  st_mtime_nsec;
-
-	unsigned long  st_ctime;
-	unsigned long  st_ctime_nsec;
-	unsigned long  __unused[2];
-};
-
-#elif defined(__ARM_EABI__)
-/* Syscalls for ARM in ARM or Thumb modes :
- *   - registers are 32-bit
- *   - stack is 8-byte aligned
- *     ( http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.faqs/ka4127.html)
- *   - syscall number is passed in r7
- *   - arguments are in r0, r1, r2, r3, r4, r5
- *   - the system call is performed by calling svc #0
- *   - syscall return comes in r0.
- *   - only lr is clobbered.
- *   - the arguments are cast to long and assigned into the target registers
- *     which are then simply passed as registers to the asm code, so that we
- *     don't have to experience issues with register constraints.
- *   - the syscall number is always specified last in order to allow to force
- *     some registers before (gcc refuses a %-register at the last position).
- *
- * Also, ARM supports the old_select syscall if newselect is not available
- */
-#define __ARCH_WANT_SYS_OLD_SELECT
-
-#define my_syscall0(num)                                                      \
-({                                                                            \
-	register long _num asm("r7") = (num);                                 \
-	register long _arg1 asm("r0");                                        \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_num)                                                   \
-		: "memory", "cc", "lr"                                        \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall1(num, arg1)                                                \
-({                                                                            \
-	register long _num asm("r7") = (num);                                 \
-	register long _arg1 asm("r0") = (long)(arg1);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_arg1),                                                 \
-		  "r"(_num)                                                   \
-		: "memory", "cc", "lr"                                        \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall2(num, arg1, arg2)                                          \
-({                                                                            \
-	register long _num asm("r7") = (num);                                 \
-	register long _arg1 asm("r0") = (long)(arg1);                         \
-	register long _arg2 asm("r1") = (long)(arg2);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_arg1), "r"(_arg2),                                     \
-		  "r"(_num)                                                   \
-		: "memory", "cc", "lr"                                        \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall3(num, arg1, arg2, arg3)                                    \
-({                                                                            \
-	register long _num asm("r7") = (num);                                 \
-	register long _arg1 asm("r0") = (long)(arg1);                         \
-	register long _arg2 asm("r1") = (long)(arg2);                         \
-	register long _arg3 asm("r2") = (long)(arg3);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
-		  "r"(_num)                                                   \
-		: "memory", "cc", "lr"                                        \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
-({                                                                            \
-	register long _num asm("r7") = (num);                                 \
-	register long _arg1 asm("r0") = (long)(arg1);                         \
-	register long _arg2 asm("r1") = (long)(arg2);                         \
-	register long _arg3 asm("r2") = (long)(arg3);                         \
-	register long _arg4 asm("r3") = (long)(arg4);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
-		  "r"(_num)                                                   \
-		: "memory", "cc", "lr"                                        \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
-({                                                                            \
-	register long _num asm("r7") = (num);                                 \
-	register long _arg1 asm("r0") = (long)(arg1);                         \
-	register long _arg2 asm("r1") = (long)(arg2);                         \
-	register long _arg3 asm("r2") = (long)(arg3);                         \
-	register long _arg4 asm("r3") = (long)(arg4);                         \
-	register long _arg5 asm("r4") = (long)(arg5);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r" (_arg1)                                                \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
-		  "r"(_num)                                                   \
-		: "memory", "cc", "lr"                                        \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-/* startup code */
-asm(".section .text\n"
-    ".global _start\n"
-    "_start:\n"
-#if defined(__THUMBEB__) || defined(__THUMBEL__)
-    /* We enter here in 32-bit mode but if some previous functions were in
-     * 16-bit mode, the assembler cannot know, so we need to tell it we're in
-     * 32-bit now, then switch to 16-bit (is there a better way to do it than
-     * adding 1 by hand ?) and tell the asm we're now in 16-bit mode so that
-     * it generates correct instructions. Note that we do not support thumb1.
-     */
-    ".code 32\n"
-    "add     r0, pc, #1\n"
-    "bx      r0\n"
-    ".code 16\n"
-#endif
-    "pop {%r0}\n"                 // argc was in the stack
-    "mov %r1, %sp\n"              // argv = sp
-    "add %r2, %r1, %r0, lsl #2\n" // envp = argv + 4*argc ...
-    "add %r2, %r2, $4\n"          //        ... + 4
-    "and %r3, %r1, $-8\n"         // AAPCS : sp must be 8-byte aligned in the
-    "mov %sp, %r3\n"              //         callee, an bl doesn't push (lr=pc)
-    "bl main\n"                   // main() returns the status code, we'll exit with it.
-    "movs r7, $1\n"               // NR_exit == 1
-    "svc $0x00\n"
-    "");
-
-/* fcntl / open */
-#define O_RDONLY            0
-#define O_WRONLY            1
-#define O_RDWR              2
-#define O_CREAT          0x40
-#define O_EXCL           0x80
-#define O_NOCTTY        0x100
-#define O_TRUNC         0x200
-#define O_APPEND        0x400
-#define O_NONBLOCK      0x800
-#define O_DIRECTORY    0x4000
-
-/* The struct returned by the stat() syscall, 32-bit only, the syscall returns
- * exactly 56 bytes (stops before the unused array). In big endian, the format
- * differs as devices are returned as short only.
- */
-struct sys_stat_struct {
-#if defined(__ARMEB__)
-	unsigned short st_dev;
-	unsigned short __pad1;
-#else
-	unsigned long  st_dev;
-#endif
-	unsigned long  st_ino;
-	unsigned short st_mode;
-	unsigned short st_nlink;
-	unsigned short st_uid;
-	unsigned short st_gid;
-#if defined(__ARMEB__)
-	unsigned short st_rdev;
-	unsigned short __pad2;
-#else
-	unsigned long  st_rdev;
-#endif
-	unsigned long  st_size;
-	unsigned long  st_blksize;
-	unsigned long  st_blocks;
-	unsigned long  st_atime;
-	unsigned long  st_atime_nsec;
-	unsigned long  st_mtime;
-	unsigned long  st_mtime_nsec;
-	unsigned long  st_ctime;
-	unsigned long  st_ctime_nsec;
-	unsigned long  __unused[2];
-};
-
-#elif defined(__aarch64__)
-/* Syscalls for AARCH64 :
- *   - registers are 64-bit
- *   - stack is 16-byte aligned
- *   - syscall number is passed in x8
- *   - arguments are in x0, x1, x2, x3, x4, x5
- *   - the system call is performed by calling svc 0
- *   - syscall return comes in x0.
- *   - the arguments are cast to long and assigned into the target registers
- *     which are then simply passed as registers to the asm code, so that we
- *     don't have to experience issues with register constraints.
- *
- * On aarch64, select() is not implemented so we have to use pselect6().
- */
-#define __ARCH_WANT_SYS_PSELECT6
-
-#define my_syscall0(num)                                                      \
-({                                                                            \
-	register long _num  asm("x8") = (num);                                \
-	register long _arg1 asm("x0");                                        \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall1(num, arg1)                                                \
-({                                                                            \
-	register long _num  asm("x8") = (num);                                \
-	register long _arg1 asm("x0") = (long)(arg1);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_arg1),                                                 \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall2(num, arg1, arg2)                                          \
-({                                                                            \
-	register long _num  asm("x8") = (num);                                \
-	register long _arg1 asm("x0") = (long)(arg1);                         \
-	register long _arg2 asm("x1") = (long)(arg2);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_arg1), "r"(_arg2),                                     \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall3(num, arg1, arg2, arg3)                                    \
-({                                                                            \
-	register long _num  asm("x8") = (num);                                \
-	register long _arg1 asm("x0") = (long)(arg1);                         \
-	register long _arg2 asm("x1") = (long)(arg2);                         \
-	register long _arg3 asm("x2") = (long)(arg3);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3),                         \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
-({                                                                            \
-	register long _num  asm("x8") = (num);                                \
-	register long _arg1 asm("x0") = (long)(arg1);                         \
-	register long _arg2 asm("x1") = (long)(arg2);                         \
-	register long _arg3 asm("x2") = (long)(arg3);                         \
-	register long _arg4 asm("x3") = (long)(arg4);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r"(_arg1)                                                 \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4),             \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
-({                                                                            \
-	register long _num  asm("x8") = (num);                                \
-	register long _arg1 asm("x0") = (long)(arg1);                         \
-	register long _arg2 asm("x1") = (long)(arg2);                         \
-	register long _arg3 asm("x2") = (long)(arg3);                         \
-	register long _arg4 asm("x3") = (long)(arg4);                         \
-	register long _arg5 asm("x4") = (long)(arg5);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r" (_arg1)                                                \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall6(num, arg1, arg2, arg3, arg4, arg5, arg6)                  \
-({                                                                            \
-	register long _num  asm("x8") = (num);                                \
-	register long _arg1 asm("x0") = (long)(arg1);                         \
-	register long _arg2 asm("x1") = (long)(arg2);                         \
-	register long _arg3 asm("x2") = (long)(arg3);                         \
-	register long _arg4 asm("x3") = (long)(arg4);                         \
-	register long _arg5 asm("x4") = (long)(arg5);                         \
-	register long _arg6 asm("x5") = (long)(arg6);                         \
-									      \
-	asm volatile (                                                        \
-		"svc #0\n"                                                    \
-		: "=r" (_arg1)                                                \
-		: "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), \
-		  "r"(_arg6), "r"(_num)                                       \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-/* startup code */
-asm(".section .text\n"
-    ".global _start\n"
-    "_start:\n"
-    "ldr x0, [sp]\n"              // argc (x0) was in the stack
-    "add x1, sp, 8\n"             // argv (x1) = sp
-    "lsl x2, x0, 3\n"             // envp (x2) = 8*argc ...
-    "add x2, x2, 8\n"             //           + 8 (skip null)
-    "add x2, x2, x1\n"            //           + argv
-    "and sp, x1, -16\n"           // sp must be 16-byte aligned in the callee
-    "bl main\n"                   // main() returns the status code, we'll exit with it.
-    "mov x8, 93\n"                // NR_exit == 93
-    "svc #0\n"
-    "");
-
-/* fcntl / open */
-#define O_RDONLY            0
-#define O_WRONLY            1
-#define O_RDWR              2
-#define O_CREAT          0x40
-#define O_EXCL           0x80
-#define O_NOCTTY        0x100
-#define O_TRUNC         0x200
-#define O_APPEND        0x400
-#define O_NONBLOCK      0x800
-#define O_DIRECTORY    0x4000
-
-/* The struct returned by the newfstatat() syscall. Differs slightly from the
- * x86_64's stat one by field ordering, so be careful.
- */
-struct sys_stat_struct {
-	unsigned long   st_dev;
-	unsigned long   st_ino;
-	unsigned int    st_mode;
-	unsigned int    st_nlink;
-	unsigned int    st_uid;
-	unsigned int    st_gid;
-
-	unsigned long   st_rdev;
-	unsigned long   __pad1;
-	long            st_size;
-	int             st_blksize;
-	int             __pad2;
-
-	long            st_blocks;
-	long            st_atime;
-	unsigned long   st_atime_nsec;
-	long            st_mtime;
-
-	unsigned long   st_mtime_nsec;
-	long            st_ctime;
-	unsigned long   st_ctime_nsec;
-	unsigned int    __unused[2];
-};
-
-#elif defined(__mips__) && defined(_ABIO32)
-/* Syscalls for MIPS ABI O32 :
- *   - WARNING! there's always a delayed slot!
- *   - WARNING again, the syntax is different, registers take a '$' and numbers
- *     do not.
- *   - registers are 32-bit
- *   - stack is 8-byte aligned
- *   - syscall number is passed in v0 (starts at 0xfa0).
- *   - arguments are in a0, a1, a2, a3, then the stack. The caller needs to
- *     leave some room in the stack for the callee to save a0..a3 if needed.
- *   - Many registers are clobbered, in fact only a0..a2 and s0..s8 are
- *     preserved. See: https://www.linux-mips.org/wiki/Syscall as well as
- *     scall32-o32.S in the kernel sources.
- *   - the system call is performed by calling "syscall"
- *   - syscall return comes in v0, and register a3 needs to be checked to know
- *     if an error occurred, in which case errno is in v0.
- *   - the arguments are cast to long and assigned into the target registers
- *     which are then simply passed as registers to the asm code, so that we
- *     don't have to experience issues with register constraints.
- */
-
-#define my_syscall0(num)                                                      \
-({                                                                            \
-	register long _num asm("v0") = (num);                                 \
-	register long _arg4 asm("a3");                                        \
-									      \
-	asm volatile (                                                        \
-		"addiu $sp, $sp, -32\n"                                       \
-		"syscall\n"                                                   \
-		"addiu $sp, $sp, 32\n"                                        \
-		: "=r"(_num), "=r"(_arg4)                                     \
-		: "r"(_num)                                                   \
-		: "memory", "cc", "at", "v1", "hi", "lo",                     \
-		  "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
-	);                                                                    \
-	_arg4 ? -_num : _num;                                                 \
-})
-
-#define my_syscall1(num, arg1)                                                \
-({                                                                            \
-	register long _num asm("v0") = (num);                                 \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg4 asm("a3");                                        \
-									      \
-	asm volatile (                                                        \
-		"addiu $sp, $sp, -32\n"                                       \
-		"syscall\n"                                                   \
-		"addiu $sp, $sp, 32\n"                                        \
-		: "=r"(_num), "=r"(_arg4)                                     \
-		: "0"(_num),                                                  \
-		  "r"(_arg1)                                                  \
-		: "memory", "cc", "at", "v1", "hi", "lo",                     \
-		  "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
-	);                                                                    \
-	_arg4 ? -_num : _num;                                                 \
-})
-
-#define my_syscall2(num, arg1, arg2)                                          \
-({                                                                            \
-	register long _num asm("v0") = (num);                                 \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-	register long _arg4 asm("a3");                                        \
-									      \
-	asm volatile (                                                        \
-		"addiu $sp, $sp, -32\n"                                       \
-		"syscall\n"                                                   \
-		"addiu $sp, $sp, 32\n"                                        \
-		: "=r"(_num), "=r"(_arg4)                                     \
-		: "0"(_num),                                                  \
-		  "r"(_arg1), "r"(_arg2)                                      \
-		: "memory", "cc", "at", "v1", "hi", "lo",                     \
-		  "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
-	);                                                                    \
-	_arg4 ? -_num : _num;                                                 \
-})
-
-#define my_syscall3(num, arg1, arg2, arg3)                                    \
-({                                                                            \
-	register long _num asm("v0")  = (num);                                \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-	register long _arg3 asm("a2") = (long)(arg3);                         \
-	register long _arg4 asm("a3");                                        \
-									      \
-	asm volatile (                                                        \
-		"addiu $sp, $sp, -32\n"                                       \
-		"syscall\n"                                                   \
-		"addiu $sp, $sp, 32\n"                                        \
-		: "=r"(_num), "=r"(_arg4)                                     \
-		: "0"(_num),                                                  \
-		  "r"(_arg1), "r"(_arg2), "r"(_arg3)                          \
-		: "memory", "cc", "at", "v1", "hi", "lo",                     \
-		  "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
-	);                                                                    \
-	_arg4 ? -_num : _num;                                                 \
-})
-
-#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
-({                                                                            \
-	register long _num asm("v0") = (num);                                 \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-	register long _arg3 asm("a2") = (long)(arg3);                         \
-	register long _arg4 asm("a3") = (long)(arg4);                         \
-									      \
-	asm volatile (                                                        \
-		"addiu $sp, $sp, -32\n"                                       \
-		"syscall\n"                                                   \
-		"addiu $sp, $sp, 32\n"                                        \
-		: "=r" (_num), "=r"(_arg4)                                    \
-		: "0"(_num),                                                  \
-		  "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4)              \
-		: "memory", "cc", "at", "v1", "hi", "lo",                     \
-		  "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
-	);                                                                    \
-	_arg4 ? -_num : _num;                                                 \
-})
-
-#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
-({                                                                            \
-	register long _num asm("v0") = (num);                                 \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-	register long _arg3 asm("a2") = (long)(arg3);                         \
-	register long _arg4 asm("a3") = (long)(arg4);                         \
-	register long _arg5 = (long)(arg5);				      \
-									      \
-	asm volatile (                                                        \
-		"addiu $sp, $sp, -32\n"                                       \
-		"sw %7, 16($sp)\n"                                            \
-		"syscall\n  "                                                 \
-		"addiu $sp, $sp, 32\n"                                        \
-		: "=r" (_num), "=r"(_arg4)                                    \
-		: "0"(_num),                                                  \
-		  "r"(_arg1), "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5)  \
-		: "memory", "cc", "at", "v1", "hi", "lo",                     \
-		  "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"  \
-	);                                                                    \
-	_arg4 ? -_num : _num;                                                 \
-})
-
-/* startup code, note that it's called __start on MIPS */
-asm(".section .text\n"
-    ".set nomips16\n"
-    ".global __start\n"
-    ".set    noreorder\n"
-    ".option pic0\n"
-    ".ent __start\n"
-    "__start:\n"
-    "lw $a0,($sp)\n"              // argc was in the stack
-    "addiu  $a1, $sp, 4\n"        // argv = sp + 4
-    "sll $a2, $a0, 2\n"           // a2 = argc * 4
-    "add   $a2, $a2, $a1\n"       // envp = argv + 4*argc ...
-    "addiu $a2, $a2, 4\n"         //        ... + 4
-    "li $t0, -8\n"
-    "and $sp, $sp, $t0\n"         // sp must be 8-byte aligned
-    "addiu $sp,$sp,-16\n"         // the callee expects to save a0..a3 there!
-    "jal main\n"                  // main() returns the status code, we'll exit with it.
-    "nop\n"                       // delayed slot
-    "move $a0, $v0\n"             // retrieve 32-bit exit code from v0
-    "li $v0, 4001\n"              // NR_exit == 4001
-    "syscall\n"
-    ".end __start\n"
-    "");
-
-/* fcntl / open */
-#define O_RDONLY            0
-#define O_WRONLY            1
-#define O_RDWR              2
-#define O_APPEND       0x0008
-#define O_NONBLOCK     0x0080
-#define O_CREAT        0x0100
-#define O_TRUNC        0x0200
-#define O_EXCL         0x0400
-#define O_NOCTTY       0x0800
-#define O_DIRECTORY   0x10000
-
-/* The struct returned by the stat() syscall. 88 bytes are returned by the
- * syscall.
- */
-struct sys_stat_struct {
-	unsigned int  st_dev;
-	long          st_pad1[3];
-	unsigned long st_ino;
-	unsigned int  st_mode;
-	unsigned int  st_nlink;
-	unsigned int  st_uid;
-	unsigned int  st_gid;
-	unsigned int  st_rdev;
-	long          st_pad2[2];
-	long          st_size;
-	long          st_pad3;
-	long          st_atime;
-	long          st_atime_nsec;
-	long          st_mtime;
-	long          st_mtime_nsec;
-	long          st_ctime;
-	long          st_ctime_nsec;
-	long          st_blksize;
-	long          st_blocks;
-	long          st_pad4[14];
-};
-
-#elif defined(__riscv)
-
-#if   __riscv_xlen == 64
-#define PTRLOG "3"
-#define SZREG  "8"
-#elif __riscv_xlen == 32
-#define PTRLOG "2"
-#define SZREG  "4"
-#endif
-
-/* Syscalls for RISCV :
- *   - stack is 16-byte aligned
- *   - syscall number is passed in a7
- *   - arguments are in a0, a1, a2, a3, a4, a5
- *   - the system call is performed by calling ecall
- *   - syscall return comes in a0
- *   - the arguments are cast to long and assigned into the target
- *     registers which are then simply passed as registers to the asm code,
- *     so that we don't have to experience issues with register constraints.
- */
-
-#define my_syscall0(num)                                                      \
-({                                                                            \
-	register long _num  asm("a7") = (num);                                \
-	register long _arg1 asm("a0");                                        \
-									      \
-	asm volatile (                                                        \
-		"ecall\n\t"                                                   \
-		: "=r"(_arg1)                                                 \
-		: "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall1(num, arg1)                                                \
-({                                                                            \
-	register long _num  asm("a7") = (num);                                \
-	register long _arg1 asm("a0") = (long)(arg1);		              \
-									      \
-	asm volatile (                                                        \
-		"ecall\n"                                                     \
-		: "+r"(_arg1)                                                 \
-		: "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall2(num, arg1, arg2)                                          \
-({                                                                            \
-	register long _num  asm("a7") = (num);                                \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-									      \
-	asm volatile (                                                        \
-		"ecall\n"                                                     \
-		: "+r"(_arg1)                                                 \
-		: "r"(_arg2),                                                 \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall3(num, arg1, arg2, arg3)                                    \
-({                                                                            \
-	register long _num  asm("a7") = (num);                                \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-	register long _arg3 asm("a2") = (long)(arg3);                         \
-									      \
-	asm volatile (                                                        \
-		"ecall\n\t"                                                   \
-		: "+r"(_arg1)                                                 \
-		: "r"(_arg2), "r"(_arg3),                                     \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall4(num, arg1, arg2, arg3, arg4)                              \
-({                                                                            \
-	register long _num  asm("a7") = (num);                                \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-	register long _arg3 asm("a2") = (long)(arg3);                         \
-	register long _arg4 asm("a3") = (long)(arg4);                         \
-									      \
-	asm volatile (                                                        \
-		"ecall\n"                                                     \
-		: "+r"(_arg1)                                                 \
-		: "r"(_arg2), "r"(_arg3), "r"(_arg4),                         \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)                        \
-({                                                                            \
-	register long _num  asm("a7") = (num);                                \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-	register long _arg3 asm("a2") = (long)(arg3);                         \
-	register long _arg4 asm("a3") = (long)(arg4);                         \
-	register long _arg5 asm("a4") = (long)(arg5);                         \
-									      \
-	asm volatile (                                                        \
-		"ecall\n"                                                     \
-		: "+r"(_arg1)                                                 \
-		: "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5),             \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-#define my_syscall6(num, arg1, arg2, arg3, arg4, arg5, arg6)                  \
-({                                                                            \
-	register long _num  asm("a7") = (num);                                \
-	register long _arg1 asm("a0") = (long)(arg1);                         \
-	register long _arg2 asm("a1") = (long)(arg2);                         \
-	register long _arg3 asm("a2") = (long)(arg3);                         \
-	register long _arg4 asm("a3") = (long)(arg4);                         \
-	register long _arg5 asm("a4") = (long)(arg5);                         \
-	register long _arg6 asm("a5") = (long)(arg6);                         \
-									      \
-	asm volatile (                                                        \
-		"ecall\n"                                                     \
-		: "+r"(_arg1)                                                 \
-		: "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5), "r"(_arg6), \
-		  "r"(_num)                                                   \
-		: "memory", "cc"                                              \
-	);                                                                    \
-	_arg1;                                                                \
-})
-
-/* startup code */
-asm(".section .text\n"
-    ".global _start\n"
-    "_start:\n"
-    ".option push\n"
-    ".option norelax\n"
-    "lla   gp, __global_pointer$\n"
-    ".option pop\n"
-    "ld    a0, 0(sp)\n"          // argc (a0) was in the stack
-    "add   a1, sp, "SZREG"\n"    // argv (a1) = sp
-    "slli  a2, a0, "PTRLOG"\n"   // envp (a2) = SZREG*argc ...
-    "add   a2, a2, "SZREG"\n"    //             + SZREG (skip null)
-    "add   a2,a2,a1\n"           //             + argv
-    "andi  sp,a1,-16\n"          // sp must be 16-byte aligned
-    "call  main\n"               // main() returns the status code, we'll exit with it.
-    "li a7, 93\n"                // NR_exit == 93
-    "ecall\n"
-    "");
-
-/* fcntl / open */
-#define O_RDONLY            0
-#define O_WRONLY            1
-#define O_RDWR              2
-#define O_CREAT         0x100
-#define O_EXCL          0x200
-#define O_NOCTTY        0x400
-#define O_TRUNC        0x1000
-#define O_APPEND       0x2000
-#define O_NONBLOCK     0x4000
-#define O_DIRECTORY  0x200000
-
-struct sys_stat_struct {
-	unsigned long	st_dev;		/* Device.  */
-	unsigned long	st_ino;		/* File serial number.  */
-	unsigned int	st_mode;	/* File mode.  */
-	unsigned int	st_nlink;	/* Link count.  */
-	unsigned int	st_uid;		/* User ID of the file's owner.  */
-	unsigned int	st_gid;		/* Group ID of the file's group. */
-	unsigned long	st_rdev;	/* Device number, if device.  */
-	unsigned long	__pad1;
-	long		st_size;	/* Size of file, in bytes.  */
-	int		st_blksize;	/* Optimal block size for I/O.  */
-	int		__pad2;
-	long		st_blocks;	/* Number 512-byte blocks allocated. */
-	long		st_atime;	/* Time of last access.  */
-	unsigned long	st_atime_nsec;
-	long		st_mtime;	/* Time of last modification.  */
-	unsigned long	st_mtime_nsec;
-	long		st_ctime;	/* Time of last status change.  */
-	unsigned long	st_ctime_nsec;
-	unsigned int	__unused4;
-	unsigned int	__unused5;
-};
-
-#endif
-
 
 /* Below are the C functions used to declare the raw syscalls. They try to be
  * architecture-agnostic, and return either a success or -errno. Declaring them
diff --git a/tools/include/nolibc/std.h b/tools/include/nolibc/std.h
new file mode 100644
index 000000000000..1747ae125392
--- /dev/null
+++ b/tools/include/nolibc/std.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * Standard definitions and types for NOLIBC
+ * Copyright (C) 2017-2021 Willy Tarreau <w@1wt.eu>
+ */
+
+#ifndef _NOLIBC_STD_H
+#define _NOLIBC_STD_H
+
+/* Declare a few quite common macros and types that usually are in stdlib.h,
+ * stdint.h, ctype.h, unistd.h and a few other common locations. Please place
+ * integer type definitions and generic macros here, but avoid OS-specific and
+ * syscall-specific stuff, as this file is expected to be included very early.
+ */
+
+/* note: may already be defined */
+#ifndef NULL
+#define NULL ((void *)0)
+#endif
+
+/* stdint types */
+typedef unsigned char       uint8_t;
+typedef   signed char        int8_t;
+typedef unsigned short     uint16_t;
+typedef   signed short      int16_t;
+typedef unsigned int       uint32_t;
+typedef   signed int        int32_t;
+typedef unsigned long long uint64_t;
+typedef   signed long long  int64_t;
+typedef unsigned long        size_t;
+typedef   signed long       ssize_t;
+typedef unsigned long     uintptr_t;
+typedef   signed long      intptr_t;
+typedef   signed long     ptrdiff_t;
+
+/* those are commonly provided by sys/types.h */
+typedef unsigned int          dev_t;
+typedef unsigned long         ino_t;
+typedef unsigned int         mode_t;
+typedef   signed int          pid_t;
+typedef unsigned int          uid_t;
+typedef unsigned int          gid_t;
+typedef unsigned long       nlink_t;
+typedef   signed long         off_t;
+typedef   signed long     blksize_t;
+typedef   signed long      blkcnt_t;
+typedef   signed long        time_t;
+
+#endif /* _NOLIBC_STD_H */
diff --git a/tools/include/nolibc/types.h b/tools/include/nolibc/types.h
new file mode 100644
index 000000000000..2f09abaf95f1
--- /dev/null
+++ b/tools/include/nolibc/types.h
@@ -0,0 +1,133 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * Special types used by various syscalls for NOLIBC
+ * Copyright (C) 2017-2021 Willy Tarreau <w@1wt.eu>
+ */
+
+#ifndef _NOLIBC_TYPES_H
+#define _NOLIBC_TYPES_H
+
+#include "std.h"
+#include <linux/time.h>
+
+
+/* Only the generic macros and types may be defined here. The arch-specific
+ * ones such as the O_RDONLY and related macros used by fcntl() and open(), or
+ * the layout of sys_stat_struct must not be defined here.
+ */
+
+/* stat flags (WARNING, octal here) */
+#define S_IFDIR        0040000
+#define S_IFCHR        0020000
+#define S_IFBLK        0060000
+#define S_IFREG        0100000
+#define S_IFIFO        0010000
+#define S_IFLNK        0120000
+#define S_IFSOCK       0140000
+#define S_IFMT         0170000
+
+#define S_ISDIR(mode)  (((mode) & S_IFDIR)  == S_IFDIR)
+#define S_ISCHR(mode)  (((mode) & S_IFCHR)  == S_IFCHR)
+#define S_ISBLK(mode)  (((mode) & S_IFBLK)  == S_IFBLK)
+#define S_ISREG(mode)  (((mode) & S_IFREG)  == S_IFREG)
+#define S_ISFIFO(mode) (((mode) & S_IFIFO)  == S_IFIFO)
+#define S_ISLNK(mode)  (((mode) & S_IFLNK)  == S_IFLNK)
+#define S_ISSOCK(mode) (((mode) & S_IFSOCK) == S_IFSOCK)
+
+/* dirent types */
+#define DT_UNKNOWN     0x0
+#define DT_FIFO        0x1
+#define DT_CHR         0x2
+#define DT_DIR         0x4
+#define DT_BLK         0x6
+#define DT_REG         0x8
+#define DT_LNK         0xa
+#define DT_SOCK        0xc
+
+/* commonly an fd_set represents 256 FDs */
+#define FD_SETSIZE     256
+
+/* Special FD used by all the *at functions */
+#ifndef AT_FDCWD
+#define AT_FDCWD       (-100)
+#endif
+
+/* whence values for lseek() */
+#define SEEK_SET       0
+#define SEEK_CUR       1
+#define SEEK_END       2
+
+/* cmd for reboot() */
+#define LINUX_REBOOT_MAGIC1         0xfee1dead
+#define LINUX_REBOOT_MAGIC2         0x28121969
+#define LINUX_REBOOT_CMD_HALT       0xcdef0123
+#define LINUX_REBOOT_CMD_POWER_OFF  0x4321fedc
+#define LINUX_REBOOT_CMD_RESTART    0x01234567
+#define LINUX_REBOOT_CMD_SW_SUSPEND 0xd000fce2
+
+/* Macros used on waitpid()'s return status */
+#define WEXITSTATUS(status) (((status) & 0xff00) >> 8)
+#define WIFEXITED(status)   (((status) & 0x7f) == 0)
+
+
+/* for select() */
+typedef struct {
+	uint32_t fd32[FD_SETSIZE / 32];
+} fd_set;
+
+/* for poll() */
+struct pollfd {
+	int fd;
+	short int events;
+	short int revents;
+};
+
+/* for getdents64() */
+struct linux_dirent64 {
+	uint64_t       d_ino;
+	int64_t        d_off;
+	unsigned short d_reclen;
+	unsigned char  d_type;
+	char           d_name[];
+};
+
+/* needed by wait4() */
+struct rusage {
+	struct timeval ru_utime;
+	struct timeval ru_stime;
+	long   ru_maxrss;
+	long   ru_ixrss;
+	long   ru_idrss;
+	long   ru_isrss;
+	long   ru_minflt;
+	long   ru_majflt;
+	long   ru_nswap;
+	long   ru_inblock;
+	long   ru_oublock;
+	long   ru_msgsnd;
+	long   ru_msgrcv;
+	long   ru_nsignals;
+	long   ru_nvcsw;
+	long   ru_nivcsw;
+};
+
+/* The format of the struct as returned by the libc to the application, which
+ * significantly differs from the format returned by the stat() syscall flavours.
+ */
+struct stat {
+	dev_t     st_dev;     /* ID of device containing file */
+	ino_t     st_ino;     /* inode number */
+	mode_t    st_mode;    /* protection */
+	nlink_t   st_nlink;   /* number of hard links */
+	uid_t     st_uid;     /* user ID of owner */
+	gid_t     st_gid;     /* group ID of owner */
+	dev_t     st_rdev;    /* device ID (if special file) */
+	off_t     st_size;    /* total size, in bytes */
+	blksize_t st_blksize; /* blocksize for file system I/O */
+	blkcnt_t  st_blocks;  /* number of 512B blocks allocated */
+	time_t    st_atime;   /* time of last access */
+	time_t    st_mtime;   /* time of last modification */
+	time_t    st_ctime;   /* time of last status change */
+};
+
+#endif /* _NOLIBC_TYPES_H */
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2fea9952818f..d9ea546850cd 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -17,7 +17,9 @@
 #include "util/record.h"
 #include <traceevent/event-parse.h>
 #include <api/fs/tracing_path.h>
+#ifdef HAVE_LIBBPF_SUPPORT
 #include <bpf/bpf.h>
+#endif
 #include "util/bpf_map.h"
 #include "util/rlimit.h"
 #include "builtin.h"
diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index c7f78d589e1c..0ef4cbf21e62 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -2545,7 +2545,7 @@ static int find_dso_sym(struct dso *dso, const char *sym_name, u64 *start,
 				*size = sym->start - *start;
 			if (idx > 0) {
 				if (*size)
-					return 1;
+					return 0;
 			} else if (dso_sym_match(sym, sym_name, &cnt, idx)) {
 				print_duplicate_syms(dso, sym_name);
 				return -EINVAL;
diff --git a/tools/perf/util/bpf_counter.h b/tools/perf/util/bpf_counter.h
index 65ebaa6694fb..4b5dda7530c4 100644
--- a/tools/perf/util/bpf_counter.h
+++ b/tools/perf/util/bpf_counter.h
@@ -4,9 +4,12 @@
 
 #include <linux/list.h>
 #include <sys/resource.h>
+
+#ifdef HAVE_LIBBPF_SUPPORT
 #include <bpf/bpf.h>
 #include <bpf/btf.h>
 #include <bpf/libbpf.h>
+#endif
 
 struct evsel;
 struct target;
@@ -87,6 +90,8 @@ static inline void set_max_rlimit(void)
 	setrlimit(RLIMIT_MEMLOCK, &rinf);
 }
 
+#ifdef HAVE_BPF_SKEL
+
 static inline __u32 bpf_link_get_id(int fd)
 {
 	struct bpf_link_info link_info = { .id = 0, };
@@ -127,5 +132,6 @@ static inline int bperf_trigger_reading(int prog_fd, int cpu)
 
 	return bpf_prog_test_run_opts(prog_fd, &opts);
 }
+#endif /* HAVE_BPF_SKEL */
 
 #endif /* __PERF_BPF_COUNTER_H */
diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 2237d1aac801..d7a7e760adc8 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -233,7 +233,7 @@ int main(int argc, char *argv[])
 	ucall_init(vm, NULL);
 
 	pthread_create(&migration_thread, NULL, migration_worker,
-		       (void *)(unsigned long)gettid());
+		       (void *)(unsigned long)syscall(SYS_gettid));
 
 	for (i = 0; !done; i++) {
 		vcpu_run(vm, VCPU_ID);
diff --git a/tools/testing/selftests/net/af_unix/test_unix_oob.c b/tools/testing/selftests/net/af_unix/test_unix_oob.c
index b57e91e1c3f2..532459a15067 100644
--- a/tools/testing/selftests/net/af_unix/test_unix_oob.c
+++ b/tools/testing/selftests/net/af_unix/test_unix_oob.c
@@ -124,7 +124,7 @@ void producer(struct sockaddr_un *consumer_addr)
 
 	wait_for_signal(pipefd[0]);
 	if (connect(cfd, (struct sockaddr *)consumer_addr,
-		     sizeof(struct sockaddr)) != 0) {
+		     sizeof(*consumer_addr)) != 0) {
 		perror("Connect failed");
 		kill(0, SIGTERM);
 		exit(1);

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180E65375AD
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 09:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiE3HnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 03:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbiE3HnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 03:43:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14E971D8B;
        Mon, 30 May 2022 00:42:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32846B80C0A;
        Mon, 30 May 2022 07:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C2DC341C7;
        Mon, 30 May 2022 07:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653896551;
        bh=lROwFe/pZiCqi9uRAxA3AFT4iEVdASLH5le0pU+0lnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MRNPcJYm5Xng93MHe0F2lHXbFd2Og3O3Lv/Nmnq+729Gsc/rKPzE+WyoES4Su6OaA
         3i56FHOMy78FowsgVV/R0sFh16tMeB7E/vNk4CfGb6WhLdxRjS7AZWMVyss2kWjfY5
         mMVFs/eZVAQrPNSwwB0d+LLSN/EZaOaW+DSYEVfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.17.12
Date:   Mon, 30 May 2022 09:42:19 +0200
Message-Id: <1653896539201127@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165389653923247@kroah.com>
References: <165389653923247@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 59f881f36779..ad67b848d04e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4355,6 +4355,12 @@
 			fully seed the kernel's CRNG. Default is controlled
 			by CONFIG_RANDOM_TRUST_CPU.
 
+	random.trust_bootloader={on,off}
+			[KNL] Enable or disable trusting the use of a
+			seed passed by the bootloader (if available) to
+			fully seed the kernel's CRNG. Default is controlled
+			by CONFIG_RANDOM_TRUST_BOOTLOADER.
+
 	randomize_kstack_offset=
 			[KNL] Enable or disable kernel stack offset
 			randomization, which provides roughly 5 bits of
diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index 0f86e9f93129..264735c5d0bd 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1025,28 +1025,22 @@ This is a directory, with the following entries:
 * ``boot_id``: a UUID generated the first time this is retrieved, and
   unvarying after that;
 
+* ``uuid``: a UUID generated every time this is retrieved (this can
+  thus be used to generate UUIDs at will);
+
 * ``entropy_avail``: the pool's entropy count, in bits;
 
 * ``poolsize``: the entropy pool size, in bits;
 
 * ``urandom_min_reseed_secs``: obsolete (used to determine the minimum
-  number of seconds between urandom pool reseeding).
-
-* ``uuid``: a UUID generated every time this is retrieved (this can
-  thus be used to generate UUIDs at will);
+  number of seconds between urandom pool reseeding). This file is
+  writable for compatibility purposes, but writing to it has no effect
+  on any RNG behavior;
 
 * ``write_wakeup_threshold``: when the entropy count drops below this
   (as a number of bits), processes waiting to write to ``/dev/random``
-  are woken up.
-
-If ``drivers/char/random.c`` is built with ``ADD_INTERRUPT_BENCH``
-defined, these additional entries are present:
-
-* ``add_interrupt_avg_cycles``: the average number of cycles between
-  interrupts used to feed the pool;
-
-* ``add_interrupt_avg_deviation``: the standard deviation seen on the
-  number of cycles between interrupts used to feed the pool.
+  are woken up. This file is writable for compatibility purposes, but
+  writing to it has no effect on any RNG behavior.
 
 
 randomize_va_space
diff --git a/Makefile b/Makefile
index b821f270a4ca..25c44dda0ef3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 17
-SUBLEVEL = 11
+SUBLEVEL = 12
 EXTRAVERSION =
 NAME = Superb Owl
 
diff --git a/arch/alpha/include/asm/timex.h b/arch/alpha/include/asm/timex.h
index b565cc6f408e..f89798da8a14 100644
--- a/arch/alpha/include/asm/timex.h
+++ b/arch/alpha/include/asm/timex.h
@@ -28,5 +28,6 @@ static inline cycles_t get_cycles (void)
 	__asm__ __volatile__ ("rpcc %0" : "=r"(ret));
 	return ret;
 }
+#define get_cycles get_cycles
 
 #endif
diff --git a/arch/arm/include/asm/timex.h b/arch/arm/include/asm/timex.h
index 7c3b3671d6c2..6d1337c169cd 100644
--- a/arch/arm/include/asm/timex.h
+++ b/arch/arm/include/asm/timex.h
@@ -11,5 +11,6 @@
 
 typedef unsigned long cycles_t;
 #define get_cycles()	({ cycles_t c; read_current_timer(&c) ? 0 : c; })
+#define random_get_entropy() (((unsigned long)get_cycles()) ?: random_get_entropy_fallback())
 
 #endif
diff --git a/arch/ia64/include/asm/timex.h b/arch/ia64/include/asm/timex.h
index 869a3ac6bf23..7ccc077a60be 100644
--- a/arch/ia64/include/asm/timex.h
+++ b/arch/ia64/include/asm/timex.h
@@ -39,6 +39,7 @@ get_cycles (void)
 	ret = ia64_getreg(_IA64_REG_AR_ITC);
 	return ret;
 }
+#define get_cycles get_cycles
 
 extern void ia64_cpu_local_tick (void);
 extern unsigned long long ia64_native_sched_clock (void);
diff --git a/arch/m68k/include/asm/timex.h b/arch/m68k/include/asm/timex.h
index 6a21d9358280..f4a7a340f4ca 100644
--- a/arch/m68k/include/asm/timex.h
+++ b/arch/m68k/include/asm/timex.h
@@ -35,7 +35,7 @@ static inline unsigned long random_get_entropy(void)
 {
 	if (mach_random_get_entropy)
 		return mach_random_get_entropy();
-	return 0;
+	return random_get_entropy_fallback();
 }
 #define random_get_entropy	random_get_entropy
 
diff --git a/arch/mips/include/asm/timex.h b/arch/mips/include/asm/timex.h
index 8026baf46e72..2e107886f97a 100644
--- a/arch/mips/include/asm/timex.h
+++ b/arch/mips/include/asm/timex.h
@@ -76,25 +76,24 @@ static inline cycles_t get_cycles(void)
 	else
 		return 0;	/* no usable counter */
 }
+#define get_cycles get_cycles
 
 /*
  * Like get_cycles - but where c0_count is not available we desperately
  * use c0_random in an attempt to get at least a little bit of entropy.
- *
- * R6000 and R6000A neither have a count register nor a random register.
- * That leaves no entropy source in the CPU itself.
  */
 static inline unsigned long random_get_entropy(void)
 {
-	unsigned int prid = read_c0_prid();
-	unsigned int imp = prid & PRID_IMP_MASK;
+	unsigned int c0_random;
 
-	if (can_use_mips_counter(prid))
+	if (can_use_mips_counter(read_c0_prid()))
 		return read_c0_count();
-	else if (likely(imp != PRID_IMP_R6000 && imp != PRID_IMP_R6000A))
-		return read_c0_random();
+
+	if (cpu_has_3kex)
+		c0_random = (read_c0_random() >> 8) & 0x3f;
 	else
-		return 0;	/* no usable register */
+		c0_random = read_c0_random() & 0x3f;
+	return (random_get_entropy_fallback() << 6) | (0x3f - c0_random);
 }
 #define random_get_entropy random_get_entropy
 
diff --git a/arch/nios2/include/asm/timex.h b/arch/nios2/include/asm/timex.h
index a769f871b28d..40a1adc9bd03 100644
--- a/arch/nios2/include/asm/timex.h
+++ b/arch/nios2/include/asm/timex.h
@@ -8,5 +8,8 @@
 typedef unsigned long cycles_t;
 
 extern cycles_t get_cycles(void);
+#define get_cycles get_cycles
+
+#define random_get_entropy() (((unsigned long)get_cycles()) ?: random_get_entropy_fallback())
 
 #endif
diff --git a/arch/parisc/include/asm/timex.h b/arch/parisc/include/asm/timex.h
index 06b510f8172e..b4622cb06a75 100644
--- a/arch/parisc/include/asm/timex.h
+++ b/arch/parisc/include/asm/timex.h
@@ -13,9 +13,10 @@
 
 typedef unsigned long cycles_t;
 
-static inline cycles_t get_cycles (void)
+static inline cycles_t get_cycles(void)
 {
 	return mfctl(16);
 }
+#define get_cycles get_cycles
 
 #endif
diff --git a/arch/powerpc/include/asm/timex.h b/arch/powerpc/include/asm/timex.h
index fa2e76e4093a..14b4489de52c 100644
--- a/arch/powerpc/include/asm/timex.h
+++ b/arch/powerpc/include/asm/timex.h
@@ -19,6 +19,7 @@ static inline cycles_t get_cycles(void)
 {
 	return mftb();
 }
+#define get_cycles get_cycles
 
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_TIMEX_H */
diff --git a/arch/riscv/include/asm/timex.h b/arch/riscv/include/asm/timex.h
index 507cae273bc6..d6a7428f6248 100644
--- a/arch/riscv/include/asm/timex.h
+++ b/arch/riscv/include/asm/timex.h
@@ -41,7 +41,7 @@ static inline u32 get_cycles_hi(void)
 static inline unsigned long random_get_entropy(void)
 {
 	if (unlikely(clint_time_val == NULL))
-		return 0;
+		return random_get_entropy_fallback();
 	return get_cycles();
 }
 #define random_get_entropy()	random_get_entropy()
diff --git a/arch/s390/include/asm/timex.h b/arch/s390/include/asm/timex.h
index 50d9b04ecbd1..bc50ee0e91ff 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -201,6 +201,7 @@ static inline cycles_t get_cycles(void)
 {
 	return (cycles_t) get_tod_clock() >> 2;
 }
+#define get_cycles get_cycles
 
 int get_phys_clock(unsigned long *clock);
 void init_cpu_timer(void);
diff --git a/arch/sparc/include/asm/timex_32.h b/arch/sparc/include/asm/timex_32.h
index 542915b46209..f86326a6f89e 100644
--- a/arch/sparc/include/asm/timex_32.h
+++ b/arch/sparc/include/asm/timex_32.h
@@ -9,8 +9,6 @@
 
 #define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
 
-/* XXX Maybe do something better at some point... -DaveM */
-typedef unsigned long cycles_t;
-#define get_cycles()	(0)
+#include <asm-generic/timex.h>
 
 #endif
diff --git a/arch/um/include/asm/timex.h b/arch/um/include/asm/timex.h
index e392a9a5bc9b..9f27176adb26 100644
--- a/arch/um/include/asm/timex.h
+++ b/arch/um/include/asm/timex.h
@@ -2,13 +2,8 @@
 #ifndef __UM_TIMEX_H
 #define __UM_TIMEX_H
 
-typedef unsigned long cycles_t;
-
-static inline cycles_t get_cycles (void)
-{
-	return 0;
-}
-
 #define CLOCK_TICK_RATE (HZ)
 
+#include <asm-generic/timex.h>
+
 #endif
diff --git a/arch/x86/include/asm/timex.h b/arch/x86/include/asm/timex.h
index a4a8b1b16c0c..956e4145311b 100644
--- a/arch/x86/include/asm/timex.h
+++ b/arch/x86/include/asm/timex.h
@@ -5,6 +5,15 @@
 #include <asm/processor.h>
 #include <asm/tsc.h>
 
+static inline unsigned long random_get_entropy(void)
+{
+	if (!IS_ENABLED(CONFIG_X86_TSC) &&
+	    !cpu_feature_enabled(X86_FEATURE_TSC))
+		return random_get_entropy_fallback();
+	return rdtsc();
+}
+#define random_get_entropy random_get_entropy
+
 /* Assume we use the PIT time source for the clock tick */
 #define CLOCK_TICK_RATE		PIT_TICK_RATE
 
diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 01a300a9700b..fbdc3d951494 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -20,13 +20,12 @@ extern void disable_TSC(void);
 
 static inline cycles_t get_cycles(void)
 {
-#ifndef CONFIG_X86_TSC
-	if (!boot_cpu_has(X86_FEATURE_TSC))
+	if (!IS_ENABLED(CONFIG_X86_TSC) &&
+	    !cpu_feature_enabled(X86_FEATURE_TSC))
 		return 0;
-#endif
-
 	return rdtsc();
 }
+#define get_cycles get_cycles
 
 extern struct system_counterval_t convert_art_to_tsc(u64 art);
 extern struct system_counterval_t convert_art_ns_to_tsc(u64 art_ns);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 32333dfc85b6..495329ae6b1b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5416,14 +5416,16 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 	uint i;
 
 	if (pcid == kvm_get_active_pcid(vcpu)) {
-		mmu->invlpg(vcpu, gva, mmu->root_hpa);
+		if (mmu->invlpg)
+			mmu->invlpg(vcpu, gva, mmu->root_hpa);
 		tlb_flush = true;
 	}
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		if (VALID_PAGE(mmu->prev_roots[i].hpa) &&
 		    pcid == kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd)) {
-			mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
+			if (mmu->invlpg)
+				mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
 			tlb_flush = true;
 		}
 	}
diff --git a/arch/xtensa/include/asm/timex.h b/arch/xtensa/include/asm/timex.h
index 233ec75e60c6..3f2462f2d027 100644
--- a/arch/xtensa/include/asm/timex.h
+++ b/arch/xtensa/include/asm/timex.h
@@ -29,10 +29,6 @@
 
 extern unsigned long ccount_freq;
 
-typedef unsigned long long cycles_t;
-
-#define get_cycles()	(0)
-
 void local_timer_setup(unsigned cpu);
 
 /*
@@ -59,4 +55,6 @@ static inline void set_linux_timer (unsigned long ccompare)
 	xtensa_set_sr(ccompare, SREG_CCOMPARE + LINUX_TIMER);
 }
 
+#include <asm-generic/timex.h>
+
 #endif	/* _XTENSA_TIMEX_H */
diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index a4b638bea6f1..cc2fe0618178 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -415,19 +415,30 @@ static ssize_t acpi_data_show(struct file *filp, struct kobject *kobj,
 			      loff_t offset, size_t count)
 {
 	struct acpi_data_attr *data_attr;
-	void *base;
-	ssize_t rc;
+	void __iomem *base;
+	ssize_t size;
 
 	data_attr = container_of(bin_attr, struct acpi_data_attr, attr);
+	size = data_attr->attr.size;
+
+	if (offset < 0)
+		return -EINVAL;
+
+	if (offset >= size)
+		return 0;
 
-	base = acpi_os_map_memory(data_attr->addr, data_attr->attr.size);
+	if (count > size - offset)
+		count = size - offset;
+
+	base = acpi_os_map_iomem(data_attr->addr, size);
 	if (!base)
 		return -ENOMEM;
-	rc = memory_read_from_buffer(buf, count, &offset, base,
-				     data_attr->attr.size);
-	acpi_os_unmap_memory(base, data_attr->attr.size);
 
-	return rc;
+	memcpy_fromio(buf, base + offset, count);
+
+	acpi_os_unmap_iomem(base, size);
+
+	return count;
 }
 
 static int acpi_bert_data_init(void *th, struct acpi_data_attr *data_attr)
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 740811893c57..55f48375e3fe 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -449,6 +449,7 @@ config RANDOM_TRUST_BOOTLOADER
 	device randomness. Say Y here to assume the entropy provided by the
 	booloader is trustworthy so it will be added to the kernel's entropy
 	pool. Otherwise, say N here so it will be regarded as device input that
-	only mixes the entropy pool.
+	only mixes the entropy pool. This can also be configured at boot with
+	"random.trust_bootloader=on/off".
 
 endmenu
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index a3db27916256..cfb085de876b 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/hw_random.h>
+#include <linux/random.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/sched/signal.h>
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 3404a91edf29..92428bfdc143 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1,320 +1,26 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 /*
- * random.c -- A strong random number generator
- *
  * Copyright (C) 2017-2022 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
- *
  * Copyright Matt Mackall <mpm@selenic.com>, 2003, 2004, 2005
- *
- * Copyright Theodore Ts'o, 1994, 1995, 1996, 1997, 1998, 1999.  All
- * rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, and the entire permission notice in its entirety,
- *    including the disclaimer of warranties.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- * 3. The name of the author may not be used to endorse or promote
- *    products derived from this software without specific prior
- *    written permission.
- *
- * ALTERNATIVELY, this product may be distributed under the terms of
- * the GNU General Public License, in which case the provisions of the GPL are
- * required INSTEAD OF the above restrictions.  (This clause is
- * necessary due to a potential bad interaction between the GPL and
- * the restrictions contained in a BSD-style copyright.)
- *
- * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
- * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
- * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
- * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
- * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
- * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
- * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
- * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
- * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
- * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
- * DAMAGE.
- */
-
-/*
- * (now, with legal B.S. out of the way.....)
- *
- * This routine gathers environmental noise from device drivers, etc.,
- * and returns good random numbers, suitable for cryptographic use.
- * Besides the obvious cryptographic uses, these numbers are also good
- * for seeding TCP sequence numbers, and other places where it is
- * desirable to have numbers which are not only random, but hard to
- * predict by an attacker.
- *
- * Theory of operation
- * ===================
- *
- * Computers are very predictable devices.  Hence it is extremely hard
- * to produce truly random numbers on a computer --- as opposed to
- * pseudo-random numbers, which can easily generated by using a
- * algorithm.  Unfortunately, it is very easy for attackers to guess
- * the sequence of pseudo-random number generators, and for some
- * applications this is not acceptable.  So instead, we must try to
- * gather "environmental noise" from the computer's environment, which
- * must be hard for outside attackers to observe, and use that to
- * generate random numbers.  In a Unix environment, this is best done
- * from inside the kernel.
- *
- * Sources of randomness from the environment include inter-keyboard
- * timings, inter-interrupt timings from some interrupts, and other
- * events which are both (a) non-deterministic and (b) hard for an
- * outside observer to measure.  Randomness from these sources are
- * added to an "entropy pool", which is mixed using a CRC-like function.
- * This is not cryptographically strong, but it is adequate assuming
- * the randomness is not chosen maliciously, and it is fast enough that
- * the overhead of doing it on every interrupt is very reasonable.
- * As random bytes are mixed into the entropy pool, the routines keep
- * an *estimate* of how many bits of randomness have been stored into
- * the random number generator's internal state.
- *
- * When random bytes are desired, they are obtained by taking the BLAKE2s
- * hash of the contents of the "entropy pool".  The BLAKE2s hash avoids
- * exposing the internal state of the entropy pool.  It is believed to
- * be computationally infeasible to derive any useful information
- * about the input of BLAKE2s from its output.  Even if it is possible to
- * analyze BLAKE2s in some clever way, as long as the amount of data
- * returned from the generator is less than the inherent entropy in
- * the pool, the output data is totally unpredictable.  For this
- * reason, the routine decreases its internal estimate of how many
- * bits of "true randomness" are contained in the entropy pool as it
- * outputs random numbers.
- *
- * If this estimate goes to zero, the routine can still generate
- * random numbers; however, an attacker may (at least in theory) be
- * able to infer the future output of the generator from prior
- * outputs.  This requires successful cryptanalysis of BLAKE2s, which is
- * not believed to be feasible, but there is a remote possibility.
- * Nonetheless, these numbers should be useful for the vast majority
- * of purposes.
- *
- * Exported interfaces ---- output
- * ===============================
- *
- * There are four exported interfaces; two for use within the kernel,
- * and two for use from userspace.
- *
- * Exported interfaces ---- userspace output
- * -----------------------------------------
- *
- * The userspace interfaces are two character devices /dev/random and
- * /dev/urandom.  /dev/random is suitable for use when very high
- * quality randomness is desired (for example, for key generation or
- * one-time pads), as it will only return a maximum of the number of
- * bits of randomness (as estimated by the random number generator)
- * contained in the entropy pool.
- *
- * The /dev/urandom device does not have this limit, and will return
- * as many bytes as are requested.  As more and more random bytes are
- * requested without giving time for the entropy pool to recharge,
- * this will result in random numbers that are merely cryptographically
- * strong.  For many applications, however, this is acceptable.
- *
- * Exported interfaces ---- kernel output
- * --------------------------------------
- *
- * The primary kernel interface is
- *
- *	void get_random_bytes(void *buf, int nbytes);
- *
- * This interface will return the requested number of random bytes,
- * and place it in the requested buffer.  This is equivalent to a
- * read from /dev/urandom.
- *
- * For less critical applications, there are the functions:
- *
- *	u32 get_random_u32()
- *	u64 get_random_u64()
- *	unsigned int get_random_int()
- *	unsigned long get_random_long()
- *
- * These are produced by a cryptographic RNG seeded from get_random_bytes,
- * and so do not deplete the entropy pool as much.  These are recommended
- * for most in-kernel operations *if the result is going to be stored in
- * the kernel*.
- *
- * Specifically, the get_random_int() family do not attempt to do
- * "anti-backtracking".  If you capture the state of the kernel (e.g.
- * by snapshotting the VM), you can figure out previous get_random_int()
- * return values.  But if the value is stored in the kernel anyway,
- * this is not a problem.
- *
- * It *is* safe to expose get_random_int() output to attackers (e.g. as
- * network cookies); given outputs 1..n, it's not feasible to predict
- * outputs 0 or n+1.  The only concern is an attacker who breaks into
- * the kernel later; the get_random_int() engine is not reseeded as
- * often as the get_random_bytes() one.
- *
- * get_random_bytes() is needed for keys that need to stay secret after
- * they are erased from the kernel.  For example, any key that will
- * be wrapped and stored encrypted.  And session encryption keys: we'd
- * like to know that after the session is closed and the keys erased,
- * the plaintext is unrecoverable to someone who recorded the ciphertext.
- *
- * But for network ports/cookies, stack canaries, PRNG seeds, address
- * space layout randomization, session *authentication* keys, or other
- * applications where the sensitive data is stored in the kernel in
- * plaintext for as long as it's sensitive, the get_random_int() family
- * is just fine.
- *
- * Consider ASLR.  We want to keep the address space secret from an
- * outside attacker while the process is running, but once the address
- * space is torn down, it's of no use to an attacker any more.  And it's
- * stored in kernel data structures as long as it's alive, so worrying
- * about an attacker's ability to extrapolate it from the get_random_int()
- * CRNG is silly.
- *
- * Even some cryptographic keys are safe to generate with get_random_int().
- * In particular, keys for SipHash are generally fine.  Here, knowledge
- * of the key authorizes you to do something to a kernel object (inject
- * packets to a network connection, or flood a hash table), and the
- * key is stored with the object being protected.  Once it goes away,
- * we no longer care if anyone knows the key.
- *
- * prandom_u32()
- * -------------
- *
- * For even weaker applications, see the pseudorandom generator
- * prandom_u32(), prandom_max(), and prandom_bytes().  If the random
- * numbers aren't security-critical at all, these are *far* cheaper.
- * Useful for self-tests, random error simulation, randomized backoffs,
- * and any other application where you trust that nobody is trying to
- * maliciously mess with you by guessing the "random" numbers.
- *
- * Exported interfaces ---- input
- * ==============================
- *
- * The current exported interfaces for gathering environmental noise
- * from the devices are:
- *
- *	void add_device_randomness(const void *buf, unsigned int size);
- *	void add_input_randomness(unsigned int type, unsigned int code,
- *                                unsigned int value);
- *	void add_interrupt_randomness(int irq);
- *	void add_disk_randomness(struct gendisk *disk);
- *	void add_hwgenerator_randomness(const char *buffer, size_t count,
- *					size_t entropy);
- *	void add_bootloader_randomness(const void *buf, unsigned int size);
- *
- * add_device_randomness() is for adding data to the random pool that
- * is likely to differ between two devices (or possibly even per boot).
- * This would be things like MAC addresses or serial numbers, or the
- * read-out of the RTC. This does *not* add any actual entropy to the
- * pool, but it initializes the pool to different values for devices
- * that might otherwise be identical and have very little entropy
- * available to them (particularly common in the embedded world).
- *
- * add_input_randomness() uses the input layer interrupt timing, as well as
- * the event type information from the hardware.
- *
- * add_interrupt_randomness() uses the interrupt timing as random
- * inputs to the entropy pool. Using the cycle counters and the irq source
- * as inputs, it feeds the randomness roughly once a second.
- *
- * add_disk_randomness() uses what amounts to the seek time of block
- * layer request events, on a per-disk_devt basis, as input to the
- * entropy pool. Note that high-speed solid state drives with very low
- * seek times do not make for good sources of entropy, as their seek
- * times are usually fairly consistent.
- *
- * All of these routines try to estimate how many bits of randomness a
- * particular randomness source.  They do this by keeping track of the
- * first and second order deltas of the event timings.
- *
- * add_hwgenerator_randomness() is for true hardware RNGs, and will credit
- * entropy as specified by the caller. If the entropy pool is full it will
- * block until more entropy is needed.
- *
- * add_bootloader_randomness() is the same as add_hwgenerator_randomness() or
- * add_device_randomness(), depending on whether or not the configuration
- * option CONFIG_RANDOM_TRUST_BOOTLOADER is set.
- *
- * Ensuring unpredictability at system startup
- * ============================================
- *
- * When any operating system starts up, it will go through a sequence
- * of actions that are fairly predictable by an adversary, especially
- * if the start-up does not involve interaction with a human operator.
- * This reduces the actual number of bits of unpredictability in the
- * entropy pool below the value in entropy_count.  In order to
- * counteract this effect, it helps to carry information in the
- * entropy pool across shut-downs and start-ups.  To do this, put the
- * following lines an appropriate script which is run during the boot
- * sequence:
- *
- *	echo "Initializing random number generator..."
- *	random_seed=/var/run/random-seed
- *	# Carry a random seed from start-up to start-up
- *	# Load and then save the whole entropy pool
- *	if [ -f $random_seed ]; then
- *		cat $random_seed >/dev/urandom
- *	else
- *		touch $random_seed
- *	fi
- *	chmod 600 $random_seed
- *	dd if=/dev/urandom of=$random_seed count=1 bs=512
- *
- * and the following lines in an appropriate script which is run as
- * the system is shutdown:
- *
- *	# Carry a random seed from shut-down to start-up
- *	# Save the whole entropy pool
- *	echo "Saving random seed..."
- *	random_seed=/var/run/random-seed
- *	touch $random_seed
- *	chmod 600 $random_seed
- *	dd if=/dev/urandom of=$random_seed count=1 bs=512
- *
- * For example, on most modern systems using the System V init
- * scripts, such code fragments would be found in
- * /etc/rc.d/init.d/random.  On older Linux systems, the correct script
- * location might be in /etc/rcb.d/rc.local or /etc/rc.d/rc.0.
- *
- * Effectively, these commands cause the contents of the entropy pool
- * to be saved at shut-down time and reloaded into the entropy pool at
- * start-up.  (The 'dd' in the addition to the bootup script is to
- * make sure that /etc/random-seed is different for every start-up,
- * even if the system crashes without executing rc.0.)  Even with
- * complete knowledge of the start-up activities, predicting the state
- * of the entropy pool requires knowledge of the previous history of
- * the system.
- *
- * Configuring the /dev/random driver under Linux
- * ==============================================
- *
- * The /dev/random driver under Linux uses minor numbers 8 and 9 of
- * the /dev/mem major number (#1).  So if your system does not have
- * /dev/random and /dev/urandom created already, they can be created
- * by using the commands:
- *
- *	mknod /dev/random c 1 8
- *	mknod /dev/urandom c 1 9
- *
- * Acknowledgements:
- * =================
- *
- * Ideas for constructing this random number generator were derived
- * from Pretty Good Privacy's random number generator, and from private
- * discussions with Phil Karn.  Colin Plumb provided a faster random
- * number generator, which speed up the mixing function of the entropy
- * pool, taken from PGPfone.  Dale Worley has also contributed many
- * useful ideas and suggestions to improve this driver.
- *
- * Any flaws in the design are solely my responsibility, and should
- * not be attributed to the Phil, Colin, or any of authors of PGP.
- *
- * Further background information on this topic may be obtained from
- * RFC 1750, "Randomness Recommendations for Security", by Donald
- * Eastlake, Steve Crocker, and Jeff Schiller.
+ * Copyright Theodore Ts'o, 1994, 1995, 1996, 1997, 1998, 1999. All rights reserved.
+ *
+ * This driver produces cryptographically secure pseudorandom data. It is divided
+ * into roughly six sections, each with a section header:
+ *
+ *   - Initialization and readiness waiting.
+ *   - Fast key erasure RNG, the "crng".
+ *   - Entropy accumulation and extraction routines.
+ *   - Entropy collection routines.
+ *   - Userspace reader/writer interfaces.
+ *   - Sysctl interface.
+ *
+ * The high level overview is that there is one input pool, into which
+ * various pieces of data are hashed. Prior to initialization, some of that
+ * data is then "credited" as having a certain number of bits of entropy.
+ * When enough bits of entropy are available, the hash is finalized and
+ * handed as a key to a stream cipher that expands it indefinitely for
+ * various consumers. This key is periodically refreshed as the various
+ * entropy collectors, described below, add data to the input pool.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -344,1371 +50,1080 @@
 #include <linux/syscalls.h>
 #include <linux/completion.h>
 #include <linux/uuid.h>
+#include <linux/uaccess.h>
+#include <linux/siphash.h>
+#include <linux/uio.h>
 #include <crypto/chacha.h>
 #include <crypto/blake2s.h>
-
 #include <asm/processor.h>
-#include <linux/uaccess.h>
 #include <asm/irq.h>
 #include <asm/irq_regs.h>
 #include <asm/io.h>
 
-#define CREATE_TRACE_POINTS
-#include <trace/events/random.h>
-
-/* #define ADD_INTERRUPT_BENCH */
-
-/*
- * If the entropy count falls under this number of bits, then we
- * should wake up processes which are selecting or polling on write
- * access to /dev/random.
- */
-static int random_write_wakeup_bits = 28 * (1 << 5);
-
-/*
- * Originally, we used a primitive polynomial of degree .poolwords
- * over GF(2).  The taps for various sizes are defined below.  They
- * were chosen to be evenly spaced except for the last tap, which is 1
- * to get the twisting happening as fast as possible.
- *
- * For the purposes of better mixing, we use the CRC-32 polynomial as
- * well to make a (modified) twisted Generalized Feedback Shift
- * Register.  (See M. Matsumoto & Y. Kurita, 1992.  Twisted GFSR
- * generators.  ACM Transactions on Modeling and Computer Simulation
- * 2(3):179-194.  Also see M. Matsumoto & Y. Kurita, 1994.  Twisted
- * GFSR generators II.  ACM Transactions on Modeling and Computer
- * Simulation 4:254-266)
+/*********************************************************************
  *
- * Thanks to Colin Plumb for suggesting this.
+ * Initialization and readiness waiting.
  *
- * The mixing operation is much less sensitive than the output hash,
- * where we use BLAKE2s.  All that we want of mixing operation is that
- * it be a good non-cryptographic hash; i.e. it not produce collisions
- * when fed "random" data of the sort we expect to see.  As long as
- * the pool state differs for different inputs, we have preserved the
- * input entropy and done a good job.  The fact that an intelligent
- * attacker can construct inputs that will produce controlled
- * alterations to the pool's state is not important because we don't
- * consider such inputs to contribute any randomness.  The only
- * property we need with respect to them is that the attacker can't
- * increase his/her knowledge of the pool's state.  Since all
- * additions are reversible (knowing the final state and the input,
- * you can reconstruct the initial state), if an attacker has any
- * uncertainty about the initial state, he/she can only shuffle that
- * uncertainty about, but never cause any collisions (which would
- * decrease the uncertainty).
+ * Much of the RNG infrastructure is devoted to various dependencies
+ * being able to wait until the RNG has collected enough entropy and
+ * is ready for safe consumption.
  *
- * Our mixing functions were analyzed by Lacharme, Roeck, Strubel, and
- * Videau in their paper, "The Linux Pseudorandom Number Generator
- * Revisited" (see: http://eprint.iacr.org/2012/251.pdf).  In their
- * paper, they point out that we are not using a true Twisted GFSR,
- * since Matsumoto & Kurita used a trinomial feedback polynomial (that
- * is, with only three taps, instead of the six that we are using).
- * As a result, the resulting polynomial is neither primitive nor
- * irreducible, and hence does not have a maximal period over
- * GF(2**32).  They suggest a slight change to the generator
- * polynomial which improves the resulting TGFSR polynomial to be
- * irreducible, which we have made here.
- */
-enum poolinfo {
-	POOL_WORDS = 128,
-	POOL_WORDMASK = POOL_WORDS - 1,
-	POOL_BYTES = POOL_WORDS * sizeof(u32),
-	POOL_BITS = POOL_BYTES * 8,
-	POOL_BITSHIFT = ilog2(POOL_BITS),
-
-	/* To allow fractional bits to be tracked, the entropy_count field is
-	 * denominated in units of 1/8th bits. */
-	POOL_ENTROPY_SHIFT = 3,
-#define POOL_ENTROPY_BITS() (input_pool.entropy_count >> POOL_ENTROPY_SHIFT)
-	POOL_FRACBITS = POOL_BITS << POOL_ENTROPY_SHIFT,
-
-	/* x^128 + x^104 + x^76 + x^51 +x^25 + x + 1 */
-	POOL_TAP1 = 104,
-	POOL_TAP2 = 76,
-	POOL_TAP3 = 51,
-	POOL_TAP4 = 25,
-	POOL_TAP5 = 1,
-
-	EXTRACT_SIZE = BLAKE2S_HASH_SIZE / 2
-};
+ *********************************************************************/
 
 /*
- * Static global variables
+ * crng_init is protected by base_crng->lock, and only increases
+ * its value (from empty->early->ready).
  */
-static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
+static enum {
+	CRNG_EMPTY = 0, /* Little to no entropy collected */
+	CRNG_EARLY = 1, /* At least POOL_EARLY_BITS collected */
+	CRNG_READY = 2  /* Fully initialized with POOL_READY_BITS collected */
+} crng_init __read_mostly = CRNG_EMPTY;
+static DEFINE_STATIC_KEY_FALSE(crng_is_ready);
+#define crng_ready() (static_branch_likely(&crng_is_ready) || crng_init >= CRNG_READY)
+/* Various types of waiters for crng_init->CRNG_READY transition. */
+static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 static struct fasync_struct *fasync;
+static DEFINE_SPINLOCK(random_ready_chain_lock);
+static RAW_NOTIFIER_HEAD(random_ready_chain);
 
-static DEFINE_SPINLOCK(random_ready_list_lock);
-static LIST_HEAD(random_ready_list);
-
-struct crng_state {
-	u32 state[16];
-	unsigned long init_time;
-	spinlock_t lock;
-};
-
-static struct crng_state primary_crng = {
-	.lock = __SPIN_LOCK_UNLOCKED(primary_crng.lock),
-	.state[0] = CHACHA_CONSTANT_EXPA,
-	.state[1] = CHACHA_CONSTANT_ND_3,
-	.state[2] = CHACHA_CONSTANT_2_BY,
-	.state[3] = CHACHA_CONSTANT_TE_K,
-};
-
-/*
- * crng_init =  0 --> Uninitialized
- *		1 --> Initialized
- *		2 --> Initialized from input_pool
- *
- * crng_init is protected by primary_crng->lock, and only increases
- * its value (from 0->1->2).
- */
-static int crng_init = 0;
-static bool crng_need_final_init = false;
-#define crng_ready() (likely(crng_init > 1))
-static int crng_init_cnt = 0;
-static unsigned long crng_global_init_time = 0;
-#define CRNG_INIT_CNT_THRESH (2 * CHACHA_KEY_SIZE)
-static void _extract_crng(struct crng_state *crng, u8 out[CHACHA_BLOCK_SIZE]);
-static void _crng_backtrack_protect(struct crng_state *crng,
-				    u8 tmp[CHACHA_BLOCK_SIZE], int used);
-static void process_random_ready_list(void);
-static void _get_random_bytes(void *buf, int nbytes);
-
-static struct ratelimit_state unseeded_warning =
-	RATELIMIT_STATE_INIT("warn_unseeded_randomness", HZ, 3);
+/* Control how we warn userspace. */
 static struct ratelimit_state urandom_warning =
 	RATELIMIT_STATE_INIT("warn_urandom_randomness", HZ, 3);
-
-static int ratelimit_disable __read_mostly;
-
+static int ratelimit_disable __read_mostly =
+	IS_ENABLED(CONFIG_WARN_ALL_UNSEEDED_RANDOM);
 module_param_named(ratelimit_disable, ratelimit_disable, int, 0644);
 MODULE_PARM_DESC(ratelimit_disable, "Disable random ratelimit suppression");
 
-/**********************************************************************
- *
- * OS independent entropy store.   Here are the functions which handle
- * storing entropy in an entropy pool.
- *
- **********************************************************************/
-
-static u32 input_pool_data[POOL_WORDS] __latent_entropy;
-
-static struct {
-	spinlock_t lock;
-	u16 add_ptr;
-	u16 input_rotate;
-	int entropy_count;
-} input_pool = {
-	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
-};
-
-static ssize_t extract_entropy(void *buf, size_t nbytes, int min);
-static ssize_t _extract_entropy(void *buf, size_t nbytes);
-
-static void crng_reseed(struct crng_state *crng, bool use_input_pool);
-
-static const u32 twist_table[8] = {
-	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
-	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
-
 /*
- * This function adds bytes into the entropy "pool".  It does not
- * update the entropy estimate.  The caller should call
- * credit_entropy_bits if this is appropriate.
+ * Returns whether or not the input pool has been seeded and thus guaranteed
+ * to supply cryptographically secure random numbers. This applies to: the
+ * /dev/urandom device, the get_random_bytes function, and the get_random_{u32,
+ * ,u64,int,long} family of functions.
  *
- * The pool is stirred with a primitive polynomial of the appropriate
- * degree, and then twisted.  We twist by three bits at a time because
- * it's cheap to do so and helps slightly in the expected case where
- * the entropy is concentrated in the low-order bits.
+ * Returns: true if the input pool has been seeded.
+ *          false if the input pool has not been seeded.
  */
-static void _mix_pool_bytes(const void *in, int nbytes)
-{
-	unsigned long i;
-	int input_rotate;
-	const u8 *bytes = in;
-	u32 w;
-
-	input_rotate = input_pool.input_rotate;
-	i = input_pool.add_ptr;
-
-	/* mix one byte at a time to simplify size handling and churn faster */
-	while (nbytes--) {
-		w = rol32(*bytes++, input_rotate);
-		i = (i - 1) & POOL_WORDMASK;
-
-		/* XOR in the various taps */
-		w ^= input_pool_data[i];
-		w ^= input_pool_data[(i + POOL_TAP1) & POOL_WORDMASK];
-		w ^= input_pool_data[(i + POOL_TAP2) & POOL_WORDMASK];
-		w ^= input_pool_data[(i + POOL_TAP3) & POOL_WORDMASK];
-		w ^= input_pool_data[(i + POOL_TAP4) & POOL_WORDMASK];
-		w ^= input_pool_data[(i + POOL_TAP5) & POOL_WORDMASK];
-
-		/* Mix the result back in with a twist */
-		input_pool_data[i] = (w >> 3) ^ twist_table[w & 7];
-
-		/*
-		 * Normally, we add 7 bits of rotation to the pool.
-		 * At the beginning of the pool, add an extra 7 bits
-		 * rotation, so that successive passes spread the
-		 * input bits across the pool evenly.
-		 */
-		input_rotate = (input_rotate + (i ? 7 : 14)) & 31;
-	}
-
-	input_pool.input_rotate = input_rotate;
-	input_pool.add_ptr = i;
-}
-
-static void __mix_pool_bytes(const void *in, int nbytes)
+bool rng_is_initialized(void)
 {
-	trace_mix_pool_bytes_nolock(nbytes, _RET_IP_);
-	_mix_pool_bytes(in, nbytes);
+	return crng_ready();
 }
+EXPORT_SYMBOL(rng_is_initialized);
 
-static void mix_pool_bytes(const void *in, int nbytes)
+static void __cold crng_set_ready(struct work_struct *work)
 {
-	unsigned long flags;
-
-	trace_mix_pool_bytes(nbytes, _RET_IP_);
-	spin_lock_irqsave(&input_pool.lock, flags);
-	_mix_pool_bytes(in, nbytes);
-	spin_unlock_irqrestore(&input_pool.lock, flags);
+	static_branch_enable(&crng_is_ready);
 }
 
-struct fast_pool {
-	u32 pool[4];
-	unsigned long last;
-	u16 reg_idx;
-	u8 count;
-};
+/* Used by wait_for_random_bytes(), and considered an entropy collector, below. */
+static void try_to_generate_entropy(void);
 
 /*
- * This is a fast mixing routine used by the interrupt randomness
- * collector.  It's hardcoded for an 128 bit pool and assumes that any
- * locks that might be needed are taken by the caller.
+ * Wait for the input pool to be seeded and thus guaranteed to supply
+ * cryptographically secure random numbers. This applies to: the /dev/urandom
+ * device, the get_random_bytes function, and the get_random_{u32,u64,int,long}
+ * family of functions. Using any of these functions without first calling
+ * this function forfeits the guarantee of security.
+ *
+ * Returns: 0 if the input pool has been seeded.
+ *          -ERESTARTSYS if the function was interrupted by a signal.
  */
-static void fast_mix(struct fast_pool *f)
+int wait_for_random_bytes(void)
 {
-	u32 a = f->pool[0],	b = f->pool[1];
-	u32 c = f->pool[2],	d = f->pool[3];
-
-	a += b;			c += d;
-	b = rol32(b, 6);	d = rol32(d, 27);
-	d ^= a;			b ^= c;
-
-	a += b;			c += d;
-	b = rol32(b, 16);	d = rol32(d, 14);
-	d ^= a;			b ^= c;
-
-	a += b;			c += d;
-	b = rol32(b, 6);	d = rol32(d, 27);
-	d ^= a;			b ^= c;
-
-	a += b;			c += d;
-	b = rol32(b, 16);	d = rol32(d, 14);
-	d ^= a;			b ^= c;
+	while (!crng_ready()) {
+		int ret;
 
-	f->pool[0] = a;  f->pool[1] = b;
-	f->pool[2] = c;  f->pool[3] = d;
-	f->count++;
+		try_to_generate_entropy();
+		ret = wait_event_interruptible_timeout(crng_init_wait, crng_ready(), HZ);
+		if (ret)
+			return ret > 0 ? 0 : ret;
+	}
+	return 0;
 }
+EXPORT_SYMBOL(wait_for_random_bytes);
 
-static void process_random_ready_list(void)
+/*
+ * Add a callback function that will be invoked when the input
+ * pool is initialised.
+ *
+ * returns: 0 if callback is successfully added
+ *	    -EALREADY if pool is already initialised (callback not called)
+ */
+int __cold register_random_ready_notifier(struct notifier_block *nb)
 {
 	unsigned long flags;
-	struct random_ready_callback *rdy, *tmp;
+	int ret = -EALREADY;
 
-	spin_lock_irqsave(&random_ready_list_lock, flags);
-	list_for_each_entry_safe(rdy, tmp, &random_ready_list, list) {
-		struct module *owner = rdy->owner;
+	if (crng_ready())
+		return ret;
 
-		list_del_init(&rdy->list);
-		rdy->func(rdy);
-		module_put(owner);
-	}
-	spin_unlock_irqrestore(&random_ready_list_lock, flags);
+	spin_lock_irqsave(&random_ready_chain_lock, flags);
+	if (!crng_ready())
+		ret = raw_notifier_chain_register(&random_ready_chain, nb);
+	spin_unlock_irqrestore(&random_ready_chain_lock, flags);
+	return ret;
 }
 
 /*
- * Credit (or debit) the entropy store with n bits of entropy.
- * Use credit_entropy_bits_safe() if the value comes from userspace
- * or otherwise should be checked for extreme values.
+ * Delete a previously registered readiness callback function.
  */
-static void credit_entropy_bits(int nbits)
+int __cold unregister_random_ready_notifier(struct notifier_block *nb)
 {
-	int entropy_count, entropy_bits, orig;
-	int nfrac = nbits << POOL_ENTROPY_SHIFT;
-
-	/* Ensure that the multiplication can avoid being 64 bits wide. */
-	BUILD_BUG_ON(2 * (POOL_ENTROPY_SHIFT + POOL_BITSHIFT) > 31);
-
-	if (!nbits)
-		return;
-
-retry:
-	entropy_count = orig = READ_ONCE(input_pool.entropy_count);
-	if (nfrac < 0) {
-		/* Debit */
-		entropy_count += nfrac;
-	} else {
-		/*
-		 * Credit: we have to account for the possibility of
-		 * overwriting already present entropy.	 Even in the
-		 * ideal case of pure Shannon entropy, new contributions
-		 * approach the full value asymptotically:
-		 *
-		 * entropy <- entropy + (pool_size - entropy) *
-		 *	(1 - exp(-add_entropy/pool_size))
-		 *
-		 * For add_entropy <= pool_size/2 then
-		 * (1 - exp(-add_entropy/pool_size)) >=
-		 *    (add_entropy/pool_size)*0.7869...
-		 * so we can approximate the exponential with
-		 * 3/4*add_entropy/pool_size and still be on the
-		 * safe side by adding at most pool_size/2 at a time.
-		 *
-		 * The use of pool_size-2 in the while statement is to
-		 * prevent rounding artifacts from making the loop
-		 * arbitrarily long; this limits the loop to log2(pool_size)*2
-		 * turns no matter how large nbits is.
-		 */
-		int pnfrac = nfrac;
-		const int s = POOL_BITSHIFT + POOL_ENTROPY_SHIFT + 2;
-		/* The +2 corresponds to the /4 in the denominator */
-
-		do {
-			unsigned int anfrac = min(pnfrac, POOL_FRACBITS / 2);
-			unsigned int add =
-				((POOL_FRACBITS - entropy_count) * anfrac * 3) >> s;
-
-			entropy_count += add;
-			pnfrac -= anfrac;
-		} while (unlikely(entropy_count < POOL_FRACBITS - 2 && pnfrac));
-	}
-
-	if (WARN_ON(entropy_count < 0)) {
-		pr_warn("negative entropy/overflow: count %d\n", entropy_count);
-		entropy_count = 0;
-	} else if (entropy_count > POOL_FRACBITS)
-		entropy_count = POOL_FRACBITS;
-	if (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig)
-		goto retry;
-
-	trace_credit_entropy_bits(nbits, entropy_count >> POOL_ENTROPY_SHIFT, _RET_IP_);
+	unsigned long flags;
+	int ret;
 
-	entropy_bits = entropy_count >> POOL_ENTROPY_SHIFT;
-	if (crng_init < 2 && entropy_bits >= 128)
-		crng_reseed(&primary_crng, true);
+	spin_lock_irqsave(&random_ready_chain_lock, flags);
+	ret = raw_notifier_chain_unregister(&random_ready_chain, nb);
+	spin_unlock_irqrestore(&random_ready_chain_lock, flags);
+	return ret;
 }
 
-static int credit_entropy_bits_safe(int nbits)
+static void __cold process_random_ready_list(void)
 {
-	if (nbits < 0)
-		return -EINVAL;
-
-	/* Cap the value to avoid overflows */
-	nbits = min(nbits, POOL_BITS);
+	unsigned long flags;
 
-	credit_entropy_bits(nbits);
-	return 0;
+	spin_lock_irqsave(&random_ready_chain_lock, flags);
+	raw_notifier_call_chain(&random_ready_chain, 0, NULL);
+	spin_unlock_irqrestore(&random_ready_chain_lock, flags);
 }
 
+#define warn_unseeded_randomness() \
+	if (IS_ENABLED(CONFIG_WARN_ALL_UNSEEDED_RANDOM) && !crng_ready()) \
+		printk_deferred(KERN_NOTICE "random: %s called from %pS with crng_init=%d\n", \
+				__func__, (void *)_RET_IP_, crng_init)
+
+
 /*********************************************************************
  *
- * CRNG using CHACHA20
+ * Fast key erasure RNG, the "crng".
+ *
+ * These functions expand entropy from the entropy extractor into
+ * long streams for external consumption using the "fast key erasure"
+ * RNG described at <https://blog.cr.yp.to/20170723-random.html>.
+ *
+ * There are a few exported interfaces for use by other drivers:
+ *
+ *	void get_random_bytes(void *buf, size_t len)
+ *	u32 get_random_u32()
+ *	u64 get_random_u64()
+ *	unsigned int get_random_int()
+ *	unsigned long get_random_long()
+ *
+ * These interfaces will return the requested number of random bytes
+ * into the given buffer or as a return value. This is equivalent to
+ * a read from /dev/urandom. The u32, u64, int, and long family of
+ * functions may be higher performance for one-off random integers,
+ * because they do a bit of buffering and do not invoke reseeding
+ * until the buffer is emptied.
  *
  *********************************************************************/
 
-#define CRNG_RESEED_INTERVAL (300 * HZ)
+enum {
+	CRNG_RESEED_START_INTERVAL = HZ,
+	CRNG_RESEED_INTERVAL = 60 * HZ
+};
 
-static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
+static struct {
+	u8 key[CHACHA_KEY_SIZE] __aligned(__alignof__(long));
+	unsigned long birth;
+	unsigned long generation;
+	spinlock_t lock;
+} base_crng = {
+	.lock = __SPIN_LOCK_UNLOCKED(base_crng.lock)
+};
 
-/*
- * Hack to deal with crazy userspace progams when they are all trying
- * to access /dev/urandom in parallel.  The programs are almost
- * certainly doing something terribly wrong, but we'll work around
- * their brain damage.
- */
-static struct crng_state **crng_node_pool __read_mostly;
+struct crng {
+	u8 key[CHACHA_KEY_SIZE];
+	unsigned long generation;
+	local_lock_t lock;
+};
 
-static void invalidate_batched_entropy(void);
-static void numa_crng_init(void);
+static DEFINE_PER_CPU(struct crng, crngs) = {
+	.generation = ULONG_MAX,
+	.lock = INIT_LOCAL_LOCK(crngs.lock),
+};
 
-static bool trust_cpu __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
-static int __init parse_trust_cpu(char *arg)
-{
-	return kstrtobool(arg, &trust_cpu);
-}
-early_param("random.trust_cpu", parse_trust_cpu);
+/* Used by crng_reseed() and crng_make_state() to extract a new seed from the input pool. */
+static void extract_entropy(void *buf, size_t len);
 
-static bool crng_init_try_arch(struct crng_state *crng)
+/* This extracts a new crng key from the input pool. */
+static void crng_reseed(void)
 {
-	int i;
-	bool arch_init = true;
-	unsigned long rv;
-
-	for (i = 4; i < 16; i++) {
-		if (!arch_get_random_seed_long(&rv) &&
-		    !arch_get_random_long(&rv)) {
-			rv = random_get_entropy();
-			arch_init = false;
-		}
-		crng->state[i] ^= rv;
-	}
+	unsigned long flags;
+	unsigned long next_gen;
+	u8 key[CHACHA_KEY_SIZE];
 
-	return arch_init;
+	extract_entropy(key, sizeof(key));
+
+	/*
+	 * We copy the new key into the base_crng, overwriting the old one,
+	 * and update the generation counter. We avoid hitting ULONG_MAX,
+	 * because the per-cpu crngs are initialized to ULONG_MAX, so this
+	 * forces new CPUs that come online to always initialize.
+	 */
+	spin_lock_irqsave(&base_crng.lock, flags);
+	memcpy(base_crng.key, key, sizeof(base_crng.key));
+	next_gen = base_crng.generation + 1;
+	if (next_gen == ULONG_MAX)
+		++next_gen;
+	WRITE_ONCE(base_crng.generation, next_gen);
+	WRITE_ONCE(base_crng.birth, jiffies);
+	if (!static_branch_likely(&crng_is_ready))
+		crng_init = CRNG_READY;
+	spin_unlock_irqrestore(&base_crng.lock, flags);
+	memzero_explicit(key, sizeof(key));
 }
 
-static bool __init crng_init_try_arch_early(void)
+/*
+ * This generates a ChaCha block using the provided key, and then
+ * immediately overwites that key with half the block. It returns
+ * the resultant ChaCha state to the user, along with the second
+ * half of the block containing 32 bytes of random data that may
+ * be used; random_data_len may not be greater than 32.
+ *
+ * The returned ChaCha state contains within it a copy of the old
+ * key value, at index 4, so the state should always be zeroed out
+ * immediately after using in order to maintain forward secrecy.
+ * If the state cannot be erased in a timely manner, then it is
+ * safer to set the random_data parameter to &chacha_state[4] so
+ * that this function overwrites it before returning.
+ */
+static void crng_fast_key_erasure(u8 key[CHACHA_KEY_SIZE],
+				  u32 chacha_state[CHACHA_STATE_WORDS],
+				  u8 *random_data, size_t random_data_len)
 {
-	int i;
-	bool arch_init = true;
-	unsigned long rv;
-
-	for (i = 4; i < 16; i++) {
-		if (!arch_get_random_seed_long_early(&rv) &&
-		    !arch_get_random_long_early(&rv)) {
-			rv = random_get_entropy();
-			arch_init = false;
-		}
-		primary_crng.state[i] ^= rv;
-	}
+	u8 first_block[CHACHA_BLOCK_SIZE];
 
-	return arch_init;
-}
+	BUG_ON(random_data_len > 32);
 
-static void crng_initialize_secondary(struct crng_state *crng)
-{
-	chacha_init_consts(crng->state);
-	_get_random_bytes(&crng->state[4], sizeof(u32) * 12);
-	crng_init_try_arch(crng);
-	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
+	chacha_init_consts(chacha_state);
+	memcpy(&chacha_state[4], key, CHACHA_KEY_SIZE);
+	memset(&chacha_state[12], 0, sizeof(u32) * 4);
+	chacha20_block(chacha_state, first_block);
+
+	memcpy(key, first_block, CHACHA_KEY_SIZE);
+	memcpy(random_data, first_block + CHACHA_KEY_SIZE, random_data_len);
+	memzero_explicit(first_block, sizeof(first_block));
 }
 
-static void __init crng_initialize_primary(void)
-{
-	_extract_entropy(&primary_crng.state[4], sizeof(u32) * 12);
-	if (crng_init_try_arch_early() && trust_cpu && crng_init < 2) {
-		invalidate_batched_entropy();
-		numa_crng_init();
-		crng_init = 2;
-		pr_notice("crng init done (trusting CPU's manufacturer)\n");
+/*
+ * Return whether the crng seed is considered to be sufficiently old
+ * that a reseeding is needed. This happens if the last reseeding
+ * was CRNG_RESEED_INTERVAL ago, or during early boot, at an interval
+ * proportional to the uptime.
+ */
+static bool crng_has_old_seed(void)
+{
+	static bool early_boot = true;
+	unsigned long interval = CRNG_RESEED_INTERVAL;
+
+	if (unlikely(READ_ONCE(early_boot))) {
+		time64_t uptime = ktime_get_seconds();
+		if (uptime >= CRNG_RESEED_INTERVAL / HZ * 2)
+			WRITE_ONCE(early_boot, false);
+		else
+			interval = max_t(unsigned int, CRNG_RESEED_START_INTERVAL,
+					 (unsigned int)uptime / 2 * HZ);
 	}
-	primary_crng.init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
+	return time_is_before_jiffies(READ_ONCE(base_crng.birth) + interval);
 }
 
-static void crng_finalize_init(void)
+/*
+ * This function returns a ChaCha state that you may use for generating
+ * random data. It also returns up to 32 bytes on its own of random data
+ * that may be used; random_data_len may not be greater than 32.
+ */
+static void crng_make_state(u32 chacha_state[CHACHA_STATE_WORDS],
+			    u8 *random_data, size_t random_data_len)
 {
-	if (!system_wq) {
-		/* We can't call numa_crng_init until we have workqueues,
-		 * so mark this for processing later. */
-		crng_need_final_init = true;
-		return;
-	}
+	unsigned long flags;
+	struct crng *crng;
 
-	invalidate_batched_entropy();
-	numa_crng_init();
-	crng_init = 2;
-	crng_need_final_init = false;
-	process_random_ready_list();
-	wake_up_interruptible(&crng_init_wait);
-	kill_fasync(&fasync, SIGIO, POLL_IN);
-	pr_notice("crng init done\n");
-	if (unseeded_warning.missed) {
-		pr_notice("%d get_random_xx warning(s) missed due to ratelimiting\n",
-			  unseeded_warning.missed);
-		unseeded_warning.missed = 0;
+	BUG_ON(random_data_len > 32);
+
+	/*
+	 * For the fast path, we check whether we're ready, unlocked first, and
+	 * then re-check once locked later. In the case where we're really not
+	 * ready, we do fast key erasure with the base_crng directly, extracting
+	 * when crng_init is CRNG_EMPTY.
+	 */
+	if (!crng_ready()) {
+		bool ready;
+
+		spin_lock_irqsave(&base_crng.lock, flags);
+		ready = crng_ready();
+		if (!ready) {
+			if (crng_init == CRNG_EMPTY)
+				extract_entropy(base_crng.key, sizeof(base_crng.key));
+			crng_fast_key_erasure(base_crng.key, chacha_state,
+					      random_data, random_data_len);
+		}
+		spin_unlock_irqrestore(&base_crng.lock, flags);
+		if (!ready)
+			return;
 	}
-	if (urandom_warning.missed) {
-		pr_notice("%d urandom warning(s) missed due to ratelimiting\n",
-			  urandom_warning.missed);
-		urandom_warning.missed = 0;
+
+	/*
+	 * If the base_crng is old enough, we reseed, which in turn bumps the
+	 * generation counter that we check below.
+	 */
+	if (unlikely(crng_has_old_seed()))
+		crng_reseed();
+
+	local_lock_irqsave(&crngs.lock, flags);
+	crng = raw_cpu_ptr(&crngs);
+
+	/*
+	 * If our per-cpu crng is older than the base_crng, then it means
+	 * somebody reseeded the base_crng. In that case, we do fast key
+	 * erasure on the base_crng, and use its output as the new key
+	 * for our per-cpu crng. This brings us up to date with base_crng.
+	 */
+	if (unlikely(crng->generation != READ_ONCE(base_crng.generation))) {
+		spin_lock(&base_crng.lock);
+		crng_fast_key_erasure(base_crng.key, chacha_state,
+				      crng->key, sizeof(crng->key));
+		crng->generation = base_crng.generation;
+		spin_unlock(&base_crng.lock);
 	}
+
+	/*
+	 * Finally, when we've made it this far, our per-cpu crng has an up
+	 * to date key, and we can do fast key erasure with it to produce
+	 * some random data and a ChaCha state for the caller. All other
+	 * branches of this function are "unlikely", so most of the time we
+	 * should wind up here immediately.
+	 */
+	crng_fast_key_erasure(crng->key, chacha_state, random_data, random_data_len);
+	local_unlock_irqrestore(&crngs.lock, flags);
 }
 
-static void do_numa_crng_init(struct work_struct *work)
+static void _get_random_bytes(void *buf, size_t len)
 {
-	int i;
-	struct crng_state *crng;
-	struct crng_state **pool;
-
-	pool = kcalloc(nr_node_ids, sizeof(*pool), GFP_KERNEL | __GFP_NOFAIL);
-	for_each_online_node(i) {
-		crng = kmalloc_node(sizeof(struct crng_state),
-				    GFP_KERNEL | __GFP_NOFAIL, i);
-		spin_lock_init(&crng->lock);
-		crng_initialize_secondary(crng);
-		pool[i] = crng;
-	}
-	/* pairs with READ_ONCE() in select_crng() */
-	if (cmpxchg_release(&crng_node_pool, NULL, pool) != NULL) {
-		for_each_node(i)
-			kfree(pool[i]);
-		kfree(pool);
-	}
-}
+	u32 chacha_state[CHACHA_STATE_WORDS];
+	u8 tmp[CHACHA_BLOCK_SIZE];
+	size_t first_block_len;
 
-static DECLARE_WORK(numa_crng_init_work, do_numa_crng_init);
+	if (!len)
+		return;
 
-static void numa_crng_init(void)
-{
-	if (IS_ENABLED(CONFIG_NUMA))
-		schedule_work(&numa_crng_init_work);
-}
+	first_block_len = min_t(size_t, 32, len);
+	crng_make_state(chacha_state, buf, first_block_len);
+	len -= first_block_len;
+	buf += first_block_len;
 
-static struct crng_state *select_crng(void)
-{
-	if (IS_ENABLED(CONFIG_NUMA)) {
-		struct crng_state **pool;
-		int nid = numa_node_id();
-
-		/* pairs with cmpxchg_release() in do_numa_crng_init() */
-		pool = READ_ONCE(crng_node_pool);
-		if (pool && pool[nid])
-			return pool[nid];
+	while (len) {
+		if (len < CHACHA_BLOCK_SIZE) {
+			chacha20_block(chacha_state, tmp);
+			memcpy(buf, tmp, len);
+			memzero_explicit(tmp, sizeof(tmp));
+			break;
+		}
+
+		chacha20_block(chacha_state, buf);
+		if (unlikely(chacha_state[12] == 0))
+			++chacha_state[13];
+		len -= CHACHA_BLOCK_SIZE;
+		buf += CHACHA_BLOCK_SIZE;
 	}
 
-	return &primary_crng;
+	memzero_explicit(chacha_state, sizeof(chacha_state));
 }
 
 /*
- * crng_fast_load() can be called by code in the interrupt service
- * path.  So we can't afford to dilly-dally. Returns the number of
- * bytes processed from cp.
+ * This function is the exported kernel interface.  It returns some
+ * number of good random numbers, suitable for key generation, seeding
+ * TCP sequence numbers, etc.  It does not rely on the hardware random
+ * number generator.  For random bytes direct from the hardware RNG
+ * (when available), use get_random_bytes_arch(). In order to ensure
+ * that the randomness provided by this function is okay, the function
+ * wait_for_random_bytes() should be called and return 0 at least once
+ * at any point prior.
  */
-static size_t crng_fast_load(const u8 *cp, size_t len)
+void get_random_bytes(void *buf, size_t len)
 {
-	unsigned long flags;
-	u8 *p;
-	size_t ret = 0;
-
-	if (!spin_trylock_irqsave(&primary_crng.lock, flags))
-		return 0;
-	if (crng_init != 0) {
-		spin_unlock_irqrestore(&primary_crng.lock, flags);
-		return 0;
-	}
-	p = (u8 *)&primary_crng.state[4];
-	while (len > 0 && crng_init_cnt < CRNG_INIT_CNT_THRESH) {
-		p[crng_init_cnt % CHACHA_KEY_SIZE] ^= *cp;
-		cp++; crng_init_cnt++; len--; ret++;
-	}
-	spin_unlock_irqrestore(&primary_crng.lock, flags);
-	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
-		invalidate_batched_entropy();
-		crng_init = 1;
-		pr_notice("fast init done\n");
-	}
-	return ret;
+	warn_unseeded_randomness();
+	_get_random_bytes(buf, len);
 }
+EXPORT_SYMBOL(get_random_bytes);
 
-/*
- * crng_slow_load() is called by add_device_randomness, which has two
- * attributes.  (1) We can't trust the buffer passed to it is
- * guaranteed to be unpredictable (so it might not have any entropy at
- * all), and (2) it doesn't have the performance constraints of
- * crng_fast_load().
- *
- * So we do something more comprehensive which is guaranteed to touch
- * all of the primary_crng's state, and which uses a LFSR with a
- * period of 255 as part of the mixing algorithm.  Finally, we do
- * *not* advance crng_init_cnt since buffer we may get may be something
- * like a fixed DMI table (for example), which might very well be
- * unique to the machine, but is otherwise unvarying.
- */
-static int crng_slow_load(const u8 *cp, size_t len)
+static ssize_t get_random_bytes_user(struct iov_iter *iter)
 {
-	unsigned long flags;
-	static u8 lfsr = 1;
-	u8 tmp;
-	unsigned int i, max = CHACHA_KEY_SIZE;
-	const u8 *src_buf = cp;
-	u8 *dest_buf = (u8 *)&primary_crng.state[4];
+	u32 chacha_state[CHACHA_STATE_WORDS];
+	u8 block[CHACHA_BLOCK_SIZE];
+	size_t ret = 0, copied;
 
-	if (!spin_trylock_irqsave(&primary_crng.lock, flags))
-		return 0;
-	if (crng_init != 0) {
-		spin_unlock_irqrestore(&primary_crng.lock, flags);
+	if (unlikely(!iov_iter_count(iter)))
 		return 0;
-	}
-	if (len > max)
-		max = len;
-
-	for (i = 0; i < max; i++) {
-		tmp = lfsr;
-		lfsr >>= 1;
-		if (tmp & 1)
-			lfsr ^= 0xE1;
-		tmp = dest_buf[i % CHACHA_KEY_SIZE];
-		dest_buf[i % CHACHA_KEY_SIZE] ^= src_buf[i % len] ^ lfsr;
-		lfsr += (tmp << 3) | (tmp >> 5);
-	}
-	spin_unlock_irqrestore(&primary_crng.lock, flags);
-	return 1;
-}
 
-static void crng_reseed(struct crng_state *crng, bool use_input_pool)
-{
-	unsigned long flags;
-	int i, num;
-	union {
-		u8 block[CHACHA_BLOCK_SIZE];
-		u32 key[8];
-	} buf;
-
-	if (use_input_pool) {
-		num = extract_entropy(&buf, 32, 16);
-		if (num == 0)
-			return;
-	} else {
-		_extract_crng(&primary_crng, buf.block);
-		_crng_backtrack_protect(&primary_crng, buf.block,
-					CHACHA_KEY_SIZE);
-	}
-	spin_lock_irqsave(&crng->lock, flags);
-	for (i = 0; i < 8; i++) {
-		unsigned long rv;
-		if (!arch_get_random_seed_long(&rv) &&
-		    !arch_get_random_long(&rv))
-			rv = random_get_entropy();
-		crng->state[i + 4] ^= buf.key[i] ^ rv;
+	/*
+	 * Immediately overwrite the ChaCha key at index 4 with random
+	 * bytes, in case userspace causes copy_to_user() below to sleep
+	 * forever, so that we still retain forward secrecy in that case.
+	 */
+	crng_make_state(chacha_state, (u8 *)&chacha_state[4], CHACHA_KEY_SIZE);
+	/*
+	 * However, if we're doing a read of len <= 32, we don't need to
+	 * use chacha_state after, so we can simply return those bytes to
+	 * the user directly.
+	 */
+	if (iov_iter_count(iter) <= CHACHA_KEY_SIZE) {
+		ret = copy_to_iter(&chacha_state[4], CHACHA_KEY_SIZE, iter);
+		goto out_zero_chacha;
 	}
-	memzero_explicit(&buf, sizeof(buf));
-	WRITE_ONCE(crng->init_time, jiffies);
-	spin_unlock_irqrestore(&crng->lock, flags);
-	if (crng == &primary_crng && crng_init < 2)
-		crng_finalize_init();
-}
 
-static void _extract_crng(struct crng_state *crng, u8 out[CHACHA_BLOCK_SIZE])
-{
-	unsigned long flags, init_time;
+	for (;;) {
+		chacha20_block(chacha_state, block);
+		if (unlikely(chacha_state[12] == 0))
+			++chacha_state[13];
+
+		copied = copy_to_iter(block, sizeof(block), iter);
+		ret += copied;
+		if (!iov_iter_count(iter) || copied != sizeof(block))
+			break;
 
-	if (crng_ready()) {
-		init_time = READ_ONCE(crng->init_time);
-		if (time_after(READ_ONCE(crng_global_init_time), init_time) ||
-		    time_after(jiffies, init_time + CRNG_RESEED_INTERVAL))
-			crng_reseed(crng, crng == &primary_crng);
+		BUILD_BUG_ON(PAGE_SIZE % sizeof(block) != 0);
+		if (ret % PAGE_SIZE == 0) {
+			if (signal_pending(current))
+				break;
+			cond_resched();
+		}
 	}
-	spin_lock_irqsave(&crng->lock, flags);
-	chacha20_block(&crng->state[0], out);
-	if (crng->state[12] == 0)
-		crng->state[13]++;
-	spin_unlock_irqrestore(&crng->lock, flags);
-}
 
-static void extract_crng(u8 out[CHACHA_BLOCK_SIZE])
-{
-	_extract_crng(select_crng(), out);
+	memzero_explicit(block, sizeof(block));
+out_zero_chacha:
+	memzero_explicit(chacha_state, sizeof(chacha_state));
+	return ret ? ret : -EFAULT;
 }
 
 /*
- * Use the leftover bytes from the CRNG block output (if there is
- * enough) to mutate the CRNG key to provide backtracking protection.
+ * Batched entropy returns random integers. The quality of the random
+ * number is good as /dev/urandom. In order to ensure that the randomness
+ * provided by this function is okay, the function wait_for_random_bytes()
+ * should be called and return 0 at least once at any point prior.
  */
-static void _crng_backtrack_protect(struct crng_state *crng,
-				    u8 tmp[CHACHA_BLOCK_SIZE], int used)
-{
-	unsigned long flags;
-	u32 *s, *d;
-	int i;
 
-	used = round_up(used, sizeof(u32));
-	if (used + CHACHA_KEY_SIZE > CHACHA_BLOCK_SIZE) {
-		extract_crng(tmp);
-		used = 0;
-	}
-	spin_lock_irqsave(&crng->lock, flags);
-	s = (u32 *)&tmp[used];
-	d = &crng->state[4];
-	for (i = 0; i < 8; i++)
-		*d++ ^= *s++;
-	spin_unlock_irqrestore(&crng->lock, flags);
-}
-
-static void crng_backtrack_protect(u8 tmp[CHACHA_BLOCK_SIZE], int used)
+#define DEFINE_BATCHED_ENTROPY(type)						\
+struct batch_ ##type {								\
+	/*									\
+	 * We make this 1.5x a ChaCha block, so that we get the			\
+	 * remaining 32 bytes from fast key erasure, plus one full		\
+	 * block from the detached ChaCha state. We can increase		\
+	 * the size of this later if needed so long as we keep the		\
+	 * formula of (integer_blocks + 0.5) * CHACHA_BLOCK_SIZE.		\
+	 */									\
+	type entropy[CHACHA_BLOCK_SIZE * 3 / (2 * sizeof(type))];		\
+	local_lock_t lock;							\
+	unsigned long generation;						\
+	unsigned int position;							\
+};										\
+										\
+static DEFINE_PER_CPU(struct batch_ ##type, batched_entropy_ ##type) = {	\
+	.lock = INIT_LOCAL_LOCK(batched_entropy_ ##type.lock),			\
+	.position = UINT_MAX							\
+};										\
+										\
+type get_random_ ##type(void)							\
+{										\
+	type ret;								\
+	unsigned long flags;							\
+	struct batch_ ##type *batch;						\
+	unsigned long next_gen;							\
+										\
+	warn_unseeded_randomness();						\
+										\
+	if  (!crng_ready()) {							\
+		_get_random_bytes(&ret, sizeof(ret));				\
+		return ret;							\
+	}									\
+										\
+	local_lock_irqsave(&batched_entropy_ ##type.lock, flags);		\
+	batch = raw_cpu_ptr(&batched_entropy_##type);				\
+										\
+	next_gen = READ_ONCE(base_crng.generation);				\
+	if (batch->position >= ARRAY_SIZE(batch->entropy) ||			\
+	    next_gen != batch->generation) {					\
+		_get_random_bytes(batch->entropy, sizeof(batch->entropy));	\
+		batch->position = 0;						\
+		batch->generation = next_gen;					\
+	}									\
+										\
+	ret = batch->entropy[batch->position];					\
+	batch->entropy[batch->position] = 0;					\
+	++batch->position;							\
+	local_unlock_irqrestore(&batched_entropy_ ##type.lock, flags);		\
+	return ret;								\
+}										\
+EXPORT_SYMBOL(get_random_ ##type);
+
+DEFINE_BATCHED_ENTROPY(u64)
+DEFINE_BATCHED_ENTROPY(u32)
+
+#ifdef CONFIG_SMP
+/*
+ * This function is called when the CPU is coming up, with entry
+ * CPUHP_RANDOM_PREPARE, which comes before CPUHP_WORKQUEUE_PREP.
+ */
+int __cold random_prepare_cpu(unsigned int cpu)
 {
-	_crng_backtrack_protect(select_crng(), tmp, used);
+	/*
+	 * When the cpu comes back online, immediately invalidate both
+	 * the per-cpu crng and all batches, so that we serve fresh
+	 * randomness.
+	 */
+	per_cpu_ptr(&crngs, cpu)->generation = ULONG_MAX;
+	per_cpu_ptr(&batched_entropy_u32, cpu)->position = UINT_MAX;
+	per_cpu_ptr(&batched_entropy_u64, cpu)->position = UINT_MAX;
+	return 0;
 }
+#endif
 
-static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
+/*
+ * This function will use the architecture-specific hardware random
+ * number generator if it is available. It is not recommended for
+ * use. Use get_random_bytes() instead. It returns the number of
+ * bytes filled in.
+ */
+size_t __must_check get_random_bytes_arch(void *buf, size_t len)
 {
-	ssize_t ret = 0, i = CHACHA_BLOCK_SIZE;
-	u8 tmp[CHACHA_BLOCK_SIZE] __aligned(4);
-	int large_request = (nbytes > 256);
-
-	while (nbytes) {
-		if (large_request && need_resched()) {
-			if (signal_pending(current)) {
-				if (ret == 0)
-					ret = -ERESTARTSYS;
-				break;
-			}
-			schedule();
-		}
+	size_t left = len;
+	u8 *p = buf;
+
+	while (left) {
+		unsigned long v;
+		size_t block_len = min_t(size_t, left, sizeof(unsigned long));
 
-		extract_crng(tmp);
-		i = min_t(int, nbytes, CHACHA_BLOCK_SIZE);
-		if (copy_to_user(buf, tmp, i)) {
-			ret = -EFAULT;
+		if (!arch_get_random_long(&v))
 			break;
-		}
 
-		nbytes -= i;
-		buf += i;
-		ret += i;
+		memcpy(p, &v, block_len);
+		p += block_len;
+		left -= block_len;
 	}
-	crng_backtrack_protect(tmp, i);
-
-	/* Wipe data just written to memory */
-	memzero_explicit(tmp, sizeof(tmp));
 
-	return ret;
+	return len - left;
 }
+EXPORT_SYMBOL(get_random_bytes_arch);
 
-/*********************************************************************
+
+/**********************************************************************
  *
- * Entropy input management
+ * Entropy accumulation and extraction routines.
  *
- *********************************************************************/
+ * Callers may add entropy via:
+ *
+ *     static void mix_pool_bytes(const void *buf, size_t len)
+ *
+ * After which, if added entropy should be credited:
+ *
+ *     static void credit_init_bits(size_t bits)
+ *
+ * Finally, extract entropy via:
+ *
+ *     static void extract_entropy(void *buf, size_t len)
+ *
+ **********************************************************************/
 
-/* There is one of these per entropy source */
-struct timer_rand_state {
-	cycles_t last_time;
-	long last_delta, last_delta2;
+enum {
+	POOL_BITS = BLAKE2S_HASH_SIZE * 8,
+	POOL_READY_BITS = POOL_BITS, /* When crng_init->CRNG_READY */
+	POOL_EARLY_BITS = POOL_READY_BITS / 2 /* When crng_init->CRNG_EARLY */
 };
 
-#define INIT_TIMER_RAND_STATE { INITIAL_JIFFIES, };
+static struct {
+	struct blake2s_state hash;
+	spinlock_t lock;
+	unsigned int init_bits;
+} input_pool = {
+	.hash.h = { BLAKE2S_IV0 ^ (0x01010000 | BLAKE2S_HASH_SIZE),
+		    BLAKE2S_IV1, BLAKE2S_IV2, BLAKE2S_IV3, BLAKE2S_IV4,
+		    BLAKE2S_IV5, BLAKE2S_IV6, BLAKE2S_IV7 },
+	.hash.outlen = BLAKE2S_HASH_SIZE,
+	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
+};
+
+static void _mix_pool_bytes(const void *buf, size_t len)
+{
+	blake2s_update(&input_pool.hash, buf, len);
+}
 
 /*
- * Add device- or boot-specific data to the input pool to help
- * initialize it.
- *
- * None of this adds any entropy; it is meant to avoid the problem of
- * the entropy pool having similar initial state across largely
- * identical devices.
+ * This function adds bytes into the input pool. It does not
+ * update the initialization bit counter; the caller should call
+ * credit_init_bits if this is appropriate.
  */
-void add_device_randomness(const void *buf, unsigned int size)
+static void mix_pool_bytes(const void *buf, size_t len)
 {
-	unsigned long time = random_get_entropy() ^ jiffies;
 	unsigned long flags;
 
-	if (!crng_ready() && size)
-		crng_slow_load(buf, size);
-
-	trace_add_device_randomness(size, _RET_IP_);
 	spin_lock_irqsave(&input_pool.lock, flags);
-	_mix_pool_bytes(buf, size);
-	_mix_pool_bytes(&time, sizeof(time));
+	_mix_pool_bytes(buf, len);
 	spin_unlock_irqrestore(&input_pool.lock, flags);
 }
-EXPORT_SYMBOL(add_device_randomness);
-
-static struct timer_rand_state input_timer_state = INIT_TIMER_RAND_STATE;
 
 /*
- * This function adds entropy to the entropy "pool" by using timing
- * delays.  It uses the timer_rand_state structure to make an estimate
- * of how many bits of entropy this call has added to the pool.
- *
- * The number "num" is also added to the pool - it should somehow describe
- * the type of event which just happened.  This is currently 0-255 for
- * keyboard scan codes, and 256 upwards for interrupts.
- *
+ * This is an HKDF-like construction for using the hashed collected entropy
+ * as a PRF key, that's then expanded block-by-block.
  */
-static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
+static void extract_entropy(void *buf, size_t len)
 {
+	unsigned long flags;
+	u8 seed[BLAKE2S_HASH_SIZE], next_key[BLAKE2S_HASH_SIZE];
 	struct {
-		long jiffies;
-		unsigned int cycles;
-		unsigned int num;
-	} sample;
-	long delta, delta2, delta3;
-
-	sample.jiffies = jiffies;
-	sample.cycles = random_get_entropy();
-	sample.num = num;
-	mix_pool_bytes(&sample, sizeof(sample));
-
-	/*
-	 * Calculate number of bits of randomness we probably added.
-	 * We take into account the first, second and third-order deltas
-	 * in order to make our estimate.
-	 */
-	delta = sample.jiffies - READ_ONCE(state->last_time);
-	WRITE_ONCE(state->last_time, sample.jiffies);
-
-	delta2 = delta - READ_ONCE(state->last_delta);
-	WRITE_ONCE(state->last_delta, delta);
-
-	delta3 = delta2 - READ_ONCE(state->last_delta2);
-	WRITE_ONCE(state->last_delta2, delta2);
+		unsigned long rdseed[32 / sizeof(long)];
+		size_t counter;
+	} block;
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(block.rdseed); ++i) {
+		if (!arch_get_random_seed_long(&block.rdseed[i]) &&
+		    !arch_get_random_long(&block.rdseed[i]))
+			block.rdseed[i] = random_get_entropy();
+	}
 
-	if (delta < 0)
-		delta = -delta;
-	if (delta2 < 0)
-		delta2 = -delta2;
-	if (delta3 < 0)
-		delta3 = -delta3;
-	if (delta > delta2)
-		delta = delta2;
-	if (delta > delta3)
-		delta = delta3;
+	spin_lock_irqsave(&input_pool.lock, flags);
 
-	/*
-	 * delta is now minimum absolute delta.
-	 * Round down by 1 bit on general principles,
-	 * and limit entropy estimate to 12 bits.
-	 */
-	credit_entropy_bits(min_t(int, fls(delta >> 1), 11));
-}
+	/* seed = HASHPRF(last_key, entropy_input) */
+	blake2s_final(&input_pool.hash, seed);
 
-void add_input_randomness(unsigned int type, unsigned int code,
-			  unsigned int value)
-{
-	static unsigned char last_value;
+	/* next_key = HASHPRF(seed, RDSEED || 0) */
+	block.counter = 0;
+	blake2s(next_key, (u8 *)&block, seed, sizeof(next_key), sizeof(block), sizeof(seed));
+	blake2s_init_key(&input_pool.hash, BLAKE2S_HASH_SIZE, next_key, sizeof(next_key));
 
-	/* ignore autorepeat and the like */
-	if (value == last_value)
-		return;
+	spin_unlock_irqrestore(&input_pool.lock, flags);
+	memzero_explicit(next_key, sizeof(next_key));
+
+	while (len) {
+		i = min_t(size_t, len, BLAKE2S_HASH_SIZE);
+		/* output = HASHPRF(seed, RDSEED || ++counter) */
+		++block.counter;
+		blake2s(buf, (u8 *)&block, seed, i, sizeof(block), sizeof(seed));
+		len -= i;
+		buf += i;
+	}
 
-	last_value = value;
-	add_timer_randomness(&input_timer_state,
-			     (type << 4) ^ code ^ (code >> 4) ^ value);
-	trace_add_input_randomness(POOL_ENTROPY_BITS());
+	memzero_explicit(seed, sizeof(seed));
+	memzero_explicit(&block, sizeof(block));
 }
-EXPORT_SYMBOL_GPL(add_input_randomness);
-
-static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
 
-#ifdef ADD_INTERRUPT_BENCH
-static unsigned long avg_cycles, avg_deviation;
+#define credit_init_bits(bits) if (!crng_ready()) _credit_init_bits(bits)
 
-#define AVG_SHIFT 8 /* Exponential average factor k=1/256 */
-#define FIXED_1_2 (1 << (AVG_SHIFT - 1))
-
-static void add_interrupt_bench(cycles_t start)
+static void __cold _credit_init_bits(size_t bits)
 {
-	long delta = random_get_entropy() - start;
-
-	/* Use a weighted moving average */
-	delta = delta - ((avg_cycles + FIXED_1_2) >> AVG_SHIFT);
-	avg_cycles += delta;
-	/* And average deviation */
-	delta = abs(delta) - ((avg_deviation + FIXED_1_2) >> AVG_SHIFT);
-	avg_deviation += delta;
-}
-#else
-#define add_interrupt_bench(x)
-#endif
+	static struct execute_work set_ready;
+	unsigned int new, orig, add;
+	unsigned long flags;
 
-static u32 get_reg(struct fast_pool *f, struct pt_regs *regs)
-{
-	u32 *ptr = (u32 *)regs;
-	unsigned int idx;
+	if (!bits)
+		return;
 
-	if (regs == NULL)
-		return 0;
-	idx = READ_ONCE(f->reg_idx);
-	if (idx >= sizeof(struct pt_regs) / sizeof(u32))
-		idx = 0;
-	ptr += idx++;
-	WRITE_ONCE(f->reg_idx, idx);
-	return *ptr;
-}
+	add = min_t(size_t, bits, POOL_BITS);
 
-void add_interrupt_randomness(int irq)
-{
-	struct fast_pool *fast_pool = this_cpu_ptr(&irq_randomness);
-	struct pt_regs *regs = get_irq_regs();
-	unsigned long now = jiffies;
-	cycles_t cycles = random_get_entropy();
-	u32 c_high, j_high;
-	u64 ip;
-
-	if (cycles == 0)
-		cycles = get_reg(fast_pool, regs);
-	c_high = (sizeof(cycles) > 4) ? cycles >> 32 : 0;
-	j_high = (sizeof(now) > 4) ? now >> 32 : 0;
-	fast_pool->pool[0] ^= cycles ^ j_high ^ irq;
-	fast_pool->pool[1] ^= now ^ c_high;
-	ip = regs ? instruction_pointer(regs) : _RET_IP_;
-	fast_pool->pool[2] ^= ip;
-	fast_pool->pool[3] ^=
-		(sizeof(ip) > 4) ? ip >> 32 : get_reg(fast_pool, regs);
-
-	fast_mix(fast_pool);
-	add_interrupt_bench(cycles);
-
-	if (unlikely(crng_init == 0)) {
-		if ((fast_pool->count >= 64) &&
-		    crng_fast_load((u8 *)fast_pool->pool, sizeof(fast_pool->pool)) > 0) {
-			fast_pool->count = 0;
-			fast_pool->last = now;
+	do {
+		orig = READ_ONCE(input_pool.init_bits);
+		new = min_t(unsigned int, POOL_BITS, orig + add);
+	} while (cmpxchg(&input_pool.init_bits, orig, new) != orig);
+
+	if (orig < POOL_READY_BITS && new >= POOL_READY_BITS) {
+		crng_reseed(); /* Sets crng_init to CRNG_READY under base_crng.lock. */
+		execute_in_process_context(crng_set_ready, &set_ready);
+		process_random_ready_list();
+		wake_up_interruptible(&crng_init_wait);
+		kill_fasync(&fasync, SIGIO, POLL_IN);
+		pr_notice("crng init done\n");
+		if (urandom_warning.missed)
+			pr_notice("%d urandom warning(s) missed due to ratelimiting\n",
+				  urandom_warning.missed);
+	} else if (orig < POOL_EARLY_BITS && new >= POOL_EARLY_BITS) {
+		spin_lock_irqsave(&base_crng.lock, flags);
+		/* Check if crng_init is CRNG_EMPTY, to avoid race with crng_reseed(). */
+		if (crng_init == CRNG_EMPTY) {
+			extract_entropy(base_crng.key, sizeof(base_crng.key));
+			crng_init = CRNG_EARLY;
 		}
-		return;
+		spin_unlock_irqrestore(&base_crng.lock, flags);
 	}
+}
 
-	if ((fast_pool->count < 64) && !time_after(now, fast_pool->last + HZ))
-		return;
-
-	if (!spin_trylock(&input_pool.lock))
-		return;
-
-	fast_pool->last = now;
-	__mix_pool_bytes(&fast_pool->pool, sizeof(fast_pool->pool));
-	spin_unlock(&input_pool.lock);
 
-	fast_pool->count = 0;
+/**********************************************************************
+ *
+ * Entropy collection routines.
+ *
+ * The following exported functions are used for pushing entropy into
+ * the above entropy accumulation routines:
+ *
+ *	void add_device_randomness(const void *buf, size_t len);
+ *	void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy);
+ *	void add_bootloader_randomness(const void *buf, size_t len);
+ *	void add_interrupt_randomness(int irq);
+ *	void add_input_randomness(unsigned int type, unsigned int code, unsigned int value);
+ *	void add_disk_randomness(struct gendisk *disk);
+ *
+ * add_device_randomness() adds data to the input pool that
+ * is likely to differ between two devices (or possibly even per boot).
+ * This would be things like MAC addresses or serial numbers, or the
+ * read-out of the RTC. This does *not* credit any actual entropy to
+ * the pool, but it initializes the pool to different values for devices
+ * that might otherwise be identical and have very little entropy
+ * available to them (particularly common in the embedded world).
+ *
+ * add_hwgenerator_randomness() is for true hardware RNGs, and will credit
+ * entropy as specified by the caller. If the entropy pool is full it will
+ * block until more entropy is needed.
+ *
+ * add_bootloader_randomness() is called by bootloader drivers, such as EFI
+ * and device tree, and credits its input depending on whether or not the
+ * configuration option CONFIG_RANDOM_TRUST_BOOTLOADER is set.
+ *
+ * add_interrupt_randomness() uses the interrupt timing as random
+ * inputs to the entropy pool. Using the cycle counters and the irq source
+ * as inputs, it feeds the input pool roughly once a second or after 64
+ * interrupts, crediting 1 bit of entropy for whichever comes first.
+ *
+ * add_input_randomness() uses the input layer interrupt timing, as well
+ * as the event type information from the hardware.
+ *
+ * add_disk_randomness() uses what amounts to the seek time of block
+ * layer request events, on a per-disk_devt basis, as input to the
+ * entropy pool. Note that high-speed solid state drives with very low
+ * seek times do not make for good sources of entropy, as their seek
+ * times are usually fairly consistent.
+ *
+ * The last two routines try to estimate how many bits of entropy
+ * to credit. They do this by keeping track of the first and second
+ * order deltas of the event timings.
+ *
+ **********************************************************************/
 
-	/* award one bit for the contents of the fast pool */
-	credit_entropy_bits(1);
+static bool trust_cpu __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
+static bool trust_bootloader __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_BOOTLOADER);
+static int __init parse_trust_cpu(char *arg)
+{
+	return kstrtobool(arg, &trust_cpu);
 }
-EXPORT_SYMBOL_GPL(add_interrupt_randomness);
-
-#ifdef CONFIG_BLOCK
-void add_disk_randomness(struct gendisk *disk)
+static int __init parse_trust_bootloader(char *arg)
 {
-	if (!disk || !disk->random)
-		return;
-	/* first major is 1, so we get >= 0x200 here */
-	add_timer_randomness(disk->random, 0x100 + disk_devt(disk));
-	trace_add_disk_randomness(disk_devt(disk), POOL_ENTROPY_BITS());
+	return kstrtobool(arg, &trust_bootloader);
 }
-EXPORT_SYMBOL_GPL(add_disk_randomness);
-#endif
-
-/*********************************************************************
- *
- * Entropy extraction routines
- *
- *********************************************************************/
+early_param("random.trust_cpu", parse_trust_cpu);
+early_param("random.trust_bootloader", parse_trust_bootloader);
 
 /*
- * This function decides how many bytes to actually take from the
- * given pool, and also debits the entropy count accordingly.
+ * The first collection of entropy occurs at system boot while interrupts
+ * are still turned off. Here we push in latent entropy, RDSEED, a timestamp,
+ * utsname(), and the command line. Depending on the above configuration knob,
+ * RDSEED may be considered sufficient for initialization. Note that much
+ * earlier setup may already have pushed entropy into the input pool by the
+ * time we get here.
  */
-static size_t account(size_t nbytes, int min)
+int __init random_init(const char *command_line)
 {
-	int entropy_count, orig;
-	size_t ibytes, nfrac;
+	ktime_t now = ktime_get_real();
+	unsigned int i, arch_bytes;
+	unsigned long entropy;
 
-	BUG_ON(input_pool.entropy_count > POOL_FRACBITS);
+#if defined(LATENT_ENTROPY_PLUGIN)
+	static const u8 compiletime_seed[BLAKE2S_BLOCK_SIZE] __initconst __latent_entropy;
+	_mix_pool_bytes(compiletime_seed, sizeof(compiletime_seed));
+#endif
 
-	/* Can we pull enough? */
-retry:
-	entropy_count = orig = READ_ONCE(input_pool.entropy_count);
-	if (WARN_ON(entropy_count < 0)) {
-		pr_warn("negative entropy count: count %d\n", entropy_count);
-		entropy_count = 0;
+	for (i = 0, arch_bytes = BLAKE2S_BLOCK_SIZE;
+	     i < BLAKE2S_BLOCK_SIZE; i += sizeof(entropy)) {
+		if (!arch_get_random_seed_long_early(&entropy) &&
+		    !arch_get_random_long_early(&entropy)) {
+			entropy = random_get_entropy();
+			arch_bytes -= sizeof(entropy);
+		}
+		_mix_pool_bytes(&entropy, sizeof(entropy));
 	}
+	_mix_pool_bytes(&now, sizeof(now));
+	_mix_pool_bytes(utsname(), sizeof(*(utsname())));
+	_mix_pool_bytes(command_line, strlen(command_line));
+	add_latent_entropy();
 
-	/* never pull more than available */
-	ibytes = min_t(size_t, nbytes, entropy_count >> (POOL_ENTROPY_SHIFT + 3));
-	if (ibytes < min)
-		ibytes = 0;
-	nfrac = ibytes << (POOL_ENTROPY_SHIFT + 3);
-	if ((size_t)entropy_count > nfrac)
-		entropy_count -= nfrac;
-	else
-		entropy_count = 0;
-
-	if (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig)
-		goto retry;
-
-	trace_debit_entropy(8 * ibytes);
-	if (ibytes && POOL_ENTROPY_BITS() < random_write_wakeup_bits) {
-		wake_up_interruptible(&random_write_wait);
-		kill_fasync(&fasync, SIGIO, POLL_OUT);
-	}
+	if (crng_ready())
+		crng_reseed();
+	else if (trust_cpu)
+		credit_init_bits(arch_bytes * 8);
 
-	return ibytes;
+	return 0;
 }
 
 /*
- * This function does the actual extraction for extract_entropy.
+ * Add device- or boot-specific data to the input pool to help
+ * initialize it.
  *
- * Note: we assume that .poolwords is a multiple of 16 words.
+ * None of this adds any entropy; it is meant to avoid the problem of
+ * the entropy pool having similar initial state across largely
+ * identical devices.
  */
-static void extract_buf(u8 *out)
+void add_device_randomness(const void *buf, size_t len)
 {
-	struct blake2s_state state __aligned(__alignof__(unsigned long));
-	u8 hash[BLAKE2S_HASH_SIZE];
-	unsigned long *salt;
+	unsigned long entropy = random_get_entropy();
 	unsigned long flags;
 
-	blake2s_init(&state, sizeof(hash));
-
-	/*
-	 * If we have an architectural hardware random number
-	 * generator, use it for BLAKE2's salt & personal fields.
-	 */
-	for (salt = (unsigned long *)&state.h[4];
-	     salt < (unsigned long *)&state.h[8]; ++salt) {
-		unsigned long v;
-		if (!arch_get_random_long(&v))
-			break;
-		*salt ^= v;
-	}
-
-	/* Generate a hash across the pool */
 	spin_lock_irqsave(&input_pool.lock, flags);
-	blake2s_update(&state, (const u8 *)input_pool_data, POOL_BYTES);
-	blake2s_final(&state, hash); /* final zeros out state */
-
-	/*
-	 * We mix the hash back into the pool to prevent backtracking
-	 * attacks (where the attacker knows the state of the pool
-	 * plus the current outputs, and attempts to find previous
-	 * outputs), unless the hash function can be inverted. By
-	 * mixing at least a hash worth of hash data back, we make
-	 * brute-forcing the feedback as hard as brute-forcing the
-	 * hash.
-	 */
-	__mix_pool_bytes(hash, sizeof(hash));
+	_mix_pool_bytes(&entropy, sizeof(entropy));
+	_mix_pool_bytes(buf, len);
 	spin_unlock_irqrestore(&input_pool.lock, flags);
-
-	/* Note that EXTRACT_SIZE is half of hash size here, because above
-	 * we've dumped the full length back into mixer. By reducing the
-	 * amount that we emit, we retain a level of forward secrecy.
-	 */
-	memcpy(out, hash, EXTRACT_SIZE);
-	memzero_explicit(hash, sizeof(hash));
 }
+EXPORT_SYMBOL(add_device_randomness);
 
-static ssize_t _extract_entropy(void *buf, size_t nbytes)
+/*
+ * Interface for in-kernel drivers of true hardware RNGs.
+ * Those devices may produce endless random bits and will be throttled
+ * when our pool is full.
+ */
+void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy)
 {
-	ssize_t ret = 0, i;
-	u8 tmp[EXTRACT_SIZE];
-
-	while (nbytes) {
-		extract_buf(tmp);
-		i = min_t(int, nbytes, EXTRACT_SIZE);
-		memcpy(buf, tmp, i);
-		nbytes -= i;
-		buf += i;
-		ret += i;
-	}
+	mix_pool_bytes(buf, len);
+	credit_init_bits(entropy);
 
-	/* Wipe data just returned from memory */
-	memzero_explicit(tmp, sizeof(tmp));
-
-	return ret;
+	/*
+	 * Throttle writing to once every CRNG_RESEED_INTERVAL, unless
+	 * we're not yet initialized.
+	 */
+	if (!kthread_should_stop() && crng_ready())
+		schedule_timeout_interruptible(CRNG_RESEED_INTERVAL);
 }
+EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
 
 /*
- * This function extracts randomness from the "entropy pool", and
- * returns it in a buffer.
- *
- * The min parameter specifies the minimum amount we can pull before
- * failing to avoid races that defeat catastrophic reseeding.
+ * Handle random seed passed by bootloader, and credit it if
+ * CONFIG_RANDOM_TRUST_BOOTLOADER is set.
  */
-static ssize_t extract_entropy(void *buf, size_t nbytes, int min)
+void __cold add_bootloader_randomness(const void *buf, size_t len)
 {
-	trace_extract_entropy(nbytes, POOL_ENTROPY_BITS(), _RET_IP_);
-	nbytes = account(nbytes, min);
-	return _extract_entropy(buf, nbytes);
+	mix_pool_bytes(buf, len);
+	if (trust_bootloader)
+		credit_init_bits(len * 8);
 }
+EXPORT_SYMBOL_GPL(add_bootloader_randomness);
 
-#define warn_unseeded_randomness(previous) \
-	_warn_unseeded_randomness(__func__, (void *)_RET_IP_, (previous))
+struct fast_pool {
+	struct work_struct mix;
+	unsigned long pool[4];
+	unsigned long last;
+	unsigned int count;
+};
 
-static void _warn_unseeded_randomness(const char *func_name, void *caller, void **previous)
-{
-#ifdef CONFIG_WARN_ALL_UNSEEDED_RANDOM
-	const bool print_once = false;
+static DEFINE_PER_CPU(struct fast_pool, irq_randomness) = {
+#ifdef CONFIG_64BIT
+#define FASTMIX_PERM SIPHASH_PERMUTATION
+	.pool = { SIPHASH_CONST_0, SIPHASH_CONST_1, SIPHASH_CONST_2, SIPHASH_CONST_3 }
 #else
-	static bool print_once __read_mostly;
-#endif
-
-	if (print_once || crng_ready() ||
-	    (previous && (caller == READ_ONCE(*previous))))
-		return;
-	WRITE_ONCE(*previous, caller);
-#ifndef CONFIG_WARN_ALL_UNSEEDED_RANDOM
-	print_once = true;
+#define FASTMIX_PERM HSIPHASH_PERMUTATION
+	.pool = { HSIPHASH_CONST_0, HSIPHASH_CONST_1, HSIPHASH_CONST_2, HSIPHASH_CONST_3 }
 #endif
-	if (__ratelimit(&unseeded_warning))
-		printk_deferred(KERN_NOTICE "random: %s called from %pS with crng_init=%d\n",
-				func_name, caller, crng_init);
-}
+};
 
 /*
- * This function is the exported kernel interface.  It returns some
- * number of good random numbers, suitable for key generation, seeding
- * TCP sequence numbers, etc.  It does not rely on the hardware random
- * number generator.  For random bytes direct from the hardware RNG
- * (when available), use get_random_bytes_arch(). In order to ensure
- * that the randomness provided by this function is okay, the function
- * wait_for_random_bytes() should be called and return 0 at least once
- * at any point prior.
+ * This is [Half]SipHash-1-x, starting from an empty key. Because
+ * the key is fixed, it assumes that its inputs are non-malicious,
+ * and therefore this has no security on its own. s represents the
+ * four-word SipHash state, while v represents a two-word input.
  */
-static void _get_random_bytes(void *buf, int nbytes)
-{
-	u8 tmp[CHACHA_BLOCK_SIZE] __aligned(4);
-
-	trace_get_random_bytes(nbytes, _RET_IP_);
-
-	while (nbytes >= CHACHA_BLOCK_SIZE) {
-		extract_crng(buf);
-		buf += CHACHA_BLOCK_SIZE;
-		nbytes -= CHACHA_BLOCK_SIZE;
-	}
-
-	if (nbytes > 0) {
-		extract_crng(tmp);
-		memcpy(buf, tmp, nbytes);
-		crng_backtrack_protect(tmp, nbytes);
-	} else
-		crng_backtrack_protect(tmp, CHACHA_BLOCK_SIZE);
-	memzero_explicit(tmp, sizeof(tmp));
-}
-
-void get_random_bytes(void *buf, int nbytes)
+static void fast_mix(unsigned long s[4], unsigned long v1, unsigned long v2)
 {
-	static void *previous;
-
-	warn_unseeded_randomness(&previous);
-	_get_random_bytes(buf, nbytes);
+	s[3] ^= v1;
+	FASTMIX_PERM(s[0], s[1], s[2], s[3]);
+	s[0] ^= v1;
+	s[3] ^= v2;
+	FASTMIX_PERM(s[0], s[1], s[2], s[3]);
+	s[0] ^= v2;
 }
-EXPORT_SYMBOL(get_random_bytes);
 
+#ifdef CONFIG_SMP
 /*
- * Each time the timer fires, we expect that we got an unpredictable
- * jump in the cycle counter. Even if the timer is running on another
- * CPU, the timer activity will be touching the stack of the CPU that is
- * generating entropy..
- *
- * Note that we don't re-arm the timer in the timer itself - we are
- * happy to be scheduled away, since that just makes the load more
- * complex, but we do not want the timer to keep ticking unless the
- * entropy loop is running.
- *
- * So the re-arming always happens in the entropy loop itself.
+ * This function is called when the CPU has just come online, with
+ * entry CPUHP_AP_RANDOM_ONLINE, just after CPUHP_AP_WORKQUEUE_ONLINE.
  */
-static void entropy_timer(struct timer_list *t)
+int __cold random_online_cpu(unsigned int cpu)
 {
-	credit_entropy_bits(1);
+	/*
+	 * During CPU shutdown and before CPU onlining, add_interrupt_
+	 * randomness() may schedule mix_interrupt_randomness(), and
+	 * set the MIX_INFLIGHT flag. However, because the worker can
+	 * be scheduled on a different CPU during this period, that
+	 * flag will never be cleared. For that reason, we zero out
+	 * the flag here, which runs just after workqueues are onlined
+	 * for the CPU again. This also has the effect of setting the
+	 * irq randomness count to zero so that new accumulated irqs
+	 * are fresh.
+	 */
+	per_cpu_ptr(&irq_randomness, cpu)->count = 0;
+	return 0;
 }
+#endif
 
-/*
- * If we have an actual cycle counter, see if we can
- * generate enough entropy with timing noise
- */
-static void try_to_generate_entropy(void)
+static void mix_interrupt_randomness(struct work_struct *work)
 {
-	struct {
-		unsigned long now;
-		struct timer_list timer;
-	} stack;
-
-	stack.now = random_get_entropy();
+	struct fast_pool *fast_pool = container_of(work, struct fast_pool, mix);
+	/*
+	 * The size of the copied stack pool is explicitly 2 longs so that we
+	 * only ever ingest half of the siphash output each time, retaining
+	 * the other half as the next "key" that carries over. The entropy is
+	 * supposed to be sufficiently dispersed between bits so on average
+	 * we don't wind up "losing" some.
+	 */
+	unsigned long pool[2];
+	unsigned int count;
 
-	/* Slow counter - or none. Don't even bother */
-	if (stack.now == random_get_entropy())
+	/* Check to see if we're running on the wrong CPU due to hotplug. */
+	local_irq_disable();
+	if (fast_pool != this_cpu_ptr(&irq_randomness)) {
+		local_irq_enable();
 		return;
-
-	timer_setup_on_stack(&stack.timer, entropy_timer, 0);
-	while (!crng_ready()) {
-		if (!timer_pending(&stack.timer))
-			mod_timer(&stack.timer, jiffies + 1);
-		mix_pool_bytes(&stack.now, sizeof(stack.now));
-		schedule();
-		stack.now = random_get_entropy();
 	}
 
-	del_timer_sync(&stack.timer);
-	destroy_timer_on_stack(&stack.timer);
-	mix_pool_bytes(&stack.now, sizeof(stack.now));
-}
-
-/*
- * Wait for the urandom pool to be seeded and thus guaranteed to supply
- * cryptographically secure random numbers. This applies to: the /dev/urandom
- * device, the get_random_bytes function, and the get_random_{u32,u64,int,long}
- * family of functions. Using any of these functions without first calling
- * this function forfeits the guarantee of security.
- *
- * Returns: 0 if the urandom pool has been seeded.
- *          -ERESTARTSYS if the function was interrupted by a signal.
- */
-int wait_for_random_bytes(void)
-{
-	if (likely(crng_ready()))
-		return 0;
-
-	do {
-		int ret;
-		ret = wait_event_interruptible_timeout(crng_init_wait, crng_ready(), HZ);
-		if (ret)
-			return ret > 0 ? 0 : ret;
+	/*
+	 * Copy the pool to the stack so that the mixer always has a
+	 * consistent view, before we reenable irqs again.
+	 */
+	memcpy(pool, fast_pool->pool, sizeof(pool));
+	count = fast_pool->count;
+	fast_pool->count = 0;
+	fast_pool->last = jiffies;
+	local_irq_enable();
 
-		try_to_generate_entropy();
-	} while (!crng_ready());
+	mix_pool_bytes(pool, sizeof(pool));
+	credit_init_bits(max(1u, (count & U16_MAX) / 64));
 
-	return 0;
+	memzero_explicit(pool, sizeof(pool));
 }
-EXPORT_SYMBOL(wait_for_random_bytes);
 
-/*
- * Returns whether or not the urandom pool has been seeded and thus guaranteed
- * to supply cryptographically secure random numbers. This applies to: the
- * /dev/urandom device, the get_random_bytes function, and the get_random_{u32,
- * ,u64,int,long} family of functions.
- *
- * Returns: true if the urandom pool has been seeded.
- *          false if the urandom pool has not been seeded.
- */
-bool rng_is_initialized(void)
-{
-	return crng_ready();
-}
-EXPORT_SYMBOL(rng_is_initialized);
-
-/*
- * Add a callback function that will be invoked when the nonblocking
- * pool is initialised.
- *
- * returns: 0 if callback is successfully added
- *	    -EALREADY if pool is already initialised (callback not called)
- *	    -ENOENT if module for callback is not alive
- */
-int add_random_ready_callback(struct random_ready_callback *rdy)
+void add_interrupt_randomness(int irq)
 {
-	struct module *owner;
-	unsigned long flags;
-	int err = -EALREADY;
-
-	if (crng_ready())
-		return err;
-
-	owner = rdy->owner;
-	if (!try_module_get(owner))
-		return -ENOENT;
-
-	spin_lock_irqsave(&random_ready_list_lock, flags);
-	if (crng_ready())
-		goto out;
-
-	owner = NULL;
+	enum { MIX_INFLIGHT = 1U << 31 };
+	unsigned long entropy = random_get_entropy();
+	struct fast_pool *fast_pool = this_cpu_ptr(&irq_randomness);
+	struct pt_regs *regs = get_irq_regs();
+	unsigned int new_count;
 
-	list_add(&rdy->list, &random_ready_list);
-	err = 0;
+	fast_mix(fast_pool->pool, entropy,
+		 (regs ? instruction_pointer(regs) : _RET_IP_) ^ swab(irq));
+	new_count = ++fast_pool->count;
 
-out:
-	spin_unlock_irqrestore(&random_ready_list_lock, flags);
+	if (new_count & MIX_INFLIGHT)
+		return;
 
-	module_put(owner);
+	if (new_count < 64 && !time_is_before_jiffies(fast_pool->last + HZ))
+		return;
 
-	return err;
+	if (unlikely(!fast_pool->mix.func))
+		INIT_WORK(&fast_pool->mix, mix_interrupt_randomness);
+	fast_pool->count |= MIX_INFLIGHT;
+	queue_work_on(raw_smp_processor_id(), system_highpri_wq, &fast_pool->mix);
 }
-EXPORT_SYMBOL(add_random_ready_callback);
+EXPORT_SYMBOL_GPL(add_interrupt_randomness);
+
+/* There is one of these per entropy source */
+struct timer_rand_state {
+	unsigned long last_time;
+	long last_delta, last_delta2;
+};
 
 /*
- * Delete a previously registered readiness callback function.
+ * This function adds entropy to the entropy "pool" by using timing
+ * delays. It uses the timer_rand_state structure to make an estimate
+ * of how many bits of entropy this call has added to the pool. The
+ * value "num" is also added to the pool; it should somehow describe
+ * the type of event that just happened.
  */
-void del_random_ready_callback(struct random_ready_callback *rdy)
+static void add_timer_randomness(struct timer_rand_state *state, unsigned int num)
 {
-	unsigned long flags;
-	struct module *owner = NULL;
+	unsigned long entropy = random_get_entropy(), now = jiffies, flags;
+	long delta, delta2, delta3;
+	unsigned int bits;
 
-	spin_lock_irqsave(&random_ready_list_lock, flags);
-	if (!list_empty(&rdy->list)) {
-		list_del_init(&rdy->list);
-		owner = rdy->owner;
+	/*
+	 * If we're in a hard IRQ, add_interrupt_randomness() will be called
+	 * sometime after, so mix into the fast pool.
+	 */
+	if (in_hardirq()) {
+		fast_mix(this_cpu_ptr(&irq_randomness)->pool, entropy, num);
+	} else {
+		spin_lock_irqsave(&input_pool.lock, flags);
+		_mix_pool_bytes(&entropy, sizeof(entropy));
+		_mix_pool_bytes(&num, sizeof(num));
+		spin_unlock_irqrestore(&input_pool.lock, flags);
 	}
-	spin_unlock_irqrestore(&random_ready_list_lock, flags);
 
-	module_put(owner);
-}
-EXPORT_SYMBOL(del_random_ready_callback);
+	if (crng_ready())
+		return;
 
-/*
- * This function will use the architecture-specific hardware random
- * number generator if it is available.  The arch-specific hw RNG will
- * almost certainly be faster than what we can do in software, but it
- * is impossible to verify that it is implemented securely (as
- * opposed, to, say, the AES encryption of a sequence number using a
- * key known by the NSA).  So it's useful if we need the speed, but
- * only if we're willing to trust the hardware manufacturer not to
- * have put in a back door.
- *
- * Return number of bytes filled in.
- */
-int __must_check get_random_bytes_arch(void *buf, int nbytes)
-{
-	int left = nbytes;
-	u8 *p = buf;
+	/*
+	 * Calculate number of bits of randomness we probably added.
+	 * We take into account the first, second and third-order deltas
+	 * in order to make our estimate.
+	 */
+	delta = now - READ_ONCE(state->last_time);
+	WRITE_ONCE(state->last_time, now);
+
+	delta2 = delta - READ_ONCE(state->last_delta);
+	WRITE_ONCE(state->last_delta, delta);
 
-	trace_get_random_bytes_arch(left, _RET_IP_);
-	while (left) {
-		unsigned long v;
-		int chunk = min_t(int, left, sizeof(unsigned long));
+	delta3 = delta2 - READ_ONCE(state->last_delta2);
+	WRITE_ONCE(state->last_delta2, delta2);
 
-		if (!arch_get_random_long(&v))
-			break;
+	if (delta < 0)
+		delta = -delta;
+	if (delta2 < 0)
+		delta2 = -delta2;
+	if (delta3 < 0)
+		delta3 = -delta3;
+	if (delta > delta2)
+		delta = delta2;
+	if (delta > delta3)
+		delta = delta3;
 
-		memcpy(p, &v, chunk);
-		p += chunk;
-		left -= chunk;
-	}
+	/*
+	 * delta is now minimum absolute delta. Round down by 1 bit
+	 * on general principles, and limit entropy estimate to 11 bits.
+	 */
+	bits = min(fls(delta >> 1), 11);
 
-	return nbytes - left;
+	/*
+	 * As mentioned above, if we're in a hard IRQ, add_interrupt_randomness()
+	 * will run after this, which uses a different crediting scheme of 1 bit
+	 * per every 64 interrupts. In order to let that function do accounting
+	 * close to the one in this function, we credit a full 64/64 bit per bit,
+	 * and then subtract one to account for the extra one added.
+	 */
+	if (in_hardirq())
+		this_cpu_ptr(&irq_randomness)->count += max(1u, bits * 64) - 1;
+	else
+		_credit_init_bits(bits);
 }
-EXPORT_SYMBOL(get_random_bytes_arch);
 
-/*
- * init_std_data - initialize pool with system data
- *
- * This function clears the pool's entropy count and mixes some system
- * data into the pool to prepare it for use. The pool is not cleared
- * as that can only decrease the entropy in the pool.
- */
-static void __init init_std_data(void)
+void add_input_randomness(unsigned int type, unsigned int code, unsigned int value)
 {
-	int i;
-	ktime_t now = ktime_get_real();
-	unsigned long rv;
-
-	mix_pool_bytes(&now, sizeof(now));
-	for (i = POOL_BYTES; i > 0; i -= sizeof(rv)) {
-		if (!arch_get_random_seed_long(&rv) &&
-		    !arch_get_random_long(&rv))
-			rv = random_get_entropy();
-		mix_pool_bytes(&rv, sizeof(rv));
-	}
-	mix_pool_bytes(utsname(), sizeof(*(utsname())));
+	static unsigned char last_value;
+	static struct timer_rand_state input_timer_state = { INITIAL_JIFFIES };
+
+	/* Ignore autorepeat and the like. */
+	if (value == last_value)
+		return;
+
+	last_value = value;
+	add_timer_randomness(&input_timer_state,
+			     (type << 4) ^ code ^ (code >> 4) ^ value);
 }
+EXPORT_SYMBOL_GPL(add_input_randomness);
 
-/*
- * Note that setup_arch() may call add_device_randomness()
- * long before we get here. This allows seeding of the pools
- * with some platform dependent data very early in the boot
- * process. But it limits our options here. We must use
- * statically allocated structures that already have all
- * initializations complete at compile time. We should also
- * take care not to overwrite the precious per platform data
- * we were given.
- */
-int __init rand_initialize(void)
+#ifdef CONFIG_BLOCK
+void add_disk_randomness(struct gendisk *disk)
 {
-	init_std_data();
-	if (crng_need_final_init)
-		crng_finalize_init();
-	crng_initialize_primary();
-	crng_global_init_time = jiffies;
-	if (ratelimit_disable) {
-		urandom_warning.interval = 0;
-		unseeded_warning.interval = 0;
-	}
-	return 0;
+	if (!disk || !disk->random)
+		return;
+	/* First major is 1, so we get >= 0x200 here. */
+	add_timer_randomness(disk->random, 0x100 + disk_devt(disk));
 }
+EXPORT_SYMBOL_GPL(add_disk_randomness);
 
-#ifdef CONFIG_BLOCK
-void rand_initialize_disk(struct gendisk *disk)
+void __cold rand_initialize_disk(struct gendisk *disk)
 {
 	struct timer_rand_state *state;
 
@@ -1724,109 +1139,189 @@ void rand_initialize_disk(struct gendisk *disk)
 }
 #endif
 
-static ssize_t urandom_read_nowarn(struct file *file, char __user *buf,
-				   size_t nbytes, loff_t *ppos)
+/*
+ * Each time the timer fires, we expect that we got an unpredictable
+ * jump in the cycle counter. Even if the timer is running on another
+ * CPU, the timer activity will be touching the stack of the CPU that is
+ * generating entropy..
+ *
+ * Note that we don't re-arm the timer in the timer itself - we are
+ * happy to be scheduled away, since that just makes the load more
+ * complex, but we do not want the timer to keep ticking unless the
+ * entropy loop is running.
+ *
+ * So the re-arming always happens in the entropy loop itself.
+ */
+static void __cold entropy_timer(struct timer_list *t)
 {
-	int ret;
-
-	nbytes = min_t(size_t, nbytes, INT_MAX >> (POOL_ENTROPY_SHIFT + 3));
-	ret = extract_crng_user(buf, nbytes);
-	trace_urandom_read(8 * nbytes, 0, POOL_ENTROPY_BITS());
-	return ret;
+	credit_init_bits(1);
 }
 
-static ssize_t urandom_read(struct file *file, char __user *buf, size_t nbytes,
-			    loff_t *ppos)
+/*
+ * If we have an actual cycle counter, see if we can
+ * generate enough entropy with timing noise
+ */
+static void __cold try_to_generate_entropy(void)
 {
-	static int maxwarn = 10;
+	struct {
+		unsigned long entropy;
+		struct timer_list timer;
+	} stack;
+
+	stack.entropy = random_get_entropy();
+
+	/* Slow counter - or none. Don't even bother */
+	if (stack.entropy == random_get_entropy())
+		return;
 
-	if (!crng_ready() && maxwarn > 0) {
-		maxwarn--;
-		if (__ratelimit(&urandom_warning))
-			pr_notice("%s: uninitialized urandom read (%zd bytes read)\n",
-				  current->comm, nbytes);
+	timer_setup_on_stack(&stack.timer, entropy_timer, 0);
+	while (!crng_ready() && !signal_pending(current)) {
+		if (!timer_pending(&stack.timer))
+			mod_timer(&stack.timer, jiffies + 1);
+		mix_pool_bytes(&stack.entropy, sizeof(stack.entropy));
+		schedule();
+		stack.entropy = random_get_entropy();
 	}
 
-	return urandom_read_nowarn(file, buf, nbytes, ppos);
+	del_timer_sync(&stack.timer);
+	destroy_timer_on_stack(&stack.timer);
+	mix_pool_bytes(&stack.entropy, sizeof(stack.entropy));
 }
 
-static ssize_t random_read(struct file *file, char __user *buf, size_t nbytes,
-			   loff_t *ppos)
+
+/**********************************************************************
+ *
+ * Userspace reader/writer interfaces.
+ *
+ * getrandom(2) is the primary modern interface into the RNG and should
+ * be used in preference to anything else.
+ *
+ * Reading from /dev/random has the same functionality as calling
+ * getrandom(2) with flags=0. In earlier versions, however, it had
+ * vastly different semantics and should therefore be avoided, to
+ * prevent backwards compatibility issues.
+ *
+ * Reading from /dev/urandom has the same functionality as calling
+ * getrandom(2) with flags=GRND_INSECURE. Because it does not block
+ * waiting for the RNG to be ready, it should not be used.
+ *
+ * Writing to either /dev/random or /dev/urandom adds entropy to
+ * the input pool but does not credit it.
+ *
+ * Polling on /dev/random indicates when the RNG is initialized, on
+ * the read side, and when it wants new entropy, on the write side.
+ *
+ * Both /dev/random and /dev/urandom have the same set of ioctls for
+ * adding entropy, getting the entropy count, zeroing the count, and
+ * reseeding the crng.
+ *
+ **********************************************************************/
+
+SYSCALL_DEFINE3(getrandom, char __user *, ubuf, size_t, len, unsigned int, flags)
 {
+	struct iov_iter iter;
+	struct iovec iov;
 	int ret;
 
-	ret = wait_for_random_bytes();
-	if (ret != 0)
+	if (flags & ~(GRND_NONBLOCK | GRND_RANDOM | GRND_INSECURE))
+		return -EINVAL;
+
+	/*
+	 * Requesting insecure and blocking randomness at the same time makes
+	 * no sense.
+	 */
+	if ((flags & (GRND_INSECURE | GRND_RANDOM)) == (GRND_INSECURE | GRND_RANDOM))
+		return -EINVAL;
+
+	if (!crng_ready() && !(flags & GRND_INSECURE)) {
+		if (flags & GRND_NONBLOCK)
+			return -EAGAIN;
+		ret = wait_for_random_bytes();
+		if (unlikely(ret))
+			return ret;
+	}
+
+	ret = import_single_range(READ, ubuf, len, &iov, &iter);
+	if (unlikely(ret))
 		return ret;
-	return urandom_read_nowarn(file, buf, nbytes, ppos);
+	return get_random_bytes_user(&iter);
 }
 
 static __poll_t random_poll(struct file *file, poll_table *wait)
 {
-	__poll_t mask;
-
 	poll_wait(file, &crng_init_wait, wait);
-	poll_wait(file, &random_write_wait, wait);
-	mask = 0;
-	if (crng_ready())
-		mask |= EPOLLIN | EPOLLRDNORM;
-	if (POOL_ENTROPY_BITS() < random_write_wakeup_bits)
-		mask |= EPOLLOUT | EPOLLWRNORM;
-	return mask;
+	return crng_ready() ? EPOLLIN | EPOLLRDNORM : EPOLLOUT | EPOLLWRNORM;
 }
 
-static int write_pool(const char __user *buffer, size_t count)
+static ssize_t write_pool_user(struct iov_iter *iter)
 {
-	size_t bytes;
-	u32 t, buf[16];
-	const char __user *p = buffer;
+	u8 block[BLAKE2S_BLOCK_SIZE];
+	ssize_t ret = 0;
+	size_t copied;
 
-	while (count > 0) {
-		int b, i = 0;
+	if (unlikely(!iov_iter_count(iter)))
+		return 0;
 
-		bytes = min(count, sizeof(buf));
-		if (copy_from_user(&buf, p, bytes))
-			return -EFAULT;
+	for (;;) {
+		copied = copy_from_iter(block, sizeof(block), iter);
+		ret += copied;
+		mix_pool_bytes(block, copied);
+		if (!iov_iter_count(iter) || copied != sizeof(block))
+			break;
 
-		for (b = bytes; b > 0; b -= sizeof(u32), i++) {
-			if (!arch_get_random_int(&t))
+		BUILD_BUG_ON(PAGE_SIZE % sizeof(block) != 0);
+		if (ret % PAGE_SIZE == 0) {
+			if (signal_pending(current))
 				break;
-			buf[i] ^= t;
+			cond_resched();
 		}
+	}
 
-		count -= bytes;
-		p += bytes;
+	memzero_explicit(block, sizeof(block));
+	return ret ? ret : -EFAULT;
+}
+
+static ssize_t random_write_iter(struct kiocb *kiocb, struct iov_iter *iter)
+{
+	return write_pool_user(iter);
+}
 
-		mix_pool_bytes(buf, bytes);
-		cond_resched();
+static ssize_t urandom_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
+{
+	static int maxwarn = 10;
+
+	if (!crng_ready()) {
+		if (!ratelimit_disable && maxwarn <= 0)
+			++urandom_warning.missed;
+		else if (ratelimit_disable || __ratelimit(&urandom_warning)) {
+			--maxwarn;
+			pr_notice("%s: uninitialized urandom read (%zu bytes read)\n",
+				  current->comm, iov_iter_count(iter));
+		}
 	}
 
-	return 0;
+	return get_random_bytes_user(iter);
 }
 
-static ssize_t random_write(struct file *file, const char __user *buffer,
-			    size_t count, loff_t *ppos)
+static ssize_t random_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
 {
-	size_t ret;
+	int ret;
 
-	ret = write_pool(buffer, count);
-	if (ret)
+	ret = wait_for_random_bytes();
+	if (ret != 0)
 		return ret;
-
-	return (ssize_t)count;
+	return get_random_bytes_user(iter);
 }
 
 static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
-	int size, ent_count;
 	int __user *p = (int __user *)arg;
-	int retval;
+	int ent_count;
 
 	switch (cmd) {
 	case RNDGETENTCNT:
-		/* inherently racy, no point locking */
-		ent_count = POOL_ENTROPY_BITS();
-		if (put_user(ent_count, p))
+		/* Inherently racy, no point locking. */
+		if (put_user(input_pool.init_bits, p))
 			return -EFAULT;
 		return 0;
 	case RNDADDTOENTCNT:
@@ -1834,40 +1329,48 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 			return -EPERM;
 		if (get_user(ent_count, p))
 			return -EFAULT;
-		return credit_entropy_bits_safe(ent_count);
-	case RNDADDENTROPY:
+		if (ent_count < 0)
+			return -EINVAL;
+		credit_init_bits(ent_count);
+		return 0;
+	case RNDADDENTROPY: {
+		struct iov_iter iter;
+		struct iovec iov;
+		ssize_t ret;
+		int len;
+
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		if (get_user(ent_count, p++))
 			return -EFAULT;
 		if (ent_count < 0)
 			return -EINVAL;
-		if (get_user(size, p++))
+		if (get_user(len, p++))
+			return -EFAULT;
+		ret = import_single_range(WRITE, p, len, &iov, &iter);
+		if (unlikely(ret))
+			return ret;
+		ret = write_pool_user(&iter);
+		if (unlikely(ret < 0))
+			return ret;
+		/* Since we're crediting, enforce that it was all written into the pool. */
+		if (unlikely(ret != len))
 			return -EFAULT;
-		retval = write_pool((const char __user *)p, size);
-		if (retval < 0)
-			return retval;
-		return credit_entropy_bits_safe(ent_count);
+		credit_init_bits(ent_count);
+		return 0;
+	}
 	case RNDZAPENTCNT:
 	case RNDCLEARPOOL:
-		/*
-		 * Clear the entropy pool counters. We no longer clear
-		 * the entropy pool, as that's silly.
-		 */
+		/* No longer has any effect. */
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		if (xchg(&input_pool.entropy_count, 0) && random_write_wakeup_bits) {
-			wake_up_interruptible(&random_write_wait);
-			kill_fasync(&fasync, SIGIO, POLL_OUT);
-		}
 		return 0;
 	case RNDRESEEDCRNG:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		if (crng_init < 2)
+		if (!crng_ready())
 			return -ENODATA;
-		crng_reseed(&primary_crng, true);
-		WRITE_ONCE(crng_global_init_time, jiffies - 1);
+		crng_reseed();
 		return 0;
 	default:
 		return -EINVAL;
@@ -1880,55 +1383,56 @@ static int random_fasync(int fd, struct file *filp, int on)
 }
 
 const struct file_operations random_fops = {
-	.read = random_read,
-	.write = random_write,
+	.read_iter = random_read_iter,
+	.write_iter = random_write_iter,
 	.poll = random_poll,
 	.unlocked_ioctl = random_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 	.fasync = random_fasync,
 	.llseek = noop_llseek,
+	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
 };
 
 const struct file_operations urandom_fops = {
-	.read = urandom_read,
-	.write = random_write,
+	.read_iter = urandom_read_iter,
+	.write_iter = random_write_iter,
 	.unlocked_ioctl = random_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 	.fasync = random_fasync,
 	.llseek = noop_llseek,
+	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
 };
 
-SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count, unsigned int,
-		flags)
-{
-	int ret;
-
-	if (flags & ~(GRND_NONBLOCK | GRND_RANDOM | GRND_INSECURE))
-		return -EINVAL;
-
-	/*
-	 * Requesting insecure and blocking randomness at the same time makes
-	 * no sense.
-	 */
-	if ((flags & (GRND_INSECURE | GRND_RANDOM)) == (GRND_INSECURE | GRND_RANDOM))
-		return -EINVAL;
-
-	if (count > INT_MAX)
-		count = INT_MAX;
-
-	if (!(flags & GRND_INSECURE) && !crng_ready()) {
-		if (flags & GRND_NONBLOCK)
-			return -EAGAIN;
-		ret = wait_for_random_bytes();
-		if (unlikely(ret))
-			return ret;
-	}
-	return urandom_read_nowarn(NULL, buf, count, NULL);
-}
 
 /********************************************************************
  *
- * Sysctl interface
+ * Sysctl interface.
+ *
+ * These are partly unused legacy knobs with dummy values to not break
+ * userspace and partly still useful things. They are usually accessible
+ * in /proc/sys/kernel/random/ and are as follows:
+ *
+ * - boot_id - a UUID representing the current boot.
+ *
+ * - uuid - a random UUID, different each time the file is read.
+ *
+ * - poolsize - the number of bits of entropy that the input pool can
+ *   hold, tied to the POOL_BITS constant.
+ *
+ * - entropy_avail - the number of bits of entropy currently in the
+ *   input pool. Always <= poolsize.
+ *
+ * - write_wakeup_threshold - the amount of entropy in the input pool
+ *   below which write polls to /dev/random will unblock, requesting
+ *   more entropy, tied to the POOL_READY_BITS constant. It is writable
+ *   to avoid breaking old userspaces, but writing to it does not
+ *   change any behavior of the RNG.
+ *
+ * - urandom_min_reseed_secs - fixed to the value CRNG_RESEED_INTERVAL.
+ *   It is writable to avoid breaking old userspaces, but writing
+ *   to it does not change any behavior of the RNG.
  *
  ********************************************************************/
 
@@ -1936,25 +1440,28 @@ SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count, unsigned int,
 
 #include <linux/sysctl.h>
 
-static int min_write_thresh;
-static int max_write_thresh = POOL_BITS;
-static int random_min_urandom_seed = 60;
-static char sysctl_bootid[16];
+static int sysctl_random_min_urandom_seed = CRNG_RESEED_INTERVAL / HZ;
+static int sysctl_random_write_wakeup_bits = POOL_READY_BITS;
+static int sysctl_poolsize = POOL_BITS;
+static u8 sysctl_bootid[UUID_SIZE];
 
 /*
  * This function is used to return both the bootid UUID, and random
- * UUID.  The difference is in whether table->data is NULL; if it is,
+ * UUID. The difference is in whether table->data is NULL; if it is,
  * then a new UUID is generated and returned to the user.
- *
- * If the user accesses this via the proc interface, the UUID will be
- * returned as an ASCII string in the standard UUID format; if via the
- * sysctl system call, as 16 bytes of binary data.
  */
-static int proc_do_uuid(struct ctl_table *table, int write, void *buffer,
+static int proc_do_uuid(struct ctl_table *table, int write, void *buf,
 			size_t *lenp, loff_t *ppos)
 {
-	struct ctl_table fake_table;
-	unsigned char buf[64], tmp_uuid[16], *uuid;
+	u8 tmp_uuid[UUID_SIZE], *uuid;
+	char uuid_string[UUID_STRING_LEN + 1];
+	struct ctl_table fake_table = {
+		.data = uuid_string,
+		.maxlen = UUID_STRING_LEN
+	};
+
+	if (write)
+		return -EPERM;
 
 	uuid = table->data;
 	if (!uuid) {
@@ -1969,32 +1476,17 @@ static int proc_do_uuid(struct ctl_table *table, int write, void *buffer,
 		spin_unlock(&bootid_spinlock);
 	}
 
-	sprintf(buf, "%pU", uuid);
-
-	fake_table.data = buf;
-	fake_table.maxlen = sizeof(buf);
-
-	return proc_dostring(&fake_table, write, buffer, lenp, ppos);
+	snprintf(uuid_string, sizeof(uuid_string), "%pU", uuid);
+	return proc_dostring(&fake_table, 0, buf, lenp, ppos);
 }
 
-/*
- * Return entropy available scaled to integral bits
- */
-static int proc_do_entropy(struct ctl_table *table, int write, void *buffer,
-			   size_t *lenp, loff_t *ppos)
+/* The same as proc_dointvec, but writes don't change anything. */
+static int proc_do_rointvec(struct ctl_table *table, int write, void *buf,
+			    size_t *lenp, loff_t *ppos)
 {
-	struct ctl_table fake_table;
-	int entropy_count;
-
-	entropy_count = *(int *)table->data >> POOL_ENTROPY_SHIFT;
-
-	fake_table.data = &entropy_count;
-	fake_table.maxlen = sizeof(entropy_count);
-
-	return proc_dointvec(&fake_table, write, buffer, lenp, ppos);
+	return write ? 0 : proc_dointvec(table, 0, buf, lenp, ppos);
 }
 
-static int sysctl_poolsize = POOL_BITS;
 static struct ctl_table random_table[] = {
 	{
 		.procname	= "poolsize",
@@ -2005,62 +1497,42 @@ static struct ctl_table random_table[] = {
 	},
 	{
 		.procname	= "entropy_avail",
+		.data		= &input_pool.init_bits,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= proc_do_entropy,
-		.data		= &input_pool.entropy_count,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "write_wakeup_threshold",
-		.data		= &random_write_wakeup_bits,
+		.data		= &sysctl_random_write_wakeup_bits,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &min_write_thresh,
-		.extra2		= &max_write_thresh,
+		.proc_handler	= proc_do_rointvec,
 	},
 	{
 		.procname	= "urandom_min_reseed_secs",
-		.data		= &random_min_urandom_seed,
+		.data		= &sysctl_random_min_urandom_seed,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_do_rointvec,
 	},
 	{
 		.procname	= "boot_id",
 		.data		= &sysctl_bootid,
-		.maxlen		= 16,
 		.mode		= 0444,
 		.proc_handler	= proc_do_uuid,
 	},
 	{
 		.procname	= "uuid",
-		.maxlen		= 16,
 		.mode		= 0444,
 		.proc_handler	= proc_do_uuid,
 	},
-#ifdef ADD_INTERRUPT_BENCH
-	{
-		.procname	= "add_interrupt_avg_cycles",
-		.data		= &avg_cycles,
-		.maxlen		= sizeof(avg_cycles),
-		.mode		= 0444,
-		.proc_handler	= proc_doulongvec_minmax,
-	},
-	{
-		.procname	= "add_interrupt_avg_deviation",
-		.data		= &avg_deviation,
-		.maxlen		= sizeof(avg_deviation),
-		.mode		= 0444,
-		.proc_handler	= proc_doulongvec_minmax,
-	},
-#endif
 	{ }
 };
 
 /*
- * rand_initialize() is called before sysctl_init(),
- * so we cannot call register_sysctl_init() in rand_initialize()
+ * random_init() is called before sysctl_init(),
+ * so we cannot call register_sysctl_init() in random_init()
  */
 static int __init random_sysctls_init(void)
 {
@@ -2068,170 +1540,4 @@ static int __init random_sysctls_init(void)
 	return 0;
 }
 device_initcall(random_sysctls_init);
-#endif	/* CONFIG_SYSCTL */
-
-struct batched_entropy {
-	union {
-		u64 entropy_u64[CHACHA_BLOCK_SIZE / sizeof(u64)];
-		u32 entropy_u32[CHACHA_BLOCK_SIZE / sizeof(u32)];
-	};
-	unsigned int position;
-	spinlock_t batch_lock;
-};
-
-/*
- * Get a random word for internal kernel use only. The quality of the random
- * number is good as /dev/urandom, but there is no backtrack protection, with
- * the goal of being quite fast and not depleting entropy. In order to ensure
- * that the randomness provided by this function is okay, the function
- * wait_for_random_bytes() should be called and return 0 at least once at any
- * point prior.
- */
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64) = {
-	.batch_lock = __SPIN_LOCK_UNLOCKED(batched_entropy_u64.lock),
-};
-
-u64 get_random_u64(void)
-{
-	u64 ret;
-	unsigned long flags;
-	struct batched_entropy *batch;
-	static void *previous;
-
-	warn_unseeded_randomness(&previous);
-
-	batch = raw_cpu_ptr(&batched_entropy_u64);
-	spin_lock_irqsave(&batch->batch_lock, flags);
-	if (batch->position % ARRAY_SIZE(batch->entropy_u64) == 0) {
-		extract_crng((u8 *)batch->entropy_u64);
-		batch->position = 0;
-	}
-	ret = batch->entropy_u64[batch->position++];
-	spin_unlock_irqrestore(&batch->batch_lock, flags);
-	return ret;
-}
-EXPORT_SYMBOL(get_random_u64);
-
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32) = {
-	.batch_lock = __SPIN_LOCK_UNLOCKED(batched_entropy_u32.lock),
-};
-u32 get_random_u32(void)
-{
-	u32 ret;
-	unsigned long flags;
-	struct batched_entropy *batch;
-	static void *previous;
-
-	warn_unseeded_randomness(&previous);
-
-	batch = raw_cpu_ptr(&batched_entropy_u32);
-	spin_lock_irqsave(&batch->batch_lock, flags);
-	if (batch->position % ARRAY_SIZE(batch->entropy_u32) == 0) {
-		extract_crng((u8 *)batch->entropy_u32);
-		batch->position = 0;
-	}
-	ret = batch->entropy_u32[batch->position++];
-	spin_unlock_irqrestore(&batch->batch_lock, flags);
-	return ret;
-}
-EXPORT_SYMBOL(get_random_u32);
-
-/* It's important to invalidate all potential batched entropy that might
- * be stored before the crng is initialized, which we can do lazily by
- * simply resetting the counter to zero so that it's re-extracted on the
- * next usage. */
-static void invalidate_batched_entropy(void)
-{
-	int cpu;
-	unsigned long flags;
-
-	for_each_possible_cpu(cpu) {
-		struct batched_entropy *batched_entropy;
-
-		batched_entropy = per_cpu_ptr(&batched_entropy_u32, cpu);
-		spin_lock_irqsave(&batched_entropy->batch_lock, flags);
-		batched_entropy->position = 0;
-		spin_unlock(&batched_entropy->batch_lock);
-
-		batched_entropy = per_cpu_ptr(&batched_entropy_u64, cpu);
-		spin_lock(&batched_entropy->batch_lock);
-		batched_entropy->position = 0;
-		spin_unlock_irqrestore(&batched_entropy->batch_lock, flags);
-	}
-}
-
-/**
- * randomize_page - Generate a random, page aligned address
- * @start:	The smallest acceptable address the caller will take.
- * @range:	The size of the area, starting at @start, within which the
- *		random address must fall.
- *
- * If @start + @range would overflow, @range is capped.
- *
- * NOTE: Historical use of randomize_range, which this replaces, presumed that
- * @start was already page aligned.  We now align it regardless.
- *
- * Return: A page aligned address within [start, start + range).  On error,
- * @start is returned.
- */
-unsigned long randomize_page(unsigned long start, unsigned long range)
-{
-	if (!PAGE_ALIGNED(start)) {
-		range -= PAGE_ALIGN(start) - start;
-		start = PAGE_ALIGN(start);
-	}
-
-	if (start > ULONG_MAX - range)
-		range = ULONG_MAX - start;
-
-	range >>= PAGE_SHIFT;
-
-	if (range == 0)
-		return start;
-
-	return start + (get_random_long() % range << PAGE_SHIFT);
-}
-
-/* Interface for in-kernel drivers of true hardware RNGs.
- * Those devices may produce endless random bits and will be throttled
- * when our pool is full.
- */
-void add_hwgenerator_randomness(const char *buffer, size_t count,
-				size_t entropy)
-{
-	if (unlikely(crng_init == 0)) {
-		size_t ret = crng_fast_load(buffer, count);
-		mix_pool_bytes(buffer, ret);
-		count -= ret;
-		buffer += ret;
-		if (!count || crng_init == 0)
-			return;
-	}
-
-	/* Throttle writing if we're above the trickle threshold.
-	 * We'll be woken up again once below random_write_wakeup_thresh,
-	 * when the calling thread is about to terminate, or once
-	 * CRNG_RESEED_INTERVAL has lapsed.
-	 */
-	wait_event_interruptible_timeout(random_write_wait,
-			!system_wq || kthread_should_stop() ||
-			POOL_ENTROPY_BITS() <= random_write_wakeup_bits,
-			CRNG_RESEED_INTERVAL);
-	mix_pool_bytes(buffer, count);
-	credit_entropy_bits(entropy);
-}
-EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
-
-/* Handle random seed passed by bootloader.
- * If the seed is trustworthy, it would be regarded as hardware RNGs. Otherwise
- * it would be regarded as device data.
- * The decision is controlled by CONFIG_RANDOM_TRUST_BOOTLOADER.
- */
-void add_bootloader_randomness(const void *buf, unsigned int size)
-{
-	if (IS_ENABLED(CONFIG_RANDOM_TRUST_BOOTLOADER))
-		add_hwgenerator_randomness(buf, size, size * 8);
-	else
-		add_device_randomness(buf, size);
-}
-EXPORT_SYMBOL_GPL(add_bootloader_randomness);
+#endif
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_client.c b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
index c5de0ec4f9d0..444acd9e2cd6 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -227,6 +227,17 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 		dev_dbg(dev, "sid 0x%x status 0x%x\n",
 			cl_data->sensor_idx[i], cl_data->sensor_sts[i]);
 	}
+	if (privdata->mp2_ops->discovery_status &&
+	    privdata->mp2_ops->discovery_status(privdata) == 0) {
+		amd_sfh_hid_client_deinit(privdata);
+		for (i = 0; i < cl_data->num_hid_devices; i++) {
+			devm_kfree(dev, cl_data->feature_report[i]);
+			devm_kfree(dev, in_data->input_report[i]);
+			devm_kfree(dev, cl_data->report_descr[i]);
+		}
+		dev_warn(dev, "Failed to discover, sensors not enabled\n");
+		return -EOPNOTSUPP;
+	}
 	schedule_delayed_work(&cl_data->work_buffer, msecs_to_jiffies(AMD_SFH_IDLE_LOOP));
 	return 0;
 
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index 19fa734a9a79..abd7f6586095 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -130,6 +130,12 @@ static int amd_sfh_irq_init_v2(struct amd_mp2_dev *privdata)
 	return 0;
 }
 
+static int amd_sfh_dis_sts_v2(struct amd_mp2_dev *privdata)
+{
+	return (readl(privdata->mmio + AMD_P2C_MSG(1)) &
+		      SENSOR_DISCOVERY_STATUS_MASK) >> SENSOR_DISCOVERY_STATUS_SHIFT;
+}
+
 void amd_start_sensor(struct amd_mp2_dev *privdata, struct amd_mp2_sensor_info info)
 {
 	union sfh_cmd_param cmd_param;
@@ -245,6 +251,7 @@ static const struct amd_mp2_ops amd_sfh_ops_v2 = {
 	.response = amd_sfh_wait_response_v2,
 	.clear_intr = amd_sfh_clear_intr_v2,
 	.init_intr = amd_sfh_irq_init_v2,
+	.discovery_status = amd_sfh_dis_sts_v2,
 };
 
 static const struct amd_mp2_ops amd_sfh_ops = {
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
index 97b99861fae2..9aa88a91ac8d 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
@@ -39,6 +39,9 @@
 
 #define AMD_SFH_IDLE_LOOP	200
 
+#define SENSOR_DISCOVERY_STATUS_MASK		GENMASK(5, 3)
+#define SENSOR_DISCOVERY_STATUS_SHIFT		3
+
 /* SFH Command register */
 union sfh_cmd_base {
 	u32 ul;
@@ -143,5 +146,6 @@ struct amd_mp2_ops {
 	 int (*response)(struct amd_mp2_dev *mp2, u8 sid, u32 sensor_sts);
 	 void (*clear_intr)(struct amd_mp2_dev *privdata);
 	 int (*init_intr)(struct amd_mp2_dev *privdata);
+	 int (*discovery_status)(struct amd_mp2_dev *privdata);
 };
 #endif
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 411a428ace4d..481e565cc5c4 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -100,6 +100,7 @@ enum cpuhp_state {
 	CPUHP_AP_ARM_CACHE_B15_RAC_DEAD,
 	CPUHP_PADATA_DEAD,
 	CPUHP_AP_DTPM_CPU_DEAD,
+	CPUHP_RANDOM_PREPARE,
 	CPUHP_WORKQUEUE_PREP,
 	CPUHP_POWER_NUMA_PREPARE,
 	CPUHP_HRTIMERS_PREPARE,
@@ -240,6 +241,7 @@ enum cpuhp_state {
 	CPUHP_AP_PERF_CSKY_ONLINE,
 	CPUHP_AP_WATCHDOG_ONLINE,
 	CPUHP_AP_WORKQUEUE_ONLINE,
+	CPUHP_AP_RANDOM_ONLINE,
 	CPUHP_AP_RCUTREE_ONLINE,
 	CPUHP_AP_BASE_CACHEINFO_ONLINE,
 	CPUHP_AP_ONLINE_DYN,
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 8e6dd908da21..aa1d4da03538 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -60,7 +60,5 @@ extern int devm_hwrng_register(struct device *dev, struct hwrng *rng);
 /** Unregister a Hardware Random Number Generator driver. */
 extern void hwrng_unregister(struct hwrng *rng);
 extern void devm_hwrng_unregister(struct device *dve, struct hwrng *rng);
-/** Feed random bits into the pool. */
-extern void add_hwgenerator_randomness(const char *buffer, size_t count, size_t entropy);
 
 #endif /* LINUX_HWRANDOM_H_ */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5744a3fc4716..9cb0ff065e8b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2678,6 +2678,7 @@ extern int install_special_mapping(struct mm_struct *mm,
 				   unsigned long flags, struct page **pages);
 
 unsigned long randomize_stack_top(unsigned long stack_top);
+unsigned long randomize_page(unsigned long start, unsigned long range);
 
 extern unsigned long get_unmapped_area(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 
diff --git a/include/linux/prandom.h b/include/linux/prandom.h
index 056d31317e49..a4aadd2dc153 100644
--- a/include/linux/prandom.h
+++ b/include/linux/prandom.h
@@ -10,6 +10,7 @@
 
 #include <linux/types.h>
 #include <linux/percpu.h>
+#include <linux/siphash.h>
 
 u32 prandom_u32(void);
 void prandom_bytes(void *buf, size_t nbytes);
@@ -27,15 +28,10 @@ DECLARE_PER_CPU(unsigned long, net_rand_noise);
  * The core SipHash round function.  Each line can be executed in
  * parallel given enough CPU resources.
  */
-#define PRND_SIPROUND(v0, v1, v2, v3) ( \
-	v0 += v1, v1 = rol64(v1, 13),  v2 += v3, v3 = rol64(v3, 16), \
-	v1 ^= v0, v0 = rol64(v0, 32),  v3 ^= v2,                     \
-	v0 += v3, v3 = rol64(v3, 21),  v2 += v1, v1 = rol64(v1, 17), \
-	v3 ^= v0,                      v1 ^= v2, v2 = rol64(v2, 32)  \
-)
+#define PRND_SIPROUND(v0, v1, v2, v3) SIPHASH_PERMUTATION(v0, v1, v2, v3)
 
-#define PRND_K0 (0x736f6d6570736575 ^ 0x6c7967656e657261)
-#define PRND_K1 (0x646f72616e646f6d ^ 0x7465646279746573)
+#define PRND_K0 (SIPHASH_CONST_0 ^ SIPHASH_CONST_2)
+#define PRND_K1 (SIPHASH_CONST_1 ^ SIPHASH_CONST_3)
 
 #elif BITS_PER_LONG == 32
 /*
@@ -43,14 +39,9 @@ DECLARE_PER_CPU(unsigned long, net_rand_noise);
  * This is weaker, but 32-bit machines are not used for high-traffic
  * applications, so there is less output for an attacker to analyze.
  */
-#define PRND_SIPROUND(v0, v1, v2, v3) ( \
-	v0 += v1, v1 = rol32(v1,  5),  v2 += v3, v3 = rol32(v3,  8), \
-	v1 ^= v0, v0 = rol32(v0, 16),  v3 ^= v2,                     \
-	v0 += v3, v3 = rol32(v3,  7),  v2 += v1, v1 = rol32(v1, 13), \
-	v3 ^= v0,                      v1 ^= v2, v2 = rol32(v2, 16)  \
-)
-#define PRND_K0 0x6c796765
-#define PRND_K1 0x74656462
+#define PRND_SIPROUND(v0, v1, v2, v3) HSIPHASH_PERMUTATION(v0, v1, v2, v3)
+#define PRND_K0 (HSIPHASH_CONST_0 ^ HSIPHASH_CONST_2)
+#define PRND_K1 (HSIPHASH_CONST_1 ^ HSIPHASH_CONST_3)
 
 #else
 #error Unsupported BITS_PER_LONG
diff --git a/include/linux/random.h b/include/linux/random.h
index c45b2693e51f..917470c4490a 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -1,9 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*
- * include/linux/random.h
- *
- * Include file for the random number generator.
- */
+
 #ifndef _LINUX_RANDOM_H
 #define _LINUX_RANDOM_H
 
@@ -14,41 +10,26 @@
 
 #include <uapi/linux/random.h>
 
-struct random_ready_callback {
-	struct list_head list;
-	void (*func)(struct random_ready_callback *rdy);
-	struct module *owner;
-};
+struct notifier_block;
 
-extern void add_device_randomness(const void *, unsigned int);
-extern void add_bootloader_randomness(const void *, unsigned int);
+void add_device_randomness(const void *buf, size_t len);
+void add_bootloader_randomness(const void *buf, size_t len);
+void add_input_randomness(unsigned int type, unsigned int code,
+			  unsigned int value) __latent_entropy;
+void add_interrupt_randomness(int irq) __latent_entropy;
+void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy);
 
 #if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 static inline void add_latent_entropy(void)
 {
-	add_device_randomness((const void *)&latent_entropy,
-			      sizeof(latent_entropy));
+	add_device_randomness((const void *)&latent_entropy, sizeof(latent_entropy));
 }
 #else
-static inline void add_latent_entropy(void) {}
-#endif
-
-extern void add_input_randomness(unsigned int type, unsigned int code,
-				 unsigned int value) __latent_entropy;
-extern void add_interrupt_randomness(int irq) __latent_entropy;
-
-extern void get_random_bytes(void *buf, int nbytes);
-extern int wait_for_random_bytes(void);
-extern int __init rand_initialize(void);
-extern bool rng_is_initialized(void);
-extern int add_random_ready_callback(struct random_ready_callback *rdy);
-extern void del_random_ready_callback(struct random_ready_callback *rdy);
-extern int __must_check get_random_bytes_arch(void *buf, int nbytes);
-
-#ifndef MODULE
-extern const struct file_operations random_fops, urandom_fops;
+static inline void add_latent_entropy(void) { }
 #endif
 
+void get_random_bytes(void *buf, size_t len);
+size_t __must_check get_random_bytes_arch(void *buf, size_t len);
 u32 get_random_u32(void);
 u64 get_random_u64(void);
 static inline unsigned int get_random_int(void)
@@ -80,36 +61,38 @@ static inline unsigned long get_random_long(void)
 
 static inline unsigned long get_random_canary(void)
 {
-	unsigned long val = get_random_long();
-
-	return val & CANARY_MASK;
+	return get_random_long() & CANARY_MASK;
 }
 
+int __init random_init(const char *command_line);
+bool rng_is_initialized(void);
+int wait_for_random_bytes(void);
+int register_random_ready_notifier(struct notifier_block *nb);
+int unregister_random_ready_notifier(struct notifier_block *nb);
+
 /* Calls wait_for_random_bytes() and then calls get_random_bytes(buf, nbytes).
  * Returns the result of the call to wait_for_random_bytes. */
-static inline int get_random_bytes_wait(void *buf, int nbytes)
+static inline int get_random_bytes_wait(void *buf, size_t nbytes)
 {
 	int ret = wait_for_random_bytes();
 	get_random_bytes(buf, nbytes);
 	return ret;
 }
 
-#define declare_get_random_var_wait(var) \
-	static inline int get_random_ ## var ## _wait(var *out) { \
+#define declare_get_random_var_wait(name, ret_type) \
+	static inline int get_random_ ## name ## _wait(ret_type *out) { \
 		int ret = wait_for_random_bytes(); \
 		if (unlikely(ret)) \
 			return ret; \
-		*out = get_random_ ## var(); \
+		*out = get_random_ ## name(); \
 		return 0; \
 	}
-declare_get_random_var_wait(u32)
-declare_get_random_var_wait(u64)
-declare_get_random_var_wait(int)
-declare_get_random_var_wait(long)
+declare_get_random_var_wait(u32, u32)
+declare_get_random_var_wait(u64, u32)
+declare_get_random_var_wait(int, unsigned int)
+declare_get_random_var_wait(long, unsigned long)
 #undef declare_get_random_var
 
-unsigned long randomize_page(unsigned long start, unsigned long range);
-
 /*
  * This is designed to be standalone for just prandom
  * users, but for now we include it from <linux/random.h>
@@ -120,22 +103,10 @@ unsigned long randomize_page(unsigned long start, unsigned long range);
 #ifdef CONFIG_ARCH_RANDOM
 # include <asm/archrandom.h>
 #else
-static inline bool __must_check arch_get_random_long(unsigned long *v)
-{
-	return false;
-}
-static inline bool __must_check arch_get_random_int(unsigned int *v)
-{
-	return false;
-}
-static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
-{
-	return false;
-}
-static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
-{
-	return false;
-}
+static inline bool __must_check arch_get_random_long(unsigned long *v) { return false; }
+static inline bool __must_check arch_get_random_int(unsigned int *v) { return false; }
+static inline bool __must_check arch_get_random_seed_long(unsigned long *v) { return false; }
+static inline bool __must_check arch_get_random_seed_int(unsigned int *v) { return false; }
 #endif
 
 /*
@@ -158,4 +129,13 @@ static inline bool __init arch_get_random_long_early(unsigned long *v)
 }
 #endif
 
+#ifdef CONFIG_SMP
+int random_prepare_cpu(unsigned int cpu);
+int random_online_cpu(unsigned int cpu);
+#endif
+
+#ifndef MODULE
+extern const struct file_operations random_fops, urandom_fops;
+#endif
+
 #endif /* _LINUX_RANDOM_H */
diff --git a/include/linux/siphash.h b/include/linux/siphash.h
index cce8a9acc76c..3af1428da559 100644
--- a/include/linux/siphash.h
+++ b/include/linux/siphash.h
@@ -138,4 +138,32 @@ static inline u32 hsiphash(const void *data, size_t len,
 	return ___hsiphash_aligned(data, len, key);
 }
 
+/*
+ * These macros expose the raw SipHash and HalfSipHash permutations.
+ * Do not use them directly! If you think you have a use for them,
+ * be sure to CC the maintainer of this file explaining why.
+ */
+
+#define SIPHASH_PERMUTATION(a, b, c, d) ( \
+	(a) += (b), (b) = rol64((b), 13), (b) ^= (a), (a) = rol64((a), 32), \
+	(c) += (d), (d) = rol64((d), 16), (d) ^= (c), \
+	(a) += (d), (d) = rol64((d), 21), (d) ^= (a), \
+	(c) += (b), (b) = rol64((b), 17), (b) ^= (c), (c) = rol64((c), 32))
+
+#define SIPHASH_CONST_0 0x736f6d6570736575ULL
+#define SIPHASH_CONST_1 0x646f72616e646f6dULL
+#define SIPHASH_CONST_2 0x6c7967656e657261ULL
+#define SIPHASH_CONST_3 0x7465646279746573ULL
+
+#define HSIPHASH_PERMUTATION(a, b, c, d) ( \
+	(a) += (b), (b) = rol32((b), 5), (b) ^= (a), (a) = rol32((a), 16), \
+	(c) += (d), (d) = rol32((d), 8), (d) ^= (c), \
+	(a) += (d), (d) = rol32((d), 7), (d) ^= (a), \
+	(c) += (b), (b) = rol32((b), 13), (b) ^= (c), (c) = rol32((c), 16))
+
+#define HSIPHASH_CONST_0 0U
+#define HSIPHASH_CONST_1 0U
+#define HSIPHASH_CONST_2 0x6c796765U
+#define HSIPHASH_CONST_3 0x74656462U
+
 #endif /* _LINUX_SIPHASH_H */
diff --git a/include/linux/timex.h b/include/linux/timex.h
index 059b18eb1f1f..3871b06bd302 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -62,6 +62,8 @@
 #include <linux/types.h>
 #include <linux/param.h>
 
+unsigned long random_get_entropy_fallback(void);
+
 #include <asm/timex.h>
 
 #ifndef random_get_entropy
@@ -74,8 +76,14 @@
  *
  * By default we use get_cycles() for this purpose, but individual
  * architectures may override this in their asm/timex.h header file.
+ * If a given arch does not have get_cycles(), then we fallback to
+ * using random_get_entropy_fallback().
  */
-#define random_get_entropy()	get_cycles()
+#ifdef get_cycles
+#define random_get_entropy()	((unsigned long)get_cycles())
+#else
+#define random_get_entropy()	random_get_entropy_fallback()
+#endif
 #endif
 
 /*
diff --git a/include/trace/events/random.h b/include/trace/events/random.h
deleted file mode 100644
index a2d9aa16a5d7..000000000000
--- a/include/trace/events/random.h
+++ /dev/null
@@ -1,233 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM random
-
-#if !defined(_TRACE_RANDOM_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_RANDOM_H
-
-#include <linux/writeback.h>
-#include <linux/tracepoint.h>
-
-TRACE_EVENT(add_device_randomness,
-	TP_PROTO(int bytes, unsigned long IP),
-
-	TP_ARGS(bytes, IP),
-
-	TP_STRUCT__entry(
-		__field(	  int,	bytes			)
-		__field(unsigned long,	IP			)
-	),
-
-	TP_fast_assign(
-		__entry->bytes		= bytes;
-		__entry->IP		= IP;
-	),
-
-	TP_printk("bytes %d caller %pS",
-		__entry->bytes, (void *)__entry->IP)
-);
-
-DECLARE_EVENT_CLASS(random__mix_pool_bytes,
-	TP_PROTO(int bytes, unsigned long IP),
-
-	TP_ARGS(bytes, IP),
-
-	TP_STRUCT__entry(
-		__field(	  int,	bytes			)
-		__field(unsigned long,	IP			)
-	),
-
-	TP_fast_assign(
-		__entry->bytes		= bytes;
-		__entry->IP		= IP;
-	),
-
-	TP_printk("input pool: bytes %d caller %pS",
-		  __entry->bytes, (void *)__entry->IP)
-);
-
-DEFINE_EVENT(random__mix_pool_bytes, mix_pool_bytes,
-	TP_PROTO(int bytes, unsigned long IP),
-
-	TP_ARGS(bytes, IP)
-);
-
-DEFINE_EVENT(random__mix_pool_bytes, mix_pool_bytes_nolock,
-	TP_PROTO(int bytes, unsigned long IP),
-
-	TP_ARGS(bytes, IP)
-);
-
-TRACE_EVENT(credit_entropy_bits,
-	TP_PROTO(int bits, int entropy_count, unsigned long IP),
-
-	TP_ARGS(bits, entropy_count, IP),
-
-	TP_STRUCT__entry(
-		__field(	  int,	bits			)
-		__field(	  int,	entropy_count		)
-		__field(unsigned long,	IP			)
-	),
-
-	TP_fast_assign(
-		__entry->bits		= bits;
-		__entry->entropy_count	= entropy_count;
-		__entry->IP		= IP;
-	),
-
-	TP_printk("input pool: bits %d entropy_count %d caller %pS",
-		  __entry->bits, __entry->entropy_count, (void *)__entry->IP)
-);
-
-TRACE_EVENT(debit_entropy,
-	TP_PROTO(int debit_bits),
-
-	TP_ARGS( debit_bits),
-
-	TP_STRUCT__entry(
-		__field(	  int,	debit_bits		)
-	),
-
-	TP_fast_assign(
-		__entry->debit_bits	= debit_bits;
-	),
-
-	TP_printk("input pool: debit_bits %d", __entry->debit_bits)
-);
-
-TRACE_EVENT(add_input_randomness,
-	TP_PROTO(int input_bits),
-
-	TP_ARGS(input_bits),
-
-	TP_STRUCT__entry(
-		__field(	  int,	input_bits		)
-	),
-
-	TP_fast_assign(
-		__entry->input_bits	= input_bits;
-	),
-
-	TP_printk("input_pool_bits %d", __entry->input_bits)
-);
-
-TRACE_EVENT(add_disk_randomness,
-	TP_PROTO(dev_t dev, int input_bits),
-
-	TP_ARGS(dev, input_bits),
-
-	TP_STRUCT__entry(
-		__field(	dev_t,	dev			)
-		__field(	  int,	input_bits		)
-	),
-
-	TP_fast_assign(
-		__entry->dev		= dev;
-		__entry->input_bits	= input_bits;
-	),
-
-	TP_printk("dev %d,%d input_pool_bits %d", MAJOR(__entry->dev),
-		  MINOR(__entry->dev), __entry->input_bits)
-);
-
-DECLARE_EVENT_CLASS(random__get_random_bytes,
-	TP_PROTO(int nbytes, unsigned long IP),
-
-	TP_ARGS(nbytes, IP),
-
-	TP_STRUCT__entry(
-		__field(	  int,	nbytes			)
-		__field(unsigned long,	IP			)
-	),
-
-	TP_fast_assign(
-		__entry->nbytes		= nbytes;
-		__entry->IP		= IP;
-	),
-
-	TP_printk("nbytes %d caller %pS", __entry->nbytes, (void *)__entry->IP)
-);
-
-DEFINE_EVENT(random__get_random_bytes, get_random_bytes,
-	TP_PROTO(int nbytes, unsigned long IP),
-
-	TP_ARGS(nbytes, IP)
-);
-
-DEFINE_EVENT(random__get_random_bytes, get_random_bytes_arch,
-	TP_PROTO(int nbytes, unsigned long IP),
-
-	TP_ARGS(nbytes, IP)
-);
-
-DECLARE_EVENT_CLASS(random__extract_entropy,
-	TP_PROTO(int nbytes, int entropy_count, unsigned long IP),
-
-	TP_ARGS(nbytes, entropy_count, IP),
-
-	TP_STRUCT__entry(
-		__field(	  int,	nbytes			)
-		__field(	  int,	entropy_count		)
-		__field(unsigned long,	IP			)
-	),
-
-	TP_fast_assign(
-		__entry->nbytes		= nbytes;
-		__entry->entropy_count	= entropy_count;
-		__entry->IP		= IP;
-	),
-
-	TP_printk("input pool: nbytes %d entropy_count %d caller %pS",
-		  __entry->nbytes, __entry->entropy_count, (void *)__entry->IP)
-);
-
-
-DEFINE_EVENT(random__extract_entropy, extract_entropy,
-	TP_PROTO(int nbytes, int entropy_count, unsigned long IP),
-
-	TP_ARGS(nbytes, entropy_count, IP)
-);
-
-TRACE_EVENT(urandom_read,
-	TP_PROTO(int got_bits, int pool_left, int input_left),
-
-	TP_ARGS(got_bits, pool_left, input_left),
-
-	TP_STRUCT__entry(
-		__field(	  int,	got_bits		)
-		__field(	  int,	pool_left		)
-		__field(	  int,	input_left		)
-	),
-
-	TP_fast_assign(
-		__entry->got_bits	= got_bits;
-		__entry->pool_left	= pool_left;
-		__entry->input_left	= input_left;
-	),
-
-	TP_printk("got_bits %d nonblocking_pool_entropy_left %d "
-		  "input_entropy_left %d", __entry->got_bits,
-		  __entry->pool_left, __entry->input_left)
-);
-
-TRACE_EVENT(prandom_u32,
-
-	TP_PROTO(unsigned int ret),
-
-	TP_ARGS(ret),
-
-	TP_STRUCT__entry(
-		__field(   unsigned int, ret)
-	),
-
-	TP_fast_assign(
-		__entry->ret = ret;
-	),
-
-	TP_printk("ret=%u" , __entry->ret)
-);
-
-#endif /* _TRACE_RANDOM_H */
-
-/* This part must be outside protection */
-#include <trace/define_trace.h>
diff --git a/init/main.c b/init/main.c
index 9a5097b2251a..0aa2e1c17b1c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1035,21 +1035,18 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 	softirq_init();
 	timekeeping_init();
 	kfence_init();
+	time_init();
 
 	/*
 	 * For best initial stack canary entropy, prepare it after:
 	 * - setup_arch() for any UEFI RNG entropy and boot cmdline access
-	 * - timekeeping_init() for ktime entropy used in rand_initialize()
-	 * - rand_initialize() to get any arch-specific entropy like RDRAND
-	 * - add_latent_entropy() to get any latent entropy
-	 * - adding command line entropy
+	 * - timekeeping_init() for ktime entropy used in random_init()
+	 * - time_init() for making random_get_entropy() work on some platforms
+	 * - random_init() to initialize the RNG from from early entropy sources
 	 */
-	rand_initialize();
-	add_latent_entropy();
-	add_device_randomness(command_line, strlen(command_line));
+	random_init(command_line);
 	boot_init_stack_canary();
 
-	time_init();
 	perf_event_init();
 	profile_init();
 	call_function_init();
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 5601216eb51b..da871eb07566 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -34,6 +34,7 @@
 #include <linux/scs.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/cpuset.h>
+#include <linux/random.h>
 
 #include <trace/events/power.h>
 #define CREATE_TRACE_POINTS
@@ -1659,6 +1660,11 @@ static struct cpuhp_step cpuhp_hp_states[] = {
 		.startup.single		= perf_event_init_cpu,
 		.teardown.single	= perf_event_exit_cpu,
 	},
+	[CPUHP_RANDOM_PREPARE] = {
+		.name			= "random:prepare",
+		.startup.single		= random_prepare_cpu,
+		.teardown.single	= NULL,
+	},
 	[CPUHP_WORKQUEUE_PREP] = {
 		.name			= "workqueue:prepare",
 		.startup.single		= workqueue_prepare_cpu,
@@ -1782,6 +1788,11 @@ static struct cpuhp_step cpuhp_hp_states[] = {
 		.startup.single		= workqueue_online_cpu,
 		.teardown.single	= workqueue_offline_cpu,
 	},
+	[CPUHP_AP_RANDOM_ONLINE] = {
+		.name			= "random:online",
+		.startup.single		= random_online_cpu,
+		.teardown.single	= NULL,
+	},
 	[CPUHP_AP_RCUTREE_ONLINE] = {
 		.name			= "RCU/tree:online",
 		.startup.single		= rcutree_online_cpu,
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 3b1398fbddaf..871c912860ed 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -17,6 +17,7 @@
 #include <linux/clocksource.h>
 #include <linux/jiffies.h>
 #include <linux/time.h>
+#include <linux/timex.h>
 #include <linux/tick.h>
 #include <linux/stop_machine.h>
 #include <linux/pvclock_gtod.h>
@@ -2380,6 +2381,20 @@ static int timekeeping_validate_timex(const struct __kernel_timex *txc)
 	return 0;
 }
 
+/**
+ * random_get_entropy_fallback - Returns the raw clock source value,
+ * used by random.c for platforms with no valid random_get_entropy().
+ */
+unsigned long random_get_entropy_fallback(void)
+{
+	struct tk_read_base *tkr = &tk_core.timekeeper.tkr_mono;
+	struct clocksource *clock = READ_ONCE(tkr->clock);
+
+	if (unlikely(timekeeping_suspended || !clock))
+		return 0;
+	return clock->read(clock);
+}
+EXPORT_SYMBOL_GPL(random_get_entropy_fallback);
 
 /**
  * do_adjtimex() - Accessor function to NTP __do_adjtimex function
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 440fd666c16d..c7dfe1000111 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1566,8 +1566,7 @@ config WARN_ALL_UNSEEDED_RANDOM
 	  so architecture maintainers really need to do what they can
 	  to get the CRNG seeded sooner after the system is booted.
 	  However, since users cannot do anything actionable to
-	  address this, by default the kernel will issue only a single
-	  warning for the first use of unseeded randomness.
+	  address this, by default this option is disabled.
 
 	  Say Y here if you want to receive warnings for all uses of
 	  unseeded randomness.  This will be of use primarily for
diff --git a/lib/random32.c b/lib/random32.c
index a57a0e18819d..976632003ec6 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -41,7 +41,6 @@
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include <asm/unaligned.h>
-#include <trace/events/random.h>
 
 /**
  *	prandom_u32_state - seeded pseudo-random number generator.
@@ -387,7 +386,6 @@ u32 prandom_u32(void)
 	struct siprand_state *state = get_cpu_ptr(&net_rand_state);
 	u32 res = siprand_u32(state);
 
-	trace_prandom_u32(res);
 	put_cpu_ptr(&net_rand_state);
 	return res;
 }
@@ -553,9 +551,11 @@ static void prandom_reseed(struct timer_list *unused)
  * To avoid worrying about whether it's safe to delay that interrupt
  * long enough to seed all CPUs, just schedule an immediate timer event.
  */
-static void prandom_timer_start(struct random_ready_callback *unused)
+static int prandom_timer_start(struct notifier_block *nb,
+			       unsigned long action, void *data)
 {
 	mod_timer(&seed_timer, jiffies);
+	return 0;
 }
 
 #ifdef CONFIG_RANDOM32_SELFTEST
@@ -619,13 +619,13 @@ core_initcall(prandom32_state_selftest);
  */
 static int __init prandom_init_late(void)
 {
-	static struct random_ready_callback random_ready = {
-		.func = prandom_timer_start
+	static struct notifier_block random_ready = {
+		.notifier_call = prandom_timer_start
 	};
-	int ret = add_random_ready_callback(&random_ready);
+	int ret = register_random_ready_notifier(&random_ready);
 
 	if (ret == -EALREADY) {
-		prandom_timer_start(&random_ready);
+		prandom_timer_start(&random_ready, 0, NULL);
 		ret = 0;
 	}
 	return ret;
diff --git a/lib/siphash.c b/lib/siphash.c
index 72b9068ab57b..71d315a6ad62 100644
--- a/lib/siphash.c
+++ b/lib/siphash.c
@@ -18,19 +18,13 @@
 #include <asm/word-at-a-time.h>
 #endif
 
-#define SIPROUND \
-	do { \
-	v0 += v1; v1 = rol64(v1, 13); v1 ^= v0; v0 = rol64(v0, 32); \
-	v2 += v3; v3 = rol64(v3, 16); v3 ^= v2; \
-	v0 += v3; v3 = rol64(v3, 21); v3 ^= v0; \
-	v2 += v1; v1 = rol64(v1, 17); v1 ^= v2; v2 = rol64(v2, 32); \
-	} while (0)
+#define SIPROUND SIPHASH_PERMUTATION(v0, v1, v2, v3)
 
 #define PREAMBLE(len) \
-	u64 v0 = 0x736f6d6570736575ULL; \
-	u64 v1 = 0x646f72616e646f6dULL; \
-	u64 v2 = 0x6c7967656e657261ULL; \
-	u64 v3 = 0x7465646279746573ULL; \
+	u64 v0 = SIPHASH_CONST_0; \
+	u64 v1 = SIPHASH_CONST_1; \
+	u64 v2 = SIPHASH_CONST_2; \
+	u64 v3 = SIPHASH_CONST_3; \
 	u64 b = ((u64)(len)) << 56; \
 	v3 ^= key->key[1]; \
 	v2 ^= key->key[0]; \
@@ -389,19 +383,13 @@ u32 hsiphash_4u32(const u32 first, const u32 second, const u32 third,
 }
 EXPORT_SYMBOL(hsiphash_4u32);
 #else
-#define HSIPROUND \
-	do { \
-	v0 += v1; v1 = rol32(v1, 5); v1 ^= v0; v0 = rol32(v0, 16); \
-	v2 += v3; v3 = rol32(v3, 8); v3 ^= v2; \
-	v0 += v3; v3 = rol32(v3, 7); v3 ^= v0; \
-	v2 += v1; v1 = rol32(v1, 13); v1 ^= v2; v2 = rol32(v2, 16); \
-	} while (0)
+#define HSIPROUND HSIPHASH_PERMUTATION(v0, v1, v2, v3)
 
 #define HPREAMBLE(len) \
-	u32 v0 = 0; \
-	u32 v1 = 0; \
-	u32 v2 = 0x6c796765U; \
-	u32 v3 = 0x74656462U; \
+	u32 v0 = HSIPHASH_CONST_0; \
+	u32 v1 = HSIPHASH_CONST_1; \
+	u32 v2 = HSIPHASH_CONST_2; \
+	u32 v3 = HSIPHASH_CONST_3; \
 	u32 b = ((u32)(len)) << 24; \
 	v3 ^= key->key[1]; \
 	v2 ^= key->key[0]; \
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index fbf261bbea95..35cc358f8dae 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -762,14 +762,16 @@ static void enable_ptr_key_workfn(struct work_struct *work)
 
 static DECLARE_WORK(enable_ptr_key_work, enable_ptr_key_workfn);
 
-static void fill_random_ptr_key(struct random_ready_callback *unused)
+static int fill_random_ptr_key(struct notifier_block *nb,
+			       unsigned long action, void *data)
 {
 	/* This may be in an interrupt handler. */
 	queue_work(system_unbound_wq, &enable_ptr_key_work);
+	return 0;
 }
 
-static struct random_ready_callback random_ready = {
-	.func = fill_random_ptr_key
+static struct notifier_block random_ready = {
+	.notifier_call = fill_random_ptr_key
 };
 
 static int __init initialize_ptr_random(void)
@@ -783,7 +785,7 @@ static int __init initialize_ptr_random(void)
 		return 0;
 	}
 
-	ret = add_random_ready_callback(&random_ready);
+	ret = register_random_ready_notifier(&random_ready);
 	if (!ret) {
 		return 0;
 	} else if (ret == -EALREADY) {
diff --git a/mm/util.c b/mm/util.c
index d3102081add0..5223d7e2f65e 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -343,6 +343,38 @@ unsigned long randomize_stack_top(unsigned long stack_top)
 #endif
 }
 
+/**
+ * randomize_page - Generate a random, page aligned address
+ * @start:	The smallest acceptable address the caller will take.
+ * @range:	The size of the area, starting at @start, within which the
+ *		random address must fall.
+ *
+ * If @start + @range would overflow, @range is capped.
+ *
+ * NOTE: Historical use of randomize_range, which this replaces, presumed that
+ * @start was already page aligned.  We now align it regardless.
+ *
+ * Return: A page aligned address within [start, start + range).  On error,
+ * @start is returned.
+ */
+unsigned long randomize_page(unsigned long start, unsigned long range)
+{
+	if (!PAGE_ALIGNED(start)) {
+		range -= PAGE_ALIGN(start) - start;
+		start = PAGE_ALIGN(start);
+	}
+
+	if (start > ULONG_MAX - range)
+		range = ULONG_MAX - start;
+
+	range >>= PAGE_SHIFT;
+
+	if (range == 0)
+		return start;
+
+	return start + (get_random_long() % range << PAGE_SHIFT);
+}
+
 #ifdef CONFIG_ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index 78f35e88aed6..fbdb8a3d5b8e 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -36,6 +36,7 @@
 			    | ((IEC958_AES3_CON_FS_48000) << 24))
 
 static const struct snd_pci_quirk subsys_20k1_list[] = {
+	SND_PCI_QUIRK(PCI_VENDOR_ID_CREATIVE, 0x0021, "SB046x", CTSB046X),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_CREATIVE, 0x0022, "SB055x", CTSB055X),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_CREATIVE, 0x002f, "SB055x", CTSB055X),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_CREATIVE, 0x0029, "SB073x", CTSB073X),
@@ -64,6 +65,7 @@ static const struct snd_pci_quirk subsys_20k2_list[] = {
 
 static const char *ct_subsys_name[NUM_CTCARDS] = {
 	/* 20k1 models */
+	[CTSB046X]	= "SB046x",
 	[CTSB055X]	= "SB055x",
 	[CTSB073X]	= "SB073x",
 	[CTUAA]		= "UAA",
diff --git a/sound/pci/ctxfi/cthardware.h b/sound/pci/ctxfi/cthardware.h
index f406b626a28c..2875cec83b8f 100644
--- a/sound/pci/ctxfi/cthardware.h
+++ b/sound/pci/ctxfi/cthardware.h
@@ -26,8 +26,9 @@ enum CHIPTYP {
 
 enum CTCARDS {
 	/* 20k1 models */
+	CTSB046X,
+	CT20K1_MODEL_FIRST = CTSB046X,
 	CTSB055X,
-	CT20K1_MODEL_FIRST = CTSB055X,
 	CTSB073X,
 	CTUAA,
 	CT20K1_UNKNOWN,

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE23556A786
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 18:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236045AbiGGQJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 12:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbiGGQJT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 12:09:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92CB53D37;
        Thu,  7 Jul 2022 09:08:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06327623D5;
        Thu,  7 Jul 2022 16:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798A8C3411E;
        Thu,  7 Jul 2022 16:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657210134;
        bh=vFVSlBpoNhevGGBiHF3LW+RdVMDwd0o7TI9ANdJ0xes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4wTEHt4UUxntXaSwXZvScCqbhoB9OAjX67AnA8iFVNqg6I4Btgce55h60Gya5tAN
         805aGp8RtfCix/BqtFZvPeY/BrOAPBl9u06a/MN7AyvsFDxBYtQfzO95f+S4WES86G
         ekolClINWnVElGIznWo3xldsg67EoxAaWn+CIRX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.53
Date:   Thu,  7 Jul 2022 18:08:40 +0200
Message-Id: <16572101209389@kroah.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <165721011919131@kroah.com>
References: <165721011919131@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/MAINTAINERS b/MAINTAINERS
index 393706e85ba2..a60d7e0466af 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20579,6 +20579,7 @@ F:	drivers/xen/*swiotlb*
 
 XFS FILESYSTEM
 C:	irc://irc.oftc.net/xfs
+M:	Leah Rumancik <leah.rumancik@gmail.com>
 M:	Darrick J. Wong <djwong@kernel.org>
 M:	linux-xfs@vger.kernel.org
 L:	linux-xfs@vger.kernel.org
diff --git a/Makefile b/Makefile
index 777e0a0eeccd..c7750d260a55 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 52
+SUBLEVEL = 53
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/xen/p2m.c b/arch/arm/xen/p2m.c
index 84a1cea1f43b..309648c17f48 100644
--- a/arch/arm/xen/p2m.c
+++ b/arch/arm/xen/p2m.c
@@ -63,11 +63,12 @@ static int xen_add_phys_to_mach_entry(struct xen_p2m_entry *new)
 
 unsigned long __pfn_to_mfn(unsigned long pfn)
 {
-	struct rb_node *n = phys_to_mach.rb_node;
+	struct rb_node *n;
 	struct xen_p2m_entry *entry;
 	unsigned long irqflags;
 
 	read_lock_irqsave(&p2m_lock, irqflags);
+	n = phys_to_mach.rb_node;
 	while (n) {
 		entry = rb_entry(n, struct xen_p2m_entry, rbnode_phys);
 		if (entry->pfn <= pfn &&
@@ -152,10 +153,11 @@ bool __set_phys_to_machine_multi(unsigned long pfn,
 	int rc;
 	unsigned long irqflags;
 	struct xen_p2m_entry *p2m_entry;
-	struct rb_node *n = phys_to_mach.rb_node;
+	struct rb_node *n;
 
 	if (mfn == INVALID_P2M_ENTRY) {
 		write_lock_irqsave(&p2m_lock, irqflags);
+		n = phys_to_mach.rb_node;
 		while (n) {
 			p2m_entry = rb_entry(n, struct xen_p2m_entry, rbnode_phys);
 			if (p2m_entry->pfn <= pfn &&
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 941618a7f7ff..27222b75d2a4 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -353,6 +353,10 @@ config ARCH_SUSPEND_NONZERO_CPU
 	def_bool y
 	depends on PPC_POWERNV || PPC_PSERIES
 
+config ARCH_HAS_ADD_PAGES
+	def_bool y
+	depends on ARCH_ENABLE_MEMORY_HOTPLUG
+
 config PPC_DCR_NATIVE
 	bool
 
diff --git a/arch/powerpc/include/asm/bpf_perf_event.h b/arch/powerpc/include/asm/bpf_perf_event.h
new file mode 100644
index 000000000000..e8a7b4ffb58c
--- /dev/null
+++ b/arch/powerpc/include/asm/bpf_perf_event.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_BPF_PERF_EVENT_H
+#define _ASM_POWERPC_BPF_PERF_EVENT_H
+
+#include <asm/ptrace.h>
+
+typedef struct user_pt_regs bpf_user_pt_regs_t;
+
+#endif /* _ASM_POWERPC_BPF_PERF_EVENT_H */
diff --git a/arch/powerpc/include/uapi/asm/bpf_perf_event.h b/arch/powerpc/include/uapi/asm/bpf_perf_event.h
deleted file mode 100644
index 5e1e648aeec4..000000000000
--- a/arch/powerpc/include/uapi/asm/bpf_perf_event.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _UAPI__ASM_BPF_PERF_EVENT_H__
-#define _UAPI__ASM_BPF_PERF_EVENT_H__
-
-#include <asm/ptrace.h>
-
-typedef struct user_pt_regs bpf_user_pt_regs_t;
-
-#endif /* _UAPI__ASM_BPF_PERF_EVENT_H__ */
diff --git a/arch/powerpc/kernel/prom_init_check.sh b/arch/powerpc/kernel/prom_init_check.sh
index b183ab9c5107..dfa5f729f774 100644
--- a/arch/powerpc/kernel/prom_init_check.sh
+++ b/arch/powerpc/kernel/prom_init_check.sh
@@ -13,7 +13,7 @@
 # If you really need to reference something from prom_init.o add
 # it to the list below:
 
-grep "^CONFIG_KASAN=y$" .config >/dev/null
+grep "^CONFIG_KASAN=y$" ${KCONFIG_CONFIG} >/dev/null
 if [ $? -eq 0 ]
 then
 	MEM_FUNCS="__memcpy __memset"
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 543a044560e9..6902f453c745 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -104,6 +104,37 @@ void __ref arch_remove_linear_mapping(u64 start, u64 size)
 	vm_unmap_aliases();
 }
 
+/*
+ * After memory hotplug the variables max_pfn, max_low_pfn and high_memory need
+ * updating.
+ */
+static void update_end_of_memory_vars(u64 start, u64 size)
+{
+	unsigned long end_pfn = PFN_UP(start + size);
+
+	if (end_pfn > max_pfn) {
+		max_pfn = end_pfn;
+		max_low_pfn = end_pfn;
+		high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
+	}
+}
+
+int __ref add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
+		    struct mhp_params *params)
+{
+	int ret;
+
+	ret = __add_pages(nid, start_pfn, nr_pages, params);
+	if (ret)
+		return ret;
+
+	/* update max_pfn, max_low_pfn and high_memory */
+	update_end_of_memory_vars(start_pfn << PAGE_SHIFT,
+				  nr_pages << PAGE_SHIFT);
+
+	return ret;
+}
+
 int __ref arch_add_memory(int nid, u64 start, u64 size,
 			  struct mhp_params *params)
 {
@@ -114,7 +145,7 @@ int __ref arch_add_memory(int nid, u64 start, u64 size,
 	rc = arch_create_linear_mapping(nid, start, size, params);
 	if (rc)
 		return rc;
-	rc = __add_pages(nid, start_pfn, nr_pages, params);
+	rc = add_pages(nid, start_pfn, nr_pages, params);
 	if (rc)
 		arch_remove_linear_mapping(start, size);
 	return rc;
diff --git a/arch/powerpc/mm/nohash/book3e_pgtable.c b/arch/powerpc/mm/nohash/book3e_pgtable.c
index 77884e24281d..3d845e001c87 100644
--- a/arch/powerpc/mm/nohash/book3e_pgtable.c
+++ b/arch/powerpc/mm/nohash/book3e_pgtable.c
@@ -95,8 +95,8 @@ int __ref map_kernel_page(unsigned long ea, unsigned long pa, pgprot_t prot)
 		pgdp = pgd_offset_k(ea);
 		p4dp = p4d_offset(pgdp, ea);
 		if (p4d_none(*p4dp)) {
-			pmdp = early_alloc_pgtable(PMD_TABLE_SIZE);
-			p4d_populate(&init_mm, p4dp, pmdp);
+			pudp = early_alloc_pgtable(PUD_TABLE_SIZE);
+			p4d_populate(&init_mm, p4dp, pudp);
 		}
 		pudp = pud_offset(p4dp, ea);
 		if (pud_none(*pudp)) {
@@ -105,7 +105,7 @@ int __ref map_kernel_page(unsigned long ea, unsigned long pa, pgprot_t prot)
 		}
 		pmdp = pmd_offset(pudp, ea);
 		if (!pmd_present(*pmdp)) {
-			ptep = early_alloc_pgtable(PAGE_SIZE);
+			ptep = early_alloc_pgtable(PTE_TABLE_SIZE);
 			pmd_populate_kernel(&init_mm, pmdp, ptep);
 		}
 		ptep = pte_offset_kernel(pmdp, ea);
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 797041b5109a..e402fa964f23 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -516,7 +516,6 @@ config KEXEC
 config KEXEC_FILE
 	bool "kexec file based system call"
 	select KEXEC_CORE
-	select BUILD_BIN2C
 	depends on CRYPTO
 	depends on CRYPTO_SHA256
 	depends on CRYPTO_SHA256_S390
diff --git a/arch/s390/crypto/arch_random.c b/arch/s390/crypto/arch_random.c
index 56007c763902..1f2d40993c4d 100644
--- a/arch/s390/crypto/arch_random.c
+++ b/arch/s390/crypto/arch_random.c
@@ -4,232 +4,15 @@
  *
  * Copyright IBM Corp. 2017, 2020
  * Author(s): Harald Freudenberger
- *
- * The s390_arch_random_generate() function may be called from random.c
- * in interrupt context. So this implementation does the best to be very
- * fast. There is a buffer of random data which is asynchronously checked
- * and filled by a workqueue thread.
- * If there are enough bytes in the buffer the s390_arch_random_generate()
- * just delivers these bytes. Otherwise false is returned until the
- * worker thread refills the buffer.
- * The worker fills the rng buffer by pulling fresh entropy from the
- * high quality (but slow) true hardware random generator. This entropy
- * is then spread over the buffer with an pseudo random generator PRNG.
- * As the arch_get_random_seed_long() fetches 8 bytes and the calling
- * function add_interrupt_randomness() counts this as 1 bit entropy the
- * distribution needs to make sure there is in fact 1 bit entropy contained
- * in 8 bytes of the buffer. The current values pull 32 byte entropy
- * and scatter this into a 2048 byte buffer. So 8 byte in the buffer
- * will contain 1 bit of entropy.
- * The worker thread is rescheduled based on the charge level of the
- * buffer but at least with 500 ms delay to avoid too much CPU consumption.
- * So the max. amount of rng data delivered via arch_get_random_seed is
- * limited to 4k bytes per second.
  */
 
 #include <linux/kernel.h>
 #include <linux/atomic.h>
 #include <linux/random.h>
-#include <linux/slab.h>
 #include <linux/static_key.h>
-#include <linux/workqueue.h>
-#include <linux/moduleparam.h>
 #include <asm/cpacf.h>
 
 DEFINE_STATIC_KEY_FALSE(s390_arch_random_available);
 
 atomic64_t s390_arch_random_counter = ATOMIC64_INIT(0);
 EXPORT_SYMBOL(s390_arch_random_counter);
-
-#define ARCH_REFILL_TICKS (HZ/2)
-#define ARCH_PRNG_SEED_SIZE 32
-#define ARCH_RNG_BUF_SIZE 2048
-
-static DEFINE_SPINLOCK(arch_rng_lock);
-static u8 *arch_rng_buf;
-static unsigned int arch_rng_buf_idx;
-
-static void arch_rng_refill_buffer(struct work_struct *);
-static DECLARE_DELAYED_WORK(arch_rng_work, arch_rng_refill_buffer);
-
-bool s390_arch_random_generate(u8 *buf, unsigned int nbytes)
-{
-	/* max hunk is ARCH_RNG_BUF_SIZE */
-	if (nbytes > ARCH_RNG_BUF_SIZE)
-		return false;
-
-	/* lock rng buffer */
-	if (!spin_trylock(&arch_rng_lock))
-		return false;
-
-	/* try to resolve the requested amount of bytes from the buffer */
-	arch_rng_buf_idx -= nbytes;
-	if (arch_rng_buf_idx < ARCH_RNG_BUF_SIZE) {
-		memcpy(buf, arch_rng_buf + arch_rng_buf_idx, nbytes);
-		atomic64_add(nbytes, &s390_arch_random_counter);
-		spin_unlock(&arch_rng_lock);
-		return true;
-	}
-
-	/* not enough bytes in rng buffer, refill is done asynchronously */
-	spin_unlock(&arch_rng_lock);
-
-	return false;
-}
-EXPORT_SYMBOL(s390_arch_random_generate);
-
-static void arch_rng_refill_buffer(struct work_struct *unused)
-{
-	unsigned int delay = ARCH_REFILL_TICKS;
-
-	spin_lock(&arch_rng_lock);
-	if (arch_rng_buf_idx > ARCH_RNG_BUF_SIZE) {
-		/* buffer is exhausted and needs refill */
-		u8 seed[ARCH_PRNG_SEED_SIZE];
-		u8 prng_wa[240];
-		/* fetch ARCH_PRNG_SEED_SIZE bytes of entropy */
-		cpacf_trng(NULL, 0, seed, sizeof(seed));
-		/* blow this entropy up to ARCH_RNG_BUF_SIZE with PRNG */
-		memset(prng_wa, 0, sizeof(prng_wa));
-		cpacf_prno(CPACF_PRNO_SHA512_DRNG_SEED,
-			   &prng_wa, NULL, 0, seed, sizeof(seed));
-		cpacf_prno(CPACF_PRNO_SHA512_DRNG_GEN,
-			   &prng_wa, arch_rng_buf, ARCH_RNG_BUF_SIZE, NULL, 0);
-		arch_rng_buf_idx = ARCH_RNG_BUF_SIZE;
-	}
-	delay += (ARCH_REFILL_TICKS * arch_rng_buf_idx) / ARCH_RNG_BUF_SIZE;
-	spin_unlock(&arch_rng_lock);
-
-	/* kick next check */
-	queue_delayed_work(system_long_wq, &arch_rng_work, delay);
-}
-
-/*
- * Here follows the implementation of s390_arch_get_random_long().
- *
- * The random longs to be pulled by arch_get_random_long() are
- * prepared in an 4K buffer which is filled from the NIST 800-90
- * compliant s390 drbg. By default the random long buffer is refilled
- * 256 times before the drbg itself needs a reseed. The reseed of the
- * drbg is done with 32 bytes fetched from the high quality (but slow)
- * trng which is assumed to deliver 100% entropy. So the 32 * 8 = 256
- * bits of entropy are spread over 256 * 4KB = 1MB serving 131072
- * arch_get_random_long() invocations before reseeded.
- *
- * How often the 4K random long buffer is refilled with the drbg
- * before the drbg is reseeded can be adjusted. There is a module
- * parameter 's390_arch_rnd_long_drbg_reseed' accessible via
- *   /sys/module/arch_random/parameters/rndlong_drbg_reseed
- * or as kernel command line parameter
- *   arch_random.rndlong_drbg_reseed=<value>
- * This parameter tells how often the drbg fills the 4K buffer before
- * it is re-seeded by fresh entropy from the trng.
- * A value of 16 results in reseeding the drbg at every 16 * 4 KB = 64
- * KB with 32 bytes of fresh entropy pulled from the trng. So a value
- * of 16 would result in 256 bits entropy per 64 KB.
- * A value of 256 results in 1MB of drbg output before a reseed of the
- * drbg is done. So this would spread the 256 bits of entropy among 1MB.
- * Setting this parameter to 0 forces the reseed to take place every
- * time the 4K buffer is depleted, so the entropy rises to 256 bits
- * entropy per 4K or 0.5 bit entropy per arch_get_random_long().  With
- * setting this parameter to negative values all this effort is
- * disabled, arch_get_random long() returns false and thus indicating
- * that the arch_get_random_long() feature is disabled at all.
- */
-
-static unsigned long rndlong_buf[512];
-static DEFINE_SPINLOCK(rndlong_lock);
-static int rndlong_buf_index;
-
-static int rndlong_drbg_reseed = 256;
-module_param_named(rndlong_drbg_reseed, rndlong_drbg_reseed, int, 0600);
-MODULE_PARM_DESC(rndlong_drbg_reseed, "s390 arch_get_random_long() drbg reseed");
-
-static inline void refill_rndlong_buf(void)
-{
-	static u8 prng_ws[240];
-	static int drbg_counter;
-
-	if (--drbg_counter < 0) {
-		/* need to re-seed the drbg */
-		u8 seed[32];
-
-		/* fetch seed from trng */
-		cpacf_trng(NULL, 0, seed, sizeof(seed));
-		/* seed drbg */
-		memset(prng_ws, 0, sizeof(prng_ws));
-		cpacf_prno(CPACF_PRNO_SHA512_DRNG_SEED,
-			   &prng_ws, NULL, 0, seed, sizeof(seed));
-		/* re-init counter for drbg */
-		drbg_counter = rndlong_drbg_reseed;
-	}
-
-	/* fill the arch_get_random_long buffer from drbg */
-	cpacf_prno(CPACF_PRNO_SHA512_DRNG_GEN, &prng_ws,
-		   (u8 *) rndlong_buf, sizeof(rndlong_buf),
-		   NULL, 0);
-}
-
-bool s390_arch_get_random_long(unsigned long *v)
-{
-	bool rc = false;
-	unsigned long flags;
-
-	/* arch_get_random_long() disabled ? */
-	if (rndlong_drbg_reseed < 0)
-		return false;
-
-	/* try to lock the random long lock */
-	if (!spin_trylock_irqsave(&rndlong_lock, flags))
-		return false;
-
-	if (--rndlong_buf_index >= 0) {
-		/* deliver next long value from the buffer */
-		*v = rndlong_buf[rndlong_buf_index];
-		rc = true;
-		goto out;
-	}
-
-	/* buffer is depleted and needs refill */
-	if (in_interrupt()) {
-		/* delay refill in interrupt context to next caller */
-		rndlong_buf_index = 0;
-		goto out;
-	}
-
-	/* refill random long buffer */
-	refill_rndlong_buf();
-	rndlong_buf_index = ARRAY_SIZE(rndlong_buf);
-
-	/* and provide one random long */
-	*v = rndlong_buf[--rndlong_buf_index];
-	rc = true;
-
-out:
-	spin_unlock_irqrestore(&rndlong_lock, flags);
-	return rc;
-}
-EXPORT_SYMBOL(s390_arch_get_random_long);
-
-static int __init s390_arch_random_init(void)
-{
-	/* all the needed PRNO subfunctions available ? */
-	if (cpacf_query_func(CPACF_PRNO, CPACF_PRNO_TRNG) &&
-	    cpacf_query_func(CPACF_PRNO, CPACF_PRNO_SHA512_DRNG_GEN)) {
-
-		/* alloc arch random working buffer */
-		arch_rng_buf = kmalloc(ARCH_RNG_BUF_SIZE, GFP_KERNEL);
-		if (!arch_rng_buf)
-			return -ENOMEM;
-
-		/* kick worker queue job to fill the random buffer */
-		queue_delayed_work(system_long_wq,
-				   &arch_rng_work, ARCH_REFILL_TICKS);
-
-		/* enable arch random to the outside world */
-		static_branch_enable(&s390_arch_random_available);
-	}
-
-	return 0;
-}
-arch_initcall(s390_arch_random_init);
diff --git a/arch/s390/include/asm/archrandom.h b/arch/s390/include/asm/archrandom.h
index 5dc712fde3c7..2c6e1c6ecbe7 100644
--- a/arch/s390/include/asm/archrandom.h
+++ b/arch/s390/include/asm/archrandom.h
@@ -15,17 +15,13 @@
 
 #include <linux/static_key.h>
 #include <linux/atomic.h>
+#include <asm/cpacf.h>
 
 DECLARE_STATIC_KEY_FALSE(s390_arch_random_available);
 extern atomic64_t s390_arch_random_counter;
 
-bool s390_arch_get_random_long(unsigned long *v);
-bool s390_arch_random_generate(u8 *buf, unsigned int nbytes);
-
 static inline bool __must_check arch_get_random_long(unsigned long *v)
 {
-	if (static_branch_likely(&s390_arch_random_available))
-		return s390_arch_get_random_long(v);
 	return false;
 }
 
@@ -37,7 +33,9 @@ static inline bool __must_check arch_get_random_int(unsigned int *v)
 static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 {
 	if (static_branch_likely(&s390_arch_random_available)) {
-		return s390_arch_random_generate((u8 *)v, sizeof(*v));
+		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
+		atomic64_add(sizeof(*v), &s390_arch_random_counter);
+		return true;
 	}
 	return false;
 }
@@ -45,7 +43,9 @@ static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 {
 	if (static_branch_likely(&s390_arch_random_available)) {
-		return s390_arch_random_generate((u8 *)v, sizeof(*v));
+		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
+		atomic64_add(sizeof(*v), &s390_arch_random_counter);
+		return true;
 	}
 	return false;
 }
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index ee67215a678a..8ede12c4ba6b 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -880,6 +880,11 @@ static void __init setup_randomness(void)
 	if (stsi(vmms, 3, 2, 2) == 0 && vmms->count)
 		add_device_randomness(&vmms->vm, sizeof(vmms->vm[0]) * vmms->count);
 	memblock_free((unsigned long) vmms, PAGE_SIZE);
+
+#ifdef CONFIG_ARCH_RANDOM
+	if (cpacf_query_func(CPACF_PRNO, CPACF_PRNO_TRNG))
+		static_branch_enable(&s390_arch_random_available);
+#endif
 }
 
 /*
diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 42ede059728c..007deb3a8ea3 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -73,6 +73,7 @@ module_param(device_id_scheme, bool, 0444);
 static int only_lcd = -1;
 module_param(only_lcd, int, 0444);
 
+static bool has_backlight;
 static int register_count;
 static DEFINE_MUTEX(register_count_mutex);
 static DEFINE_MUTEX(video_list_lock);
@@ -1222,6 +1223,9 @@ acpi_video_bus_get_one_device(struct acpi_device *device,
 	acpi_video_device_bind(video, data);
 	acpi_video_device_find_cap(data);
 
+	if (data->cap._BCM && data->cap._BCL)
+		has_backlight = true;
+
 	mutex_lock(&video->device_list_lock);
 	list_add_tail(&data->entry, &video->video_device_list);
 	mutex_unlock(&video->device_list_lock);
@@ -2251,6 +2255,7 @@ void acpi_video_unregister(void)
 	if (register_count) {
 		acpi_bus_unregister_driver(&acpi_video_bus);
 		register_count = 0;
+		has_backlight = false;
 	}
 	mutex_unlock(&register_count_mutex);
 }
@@ -2272,13 +2277,7 @@ void acpi_video_unregister_backlight(void)
 
 bool acpi_video_handles_brightness_key_presses(void)
 {
-	bool have_video_busses;
-
-	mutex_lock(&video_list_lock);
-	have_video_busses = !list_empty(&video_bus_head);
-	mutex_unlock(&video_list_lock);
-
-	return have_video_busses &&
+	return has_backlight &&
 	       (report_key_events & REPORT_BRIGHTNESS_KEY_EVENTS);
 }
 EXPORT_SYMBOL(acpi_video_handles_brightness_key_presses);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index d7a9bf43fb32..f6f679702b83 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -152,6 +152,10 @@ static unsigned int xen_blkif_max_ring_order;
 module_param_named(max_ring_page_order, xen_blkif_max_ring_order, int, 0444);
 MODULE_PARM_DESC(max_ring_page_order, "Maximum order of pages to be used for the shared ring");
 
+static bool __read_mostly xen_blkif_trusted = true;
+module_param_named(trusted, xen_blkif_trusted, bool, 0644);
+MODULE_PARM_DESC(trusted, "Is the backend trusted");
+
 #define BLK_RING_SIZE(info)	\
 	__CONST_RING_SIZE(blkif, XEN_PAGE_SIZE * (info)->nr_ring_pages)
 
@@ -209,6 +213,7 @@ struct blkfront_info
 	unsigned int feature_discard:1;
 	unsigned int feature_secdiscard:1;
 	unsigned int feature_persistent:1;
+	unsigned int bounce:1;
 	unsigned int discard_granularity;
 	unsigned int discard_alignment;
 	/* Number of 4KB segments handled */
@@ -311,8 +316,8 @@ static int fill_grant_buffer(struct blkfront_ring_info *rinfo, int num)
 		if (!gnt_list_entry)
 			goto out_of_memory;
 
-		if (info->feature_persistent) {
-			granted_page = alloc_page(GFP_NOIO);
+		if (info->bounce) {
+			granted_page = alloc_page(GFP_NOIO | __GFP_ZERO);
 			if (!granted_page) {
 				kfree(gnt_list_entry);
 				goto out_of_memory;
@@ -331,7 +336,7 @@ static int fill_grant_buffer(struct blkfront_ring_info *rinfo, int num)
 	list_for_each_entry_safe(gnt_list_entry, n,
 	                         &rinfo->grants, node) {
 		list_del(&gnt_list_entry->node);
-		if (info->feature_persistent)
+		if (info->bounce)
 			__free_page(gnt_list_entry->page);
 		kfree(gnt_list_entry);
 		i--;
@@ -377,7 +382,7 @@ static struct grant *get_grant(grant_ref_t *gref_head,
 	/* Assign a gref to this page */
 	gnt_list_entry->gref = gnttab_claim_grant_reference(gref_head);
 	BUG_ON(gnt_list_entry->gref == -ENOSPC);
-	if (info->feature_persistent)
+	if (info->bounce)
 		grant_foreign_access(gnt_list_entry, info);
 	else {
 		/* Grant access to the GFN passed by the caller */
@@ -401,7 +406,7 @@ static struct grant *get_indirect_grant(grant_ref_t *gref_head,
 	/* Assign a gref to this page */
 	gnt_list_entry->gref = gnttab_claim_grant_reference(gref_head);
 	BUG_ON(gnt_list_entry->gref == -ENOSPC);
-	if (!info->feature_persistent) {
+	if (!info->bounce) {
 		struct page *indirect_page;
 
 		/* Fetch a pre-allocated page to use for indirect grefs */
@@ -703,7 +708,7 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
 		.grant_idx = 0,
 		.segments = NULL,
 		.rinfo = rinfo,
-		.need_copy = rq_data_dir(req) && info->feature_persistent,
+		.need_copy = rq_data_dir(req) && info->bounce,
 	};
 
 	/*
@@ -981,11 +986,12 @@ static void xlvbd_flush(struct blkfront_info *info)
 {
 	blk_queue_write_cache(info->rq, info->feature_flush ? true : false,
 			      info->feature_fua ? true : false);
-	pr_info("blkfront: %s: %s %s %s %s %s\n",
+	pr_info("blkfront: %s: %s %s %s %s %s %s %s\n",
 		info->gd->disk_name, flush_info(info),
 		"persistent grants:", info->feature_persistent ?
 		"enabled;" : "disabled;", "indirect descriptors:",
-		info->max_indirect_segments ? "enabled;" : "disabled;");
+		info->max_indirect_segments ? "enabled;" : "disabled;",
+		"bounce buffer:", info->bounce ? "enabled" : "disabled;");
 }
 
 static int xen_translate_vdev(int vdevice, int *minor, unsigned int *offset)
@@ -1212,7 +1218,7 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
 	if (!list_empty(&rinfo->indirect_pages)) {
 		struct page *indirect_page, *n;
 
-		BUG_ON(info->feature_persistent);
+		BUG_ON(info->bounce);
 		list_for_each_entry_safe(indirect_page, n, &rinfo->indirect_pages, lru) {
 			list_del(&indirect_page->lru);
 			__free_page(indirect_page);
@@ -1229,7 +1235,7 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
 							  0, 0UL);
 				rinfo->persistent_gnts_c--;
 			}
-			if (info->feature_persistent)
+			if (info->bounce)
 				__free_page(persistent_gnt->page);
 			kfree(persistent_gnt);
 		}
@@ -1250,7 +1256,7 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
 		for (j = 0; j < segs; j++) {
 			persistent_gnt = rinfo->shadow[i].grants_used[j];
 			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
-			if (info->feature_persistent)
+			if (info->bounce)
 				__free_page(persistent_gnt->page);
 			kfree(persistent_gnt);
 		}
@@ -1440,7 +1446,7 @@ static int blkif_completion(unsigned long *id,
 	data.s = s;
 	num_sg = s->num_sg;
 
-	if (bret->operation == BLKIF_OP_READ && info->feature_persistent) {
+	if (bret->operation == BLKIF_OP_READ && info->bounce) {
 		for_each_sg(s->sg, sg, num_sg, i) {
 			BUG_ON(sg->offset + sg->length > PAGE_SIZE);
 
@@ -1499,7 +1505,7 @@ static int blkif_completion(unsigned long *id,
 				 * Add the used indirect page back to the list of
 				 * available pages for indirect grefs.
 				 */
-				if (!info->feature_persistent) {
+				if (!info->bounce) {
 					indirect_page = s->indirect_grants[i]->page;
 					list_add(&indirect_page->lru, &rinfo->indirect_pages);
 				}
@@ -1692,7 +1698,7 @@ static int setup_blkring(struct xenbus_device *dev,
 	for (i = 0; i < info->nr_ring_pages; i++)
 		rinfo->ring_ref[i] = GRANT_INVALID_REF;
 
-	sring = alloc_pages_exact(ring_size, GFP_NOIO);
+	sring = alloc_pages_exact(ring_size, GFP_NOIO | __GFP_ZERO);
 	if (!sring) {
 		xenbus_dev_fatal(dev, -ENOMEM, "allocating shared ring");
 		return -ENOMEM;
@@ -1790,6 +1796,10 @@ static int talk_to_blkback(struct xenbus_device *dev,
 	if (!info)
 		return -ENODEV;
 
+	/* Check if backend is trusted. */
+	info->bounce = !xen_blkif_trusted ||
+		       !xenbus_read_unsigned(dev->nodename, "trusted", 1);
+
 	max_page_order = xenbus_read_unsigned(info->xbdev->otherend,
 					      "max-ring-page-order", 0);
 	ring_page_order = min(xen_blkif_max_ring_order, max_page_order);
@@ -2199,17 +2209,18 @@ static int blkfront_setup_indirect(struct blkfront_ring_info *rinfo)
 	if (err)
 		goto out_of_memory;
 
-	if (!info->feature_persistent && info->max_indirect_segments) {
+	if (!info->bounce && info->max_indirect_segments) {
 		/*
-		 * We are using indirect descriptors but not persistent
-		 * grants, we need to allocate a set of pages that can be
+		 * We are using indirect descriptors but don't have a bounce
+		 * buffer, we need to allocate a set of pages that can be
 		 * used for mapping indirect grefs
 		 */
 		int num = INDIRECT_GREFS(grants) * BLK_RING_SIZE(info);
 
 		BUG_ON(!list_empty(&rinfo->indirect_pages));
 		for (i = 0; i < num; i++) {
-			struct page *indirect_page = alloc_page(GFP_KERNEL);
+			struct page *indirect_page = alloc_page(GFP_KERNEL |
+			                                        __GFP_ZERO);
 			if (!indirect_page)
 				goto out_of_memory;
 			list_add(&indirect_page->lru, &rinfo->indirect_pages);
@@ -2302,6 +2313,8 @@ static void blkfront_gather_backend_features(struct blkfront_info *info)
 		info->feature_persistent =
 			!!xenbus_read_unsigned(info->xbdev->otherend,
 					       "feature-persistent", 0);
+	if (info->feature_persistent)
+		info->bounce = true;
 
 	indirect_segments = xenbus_read_unsigned(info->xbdev->otherend,
 					"feature-max-indirect-segments", 0);
@@ -2565,6 +2578,13 @@ static void blkfront_delay_work(struct work_struct *work)
 	struct blkfront_info *info;
 	bool need_schedule_work = false;
 
+	/*
+	 * Note that when using bounce buffers but not persistent grants
+	 * there's no need to run blkfront_delay_work because grants are
+	 * revoked in blkif_completion or else an error is reported and the
+	 * connection is closed.
+	 */
+
 	mutex_lock(&blkfront_mutex);
 
 	list_for_each_entry(info, &info_list, info_list) {
diff --git a/drivers/clocksource/timer-ixp4xx.c b/drivers/clocksource/timer-ixp4xx.c
index cbb184953510..b8e92991c471 100644
--- a/drivers/clocksource/timer-ixp4xx.c
+++ b/drivers/clocksource/timer-ixp4xx.c
@@ -282,7 +282,6 @@ void __init ixp4xx_timer_setup(resource_size_t timerbase,
 	}
 	ixp4xx_timer_register(base, timer_irq, timer_freq);
 }
-EXPORT_SYMBOL_GPL(ixp4xx_timer_setup);
 
 #ifdef CONFIG_OF
 static __init int ixp4xx_of_timer_init(struct device_node *np)
diff --git a/drivers/cpufreq/qoriq-cpufreq.c b/drivers/cpufreq/qoriq-cpufreq.c
index 6b6b20da2bcf..573b417e1483 100644
--- a/drivers/cpufreq/qoriq-cpufreq.c
+++ b/drivers/cpufreq/qoriq-cpufreq.c
@@ -275,6 +275,7 @@ static int qoriq_cpufreq_probe(struct platform_device *pdev)
 
 	np = of_find_matching_node(NULL, qoriq_cpufreq_blacklist);
 	if (np) {
+		of_node_put(np);
 		dev_info(&pdev->dev, "Disabling due to erratum A-008083");
 		return -ENODEV;
 	}
diff --git a/drivers/devfreq/event/exynos-ppmu.c b/drivers/devfreq/event/exynos-ppmu.c
index 17ed980d9099..d6da9c3e3106 100644
--- a/drivers/devfreq/event/exynos-ppmu.c
+++ b/drivers/devfreq/event/exynos-ppmu.c
@@ -514,15 +514,19 @@ static int of_get_devfreq_events(struct device_node *np,
 
 	count = of_get_child_count(events_np);
 	desc = devm_kcalloc(dev, count, sizeof(*desc), GFP_KERNEL);
-	if (!desc)
+	if (!desc) {
+		of_node_put(events_np);
 		return -ENOMEM;
+	}
 	info->num_events = count;
 
 	of_id = of_match_device(exynos_ppmu_id_match, dev);
 	if (of_id)
 		info->ppmu_type = (enum exynos_ppmu_type)of_id->data;
-	else
+	else {
+		of_node_put(events_np);
 		return -EINVAL;
+	}
 
 	j = 0;
 	for_each_child_of_node(events_np, node) {
diff --git a/drivers/fsi/fsi-occ.c b/drivers/fsi/fsi-occ.c
index b223f0ef337b..ecf738411fe2 100644
--- a/drivers/fsi/fsi-occ.c
+++ b/drivers/fsi/fsi-occ.c
@@ -50,6 +50,7 @@ struct occ {
 	struct device *sbefifo;
 	char name[32];
 	int idx;
+	u8 sequence_number;
 	enum versions version;
 	struct miscdevice mdev;
 	struct mutex occ_lock;
@@ -141,8 +142,7 @@ static ssize_t occ_write(struct file *file, const char __user *buf,
 {
 	struct occ_client *client = file->private_data;
 	size_t rlen, data_length;
-	u16 checksum = 0;
-	ssize_t rc, i;
+	ssize_t rc;
 	u8 *cmd;
 
 	if (!client)
@@ -156,9 +156,6 @@ static ssize_t occ_write(struct file *file, const char __user *buf,
 	/* Construct the command */
 	cmd = client->buffer;
 
-	/* Sequence number (we could increment and compare with response) */
-	cmd[0] = 1;
-
 	/*
 	 * Copy the user command (assume user data follows the occ command
 	 * format)
@@ -178,14 +175,7 @@ static ssize_t occ_write(struct file *file, const char __user *buf,
 		goto done;
 	}
 
-	/* Calculate checksum */
-	for (i = 0; i < data_length + 4; ++i)
-		checksum += cmd[i];
-
-	cmd[data_length + 4] = checksum >> 8;
-	cmd[data_length + 5] = checksum & 0xFF;
-
-	/* Submit command */
+	/* Submit command; 4 bytes before the data and 2 bytes after */
 	rlen = PAGE_SIZE;
 	rc = fsi_occ_submit(client->occ->dev, cmd, data_length + 6, cmd,
 			    &rlen);
@@ -314,11 +304,13 @@ static int occ_getsram(struct occ *occ, u32 offset, void *data, ssize_t len)
 	return rc;
 }
 
-static int occ_putsram(struct occ *occ, const void *data, ssize_t len)
+static int occ_putsram(struct occ *occ, const void *data, ssize_t len,
+		       u8 seq_no, u16 checksum)
 {
 	size_t cmd_len, buf_len, resp_len, resp_data_len;
 	u32 data_len = ((len + 7) / 8) * 8;	/* must be multiples of 8 B */
 	__be32 *buf;
+	u8 *byte_buf;
 	int idx = 0, rc;
 
 	cmd_len = (occ->version == occ_p10) ? 6 : 5;
@@ -358,6 +350,15 @@ static int occ_putsram(struct occ *occ, const void *data, ssize_t len)
 	buf[4 + idx] = cpu_to_be32(data_len);
 	memcpy(&buf[5 + idx], data, len);
 
+	byte_buf = (u8 *)&buf[5 + idx];
+	/*
+	 * Overwrite the first byte with our sequence number and the last two
+	 * bytes with the checksum.
+	 */
+	byte_buf[0] = seq_no;
+	byte_buf[len - 2] = checksum >> 8;
+	byte_buf[len - 1] = checksum & 0xff;
+
 	rc = sbefifo_submit(occ->sbefifo, buf, cmd_len, buf, &resp_len);
 	if (rc)
 		goto free;
@@ -467,9 +468,12 @@ int fsi_occ_submit(struct device *dev, const void *request, size_t req_len,
 	struct occ *occ = dev_get_drvdata(dev);
 	struct occ_response *resp = response;
 	u8 seq_no;
+	u16 checksum = 0;
 	u16 resp_data_length;
+	const u8 *byte_request = (const u8 *)request;
 	unsigned long start;
 	int rc;
+	size_t i;
 
 	if (!occ)
 		return -ENODEV;
@@ -479,11 +483,26 @@ int fsi_occ_submit(struct device *dev, const void *request, size_t req_len,
 		return -EINVAL;
 	}
 
+	/* Checksum the request, ignoring first byte (sequence number). */
+	for (i = 1; i < req_len - 2; ++i)
+		checksum += byte_request[i];
+
 	mutex_lock(&occ->occ_lock);
 
-	/* Extract the seq_no from the command (first byte) */
-	seq_no = *(const u8 *)request;
-	rc = occ_putsram(occ, request, req_len);
+	/*
+	 * Get a sequence number and update the counter. Avoid a sequence
+	 * number of 0 which would pass the response check below even if the
+	 * OCC response is uninitialized. Any sequence number the user is
+	 * trying to send is overwritten since this function is the only common
+	 * interface to the OCC and therefore the only place we can guarantee
+	 * unique sequence numbers.
+	 */
+	seq_no = occ->sequence_number++;
+	if (!occ->sequence_number)
+		occ->sequence_number = 1;
+	checksum += seq_no;
+
+	rc = occ_putsram(occ, request, req_len, seq_no, checksum);
 	if (rc)
 		goto done;
 
@@ -574,6 +593,7 @@ static int occ_probe(struct platform_device *pdev)
 	occ->version = (uintptr_t)of_device_get_match_data(dev);
 	occ->dev = dev;
 	occ->sbefifo = dev->parent;
+	occ->sequence_number = 1;
 	mutex_init(&occ->occ_lock);
 
 	if (dev->of_node) {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
index 1d41c2c00623..5690cb6d27fe 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -768,7 +768,8 @@ int amdgpu_amdkfd_flush_gpu_tlb_pasid(struct kgd_dev *kgd, uint16_t pasid,
 	struct amdgpu_device *adev = (struct amdgpu_device *)kgd;
 	bool all_hub = false;
 
-	if (adev->family == AMDGPU_FAMILY_AI)
+	if (adev->family == AMDGPU_FAMILY_AI ||
+	    adev->family == AMDGPU_FAMILY_RV)
 		all_hub = true;
 
 	return amdgpu_gmc_flush_gpu_tlb_pasid(adev, pasid, flush_type, all_hub);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
index 4f3c62adccbd..cc2e0c9cfe0a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -333,6 +333,7 @@ int amdgpu_irq_init(struct amdgpu_device *adev)
 	if (!amdgpu_device_has_dc_support(adev)) {
 		if (!adev->enable_virtual_display)
 			/* Disable vblank IRQs aggressively for power-saving */
+			/* XXX: can this be enabled for DC? */
 			adev_to_drm(adev)->vblank_disable_immediate = true;
 
 		r = drm_vblank_init(adev_to_drm(adev), adev->mode_info.num_crtc);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index d2aecf7bf66b..d35a6f6d158e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3838,9 +3838,6 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 	}
 #endif
 
-	/* Disable vblank IRQs aggressively for power-saving. */
-	adev_to_drm(adev)->vblank_disable_immediate = true;
-
 	/* loops over all connectors on the board */
 	for (i = 0; i < link_cnt; i++) {
 		struct dc_link *link = NULL;
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index 166bb46408a9..ee0c0b712522 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -720,8 +720,9 @@ static int set_proto_ctx_param(struct drm_i915_file_private *fpriv,
 	case I915_CONTEXT_PARAM_PERSISTENCE:
 		if (args->size)
 			ret = -EINVAL;
-		ret = proto_context_set_persistence(fpriv->dev_priv, pc,
-						    args->value);
+		else
+			ret = proto_context_set_persistence(fpriv->dev_priv, pc,
+							    args->value);
 		break;
 
 	case I915_CONTEXT_PARAM_NO_ZEROMAP:
diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 7fb7ff043bcd..1f74bab9e231 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -889,7 +889,7 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 	submit->fence_id = idr_alloc_cyclic(&queue->fence_idr,
 			submit->user_fence, 1, INT_MAX, GFP_KERNEL);
 	if (submit->fence_id < 0) {
-		ret = submit->fence_id = 0;
+		ret = submit->fence_id;
 		submit->fence_id = 0;
 		goto out;
 	}
diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index a4ec85207782..2e6d6a5cffa1 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -550,7 +550,7 @@ static int aem_init_aem1_inst(struct aem_ipmi_data *probe, u8 module_handle)
 
 	res = platform_device_add(data->pdev);
 	if (res)
-		goto ipmi_err;
+		goto dev_add_err;
 
 	platform_set_drvdata(data->pdev, data);
 
@@ -598,7 +598,9 @@ static int aem_init_aem1_inst(struct aem_ipmi_data *probe, u8 module_handle)
 	ipmi_destroy_user(data->ipmi.user);
 ipmi_err:
 	platform_set_drvdata(data->pdev, NULL);
-	platform_device_unregister(data->pdev);
+	platform_device_del(data->pdev);
+dev_add_err:
+	platform_device_put(data->pdev);
 dev_err:
 	ida_simple_remove(&aem_ida, data->id);
 id_err:
@@ -690,7 +692,7 @@ static int aem_init_aem2_inst(struct aem_ipmi_data *probe,
 
 	res = platform_device_add(data->pdev);
 	if (res)
-		goto ipmi_err;
+		goto dev_add_err;
 
 	platform_set_drvdata(data->pdev, data);
 
@@ -738,7 +740,9 @@ static int aem_init_aem2_inst(struct aem_ipmi_data *probe,
 	ipmi_destroy_user(data->ipmi.user);
 ipmi_err:
 	platform_set_drvdata(data->pdev, NULL);
-	platform_device_unregister(data->pdev);
+	platform_device_del(data->pdev);
+dev_add_err:
+	platform_device_put(data->pdev);
 dev_err:
 	ida_simple_remove(&aem_ida, data->id);
 id_err:
diff --git a/drivers/hwmon/occ/common.c b/drivers/hwmon/occ/common.c
index ae664613289c..bbe5e4ef4113 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -132,22 +132,20 @@ struct extended_sensor {
 static int occ_poll(struct occ *occ)
 {
 	int rc;
-	u16 checksum = occ->poll_cmd_data + occ->seq_no + 1;
-	u8 cmd[8];
+	u8 cmd[7];
 	struct occ_poll_response_header *header;
 
 	/* big endian */
-	cmd[0] = occ->seq_no++;		/* sequence number */
+	cmd[0] = 0;			/* sequence number */
 	cmd[1] = 0;			/* cmd type */
 	cmd[2] = 0;			/* data length msb */
 	cmd[3] = 1;			/* data length lsb */
 	cmd[4] = occ->poll_cmd_data;	/* data */
-	cmd[5] = checksum >> 8;		/* checksum msb */
-	cmd[6] = checksum & 0xFF;	/* checksum lsb */
-	cmd[7] = 0;
+	cmd[5] = 0;			/* checksum msb */
+	cmd[6] = 0;			/* checksum lsb */
 
 	/* mutex should already be locked if necessary */
-	rc = occ->send_cmd(occ, cmd);
+	rc = occ->send_cmd(occ, cmd, sizeof(cmd), &occ->resp, sizeof(occ->resp));
 	if (rc) {
 		occ->last_error = rc;
 		if (occ->error_count++ > OCC_ERROR_COUNT_THRESHOLD)
@@ -184,25 +182,24 @@ static int occ_set_user_power_cap(struct occ *occ, u16 user_power_cap)
 {
 	int rc;
 	u8 cmd[8];
-	u16 checksum = 0x24;
+	u8 resp[8];
 	__be16 user_power_cap_be = cpu_to_be16(user_power_cap);
 
-	cmd[0] = 0;
-	cmd[1] = 0x22;
-	cmd[2] = 0;
-	cmd[3] = 2;
+	cmd[0] = 0;	/* sequence number */
+	cmd[1] = 0x22;	/* cmd type */
+	cmd[2] = 0;	/* data length msb */
+	cmd[3] = 2;	/* data length lsb */
 
 	memcpy(&cmd[4], &user_power_cap_be, 2);
 
-	checksum += cmd[4] + cmd[5];
-	cmd[6] = checksum >> 8;
-	cmd[7] = checksum & 0xFF;
+	cmd[6] = 0;	/* checksum msb */
+	cmd[7] = 0;	/* checksum lsb */
 
 	rc = mutex_lock_interruptible(&occ->lock);
 	if (rc)
 		return rc;
 
-	rc = occ->send_cmd(occ, cmd);
+	rc = occ->send_cmd(occ, cmd, sizeof(cmd), resp, sizeof(resp));
 
 	mutex_unlock(&occ->lock);
 
@@ -1144,8 +1141,6 @@ int occ_setup(struct occ *occ, const char *name)
 {
 	int rc;
 
-	/* start with 1 to avoid false match with zero-initialized SRAM buffer */
-	occ->seq_no = 1;
 	mutex_init(&occ->lock);
 	occ->groups[0] = &occ->group;
 
diff --git a/drivers/hwmon/occ/common.h b/drivers/hwmon/occ/common.h
index e6df719770e8..7abf19102062 100644
--- a/drivers/hwmon/occ/common.h
+++ b/drivers/hwmon/occ/common.h
@@ -95,9 +95,9 @@ struct occ {
 	struct occ_sensors sensors;
 
 	int powr_sample_time_us;	/* average power sample time */
-	u8 seq_no;
 	u8 poll_cmd_data;		/* to perform OCC poll command */
-	int (*send_cmd)(struct occ *occ, u8 *cmd);
+	int (*send_cmd)(struct occ *occ, u8 *cmd, size_t len, void *resp,
+			size_t resp_len);
 
 	unsigned long next_update;
 	struct mutex lock;		/* lock OCC access */
diff --git a/drivers/hwmon/occ/p8_i2c.c b/drivers/hwmon/occ/p8_i2c.c
index 0cf8588be35a..c35c07964d85 100644
--- a/drivers/hwmon/occ/p8_i2c.c
+++ b/drivers/hwmon/occ/p8_i2c.c
@@ -97,18 +97,22 @@ static int p8_i2c_occ_putscom_u32(struct i2c_client *client, u32 address,
 }
 
 static int p8_i2c_occ_putscom_be(struct i2c_client *client, u32 address,
-				 u8 *data)
+				 u8 *data, size_t len)
 {
-	__be32 data0, data1;
+	__be32 data0 = 0, data1 = 0;
 
-	memcpy(&data0, data, 4);
-	memcpy(&data1, data + 4, 4);
+	memcpy(&data0, data, min_t(size_t, len, 4));
+	if (len > 4) {
+		len -= 4;
+		memcpy(&data1, data + 4, min_t(size_t, len, 4));
+	}
 
 	return p8_i2c_occ_putscom_u32(client, address, be32_to_cpu(data0),
 				      be32_to_cpu(data1));
 }
 
-static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd)
+static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len,
+			       void *resp, size_t resp_len)
 {
 	int i, rc;
 	unsigned long start;
@@ -117,7 +121,7 @@ static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd)
 	const long wait_time = msecs_to_jiffies(OCC_CMD_IN_PRG_WAIT_MS);
 	struct p8_i2c_occ *ctx = to_p8_i2c_occ(occ);
 	struct i2c_client *client = ctx->client;
-	struct occ_response *resp = &occ->resp;
+	struct occ_response *or = (struct occ_response *)resp;
 
 	start = jiffies;
 
@@ -127,7 +131,7 @@ static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd)
 		return rc;
 
 	/* write command (expected to already be BE), we need bus-endian... */
-	rc = p8_i2c_occ_putscom_be(client, OCB_DATA3, cmd);
+	rc = p8_i2c_occ_putscom_be(client, OCB_DATA3, cmd, len);
 	if (rc)
 		return rc;
 
@@ -148,7 +152,7 @@ static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd)
 			return rc;
 
 		/* wait for OCC */
-		if (resp->return_status == OCC_RESP_CMD_IN_PRG) {
+		if (or->return_status == OCC_RESP_CMD_IN_PRG) {
 			rc = -EALREADY;
 
 			if (time_after(jiffies, start + timeout))
@@ -160,7 +164,7 @@ static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd)
 	} while (rc);
 
 	/* check the OCC response */
-	switch (resp->return_status) {
+	switch (or->return_status) {
 	case OCC_RESP_CMD_IN_PRG:
 		rc = -ETIMEDOUT;
 		break;
@@ -189,8 +193,8 @@ static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd)
 	if (rc < 0)
 		return rc;
 
-	data_length = get_unaligned_be16(&resp->data_length);
-	if (data_length > OCC_RESP_DATA_BYTES)
+	data_length = get_unaligned_be16(&or->data_length);
+	if ((data_length + 7) > resp_len)
 		return -EMSGSIZE;
 
 	/* fetch the rest of the response data */
diff --git a/drivers/hwmon/occ/p9_sbe.c b/drivers/hwmon/occ/p9_sbe.c
index f6387cc0b754..14923e78e1f3 100644
--- a/drivers/hwmon/occ/p9_sbe.c
+++ b/drivers/hwmon/occ/p9_sbe.c
@@ -16,18 +16,17 @@ struct p9_sbe_occ {
 
 #define to_p9_sbe_occ(x)	container_of((x), struct p9_sbe_occ, occ)
 
-static int p9_sbe_occ_send_cmd(struct occ *occ, u8 *cmd)
+static int p9_sbe_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len,
+			       void *resp, size_t resp_len)
 {
-	struct occ_response *resp = &occ->resp;
 	struct p9_sbe_occ *ctx = to_p9_sbe_occ(occ);
-	size_t resp_len = sizeof(*resp);
 	int rc;
 
-	rc = fsi_occ_submit(ctx->sbe, cmd, 8, resp, &resp_len);
+	rc = fsi_occ_submit(ctx->sbe, cmd, len, resp, &resp_len);
 	if (rc < 0)
 		return rc;
 
-	switch (resp->return_status) {
+	switch (((struct occ_response *)resp)->return_status) {
 	case OCC_RESP_CMD_IN_PRG:
 		rc = -ETIMEDOUT;
 		break;
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 1c107d6d03b9..b985e0d9bc05 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1252,8 +1252,10 @@ struct ib_cm_id *ib_cm_insert_listen(struct ib_device *device,
 		return ERR_CAST(cm_id_priv);
 
 	err = cm_init_listen(cm_id_priv, service_id, 0);
-	if (err)
+	if (err) {
+		ib_destroy_cm_id(&cm_id_priv->id);
 		return ERR_PTR(err);
+	}
 
 	spin_lock_irq(&cm_id_priv->lock);
 	listen_id_priv = cm_insert_listen(cm_id_priv, cm_handler);
diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 8def88cfa300..db9ef3e1eb97 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -418,6 +418,7 @@ struct qedr_qp {
 	u32 sq_psn;
 	u32 qkey;
 	u32 dest_qp_num;
+	u8 timeout;
 
 	/* Relevant to qps created from kernel space only (ULPs) */
 	u8 prev_wqe_size;
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index f652d083ff20..49dfedbc5665 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2622,6 +2622,8 @@ int qedr_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 					1 << max_t(int, attr->timeout - 8, 0);
 		else
 			qp_params.ack_timeout = 0;
+
+		qp->timeout = attr->timeout;
 	}
 
 	if (attr_mask & IB_QP_RETRY_CNT) {
@@ -2781,7 +2783,7 @@ int qedr_query_qp(struct ib_qp *ibqp,
 	rdma_ah_set_dgid_raw(&qp_attr->ah_attr, &params.dgid.bytes[0]);
 	rdma_ah_set_port_num(&qp_attr->ah_attr, 1);
 	rdma_ah_set_sl(&qp_attr->ah_attr, 0);
-	qp_attr->timeout = params.timeout;
+	qp_attr->timeout = qp->timeout;
 	qp_attr->rnr_retry = params.rnr_retry;
 	qp_attr->retry_cnt = params.retry_cnt;
 	qp_attr->min_rnr_timer = params.min_rnr_nak_timer;
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index d9ef52159a22..b0566aabc186 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1001,12 +1001,13 @@ static int validate_region_size(struct raid_set *rs, unsigned long region_size)
 static int validate_raid_redundancy(struct raid_set *rs)
 {
 	unsigned int i, rebuild_cnt = 0;
-	unsigned int rebuilds_per_group = 0, copies;
+	unsigned int rebuilds_per_group = 0, copies, raid_disks;
 	unsigned int group_size, last_group_start;
 
-	for (i = 0; i < rs->md.raid_disks; i++)
-		if (!test_bit(In_sync, &rs->dev[i].rdev.flags) ||
-		    !rs->dev[i].rdev.sb_page)
+	for (i = 0; i < rs->raid_disks; i++)
+		if (!test_bit(FirstUse, &rs->dev[i].rdev.flags) &&
+		    ((!test_bit(In_sync, &rs->dev[i].rdev.flags) ||
+		      !rs->dev[i].rdev.sb_page)))
 			rebuild_cnt++;
 
 	switch (rs->md.level) {
@@ -1046,8 +1047,9 @@ static int validate_raid_redundancy(struct raid_set *rs)
 		 *	    A	 A    B	   B	C
 		 *	    C	 D    D	   E	E
 		 */
+		raid_disks = min(rs->raid_disks, rs->md.raid_disks);
 		if (__is_raid10_near(rs->md.new_layout)) {
-			for (i = 0; i < rs->md.raid_disks; i++) {
+			for (i = 0; i < raid_disks; i++) {
 				if (!(i % copies))
 					rebuilds_per_group = 0;
 				if ((!rs->dev[i].rdev.sb_page ||
@@ -1070,10 +1072,10 @@ static int validate_raid_redundancy(struct raid_set *rs)
 		 * results in the need to treat the last (potentially larger)
 		 * set differently.
 		 */
-		group_size = (rs->md.raid_disks / copies);
-		last_group_start = (rs->md.raid_disks / group_size) - 1;
+		group_size = (raid_disks / copies);
+		last_group_start = (raid_disks / group_size) - 1;
 		last_group_start *= group_size;
-		for (i = 0; i < rs->md.raid_disks; i++) {
+		for (i = 0; i < raid_disks; i++) {
 			if (!(i % copies) && !(i > last_group_start))
 				rebuilds_per_group = 0;
 			if ((!rs->dev[i].rdev.sb_page ||
@@ -1588,7 +1590,7 @@ static sector_t __rdev_sectors(struct raid_set *rs)
 {
 	int i;
 
-	for (i = 0; i < rs->md.raid_disks; i++) {
+	for (i = 0; i < rs->raid_disks; i++) {
 		struct md_rdev *rdev = &rs->dev[i].rdev;
 
 		if (!test_bit(Journal, &rdev->flags) &&
@@ -3771,13 +3773,13 @@ static int raid_iterate_devices(struct dm_target *ti,
 	unsigned int i;
 	int r = 0;
 
-	for (i = 0; !r && i < rs->md.raid_disks; i++)
-		if (rs->dev[i].data_dev)
-			r = fn(ti,
-				 rs->dev[i].data_dev,
-				 0, /* No offset on data devs */
-				 rs->md.dev_sectors,
-				 data);
+	for (i = 0; !r && i < rs->raid_disks; i++) {
+		if (rs->dev[i].data_dev) {
+			r = fn(ti, rs->dev[i].data_dev,
+			       0, /* No offset on data devs */
+			       rs->md.dev_sectors, data);
+		}
+	}
 
 	return r;
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e54d802ee0bb..b58984ddca13 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8026,6 +8026,7 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	 */
 	if (rdev->saved_raid_disk >= 0 &&
 	    rdev->saved_raid_disk >= first &&
+	    rdev->saved_raid_disk <= last &&
 	    conf->disks[rdev->saved_raid_disk].rdev == NULL)
 		first = rdev->saved_raid_disk;
 
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index a86b1f71762e..d7fb33c078e8 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2228,7 +2228,8 @@ void bond_3ad_unbind_slave(struct slave *slave)
 				temp_aggregator->num_of_ports--;
 				if (__agg_active_ports(temp_aggregator) == 0) {
 					select_new_active_agg = temp_aggregator->is_active;
-					ad_clear_agg(temp_aggregator);
+					if (temp_aggregator->num_of_ports == 0)
+						ad_clear_agg(temp_aggregator);
 					if (select_new_active_agg) {
 						slave_info(bond->dev, slave->dev, "Removing an active aggregator\n");
 						/* select new active aggregator */
diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index bca36be884b8..a6a70b872ac4 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1281,12 +1281,12 @@ int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
 		return res;
 
 	if (rlb_enabled) {
-		bond->alb_info.rlb_enabled = 1;
 		res = rlb_initialize(bond);
 		if (res) {
 			tlb_deinitialize(bond);
 			return res;
 		}
+		bond->alb_info.rlb_enabled = 1;
 	} else {
 		bond->alb_info.rlb_enabled = 0;
 	}
diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index 91230894692d..da87de02b2fc 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -721,13 +721,21 @@ static int cfv_probe(struct virtio_device *vdev)
 	/* Carrier is off until netdevice is opened */
 	netif_carrier_off(netdev);
 
+	/* serialize netdev register + virtio_device_ready() with ndo_open() */
+	rtnl_lock();
+
 	/* register Netdev */
-	err = register_netdev(netdev);
+	err = register_netdevice(netdev);
 	if (err) {
+		rtnl_unlock();
 		dev_err(&vdev->dev, "Unable to register netdev (%d)\n", err);
 		goto err;
 	}
 
+	virtio_device_ready(vdev);
+
+	rtnl_unlock();
+
 	debugfs_init(cfv);
 
 	return 0;
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index b3a43a3d90e4..d76b2377d66e 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -865,6 +865,11 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 		if (duplex == DUPLEX_FULL)
 			reg |= DUPLX_MODE;
 
+		if (tx_pause)
+			reg |= TXFLOW_CNTL;
+		if (rx_pause)
+			reg |= RXFLOW_CNTL;
+
 		core_writel(priv, reg, offset);
 	}
 
diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
index 2572c6087bb5..b28baab6d56a 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
@@ -300,6 +300,7 @@ static int hellcreek_led_setup(struct hellcreek *hellcreek)
 	const char *label, *state;
 	int ret = -EINVAL;
 
+	of_node_get(hellcreek->dev->of_node);
 	leds = of_find_node_by_name(hellcreek->dev->of_node, "leds");
 	if (!leds) {
 		dev_err(hellcreek->dev, "No LEDs specified in device tree!\n");
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 19bb3ca0515e..d7d90cdce4f6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4293,6 +4293,8 @@ static int mlxsw_sp_nexthop4_init(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_nexthop_neigh_init:
+	list_del(&nh->router_list_node);
+	mlxsw_sp_nexthop_counter_free(mlxsw_sp, nh);
 	mlxsw_sp_nexthop_remove(mlxsw_sp, nh);
 	return err;
 }
@@ -6578,6 +6580,7 @@ static int mlxsw_sp_nexthop6_init(struct mlxsw_sp *mlxsw_sp,
 				  const struct fib6_info *rt)
 {
 	struct net_device *dev = rt->fib6_nh->fib_nh_dev;
+	int err;
 
 	nh->nhgi = nh_grp->nhgi;
 	nh->nh_weight = rt->fib6_nh->fib_nh_weight;
@@ -6593,7 +6596,16 @@ static int mlxsw_sp_nexthop6_init(struct mlxsw_sp *mlxsw_sp,
 		return 0;
 	nh->ifindex = dev->ifindex;
 
-	return mlxsw_sp_nexthop_type_init(mlxsw_sp, nh, dev);
+	err = mlxsw_sp_nexthop_type_init(mlxsw_sp, nh, dev);
+	if (err)
+		goto err_nexthop_type_init;
+
+	return 0;
+
+err_nexthop_type_init:
+	list_del(&nh->router_list_node);
+	mlxsw_sp_nexthop_counter_free(mlxsw_sp, nh);
+	return err;
 }
 
 static void mlxsw_sp_nexthop6_fini(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/ethernet/smsc/epic100.c b/drivers/net/ethernet/smsc/epic100.c
index 44daf79a8f97..f3b1af9a59e8 100644
--- a/drivers/net/ethernet/smsc/epic100.c
+++ b/drivers/net/ethernet/smsc/epic100.c
@@ -1513,14 +1513,14 @@ static void epic_remove_one(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct epic_private *ep = netdev_priv(dev);
 
+	unregister_netdev(dev);
 	dma_free_coherent(&pdev->dev, TX_TOTAL_SIZE, ep->tx_ring,
 			  ep->tx_ring_dma);
 	dma_free_coherent(&pdev->dev, RX_TOTAL_SIZE, ep->rx_ring,
 			  ep->rx_ring_dma);
-	unregister_netdev(dev);
 	pci_iounmap(pdev, ep->ioaddr);
-	pci_release_regions(pdev);
 	free_netdev(dev);
+	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	/* pci_power_off(pdev, -1); */
 }
diff --git a/drivers/net/phy/ax88796b.c b/drivers/net/phy/ax88796b.c
index 457896337505..0f1e617a26c9 100644
--- a/drivers/net/phy/ax88796b.c
+++ b/drivers/net/phy/ax88796b.c
@@ -88,8 +88,10 @@ static void asix_ax88772a_link_change_notify(struct phy_device *phydev)
 	/* Reset PHY, otherwise MII_LPA will provide outdated information.
 	 * This issue is reproducible only with some link partner PHYs
 	 */
-	if (phydev->state == PHY_NOLINK && phydev->drv->soft_reset)
-		phydev->drv->soft_reset(phydev);
+	if (phydev->state == PHY_NOLINK) {
+		phy_init_hw(phydev);
+		phy_start_aneg(phydev);
+	}
 }
 
 static struct phy_driver asix_driver[] = {
diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index ce17b2af3218..a792dd6d2ec3 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -228,9 +228,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 		if (misr_status < 0)
 			return misr_status;
 
-		misr_status |= (DP83822_RX_ERR_HF_INT_EN |
-				DP83822_FALSE_CARRIER_HF_INT_EN |
-				DP83822_LINK_STAT_INT_EN |
+		misr_status |= (DP83822_LINK_STAT_INT_EN |
 				DP83822_ENERGY_DET_INT_EN |
 				DP83822_LINK_QUAL_INT_EN);
 
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index f122026c4682..2fc851082e7b 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -31,6 +31,7 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <linux/atomic.h>
+#include <linux/suspend.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
 #include <net/sock.h>
@@ -972,6 +973,28 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 	struct phy_driver *drv = phydev->drv;
 	irqreturn_t ret;
 
+	/* Wakeup interrupts may occur during a system sleep transition.
+	 * Postpone handling until the PHY has resumed.
+	 */
+	if (IS_ENABLED(CONFIG_PM_SLEEP) && phydev->irq_suspended) {
+		struct net_device *netdev = phydev->attached_dev;
+
+		if (netdev) {
+			struct device *parent = netdev->dev.parent;
+
+			if (netdev->wol_enabled)
+				pm_system_wakeup();
+			else if (device_may_wakeup(&netdev->dev))
+				pm_wakeup_dev_event(&netdev->dev, 0, true);
+			else if (parent && device_may_wakeup(parent))
+				pm_wakeup_dev_event(parent, 0, true);
+		}
+
+		phydev->irq_rerun = 1;
+		disable_irq_nosync(irq);
+		return IRQ_HANDLED;
+	}
+
 	mutex_lock(&phydev->lock);
 	ret = drv->handle_interrupt(phydev);
 	mutex_unlock(&phydev->lock);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 28f4a383aba7..0d3f8fe8e42c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -277,6 +277,15 @@ static __maybe_unused int mdio_bus_phy_suspend(struct device *dev)
 	if (phydev->mac_managed_pm)
 		return 0;
 
+	/* Wakeup interrupts may occur during the system sleep transition when
+	 * the PHY is inaccessible. Set flag to postpone handling until the PHY
+	 * has resumed. Wait for concurrent interrupt handler to complete.
+	 */
+	if (phy_interrupt_is_valid(phydev)) {
+		phydev->irq_suspended = 1;
+		synchronize_irq(phydev->irq);
+	}
+
 	/* We must stop the state machine manually, otherwise it stops out of
 	 * control, possibly with the phydev->lock held. Upon resume, netdev
 	 * may call phy routines that try to grab the same lock, and that may
@@ -314,6 +323,20 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 	if (ret < 0)
 		return ret;
 no_resume:
+	if (phy_interrupt_is_valid(phydev)) {
+		phydev->irq_suspended = 0;
+		synchronize_irq(phydev->irq);
+
+		/* Rerun interrupts which were postponed by phy_interrupt()
+		 * because they occurred during the system sleep transition.
+		 */
+		if (phydev->irq_rerun) {
+			phydev->irq_rerun = 0;
+			enable_irq(phydev->irq);
+			irq_wake_thread(phydev->irq, phydev);
+		}
+	}
+
 	if (phydev->attached_dev && phydev->adjust_link)
 		phy_start_machine(phydev);
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 02de8d998bfa..ea60453fe69a 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -274,6 +274,12 @@ static void tun_napi_init(struct tun_struct *tun, struct tun_file *tfile,
 	}
 }
 
+static void tun_napi_enable(struct tun_file *tfile)
+{
+	if (tfile->napi_enabled)
+		napi_enable(&tfile->napi);
+}
+
 static void tun_napi_disable(struct tun_file *tfile)
 {
 	if (tfile->napi_enabled)
@@ -635,7 +641,8 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 	tun = rtnl_dereference(tfile->tun);
 
 	if (tun && clean) {
-		tun_napi_disable(tfile);
+		if (!tfile->detached)
+			tun_napi_disable(tfile);
 		tun_napi_del(tfile);
 	}
 
@@ -654,8 +661,10 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 		if (clean) {
 			RCU_INIT_POINTER(tfile->tun, NULL);
 			sock_put(&tfile->sk);
-		} else
+		} else {
 			tun_disable_queue(tun, tfile);
+			tun_napi_disable(tfile);
+		}
 
 		synchronize_net();
 		tun_flow_delete_by_queue(tun, tun->numqueues + 1);
@@ -728,6 +737,7 @@ static void tun_detach_all(struct net_device *dev)
 		sock_put(&tfile->sk);
 	}
 	list_for_each_entry_safe(tfile, tmp, &tun->disabled, next) {
+		tun_napi_del(tfile);
 		tun_enable_queue(tfile);
 		tun_queue_purge(tfile);
 		xdp_rxq_info_unreg(&tfile->xdp_rxq);
@@ -808,6 +818,7 @@ static int tun_attach(struct tun_struct *tun, struct file *file,
 
 	if (tfile->detached) {
 		tun_enable_queue(tfile);
+		tun_napi_enable(tfile);
 	} else {
 		sock_hold(&tfile->sk);
 		tun_napi_init(tun, tfile, napi, napi_frags);
diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index 4334aafab59a..c126df1c13ee 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -126,8 +126,7 @@
 	 AX_MEDIUM_RE)
 
 #define AX88772_MEDIUM_DEFAULT	\
-	(AX_MEDIUM_FD | AX_MEDIUM_RFC | \
-	 AX_MEDIUM_TFC | AX_MEDIUM_PS | \
+	(AX_MEDIUM_FD | AX_MEDIUM_PS | \
 	 AX_MEDIUM_AC | AX_MEDIUM_RE)
 
 /* AX88772 & AX88178 RX_CTL values */
diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index f39188b7717a..00c23f1d1c94 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -431,6 +431,7 @@ void asix_adjust_link(struct net_device *netdev)
 
 	asix_write_medium_mode(dev, mode, 0);
 	phy_print_status(phydev);
+	usbnet_link_change(dev, phydev->link, 0);
 }
 
 int asix_write_gpio(struct usbnet *dev, u16 value, int sleep, int in_pm)
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index d5ce642200e8..0a2c3860179e 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1471,6 +1471,42 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	 * are bundled into this buffer and where we can find an array of
 	 * per-packet metadata (which contains elements encoded into u16).
 	 */
+
+	/* SKB contents for current firmware:
+	 *   <packet 1> <padding>
+	 *   ...
+	 *   <packet N> <padding>
+	 *   <per-packet metadata entry 1> <dummy header>
+	 *   ...
+	 *   <per-packet metadata entry N> <dummy header>
+	 *   <padding2> <rx_hdr>
+	 *
+	 * where:
+	 *   <packet N> contains pkt_len bytes:
+	 *		2 bytes of IP alignment pseudo header
+	 *		packet received
+	 *   <per-packet metadata entry N> contains 4 bytes:
+	 *		pkt_len and fields AX_RXHDR_*
+	 *   <padding>	0-7 bytes to terminate at
+	 *		8 bytes boundary (64-bit).
+	 *   <padding2> 4 bytes to make rx_hdr terminate at
+	 *		8 bytes boundary (64-bit)
+	 *   <dummy-header> contains 4 bytes:
+	 *		pkt_len=0 and AX_RXHDR_DROP_ERR
+	 *   <rx-hdr>	contains 4 bytes:
+	 *		pkt_cnt and hdr_off (offset of
+	 *		  <per-packet metadata entry 1>)
+	 *
+	 * pkt_cnt is number of entrys in the per-packet metadata.
+	 * In current firmware there is 2 entrys per packet.
+	 * The first points to the packet and the
+	 *  second is a dummy header.
+	 * This was done probably to align fields in 64-bit and
+	 *  maintain compatibility with old firmware.
+	 * This code assumes that <dummy header> and <padding2> are
+	 *  optional.
+	 */
+
 	if (skb->len < 4)
 		return 0;
 	skb_trim(skb, skb->len - 4);
@@ -1484,51 +1520,66 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	/* Make sure that the bounds of the metadata array are inside the SKB
 	 * (and in front of the counter at the end).
 	 */
-	if (pkt_cnt * 2 + hdr_off > skb->len)
+	if (pkt_cnt * 4 + hdr_off > skb->len)
 		return 0;
 	pkt_hdr = (u32 *)(skb->data + hdr_off);
 
 	/* Packets must not overlap the metadata array */
 	skb_trim(skb, hdr_off);
 
-	for (; ; pkt_cnt--, pkt_hdr++) {
+	for (; pkt_cnt > 0; pkt_cnt--, pkt_hdr++) {
+		u16 pkt_len_plus_padd;
 		u16 pkt_len;
 
 		le32_to_cpus(pkt_hdr);
 		pkt_len = (*pkt_hdr >> 16) & 0x1fff;
+		pkt_len_plus_padd = (pkt_len + 7) & 0xfff8;
 
-		if (pkt_len > skb->len)
+		/* Skip dummy header used for alignment
+		 */
+		if (pkt_len == 0)
+			continue;
+
+		if (pkt_len_plus_padd > skb->len)
 			return 0;
 
 		/* Check CRC or runt packet */
-		if (((*pkt_hdr & (AX_RXHDR_CRC_ERR | AX_RXHDR_DROP_ERR)) == 0) &&
-		    pkt_len >= 2 + ETH_HLEN) {
-			bool last = (pkt_cnt == 0);
-
-			if (last) {
-				ax_skb = skb;
-			} else {
-				ax_skb = skb_clone(skb, GFP_ATOMIC);
-				if (!ax_skb)
-					return 0;
-			}
-			ax_skb->len = pkt_len;
-			/* Skip IP alignment pseudo header */
-			skb_pull(ax_skb, 2);
-			skb_set_tail_pointer(ax_skb, ax_skb->len);
-			ax_skb->truesize = pkt_len + sizeof(struct sk_buff);
-			ax88179_rx_checksum(ax_skb, pkt_hdr);
+		if ((*pkt_hdr & (AX_RXHDR_CRC_ERR | AX_RXHDR_DROP_ERR)) ||
+		    pkt_len < 2 + ETH_HLEN) {
+			dev->net->stats.rx_errors++;
+			skb_pull(skb, pkt_len_plus_padd);
+			continue;
+		}
 
-			if (last)
-				return 1;
+		/* last packet */
+		if (pkt_len_plus_padd == skb->len) {
+			skb_trim(skb, pkt_len);
 
-			usbnet_skb_return(dev, ax_skb);
+			/* Skip IP alignment pseudo header */
+			skb_pull(skb, 2);
+
+			skb->truesize = SKB_TRUESIZE(pkt_len_plus_padd);
+			ax88179_rx_checksum(skb, pkt_hdr);
+			return 1;
 		}
 
-		/* Trim this packet away from the SKB */
-		if (!skb_pull(skb, (pkt_len + 7) & 0xFFF8))
+		ax_skb = skb_clone(skb, GFP_ATOMIC);
+		if (!ax_skb)
 			return 0;
+		skb_trim(ax_skb, pkt_len);
+
+		/* Skip IP alignment pseudo header */
+		skb_pull(ax_skb, 2);
+
+		skb->truesize = pkt_len_plus_padd +
+				SKB_DATA_ALIGN(sizeof(struct sk_buff));
+		ax88179_rx_checksum(ax_skb, pkt_hdr);
+		usbnet_skb_return(dev, ax_skb);
+
+		skb_pull(skb, pkt_len_plus_padd);
 	}
+
+	return 0;
 }
 
 static struct sk_buff *
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 0c7f02ca6822..3e1aab1e894e 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1355,6 +1355,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1070, 2)},	/* Telit FN990 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},	/* Telit ME910 dual modem */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index af2bbaff2478..a0ea236ac60e 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -2002,7 +2002,7 @@ static int __usbnet_read_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
 		   cmd, reqtype, value, index, size);
 
 	if (size) {
-		buf = kmalloc(size, GFP_KERNEL);
+		buf = kmalloc(size, GFP_NOIO);
 		if (!buf)
 			goto out;
 	}
@@ -2034,7 +2034,7 @@ static int __usbnet_write_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
 		   cmd, reqtype, value, index, size);
 
 	if (data) {
-		buf = kmemdup(data, size, GFP_KERNEL);
+		buf = kmemdup(data, size, GFP_NOIO);
 		if (!buf)
 			goto out;
 	} else {
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 468d0ffc266b..318c681ad63e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3241,14 +3241,20 @@ static int virtnet_probe(struct virtio_device *vdev)
 		}
 	}
 
-	err = register_netdev(dev);
+	/* serialize netdev register + virtio_device_ready() with ndo_open() */
+	rtnl_lock();
+
+	err = register_netdevice(dev);
 	if (err) {
 		pr_debug("virtio_net: registering device failed\n");
+		rtnl_unlock();
 		goto free_failover;
 	}
 
 	virtio_device_ready(vdev);
 
+	rtnl_unlock();
+
 	err = virtnet_cpu_notif_add(vi);
 	if (err) {
 		pr_debug("virtio_net: registering cpu notifier failed\n");
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 2492a27467b4..074dceb1930b 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -66,6 +66,10 @@ module_param_named(max_queues, xennet_max_queues, uint, 0644);
 MODULE_PARM_DESC(max_queues,
 		 "Maximum number of queues per virtual interface");
 
+static bool __read_mostly xennet_trusted = true;
+module_param_named(trusted, xennet_trusted, bool, 0644);
+MODULE_PARM_DESC(trusted, "Is the backend trusted");
+
 #define XENNET_TIMEOUT  (5 * HZ)
 
 static const struct ethtool_ops xennet_ethtool_ops;
@@ -175,6 +179,9 @@ struct netfront_info {
 	/* Is device behaving sane? */
 	bool broken;
 
+	/* Should skbs be bounced into a zeroed buffer? */
+	bool bounce;
+
 	atomic_t rx_gso_checksum_fixup;
 };
 
@@ -273,7 +280,8 @@ static struct sk_buff *xennet_alloc_one_rx_buffer(struct netfront_queue *queue)
 	if (unlikely(!skb))
 		return NULL;
 
-	page = page_pool_dev_alloc_pages(queue->page_pool);
+	page = page_pool_alloc_pages(queue->page_pool,
+				     GFP_ATOMIC | __GFP_NOWARN | __GFP_ZERO);
 	if (unlikely(!page)) {
 		kfree_skb(skb);
 		return NULL;
@@ -667,6 +675,33 @@ static int xennet_xdp_xmit(struct net_device *dev, int n,
 	return nxmit;
 }
 
+struct sk_buff *bounce_skb(const struct sk_buff *skb)
+{
+	unsigned int headerlen = skb_headroom(skb);
+	/* Align size to allocate full pages and avoid contiguous data leaks */
+	unsigned int size = ALIGN(skb_end_offset(skb) + skb->data_len,
+				  XEN_PAGE_SIZE);
+	struct sk_buff *n = alloc_skb(size, GFP_ATOMIC | __GFP_ZERO);
+
+	if (!n)
+		return NULL;
+
+	if (!IS_ALIGNED((uintptr_t)n->head, XEN_PAGE_SIZE)) {
+		WARN_ONCE(1, "misaligned skb allocated\n");
+		kfree_skb(n);
+		return NULL;
+	}
+
+	/* Set the data pointer */
+	skb_reserve(n, headerlen);
+	/* Set the tail pointer and length */
+	skb_put(n, skb->len);
+
+	BUG_ON(skb_copy_bits(skb, -headerlen, n->head, headerlen + skb->len));
+
+	skb_copy_header(n, skb);
+	return n;
+}
 
 #define MAX_XEN_SKB_FRAGS (65536 / XEN_PAGE_SIZE + 1)
 
@@ -720,9 +755,13 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 
 	/* The first req should be at least ETH_HLEN size or the packet will be
 	 * dropped by netback.
+	 *
+	 * If the backend is not trusted bounce all data to zeroed pages to
+	 * avoid exposing contiguous data on the granted page not belonging to
+	 * the skb.
 	 */
-	if (unlikely(PAGE_SIZE - offset < ETH_HLEN)) {
-		nskb = skb_copy(skb, GFP_ATOMIC);
+	if (np->bounce || unlikely(PAGE_SIZE - offset < ETH_HLEN)) {
+		nskb = bounce_skb(skb);
 		if (!nskb)
 			goto drop;
 		dev_consume_skb_any(skb);
@@ -1055,8 +1094,10 @@ static int xennet_get_responses(struct netfront_queue *queue,
 			}
 		}
 		rcu_read_unlock();
-next:
+
 		__skb_queue_tail(list, skb);
+
+next:
 		if (!(rx->flags & XEN_NETRXF_more_data))
 			break;
 
@@ -2246,6 +2287,10 @@ static int talk_to_netback(struct xenbus_device *dev,
 
 	info->netdev->irq = 0;
 
+	/* Check if backend is trusted. */
+	info->bounce = !xennet_trusted ||
+		       !xenbus_read_unsigned(dev->nodename, "trusted", 1);
+
 	/* Check if backend supports multiple queues */
 	max_queues = xenbus_read_unsigned(info->xbdev->otherend,
 					  "multi-queue-max-queues", 1);
@@ -2412,6 +2457,9 @@ static int xennet_connect(struct net_device *dev)
 		return err;
 	if (np->netback_has_xdp_headroom)
 		pr_info("backend supports XDP headroom\n");
+	if (np->bounce)
+		dev_info(&np->xbdev->dev,
+			 "bouncing transmitted data to zeroed pages\n");
 
 	/* talk_to_netback() sets the correct number of queues */
 	num_queues = dev->real_num_tx_queues;
diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index ceef81d93ac9..01329b91d59d 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -167,9 +167,9 @@ static int nfcmrvl_i2c_parse_dt(struct device_node *node,
 		pdata->irq_polarity = IRQF_TRIGGER_RISING;
 
 	ret = irq_of_parse_and_map(node, 0);
-	if (ret < 0) {
-		pr_err("Unable to get irq, error: %d\n", ret);
-		return ret;
+	if (!ret) {
+		pr_err("Unable to get irq\n");
+		return -EINVAL;
 	}
 	pdata->irq = ret;
 
diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
index 5b833a9a83f8..abd75779194c 100644
--- a/drivers/nfc/nfcmrvl/spi.c
+++ b/drivers/nfc/nfcmrvl/spi.c
@@ -115,9 +115,9 @@ static int nfcmrvl_spi_parse_dt(struct device_node *node,
 	}
 
 	ret = irq_of_parse_and_map(node, 0);
-	if (ret < 0) {
-		pr_err("Unable to get irq, error: %d\n", ret);
-		return ret;
+	if (!ret) {
+		pr_err("Unable to get irq\n");
+		return -EINVAL;
 	}
 	pdata->irq = ret;
 
diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 7e451c10985d..e8f3b35afbee 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -162,6 +162,9 @@ static int nxp_nci_i2c_nci_read(struct nxp_nci_i2c_phy *phy,
 
 	skb_put_data(*skb, (void *)&header, NCI_CTRL_HDR_SIZE);
 
+	if (!header.plen)
+		return 0;
+
 	r = i2c_master_recv(client, skb_put(*skb, header.plen), header.plen);
 	if (r != header.plen) {
 		nfc_err(&client->dev,
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 9dc7f3edd42b..84d197cc09f8 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -185,8 +185,8 @@ static int nvdimm_clear_badblocks_region(struct device *dev, void *data)
 	ndr_end = nd_region->ndr_start + nd_region->ndr_size - 1;
 
 	/* make sure we are in the region */
-	if (ctx->phys < nd_region->ndr_start
-			|| (ctx->phys + ctx->cleared) > ndr_end)
+	if (ctx->phys < nd_region->ndr_start ||
+	    (ctx->phys + ctx->cleared - 1) > ndr_end)
 		return 0;
 
 	sector = (ctx->phys - nd_region->ndr_start) / 512;
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 58b8461b2b0f..c3db9f12dac3 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3341,8 +3341,11 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(0x1b4b, 0x1092),	/* Lexar 256 GB SSD */
 		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	{ PCI_DEVICE(0x1cc1, 0x33f8),   /* ADATA IM2P33F8ABR1 1 TB */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x10ec, 0x5762),   /* ADATA SX6000LNP */
-		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN |
+				NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1cc1, 0x8201),   /* ADATA SX8200PNP 512GB */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index e21ea3d23e6f..f1ff003bb14b 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -871,6 +871,8 @@ config PANASONIC_LAPTOP
 	tristate "Panasonic Laptop Extras"
 	depends on INPUT && ACPI
 	depends on BACKLIGHT_CLASS_DEVICE
+	depends on ACPI_VIDEO=n || ACPI_VIDEO
+	depends on SERIO_I8042 || SERIO_I8042 = n
 	select INPUT_SPARSEKMAP
 	help
 	  This driver adds support for access to backlight control and hotkeys
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index d4f444401496..7ca49b3fc6c2 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -119,20 +119,22 @@
  *		- v0.1  start from toshiba_acpi driver written by John Belmonte
  */
 
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/types.h>
+#include <linux/acpi.h>
 #include <linux/backlight.h>
 #include <linux/ctype.h>
-#include <linux/seq_file.h>
-#include <linux/uaccess.h>
-#include <linux/slab.h>
-#include <linux/acpi.h>
+#include <linux/i8042.h>
+#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
-
+#include <linux/seq_file.h>
+#include <linux/serio.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <acpi/video.h>
 
 MODULE_AUTHOR("Hiroshi Miura <miura@da-cha.org>");
 MODULE_AUTHOR("David Bronaugh <dbronaugh@linuxboxen.org>");
@@ -241,6 +243,42 @@ struct pcc_acpi {
 	struct platform_device	*platform;
 };
 
+/*
+ * On some Panasonic models the volume up / down / mute keys send duplicate
+ * keypress events over the PS/2 kbd interface, filter these out.
+ */
+static bool panasonic_i8042_filter(unsigned char data, unsigned char str,
+				   struct serio *port)
+{
+	static bool extended;
+
+	if (str & I8042_STR_AUXDATA)
+		return false;
+
+	if (data == 0xe0) {
+		extended = true;
+		return true;
+	} else if (extended) {
+		extended = false;
+
+		switch (data & 0x7f) {
+		case 0x20: /* e0 20 / e0 a0, Volume Mute press / release */
+		case 0x2e: /* e0 2e / e0 ae, Volume Down press / release */
+		case 0x30: /* e0 30 / e0 b0, Volume Up press / release */
+			return true;
+		default:
+			/*
+			 * Report the previously filtered e0 before continuing
+			 * with the next non-filtered byte.
+			 */
+			serio_interrupt(port, 0xe0, 0);
+			return false;
+		}
+	}
+
+	return false;
+}
+
 /* method access functions */
 static int acpi_pcc_write_sset(struct pcc_acpi *pcc, int func, int val)
 {
@@ -762,6 +800,8 @@ static void acpi_pcc_generate_keyinput(struct pcc_acpi *pcc)
 	struct input_dev *hotk_input_dev = pcc->input_dev;
 	int rc;
 	unsigned long long result;
+	unsigned int key;
+	unsigned int updown;
 
 	rc = acpi_evaluate_integer(pcc->handle, METHOD_HKEY_QUERY,
 				   NULL, &result);
@@ -770,20 +810,27 @@ static void acpi_pcc_generate_keyinput(struct pcc_acpi *pcc)
 		return;
 	}
 
+	key = result & 0xf;
+	updown = result & 0x80; /* 0x80 == key down; 0x00 = key up */
+
 	/* hack: some firmware sends no key down for sleep / hibernate */
-	if ((result & 0xf) == 0x7 || (result & 0xf) == 0xa) {
-		if (result & 0x80)
+	if (key == 7 || key == 10) {
+		if (updown)
 			sleep_keydown_seen = 1;
 		if (!sleep_keydown_seen)
 			sparse_keymap_report_event(hotk_input_dev,
-					result & 0xf, 0x80, false);
+					key, 0x80, false);
 	}
 
-	if ((result & 0xf) == 0x7 || (result & 0xf) == 0x9 || (result & 0xf) == 0xa) {
-		if (!sparse_keymap_report_event(hotk_input_dev,
-						result & 0xf, result & 0x80, false))
-			pr_err("Unknown hotkey event: 0x%04llx\n", result);
-	}
+	/*
+	 * Don't report brightness key-presses if they are also reported
+	 * by the ACPI video bus.
+	 */
+	if ((key == 1 || key == 2) && acpi_video_handles_brightness_key_presses())
+		return;
+
+	if (!sparse_keymap_report_event(hotk_input_dev, key, updown, false))
+		pr_err("Unknown hotkey event: 0x%04llx\n", result);
 }
 
 static void acpi_pcc_hotkey_notify(struct acpi_device *device, u32 event)
@@ -997,6 +1044,7 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 		pcc->platform = NULL;
 	}
 
+	i8042_install_filter(panasonic_i8042_filter);
 	return 0;
 
 out_platform:
@@ -1020,6 +1068,8 @@ static int acpi_pcc_hotkey_remove(struct acpi_device *device)
 	if (!device || !pcc)
 		return -EINVAL;
 
+	i8042_remove_filter(panasonic_i8042_filter);
+
 	if (pcc->platform) {
 		device_remove_file(&pcc->platform->dev, &dev_attr_cdpower);
 		platform_device_unregister(pcc->platform);
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index e4258f40dcd7..174895372e7f 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1698,6 +1698,8 @@ static void mlx5_vdpa_set_vq_cb(struct vdpa_device *vdev, u16 idx, struct vdpa_c
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
 
 	ndev->event_cbs[idx] = *cb;
+	if (is_ctrl_vq_idx(mvdev, idx))
+		mvdev->cvq.event_cb = *cb;
 }
 
 static void mlx5_cvq_notify(struct vringh *vring)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index a8470a98f84d..189323740324 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4788,6 +4788,8 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 	if (unlikely(sqe->addr2 || sqe->file_index))
 		return -EINVAL;
+	if (unlikely(sqe->addr2 || sqe->file_index || sqe->ioprio))
+		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
@@ -5011,6 +5013,8 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 	if (unlikely(sqe->addr2 || sqe->file_index))
 		return -EINVAL;
+	if (unlikely(sqe->addr2 || sqe->file_index || sqe->ioprio))
+		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 1ed3046dd5b3..876afde0ea66 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7684,7 +7684,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 	{
 		struct file_zero_data_information *zero_data;
 		struct ksmbd_file *fp;
-		loff_t off, len;
+		loff_t off, len, bfz;
 
 		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 			ksmbd_debug(SMB,
@@ -7701,19 +7701,26 @@ int smb2_ioctl(struct ksmbd_work *work)
 		zero_data =
 			(struct file_zero_data_information *)&req->Buffer[0];
 
-		fp = ksmbd_lookup_fd_fast(work, id);
-		if (!fp) {
-			ret = -ENOENT;
+		off = le64_to_cpu(zero_data->FileOffset);
+		bfz = le64_to_cpu(zero_data->BeyondFinalZero);
+		if (off > bfz) {
+			ret = -EINVAL;
 			goto out;
 		}
 
-		off = le64_to_cpu(zero_data->FileOffset);
-		len = le64_to_cpu(zero_data->BeyondFinalZero) - off;
+		len = bfz - off;
+		if (len) {
+			fp = ksmbd_lookup_fd_fast(work, id);
+			if (!fp) {
+				ret = -ENOENT;
+				goto out;
+			}
 
-		ret = ksmbd_vfs_zero_data(work, fp, off, len);
-		ksmbd_fd_put(work, fp);
-		if (ret < 0)
-			goto out;
+			ret = ksmbd_vfs_zero_data(work, fp, off, len);
+			ksmbd_fd_put(work, fp);
+			if (ret < 0)
+				goto out;
+		}
 		break;
 	}
 	case FSCTL_QUERY_ALLOCATED_RANGES:
@@ -7787,14 +7794,24 @@ int smb2_ioctl(struct ksmbd_work *work)
 		src_off = le64_to_cpu(dup_ext->SourceFileOffset);
 		dst_off = le64_to_cpu(dup_ext->TargetFileOffset);
 		length = le64_to_cpu(dup_ext->ByteCount);
-		cloned = vfs_clone_file_range(fp_in->filp, src_off, fp_out->filp,
-					      dst_off, length, 0);
+		/*
+		 * XXX: It is not clear if FSCTL_DUPLICATE_EXTENTS_TO_FILE
+		 * should fall back to vfs_copy_file_range().  This could be
+		 * beneficial when re-exporting nfs/smb mount, but note that
+		 * this can result in partial copy that returns an error status.
+		 * If/when FSCTL_DUPLICATE_EXTENTS_TO_FILE_EX is implemented,
+		 * fall back to vfs_copy_file_range(), should be avoided when
+		 * the flag DUPLICATE_EXTENTS_DATA_EX_SOURCE_ATOMIC is set.
+		 */
+		cloned = vfs_clone_file_range(fp_in->filp, src_off,
+					      fp_out->filp, dst_off, length, 0);
 		if (cloned == -EXDEV || cloned == -EOPNOTSUPP) {
 			ret = -EOPNOTSUPP;
 			goto dup_ext_out;
 		} else if (cloned != length) {
 			cloned = vfs_copy_file_range(fp_in->filp, src_off,
-						     fp_out->filp, dst_off, length, 0);
+						     fp_out->filp, dst_off,
+						     length, 0);
 			if (cloned != length) {
 				if (cloned < 0)
 					ret = cloned;
diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index 835b384b0895..2139aa042c79 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1018,7 +1018,9 @@ int ksmbd_vfs_zero_data(struct ksmbd_work *work, struct ksmbd_file *fp,
 				     FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
 				     off, len);
 
-	return vfs_fallocate(fp->filp, FALLOC_FL_ZERO_RANGE, off, len);
+	return vfs_fallocate(fp->filp,
+			     FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
+			     off, len);
 }
 
 int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
@@ -1049,7 +1051,7 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
 	*out_count = 0;
 	end = start + length;
 	while (start < end && *out_count < in_count) {
-		extent_start = f->f_op->llseek(f, start, SEEK_DATA);
+		extent_start = vfs_llseek(f, start, SEEK_DATA);
 		if (extent_start < 0) {
 			if (extent_start != -ENXIO)
 				ret = (int)extent_start;
@@ -1059,7 +1061,7 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
 		if (extent_start >= end)
 			break;
 
-		extent_end = f->f_op->llseek(f, extent_start, SEEK_HOLE);
+		extent_end = vfs_llseek(f, extent_start, SEEK_HOLE);
 		if (extent_end < 0) {
 			if (extent_end != -ENXIO)
 				ret = (int)extent_end;
@@ -1780,6 +1782,10 @@ int ksmbd_vfs_copy_file_ranges(struct ksmbd_work *work,
 
 		ret = vfs_copy_file_range(src_fp->filp, src_off,
 					  dst_fp->filp, dst_off, len, 0);
+		if (ret == -EOPNOTSUPP || ret == -EXDEV)
+			ret = generic_copy_file_range(src_fp->filp, src_off,
+						      dst_fp->filp, dst_off,
+						      len, 0);
 		if (ret < 0)
 			return ret;
 
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 7bfb68583154..5f62fa0963ce 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -560,6 +560,7 @@ __be32 nfsd4_clone_file_range(struct nfsd_file *nf_src, u64 src_pos,
 ssize_t nfsd_copy_file_range(struct file *src, u64 src_pos, struct file *dst,
 			     u64 dst_pos, u64 count)
 {
+	ssize_t ret;
 
 	/*
 	 * Limit copy to 4MB to prevent indefinitely blocking an nfsd
@@ -570,7 +571,12 @@ ssize_t nfsd_copy_file_range(struct file *src, u64 src_pos, struct file *dst,
 	 * limit like this and pipeline multiple COPY requests.
 	 */
 	count = min_t(u64, count, 1 << 22);
-	return vfs_copy_file_range(src, src_pos, dst, dst_pos, count, 0);
+	ret = vfs_copy_file_range(src, src_pos, dst, dst_pos, count, 0);
+
+	if (ret == -EOPNOTSUPP || ret == -EXDEV)
+		ret = generic_copy_file_range(src, src_pos, dst, dst_pos,
+					      count, 0);
+	return ret;
 }
 
 __be32 nfsd4_vfs_fallocate(struct svc_rqst *rqstp, struct svc_fh *fhp,
@@ -1142,6 +1148,7 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
 						nfsd_net_id));
 			err2 = filemap_check_wb_err(nf->nf_file->f_mapping,
 						    since);
+			err = nfserrno(err2);
 			break;
 		case -EINVAL:
 			err = nfserr_notsupp;
@@ -1149,8 +1156,8 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		default:
 			nfsd_reset_boot_verifier(net_generic(nf->nf_net,
 						 nfsd_net_id));
+			err = nfserrno(err2);
 		}
-		err = nfserrno(err2);
 	} else
 		nfsd_copy_boot_verifier(verf, net_generic(nf->nf_net,
 					nfsd_net_id));
diff --git a/fs/read_write.c b/fs/read_write.c
index af057c57bdc6..c6db1a0762fa 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1384,28 +1384,6 @@ ssize_t generic_copy_file_range(struct file *file_in, loff_t pos_in,
 }
 EXPORT_SYMBOL(generic_copy_file_range);
 
-static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
-				  struct file *file_out, loff_t pos_out,
-				  size_t len, unsigned int flags)
-{
-	/*
-	 * Although we now allow filesystems to handle cross sb copy, passing
-	 * a file of the wrong filesystem type to filesystem driver can result
-	 * in an attempt to dereference the wrong type of ->private_data, so
-	 * avoid doing that until we really have a good reason.  NFS defines
-	 * several different file_system_type structures, but they all end up
-	 * using the same ->copy_file_range() function pointer.
-	 */
-	if (file_out->f_op->copy_file_range &&
-	    file_out->f_op->copy_file_range == file_in->f_op->copy_file_range)
-		return file_out->f_op->copy_file_range(file_in, pos_in,
-						       file_out, pos_out,
-						       len, flags);
-
-	return generic_copy_file_range(file_in, pos_in, file_out, pos_out, len,
-				       flags);
-}
-
 /*
  * Performs necessary checks before doing a file copy
  *
@@ -1427,6 +1405,24 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 	if (ret)
 		return ret;
 
+	/*
+	 * We allow some filesystems to handle cross sb copy, but passing
+	 * a file of the wrong filesystem type to filesystem driver can result
+	 * in an attempt to dereference the wrong type of ->private_data, so
+	 * avoid doing that until we really have a good reason.
+	 *
+	 * nfs and cifs define several different file_system_type structures
+	 * and several different sets of file_operations, but they all end up
+	 * using the same ->copy_file_range() function pointer.
+	 */
+	if (file_out->f_op->copy_file_range) {
+		if (file_in->f_op->copy_file_range !=
+		    file_out->f_op->copy_file_range)
+			return -EXDEV;
+	} else if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb) {
+		return -EXDEV;
+	}
+
 	/* Don't touch certain kinds of inodes */
 	if (IS_IMMUTABLE(inode_out))
 		return -EPERM;
@@ -1492,26 +1488,41 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	file_start_write(file_out);
 
 	/*
-	 * Try cloning first, this is supported by more file systems, and
-	 * more efficient if both clone and copy are supported (e.g. NFS).
+	 * Cloning is supported by more file systems, so we implement copy on
+	 * same sb using clone, but for filesystems where both clone and copy
+	 * are supported (e.g. nfs,cifs), we only call the copy method.
 	 */
+	if (file_out->f_op->copy_file_range) {
+		ret = file_out->f_op->copy_file_range(file_in, pos_in,
+						      file_out, pos_out,
+						      len, flags);
+		goto done;
+	}
+
 	if (file_in->f_op->remap_file_range &&
 	    file_inode(file_in)->i_sb == file_inode(file_out)->i_sb) {
-		loff_t cloned;
-
-		cloned = file_in->f_op->remap_file_range(file_in, pos_in,
+		ret = file_in->f_op->remap_file_range(file_in, pos_in,
 				file_out, pos_out,
 				min_t(loff_t, MAX_RW_COUNT, len),
 				REMAP_FILE_CAN_SHORTEN);
-		if (cloned > 0) {
-			ret = cloned;
+		if (ret > 0)
 			goto done;
-		}
 	}
 
-	ret = do_copy_file_range(file_in, pos_in, file_out, pos_out, len,
-				flags);
-	WARN_ON_ONCE(ret == -EOPNOTSUPP);
+	/*
+	 * We can get here for same sb copy of filesystems that do not implement
+	 * ->copy_file_range() in case filesystem does not support clone or in
+	 * case filesystem supports clone but rejected the clone request (e.g.
+	 * because it was not block aligned).
+	 *
+	 * In both cases, fall back to kernel copy so we are able to maintain a
+	 * consistent story about which filesystems support copy_file_range()
+	 * and which filesystems do not, that will allow userspace tools to
+	 * make consistent desicions w.r.t using copy_file_range().
+	 */
+	ret = generic_copy_file_range(file_in, pos_in, file_out, pos_out, len,
+				      flags);
+
 done:
 	if (ret > 0) {
 		fsnotify_access(file_in);
diff --git a/include/linux/dim.h b/include/linux/dim.h
index b698266d0035..6c5733981563 100644
--- a/include/linux/dim.h
+++ b/include/linux/dim.h
@@ -21,7 +21,7 @@
  * We consider 10% difference as significant.
  */
 #define IS_SIGNIFICANT_DIFF(val, ref) \
-	(((100UL * abs((val) - (ref))) / (ref)) > 10)
+	((ref) && (((100UL * abs((val) - (ref))) / (ref)) > 10))
 
 /*
  * Calculate the gap between two values.
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 39f1893ecac0..f8d46dc62d65 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1645,7 +1645,7 @@ enum netdev_priv_flags {
 	IFF_FAILOVER_SLAVE		= 1<<28,
 	IFF_L3MDEV_RX_HANDLER		= 1<<29,
 	IFF_LIVE_RENAME_OK		= 1<<30,
-	IFF_TX_SKB_NO_LINEAR		= 1<<31,
+	IFF_TX_SKB_NO_LINEAR		= BIT_ULL(31),
 };
 
 #define IFF_802_1Q_VLAN			IFF_802_1Q_VLAN
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 736e1d1a47c4..946ccec17858 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -536,6 +536,10 @@ struct macsec_ops;
  * @mdix: Current crossover
  * @mdix_ctrl: User setting of crossover
  * @interrupts: Flag interrupts have been enabled
+ * @irq_suspended: Flag indicating PHY is suspended and therefore interrupt
+ *                 handling shall be postponed until PHY has resumed
+ * @irq_rerun: Flag indicating interrupts occurred while PHY was suspended,
+ *             requiring a rerun of the interrupt handler after resume
  * @interface: enum phy_interface_t value
  * @skb: Netlink message for cable diagnostics
  * @nest: Netlink nest used for cable diagnostics
@@ -590,6 +594,8 @@ struct phy_device {
 
 	/* Interrupts are enabled */
 	unsigned interrupts:1;
+	unsigned irq_suspended:1;
+	unsigned irq_rerun:1;
 
 	enum phy_state state;
 
diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index 9f4bb4a6f358..808c73c52820 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -1352,11 +1352,11 @@ drm_fourcc_canonicalize_nvidia_format_mod(__u64 modifier)
 #define AMD_FMT_MOD_PIPE_MASK 0x7
 
 #define AMD_FMT_MOD_SET(field, value) \
-	((uint64_t)(value) << AMD_FMT_MOD_##field##_SHIFT)
+	((__u64)(value) << AMD_FMT_MOD_##field##_SHIFT)
 #define AMD_FMT_MOD_GET(field, value) \
 	(((value) >> AMD_FMT_MOD_##field##_SHIFT) & AMD_FMT_MOD_##field##_MASK)
 #define AMD_FMT_MOD_CLEAR(field) \
-	(~((uint64_t)AMD_FMT_MOD_##field##_MASK << AMD_FMT_MOD_##field##_SHIFT))
+	(~((__u64)AMD_FMT_MOD_##field##_MASK << AMD_FMT_MOD_##field##_SHIFT))
 
 #if defined(__cplusplus)
 }
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 6b2dc7b2b612..cc1caab4a654 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -410,7 +410,7 @@ int skb_tunnel_check_pmtu(struct sk_buff *skb, struct dst_entry *encap_dst,
 	u32 mtu = dst_mtu(encap_dst) - headroom;
 
 	if ((skb_is_gso(skb) && skb_gso_validate_network_len(skb, mtu)) ||
-	    (!skb_is_gso(skb) && (skb->len - skb_mac_header_len(skb)) <= mtu))
+	    (!skb_is_gso(skb) && (skb->len - skb_network_offset(skb)) <= mtu))
 		return 0;
 
 	skb_dst_update_pmtu_no_confirm(skb, mtu);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index a189625098ba..5d94822fd506 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2014,7 +2014,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (unlikely(tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))) {
+		if (unlikely(!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb) ||
+			     tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
@@ -2061,6 +2062,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			}
 			goto discard_and_relse;
 		}
+		nf_reset_ct(skb);
 		if (nsk == sk) {
 			reqsk_put(req);
 			tcp_v4_restore_cb(skb);
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 07b868c002a3..6dcf034835ec 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1111,10 +1111,6 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 		goto out;
 	}
 
-	if (net->ipv6.devconf_all->disable_policy ||
-	    idev->cnf.disable_policy)
-		f6i->dst_nopolicy = true;
-
 	neigh_parms_data_state_setall(idev->nd_parms);
 
 	ifa->addr = *cfg->pfx;
@@ -5170,9 +5166,9 @@ static int in6_dump_addrs(struct inet6_dev *idev, struct sk_buff *skb,
 		fillargs->event = RTM_GETMULTICAST;
 
 		/* multicast address */
-		for (ifmca = rcu_dereference(idev->mc_list);
+		for (ifmca = rtnl_dereference(idev->mc_list);
 		     ifmca;
-		     ifmca = rcu_dereference(ifmca->next), ip_idx++) {
+		     ifmca = rtnl_dereference(ifmca->next), ip_idx++) {
 			if (ip_idx < s_ip_idx)
 				continue;
 			err = inet6_fill_ifmcaddr(skb, ifmca, fillargs);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0ca7c780d97a..4ca754c360a3 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4590,8 +4590,15 @@ struct fib6_info *addrconf_f6i_alloc(struct net *net,
 	}
 
 	f6i = ip6_route_info_create(&cfg, gfp_flags, NULL);
-	if (!IS_ERR(f6i))
+	if (!IS_ERR(f6i)) {
 		f6i->dst_nocount = true;
+
+		if (!anycast &&
+		    (net->ipv6.devconf_all->disable_policy ||
+		     idev->cnf.disable_policy))
+			f6i->dst_nopolicy = true;
+	}
+
 	return f6i;
 }
 
diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 5b2c9ce53395..b7d6b64cc532 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -408,7 +408,6 @@ int __net_init seg6_hmac_net_init(struct net *net)
 
 	return 0;
 }
-EXPORT_SYMBOL(seg6_hmac_net_init);
 
 void seg6_hmac_exit(void)
 {
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 626cb53aa57a..637cd99bd7a6 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -323,8 +323,6 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		kcalloc(cmax, sizeof(*kp), GFP_KERNEL_ACCOUNT | __GFP_NOWARN) :
 		NULL;
 
-	rcu_read_lock();
-
 	ca = min(t->prl_count, cmax);
 
 	if (!kp) {
@@ -341,7 +339,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		}
 	}
 
-	c = 0;
+	rcu_read_lock();
 	for_each_prl_rcu(t->prl) {
 		if (c >= cmax)
 			break;
@@ -353,7 +351,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		if (kprl.addr != htonl(INADDR_ANY))
 			break;
 	}
-out:
+
 	rcu_read_unlock();
 
 	len = sizeof(*kp) * c;
@@ -362,7 +360,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		ret = -EFAULT;
 
 	kfree(kp);
-
+out:
 	return ret;
 }
 
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index df40314de21f..76de6c8d9865 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -143,6 +143,7 @@ static bool nft_rhash_update(struct nft_set *set, const u32 *key,
 	/* Another cpu may race to insert the element with the same key */
 	if (prev) {
 		nft_set_elem_destroy(set, he, true);
+		atomic_dec(&set->nelems);
 		he = prev;
 	}
 
@@ -152,6 +153,7 @@ static bool nft_rhash_update(struct nft_set *set, const u32 *key,
 
 err2:
 	nft_set_elem_destroy(set, he, true);
+	atomic_dec(&set->nelems);
 err1:
 	return false;
 }
diff --git a/net/rose/rose_timer.c b/net/rose/rose_timer.c
index b3138fc2e552..f06ddbed3fed 100644
--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -31,89 +31,89 @@ static void rose_idletimer_expiry(struct timer_list *);
 
 void rose_start_heartbeat(struct sock *sk)
 {
-	del_timer(&sk->sk_timer);
+	sk_stop_timer(sk, &sk->sk_timer);
 
 	sk->sk_timer.function = rose_heartbeat_expiry;
 	sk->sk_timer.expires  = jiffies + 5 * HZ;
 
-	add_timer(&sk->sk_timer);
+	sk_reset_timer(sk, &sk->sk_timer, sk->sk_timer.expires);
 }
 
 void rose_start_t1timer(struct sock *sk)
 {
 	struct rose_sock *rose = rose_sk(sk);
 
-	del_timer(&rose->timer);
+	sk_stop_timer(sk, &rose->timer);
 
 	rose->timer.function = rose_timer_expiry;
 	rose->timer.expires  = jiffies + rose->t1;
 
-	add_timer(&rose->timer);
+	sk_reset_timer(sk, &rose->timer, rose->timer.expires);
 }
 
 void rose_start_t2timer(struct sock *sk)
 {
 	struct rose_sock *rose = rose_sk(sk);
 
-	del_timer(&rose->timer);
+	sk_stop_timer(sk, &rose->timer);
 
 	rose->timer.function = rose_timer_expiry;
 	rose->timer.expires  = jiffies + rose->t2;
 
-	add_timer(&rose->timer);
+	sk_reset_timer(sk, &rose->timer, rose->timer.expires);
 }
 
 void rose_start_t3timer(struct sock *sk)
 {
 	struct rose_sock *rose = rose_sk(sk);
 
-	del_timer(&rose->timer);
+	sk_stop_timer(sk, &rose->timer);
 
 	rose->timer.function = rose_timer_expiry;
 	rose->timer.expires  = jiffies + rose->t3;
 
-	add_timer(&rose->timer);
+	sk_reset_timer(sk, &rose->timer, rose->timer.expires);
 }
 
 void rose_start_hbtimer(struct sock *sk)
 {
 	struct rose_sock *rose = rose_sk(sk);
 
-	del_timer(&rose->timer);
+	sk_stop_timer(sk, &rose->timer);
 
 	rose->timer.function = rose_timer_expiry;
 	rose->timer.expires  = jiffies + rose->hb;
 
-	add_timer(&rose->timer);
+	sk_reset_timer(sk, &rose->timer, rose->timer.expires);
 }
 
 void rose_start_idletimer(struct sock *sk)
 {
 	struct rose_sock *rose = rose_sk(sk);
 
-	del_timer(&rose->idletimer);
+	sk_stop_timer(sk, &rose->idletimer);
 
 	if (rose->idle > 0) {
 		rose->idletimer.function = rose_idletimer_expiry;
 		rose->idletimer.expires  = jiffies + rose->idle;
 
-		add_timer(&rose->idletimer);
+		sk_reset_timer(sk, &rose->idletimer, rose->idletimer.expires);
 	}
 }
 
 void rose_stop_heartbeat(struct sock *sk)
 {
-	del_timer(&sk->sk_timer);
+	sk_stop_timer(sk, &sk->sk_timer);
 }
 
 void rose_stop_timer(struct sock *sk)
 {
-	del_timer(&rose_sk(sk)->timer);
+	sk_stop_timer(sk, &rose_sk(sk)->timer);
 }
 
 void rose_stop_idletimer(struct sock *sk)
 {
-	del_timer(&rose_sk(sk)->idletimer);
+	sk_stop_timer(sk, &rose_sk(sk)->idletimer);
 }
 
 static void rose_heartbeat_expiry(struct timer_list *t)
@@ -130,6 +130,7 @@ static void rose_heartbeat_expiry(struct timer_list *t)
 		    (sk->sk_state == TCP_LISTEN && sock_flag(sk, SOCK_DEAD))) {
 			bh_unlock_sock(sk);
 			rose_destroy_socket(sk);
+			sock_put(sk);
 			return;
 		}
 		break;
@@ -152,6 +153,7 @@ static void rose_heartbeat_expiry(struct timer_list *t)
 
 	rose_start_heartbeat(sk);
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
 
 static void rose_timer_expiry(struct timer_list *t)
@@ -181,6 +183,7 @@ static void rose_timer_expiry(struct timer_list *t)
 		break;
 	}
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
 
 static void rose_idletimer_expiry(struct timer_list *t)
@@ -205,4 +208,5 @@ static void rose_idletimer_expiry(struct timer_list *t)
 		sock_set_flag(sk, SOCK_DEAD);
 	}
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 7d53272727bf..d775676956bf 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -350,7 +350,8 @@ static int tcf_idr_release_unsafe(struct tc_action *p)
 }
 
 static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
-			  const struct tc_action_ops *ops)
+			  const struct tc_action_ops *ops,
+			  struct netlink_ext_ack *extack)
 {
 	struct nlattr *nest;
 	int n_i = 0;
@@ -366,20 +367,25 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	if (nla_put_string(skb, TCA_KIND, ops->kind))
 		goto nla_put_failure;
 
+	ret = 0;
 	mutex_lock(&idrinfo->lock);
 	idr_for_each_entry_ul(idr, p, tmp, id) {
 		if (IS_ERR(p))
 			continue;
 		ret = tcf_idr_release_unsafe(p);
-		if (ret == ACT_P_DELETED) {
+		if (ret == ACT_P_DELETED)
 			module_put(ops->owner);
-			n_i++;
-		} else if (ret < 0) {
-			mutex_unlock(&idrinfo->lock);
-			goto nla_put_failure;
-		}
+		else if (ret < 0)
+			break;
+		n_i++;
 	}
 	mutex_unlock(&idrinfo->lock);
+	if (ret < 0) {
+		if (n_i)
+			NL_SET_ERR_MSG(extack, "Unable to flush all TC actions");
+		else
+			goto nla_put_failure;
+	}
 
 	ret = nla_put_u32(skb, TCA_FCNT, n_i);
 	if (ret)
@@ -400,7 +406,7 @@ int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
 
 	if (type == RTM_DELACTION) {
-		return tcf_del_walker(idrinfo, skb, ops);
+		return tcf_del_walker(idrinfo, skb, ops, extack);
 	} else if (type == RTM_GETACTION) {
 		return tcf_dump_walker(idrinfo, skb, cb);
 	} else {
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 85473264cccf..f0a0a4ad6d52 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -979,7 +979,7 @@ static __be32 *xdr_get_next_encode_buffer(struct xdr_stream *xdr,
 	 */
 	xdr->p = (void *)p + frag2bytes;
 	space_left = xdr->buf->buflen - xdr->buf->len;
-	if (space_left - nbytes >= PAGE_SIZE)
+	if (space_left - frag1bytes >= PAGE_SIZE)
 		xdr->end = (void *)p + PAGE_SIZE;
 	else
 		xdr->end = (void *)p + space_left - frag1bytes;
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 6ef95ce565bd..b48d97cbbe29 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -472,8 +472,8 @@ struct tipc_node *tipc_node_create(struct net *net, u32 addr, u8 *peer_id,
 				   bool preliminary)
 {
 	struct tipc_net *tn = net_generic(net, tipc_net_id);
+	struct tipc_link *l, *snd_l = tipc_bc_sndlink(net);
 	struct tipc_node *n, *temp_node;
-	struct tipc_link *l;
 	unsigned long intv;
 	int bearer_id;
 	int i;
@@ -488,6 +488,16 @@ struct tipc_node *tipc_node_create(struct net *net, u32 addr, u8 *peer_id,
 			goto exit;
 		/* A preliminary node becomes "real" now, refresh its data */
 		tipc_node_write_lock(n);
+		if (!tipc_link_bc_create(net, tipc_own_addr(net), addr, peer_id, U16_MAX,
+					 tipc_link_min_win(snd_l), tipc_link_max_win(snd_l),
+					 n->capabilities, &n->bc_entry.inputq1,
+					 &n->bc_entry.namedq, snd_l, &n->bc_entry.link)) {
+			pr_warn("Broadcast rcv link refresh failed, no memory\n");
+			tipc_node_write_unlock_fast(n);
+			tipc_node_put(n);
+			n = NULL;
+			goto exit;
+		}
 		n->preliminary = false;
 		n->addr = addr;
 		hlist_del_rcu(&n->hash);
@@ -567,7 +577,16 @@ struct tipc_node *tipc_node_create(struct net *net, u32 addr, u8 *peer_id,
 	n->signature = INVALID_NODE_SIG;
 	n->active_links[0] = INVALID_BEARER_ID;
 	n->active_links[1] = INVALID_BEARER_ID;
-	n->bc_entry.link = NULL;
+	if (!preliminary &&
+	    !tipc_link_bc_create(net, tipc_own_addr(net), addr, peer_id, U16_MAX,
+				 tipc_link_min_win(snd_l), tipc_link_max_win(snd_l),
+				 n->capabilities, &n->bc_entry.inputq1,
+				 &n->bc_entry.namedq, snd_l, &n->bc_entry.link)) {
+		pr_warn("Broadcast rcv link creation failed, no memory\n");
+		kfree(n);
+		n = NULL;
+		goto exit;
+	}
 	tipc_node_get(n);
 	timer_setup(&n->timer, tipc_node_timeout, 0);
 	/* Start a slow timer anyway, crypto needs it */
@@ -1155,7 +1174,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 			  bool *respond, bool *dupl_addr)
 {
 	struct tipc_node *n;
-	struct tipc_link *l, *snd_l;
+	struct tipc_link *l;
 	struct tipc_link_entry *le;
 	bool addr_match = false;
 	bool sign_match = false;
@@ -1175,22 +1194,6 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		return;
 
 	tipc_node_write_lock(n);
-	if (unlikely(!n->bc_entry.link)) {
-		snd_l = tipc_bc_sndlink(net);
-		if (!tipc_link_bc_create(net, tipc_own_addr(net),
-					 addr, peer_id, U16_MAX,
-					 tipc_link_min_win(snd_l),
-					 tipc_link_max_win(snd_l),
-					 n->capabilities,
-					 &n->bc_entry.inputq1,
-					 &n->bc_entry.namedq, snd_l,
-					 &n->bc_entry.link)) {
-			pr_warn("Broadcast rcv link creation failed, no mem\n");
-			tipc_node_write_unlock_fast(n);
-			tipc_node_put(n);
-			return;
-		}
-	}
 
 	le = &n->links[b->identity];
 
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 3a9e332c5e36..68a9a897185c 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -31,6 +31,7 @@
 #include <linux/if_ether.h>
 #include <linux/btf.h>
 
+#include <bpf/btf.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
@@ -63,6 +64,11 @@ static bool unpriv_disabled = false;
 static int skips;
 static bool verbose = false;
 
+struct kfunc_btf_id_pair {
+	const char *kfunc;
+	int insn_idx;
+};
+
 struct bpf_test {
 	const char *descr;
 	struct bpf_insn	insns[MAX_INSNS];
@@ -88,6 +94,7 @@ struct bpf_test {
 	int fixup_map_event_output[MAX_FIXUPS];
 	int fixup_map_reuseport_array[MAX_FIXUPS];
 	int fixup_map_ringbuf[MAX_FIXUPS];
+	struct kfunc_btf_id_pair fixup_kfunc_btf_id[MAX_FIXUPS];
 	/* Expected verifier log output for result REJECT or VERBOSE_ACCEPT.
 	 * Can be a tab-separated sequence of expected strings. An empty string
 	 * means no log verification.
@@ -718,6 +725,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_event_output = test->fixup_map_event_output;
 	int *fixup_map_reuseport_array = test->fixup_map_reuseport_array;
 	int *fixup_map_ringbuf = test->fixup_map_ringbuf;
+	struct kfunc_btf_id_pair *fixup_kfunc_btf_id = test->fixup_kfunc_btf_id;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -903,6 +911,26 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_map_ringbuf++;
 		} while (*fixup_map_ringbuf);
 	}
+
+	/* Patch in kfunc BTF IDs */
+	if (fixup_kfunc_btf_id->kfunc) {
+		struct btf *btf;
+		int btf_id;
+
+		do {
+			btf_id = 0;
+			btf = btf__load_vmlinux_btf();
+			if (btf) {
+				btf_id = btf__find_by_name_kind(btf,
+								fixup_kfunc_btf_id->kfunc,
+								BTF_KIND_FUNC);
+				btf_id = btf_id < 0 ? 0 : btf_id;
+			}
+			btf__free(btf);
+			prog[fixup_kfunc_btf_id->insn_idx].imm = btf_id;
+			fixup_kfunc_btf_id++;
+		} while (fixup_kfunc_btf_id->kfunc);
+	}
 }
 
 struct libcap {
diff --git a/tools/testing/selftests/net/mptcp/diag.sh b/tools/testing/selftests/net/mptcp/diag.sh
index ff821025d309..49dfabded1d4 100755
--- a/tools/testing/selftests/net/mptcp/diag.sh
+++ b/tools/testing/selftests/net/mptcp/diag.sh
@@ -61,6 +61,39 @@ chk_msk_nr()
 	__chk_nr "grep -c token:" $*
 }
 
+wait_msk_nr()
+{
+	local condition="grep -c token:"
+	local expected=$1
+	local timeout=20
+	local msg nr
+	local max=0
+	local i=0
+
+	shift 1
+	msg=$*
+
+	while [ $i -lt $timeout ]; do
+		nr=$(ss -inmHMN $ns | $condition)
+		[ $nr == $expected ] && break;
+		[ $nr -gt $max ] && max=$nr
+		i=$((i + 1))
+		sleep 1
+	done
+
+	printf "%-50s" "$msg"
+	if [ $i -ge $timeout ]; then
+		echo "[ fail ] timeout while expecting $expected max $max last $nr"
+		ret=$test_cnt
+	elif [ $nr != $expected ]; then
+		echo "[ fail ] expected $expected found $nr"
+		ret=$test_cnt
+	else
+		echo "[  ok  ]"
+	fi
+	test_cnt=$((test_cnt+1))
+}
+
 chk_msk_fallback_nr()
 {
 		__chk_nr "grep -c fallback" $*
@@ -109,7 +142,7 @@ ip -n $ns link set dev lo up
 echo "a" | \
 	timeout ${timeout_test} \
 		ip netns exec $ns \
-			./mptcp_connect -p 10000 -l -t ${timeout_poll} \
+			./mptcp_connect -p 10000 -l -t ${timeout_poll} -w 20 \
 				0.0.0.0 >/dev/null &
 wait_local_port_listen $ns 10000
 chk_msk_nr 0 "no msk on netns creation"
@@ -117,7 +150,7 @@ chk_msk_nr 0 "no msk on netns creation"
 echo "b" | \
 	timeout ${timeout_test} \
 		ip netns exec $ns \
-			./mptcp_connect -p 10000 -r 0 -t ${timeout_poll} \
+			./mptcp_connect -p 10000 -r 0 -t ${timeout_poll} -w 20 \
 				127.0.0.1 >/dev/null &
 wait_connected $ns 10000
 chk_msk_nr 2 "after MPC handshake "
@@ -129,13 +162,13 @@ flush_pids
 echo "a" | \
 	timeout ${timeout_test} \
 		ip netns exec $ns \
-			./mptcp_connect -p 10001 -l -s TCP -t ${timeout_poll} \
+			./mptcp_connect -p 10001 -l -s TCP -t ${timeout_poll} -w 20 \
 				0.0.0.0 >/dev/null &
 wait_local_port_listen $ns 10001
 echo "b" | \
 	timeout ${timeout_test} \
 		ip netns exec $ns \
-			./mptcp_connect -p 10001 -r 0 -t ${timeout_poll} \
+			./mptcp_connect -p 10001 -r 0 -t ${timeout_poll} -w 20 \
 				127.0.0.1 >/dev/null &
 wait_connected $ns 10001
 chk_msk_fallback_nr 1 "check fallback"
@@ -146,7 +179,7 @@ for I in `seq 1 $NR_CLIENTS`; do
 	echo "a" | \
 		timeout ${timeout_test} \
 			ip netns exec $ns \
-				./mptcp_connect -p $((I+10001)) -l -w 10 \
+				./mptcp_connect -p $((I+10001)) -l -w 20 \
 					-t ${timeout_poll} 0.0.0.0 >/dev/null &
 done
 wait_local_port_listen $ns $((NR_CLIENTS + 10001))
@@ -155,12 +188,11 @@ for I in `seq 1 $NR_CLIENTS`; do
 	echo "b" | \
 		timeout ${timeout_test} \
 			ip netns exec $ns \
-				./mptcp_connect -p $((I+10001)) -w 10 \
+				./mptcp_connect -p $((I+10001)) -w 20 \
 					-t ${timeout_poll} 127.0.0.1 >/dev/null &
 done
-sleep 1.5
 
-chk_msk_nr $((NR_CLIENTS*2)) "many msk socket present"
+wait_msk_nr $((NR_CLIENTS*2)) "many msk socket present"
 flush_pids
 
 exit $ret
diff --git a/tools/testing/selftests/net/udpgso_bench.sh b/tools/testing/selftests/net/udpgso_bench.sh
index 80b5d352702e..dc932fd65363 100755
--- a/tools/testing/selftests/net/udpgso_bench.sh
+++ b/tools/testing/selftests/net/udpgso_bench.sh
@@ -120,7 +120,7 @@ run_all() {
 	run_udp "${ipv4_args}"
 
 	echo "ipv6"
-	run_tcp "${ipv4_args}"
+	run_tcp "${ipv6_args}"
 	run_udp "${ipv6_args}"
 }
 
diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
index 2af9d39a9716..215e1067f037 100644
--- a/tools/testing/selftests/rseq/Makefile
+++ b/tools/testing/selftests/rseq/Makefile
@@ -6,7 +6,7 @@ endif
 
 CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/ -L$(OUTPUT) -Wl,-rpath=./ \
 	  $(CLANG_FLAGS)
-LDLIBS += -lpthread
+LDLIBS += -lpthread -ldl
 
 # Own dependencies because we only want to build against 1st prerequisite, but
 # still track changes to header files and depend on shared object.
diff --git a/tools/testing/selftests/rseq/basic_percpu_ops_test.c b/tools/testing/selftests/rseq/basic_percpu_ops_test.c
index eb3f6db36d36..517756afc2a4 100644
--- a/tools/testing/selftests/rseq/basic_percpu_ops_test.c
+++ b/tools/testing/selftests/rseq/basic_percpu_ops_test.c
@@ -9,10 +9,9 @@
 #include <string.h>
 #include <stddef.h>
 
+#include "../kselftest.h"
 #include "rseq.h"
 
-#define ARRAY_SIZE(arr)	(sizeof(arr) / sizeof((arr)[0]))
-
 struct percpu_lock_entry {
 	intptr_t v;
 } __attribute__((aligned(128)));
@@ -168,7 +167,7 @@ struct percpu_list_node *this_cpu_list_pop(struct percpu_list *list,
 	for (;;) {
 		struct percpu_list_node *head;
 		intptr_t *targetptr, expectnot, *load;
-		off_t offset;
+		long offset;
 		int ret, cpu;
 
 		cpu = rseq_cpu_start();
diff --git a/tools/testing/selftests/rseq/compiler.h b/tools/testing/selftests/rseq/compiler.h
new file mode 100644
index 000000000000..876eb6a7f75b
--- /dev/null
+++ b/tools/testing/selftests/rseq/compiler.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: LGPL-2.1-only OR MIT */
+/*
+ * rseq/compiler.h
+ *
+ * Work-around asm goto compiler bugs.
+ *
+ * (C) Copyright 2021 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#ifndef RSEQ_COMPILER_H
+#define RSEQ_COMPILER_H
+
+/*
+ * gcc prior to 4.8.2 miscompiles asm goto.
+ * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
+ *
+ * gcc prior to 8.1.0 miscompiles asm goto at O1.
+ * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=103908
+ *
+ * clang prior to version 13.0.1 miscompiles asm goto at O2.
+ * https://github.com/llvm/llvm-project/issues/52735
+ *
+ * Work around these issues by adding a volatile inline asm with
+ * memory clobber in the fallthrough after the asm goto and at each
+ * label target.  Emit this for all compilers in case other similar
+ * issues are found in the future.
+ */
+#define rseq_after_asm_goto()	asm volatile ("" : : : "memory")
+
+#endif  /* RSEQ_COMPILER_H_ */
diff --git a/tools/testing/selftests/rseq/param_test.c b/tools/testing/selftests/rseq/param_test.c
index 699ad5f93c34..da23c22d5882 100644
--- a/tools/testing/selftests/rseq/param_test.c
+++ b/tools/testing/selftests/rseq/param_test.c
@@ -161,7 +161,7 @@ unsigned int yield_mod_cnt, nr_abort;
 	"	cbnz	" INJECT_ASM_REG ", 222b\n"			\
 	"333:\n"
 
-#elif __PPC__
+#elif defined(__PPC__)
 
 #define RSEQ_INJECT_INPUT \
 	, [loop_cnt_1]"m"(loop_cnt[1]) \
@@ -368,9 +368,7 @@ void *test_percpu_spinlock_thread(void *arg)
 		abort();
 	reps = thread_data->reps;
 	for (i = 0; i < reps; i++) {
-		int cpu = rseq_cpu_start();
-
-		cpu = rseq_this_cpu_lock(&data->lock);
+		int cpu = rseq_this_cpu_lock(&data->lock);
 		data->c[cpu].count++;
 		rseq_percpu_unlock(&data->lock, cpu);
 #ifndef BENCHMARK
@@ -551,7 +549,7 @@ struct percpu_list_node *this_cpu_list_pop(struct percpu_list *list,
 	for (;;) {
 		struct percpu_list_node *head;
 		intptr_t *targetptr, expectnot, *load;
-		off_t offset;
+		long offset;
 		int ret;
 
 		cpu = rseq_cpu_start();
diff --git a/tools/testing/selftests/rseq/rseq-abi.h b/tools/testing/selftests/rseq/rseq-abi.h
new file mode 100644
index 000000000000..a8c44d9af71f
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq-abi.h
@@ -0,0 +1,151 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+#ifndef _RSEQ_ABI_H
+#define _RSEQ_ABI_H
+
+/*
+ * rseq-abi.h
+ *
+ * Restartable sequences system call API
+ *
+ * Copyright (c) 2015-2022 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+enum rseq_abi_cpu_id_state {
+	RSEQ_ABI_CPU_ID_UNINITIALIZED			= -1,
+	RSEQ_ABI_CPU_ID_REGISTRATION_FAILED		= -2,
+};
+
+enum rseq_abi_flags {
+	RSEQ_ABI_FLAG_UNREGISTER = (1 << 0),
+};
+
+enum rseq_abi_cs_flags_bit {
+	RSEQ_ABI_CS_FLAG_NO_RESTART_ON_PREEMPT_BIT	= 0,
+	RSEQ_ABI_CS_FLAG_NO_RESTART_ON_SIGNAL_BIT	= 1,
+	RSEQ_ABI_CS_FLAG_NO_RESTART_ON_MIGRATE_BIT	= 2,
+};
+
+enum rseq_abi_cs_flags {
+	RSEQ_ABI_CS_FLAG_NO_RESTART_ON_PREEMPT	=
+		(1U << RSEQ_ABI_CS_FLAG_NO_RESTART_ON_PREEMPT_BIT),
+	RSEQ_ABI_CS_FLAG_NO_RESTART_ON_SIGNAL	=
+		(1U << RSEQ_ABI_CS_FLAG_NO_RESTART_ON_SIGNAL_BIT),
+	RSEQ_ABI_CS_FLAG_NO_RESTART_ON_MIGRATE	=
+		(1U << RSEQ_ABI_CS_FLAG_NO_RESTART_ON_MIGRATE_BIT),
+};
+
+/*
+ * struct rseq_abi_cs is aligned on 4 * 8 bytes to ensure it is always
+ * contained within a single cache-line. It is usually declared as
+ * link-time constant data.
+ */
+struct rseq_abi_cs {
+	/* Version of this structure. */
+	__u32 version;
+	/* enum rseq_abi_cs_flags */
+	__u32 flags;
+	__u64 start_ip;
+	/* Offset from start_ip. */
+	__u64 post_commit_offset;
+	__u64 abort_ip;
+} __attribute__((aligned(4 * sizeof(__u64))));
+
+/*
+ * struct rseq_abi is aligned on 4 * 8 bytes to ensure it is always
+ * contained within a single cache-line.
+ *
+ * A single struct rseq_abi per thread is allowed.
+ */
+struct rseq_abi {
+	/*
+	 * Restartable sequences cpu_id_start field. Updated by the
+	 * kernel. Read by user-space with single-copy atomicity
+	 * semantics. This field should only be read by the thread which
+	 * registered this data structure. Aligned on 32-bit. Always
+	 * contains a value in the range of possible CPUs, although the
+	 * value may not be the actual current CPU (e.g. if rseq is not
+	 * initialized). This CPU number value should always be compared
+	 * against the value of the cpu_id field before performing a rseq
+	 * commit or returning a value read from a data structure indexed
+	 * using the cpu_id_start value.
+	 */
+	__u32 cpu_id_start;
+	/*
+	 * Restartable sequences cpu_id field. Updated by the kernel.
+	 * Read by user-space with single-copy atomicity semantics. This
+	 * field should only be read by the thread which registered this
+	 * data structure. Aligned on 32-bit. Values
+	 * RSEQ_CPU_ID_UNINITIALIZED and RSEQ_CPU_ID_REGISTRATION_FAILED
+	 * have a special semantic: the former means "rseq uninitialized",
+	 * and latter means "rseq initialization failed". This value is
+	 * meant to be read within rseq critical sections and compared
+	 * with the cpu_id_start value previously read, before performing
+	 * the commit instruction, or read and compared with the
+	 * cpu_id_start value before returning a value loaded from a data
+	 * structure indexed using the cpu_id_start value.
+	 */
+	__u32 cpu_id;
+	/*
+	 * Restartable sequences rseq_cs field.
+	 *
+	 * Contains NULL when no critical section is active for the current
+	 * thread, or holds a pointer to the currently active struct rseq_cs.
+	 *
+	 * Updated by user-space, which sets the address of the currently
+	 * active rseq_cs at the beginning of assembly instruction sequence
+	 * block, and set to NULL by the kernel when it restarts an assembly
+	 * instruction sequence block, as well as when the kernel detects that
+	 * it is preempting or delivering a signal outside of the range
+	 * targeted by the rseq_cs. Also needs to be set to NULL by user-space
+	 * before reclaiming memory that contains the targeted struct rseq_cs.
+	 *
+	 * Read and set by the kernel. Set by user-space with single-copy
+	 * atomicity semantics. This field should only be updated by the
+	 * thread which registered this data structure. Aligned on 64-bit.
+	 */
+	union {
+		__u64 ptr64;
+
+		/*
+		 * The "arch" field provides architecture accessor for
+		 * the ptr field based on architecture pointer size and
+		 * endianness.
+		 */
+		struct {
+#ifdef __LP64__
+			__u64 ptr;
+#elif defined(__BYTE_ORDER) ? (__BYTE_ORDER == __BIG_ENDIAN) : defined(__BIG_ENDIAN)
+			__u32 padding;		/* Initialized to zero. */
+			__u32 ptr;
+#else
+			__u32 ptr;
+			__u32 padding;		/* Initialized to zero. */
+#endif
+		} arch;
+	} rseq_cs;
+
+	/*
+	 * Restartable sequences flags field.
+	 *
+	 * This field should only be updated by the thread which
+	 * registered this data structure. Read by the kernel.
+	 * Mainly used for single-stepping through rseq critical sections
+	 * with debuggers.
+	 *
+	 * - RSEQ_ABI_CS_FLAG_NO_RESTART_ON_PREEMPT
+	 *     Inhibit instruction sequence block restart on preemption
+	 *     for this thread.
+	 * - RSEQ_ABI_CS_FLAG_NO_RESTART_ON_SIGNAL
+	 *     Inhibit instruction sequence block restart on signal
+	 *     delivery for this thread.
+	 * - RSEQ_ABI_CS_FLAG_NO_RESTART_ON_MIGRATE
+	 *     Inhibit instruction sequence block restart on migration for
+	 *     this thread.
+	 */
+	__u32 flags;
+} __attribute__((aligned(4 * sizeof(__u64))));
+
+#endif /* _RSEQ_ABI_H */
diff --git a/tools/testing/selftests/rseq/rseq-arm.h b/tools/testing/selftests/rseq/rseq-arm.h
index 5943c816c07c..893a11eca9d5 100644
--- a/tools/testing/selftests/rseq/rseq-arm.h
+++ b/tools/testing/selftests/rseq/rseq-arm.h
@@ -147,14 +147,11 @@ do {									\
 		teardown						\
 		"b %l[" __rseq_str(cmpfail_label) "]\n\t"
 
-#define rseq_workaround_gcc_asm_size_guess()	__asm__ __volatile__("")
-
 static inline __attribute__((always_inline))
 int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -185,8 +182,8 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 		"5:\n\t"
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
 		  [newv]		"r" (newv)
@@ -198,30 +195,31 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
 
 static inline __attribute__((always_inline))
 int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
-			       off_t voffp, intptr_t *load, int cpu)
+			       long voffp, intptr_t *load, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -255,8 +253,8 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		"5:\n\t"
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expectnot]		"r" (expectnot),
@@ -270,19 +268,21 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -292,7 +292,6 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 #ifdef RSEQ_COMPARE_TWICE
@@ -316,8 +315,8 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		"5:\n\t"
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"m" (*v),
 		  [count]		"Ir" (count)
 		  RSEQ_INJECT_INPUT
@@ -328,14 +327,15 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		  , error1
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 #endif
 }
@@ -347,7 +347,6 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -381,8 +380,8 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		"5:\n\t"
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -398,19 +397,21 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -422,7 +423,6 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -457,8 +457,8 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
 		"5:\n\t"
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -474,19 +474,21 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -498,7 +500,6 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -537,8 +538,8 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		"5:\n\t"
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* cmp2 input */
 		  [v2]			"m" (*v2),
 		  [expect2]		"r" (expect2),
@@ -554,21 +555,24 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2, error3
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("1st expected value comparison failed");
 error3:
+	rseq_after_asm_goto();
 	rseq_bug("2nd expected value comparison failed");
 #endif
 }
@@ -582,7 +586,6 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -657,8 +660,8 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 		"8:\n\t"
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
@@ -678,21 +681,21 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -706,7 +709,6 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
 
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -782,8 +784,8 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
 		"8:\n\t"
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
@@ -803,21 +805,21 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
-	rseq_workaround_gcc_asm_size_guess();
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
diff --git a/tools/testing/selftests/rseq/rseq-arm64.h b/tools/testing/selftests/rseq/rseq-arm64.h
index 200dae9e4208..cbe190a4d005 100644
--- a/tools/testing/selftests/rseq/rseq-arm64.h
+++ b/tools/testing/selftests/rseq/rseq-arm64.h
@@ -230,8 +230,8 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 		RSEQ_ASM_DEFINE_ABORT(4, abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"Qo" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"Qo" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"Qo" (*v),
 		  [expect]		"r" (expect),
 		  [newv]		"r" (newv)
@@ -242,24 +242,28 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 		  , error1, error2
 #endif
 	);
-
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
 
 static inline __attribute__((always_inline))
 int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
-			       off_t voffp, intptr_t *load, int cpu)
+			       long voffp, intptr_t *load, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
@@ -287,8 +291,8 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		RSEQ_ASM_DEFINE_ABORT(4, abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"Qo" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"Qo" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"Qo" (*v),
 		  [expectnot]		"r" (expectnot),
 		  [load]		"Qo" (*load),
@@ -300,16 +304,21 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -337,8 +346,8 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		RSEQ_ASM_DEFINE_ABORT(4, abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"Qo" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"Qo" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"Qo" (*v),
 		  [count]		"r" (count)
 		  RSEQ_INJECT_INPUT
@@ -348,12 +357,15 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		  , error1
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 #endif
 }
@@ -388,8 +400,8 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"Qo" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"Qo" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [expect]		"r" (expect),
 		  [v]			"Qo" (*v),
 		  [newv]		"r" (newv),
@@ -402,17 +414,21 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
-
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -447,8 +463,8 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"Qo" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"Qo" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [expect]		"r" (expect),
 		  [v]			"Qo" (*v),
 		  [newv]		"r" (newv),
@@ -461,17 +477,21 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
-
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -508,8 +528,8 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"Qo" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"Qo" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"Qo" (*v),
 		  [expect]		"r" (expect),
 		  [v2]			"Qo" (*v2),
@@ -522,19 +542,24 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2, error3
 #endif
 	);
-
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 error3:
+	rseq_after_asm_goto();
 	rseq_bug("2nd expected value comparison failed");
 #endif
 }
@@ -569,8 +594,8 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"Qo" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"Qo" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [expect]		"r" (expect),
 		  [v]			"Qo" (*v),
 		  [newv]		"r" (newv),
@@ -584,17 +609,21 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
-
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -629,8 +658,8 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"Qo" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"Qo" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [expect]		"r" (expect),
 		  [v]			"Qo" (*v),
 		  [newv]		"r" (newv),
@@ -644,17 +673,21 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
-
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
diff --git a/tools/testing/selftests/rseq/rseq-generic-thread-pointer.h b/tools/testing/selftests/rseq/rseq-generic-thread-pointer.h
new file mode 100644
index 000000000000..38c584661571
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq-generic-thread-pointer.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: LGPL-2.1-only OR MIT */
+/*
+ * rseq-generic-thread-pointer.h
+ *
+ * (C) Copyright 2021 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#ifndef _RSEQ_GENERIC_THREAD_POINTER
+#define _RSEQ_GENERIC_THREAD_POINTER
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+/* Use gcc builtin thread pointer. */
+static inline void *rseq_thread_pointer(void)
+{
+	return __builtin_thread_pointer();
+}
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/tools/testing/selftests/rseq/rseq-mips.h b/tools/testing/selftests/rseq/rseq-mips.h
index e989e7c14b09..878739fae2fd 100644
--- a/tools/testing/selftests/rseq/rseq-mips.h
+++ b/tools/testing/selftests/rseq/rseq-mips.h
@@ -154,14 +154,11 @@ do {									\
 		teardown \
 		"b %l[" __rseq_str(cmpfail_label) "]\n\t"
 
-#define rseq_workaround_gcc_asm_size_guess()	__asm__ __volatile__("")
-
 static inline __attribute__((always_inline))
 int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -190,8 +187,8 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 		"5:\n\t"
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
 		  [newv]		"r" (newv)
@@ -203,14 +200,11 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
@@ -222,11 +216,10 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 
 static inline __attribute__((always_inline))
 int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
-			       off_t voffp, intptr_t *load, int cpu)
+			       long voffp, intptr_t *load, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -258,8 +251,8 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		"5:\n\t"
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expectnot]		"r" (expectnot),
@@ -273,14 +266,11 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
@@ -295,7 +285,6 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 #ifdef RSEQ_COMPARE_TWICE
@@ -319,8 +308,8 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		"5:\n\t"
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"m" (*v),
 		  [count]		"Ir" (count)
 		  RSEQ_INJECT_INPUT
@@ -331,10 +320,8 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		  , error1
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 #ifdef RSEQ_COMPARE_TWICE
@@ -350,7 +337,6 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -382,8 +368,8 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		"5:\n\t"
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -399,14 +385,11 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
@@ -423,7 +406,6 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -456,8 +438,8 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
 		"5:\n\t"
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -473,14 +455,11 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
@@ -497,7 +476,6 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -532,8 +510,8 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		"5:\n\t"
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* cmp2 input */
 		  [v2]			"m" (*v2),
 		  [expect2]		"r" (expect2),
@@ -549,14 +527,11 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2, error3
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
@@ -577,7 +552,6 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -649,8 +623,8 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 		"8:\n\t"
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
@@ -670,21 +644,16 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
-	rseq_workaround_gcc_asm_size_guess();
 	rseq_bug("cpu_id comparison failed");
 error2:
-	rseq_workaround_gcc_asm_size_guess();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -698,7 +667,6 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
 
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -771,8 +739,8 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
 		"8:\n\t"
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
@@ -792,21 +760,16 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
-	rseq_workaround_gcc_asm_size_guess();
 	rseq_bug("cpu_id comparison failed");
 error2:
-	rseq_workaround_gcc_asm_size_guess();
 	rseq_bug("expected value comparison failed");
 #endif
 }
diff --git a/tools/testing/selftests/rseq/rseq-ppc-thread-pointer.h b/tools/testing/selftests/rseq/rseq-ppc-thread-pointer.h
new file mode 100644
index 000000000000..263eee84fb76
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq-ppc-thread-pointer.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: LGPL-2.1-only OR MIT */
+/*
+ * rseq-ppc-thread-pointer.h
+ *
+ * (C) Copyright 2021 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#ifndef _RSEQ_PPC_THREAD_POINTER
+#define _RSEQ_PPC_THREAD_POINTER
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+static inline void *rseq_thread_pointer(void)
+{
+#ifdef __powerpc64__
+	register void *__result asm ("r13");
+#else
+	register void *__result asm ("r2");
+#endif
+	asm ("" : "=r" (__result));
+	return __result;
+}
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/tools/testing/selftests/rseq/rseq-ppc.h b/tools/testing/selftests/rseq/rseq-ppc.h
index 76be90196fe4..bab8e0b9fb11 100644
--- a/tools/testing/selftests/rseq/rseq-ppc.h
+++ b/tools/testing/selftests/rseq/rseq-ppc.h
@@ -47,10 +47,13 @@ do {									\
 
 #ifdef __PPC64__
 
-#define STORE_WORD	"std "
-#define LOAD_WORD	"ld "
-#define LOADX_WORD	"ldx "
-#define CMP_WORD	"cmpd "
+#define RSEQ_STORE_LONG(arg)	"std%U[" __rseq_str(arg) "]%X[" __rseq_str(arg) "] "	/* To memory ("m" constraint) */
+#define RSEQ_STORE_INT(arg)	"stw%U[" __rseq_str(arg) "]%X[" __rseq_str(arg) "] "	/* To memory ("m" constraint) */
+#define RSEQ_LOAD_LONG(arg)	"ld%U[" __rseq_str(arg) "]%X[" __rseq_str(arg) "] "	/* From memory ("m" constraint) */
+#define RSEQ_LOAD_INT(arg)	"lwz%U[" __rseq_str(arg) "]%X[" __rseq_str(arg) "] "	/* From memory ("m" constraint) */
+#define RSEQ_LOADX_LONG		"ldx "							/* From base register ("b" constraint) */
+#define RSEQ_CMP_LONG		"cmpd "
+#define RSEQ_CMP_LONG_INT	"cmpdi "
 
 #define __RSEQ_ASM_DEFINE_TABLE(label, version, flags,				\
 			start_ip, post_commit_offset, abort_ip)			\
@@ -89,10 +92,13 @@ do {									\
 
 #else /* #ifdef __PPC64__ */
 
-#define STORE_WORD	"stw "
-#define LOAD_WORD	"lwz "
-#define LOADX_WORD	"lwzx "
-#define CMP_WORD	"cmpw "
+#define RSEQ_STORE_LONG(arg)	"stw%U[" __rseq_str(arg) "]%X[" __rseq_str(arg) "] "	/* To memory ("m" constraint) */
+#define RSEQ_STORE_INT(arg)	RSEQ_STORE_LONG(arg)					/* To memory ("m" constraint) */
+#define RSEQ_LOAD_LONG(arg)	"lwz%U[" __rseq_str(arg) "]%X[" __rseq_str(arg) "] "	/* From memory ("m" constraint) */
+#define RSEQ_LOAD_INT(arg)	RSEQ_LOAD_LONG(arg)					/* From memory ("m" constraint) */
+#define RSEQ_LOADX_LONG		"lwzx "							/* From base register ("b" constraint) */
+#define RSEQ_CMP_LONG		"cmpw "
+#define RSEQ_CMP_LONG_INT	"cmpwi "
 
 #define __RSEQ_ASM_DEFINE_TABLE(label, version, flags,				\
 			start_ip, post_commit_offset, abort_ip)			\
@@ -125,7 +131,7 @@ do {									\
 		RSEQ_INJECT_ASM(1)						\
 		"lis %%r17, (" __rseq_str(cs_label) ")@ha\n\t"			\
 		"addi %%r17, %%r17, (" __rseq_str(cs_label) ")@l\n\t"		\
-		"stw %%r17, %[" __rseq_str(rseq_cs) "]\n\t"			\
+		RSEQ_STORE_INT(rseq_cs) "%%r17, %[" __rseq_str(rseq_cs) "]\n\t"	\
 		__rseq_str(label) ":\n\t"
 
 #endif /* #ifdef __PPC64__ */
@@ -136,7 +142,7 @@ do {									\
 
 #define RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, label)			\
 		RSEQ_INJECT_ASM(2)						\
-		"lwz %%r17, %[" __rseq_str(current_cpu_id) "]\n\t"		\
+		RSEQ_LOAD_INT(current_cpu_id) "%%r17, %[" __rseq_str(current_cpu_id) "]\n\t" \
 		"cmpw cr7, %[" __rseq_str(cpu_id) "], %%r17\n\t"		\
 		"bne- cr7, " __rseq_str(label) "\n\t"
 
@@ -153,25 +159,25 @@ do {									\
  * 	RSEQ_ASM_OP_* (else): doesn't have hard-code registers(unless cr7)
  */
 #define RSEQ_ASM_OP_CMPEQ(var, expect, label)					\
-		LOAD_WORD "%%r17, %[" __rseq_str(var) "]\n\t"			\
-		CMP_WORD "cr7, %%r17, %[" __rseq_str(expect) "]\n\t"		\
+		RSEQ_LOAD_LONG(var) "%%r17, %[" __rseq_str(var) "]\n\t"		\
+		RSEQ_CMP_LONG "cr7, %%r17, %[" __rseq_str(expect) "]\n\t"		\
 		"bne- cr7, " __rseq_str(label) "\n\t"
 
 #define RSEQ_ASM_OP_CMPNE(var, expectnot, label)				\
-		LOAD_WORD "%%r17, %[" __rseq_str(var) "]\n\t"			\
-		CMP_WORD "cr7, %%r17, %[" __rseq_str(expectnot) "]\n\t"		\
+		RSEQ_LOAD_LONG(var) "%%r17, %[" __rseq_str(var) "]\n\t"		\
+		RSEQ_CMP_LONG "cr7, %%r17, %[" __rseq_str(expectnot) "]\n\t"		\
 		"beq- cr7, " __rseq_str(label) "\n\t"
 
 #define RSEQ_ASM_OP_STORE(value, var)						\
-		STORE_WORD "%[" __rseq_str(value) "], %[" __rseq_str(var) "]\n\t"
+		RSEQ_STORE_LONG(var) "%[" __rseq_str(value) "], %[" __rseq_str(var) "]\n\t"
 
 /* Load @var to r17 */
 #define RSEQ_ASM_OP_R_LOAD(var)							\
-		LOAD_WORD "%%r17, %[" __rseq_str(var) "]\n\t"
+		RSEQ_LOAD_LONG(var) "%%r17, %[" __rseq_str(var) "]\n\t"
 
 /* Store r17 to @var */
 #define RSEQ_ASM_OP_R_STORE(var)						\
-		STORE_WORD "%%r17, %[" __rseq_str(var) "]\n\t"
+		RSEQ_STORE_LONG(var) "%%r17, %[" __rseq_str(var) "]\n\t"
 
 /* Add @count to r17 */
 #define RSEQ_ASM_OP_R_ADD(count)						\
@@ -179,11 +185,11 @@ do {									\
 
 /* Load (r17 + voffp) to r17 */
 #define RSEQ_ASM_OP_R_LOADX(voffp)						\
-		LOADX_WORD "%%r17, %[" __rseq_str(voffp) "], %%r17\n\t"
+		RSEQ_LOADX_LONG "%%r17, %[" __rseq_str(voffp) "], %%r17\n\t"
 
 /* TODO: implement a faster memcpy. */
 #define RSEQ_ASM_OP_R_MEMCPY() \
-		"cmpdi %%r19, 0\n\t" \
+		RSEQ_CMP_LONG_INT "%%r19, 0\n\t" \
 		"beq 333f\n\t" \
 		"addi %%r20, %%r20, -1\n\t" \
 		"addi %%r21, %%r21, -1\n\t" \
@@ -191,16 +197,16 @@ do {									\
 		"lbzu %%r18, 1(%%r20)\n\t" \
 		"stbu %%r18, 1(%%r21)\n\t" \
 		"addi %%r19, %%r19, -1\n\t" \
-		"cmpdi %%r19, 0\n\t" \
+		RSEQ_CMP_LONG_INT "%%r19, 0\n\t" \
 		"bne 222b\n\t" \
 		"333:\n\t" \
 
 #define RSEQ_ASM_OP_R_FINAL_STORE(var, post_commit_label)			\
-		STORE_WORD "%%r17, %[" __rseq_str(var) "]\n\t"			\
+		RSEQ_STORE_LONG(var) "%%r17, %[" __rseq_str(var) "]\n\t"			\
 		__rseq_str(post_commit_label) ":\n\t"
 
 #define RSEQ_ASM_OP_FINAL_STORE(value, var, post_commit_label)			\
-		STORE_WORD "%[" __rseq_str(value) "], %[" __rseq_str(var) "]\n\t" \
+		RSEQ_STORE_LONG(var) "%[" __rseq_str(value) "], %[" __rseq_str(var) "]\n\t" \
 		__rseq_str(post_commit_label) ":\n\t"
 
 static inline __attribute__((always_inline))
@@ -235,8 +241,8 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 		RSEQ_ASM_DEFINE_ABORT(4, abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
 		  [newv]		"r" (newv)
@@ -248,23 +254,28 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
 
 static inline __attribute__((always_inline))
 int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
-			       off_t voffp, intptr_t *load, int cpu)
+			       long voffp, intptr_t *load, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
@@ -301,8 +312,8 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		RSEQ_ASM_DEFINE_ABORT(4, abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expectnot]		"r" (expectnot),
@@ -316,16 +327,21 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -359,8 +375,8 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		RSEQ_ASM_DEFINE_ABORT(4, abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [count]		"r" (count)
@@ -372,12 +388,15 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		  , error1
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 #endif
 }
@@ -419,8 +438,8 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -436,16 +455,21 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -489,8 +513,8 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -506,16 +530,21 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -560,8 +589,8 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* cmp2 input */
 		  [v2]			"m" (*v2),
 		  [expect2]		"r" (expect2),
@@ -577,18 +606,24 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2, error3
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("1st expected value comparison failed");
 error3:
+	rseq_after_asm_goto();
 	rseq_bug("2nd expected value comparison failed");
 #endif
 }
@@ -635,8 +670,8 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
@@ -653,16 +688,21 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -711,8 +751,8 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
@@ -729,23 +769,23 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
 
-#undef STORE_WORD
-#undef LOAD_WORD
-#undef LOADX_WORD
-#undef CMP_WORD
-
 #endif /* !RSEQ_SKIP_FASTPATH */
diff --git a/tools/testing/selftests/rseq/rseq-s390.h b/tools/testing/selftests/rseq/rseq-s390.h
index 8ef94ad1cbb4..4e6dc5f0cb42 100644
--- a/tools/testing/selftests/rseq/rseq-s390.h
+++ b/tools/testing/selftests/rseq/rseq-s390.h
@@ -165,8 +165,8 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
 		  [newv]		"r" (newv)
@@ -178,16 +178,21 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -198,7 +203,7 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
  */
 static inline __attribute__((always_inline))
 int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
-			       off_t voffp, intptr_t *load, int cpu)
+			       long voffp, intptr_t *load, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
@@ -233,8 +238,8 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expectnot]		"r" (expectnot),
@@ -248,16 +253,21 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -288,8 +298,8 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [count]		"r" (count)
@@ -301,12 +311,15 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		  , error1
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 #endif
 }
@@ -347,8 +360,8 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -364,16 +377,21 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -426,8 +444,8 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* cmp2 input */
 		  [v2]			"m" (*v2),
 		  [expect2]		"r" (expect2),
@@ -443,18 +461,24 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2, error3
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("1st expected value comparison failed");
 error3:
+	rseq_after_asm_goto();
 	rseq_bug("2nd expected value comparison failed");
 #endif
 }
@@ -534,8 +558,8 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 #endif
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [current_cpu_id]	"m" (__rseq_abi.cpu_id),
-		  [rseq_cs]		"m" (__rseq_abi.rseq_cs),
+		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
@@ -555,16 +579,21 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
diff --git a/tools/testing/selftests/rseq/rseq-skip.h b/tools/testing/selftests/rseq/rseq-skip.h
index 72750b5905a9..7b53dac1fcdd 100644
--- a/tools/testing/selftests/rseq/rseq-skip.h
+++ b/tools/testing/selftests/rseq/rseq-skip.h
@@ -13,7 +13,7 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 
 static inline __attribute__((always_inline))
 int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
-			       off_t voffp, intptr_t *load, int cpu)
+			       long voffp, intptr_t *load, int cpu)
 {
 	return -1;
 }
diff --git a/tools/testing/selftests/rseq/rseq-thread-pointer.h b/tools/testing/selftests/rseq/rseq-thread-pointer.h
new file mode 100644
index 000000000000..977c25d758b2
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq-thread-pointer.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: LGPL-2.1-only OR MIT */
+/*
+ * rseq-thread-pointer.h
+ *
+ * (C) Copyright 2021 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#ifndef _RSEQ_THREAD_POINTER
+#define _RSEQ_THREAD_POINTER
+
+#if defined(__x86_64__) || defined(__i386__)
+#include "rseq-x86-thread-pointer.h"
+#elif defined(__PPC__)
+#include "rseq-ppc-thread-pointer.h"
+#else
+#include "rseq-generic-thread-pointer.h"
+#endif
+
+#endif
diff --git a/tools/testing/selftests/rseq/rseq-x86-thread-pointer.h b/tools/testing/selftests/rseq/rseq-x86-thread-pointer.h
new file mode 100644
index 000000000000..d3133587d996
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq-x86-thread-pointer.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: LGPL-2.1-only OR MIT */
+/*
+ * rseq-x86-thread-pointer.h
+ *
+ * (C) Copyright 2021 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#ifndef _RSEQ_X86_THREAD_POINTER
+#define _RSEQ_X86_THREAD_POINTER
+
+#include <features.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#if __GNUC_PREREQ (11, 1)
+static inline void *rseq_thread_pointer(void)
+{
+	return __builtin_thread_pointer();
+}
+#else
+static inline void *rseq_thread_pointer(void)
+{
+	void *__result;
+
+# ifdef __x86_64__
+	__asm__ ("mov %%fs:0, %0" : "=r" (__result));
+# else
+	__asm__ ("mov %%gs:0, %0" : "=r" (__result));
+# endif
+	return __result;
+}
+#endif /* !GCC 11 */
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/tools/testing/selftests/rseq/rseq-x86.h b/tools/testing/selftests/rseq/rseq-x86.h
index 640411518e46..bd01dc41ca13 100644
--- a/tools/testing/selftests/rseq/rseq-x86.h
+++ b/tools/testing/selftests/rseq/rseq-x86.h
@@ -28,6 +28,8 @@
 
 #ifdef __x86_64__
 
+#define RSEQ_ASM_TP_SEGMENT	%%fs
+
 #define rseq_smp_mb()	\
 	__asm__ __volatile__ ("lock; addl $0,-128(%%rsp)" ::: "memory", "cc")
 #define rseq_smp_rmb()	rseq_barrier()
@@ -123,14 +125,14 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error2])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"cmpq %[v], %[expect]\n\t"
 		"jnz %l[cmpfail]\n\t"
 		RSEQ_INJECT_ASM(4)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 		"cmpq %[v], %[expect]\n\t"
 		"jnz %l[error2]\n\t"
 #endif
@@ -141,7 +143,7 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (&__rseq_abi),
+		  [rseq_offset]		"r" (rseq_offset),
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
 		  [newv]		"r" (newv)
@@ -152,16 +154,21 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -172,7 +179,7 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
  */
 static inline __attribute__((always_inline))
 int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
-			       off_t voffp, intptr_t *load, int cpu)
+			       long voffp, intptr_t *load, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
@@ -184,15 +191,15 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error2])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"movq %[v], %%rbx\n\t"
 		"cmpq %%rbx, %[expectnot]\n\t"
 		"je %l[cmpfail]\n\t"
 		RSEQ_INJECT_ASM(4)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 		"movq %[v], %%rbx\n\t"
 		"cmpq %%rbx, %[expectnot]\n\t"
 		"je %l[error2]\n\t"
@@ -207,7 +214,7 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (&__rseq_abi),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expectnot]		"r" (expectnot),
@@ -220,16 +227,21 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -245,11 +257,11 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error1])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 #endif
 		/* final store */
 		"addq %[count], %[v]\n\t"
@@ -258,7 +270,7 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (&__rseq_abi),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [count]		"er" (count)
@@ -269,12 +281,15 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		  , error1
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 #endif
 }
@@ -286,7 +301,7 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
  *  *pval += inc;
  */
 static inline __attribute__((always_inline))
-int rseq_offset_deref_addv(intptr_t *ptr, off_t off, intptr_t inc, int cpu)
+int rseq_offset_deref_addv(intptr_t *ptr, long off, intptr_t inc, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
@@ -296,11 +311,11 @@ int rseq_offset_deref_addv(intptr_t *ptr, off_t off, intptr_t inc, int cpu)
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error1])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 #endif
 		/* get p+v */
 		"movq %[ptr], %%rbx\n\t"
@@ -314,7 +329,7 @@ int rseq_offset_deref_addv(intptr_t *ptr, off_t off, intptr_t inc, int cpu)
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (&__rseq_abi),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* final store input */
 		  [ptr]			"m" (*ptr),
 		  [off]			"er" (off),
@@ -351,14 +366,14 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error2])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"cmpq %[v], %[expect]\n\t"
 		"jnz %l[cmpfail]\n\t"
 		RSEQ_INJECT_ASM(4)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 		"cmpq %[v], %[expect]\n\t"
 		"jnz %l[error2]\n\t"
 #endif
@@ -372,7 +387,7 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (&__rseq_abi),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -387,16 +402,21 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -426,8 +446,8 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error3])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"cmpq %[v], %[expect]\n\t"
 		"jnz %l[cmpfail]\n\t"
@@ -436,7 +456,7 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		"jnz %l[cmpfail]\n\t"
 		RSEQ_INJECT_ASM(5)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 		"cmpq %[v], %[expect]\n\t"
 		"jnz %l[error2]\n\t"
 		"cmpq %[v2], %[expect2]\n\t"
@@ -449,7 +469,7 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (&__rseq_abi),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* cmp2 input */
 		  [v2]			"m" (*v2),
 		  [expect2]		"r" (expect2),
@@ -464,18 +484,24 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2, error3
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("1st expected value comparison failed");
 error3:
+	rseq_after_asm_goto();
 	rseq_bug("2nd expected value comparison failed");
 #endif
 }
@@ -500,14 +526,14 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 		"movq %[dst], %[rseq_scratch1]\n\t"
 		"movq %[len], %[rseq_scratch2]\n\t"
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"cmpq %[v], %[expect]\n\t"
 		"jnz 5f\n\t"
 		RSEQ_INJECT_ASM(4)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 6f)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 6f)
 		"cmpq %[v], %[expect]\n\t"
 		"jnz 7f\n\t"
 #endif
@@ -555,7 +581,7 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 #endif
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (&__rseq_abi),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
@@ -574,16 +600,21 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -600,7 +631,9 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
 
 #endif /* !RSEQ_SKIP_FASTPATH */
 
-#elif __i386__
+#elif defined(__i386__)
+
+#define RSEQ_ASM_TP_SEGMENT	%%gs
 
 #define rseq_smp_mb()	\
 	__asm__ __volatile__ ("lock; addl $0,-128(%%esp)" ::: "memory", "cc")
@@ -701,14 +734,14 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error2])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"cmpl %[v], %[expect]\n\t"
 		"jnz %l[cmpfail]\n\t"
 		RSEQ_INJECT_ASM(4)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 		"cmpl %[v], %[expect]\n\t"
 		"jnz %l[error2]\n\t"
 #endif
@@ -719,7 +752,7 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (&__rseq_abi),
+		  [rseq_offset]		"r" (rseq_offset),
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
 		  [newv]		"r" (newv)
@@ -730,16 +763,21 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -750,7 +788,7 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
  */
 static inline __attribute__((always_inline))
 int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
-			       off_t voffp, intptr_t *load, int cpu)
+			       long voffp, intptr_t *load, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
@@ -762,15 +800,15 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error2])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"movl %[v], %%ebx\n\t"
 		"cmpl %%ebx, %[expectnot]\n\t"
 		"je %l[cmpfail]\n\t"
 		RSEQ_INJECT_ASM(4)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 		"movl %[v], %%ebx\n\t"
 		"cmpl %%ebx, %[expectnot]\n\t"
 		"je %l[error2]\n\t"
@@ -785,7 +823,7 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (&__rseq_abi),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expectnot]		"r" (expectnot),
@@ -798,16 +836,21 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -823,11 +866,11 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error1])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 #endif
 		/* final store */
 		"addl %[count], %[v]\n\t"
@@ -836,7 +879,7 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (&__rseq_abi),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [count]		"ir" (count)
@@ -847,12 +890,15 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		  , error1
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 #endif
 }
@@ -872,14 +918,14 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error2])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"cmpl %[v], %[expect]\n\t"
 		"jnz %l[cmpfail]\n\t"
 		RSEQ_INJECT_ASM(4)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 		"cmpl %[v], %[expect]\n\t"
 		"jnz %l[error2]\n\t"
 #endif
@@ -894,7 +940,7 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (&__rseq_abi),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"m" (newv2),
@@ -909,16 +955,21 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -938,15 +989,15 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error2])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"movl %[expect], %%eax\n\t"
 		"cmpl %[v], %%eax\n\t"
 		"jnz %l[cmpfail]\n\t"
 		RSEQ_INJECT_ASM(4)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 		"movl %[expect], %%eax\n\t"
 		"cmpl %[v], %%eax\n\t"
 		"jnz %l[error2]\n\t"
@@ -962,7 +1013,7 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (&__rseq_abi),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -977,16 +1028,21 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 
@@ -1008,8 +1064,8 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error3])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"cmpl %[v], %[expect]\n\t"
 		"jnz %l[cmpfail]\n\t"
@@ -1018,7 +1074,7 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		"jnz %l[cmpfail]\n\t"
 		RSEQ_INJECT_ASM(5)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 		"cmpl %[v], %[expect]\n\t"
 		"jnz %l[error2]\n\t"
 		"cmpl %[expect2], %[v2]\n\t"
@@ -1032,7 +1088,7 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (&__rseq_abi),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* cmp2 input */
 		  [v2]			"m" (*v2),
 		  [expect2]		"r" (expect2),
@@ -1047,18 +1103,24 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2, error3
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("1st expected value comparison failed");
 error3:
+	rseq_after_asm_goto();
 	rseq_bug("2nd expected value comparison failed");
 #endif
 }
@@ -1084,15 +1146,15 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 		"movl %[dst], %[rseq_scratch1]\n\t"
 		"movl %[len], %[rseq_scratch2]\n\t"
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"movl %[expect], %%eax\n\t"
 		"cmpl %%eax, %[v]\n\t"
 		"jnz 5f\n\t"
 		RSEQ_INJECT_ASM(4)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 6f)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 6f)
 		"movl %[expect], %%eax\n\t"
 		"cmpl %%eax, %[v]\n\t"
 		"jnz 7f\n\t"
@@ -1142,7 +1204,7 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 #endif
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (&__rseq_abi),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"m" (expect),
@@ -1161,16 +1223,21 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -1196,15 +1263,15 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
 		"movl %[dst], %[rseq_scratch1]\n\t"
 		"movl %[len], %[rseq_scratch2]\n\t"
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"movl %[expect], %%eax\n\t"
 		"cmpl %%eax, %[v]\n\t"
 		"jnz 5f\n\t"
 		RSEQ_INJECT_ASM(4)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 6f)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 6f)
 		"movl %[expect], %%eax\n\t"
 		"cmpl %%eax, %[v]\n\t"
 		"jnz 7f\n\t"
@@ -1255,7 +1322,7 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
 #endif
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (&__rseq_abi),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"m" (expect),
@@ -1274,16 +1341,21 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
diff --git a/tools/testing/selftests/rseq/rseq.c b/tools/testing/selftests/rseq/rseq.c
index 7159eb777fd3..986b9458efb2 100644
--- a/tools/testing/selftests/rseq/rseq.c
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -26,131 +26,124 @@
 #include <assert.h>
 #include <signal.h>
 #include <limits.h>
+#include <dlfcn.h>
+#include <stddef.h>
 
+#include "../kselftest.h"
 #include "rseq.h"
 
-#define ARRAY_SIZE(arr)	(sizeof(arr) / sizeof((arr)[0]))
+static const ptrdiff_t *libc_rseq_offset_p;
+static const unsigned int *libc_rseq_size_p;
+static const unsigned int *libc_rseq_flags_p;
 
-__thread volatile struct rseq __rseq_abi = {
-	.cpu_id = RSEQ_CPU_ID_UNINITIALIZED,
-};
+/* Offset from the thread pointer to the rseq area.  */
+ptrdiff_t rseq_offset;
 
-/*
- * Shared with other libraries. This library may take rseq ownership if it is
- * still 0 when executing the library constructor. Set to 1 by library
- * constructor when handling rseq. Set to 0 in destructor if handling rseq.
- */
-int __rseq_handled;
+/* Size of the registered rseq area.  0 if the registration was
+   unsuccessful.  */
+unsigned int rseq_size = -1U;
+
+/* Flags used during rseq registration.  */
+unsigned int rseq_flags;
 
-/* Whether this library have ownership of rseq registration. */
 static int rseq_ownership;
 
-static __thread volatile uint32_t __rseq_refcount;
+static
+__thread struct rseq_abi __rseq_abi __attribute__((tls_model("initial-exec"))) = {
+	.cpu_id = RSEQ_ABI_CPU_ID_UNINITIALIZED,
+};
 
-static void signal_off_save(sigset_t *oldset)
+static int sys_rseq(struct rseq_abi *rseq_abi, uint32_t rseq_len,
+		    int flags, uint32_t sig)
 {
-	sigset_t set;
-	int ret;
-
-	sigfillset(&set);
-	ret = pthread_sigmask(SIG_BLOCK, &set, oldset);
-	if (ret)
-		abort();
+	return syscall(__NR_rseq, rseq_abi, rseq_len, flags, sig);
 }
 
-static void signal_restore(sigset_t oldset)
+int rseq_available(void)
 {
-	int ret;
+	int rc;
 
-	ret = pthread_sigmask(SIG_SETMASK, &oldset, NULL);
-	if (ret)
+	rc = sys_rseq(NULL, 0, 0, 0);
+	if (rc != -1)
 		abort();
-}
-
-static int sys_rseq(volatile struct rseq *rseq_abi, uint32_t rseq_len,
-		    int flags, uint32_t sig)
-{
-	return syscall(__NR_rseq, rseq_abi, rseq_len, flags, sig);
+	switch (errno) {
+	case ENOSYS:
+		return 0;
+	case EINVAL:
+		return 1;
+	default:
+		abort();
+	}
 }
 
 int rseq_register_current_thread(void)
 {
-	int rc, ret = 0;
-	sigset_t oldset;
+	int rc;
 
-	if (!rseq_ownership)
+	if (!rseq_ownership) {
+		/* Treat libc's ownership as a successful registration. */
 		return 0;
-	signal_off_save(&oldset);
-	if (__rseq_refcount == UINT_MAX) {
-		ret = -1;
-		goto end;
-	}
-	if (__rseq_refcount++)
-		goto end;
-	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq), 0, RSEQ_SIG);
-	if (!rc) {
-		assert(rseq_current_cpu_raw() >= 0);
-		goto end;
 	}
-	if (errno != EBUSY)
-		__rseq_abi.cpu_id = RSEQ_CPU_ID_REGISTRATION_FAILED;
-	ret = -1;
-	__rseq_refcount--;
-end:
-	signal_restore(oldset);
-	return ret;
+	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq_abi), 0, RSEQ_SIG);
+	if (rc)
+		return -1;
+	assert(rseq_current_cpu_raw() >= 0);
+	return 0;
 }
 
 int rseq_unregister_current_thread(void)
 {
-	int rc, ret = 0;
-	sigset_t oldset;
+	int rc;
 
-	if (!rseq_ownership)
+	if (!rseq_ownership) {
+		/* Treat libc's ownership as a successful unregistration. */
 		return 0;
-	signal_off_save(&oldset);
-	if (!__rseq_refcount) {
-		ret = -1;
-		goto end;
 	}
-	if (--__rseq_refcount)
-		goto end;
-	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq),
-		      RSEQ_FLAG_UNREGISTER, RSEQ_SIG);
-	if (!rc)
-		goto end;
-	__rseq_refcount = 1;
-	ret = -1;
-end:
-	signal_restore(oldset);
-	return ret;
+	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq_abi), RSEQ_ABI_FLAG_UNREGISTER, RSEQ_SIG);
+	if (rc)
+		return -1;
+	return 0;
 }
 
-int32_t rseq_fallback_current_cpu(void)
+static __attribute__((constructor))
+void rseq_init(void)
 {
-	int32_t cpu;
-
-	cpu = sched_getcpu();
-	if (cpu < 0) {
-		perror("sched_getcpu()");
-		abort();
+	libc_rseq_offset_p = dlsym(RTLD_NEXT, "__rseq_offset");
+	libc_rseq_size_p = dlsym(RTLD_NEXT, "__rseq_size");
+	libc_rseq_flags_p = dlsym(RTLD_NEXT, "__rseq_flags");
+	if (libc_rseq_size_p && libc_rseq_offset_p && libc_rseq_flags_p) {
+		/* rseq registration owned by glibc */
+		rseq_offset = *libc_rseq_offset_p;
+		rseq_size = *libc_rseq_size_p;
+		rseq_flags = *libc_rseq_flags_p;
+		return;
 	}
-	return cpu;
-}
-
-void __attribute__((constructor)) rseq_init(void)
-{
-	/* Check whether rseq is handled by another library. */
-	if (__rseq_handled)
+	if (!rseq_available())
 		return;
-	__rseq_handled = 1;
 	rseq_ownership = 1;
+	rseq_offset = (void *)&__rseq_abi - rseq_thread_pointer();
+	rseq_size = sizeof(struct rseq_abi);
+	rseq_flags = 0;
 }
 
-void __attribute__((destructor)) rseq_fini(void)
+static __attribute__((destructor))
+void rseq_exit(void)
 {
 	if (!rseq_ownership)
 		return;
-	__rseq_handled = 0;
+	rseq_offset = 0;
+	rseq_size = -1U;
 	rseq_ownership = 0;
 }
+
+int32_t rseq_fallback_current_cpu(void)
+{
+	int32_t cpu;
+
+	cpu = sched_getcpu();
+	if (cpu < 0) {
+		perror("sched_getcpu()");
+		abort();
+	}
+	return cpu;
+}
diff --git a/tools/testing/selftests/rseq/rseq.h b/tools/testing/selftests/rseq/rseq.h
index 3f63eb362b92..9d850b290c2e 100644
--- a/tools/testing/selftests/rseq/rseq.h
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -16,7 +16,9 @@
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <linux/rseq.h>
+#include <stddef.h>
+#include "rseq-abi.h"
+#include "compiler.h"
 
 /*
  * Empty code injection macros, override when testing.
@@ -43,8 +45,20 @@
 #define RSEQ_INJECT_FAILED
 #endif
 
-extern __thread volatile struct rseq __rseq_abi;
-extern int __rseq_handled;
+#include "rseq-thread-pointer.h"
+
+/* Offset from the thread pointer to the rseq area.  */
+extern ptrdiff_t rseq_offset;
+/* Size of the registered rseq area.  0 if the registration was
+   unsuccessful.  */
+extern unsigned int rseq_size;
+/* Flags used during rseq registration.  */
+extern unsigned int rseq_flags;
+
+static inline struct rseq_abi *rseq_get_abi(void)
+{
+	return (struct rseq_abi *) ((uintptr_t) rseq_thread_pointer() + rseq_offset);
+}
 
 #define rseq_likely(x)		__builtin_expect(!!(x), 1)
 #define rseq_unlikely(x)	__builtin_expect(!!(x), 0)
@@ -108,7 +122,7 @@ int32_t rseq_fallback_current_cpu(void);
  */
 static inline int32_t rseq_current_cpu_raw(void)
 {
-	return RSEQ_ACCESS_ONCE(__rseq_abi.cpu_id);
+	return RSEQ_ACCESS_ONCE(rseq_get_abi()->cpu_id);
 }
 
 /*
@@ -124,7 +138,7 @@ static inline int32_t rseq_current_cpu_raw(void)
  */
 static inline uint32_t rseq_cpu_start(void)
 {
-	return RSEQ_ACCESS_ONCE(__rseq_abi.cpu_id_start);
+	return RSEQ_ACCESS_ONCE(rseq_get_abi()->cpu_id_start);
 }
 
 static inline uint32_t rseq_current_cpu(void)
@@ -139,11 +153,7 @@ static inline uint32_t rseq_current_cpu(void)
 
 static inline void rseq_clear_rseq_cs(void)
 {
-#ifdef __LP64__
-	__rseq_abi.rseq_cs.ptr = 0;
-#else
-	__rseq_abi.rseq_cs.ptr.ptr32 = 0;
-#endif
+	RSEQ_WRITE_ONCE(rseq_get_abi()->rseq_cs.arch.ptr, 0);
 }
 
 /*

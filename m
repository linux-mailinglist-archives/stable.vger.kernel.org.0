Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009C8674748
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 00:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjASXiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 18:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjASXh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 18:37:59 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7EB37F29;
        Thu, 19 Jan 2023 15:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3bFcAmrUNZByWsKADlIMkrUGMQdyY3YOwND5QaxPXD0=; b=sAhZRTjePyXmpkMA+IBZCV/UVi
        SegprcJoEyJMLbLSphnSfQZGmUSaAFqvF6D272hYtokhTx9wZN2IC8mZB9vaiRMcnGkX8ms1n8yA8
        wGSt06BQr2VM20FF2l6SndZiKujwlk/0YkcRBWT/1TyevKCQ/uTTDMODRhtcT2XD5N+iEJJePC1Gw
        NVvM16p15JWzUIOvdc3ltmHVgHQ0Ei4bqXmYxh6rsKZieEYIcunOgBn8nalyrnokHYJ3yzfLe7bg2
        H45mKXEBkw65k4B1DOUNcpqok4uIh6gr5HeWbEIRrQavxWFIGkS8iClTHrshNmsMs10olKRUR4A9N
        +EsuNJcw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pIeTY-007dU3-La; Thu, 19 Jan 2023 23:37:44 +0000
Date:   Thu, 19 Jan 2023 15:37:44 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Petr Mladek <pmladek@suse.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        NeilBrown <neilb@suse.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Petr Pavlu <petr.pavlu@suse.com>, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <Y8nUSL8VSiDIVYCb@bombadil.infradead.org>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org>
 <Y5hRRnBGYaPby/RS@alley>
 <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
 <Y8hQbC3wvu1S+uZ5@zn.tnic>
 <Y8ibg2cB4gB2gQ8f@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8ibg2cB4gB2gQ8f@bombadil.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 18, 2023 at 05:23:15PM -0800, Luis Chamberlain wrote:
> On Wed, Jan 18, 2023 at 09:02:52PM +0100, Borislav Petkov wrote:
> > On Tue, Jan 17, 2023 at 04:04:22PM -0800, Luis Chamberlain wrote:
> > > and now I'm seeing this while trying to build v5.1:
> > > 
> > > ld: arch/x86/boot/compressed/pgtable_64.o:(.bss+0x0): multiple definition of `__force_order';
> > > arch/x86/boot/compressed/kaslr_64.o:(.bss+0x0): first defined here
> > 
> > You need to backport 
> > 
> > aa5cacdc29d7 ("x86/asm: Replace __force_order with a memory clobber")
> > 
> > for that.
> > 
> > Happens when building older kernels with newer toolchain.
> 
> Thanks that certainly helps. FWIW if someone needs it, I had to remove
> the double colons on write cr0 and cr4 to compile, but this crashed :(
> Any ideas?

The issue was my write for cr0 and cr4 didn't have r+, so:

diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 5586e4cf62d3..e4da7248edcf 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -26,7 +26,7 @@ static inline unsigned long native_read_cr0(void)
 
 static inline void native_write_cr0(unsigned long val)
 {
-	asm volatile("mov %0,%%cr0": : "r" (val) : "memory");
+	asm volatile("mov %0,%%cr0": "+r" (val) : : "memory");
 }
 
 static inline unsigned long native_read_cr2(void)
@@ -75,7 +75,7 @@ static inline unsigned long native_read_cr4(void)
 
 static inline void native_write_cr4(unsigned long val)
 {
-	asm volatile("mov %0,%%cr4": : "r" (val) : "memory");
+	asm volatile("mov %0,%%cr4": "+r" (val) : : "memory");
 }
 
 #ifdef CONFIG_X86_64

The complete patch below now boots on v5.2 however this still ends up in
a panic, it dies on cpu_startup_entry().

[    0.595694] x86: Booting SMP configuration:
[    0.596807] .... node  #0, CPUs:      #1
[    0.264759] kvm-clock: cpu 1, msr 15edff041, secondary cpu clock
[    0.264759] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: start_secondary+0x1c6/0x1d0
[    0.264759] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.2.0+ #5
[    0.264759] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-debian-1.16.0-5 04/01/2014
[    0.264759] Call Trace:
[    0.264759]  dump_stack+0x5c/0x80
[    0.264759]  panic+0x102/0x2f5
[    0.264759]  ? start_secondary+0x1c6/0x1d0
[    0.264759]  __stack_chk_fail+0x15/0x20
[    0.264759]  start_secondary+0x1c6/0x1d0
[    0.264759]  secondary_startup_64+0xa4/0xb0
[    0.264759] ---[ end Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: start_secondary+0x1c6/0x1d0 ]---

(gdb) l *(start_secondary+0x1c6)
0xffffffff810506e6 is at arch/x86/kernel/smpboot.c:265.
260             boot_init_stack_canary();
261
262             x86_cpuinit.setup_percpu_clockev();
263
264             wmb();
265             cpu_startup_entry(CPUHP_AP_ONLINE_IDLE);
266     }
267
268     /**
269      * topology_is_primary_thread - Check whether CPU is the primary SMT thread


The full attempt to backport aa5cacdc29d7 to v5.2:

diff --git a/arch/x86/boot/compressed/kaslr_64.c b/arch/x86/boot/compressed/kaslr_64.c
index 748456c365f4..9557c5a15b91 100644
--- a/arch/x86/boot/compressed/kaslr_64.c
+++ b/arch/x86/boot/compressed/kaslr_64.c
@@ -29,9 +29,6 @@
 #define __PAGE_OFFSET __PAGE_OFFSET_BASE
 #include "../../mm/ident_map.c"
 
-/* Used by pgtable.h asm code to force instruction serialization. */
-unsigned long __force_order;
-
 /* Used to track our page table allocation area. */
 struct alloc_pgt_data {
 	unsigned char *pgt_buf;
diff --git a/arch/x86/boot/compressed/pgtable_64.c b/arch/x86/boot/compressed/pgtable_64.c
index f8debf7aeb4c..7471b48524cb 100644
--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -5,15 +5,6 @@
 #include "pgtable.h"
 #include "../string.h"
 
-/*
- * __force_order is used by special_insns.h asm code to force instruction
- * serialization.
- *
- * It is not referenced from the code, but GCC < 5 with -fPIE would fail
- * due to an undefined symbol. Define it to make these ancient GCCs work.
- */
-unsigned long __force_order;
-
 #define BIOS_START_MIN		0x20000U	/* 128K, less than this is insane */
 #define BIOS_START_MAX		0x9f000U	/* 640K, absolute maximum */
 
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 0a3c4cab39db..e4da7248edcf 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -7,49 +7,50 @@
 
 #include <asm/nops.h>
 
+#define __FORCE_ORDER "m"(*(unsigned int *)0x1000UL)
+
 /*
- * Volatile isn't enough to prevent the compiler from reordering the
- * read/write functions for the control registers and messing everything up.
- * A memory clobber would solve the problem, but would prevent reordering of
- * all loads stores around it, which can hurt performance. Solution is to
- * use a variable and mimic reads and writes to it to enforce serialization
+ * The compiler should not reorder volatile asm statements with respect to each
+ * other: they should execute in program order. However GCC 4.9.x and 5.x have
+ * a bug (which was fixed in 8.1, 7.3 and 6.5) where they might reorder
+ * volatile asm. The write functions are not affected since they have memory
+ * clobbers preventing reordering. To prevent reads from being reordered with
+ * respect to writes, use a dummy memory operand
  */
-extern unsigned long __force_order;
-
 static inline unsigned long native_read_cr0(void)
 {
 	unsigned long val;
-	asm volatile("mov %%cr0,%0\n\t" : "=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr0,%0\n\t" : "=r" (val) : __FORCE_ORDER);
 	return val;
 }
 
 static inline void native_write_cr0(unsigned long val)
 {
-	asm volatile("mov %0,%%cr0": : "r" (val), "m" (__force_order));
+	asm volatile("mov %0,%%cr0": "+r" (val) : : "memory");
 }
 
 static inline unsigned long native_read_cr2(void)
 {
 	unsigned long val;
-	asm volatile("mov %%cr2,%0\n\t" : "=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr2,%0\n\t" : "=r" (val) : __FORCE_ORDER);
 	return val;
 }
 
 static inline void native_write_cr2(unsigned long val)
 {
-	asm volatile("mov %0,%%cr2": : "r" (val), "m" (__force_order));
+	asm volatile("mov %0,%%cr2": : "r" (val) : "memory");
 }
 
 static inline unsigned long __native_read_cr3(void)
 {
 	unsigned long val;
-	asm volatile("mov %%cr3,%0\n\t" : "=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr3,%0\n\t" : "=r" (val) : __FORCE_ORDER);
 	return val;
 }
 
 static inline void native_write_cr3(unsigned long val)
 {
-	asm volatile("mov %0,%%cr3": : "r" (val), "m" (__force_order));
+	asm volatile("mov %0,%%cr3": : "r" (val) : "memory");
 }
 
 static inline unsigned long native_read_cr4(void)
@@ -64,17 +65,17 @@ static inline unsigned long native_read_cr4(void)
 	asm volatile("1: mov %%cr4, %0\n"
 		     "2:\n"
 		     _ASM_EXTABLE(1b, 2b)
-		     : "=r" (val), "=m" (__force_order) : "0" (0));
+		     : "=r" (val) : "0" (0), __FORCE_ORDER);
 #else
 	/* CR4 always exists on x86_64. */
-	asm volatile("mov %%cr4,%0\n\t" : "=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr4,%0\n\t" : "=r" (val) : __FORCE_ORDER);
 #endif
 	return val;
 }
 
 static inline void native_write_cr4(unsigned long val)
 {
-	asm volatile("mov %0,%%cr4": : "r" (val), "m" (__force_order));
+	asm volatile("mov %0,%%cr4": "+r" (val) : : "memory");
 }
 
 #ifdef CONFIG_X86_64
-- 
2.35.1


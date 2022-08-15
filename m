Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A526D593C88
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344098AbiHOTkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344116AbiHOTia (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:38:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23923FA19;
        Mon, 15 Aug 2022 11:46:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D043611DD;
        Mon, 15 Aug 2022 18:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D83EC433D6;
        Mon, 15 Aug 2022 18:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589195;
        bh=aNIxx6z7knY/YW6XDKOiztcUiW0pNHqrHuUnLYw9M+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJ3F17vh5Q4rMR9vDbfMNIKgaoir2BFuhy5UaVFyRZ5LgSerhaEpsndDXZARE18Rf
         giyr0Tl43F21q77GdqN2TdEE1MuNvSxWW9KIqsdUbUxtltS4jmfsdfu5taoPn0odUY
         Zj82l/1huVE6o5OKFbSXIvgmFwK0hA8pZ2CINbbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 643/779] s390/maccess: rework absolute lowcore accessors
Date:   Mon, 15 Aug 2022 20:04:47 +0200
Message-Id: <20220815180404.851126944@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit ed0192bc644f3553d64a5cb461bdd0b1fbae3fdf ]

Macro mem_assign_absolute() is able to access the whole memory, but
is only used and makes sense when updating the absolute lowcore.
Instead, introduce get_abs_lowcore() and put_abs_lowcore() macros
that limit access to absolute lowcore addresses only.

Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/processor.h | 17 ++++++++++++-----
 arch/s390/kernel/ipl.c            |  4 ++--
 arch/s390/kernel/machine_kexec.c  |  2 +-
 arch/s390/kernel/os_info.c        |  2 +-
 arch/s390/kernel/setup.c          | 19 ++++++++++---------
 arch/s390/kernel/smp.c            | 12 ++++++------
 6 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index e9db8efd50f2..d7ca76bb2720 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -321,11 +321,18 @@ extern void (*s390_base_pgm_handler_fn)(void);
 extern int memcpy_real(void *, unsigned long, size_t);
 extern void memcpy_absolute(void *, void *, size_t);
 
-#define mem_assign_absolute(dest, val) do {			\
-	__typeof__(dest) __tmp = (val);				\
-								\
-	BUILD_BUG_ON(sizeof(__tmp) != sizeof(val));		\
-	memcpy_absolute(&(dest), &__tmp, sizeof(__tmp));	\
+#define put_abs_lowcore(member, x) do {					\
+	unsigned long __abs_address = offsetof(struct lowcore, member);	\
+	__typeof__(((struct lowcore *)0)->member) __tmp = (x);		\
+									\
+	memcpy_absolute(__va(__abs_address), &__tmp, sizeof(__tmp));	\
+} while (0)
+
+#define get_abs_lowcore(x, member) do {					\
+	unsigned long __abs_address = offsetof(struct lowcore, member);	\
+	__typeof__(((struct lowcore *)0)->member) *__ptr = &(x);	\
+									\
+	memcpy_absolute(__ptr, __va(__abs_address), sizeof(*__ptr));	\
 } while (0)
 
 extern int s390_isolate_bp(void);
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 5ad1dde23dc5..ba2988783d66 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1646,8 +1646,8 @@ static void dump_reipl_run(struct shutdown_trigger *trigger)
 
 	csum = (__force unsigned int)
 	       csum_partial(reipl_block_actual, reipl_block_actual->hdr.len, 0);
-	mem_assign_absolute(S390_lowcore.ipib, ipib);
-	mem_assign_absolute(S390_lowcore.ipib_checksum, csum);
+	put_abs_lowcore(ipib, ipib);
+	put_abs_lowcore(ipib_checksum, csum);
 	dump_run(trigger);
 }
 
diff --git a/arch/s390/kernel/machine_kexec.c b/arch/s390/kernel/machine_kexec.c
index 0505e55a6297..4b95684fbe46 100644
--- a/arch/s390/kernel/machine_kexec.c
+++ b/arch/s390/kernel/machine_kexec.c
@@ -227,7 +227,7 @@ void arch_crash_save_vmcoreinfo(void)
 	vmcoreinfo_append_str("SAMODE31=%lx\n", __samode31);
 	vmcoreinfo_append_str("EAMODE31=%lx\n", __eamode31);
 	vmcoreinfo_append_str("KERNELOFFSET=%lx\n", kaslr_offset());
-	mem_assign_absolute(S390_lowcore.vmcore_info, paddr_vmcoreinfo_note());
+	put_abs_lowcore(vmcore_info, paddr_vmcoreinfo_note());
 }
 
 void machine_shutdown(void)
diff --git a/arch/s390/kernel/os_info.c b/arch/s390/kernel/os_info.c
index 6b5b64e67eee..1acc2e05d70f 100644
--- a/arch/s390/kernel/os_info.c
+++ b/arch/s390/kernel/os_info.c
@@ -63,7 +63,7 @@ void __init os_info_init(void)
 	os_info.version_minor = OS_INFO_VERSION_MINOR;
 	os_info.magic = OS_INFO_MAGIC;
 	os_info.csum = os_info_csum(&os_info);
-	mem_assign_absolute(S390_lowcore.os_info, __pa(ptr));
+	put_abs_lowcore(os_info, __pa(ptr));
 }
 
 #ifdef CONFIG_CRASH_DUMP
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 36c1f31dfd66..6b1a8697fae8 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -479,11 +479,11 @@ static void __init setup_lowcore_dat_off(void)
 	lc->mcck_stack = mcck_stack + STACK_INIT_OFFSET;
 
 	/* Setup absolute zero lowcore */
-	mem_assign_absolute(S390_lowcore.restart_stack, lc->restart_stack);
-	mem_assign_absolute(S390_lowcore.restart_fn, lc->restart_fn);
-	mem_assign_absolute(S390_lowcore.restart_data, lc->restart_data);
-	mem_assign_absolute(S390_lowcore.restart_source, lc->restart_source);
-	mem_assign_absolute(S390_lowcore.restart_psw, lc->restart_psw);
+	put_abs_lowcore(restart_stack, lc->restart_stack);
+	put_abs_lowcore(restart_fn, lc->restart_fn);
+	put_abs_lowcore(restart_data, lc->restart_data);
+	put_abs_lowcore(restart_source, lc->restart_source);
+	put_abs_lowcore(restart_psw, lc->restart_psw);
 
 	lc->spinlock_lockval = arch_spin_lockval(0);
 	lc->spinlock_index = 0;
@@ -500,6 +500,7 @@ static void __init setup_lowcore_dat_off(void)
 static void __init setup_lowcore_dat_on(void)
 {
 	struct lowcore *lc = lowcore_ptr[0];
+	int cr;
 
 	__ctl_clear_bit(0, 28);
 	S390_lowcore.external_new_psw.mask |= PSW_MASK_DAT;
@@ -508,10 +509,10 @@ static void __init setup_lowcore_dat_on(void)
 	S390_lowcore.io_new_psw.mask |= PSW_MASK_DAT;
 	__ctl_store(S390_lowcore.cregs_save_area, 0, 15);
 	__ctl_set_bit(0, 28);
-	mem_assign_absolute(S390_lowcore.restart_flags, RESTART_FLAG_CTLREGS);
-	mem_assign_absolute(S390_lowcore.program_new_psw, lc->program_new_psw);
-	memcpy_absolute(&S390_lowcore.cregs_save_area, lc->cregs_save_area,
-			sizeof(S390_lowcore.cregs_save_area));
+	put_abs_lowcore(restart_flags, RESTART_FLAG_CTLREGS);
+	put_abs_lowcore(program_new_psw, lc->program_new_psw);
+	for (cr = 0; cr < ARRAY_SIZE(lc->cregs_save_area); cr++)
+		put_abs_lowcore(cregs_save_area[cr], lc->cregs_save_area[cr]);
 }
 
 static struct resource code_resource = {
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 7bbcb5b8d3f6..35af70ed58fc 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -334,10 +334,10 @@ static void pcpu_delegate(struct pcpu *pcpu,
 		lc->restart_data = (unsigned long)data;
 		lc->restart_source = source_cpu;
 	} else {
-		mem_assign_absolute(lc->restart_stack, stack);
-		mem_assign_absolute(lc->restart_fn, (unsigned long)func);
-		mem_assign_absolute(lc->restart_data, (unsigned long)data);
-		mem_assign_absolute(lc->restart_source, source_cpu);
+		put_abs_lowcore(restart_stack, stack);
+		put_abs_lowcore(restart_fn, (unsigned long)func);
+		put_abs_lowcore(restart_data, (unsigned long)data);
+		put_abs_lowcore(restart_source, source_cpu);
 	}
 	__bpon();
 	asm volatile(
@@ -593,9 +593,9 @@ void smp_ctl_set_clear_bit(int cr, int bit, bool set)
 		parms.andval = ~(1UL << bit);
 	}
 	spin_lock(&ctl_lock);
-	memcpy_absolute(&ctlreg, &S390_lowcore.cregs_save_area[cr], sizeof(ctlreg));
+	get_abs_lowcore(ctlreg, cregs_save_area[cr]);
 	ctlreg = (ctlreg & parms.andval) | parms.orval;
-	memcpy_absolute(&S390_lowcore.cregs_save_area[cr], &ctlreg, sizeof(ctlreg));
+	put_abs_lowcore(cregs_save_area[cr], ctlreg);
 	spin_unlock(&ctl_lock);
 	on_each_cpu(smp_ctl_bit_callback, &parms, 1);
 }
-- 
2.35.1




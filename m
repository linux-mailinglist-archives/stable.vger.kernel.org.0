Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA13A6ADA8F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjCGJlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjCGJly (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:41:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509A85071D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:41:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1C6D612A0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC27FC433EF;
        Tue,  7 Mar 2023 09:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678182112;
        bh=NP4Y2QBwvdfquT3ibjidzDoqiKhPN0XUcPC661KReQw=;
        h=Subject:To:Cc:From:Date:From;
        b=txDiEydpzTQjTYLTNBHEaeGBEJ5l7HTlmG30tu0kh8CK0Ubj9pkJpKJdTsWorJyso
         G0Odp6DNOIXRWAiAaRLRjFmvBM+mQneRf/WFoH0/e5VjiMOJP551f5UbO8NGNBmiMG
         Uu9pfzMJV2SMBrWiGta34uc2oBCY2RbmZkl5Lfso=
Subject: FAILED: patch "[PATCH] arm64: efi: Make efi_rt_lock a raw_spinlock" failed to apply to 6.1-stable tree
To:     pierre.gondois@arm.com, ardb@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 10:41:49 +0100
Message-ID: <167818210919025@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 0e68b5517d3767562889f1d83fdb828c26adb24f
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167818210919025@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

0e68b5517d37 ("arm64: efi: Make efi_rt_lock a raw_spinlock")
ff7a167961d1 ("arm64: efi: Execute runtime services from a dedicated stack")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0e68b5517d3767562889f1d83fdb828c26adb24f Mon Sep 17 00:00:00 2001
From: Pierre Gondois <pierre.gondois@arm.com>
Date: Wed, 15 Feb 2023 17:10:47 +0100
Subject: [PATCH] arm64: efi: Make efi_rt_lock a raw_spinlock

Running a rt-kernel base on 6.2.0-rc3-rt1 on an Ampere Altra outputs
the following:
  BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:46
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 9, name: kworker/u320:0
  preempt_count: 2, expected: 0
  RCU nest depth: 0, expected: 0
  3 locks held by kworker/u320:0/9:
  #0: ffff3fff8c27d128 ((wq_completion)efi_rts_wq){+.+.}-{0:0}, at: process_one_work (./include/linux/atomic/atomic-long.h:41)
  #1: ffff80000861bdd0 ((work_completion)(&efi_rts_work.work)){+.+.}-{0:0}, at: process_one_work (./include/linux/atomic/atomic-long.h:41)
  #2: ffffdf7e1ed3e460 (efi_rt_lock){+.+.}-{3:3}, at: efi_call_rts (drivers/firmware/efi/runtime-wrappers.c:101)
  Preemption disabled at:
  efi_virtmap_load (./arch/arm64/include/asm/mmu_context.h:248)
  CPU: 0 PID: 9 Comm: kworker/u320:0 Tainted: G        W          6.2.0-rc3-rt1
  Hardware name: WIWYNN Mt.Jade Server System B81.03001.0005/Mt.Jade Motherboard, BIOS 1.08.20220218 (SCP: 1.08.20220218) 2022/02/18
  Workqueue: efi_rts_wq efi_call_rts
  Call trace:
  dump_backtrace (arch/arm64/kernel/stacktrace.c:158)
  show_stack (arch/arm64/kernel/stacktrace.c:165)
  dump_stack_lvl (lib/dump_stack.c:107 (discriminator 4))
  dump_stack (lib/dump_stack.c:114)
  __might_resched (kernel/sched/core.c:10134)
  rt_spin_lock (kernel/locking/rtmutex.c:1769 (discriminator 4))
  efi_call_rts (drivers/firmware/efi/runtime-wrappers.c:101)
  [...]

This seems to come from commit ff7a167961d1 ("arm64: efi: Execute
runtime services from a dedicated stack") which adds a spinlock. This
spinlock is taken through:
efi_call_rts()
\-efi_call_virt()
  \-efi_call_virt_pointer()
    \-arch_efi_call_virt_setup()

Make 'efi_rt_lock' a raw_spinlock to avoid being preempted.

[ardb: The EFI runtime services are called with a different set of
       translation tables, and are permitted to use the SIMD registers.
       The context switch code preserves/restores neither, and so EFI
       calls must be made with preemption disabled, rather than only
       disabling migration.]

Fixes: ff7a167961d1 ("arm64: efi: Execute runtime services from a dedicated stack")
Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Cc: <stable@vger.kernel.org> # v6.1+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 5d47d429672b..1b81dd5554cb 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -34,7 +34,7 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md,
 ({									\
 	efi_virtmap_load();						\
 	__efi_fpsimd_begin();						\
-	spin_lock(&efi_rt_lock);					\
+	raw_spin_lock(&efi_rt_lock);					\
 })
 
 #undef arch_efi_call_virt
@@ -43,12 +43,12 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md,
 
 #define arch_efi_call_virt_teardown()					\
 ({									\
-	spin_unlock(&efi_rt_lock);					\
+	raw_spin_unlock(&efi_rt_lock);					\
 	__efi_fpsimd_end();						\
 	efi_virtmap_unload();						\
 })
 
-extern spinlock_t efi_rt_lock;
+extern raw_spinlock_t efi_rt_lock;
 efi_status_t __efi_rt_asm_wrapper(void *, const char *, ...);
 
 #define ARCH_EFI_IRQ_FLAGS_MASK (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index db9007cae93d..b8108d56ca2d 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -157,7 +157,7 @@ asmlinkage efi_status_t efi_handle_corrupted_x18(efi_status_t s, const char *f)
 	return s;
 }
 
-DEFINE_SPINLOCK(efi_rt_lock);
+DEFINE_RAW_SPINLOCK(efi_rt_lock);
 
 asmlinkage u64 *efi_rt_stack_top __ro_after_init;
 


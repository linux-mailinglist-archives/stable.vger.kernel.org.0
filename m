Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7C26AE70B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbjCGQqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbjCGQp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 11:45:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F83494399
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 08:42:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B84B614C8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 16:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16F8C4339B;
        Tue,  7 Mar 2023 16:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678207348;
        bh=60mAOqykdYYRZHUtyckX9wb96vtWD0dmoH0iCqtp2Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zz/W34dAT0bLkd/i8C9tsv5m5k46NW+zD1TFOq3tzJ4tdkdrEtPRA59E6hSfLVCIz
         hx6FbQURakefUkhOYNd+A4S0vIag+oNpYjSiGIOvHXBXlplLtQw1c+y+KgopT0vohb
         YKFKeCi7BKtqLX0NXjxO7HprTqiV+r8t422T+gjazZ7NblzrvAKm5utet/pT4u3jSt
         4TEk2RuhhZT/OPXnW2sr55egCFC1fDv0CRuNmSVFiaVTYrdNDg1m3KtS//+I6//f5o
         zTXw5yyFctfPvDfhynsqkBozuoQNbrbswpUBWZ6qVv3dzCtj2JExL6hiNnHp+dnubV
         XJTRLWV2RP+xg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     Pierre Gondois <pierre.gondois@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1.y] arm64: efi: Make efi_rt_lock a raw_spinlock
Date:   Tue,  7 Mar 2023 17:41:50 +0100
Message-Id: <20230307164150.2430120-1-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <167818210919025@kroah.com>
References: <167818210919025@kroah.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3953; i=ardb@kernel.org; h=from:subject; bh=CWfbv0hkMjmvfYeYOJZSwYQf0qfRgXHIedR2HOgl6ag=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIYU909d1dfOkO1/rHrWsYbHSPiwd8JWPZ/EVlsXCJUu3P l3E5BXeUcrCIMbBICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACZyxY2RYXddstbFjWJLFLiC dWtZ719tf/W096b4M0Htz1yHbUyflTEyNFo8bo7M849Qi/rFtP5we7aDnNJOPoF/sVmFR9+z17K yAQA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre Gondois <pierre.gondois@arm.com>

[ Upstream commit 0e68b5517d3767562889f1d83fdb828c26adb24 ]

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
---
 arch/arm64/include/asm/efi.h | 6 +++---
 arch/arm64/kernel/efi.c      | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index b13c22046de58a8f..62c846be2d76ac60 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -33,7 +33,7 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 ({									\
 	efi_virtmap_load();						\
 	__efi_fpsimd_begin();						\
-	spin_lock(&efi_rt_lock);					\
+	raw_spin_lock(&efi_rt_lock);					\
 })
 
 #undef arch_efi_call_virt
@@ -42,12 +42,12 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 
 #define arch_efi_call_virt_teardown()					\
 ({									\
-	spin_unlock(&efi_rt_lock);					\
+	raw_spin_unlock(&efi_rt_lock);					\
 	__efi_fpsimd_end();						\
 	efi_virtmap_unload();						\
 })
 
-extern spinlock_t efi_rt_lock;
+extern raw_spinlock_t efi_rt_lock;
 extern u64 *efi_rt_stack_top;
 efi_status_t __efi_rt_asm_wrapper(void *, const char *, ...);
 
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index b273900f45668587..a30dbe4b95cd3a0f 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -146,7 +146,7 @@ asmlinkage efi_status_t efi_handle_corrupted_x18(efi_status_t s, const char *f)
 	return s;
 }
 
-DEFINE_SPINLOCK(efi_rt_lock);
+DEFINE_RAW_SPINLOCK(efi_rt_lock);
 
 asmlinkage u64 *efi_rt_stack_top __ro_after_init;
 
-- 
2.39.2


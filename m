Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2076B4387
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjCJOPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbjCJOO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:14:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B42E2C46
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:13:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4842961771
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF68C433A7;
        Fri, 10 Mar 2023 14:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457630;
        bh=i3ZJtE2xBZNxQFezLYZc+LxXAyj4rlWfptqIAIxNKa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYnO00kxrd49abwn4PG3T8r0LTy7ObG9R5iJ0C9VD55s+UhDJ0RwN2wuGWaX+8cIN
         /va9Y9+HL5ymQec6rS1LJMIswFzHmHzV9Lki/5M8RWmOZlo3NZVN6cqRfMKLJvxvGm
         6Ivtrnr9fMtq0b8BUnuY3MXCzts8DDKhhK7hK3aA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pierre Gondois <pierre.gondois@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 197/200] arm64: efi: Make efi_rt_lock a raw_spinlock
Date:   Fri, 10 Mar 2023 14:40:04 +0100
Message-Id: <20230310133723.132137926@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre Gondois <pierre.gondois@arm.com>

commit 0e68b5517d3767562889f1d83fdb828c26adb24f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/efi.h |    6 +++---
 arch/arm64/kernel/efi.c      |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -33,7 +33,7 @@ int efi_set_mapping_permissions(struct m
 ({									\
 	efi_virtmap_load();						\
 	__efi_fpsimd_begin();						\
-	spin_lock(&efi_rt_lock);					\
+	raw_spin_lock(&efi_rt_lock);					\
 })
 
 #undef arch_efi_call_virt
@@ -42,12 +42,12 @@ int efi_set_mapping_permissions(struct m
 
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
 
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -146,7 +146,7 @@ asmlinkage efi_status_t efi_handle_corru
 	return s;
 }
 
-DEFINE_SPINLOCK(efi_rt_lock);
+DEFINE_RAW_SPINLOCK(efi_rt_lock);
 
 asmlinkage u64 *efi_rt_stack_top __ro_after_init;
 



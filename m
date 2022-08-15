Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DBB593E1A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbiHOUg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241078AbiHOUeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:34:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7F52CC8C;
        Mon, 15 Aug 2022 12:05:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAE71612D1;
        Mon, 15 Aug 2022 19:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34437C433D6;
        Mon, 15 Aug 2022 19:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590357;
        bh=+EDy0vEuWkj5EKJIzmOQjrMOTXoHW2iAKg6PACD+8ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SoA1bX6QawQ2czaVzlSEZ/JtpJzaeKESZurqcL7Xo/ix7RzgiBjI/JtI/nyI9HRlN
         BmlEPmqi09nD8DjzrWNbmv33t0Yt7XT4qUocJ4K/+NlrOAold/iZN61BS5QO0A6zNa
         TA+RTqlwFSUSjLk5dTj3jG6dUbx4jV3Z06UHRFrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0204/1095] arm64: select TRACE_IRQFLAGS_NMI_SUPPORT
Date:   Mon, 15 Aug 2022 19:53:23 +0200
Message-Id: <20220815180438.099703461@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 3381da254fab37ba08c4b7c4f19b4ee28b1a27ec ]

Due to an oversight, on arm64 lockdep IRQ state tracking doesn't work as
intended in NMI context. This demonstrably results in bogus warnings
from lockdep, and in theory could mask a variety of issues.

On arm64, we've consistently tracked IRQ flag state for NMIs (and
saved/restored the state of the interrupted context) since commit:

  f0cd5ac1e4c53cb6 ("arm64: entry: fix NMI {user, kernel}->kernel transitions")

That commit fixed most lockdep issues with NMI by virtue of the
save/restore of the lockdep state of the interrupted context. However,
for lockdep IRQ state tracking to consistently take effect in NMI
context it has been necessary to select TRACE_IRQFLAGS_NMI_SUPPORT since
commit:

  ed00495333ccc80f ("locking/lockdep: Fix TRACE_IRQFLAGS vs. NMIs")

As arm64 does not select TRACE_IRQFLAGS_NMI_SUPPORT, this means that the
lockdep state can be stale in NMI context, and some uses of that state
can consume stale data.

When an NMI is taken arm64 entry code will call arm64_enter_nmi(). This
will enter NMI context via __nmi_enter() before calling
lockdep_hardirqs_off() to inform lockdep that IRQs have been masked.
Where TRACE_IRQFLAGS_NMI_SUPPORT is not selected, lockdep_hardirqs_off()
will not update lockdep state if called in NMI context. Thus if IRQs
were enabled in the original context, lockdep will continue to believe
that IRQs are enabled despite the call to lockdep_hardirqs_off().

However, the lockdep_assert_*() checks do take effect in NMI context,
and will consume the stale lockdep state. If an NMI is taken from a
context which had IRQs enabled, and during the handling of the NMI
something calls lockdep_assert_irqs_disabled(), this will result in a
spurious warning based upon the stale lockdep state.

This can be seen when using perf with GICv3 pseudo-NMIs. Within the perf
NMI handler we may attempt a uaccess to record the userspace callchain,
and is this faults the el1_abort() call in the nested context will call
exit_to_kernel_mode() when returning, which has a
lockdep_assert_irqs_disabled() assertion:

| # ./perf record -a -g sh
| ------------[ cut here ]------------
| WARNING: CPU: 0 PID: 164 at arch/arm64/kernel/entry-common.c:73 exit_to_kernel_mode+0x118/0x1ac
| Modules linked in:
| CPU: 0 PID: 164 Comm: perf Not tainted 5.18.0-rc5 #1
| Hardware name: linux,dummy-virt (DT)
| pstate: 004003c5 (nzcv DAIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
| pc : exit_to_kernel_mode+0x118/0x1ac
| lr : el1_abort+0x80/0xbc
| sp : ffff8000080039f0
| pmr_save: 000000f0
| x29: ffff8000080039f0 x28: ffff6831054e4980 x27: ffff683103adb400
| x26: 0000000000000000 x25: 0000000000000001 x24: 0000000000000001
| x23: 00000000804000c5 x22: 00000000000000c0 x21: 0000000000000001
| x20: ffffbd51e635ec44 x19: ffff800008003a60 x18: 0000000000000000
| x17: ffffaadf98d23000 x16: ffff800008004000 x15: 0000ffffd14f25c0
| x14: 0000000000000000 x13: 00000000000018eb x12: 0000000000000040
| x11: 000000000000001e x10: 000000002b820020 x9 : 0000000100110000
| x8 : 000000000045cac0 x7 : 0000ffffd14f25c0 x6 : ffffbd51e639b000
| x5 : 00000000000003e5 x4 : ffffbd51e58543b0 x3 : 0000000000000001
| x2 : ffffaadf98d23000 x1 : ffff6831054e4980 x0 : 0000000100110000
| Call trace:
|  exit_to_kernel_mode+0x118/0x1ac
|  el1_abort+0x80/0xbc
|  el1h_64_sync_handler+0xa4/0xd0
|  el1h_64_sync+0x74/0x78
|  __arch_copy_from_user+0xa4/0x230
|  get_perf_callchain+0x134/0x1e4
|  perf_callchain+0x7c/0xa0
|  perf_prepare_sample+0x414/0x660
|  perf_event_output_forward+0x80/0x180
|  __perf_event_overflow+0x70/0x13c
|  perf_event_overflow+0x1c/0x30
|  armv8pmu_handle_irq+0xe8/0x160
|  armpmu_dispatch_irq+0x2c/0x70
|  handle_percpu_devid_fasteoi_nmi+0x7c/0xbc
|  generic_handle_domain_nmi+0x3c/0x60
|  gic_handle_irq+0x1dc/0x310
|  call_on_irq_stack+0x2c/0x54
|  do_interrupt_handler+0x80/0x94
|  el1_interrupt+0xb0/0xe4
|  el1h_64_irq_handler+0x18/0x24
|  el1h_64_irq+0x74/0x78
|  lockdep_hardirqs_off+0x50/0x120
|  trace_hardirqs_off+0x38/0x214
|  _raw_spin_lock_irq+0x98/0xa0
|  pipe_read+0x1f8/0x404
|  new_sync_read+0x140/0x150
|  vfs_read+0x190/0x1dc
|  ksys_read+0xdc/0xfc
|  __arm64_sys_read+0x20/0x30
|  invoke_syscall+0x48/0x114
|  el0_svc_common.constprop.0+0x158/0x17c
|  do_el0_svc+0x28/0x90
|  el0_svc+0x60/0x150
|  el0t_64_sync_handler+0xa4/0x130
|  el0t_64_sync+0x19c/0x1a0
| irq event stamp: 483
| hardirqs last  enabled at (483): [<ffffbd51e636aa24>] _raw_spin_unlock_irqrestore+0xa4/0xb0
| hardirqs last disabled at (482): [<ffffbd51e636acd0>] _raw_spin_lock_irqsave+0xb0/0xb4
| softirqs last  enabled at (468): [<ffffbd51e5216f58>] put_cpu_fpsimd_context+0x28/0x70
| softirqs last disabled at (466): [<ffffbd51e5216ed4>] get_cpu_fpsimd_context+0x0/0x5c
| ---[ end trace 0000000000000000 ]---

Note that as lockdep_assert_irqs_disabled() uses WARN_ON_ONCE(), and
this uses a BRK, the warning is logged with the real PSTATE at the time
of the warning, which clearly has DAIF.I set, meaning IRQs (and
pseudo-NMIs) were definitely masked and the warning is spurious.

Fix this by selecting TRACE_IRQFLAGS_NMI_SUPPORT such that the existing
entry tracking takes effect, as we had originally intended when the
arm64 entry code was fixed for transitions to/from NMI.

Arguably the lockdep_assert_*() functions should have the same NMI
checks as the rest of the code to prevent spurious warnings when
TRACE_IRQFLAGS_NMI_SUPPORT is not selected, but the real fix for any
architecture is to explicitly handle the transitions to/from NMI in the
entry code.

Fixes: f0cd5ac1e4c5 ("arm64: entry: fix NMI {user, kernel}->kernel transitions")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20220511131733.4074499-3-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b2d5a1e8eda3..54cf6faf339c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -223,6 +223,7 @@ config ARM64
 	select THREAD_INFO_IN_TASK
 	select HAVE_ARCH_USERFAULTFD_MINOR if USERFAULTFD
 	select TRACE_IRQFLAGS_SUPPORT
+	select TRACE_IRQFLAGS_NMI_SUPPORT
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
-- 
2.35.1




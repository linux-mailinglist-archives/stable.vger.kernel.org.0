Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B90033B621
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhCON5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231311AbhCON4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0344764F00;
        Mon, 15 Mar 2021 13:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816592;
        bh=gJ8NI38LJH5VhAWNWcl+S6tfPFG/pVaqzjQX3zfTKQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzRKDKLPV2Ft+jGfy2YuVtMcdUy3I9+/OC99mVOOxUnAm/rBhQfJCTvqLpMQYGrir
         XQcxZEcFptr5Kn7NbZ9vd1xmw0347vz46qjSLk7HCAZ78g76G+TjsSZYuQwVWbM833
         /yXLWQrIR77a4Qe5YR1HrQ8Y/IF7hBYzYeu4FOis=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 002/290] powerpc/perf: Fix handling of privilege level checks in perf interrupt context
Date:   Mon, 15 Mar 2021 14:51:35 +0100
Message-Id: <20210315135542.009168951@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

commit 5ae5fbd2107959b68ac69a8b75412208663aea88 upstream.

Running "perf mem record" in powerpc platforms with selinux enabled
resulted in soft lockup's. Below call-trace was seen in the logs:

  CPU: 58 PID: 3751 Comm: sssd_nss Not tainted 5.11.0-rc7+ #2
  NIP:  c000000000dff3d4 LR: c000000000dff3d0 CTR: 0000000000000000
  REGS: c000007fffab7d60 TRAP: 0100   Not tainted  (5.11.0-rc7+)
  ...
  NIP _raw_spin_lock_irqsave+0x94/0x120
  LR  _raw_spin_lock_irqsave+0x90/0x120
  Call Trace:
    0xc00000000fd47260 (unreliable)
    skb_queue_tail+0x3c/0x90
    audit_log_end+0x6c/0x180
    common_lsm_audit+0xb0/0xe0
    slow_avc_audit+0xa4/0x110
    avc_has_perm+0x1c4/0x260
    selinux_perf_event_open+0x74/0xd0
    security_perf_event_open+0x68/0xc0
    record_and_restart+0x6e8/0x7f0
    perf_event_interrupt+0x22c/0x560
    performance_monitor_exception0x4c/0x60
    performance_monitor_common_virt+0x1c8/0x1d0
  interrupt: f00 at _raw_spin_lock_irqsave+0x38/0x120
  NIP:  c000000000dff378 LR: c000000000b5fbbc CTR: c0000000007d47f0
  REGS: c00000000fd47860 TRAP: 0f00   Not tainted  (5.11.0-rc7+)
  ...
  NIP _raw_spin_lock_irqsave+0x38/0x120
  LR  skb_queue_tail+0x3c/0x90
  interrupt: f00
    0x38 (unreliable)
    0xc00000000aae6200
    audit_log_end+0x6c/0x180
    audit_log_exit+0x344/0xf80
    __audit_syscall_exit+0x2c0/0x320
    do_syscall_trace_leave+0x148/0x200
    syscall_exit_prepare+0x324/0x390
    system_call_common+0xfc/0x27c

The above trace shows that while the CPU was handling a performance
monitor exception, there was a call to security_perf_event_open()
function. In powerpc core-book3s, this function is called from
perf_allow_kernel() check during recording of data address in the
sample via perf_get_data_addr().

Commit da97e18458fb ("perf_event: Add support for LSM and SELinux
checks") introduced security enhancements to perf. As part of this
commit, the new security hook for perf_event_open() was added in all
places where perf paranoid check was previously used. In powerpc
core-book3s code, originally had paranoid checks in
perf_get_data_addr() and power_pmu_bhrb_read(). So
perf_paranoid_kernel() checks were replaced with perf_allow_kernel()
in these PMU helper functions as well.

The intention of paranoid checks in core-book3s was to verify
privilege access before capturing some of the sample data. Along with
paranoid checks, perf_allow_kernel() also does a
security_perf_event_open(). Since these functions are accessed while
recording a sample, we end up calling selinux_perf_event_open() in PMI
context. Some of the security functions use spinlock like
sidtab_sid2str_put(). If a perf interrupt hits under a spin lock and
if we end up in calling selinux hook functions in PMI handler, this
could cause a dead lock.

Since the purpose of this security hook is to control access to
perf_event_open(), it is not right to call this in interrupt context.

The paranoid checks in powerpc core-book3s were done at interrupt time
which is also not correct.

Reference commits:
  Commit cd1231d7035f ("powerpc/perf: Prevent kernel address leak via perf_get_data_addr()")
  Commit bb19af816025 ("powerpc/perf: Prevent kernel address leak to userspace via BHRB buffer")

We only allow creation of events that have already passed the
privilege checks in perf_event_open(). So these paranoid checks are
not needed at event time. As a fix, patch uses
'event->attr.exclude_kernel' check to prevent exposing kernel address
for userspace only sampling.

Fixes: cd1231d7035f ("powerpc/perf: Prevent kernel address leak via perf_get_data_addr()")
Cc: stable@vger.kernel.org # v4.17+
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1614247839-1428-1-git-send-email-atrajeev@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/perf/core-book3s.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -211,7 +211,7 @@ static inline void perf_get_data_addr(st
 	if (!(mmcra & MMCRA_SAMPLE_ENABLE) || sdar_valid)
 		*addrp = mfspr(SPRN_SDAR);
 
-	if (is_kernel_addr(mfspr(SPRN_SDAR)) && perf_allow_kernel(&event->attr) != 0)
+	if (is_kernel_addr(mfspr(SPRN_SDAR)) && event->attr.exclude_kernel)
 		*addrp = 0;
 }
 
@@ -477,7 +477,7 @@ static void power_pmu_bhrb_read(struct p
 			 * addresses, hence include a check before filtering code
 			 */
 			if (!(ppmu->flags & PPMU_ARCH_31) &&
-				is_kernel_addr(addr) && perf_allow_kernel(&event->attr) != 0)
+			    is_kernel_addr(addr) && event->attr.exclude_kernel)
 				continue;
 
 			/* Branches are read most recent first (ie. mfbhrb 0 is



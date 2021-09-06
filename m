Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01284013EB
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240639AbhIFBcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239961AbhIFB1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:27:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA1D361165;
        Mon,  6 Sep 2021 01:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891374;
        bh=BjhENQxqVTskBNpm5ddGaa50+zZRbEYuT0YBPNjWtJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=biSU382Bvjcb+3WxDq1KwWXhDGyYsHeEURwY3F5E+jYoKhNPW/Le0HC5n3o7GukQG
         gRGkWaWtQpE94KcU+ZXCd+IVDhECLbdfAnqn2JS9nOs5ASoNwyf9pr3MTDEw3w7ok+
         XziiPbEIKt5MWN2MDS13vjHQfNb/De0V9MgV2+EQjBmlIgT0d/ihmNKNFg4S2+INVm
         HFpLKsg3KRXyOBmOs6vB1QMHC1auYVx7iL6qLbjejHV8DqaRE/RS7t35UwcWdmJufV
         udVQlE1H+tzVL1sZ7aILMSnuRzmIRn8+/DS/41wTHFFBB9O7yXHWq82+BFVU5hlinr
         xCIJuO+HMWWZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        "Signed-off-by : Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/30] rcu/tree: Handle VM stoppage in stall detection
Date:   Sun,  5 Sep 2021 21:22:21 -0400
Message-Id: <20210906012244.930338-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012244.930338-1-sashal@kernel.org>
References: <20210906012244.930338-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit ccfc9dd6914feaa9a81f10f9cce56eb0f7712264 ]

The soft watchdog timer function checks if a virtual machine
was suspended and hence what looks like a lockup in fact
is a false positive.

This is what kvm_check_and_clear_guest_paused() does: it
tests guest PVCLOCK_GUEST_STOPPED (which is set by the host)
and if it's set then we need to touch all watchdogs and bail
out.

Watchdog timer function runs from IRQ, so PVCLOCK_GUEST_STOPPED
check works fine.

There is, however, one more watchdog that runs from IRQ, so
watchdog timer fn races with it, and that watchdog is not aware
of PVCLOCK_GUEST_STOPPED - RCU stall detector.

apic_timer_interrupt()
 smp_apic_timer_interrupt()
  hrtimer_interrupt()
   __hrtimer_run_queues()
    tick_sched_timer()
     tick_sched_handle()
      update_process_times()
       rcu_sched_clock_irq()

This triggers RCU stalls on our devices during VM resume.

If tick_sched_handle()->rcu_sched_clock_irq() runs on a VCPU
before watchdog_timer_fn()->kvm_check_and_clear_guest_paused()
then there is nothing on this VCPU that touches watchdogs and
RCU reads stale gp stall timestamp and new jiffies value, which
makes it think that RCU has stalled.

Make RCU stall watchdog aware of PVCLOCK_GUEST_STOPPED and
don't report RCU stalls when we resume the VM.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_stall.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/rcu/tree_stall.h b/kernel/rcu/tree_stall.h
index c0b8c458d8a6..b8c9744ad595 100644
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -7,6 +7,8 @@
  * Author: Paul E. McKenney <paulmck@linux.ibm.com>
  */
 
+#include <linux/kvm_para.h>
+
 //////////////////////////////////////////////////////////////////////////////
 //
 // Controlling CPU stall warnings, including delay calculation.
@@ -525,6 +527,14 @@ static void check_cpu_stall(struct rcu_data *rdp)
 	    (READ_ONCE(rnp->qsmask) & rdp->grpmask) &&
 	    cmpxchg(&rcu_state.jiffies_stall, js, jn) == js) {
 
+		/*
+		 * If a virtual machine is stopped by the host it can look to
+		 * the watchdog like an RCU stall. Check to see if the host
+		 * stopped the vm.
+		 */
+		if (kvm_check_and_clear_guest_paused())
+			return;
+
 		/* We haven't checked in, so go dump stack. */
 		print_cpu_stall();
 		if (rcu_cpu_stall_ftrace_dump)
@@ -534,6 +544,14 @@ static void check_cpu_stall(struct rcu_data *rdp)
 		   ULONG_CMP_GE(j, js + RCU_STALL_RAT_DELAY) &&
 		   cmpxchg(&rcu_state.jiffies_stall, js, jn) == js) {
 
+		/*
+		 * If a virtual machine is stopped by the host it can look to
+		 * the watchdog like an RCU stall. Check to see if the host
+		 * stopped the vm.
+		 */
+		if (kvm_check_and_clear_guest_paused())
+			return;
+
 		/* They had a few time units to dump stack, so complain. */
 		print_other_cpu_stall(gs2);
 		if (rcu_cpu_stall_ftrace_dump)
-- 
2.30.2


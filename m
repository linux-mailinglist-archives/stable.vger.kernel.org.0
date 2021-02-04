Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EED30C02E
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhBBNvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:51:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232860AbhBBNtC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:49:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 878E164F99;
        Tue,  2 Feb 2021 13:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273333;
        bh=UB8p8Pd2jHsx/oIU78zVjDfoX7MsfXZNYptC8w++9XI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VgglyEAZW7eiRYqltIplvFd+v+nmpyd7b0/X/FMuXPHP43I4hWZm477EimcaAXYSV
         DCaEQOqAGkmdV82RwNaV+RV3DXNidEid/FIdtcG2FLWliUZegJ8czVTJIOLfS97Un8
         4nWDZup45sFb0jiU8vX26LVhw0ZjmV2v510GNlyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rouven Czerwinski <r.czerwinski@pengutronix.de>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 5.10 067/142] tee: optee: replace might_sleep with cond_resched
Date:   Tue,  2 Feb 2021 14:37:10 +0100
Message-Id: <20210202133000.488857996@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rouven Czerwinski <r.czerwinski@pengutronix.de>

commit dcb3b06d9c34f33a249f65c08805461fb0c4325b upstream.

might_sleep() is a debugging aid and triggers rescheduling only for
certain kernel configurations. Replace with an explicit check and
reschedule to work for all kernel configurations. Fixes the following
trace:

  [  572.945146] rcu: INFO: rcu_sched self-detected stall on CPU
  [  572.949275] rcu:     0-....: (2099 ticks this GP) idle=572/1/0x40000002 softirq=7412/7412 fqs=974
  [  572.957964]  (t=2100 jiffies g=10393 q=21)
  [  572.962054] NMI backtrace for cpu 0
  [  572.965540] CPU: 0 PID: 165 Comm: xtest Not tainted 5.8.7 #1
  [  572.971188] Hardware name: STM32 (Device Tree Support)
  [  572.976354] [<c011163c>] (unwind_backtrace) from [<c010b7f8>] (show_stack+0x10/0x14)
  [  572.984080] [<c010b7f8>] (show_stack) from [<c0511e4c>] (dump_stack+0xc4/0xd8)
  [  572.991300] [<c0511e4c>] (dump_stack) from [<c0519abc>] (nmi_cpu_backtrace+0x90/0xc4)
  [  572.999130] [<c0519abc>] (nmi_cpu_backtrace) from [<c0519bdc>] (nmi_trigger_cpumask_backtrace+0xec/0x130)
  [  573.008706] [<c0519bdc>] (nmi_trigger_cpumask_backtrace) from [<c01a5184>] (rcu_dump_cpu_stacks+0xe8/0x110)
  [  573.018453] [<c01a5184>] (rcu_dump_cpu_stacks) from [<c01a4234>] (rcu_sched_clock_irq+0x7fc/0xa88)
  [  573.027416] [<c01a4234>] (rcu_sched_clock_irq) from [<c01acdd0>] (update_process_times+0x30/0x8c)
  [  573.036291] [<c01acdd0>] (update_process_times) from [<c01bfb90>] (tick_sched_timer+0x4c/0xa8)
  [  573.044905] [<c01bfb90>] (tick_sched_timer) from [<c01adcc8>] (__hrtimer_run_queues+0x174/0x358)
  [  573.053696] [<c01adcc8>] (__hrtimer_run_queues) from [<c01aea2c>] (hrtimer_interrupt+0x118/0x2bc)
  [  573.062573] [<c01aea2c>] (hrtimer_interrupt) from [<c09ad664>] (arch_timer_handler_virt+0x28/0x30)
  [  573.071536] [<c09ad664>] (arch_timer_handler_virt) from [<c0190f50>] (handle_percpu_devid_irq+0x8c/0x240)
  [  573.081109] [<c0190f50>] (handle_percpu_devid_irq) from [<c018ab8c>] (generic_handle_irq+0x34/0x44)
  [  573.090156] [<c018ab8c>] (generic_handle_irq) from [<c018b194>] (__handle_domain_irq+0x5c/0xb0)
  [  573.098857] [<c018b194>] (__handle_domain_irq) from [<c052ac50>] (gic_handle_irq+0x4c/0x90)
  [  573.107209] [<c052ac50>] (gic_handle_irq) from [<c0100b0c>] (__irq_svc+0x6c/0x90)
  [  573.114682] Exception stack(0xd90dfcf8 to 0xd90dfd40)
  [  573.119732] fce0:                                                       ffff0004 00000000
  [  573.127917] fd00: 00000000 00000000 00000000 00000000 00000000 00000000 d93493cc ffff0000
  [  573.136098] fd20: d2bc39c0 be926998 d90dfd58 d90dfd48 c09f3384 c01151f0 400d0013 ffffffff
  [  573.144281] [<c0100b0c>] (__irq_svc) from [<c01151f0>] (__arm_smccc_smc+0x10/0x20)
  [  573.151854] [<c01151f0>] (__arm_smccc_smc) from [<c09f3384>] (optee_smccc_smc+0x3c/0x44)
  [  573.159948] [<c09f3384>] (optee_smccc_smc) from [<c09f4170>] (optee_do_call_with_arg+0xb8/0x154)
  [  573.168735] [<c09f4170>] (optee_do_call_with_arg) from [<c09f4638>] (optee_invoke_func+0x110/0x190)
  [  573.177786] [<c09f4638>] (optee_invoke_func) from [<c09f1ebc>] (tee_ioctl+0x10b8/0x11c0)
  [  573.185879] [<c09f1ebc>] (tee_ioctl) from [<c029f62c>] (ksys_ioctl+0xe0/0xa4c)
  [  573.193101] [<c029f62c>] (ksys_ioctl) from [<c0100060>] (ret_fast_syscall+0x0/0x54)
  [  573.200750] Exception stack(0xd90dffa8 to 0xd90dfff0)
  [  573.205803] ffa0:                   be926bf4 be926a78 00000003 8010a403 be926908 004e3cf8
  [  573.213987] ffc0: be926bf4 be926a78 00000000 00000036 be926908 be926918 be9269b0 bffdf0f8
  [  573.222162] ffe0: b6d76fb0 be9268fc b6d66621 b6c7e0d8

seen on STM32 DK2 with CONFIG_PREEMPT_NONE.

Fixes: 9f02b8f61f29 ("tee: optee: add might_sleep for RPC requests")
Signed-off-by: Rouven Czerwinski <r.czerwinski@pengutronix.de>
Tested-by: Sumit Garg <sumit.garg@linaro.org>
[jw: added fixes tag + small adjustments in the code]
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tee/optee/call.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tee/optee/call.c
+++ b/drivers/tee/optee/call.c
@@ -7,6 +7,7 @@
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/tee_drv.h>
 #include <linux/types.h>
@@ -148,7 +149,8 @@ u32 optee_do_call_with_arg(struct tee_co
 			 */
 			optee_cq_wait_for_completion(&optee->call_queue, &w);
 		} else if (OPTEE_SMC_RETURN_IS_RPC(res.a0)) {
-			might_sleep();
+			if (need_resched())
+				cond_resched();
 			param.a0 = res.a0;
 			param.a1 = res.a1;
 			param.a2 = res.a2;



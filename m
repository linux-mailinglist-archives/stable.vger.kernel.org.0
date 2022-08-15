Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0675D593B09
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241693AbiHOUOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347119AbiHOUNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:13:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C2E8C037;
        Mon, 15 Aug 2022 11:59:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90D31B8109E;
        Mon, 15 Aug 2022 18:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF6CC433D7;
        Mon, 15 Aug 2022 18:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589941;
        bh=CGaPG4NbzAJR1W5yUiOR1a8R5WwVoE9UDU1lzpnZMCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQP0x2NJjAjdMUhg99JiE6QCSV9muF4c5KJvZFsgwHcqPmPtTL3vywqCZxo1HHTBo
         u/nWWocMQpxFul3xmNWhbiquheX6H8kMGtbbWJm9I7e74Lo27IVFh+1EBHj53r5LBp
         fifWkzfWpMAsDRExRm69Uc8qTslZusbipIbvzBJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.18 0068/1095] RISC-V: Fixup schedule out issue in machine_crash_shutdown()
Date:   Mon, 15 Aug 2022 19:51:07 +0200
Message-Id: <20220815180432.329986550@linuxfoundation.org>
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

From: Xianting Tian <xianting.tian@linux.alibaba.com>

commit ad943893d5f1d0aeea892bf7b781cf8062b36d58 upstream.

Current task of executing crash kexec will be schedule out when panic is
triggered by RCU Stall, as it needs to wait rcu completion. It lead to
inability to enter the crash system.

The implementation of machine_crash_shutdown() is non-standard for RISC-V
according to other Arch's implementation(eg, x86, arm64), we need to send
IPI to stop secondary harts.

[224521.877268] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[224521.883471] rcu: 	0-...0: (3 GPs behind) idle=cfa/0/0x1 softirq=3968793/3968793 fqs=2495
[224521.891742] 	(detected by 2, t=5255 jiffies, g=60855593, q=328)
[224521.897754] Task dump for CPU 0:
[224521.901074] task:swapper/0     state:R  running task   stack:  0 pid:  0 ppid:   0 flags:0x00000008
[224521.911090] Call Trace:
[224521.913638] [<ffffffe000c432de>] __schedule+0x208/0x5ea
[224521.918957] Kernel panic - not syncing: RCU Stall
[224521.923773] bad: scheduling from the idle thread!
[224521.928571] CPU: 2 PID: 0 Comm: swapper/2 Kdump: loaded Tainted: G   O  5.10.113-yocto-standard #1
[224521.938658] Call Trace:
[224521.941200] [<ffffffe00020395c>] walk_stackframe+0x0/0xaa
[224521.946689] [<ffffffe000c34f8e>] show_stack+0x32/0x3e
[224521.951830] [<ffffffe000c39020>] dump_stack_lvl+0x7e/0xa2
[224521.957317] [<ffffffe000c39058>] dump_stack+0x14/0x1c
[224521.962459] [<ffffffe000243884>] dequeue_task_idle+0x2c/0x40
[224521.968207] [<ffffffe000c434f4>] __schedule+0x41e/0x5ea
[224521.973520] [<ffffffe000c43826>] schedule+0x34/0xe4
[224521.978487] [<ffffffe000c46cae>] schedule_timeout+0xc6/0x170
[224521.984234] [<ffffffe000c4491e>] wait_for_completion+0x98/0xf2
[224521.990157] [<ffffffe00026d9e2>] __wait_rcu_gp+0x148/0x14a
[224521.995733] [<ffffffe0002761c4>] synchronize_rcu+0x5c/0x66
[224522.001307] [<ffffffe00026f1a6>] rcu_sync_enter+0x54/0xe6
[224522.006795] [<ffffffe00025a436>] percpu_down_write+0x32/0x11c
[224522.012629] [<ffffffe000c4266a>] _cpu_down+0x92/0x21a
[224522.017771] [<ffffffe000219a0a>] smp_shutdown_nonboot_cpus+0x90/0x118
[224522.024299] [<ffffffe00020701e>] machine_crash_shutdown+0x30/0x4a
[224522.030483] [<ffffffe00029a3f8>] __crash_kexec+0x62/0xa6
[224522.035884] [<ffffffe000c3515e>] panic+0xfa/0x2b6
[224522.040678] [<ffffffe0002772be>] rcu_sched_clock_irq+0xc26/0xcb8
[224522.046774] [<ffffffe00027fc7a>] update_process_times+0x62/0x8a
[224522.052785] [<ffffffe00028d522>] tick_sched_timer+0x9e/0x102
[224522.058533] [<ffffffe000280c3a>] __hrtimer_run_queues+0x16a/0x318
[224522.064716] [<ffffffe0002812ec>] hrtimer_interrupt+0xd4/0x228
[224522.070551] [<ffffffe0009a69b6>] riscv_timer_interrupt+0x3c/0x48
[224522.076646] [<ffffffe000268f8c>] handle_percpu_devid_irq+0xb0/0x24c
[224522.083004] [<ffffffe00026428e>] __handle_domain_irq+0xa8/0x122
[224522.089014] [<ffffffe00062f954>] riscv_intc_irq+0x38/0x60
[224522.094501] [<ffffffe000201bd4>] ret_from_exception+0x0/0xc
[224522.100161] [<ffffffe000c42146>] rcu_eqs_enter.constprop.0+0x8c/0xb8

With the patch, it can enter crash system when RCU Stall occur.

Fixes: e53d28180d4d ("RISC-V: Add kdump support")
Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Link: https://lore.kernel.org/r/20220811074150.3020189-4-xianting.tian@linux.alibaba.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/machine_kexec.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/arch/riscv/kernel/machine_kexec.c
+++ b/arch/riscv/kernel/machine_kexec.c
@@ -138,19 +138,37 @@ void machine_shutdown(void)
 #endif
 }
 
+/* Override the weak function in kernel/panic.c */
+void crash_smp_send_stop(void)
+{
+	static int cpus_stopped;
+
+	/*
+	 * This function can be called twice in panic path, but obviously
+	 * we execute this only once.
+	 */
+	if (cpus_stopped)
+		return;
+
+	smp_send_stop();
+	cpus_stopped = 1;
+}
+
 /*
  * machine_crash_shutdown - Prepare to kexec after a kernel crash
  *
  * This function is called by crash_kexec just before machine_kexec
- * below and its goal is similar to machine_shutdown, but in case of
- * a kernel crash. Since we don't handle such cases yet, this function
- * is empty.
+ * and its goal is to shutdown non-crashing cpus and save registers.
  */
 void
 machine_crash_shutdown(struct pt_regs *regs)
 {
+	local_irq_disable();
+
+	/* shutdown non-crashing cpus */
+	crash_smp_send_stop();
+
 	crash_save_cpu(regs, smp_processor_id());
-	machine_shutdown();
 	pr_info("Starting crashdump kernel...\n");
 }
 



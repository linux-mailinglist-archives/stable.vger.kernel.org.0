Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3BF190EC7
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgCXNOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:14:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbgCXNOq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:14:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18A74206F6;
        Tue, 24 Mar 2020 13:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055685;
        bh=Ogz/HH6VzWRG/oXVx9FHgc6VF02HRLS2e5Z5irOhkYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+Jjqs34/St3ML+QJqsOa2T9c4lgnZ0S8JlNCTkuRnYch9QZzcB9mOju8QO/8KZSn
         l787yamBJGdc/UgiD+Xa8umOFwSLbt9ZjN8TgMFGqrpVHHy6d9R7jliI+74RFXFZwj
         5nZZacE4T9d1NbrXmeY15z+Xg1PH/BBQN+OLkNUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.19 62/65] arm64: smp: fix crash_smp_send_stop() behaviour
Date:   Tue, 24 Mar 2020 14:11:23 +0100
Message-Id: <20200324130804.658812014@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130756.679112147@linuxfoundation.org>
References: <20200324130756.679112147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

commit f50b7dacccbab2b9e3ef18f52a6dcc18ed2050b9 upstream.

On a system configured to trigger a crash_kexec() reboot, when only one CPU
is online and another CPU panics while starting-up, crash_smp_send_stop()
will fail to send any STOP message to the other already online core,
resulting in fail to freeze and registers not properly saved.

Moreover even if the proper messages are sent (case CPUs > 2)
it will similarly fail to account for the booting CPU when executing
the final stop wait-loop, so potentially resulting in some CPU not
been waited for shutdown before rebooting.

A tangible effect of this behaviour can be observed when, after a panic
with kexec enabled and loaded, on the following reboot triggered by kexec,
the cpu that could not be successfully stopped fails to come back online:

[  362.291022] ------------[ cut here ]------------
[  362.291525] kernel BUG at arch/arm64/kernel/cpufeature.c:886!
[  362.292023] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[  362.292400] Modules linked in:
[  362.292970] CPU: 3 PID: 0 Comm: swapper/3 Kdump: loaded Not tainted 5.6.0-rc4-00003-gc780b890948a #105
[  362.293136] Hardware name: Foundation-v8A (DT)
[  362.293382] pstate: 200001c5 (nzCv dAIF -PAN -UAO)
[  362.294063] pc : has_cpuid_feature+0xf0/0x348
[  362.294177] lr : verify_local_elf_hwcaps+0x84/0xe8
[  362.294280] sp : ffff800011b1bf60
[  362.294362] x29: ffff800011b1bf60 x28: 0000000000000000
[  362.294534] x27: 0000000000000000 x26: 0000000000000000
[  362.294631] x25: 0000000000000000 x24: ffff80001189a25c
[  362.294718] x23: 0000000000000000 x22: 0000000000000000
[  362.294803] x21: ffff8000114aa018 x20: ffff800011156a00
[  362.294897] x19: ffff800010c944a0 x18: 0000000000000004
[  362.294987] x17: 0000000000000000 x16: 0000000000000000
[  362.295073] x15: 00004e53b831ae3c x14: 00004e53b831ae3c
[  362.295165] x13: 0000000000000384 x12: 0000000000000000
[  362.295251] x11: 0000000000000000 x10: 00400032b5503510
[  362.295334] x9 : 0000000000000000 x8 : ffff800010c7e204
[  362.295426] x7 : 00000000410fd0f0 x6 : 0000000000000001
[  362.295508] x5 : 00000000410fd0f0 x4 : 0000000000000000
[  362.295592] x3 : 0000000000000000 x2 : ffff8000100939d8
[  362.295683] x1 : 0000000000180420 x0 : 0000000000180480
[  362.296011] Call trace:
[  362.296257]  has_cpuid_feature+0xf0/0x348
[  362.296350]  verify_local_elf_hwcaps+0x84/0xe8
[  362.296424]  check_local_cpu_capabilities+0x44/0x128
[  362.296497]  secondary_start_kernel+0xf4/0x188
[  362.296998] Code: 52805001 72a00301 6b01001f 54000ec0 (d4210000)
[  362.298652] SMP: stopping secondary CPUs
[  362.300615] Starting crashdump kernel...
[  362.301168] Bye!
[    0.000000] Booting Linux on physical CPU 0x0000000003 [0x410fd0f0]
[    0.000000] Linux version 5.6.0-rc4-00003-gc780b890948a (crimar01@e120937-lin) (gcc version 8.3.0 (GNU Toolchain for the A-profile Architecture 8.3-2019.03 (arm-rel-8.36))) #105 SMP PREEMPT Fri Mar 6 17:00:42 GMT 2020
[    0.000000] Machine model: Foundation-v8A
[    0.000000] earlycon: pl11 at MMIO 0x000000001c090000 (options '')
[    0.000000] printk: bootconsole [pl11] enabled
.....
[    0.138024] rcu: Hierarchical SRCU implementation.
[    0.153472] its@2f020000: unable to locate ITS domain
[    0.154078] its@2f020000: Unable to locate ITS domain
[    0.157541] EFI services will not be available.
[    0.175395] smp: Bringing up secondary CPUs ...
[    0.209182] psci: failed to boot CPU1 (-22)
[    0.209377] CPU1: failed to boot: -22
[    0.274598] Detected PIPT I-cache on CPU2
[    0.278707] GICv3: CPU2: found redistributor 1 region 0:0x000000002f120000
[    0.285212] CPU2: Booted secondary processor 0x0000000001 [0x410fd0f0]
[    0.369053] Detected PIPT I-cache on CPU3
[    0.372947] GICv3: CPU3: found redistributor 2 region 0:0x000000002f140000
[    0.378664] CPU3: Booted secondary processor 0x0000000002 [0x410fd0f0]
[    0.401707] smp: Brought up 1 node, 3 CPUs
[    0.404057] SMP: Total of 3 processors activated.

Make crash_smp_send_stop() account also for the online status of the
calling CPU while evaluating how many CPUs are effectively online: this way
the right number of STOPs is sent and all other stopped-cores's registers
are properly saved.

Fixes: 78fd584cdec05 ("arm64: kdump: implement machine_crash_shutdown()")
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/smp.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -990,7 +990,11 @@ void crash_smp_send_stop(void)
 
 	cpus_stopped = 1;
 
-	if (num_online_cpus() == 1) {
+	/*
+	 * If this cpu is the only one alive at this point in time, online or
+	 * not, there are no stop messages to be sent around, so just back out.
+	 */
+	if (num_other_online_cpus() == 0) {
 		sdei_mask_local_cpu();
 		return;
 	}
@@ -998,7 +1002,7 @@ void crash_smp_send_stop(void)
 	cpumask_copy(&mask, cpu_online_mask);
 	cpumask_clear_cpu(smp_processor_id(), &mask);
 
-	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
+	atomic_set(&waiting_for_crash_ipi, num_other_online_cpus());
 
 	pr_crit("SMP: stopping secondary CPUs\n");
 	smp_cross_call(&mask, IPI_CPU_CRASH_STOP);



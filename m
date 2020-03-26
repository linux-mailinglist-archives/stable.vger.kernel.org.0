Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53FF0194C47
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgCZXYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:24:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727795AbgCZXYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:24:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD68A20714;
        Thu, 26 Mar 2020 23:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265055;
        bh=2g440nsANWvzC0hYRRM8vtVFNYP8ppWJJyUDWN97GtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Km/6gcAxPl8N9nJFrLmS/MYcDqIOiCkqIGrQz1kvX5rsWSujAeLfdts3U5x2EoZ3z
         rFjyTy78KITgec1VkvHvJQcF2poAXuOB0zfcav4VSgAwYT/4NwP8w8lzSpbHZ3HR//
         01HMBud4yl3zjVdO070jv4auaYPmH7Mz9HbMcJpE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 15/28] arm64: smp: fix crash_smp_send_stop() behaviour
Date:   Thu, 26 Mar 2020 19:23:44 -0400
Message-Id: <20200326232357.7516-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232357.7516-1-sashal@kernel.org>
References: <20200326232357.7516-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit f50b7dacccbab2b9e3ef18f52a6dcc18ed2050b9 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/smp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index e4dc241c5a8e8..5407bf5d98ac5 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -1012,7 +1012,11 @@ void crash_smp_send_stop(void)
 
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
@@ -1020,7 +1024,7 @@ void crash_smp_send_stop(void)
 	cpumask_copy(&mask, cpu_online_mask);
 	cpumask_clear_cpu(smp_processor_id(), &mask);
 
-	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
+	atomic_set(&waiting_for_crash_ipi, num_other_online_cpus());
 
 	pr_crit("SMP: stopping secondary CPUs\n");
 	smp_cross_call(&mask, IPI_CPU_CRASH_STOP);
-- 
2.20.1


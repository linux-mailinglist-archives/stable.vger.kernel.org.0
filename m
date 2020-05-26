Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B5519B23D
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389504AbgDAQmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389517AbgDAQmP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:42:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6987C2063A;
        Wed,  1 Apr 2020 16:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759334;
        bh=NvPND6h33aBGzALL5ZuRrLmNfgiv4m21T9r++dzQrVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1S31t+hELkMrsgaa7d3bnkd82uEUlIYU/60iLadUXlDVfWoHTP+aC8KMB1p+qfhGg
         qB+BmOiFffjdJjFYo9bFnMPXDnf38uhi4uEuNEB9hvXyD2UEMwnzz0izCiKm+6BRNF
         X4BgyHIGnD3yWVbCOUV4ha8odqNCm3HRneViRcRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Martin <Dave.Martin@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.14 050/148] arm64: smp: fix smp_send_stop() behaviour
Date:   Wed,  1 Apr 2020 18:17:22 +0200
Message-Id: <20200401161557.818728858@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

commit d0bab0c39e32d39a8c5cddca72e5b4a3059fe050 upstream.

On a system with only one CPU online, when another one CPU panics while
starting-up, smp_send_stop() will fail to send any STOP message to the
other already online core, resulting in a system still responsive and
alive at the end of the panic procedure.

[  186.700083] CPU3: shutdown
[  187.075462] CPU2: shutdown
[  187.162869] CPU1: shutdown
[  188.689998] ------------[ cut here ]------------
[  188.691645] kernel BUG at arch/arm64/kernel/cpufeature.c:886!
[  188.692079] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[  188.692444] Modules linked in:
[  188.693031] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.6.0-rc4-00001-g338d25c35a98 #104
[  188.693175] Hardware name: Foundation-v8A (DT)
[  188.693492] pstate: 200001c5 (nzCv dAIF -PAN -UAO)
[  188.694183] pc : has_cpuid_feature+0xf0/0x348
[  188.694311] lr : verify_local_elf_hwcaps+0x84/0xe8
[  188.694410] sp : ffff800011b1bf60
[  188.694536] x29: ffff800011b1bf60 x28: 0000000000000000
[  188.694707] x27: 0000000000000000 x26: 0000000000000000
[  188.694801] x25: 0000000000000000 x24: ffff80001189a25c
[  188.694905] x23: 0000000000000000 x22: 0000000000000000
[  188.694996] x21: ffff8000114aa018 x20: ffff800011156a38
[  188.695089] x19: ffff800010c944a0 x18: 0000000000000004
[  188.695187] x17: 0000000000000000 x16: 0000000000000000
[  188.695280] x15: 0000249dbde5431e x14: 0262cbe497efa1fa
[  188.695371] x13: 0000000000000002 x12: 0000000000002592
[  188.695472] x11: 0000000000000080 x10: 00400032b5503510
[  188.695572] x9 : 0000000000000000 x8 : ffff800010c80204
[  188.695659] x7 : 00000000410fd0f0 x6 : 0000000000000001
[  188.695750] x5 : 00000000410fd0f0 x4 : 0000000000000000
[  188.695836] x3 : 0000000000000000 x2 : ffff8000100939d8
[  188.695919] x1 : 0000000000180420 x0 : 0000000000180480
[  188.696253] Call trace:
[  188.696410]  has_cpuid_feature+0xf0/0x348
[  188.696504]  verify_local_elf_hwcaps+0x84/0xe8
[  188.696591]  check_local_cpu_capabilities+0x44/0x128
[  188.696666]  secondary_start_kernel+0xf4/0x188
[  188.697150] Code: 52805001 72a00301 6b01001f 54000ec0 (d4210000)
[  188.698639] ---[ end trace 3f12ca47652f7b72 ]---
[  188.699160] Kernel panic - not syncing: Attempted to kill the idle task!
[  188.699546] Kernel Offset: disabled
[  188.699828] CPU features: 0x00004,20c02008
[  188.700012] Memory Limit: none
[  188.700538] ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---

[root@arch ~]# echo Helo
Helo
[root@arch ~]# cat /proc/cpuinfo | grep proce
processor	: 0

Make smp_send_stop() account also for the online status of the calling CPU
while evaluating how many CPUs are effectively online: this way, the right
number of STOPs is sent, so enforcing a proper freeze of the system at the
end of panic even under the above conditions.

Fixes: 08e875c16a16c ("arm64: SMP support")
Reported-by: Dave Martin <Dave.Martin@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/smp.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -913,11 +913,22 @@ void tick_broadcast(const struct cpumask
 }
 #endif
 
+/*
+ * The number of CPUs online, not counting this CPU (which may not be
+ * fully online and so not counted in num_online_cpus()).
+ */
+static inline unsigned int num_other_online_cpus(void)
+{
+	unsigned int this_cpu_online = cpu_online(smp_processor_id());
+
+	return num_online_cpus() - this_cpu_online;
+}
+
 void smp_send_stop(void)
 {
 	unsigned long timeout;
 
-	if (num_online_cpus() > 1) {
+	if (num_other_online_cpus()) {
 		cpumask_t mask;
 
 		cpumask_copy(&mask, cpu_online_mask);
@@ -930,10 +941,10 @@ void smp_send_stop(void)
 
 	/* Wait up to one second for other CPUs to stop */
 	timeout = USEC_PER_SEC;
-	while (num_online_cpus() > 1 && timeout--)
+	while (num_other_online_cpus() && timeout--)
 		udelay(1);
 
-	if (num_online_cpus() > 1)
+	if (num_other_online_cpus())
 		pr_warning("SMP: failed to stop secondary CPUs %*pbl\n",
 			   cpumask_pr_args(cpu_online_mask));
 }



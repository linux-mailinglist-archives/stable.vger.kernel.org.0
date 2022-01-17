Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219A0490DE3
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbiAQRGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:06:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54334 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242438AbiAQREY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:04:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E16C611F1;
        Mon, 17 Jan 2022 17:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D3BC36AE3;
        Mon, 17 Jan 2022 17:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439063;
        bh=0w4R2NHgExzeD9t+H0AsT8Etmds2t5Ti0YZB3Jt+H/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5atj+A7johXYPROMg2HyB5QXv7Kw/5ZWYRarNDwXRB5wQm6a6Jfm3tYAxvuCCQWF
         FeDOKKufDC279Bd8AHywTgY82cTphHZ/YUjR+I/pJimNaZwKB7rA1PoGLvU0LHir3m
         winnMXPw6bc0/uyn4OX3gy2TZcoWku1PxvmgwmDYvNRU+oM/G64gfEPabOLyw5NUXT
         thU30LLgNdodgLAtej57LBb9tiWqo2uylOhpopnxAIV4c9Qd10xBVxIJT7nF5ehxUT
         qqTwbab00nMO8iFKCEA5uzUKE9BDd5ad7lcvgCdBQUDmDsce0jxkYqvfRbQ77HIn+w
         8ptEFD64Gobmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hari Bathini <hbathini@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, sxwjean@gmail.com,
        sfr@canb.auug.org.au, nathan@kernel.org, nick.child@ibm.com,
        aneesh.kumar@linux.ibm.com, srikar@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, nathanl@linux.ibm.com, parth@linux.ibm.com,
        clg@kaod.org, npiggin@gmail.com, robh@kernel.org,
        yukuai3@huawei.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 24/34] powerpc/fadump: Fix inaccurate CPU state info in vmcore generated with panic
Date:   Mon, 17 Jan 2022 12:03:14 -0500
Message-Id: <20220117170326.1471712-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170326.1471712-1-sashal@kernel.org>
References: <20220117170326.1471712-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hari Bathini <hbathini@linux.ibm.com>

[ Upstream commit 06e629c25daa519be620a8c17359ae8fc7a2e903 ]

In panic path, fadump is triggered via a panic notifier function.
Before calling panic notifier functions, smp_send_stop() gets called,
which stops all CPUs except the panic'ing CPU. Commit 8389b37dffdc
("powerpc: stop_this_cpu: remove the cpu from the online map.") and
again commit bab26238bbd4 ("powerpc: Offline CPU in stop_this_cpu()")
started marking CPUs as offline while stopping them. So, if a kernel
has either of the above commits, vmcore captured with fadump via panic
path would not process register data for all CPUs except the panic'ing
CPU. Sample output of crash-utility with such vmcore:

  # crash vmlinux vmcore
  ...
        KERNEL: vmlinux
      DUMPFILE: vmcore  [PARTIAL DUMP]
          CPUS: 1
          DATE: Wed Nov 10 09:56:34 EST 2021
        UPTIME: 00:00:42
  LOAD AVERAGE: 2.27, 0.69, 0.24
         TASKS: 183
      NODENAME: XXXXXXXXX
       RELEASE: 5.15.0+
       VERSION: #974 SMP Wed Nov 10 04:18:19 CST 2021
       MACHINE: ppc64le  (2500 Mhz)
        MEMORY: 8 GB
         PANIC: "Kernel panic - not syncing: sysrq triggered crash"
           PID: 3394
       COMMAND: "bash"
          TASK: c0000000150a5f80  [THREAD_INFO: c0000000150a5f80]
           CPU: 1
         STATE: TASK_RUNNING (PANIC)

  crash> p -x __cpu_online_mask
  __cpu_online_mask = $1 = {
    bits = {0x2, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}
  }
  crash>
  crash>
  crash> p -x __cpu_active_mask
  __cpu_active_mask = $2 = {
    bits = {0xff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}
  }
  crash>

While this has been the case since fadump was introduced, the issue
was not identified for two probable reasons:

  - In general, the bulk of the vmcores analyzed were from crash
    due to exception.

  - The above did change since commit 8341f2f222d7 ("sysrq: Use
    panic() to force a crash") started using panic() instead of
    deferencing NULL pointer to force a kernel crash. But then
    commit de6e5d38417e ("powerpc: smp_send_stop do not offline
    stopped CPUs") stopped marking CPUs as offline till kernel
    commit bab26238bbd4 ("powerpc: Offline CPU in stop_this_cpu()")
    reverted that change.

To ensure post processing register data of all other CPUs happens
as intended, let panic() function take the crash friendly path (read
crash_smp_send_stop()) with the help of crash_kexec_post_notifiers
option. Also, as register data for all CPUs is captured by f/w, skip
IPI callbacks here for fadump, to avoid any complications in finding
the right backtraces.

Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211207103719.91117-2-hbathini@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/fadump.c |  8 ++++++++
 arch/powerpc/kernel/smp.c    | 10 ++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index eddf362caedce..c3bb800dc4352 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -1641,6 +1641,14 @@ int __init setup_fadump(void)
 	else if (fw_dump.reserve_dump_area_size)
 		fw_dump.ops->fadump_init_mem_struct(&fw_dump);
 
+	/*
+	 * In case of panic, fadump is triggered via ppc_panic_event()
+	 * panic notifier. Setting crash_kexec_post_notifiers to 'true'
+	 * lets panic() function take crash friendly path before panic
+	 * notifiers are invoked.
+	 */
+	crash_kexec_post_notifiers = true;
+
 	return 1;
 }
 subsys_initcall(setup_fadump);
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index d993f28107afa..cf99f57aed822 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -60,6 +60,7 @@
 #include <asm/cpu_has_feature.h>
 #include <asm/ftrace.h>
 #include <asm/kup.h>
+#include <asm/fadump.h>
 
 #ifdef DEBUG
 #include <asm/udbg.h>
@@ -612,6 +613,15 @@ void crash_smp_send_stop(void)
 {
 	static bool stopped = false;
 
+	/*
+	 * In case of fadump, register data for all CPUs is captured by f/w
+	 * on ibm,os-term rtas call. Skip IPI callbacks to other CPUs before
+	 * this rtas call to avoid tricky post processing of those CPUs'
+	 * backtraces.
+	 */
+	if (should_fadump_crash())
+		return;
+
 	if (stopped)
 		return;
 
-- 
2.34.1


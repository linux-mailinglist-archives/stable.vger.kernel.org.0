Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438B04999E7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378011AbiAXVil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:38:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45920 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454201AbiAXVcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:32:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C1A7B8122A;
        Mon, 24 Jan 2022 21:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A0AC340E4;
        Mon, 24 Jan 2022 21:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059918;
        bh=IoB7Upsgx+3TaNkP2jKC4svaYwVImu5WjHntAS3c59E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XiYXDiGG/UZId/p9wcBtRK2+wi2bI3Iv/sSMwrFlru9TOQakXB5oPjJuJxFA3Op10
         eyTEAvzPVPQl9HJKU/gQX/GyC3aTsmWUaotoWb6McSMpkAY0Ohy+NJ/+CxF2JGjgcr
         cMr/m8NRk+C9CPxnlvxMYtuaX9z/tD1xHuLu/q6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hari Bathini <hbathini@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0761/1039] powerpc/fadump: Fix inaccurate CPU state info in vmcore generated with panic
Date:   Mon, 24 Jan 2022 19:42:30 +0100
Message-Id: <20220124184150.901970198@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b7ceb041743c9..60f5fc14aa235 100644
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
index 7201fdcf02f1c..c338f9d8ab37a 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -61,6 +61,7 @@
 #include <asm/cpu_has_feature.h>
 #include <asm/ftrace.h>
 #include <asm/kup.h>
+#include <asm/fadump.h>
 
 #ifdef DEBUG
 #include <asm/udbg.h>
@@ -638,6 +639,15 @@ void crash_smp_send_stop(void)
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




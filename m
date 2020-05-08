Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACB51CAAD8
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgEHMhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728083AbgEHMhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65248207DD;
        Fri,  8 May 2020 12:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941440;
        bh=St1aqTSXUcoikltNALu5tsbQlVhuyMmsI6shkvrXr8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XhC3EdcjKBsTttTG3+Zb/fbA1t+ek9mpNyQZ4QKjGGqxCg+WAYbEqHym+Gr+mWPGO
         XVwWn5g1pklEGLZgCWXHRUDJNksX9D1GZXiaDlnxzIbbPfeA6B9vLm+p/1Ls1YlOfS
         l2R+w/JLuaSk2XICa03Xd5CbfnAunlN3GVhzZ6Jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Xunlei Pang <xpang@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        David Vrabel <david.vrabel@citrix.com>,
        Toshi Kani <toshi.kani@hpe.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        "Steven J. Hill" <steven.hill@cavium.com>,
        Corey Minyard <cminyard@mvista.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 033/312] mips/panic: replace smp_send_stop() with kdump friendly version in panic path
Date:   Fri,  8 May 2020 14:30:24 +0200
Message-Id: <20200508123126.809500098@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

commit 54c721b857fd45f3ad3bda695ee4f472518db02a upstream.

Daniel Walker reported problems which happens when
crash_kexec_post_notifiers kernel option is enabled
(https://lkml.org/lkml/2015/6/24/44).

In that case, smp_send_stop() is called before entering kdump routines
which assume other CPUs are still online.  As the result, kdump
routines fail to save other CPUs' registers.  Additionally for MIPS
OCTEON, it misses to stop the watchdog timer.

To fix this problem, call a new kdump friendly function,
crash_smp_send_stop(), instead of the smp_send_stop() when
crash_kexec_post_notifiers is enabled.  crash_smp_send_stop() is a
weak function, and it just call smp_send_stop().  Architecture
codes should override it so that kdump can work appropriately.
This patch provides MIPS version.

Fixes: f06e5153f4ae (kernel/panic.c: add "crash_kexec_post_notifiers" option)
Link: http://lkml.kernel.org/r/20160810080950.11028.28000.stgit@sysi4-13.yrl.intra.hitachi.co.jp
Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Reported-by: Daniel Walker <dwalker@fifo99.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Xunlei Pang <xpang@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <david.daney@cavium.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: "Steven J. Hill" <steven.hill@cavium.com>
Cc: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/cavium-octeon/setup.c  |   14 ++++++++++++++
 arch/mips/include/asm/kexec.h    |    1 +
 arch/mips/kernel/crash.c         |   18 +++++++++++++++++-
 arch/mips/kernel/machine_kexec.c |    1 +
 4 files changed, 33 insertions(+), 1 deletion(-)

--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -251,6 +251,17 @@ static void octeon_crash_shutdown(struct
 	default_machine_crash_shutdown(regs);
 }
 
+#ifdef CONFIG_SMP
+void octeon_crash_smp_send_stop(void)
+{
+	int cpu;
+
+	/* disable watchdogs */
+	for_each_online_cpu(cpu)
+		cvmx_write_csr(CVMX_CIU_WDOGX(cpu_logical_map(cpu)), 0);
+}
+#endif
+
 #endif /* CONFIG_KEXEC */
 
 #ifdef CONFIG_CAVIUM_RESERVE32
@@ -864,6 +875,9 @@ void __init prom_init(void)
 	_machine_kexec_shutdown = octeon_shutdown;
 	_machine_crash_shutdown = octeon_crash_shutdown;
 	_machine_kexec_prepare = octeon_kexec_prepare;
+#ifdef CONFIG_SMP
+	_crash_smp_send_stop = octeon_crash_smp_send_stop;
+#endif
 #endif
 
 	octeon_user_io_init();
--- a/arch/mips/include/asm/kexec.h
+++ b/arch/mips/include/asm/kexec.h
@@ -45,6 +45,7 @@ extern const unsigned char kexec_smp_wai
 extern unsigned long secondary_kexec_args[4];
 extern void (*relocated_kexec_smp_wait) (void *);
 extern atomic_t kexec_ready_to_reboot;
+extern void (*_crash_smp_send_stop)(void);
 #endif
 #endif
 
--- a/arch/mips/kernel/crash.c
+++ b/arch/mips/kernel/crash.c
@@ -50,9 +50,14 @@ static void crash_shutdown_secondary(voi
 
 static void crash_kexec_prepare_cpus(void)
 {
+	static int cpus_stopped;
 	unsigned int msecs;
+	unsigned int ncpus;
 
-	unsigned int ncpus = num_online_cpus() - 1;/* Excluding the panic cpu */
+	if (cpus_stopped)
+		return;
+
+	ncpus = num_online_cpus() - 1;/* Excluding the panic cpu */
 
 	dump_send_ipi(crash_shutdown_secondary);
 	smp_wmb();
@@ -67,6 +72,17 @@ static void crash_kexec_prepare_cpus(voi
 		cpu_relax();
 		mdelay(1);
 	}
+
+	cpus_stopped = 1;
+}
+
+/* Override the weak function in kernel/panic.c */
+void crash_smp_send_stop(void)
+{
+	if (_crash_smp_send_stop)
+		_crash_smp_send_stop();
+
+	crash_kexec_prepare_cpus();
 }
 
 #else /* !defined(CONFIG_SMP)  */
--- a/arch/mips/kernel/machine_kexec.c
+++ b/arch/mips/kernel/machine_kexec.c
@@ -25,6 +25,7 @@ void (*_machine_crash_shutdown)(struct p
 #ifdef CONFIG_SMP
 void (*relocated_kexec_smp_wait) (void *);
 atomic_t kexec_ready_to_reboot = ATOMIC_INIT(0);
+void (*_crash_smp_send_stop)(void) = NULL;
 #endif
 
 int



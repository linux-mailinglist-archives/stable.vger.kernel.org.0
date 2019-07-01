Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13CFF3AA0C
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732649AbfFIQyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732232AbfFIQyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:54:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 611A8204EC;
        Sun,  9 Jun 2019 16:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099278;
        bh=0oC9utiurk1gh/DxHLQFLDu2HniHQEvbowuzU4EOzWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1Dpa/nXJ5MMgW+qUPFJbBVESZE9XyXiCLa11IgHKupgAgt7E7JFsRl6J2WNngH2t
         h9UEXDXMNXtFnW7iuzeIQADtEXWuCllH3+MDQXzpMG+jV6nInmnPctCw+zyQAKlC0G
         ApTQMpWln9sZy7OXlBdj92OVlO9ntqMx700XoRIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Pavel Machek <pavel@ucw.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.9 74/83] x86/power: Fix nosmt vs hibernation triple fault during resume
Date:   Sun,  9 Jun 2019 18:42:44 +0200
Message-Id: <20190609164134.192098775@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

commit ec527c318036a65a083ef68d8ba95789d2212246 upstream.

As explained in

	0cc3cd21657b ("cpu/hotplug: Boot HT siblings at least once")

we always, no matter what, have to bring up x86 HT siblings during boot at
least once in order to avoid first MCE bringing the system to its knees.

That means that whenever 'nosmt' is supplied on the kernel command-line,
all the HT siblings are as a result sitting in mwait or cpudile after
going through the online-offline cycle at least once.

This causes a serious issue though when a kernel, which saw 'nosmt' on its
commandline, is going to perform resume from hibernation: if the resume
from the hibernated image is successful, cr3 is flipped in order to point
to the address space of the kernel that is being resumed, which in turn
means that all the HT siblings are all of a sudden mwaiting on address
which is no longer valid.

That results in triple fault shortly after cr3 is switched, and machine
reboots.

Fix this by always waking up all the SMT siblings before initiating the
'restore from hibernation' process; this guarantees that all the HT
siblings will be properly carried over to the resumed kernel waiting in
resume_play_dead(), and acted upon accordingly afterwards, based on the
target kernel configuration.

Symmetricaly, the resumed kernel has to push the SMT siblings to mwait
again in case it has SMT disabled; this means it has to online all
the siblings when resuming (so that they come out of hlt) and offline
them again to let them reach mwait.

Cc: 4.19+ <stable@vger.kernel.org> # v4.19+
Debugged-by: Thomas Gleixner <tglx@linutronix.de>
Fixes: 0cc3cd21657b ("cpu/hotplug: Boot HT siblings at least once")
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/power/cpu.c          |   10 ++++++++++
 arch/x86/power/hibernate_64.c |   33 +++++++++++++++++++++++++++++++++
 include/linux/cpu.h           |    4 ++++
 kernel/cpu.c                  |    4 ++--
 kernel/power/hibernate.c      |    9 +++++++++
 5 files changed, 58 insertions(+), 2 deletions(-)

--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -292,7 +292,17 @@ int hibernate_resume_nonboot_cpu_disable
 	 * address in its instruction pointer may not be possible to resolve
 	 * any more at that point (the page tables used by it previously may
 	 * have been overwritten by hibernate image data).
+	 *
+	 * First, make sure that we wake up all the potentially disabled SMT
+	 * threads which have been initially brought up and then put into
+	 * mwait/cpuidle sleep.
+	 * Those will be put to proper (not interfering with hibernation
+	 * resume) sleep afterwards, and the resumed kernel will decide itself
+	 * what to do with them.
 	 */
+	ret = cpuhp_smt_enable();
+	if (ret)
+		return ret;
 	smp_ops.play_dead = resume_play_dead;
 	ret = disable_nonboot_cpus();
 	smp_ops.play_dead = play_dead;
--- a/arch/x86/power/hibernate_64.c
+++ b/arch/x86/power/hibernate_64.c
@@ -11,6 +11,7 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/suspend.h>
+#include <linux/cpu.h>
 
 #include <asm/init.h>
 #include <asm/proto.h>
@@ -218,3 +219,35 @@ int arch_hibernation_header_restore(void
 	restore_cr3 = rdr->cr3;
 	return (rdr->magic == RESTORE_MAGIC) ? 0 : -EINVAL;
 }
+
+int arch_resume_nosmt(void)
+{
+	int ret = 0;
+	/*
+	 * We reached this while coming out of hibernation. This means
+	 * that SMT siblings are sleeping in hlt, as mwait is not safe
+	 * against control transition during resume (see comment in
+	 * hibernate_resume_nonboot_cpu_disable()).
+	 *
+	 * If the resumed kernel has SMT disabled, we have to take all the
+	 * SMT siblings out of hlt, and offline them again so that they
+	 * end up in mwait proper.
+	 *
+	 * Called with hotplug disabled.
+	 */
+	cpu_hotplug_enable();
+	if (cpu_smt_control == CPU_SMT_DISABLED ||
+			cpu_smt_control == CPU_SMT_FORCE_DISABLED) {
+		enum cpuhp_smt_control old = cpu_smt_control;
+
+		ret = cpuhp_smt_enable();
+		if (ret)
+			goto out;
+		ret = cpuhp_smt_disable(old);
+		if (ret)
+			goto out;
+	}
+out:
+	cpu_hotplug_disable();
+	return ret;
+}
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -271,11 +271,15 @@ extern enum cpuhp_smt_control cpu_smt_co
 extern void cpu_smt_disable(bool force);
 extern void cpu_smt_check_topology_early(void);
 extern void cpu_smt_check_topology(void);
+extern int cpuhp_smt_enable(void);
+extern int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval);
 #else
 # define cpu_smt_control		(CPU_SMT_ENABLED)
 static inline void cpu_smt_disable(bool force) { }
 static inline void cpu_smt_check_topology_early(void) { }
 static inline void cpu_smt_check_topology(void) { }
+static inline int cpuhp_smt_enable(void) { return 0; }
+static inline int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval) { return 0; }
 #endif
 
 /*
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1995,7 +1995,7 @@ static void cpuhp_online_cpu_device(unsi
 	kobject_uevent(&dev->kobj, KOBJ_ONLINE);
 }
 
-static int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval)
+int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval)
 {
 	int cpu, ret = 0;
 
@@ -2029,7 +2029,7 @@ static int cpuhp_smt_disable(enum cpuhp_
 	return ret;
 }
 
-static int cpuhp_smt_enable(void)
+int cpuhp_smt_enable(void)
 {
 	int cpu, ret = 0;
 
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -256,6 +256,11 @@ void swsusp_show_speed(ktime_t start, kt
 			kps / 1000, (kps % 1000) / 10);
 }
 
+__weak int arch_resume_nosmt(void)
+{
+	return 0;
+}
+
 /**
  * create_image - Create a hibernation image.
  * @platform_mode: Whether or not to use the platform driver.
@@ -322,6 +327,10 @@ static int create_image(int platform_mod
  Enable_cpus:
 	enable_nonboot_cpus();
 
+	/* Allow architectures to do nosmt-specific post-resume dances */
+	if (!in_suspend)
+		error = arch_resume_nosmt();
+
  Platform_finish:
 	platform_finish(platform_mode);
 



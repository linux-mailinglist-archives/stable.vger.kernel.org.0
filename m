Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699A56A909F
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 06:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCCFzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 00:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjCCFzm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 00:55:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEA639BBD;
        Thu,  2 Mar 2023 21:55:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45113B81606;
        Fri,  3 Mar 2023 05:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F04C433EF;
        Fri,  3 Mar 2023 05:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677822902;
        bh=iHfZBwFCse5ztMSVUxmZpYUodSn6St6D/K4W7Hg8NWE=;
        h=Date:To:From:Subject:From;
        b=YWsnZ/jO5Fo63mUilxOzu9apCKKKlpX1lOnwY9+dPlQ6gXzU7HEzFfgoxUevwwnx/
         Ex2CGX9fhr99DBpDimQqM6FiYbT3VKSZI3E2W7gU77bylGNbvPnacU+qF+gLurxiA8
         sZrQQygQ5G06LfoW7OVmF8QYpOnv54CrXPps2Xck=
Date:   Thu, 02 Mar 2023 21:55:01 -0800
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com,
        stable@vger.kernel.org, pmladek@suse.com, mikelley@microsoft.com,
        keescook@chromium.org, hidehiro.kawai.ez@hitachi.com,
        feng.tang@intel.com, dyoung@redhat.com, d.hatayama@jp.fujitsu.com,
        bhe@redhat.com, gpiccoli@igalia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] panic-fixes-the-panic_print-nmi-backtrace-setting.patch removed from -mm tree
Message-Id: <20230303055501.E1F04C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: panic: fix the panic_print NMI backtrace setting
has been removed from the -mm tree.  Its filename was
     panic-fixes-the-panic_print-nmi-backtrace-setting.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: panic: fix the panic_print NMI backtrace setting
Date: Sun, 26 Feb 2023 13:08:38 -0300

Commit 8d470a45d1a6 ("panic: add option to dump all CPUs backtraces in
panic_print") introduced a setting for the "panic_print" kernel parameter
to allow users to request a NMI backtrace on panic.  Problem is that the
panic_print handling happens after the secondary CPUs are already
disabled, hence this option ended-up being kind of a no-op - kernel skips
the NMI trace in idling CPUs, which is the case of offline CPUs.

Fix it by checking the NMI backtrace bit in the panic_print prior to the
CPU disabling function.

Link: https://lkml.kernel.org/r/20230226160838.414257-1-gpiccoli@igalia.com
Fixes: 8d470a45d1a6 ("panic: add option to dump all CPUs backtraces in panic_print")
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Cc: <stable@vger.kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/kernel/panic.c~panic-fixes-the-panic_print-nmi-backtrace-setting
+++ a/kernel/panic.c
@@ -212,9 +212,6 @@ static void panic_print_sys_info(bool co
 		return;
 	}
 
-	if (panic_print & PANIC_PRINT_ALL_CPU_BT)
-		trigger_all_cpu_backtrace();
-
 	if (panic_print & PANIC_PRINT_TASK_INFO)
 		show_state();
 
@@ -244,6 +241,30 @@ void check_panic_on_warn(const char *ori
 		      origin, limit);
 }
 
+/*
+ * Helper that triggers the NMI backtrace (if set in panic_print)
+ * and then performs the secondary CPUs shutdown - we cannot have
+ * the NMI backtrace after the CPUs are off!
+ */
+static void panic_other_cpus_shutdown(bool crash_kexec)
+{
+	if (panic_print & PANIC_PRINT_ALL_CPU_BT)
+		trigger_all_cpu_backtrace();
+
+	/*
+	 * Note that smp_send_stop() is the usual SMP shutdown function,
+	 * which unfortunately may not be hardened to work in a panic
+	 * situation. If we want to do crash dump after notifier calls
+	 * and kmsg_dump, we will need architecture dependent extra
+	 * bits in addition to stopping other CPUs, hence we rely on
+	 * crash_smp_send_stop() for that.
+	 */
+	if (!crash_kexec)
+		smp_send_stop();
+	else
+		crash_smp_send_stop();
+}
+
 /**
  *	panic - halt the system
  *	@fmt: The text string to print
@@ -334,23 +355,10 @@ void panic(const char *fmt, ...)
 	 *
 	 * Bypass the panic_cpu check and call __crash_kexec directly.
 	 */
-	if (!_crash_kexec_post_notifiers) {
+	if (!_crash_kexec_post_notifiers)
 		__crash_kexec(NULL);
 
-		/*
-		 * Note smp_send_stop is the usual smp shutdown function, which
-		 * unfortunately means it may not be hardened to work in a
-		 * panic situation.
-		 */
-		smp_send_stop();
-	} else {
-		/*
-		 * If we want to do crash dump after notifier calls and
-		 * kmsg_dump, we will need architecture dependent extra
-		 * works in addition to stopping other CPUs.
-		 */
-		crash_smp_send_stop();
-	}
+	panic_other_cpus_shutdown(_crash_kexec_post_notifiers);
 
 	/*
 	 * Run any panic handlers, including those that might need to
_

Patches currently in -mm which might be from gpiccoli@igalia.com are



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E903C6A32B6
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 17:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjBZQJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 11:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBZQJT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 11:09:19 -0500
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A88B13DF9;
        Sun, 26 Feb 2023 08:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=J9cSEBaREI6poXfJEyM7t/caJaahD9F9/WQ3FfRuqPk=; b=U9URBDJeaaZWcFcuoSlxLwLjlm
        JSJms62xEFsoiBRLjtJjX1jkYCD1tNLMBVy2xYt4uSr/MvV9xYXJ1eXSOFxtWPpzmQ2oXkr5N95MK
        qSr6V2ibjhc691pBmB3YRUEhr0trN4WEiYT5Y8rwgigtCXTdOqi3rdtuPVBaP72G8vE1Cwx0CqPDl
        jg42HnVBVlQ06ap1tzVjaxs7kWxoTS4FEjt5Zq5kfGyloTnWZugyWtjyFiiSGC78iEWwG5Fn2PwPB
        vFFe96h9n4F5e1Zm/Xn8/qAE1Pnf1qUKX/wnbSLNFb9FcQ7u1gGeJ4bConKT7zKbSfok1NiKJu1Ak
        lnd2QZnw==;
Received: from [152.254.196.162] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1pWJa8-00FwZV-A3; Sun, 26 Feb 2023 17:09:01 +0100
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com
Cc:     linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        dyoung@redhat.com, d.hatayama@jp.fujitsu.com, feng.tang@intel.com,
        hidehiro.kawai.ez@hitachi.com, keescook@chromium.org,
        mikelley@microsoft.com, vgoyal@redhat.com, kernel-dev@igalia.com,
        kernel@gpiccoli.net, "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        stable@vger.kernel.org
Subject: [PATCH v5] panic: Fixes the panic_print NMI backtrace setting
Date:   Sun, 26 Feb 2023 13:08:38 -0300
Message-Id: <20230226160838.414257-1-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 8d470a45d1a6 ("panic: add option to dump all CPUs backtraces in panic_print")
introduced a setting for the "panic_print" kernel parameter to allow
users to request a NMI backtrace on panic. Problem is that the panic_print
handling happens after the secondary CPUs are already disabled, hence
this option ended-up being kind of a no-op - kernel skips the NMI trace
in idling CPUs, which is the case of offline CPUs.

Fix it by checking the NMI backtrace bit in the panic_print prior to
the CPU disabling function.

Fixes: 8d470a45d1a6 ("panic: add option to dump all CPUs backtraces in panic_print")
Cc: stable@vger.kernel.org
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---

V5:
- Kept the local version of "crash_kexec_post_notifiers", since
this is standalone fix that should be backported to stable. Hence,
it's not a good idea to mess with it in this patch (thanks Andrew!).

V4:
- Sent as standalone patch, rebased against v6.2-rc7.
- Link: https://lore.kernel.org/lkml/20230210203510.1734835-1-gpiccoli@igalia.com/


 kernel/panic.c | 44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 463c9295bc28..e026191a0a07 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -211,9 +211,6 @@ static void panic_print_sys_info(bool console_flush)
 		return;
 	}
 
-	if (panic_print & PANIC_PRINT_ALL_CPU_BT)
-		trigger_all_cpu_backtrace();
-
 	if (panic_print & PANIC_PRINT_TASK_INFO)
 		show_state();
 
@@ -243,6 +240,30 @@ void check_panic_on_warn(const char *origin)
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
@@ -333,23 +354,10 @@ void panic(const char *fmt, ...)
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
-- 
2.39.1


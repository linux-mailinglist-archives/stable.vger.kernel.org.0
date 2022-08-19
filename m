Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DB759A3E6
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353791AbiHSQrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353923AbiHSQp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80CD112302;
        Fri, 19 Aug 2022 09:11:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB846B82823;
        Fri, 19 Aug 2022 16:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20824C433C1;
        Fri, 19 Aug 2022 16:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925443;
        bh=v9YBIuWcbbX6Kq7dctppK9xPhA6DCGrsynSFKlqoyns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fn5Et/C1s1SvU0UDKTrk1NhvFdG4iM4dvsbTp3YagaxpTFCpajMUi4PZdQhf6QWl5
         7dn4L7ax0rw2UbJ3JwmraRkWiiQCfJ6jGqIj5mDNQIP8X/GY6TCpg5dahXt+GfWAk1
         VC/3N5a77NZ3StxXroefexxQbiZGGoefyPqVKyB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 492/545] um: Allow PM with suspend-to-idle
Date:   Fri, 19 Aug 2022 17:44:22 +0200
Message-Id: <20220819153851.466721105@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 92dcd3d31843fbe1a95d880dc912e1f6beac6632 ]

In order to be able to experiment with suspend in UML, add the
minimal work to be able to suspend (s2idle) an instance of UML,
and be able to wake it back up from that state with the USR1
signal sent to the main UML process.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/Kconfig                    |  5 +++++
 arch/um/include/shared/kern_util.h |  2 ++
 arch/um/include/shared/os.h        |  1 +
 arch/um/kernel/um_arch.c           | 25 +++++++++++++++++++++++++
 arch/um/os-Linux/signal.c          | 14 +++++++++++++-
 5 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index 4b799fad8b48..1c57599b82fa 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -192,3 +192,8 @@ config UML_TIME_TRAVEL_SUPPORT
 endmenu
 
 source "arch/um/drivers/Kconfig"
+
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y
+
+source "kernel/power/Kconfig"
diff --git a/arch/um/include/shared/kern_util.h b/arch/um/include/shared/kern_util.h
index ccafb62e8cce..9c08e728a675 100644
--- a/arch/um/include/shared/kern_util.h
+++ b/arch/um/include/shared/kern_util.h
@@ -39,6 +39,8 @@ extern int is_syscall(unsigned long addr);
 
 extern void timer_handler(int sig, struct siginfo *unused_si, struct uml_pt_regs *regs);
 
+extern void uml_pm_wake(void);
+
 extern int start_uml(void);
 extern void paging_init(void);
 
diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
index f467d28fc0b4..2f31d44d892e 100644
--- a/arch/um/include/shared/os.h
+++ b/arch/um/include/shared/os.h
@@ -241,6 +241,7 @@ extern int set_signals(int enable);
 extern int set_signals_trace(int enable);
 extern int os_is_signal_stack(void);
 extern void deliver_alarm(void);
+extern void register_pm_wake_signal(void);
 
 /* util.c */
 extern void stack_protections(unsigned long address);
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 26af24b5d900..52e2e2a3e4ae 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -13,6 +13,7 @@
 #include <linux/sched.h>
 #include <linux/sched/task.h>
 #include <linux/kmsg_dump.h>
+#include <linux/suspend.h>
 
 #include <asm/processor.h>
 #include <asm/sections.h>
@@ -385,3 +386,27 @@ void *text_poke(void *addr, const void *opcode, size_t len)
 void text_poke_sync(void)
 {
 }
+
+#ifdef CONFIG_PM_SLEEP
+void uml_pm_wake(void)
+{
+	pm_system_wakeup();
+}
+
+static int init_pm_wake_signal(void)
+{
+	/*
+	 * In external time-travel mode we can't use signals to wake up
+	 * since that would mess with the scheduling. We'll have to do
+	 * some additional work to support wakeup on virtio devices or
+	 * similar, perhaps implementing a fake RTC controller that can
+	 * trigger wakeup (and request the appropriate scheduling from
+	 * the external scheduler when going to suspend.)
+	 */
+	if (time_travel_mode != TT_MODE_EXTERNAL)
+		register_pm_wake_signal();
+	return 0;
+}
+
+late_initcall(init_pm_wake_signal);
+#endif
diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index b58bc68cbe64..0a2ea84033b4 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -136,6 +136,16 @@ void set_sigstack(void *sig_stack, int size)
 		panic("enabling signal stack failed, errno = %d\n", errno);
 }
 
+static void sigusr1_handler(int sig, struct siginfo *unused_si, mcontext_t *mc)
+{
+	uml_pm_wake();
+}
+
+void register_pm_wake_signal(void)
+{
+	set_handler(SIGUSR1);
+}
+
 static void (*handlers[_NSIG])(int sig, struct siginfo *si, mcontext_t *mc) = {
 	[SIGSEGV] = sig_handler,
 	[SIGBUS] = sig_handler,
@@ -145,7 +155,9 @@ static void (*handlers[_NSIG])(int sig, struct siginfo *si, mcontext_t *mc) = {
 
 	[SIGIO] = sig_handler,
 	[SIGWINCH] = sig_handler,
-	[SIGALRM] = timer_alarm_handler
+	[SIGALRM] = timer_alarm_handler,
+
+	[SIGUSR1] = sigusr1_handler,
 };
 
 static void hard_handler(int sig, siginfo_t *si, void *p)
-- 
2.35.1




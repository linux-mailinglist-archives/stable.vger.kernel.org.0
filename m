Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AFF499359
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345826AbiAXUdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:33:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49732 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349765AbiAXUXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:23:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A67B2614EC;
        Mon, 24 Jan 2022 20:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B484C340E5;
        Mon, 24 Jan 2022 20:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055829;
        bh=Wcrj+rKfUeDaiHz1P3RN61MxAqpAvccw1pIYIr8pwPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cp3zu2mLuHnWA3DOZjWtumE/yx+VEUT+y/uETb4eGtAA7cAaiywf9LqIgPxh/z/ul
         CxE0/Qs0kC+pfBn2C8iFwFmIvcJLLiiaacTrISOQVUQpWoT1TaHXRxnvW0q8fd3Urq
         R306wTw68Lnfo70er3HnO2l88WUrz/V5X0OYscys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 279/846] um: rename set_signals() to um_set_signals()
Date:   Mon, 24 Jan 2022 19:36:36 +0100
Message-Id: <20220124184110.555886129@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit bbe33504d4a7fdab9011211e55e262c869b3f6cc ]

Rename set_signals() as there's at least one driver that
uses the same name and can now be built on UM due to PCI
support, and thus we can get symbol conflicts.

Also rename set_signals_trace() to be consistent.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/asm/irqflags.h   | 4 ++--
 arch/um/include/shared/longjmp.h | 2 +-
 arch/um/include/shared/os.h      | 4 ++--
 arch/um/kernel/ksyms.c           | 2 +-
 arch/um/os-Linux/sigio.c         | 6 +++---
 arch/um/os-Linux/signal.c        | 8 ++++----
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/um/include/asm/irqflags.h b/arch/um/include/asm/irqflags.h
index dab5744e9253d..1e69ef5bc35e0 100644
--- a/arch/um/include/asm/irqflags.h
+++ b/arch/um/include/asm/irqflags.h
@@ -3,7 +3,7 @@
 #define __UM_IRQFLAGS_H
 
 extern int signals_enabled;
-int set_signals(int enable);
+int um_set_signals(int enable);
 void block_signals(void);
 void unblock_signals(void);
 
@@ -16,7 +16,7 @@ static inline unsigned long arch_local_save_flags(void)
 #define arch_local_irq_restore arch_local_irq_restore
 static inline void arch_local_irq_restore(unsigned long flags)
 {
-	set_signals(flags);
+	um_set_signals(flags);
 }
 
 #define arch_local_irq_enable arch_local_irq_enable
diff --git a/arch/um/include/shared/longjmp.h b/arch/um/include/shared/longjmp.h
index bdb2869b72b31..8863319039f3d 100644
--- a/arch/um/include/shared/longjmp.h
+++ b/arch/um/include/shared/longjmp.h
@@ -18,7 +18,7 @@ extern void longjmp(jmp_buf, int);
 	enable = *(volatile int *)&signals_enabled;	\
 	n = setjmp(*buf);				\
 	if(n != 0)					\
-		set_signals_trace(enable);		\
+		um_set_signals_trace(enable);		\
 	n; })
 
 #endif
diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
index 96d400387c93e..03ffbdddcc480 100644
--- a/arch/um/include/shared/os.h
+++ b/arch/um/include/shared/os.h
@@ -238,8 +238,8 @@ extern void send_sigio_to_self(void);
 extern int change_sig(int signal, int on);
 extern void block_signals(void);
 extern void unblock_signals(void);
-extern int set_signals(int enable);
-extern int set_signals_trace(int enable);
+extern int um_set_signals(int enable);
+extern int um_set_signals_trace(int enable);
 extern int os_is_signal_stack(void);
 extern void deliver_alarm(void);
 extern void register_pm_wake_signal(void);
diff --git a/arch/um/kernel/ksyms.c b/arch/um/kernel/ksyms.c
index b1e5634398d09..3a85bde3e1734 100644
--- a/arch/um/kernel/ksyms.c
+++ b/arch/um/kernel/ksyms.c
@@ -6,7 +6,7 @@
 #include <linux/module.h>
 #include <os.h>
 
-EXPORT_SYMBOL(set_signals);
+EXPORT_SYMBOL(um_set_signals);
 EXPORT_SYMBOL(signals_enabled);
 
 EXPORT_SYMBOL(os_stat_fd);
diff --git a/arch/um/os-Linux/sigio.c b/arch/um/os-Linux/sigio.c
index 6597ea1986ffa..9e71794839e87 100644
--- a/arch/um/os-Linux/sigio.c
+++ b/arch/um/os-Linux/sigio.c
@@ -132,7 +132,7 @@ static void update_thread(void)
 	int n;
 	char c;
 
-	flags = set_signals_trace(0);
+	flags = um_set_signals_trace(0);
 	CATCH_EINTR(n = write(sigio_private[0], &c, sizeof(c)));
 	if (n != sizeof(c)) {
 		printk(UM_KERN_ERR "update_thread : write failed, err = %d\n",
@@ -147,7 +147,7 @@ static void update_thread(void)
 		goto fail;
 	}
 
-	set_signals_trace(flags);
+	um_set_signals_trace(flags);
 	return;
  fail:
 	/* Critical section start */
@@ -161,7 +161,7 @@ static void update_thread(void)
 	close(write_sigio_fds[0]);
 	close(write_sigio_fds[1]);
 	/* Critical section end */
-	set_signals_trace(flags);
+	um_set_signals_trace(flags);
 }
 
 int __add_sigio_fd(int fd)
diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index 6cf098c23a394..24a403a70a020 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -94,7 +94,7 @@ void sig_handler(int sig, struct siginfo *si, mcontext_t *mc)
 
 	sig_handler_common(sig, si, mc);
 
-	set_signals_trace(enabled);
+	um_set_signals_trace(enabled);
 }
 
 static void timer_real_alarm_handler(mcontext_t *mc)
@@ -126,7 +126,7 @@ void timer_alarm_handler(int sig, struct siginfo *unused_si, mcontext_t *mc)
 
 	signals_active &= ~SIGALRM_MASK;
 
-	set_signals_trace(enabled);
+	um_set_signals_trace(enabled);
 }
 
 void deliver_alarm(void) {
@@ -348,7 +348,7 @@ void unblock_signals(void)
 	}
 }
 
-int set_signals(int enable)
+int um_set_signals(int enable)
 {
 	int ret;
 	if (signals_enabled == enable)
@@ -362,7 +362,7 @@ int set_signals(int enable)
 	return ret;
 }
 
-int set_signals_trace(int enable)
+int um_set_signals_trace(int enable)
 {
 	int ret;
 	if (signals_enabled == enable)
-- 
2.34.1




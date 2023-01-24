Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DED67A1BE
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 19:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbjAXSwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 13:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjAXSwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 13:52:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DBA402CC;
        Tue, 24 Jan 2023 10:52:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D6626132D;
        Tue, 24 Jan 2023 18:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDE5C433A7;
        Tue, 24 Jan 2023 18:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674586322;
        bh=Ow9TgWwAub8fE+SNOb9xM+/rdmy9a1pdg2vENGYMYyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQ98RMDDVvD+yJnDJrolDKhPC3l8CPVUZD/VuApgVu1LLllrFeIUee0AGaKtqCPSu
         yIeTCvINrtYlbRwoH1yotW05tySL6YCPbzKzD0MVw9ueb+/t/5lBf/bBXi+5EAhvvV
         HF4FkhyqCIpOIXgU4zcxPQbjOLluIrIa1pHBlZijFOUbQNoXGBt0ggFa0aU0snWQSq
         6UxFNFPUuG60a+HXWrU/RZg4x9sfao0pxpM/JsTucSIdcGFNykQiX7imUnmkcgrqHO
         PYp6cuMCcONBQMheaLqpzWx3dT04M0Y9HFOZHoL+xxoicTgMET9AihPdHQIkQUCsOk
         LMtpdCyB4kxkA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        tangmeng <tangmeng@uniontech.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 5.15 02/20] kernel/panic: move panic sysctls to its own file
Date:   Tue, 24 Jan 2023 10:50:52 -0800
Message-Id: <20230124185110.143857-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124185110.143857-1-ebiggers@kernel.org>
References: <20230124185110.143857-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: tangmeng <tangmeng@uniontech.com>

commit 9df918698408fd914493aba0b7858fef50eba63a upstream.

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we
just care about the core logic.

All filesystem syctls now get reviewed by fs folks. This commit
follows the commit of fs, move the oops_all_cpu_backtrace sysctl to
its own file, kernel/panic.c.

Signed-off-by: tangmeng <tangmeng@uniontech.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/panic.h |  6 ------
 kernel/panic.c        | 26 +++++++++++++++++++++++++-
 kernel/sysctl.c       | 11 -----------
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/include/linux/panic.h b/include/linux/panic.h
index f5844908a089e..e71161da69c4b 100644
--- a/include/linux/panic.h
+++ b/include/linux/panic.h
@@ -15,12 +15,6 @@ extern void oops_enter(void);
 extern void oops_exit(void);
 extern bool oops_may_print(void);
 
-#ifdef CONFIG_SMP
-extern unsigned int sysctl_oops_all_cpu_backtrace;
-#else
-#define sysctl_oops_all_cpu_backtrace 0
-#endif /* CONFIG_SMP */
-
 extern int panic_timeout;
 extern unsigned long panic_print;
 extern int panic_on_oops;
diff --git a/kernel/panic.c b/kernel/panic.c
index cefd7d82366fb..5ee281b996f9e 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -42,7 +42,9 @@
  * Should we dump all CPUs backtraces in an oops event?
  * Defaults to 0, can be changed via sysctl.
  */
-unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
+static unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
+#else
+#define sysctl_oops_all_cpu_backtrace 0
 #endif /* CONFIG_SMP */
 
 int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
@@ -71,6 +73,28 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
 EXPORT_SYMBOL(panic_notifier_list);
 
+#if defined(CONFIG_SMP) && defined(CONFIG_SYSCTL)
+static struct ctl_table kern_panic_table[] = {
+	{
+		.procname       = "oops_all_cpu_backtrace",
+		.data           = &sysctl_oops_all_cpu_backtrace,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
+	},
+	{ }
+};
+
+static __init int kernel_panic_sysctls_init(void)
+{
+	register_sysctl_init("kernel", kern_panic_table);
+	return 0;
+}
+late_initcall(kernel_panic_sysctls_init);
+#endif
+
 static long no_blink(int state)
 {
 	return 0;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 34ce5953dbb09..928798f89ca1d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2220,17 +2220,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_SMP
-	{
-		.procname	= "oops_all_cpu_backtrace",
-		.data		= &sysctl_oops_all_cpu_backtrace,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif /* CONFIG_SMP */
 	{
 		.procname	= "pid_max",
 		.data		= &pid_max,
-- 
2.39.1


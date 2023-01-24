Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B003667A306
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 20:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbjAXTfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 14:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjAXTfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 14:35:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB224211;
        Tue, 24 Jan 2023 11:35:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D446B816BF;
        Tue, 24 Jan 2023 19:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D0CC433D2;
        Tue, 24 Jan 2023 19:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674588916;
        bh=BM2SL/hK4n/mG2G/JWV0pug+lwME5e+5UISAuadPDQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pMMMa7/FWueJaPbT6WueVzTxC/XZ8ZmRy6NVYSRHJH2o9jCWKCnDuTqLkI9Uq2oMs
         26tX5Wne6sRQ49BrsLDXDyBSDnU7kpfdnmMGjAhbQFHFUzjbzZwdAXdf+oY3Uy91FA
         y9MlbNxl0UAgaVq5hGo8jrPsJWS1dSAObfTRlXgMXHaQQHhE+t+hTuwYMcxP9523KN
         Y8ew8fd4AqVdZexwqE0zwwOPm9PQVoyu/1oxSdXosdsxZZOwlX8ohDuwlYN4pnoSii
         tlftKSUr4KuqWENMwRfI57tcR+fBcp0Pn+K+mb5FcQ3cCzx/he/b7oQpXqSWMQpXhw
         HvvFg2GsoGtLg==
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
Subject: [PATCH 5.10 02/20] kernel/panic: move panic sysctls to its own file
Date:   Tue, 24 Jan 2023 11:29:46 -0800
Message-Id: <20230124193004.206841-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124193004.206841-1-ebiggers@kernel.org>
References: <20230124193004.206841-1-ebiggers@kernel.org>
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
 include/linux/kernel.h |  6 ------
 kernel/panic.c         | 26 +++++++++++++++++++++++++-
 kernel/sysctl.c        | 11 -----------
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f5392d96d6886..084d97070ed99 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -520,12 +520,6 @@ static inline u32 int_sqrt64(u64 x)
 }
 #endif
 
-#ifdef CONFIG_SMP
-extern unsigned int sysctl_oops_all_cpu_backtrace;
-#else
-#define sysctl_oops_all_cpu_backtrace 0
-#endif /* CONFIG_SMP */
-
 extern void bust_spinlocks(int yes);
 extern int panic_timeout;
 extern unsigned long panic_print;
diff --git a/kernel/panic.c b/kernel/panic.c
index 332736a72a58e..f567195d45d9d 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -41,7 +41,9 @@
  * Should we dump all CPUs backtraces in an oops event?
  * Defaults to 0, can be changed via sysctl.
  */
-unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
+static unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
+#else
+#define sysctl_oops_all_cpu_backtrace 0
 #endif /* CONFIG_SMP */
 
 int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
@@ -70,6 +72,28 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
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
index 3eb527f8a269c..d8b7b28463135 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2199,17 +2199,6 @@ static struct ctl_table kern_table[] = {
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


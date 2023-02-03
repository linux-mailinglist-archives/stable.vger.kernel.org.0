Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22D36896E9
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbjBCKdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:33:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbjBCKc7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:32:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D780CA428E;
        Fri,  3 Feb 2023 02:31:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C5AD61ECF;
        Fri,  3 Feb 2023 10:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFDAC433D2;
        Fri,  3 Feb 2023 10:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420277;
        bh=0r45++4H2nWMunVixrnZ0S8jBme1mkdMQYRQg9bca9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qz7oUv5d9YFHRRlKODTspTDGt7e25JeMvxFQf9ZnoICuHo+6gpcb+QQf2hBXGgvhL
         YeUKnxl/OmHiLStIZgz2laIS3/ABwIMpj70IoYZ9iO8/vgmRVQ0IBkgXDuuXgyZb/G
         o6ngH9u8plZBQxoRQXEQxvoWd1ePdUvap6GB0j0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@google.com>,
        Huang Ying <ying.huang@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        tangmeng <tangmeng@uniontech.com>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-doc@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/134] panic: Introduce warn_limit
Date:   Fri,  3 Feb 2023 11:13:52 +0100
Message-Id: <20230203101029.515706826@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 9fc9e278a5c0b708eeffaf47d6eb0c82aa74ed78 upstream.

Like oops_limit, add warn_limit for limiting the number of warnings when
panic_on_warn is not set.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: tangmeng <tangmeng@uniontech.com>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-doc@vger.kernel.org
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221117234328.594699-5-keescook@chromium.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/sysctl/kernel.rst | 10 ++++++++
 kernel/panic.c                              | 27 +++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index bc31c4a88f20..568c24ff00a7 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1186,6 +1186,16 @@ entry will default to 2 instead of 0.
 2 Unprivileged calls to ``bpf()`` are disabled
 = =============================================================
 
+
+warn_limit
+==========
+
+Number of kernel warnings after which the kernel should panic when
+``panic_on_warn`` is not set. Setting this to 0 disables checking
+the warning count. Setting this to 1 has the same effect as setting
+``panic_on_warn=1``. The default value is 0.
+
+
 watchdog:
 =========
 
diff --git a/kernel/panic.c b/kernel/panic.c
index 7e4900eb25ac..8f72305dd501 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -44,6 +44,7 @@ static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
 bool crash_kexec_post_notifiers;
 int panic_on_warn __read_mostly;
+static unsigned int warn_limit __read_mostly;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
@@ -60,6 +61,26 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
 EXPORT_SYMBOL(panic_notifier_list);
 
+#ifdef CONFIG_SYSCTL
+static struct ctl_table kern_panic_table[] = {
+	{
+		.procname       = "warn_limit",
+		.data           = &warn_limit,
+		.maxlen         = sizeof(warn_limit),
+		.mode           = 0644,
+		.proc_handler   = proc_douintvec,
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
@@ -158,8 +179,14 @@ static void panic_print_sys_info(void)
 
 void check_panic_on_warn(const char *origin)
 {
+	static atomic_t warn_count = ATOMIC_INIT(0);
+
 	if (panic_on_warn)
 		panic("%s: panic_on_warn set ...\n", origin);
+
+	if (atomic_inc_return(&warn_count) >= READ_ONCE(warn_limit) && warn_limit)
+		panic("%s: system warned too often (kernel.warn_limit is %d)",
+		      origin, warn_limit);
 }
 
 /**
-- 
2.39.0




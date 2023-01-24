Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A45467A329
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 20:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbjAXTgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 14:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbjAXTfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 14:35:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDE822A22;
        Tue, 24 Jan 2023 11:35:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FE1EB815DA;
        Tue, 24 Jan 2023 19:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72053C433A0;
        Tue, 24 Jan 2023 19:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674588925;
        bh=upf6vrbB2iqM5yS6hjS4TpP3gQP9b55tufNSyIjyms8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxZbmFtJLMBBpiC+ASagxMkdl7d/Sn+bHDMCGmWU6SYPDjzU9YcgnEUgRbdEbo/94
         d5V5y9OOhRNNjyf92gJFlci8SeMe8A8XXrwaqfwWYE4MN1aykFiP1z0oD+PJUpjhaz
         kcsjag7+ICAATbL/YXugT075tqeWgZPJg8yopI5S5z9nGrnEQW3HIIJptpdzewUKOs
         /9Lt5LLROnhDP8bB6hOU2LBuUVN3kfoJB+QrXmro65Ti5uVTLM0bXyn49Dpu+5wqOM
         0KvDCKlL4PY+1oEjyNaUfHMiPVzyiB+wD2tCJGq7TIxFwnlN7uxXKfBH+5uvud5u+/
         EpO8zug7WTK7g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        tangmeng <tangmeng@uniontech.com>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 5.10 18/20] panic: Expose "warn_count" to sysfs
Date:   Tue, 24 Jan 2023 11:30:02 -0800
Message-Id: <20230124193004.206841-19-ebiggers@kernel.org>
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

From: Kees Cook <keescook@chromium.org>

commit 8b05aa26336113c4cea25f1c333ee8cd4fc212a6 upstream.

Since Warn count is now tracked and is a fairly interesting signal, add
the entry /sys/kernel/warn_count to expose it to userspace.

Cc: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: tangmeng <tangmeng@uniontech.com>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221117234328.594699-6-keescook@chromium.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 .../ABI/testing/sysfs-kernel-warn_count       |  6 +++++
 kernel/panic.c                                | 22 +++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-warn_count

diff --git a/Documentation/ABI/testing/sysfs-kernel-warn_count b/Documentation/ABI/testing/sysfs-kernel-warn_count
new file mode 100644
index 0000000000000..08f083d2fd51b
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-warn_count
@@ -0,0 +1,6 @@
+What:		/sys/kernel/oops_count
+Date:		November 2022
+KernelVersion:	6.2.0
+Contact:	Linux Kernel Hardening List <linux-hardening@vger.kernel.org>
+Description:
+		Shows how many times the system has Warned since last boot.
diff --git a/kernel/panic.c b/kernel/panic.c
index e341366bd3e8b..6e30455eb2e7c 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -31,6 +31,7 @@
 #include <linux/bug.h>
 #include <linux/ratelimit.h>
 #include <linux/debugfs.h>
+#include <linux/sysfs.h>
 #include <asm/sections.h>
 
 #define PANIC_TIMER_STEP 100
@@ -104,6 +105,25 @@ static __init int kernel_panic_sysctls_init(void)
 late_initcall(kernel_panic_sysctls_init);
 #endif
 
+static atomic_t warn_count = ATOMIC_INIT(0);
+
+#ifdef CONFIG_SYSFS
+static ssize_t warn_count_show(struct kobject *kobj, struct kobj_attribute *attr,
+			       char *page)
+{
+	return sysfs_emit(page, "%d\n", atomic_read(&warn_count));
+}
+
+static struct kobj_attribute warn_count_attr = __ATTR_RO(warn_count);
+
+static __init int kernel_panic_sysfs_init(void)
+{
+	sysfs_add_file_to_group(kernel_kobj, &warn_count_attr.attr, NULL);
+	return 0;
+}
+late_initcall(kernel_panic_sysfs_init);
+#endif
+
 static long no_blink(int state)
 {
 	return 0;
@@ -202,8 +222,6 @@ static void panic_print_sys_info(void)
 
 void check_panic_on_warn(const char *origin)
 {
-	static atomic_t warn_count = ATOMIC_INIT(0);
-
 	if (panic_on_warn)
 		panic("%s: panic_on_warn set ...\n", origin);
 
-- 
2.39.1


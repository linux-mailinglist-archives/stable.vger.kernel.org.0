Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823C2689546
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbjBCKRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbjBCKR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:17:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966709D074
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:16:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01E35B82A65
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A492C4339B;
        Fri,  3 Feb 2023 10:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419405;
        bh=9lClfUdJcGXKsA6ctk086Kz8A2jnCvcSHiho7FD0U0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exlJzAdLqsf/iIVZn0df0Wac2UudmoULf1npDlG+yTUW0dRjmsnVjRhILNiqnT5P/
         fmZDrSUUPgy9qH/nL8nFs7hSG6zw6zk04Pes45bu9cFTzW1oeb0cKiuIi03FcEsuup
         xUwN45n1EO7MejFHicYcBLn+hHCqAmHKx0lOtb3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Petr Mladek <pmladek@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        tangmeng <tangmeng@uniontech.com>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.14 57/62] panic: Expose "warn_count" to sysfs
Date:   Fri,  3 Feb 2023 11:12:53 +0100
Message-Id: <20230203101015.413222041@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-kernel-warn_count |    6 ++++++
 kernel/panic.c                                    |   22 ++++++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-warn_count

--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-warn_count
@@ -0,0 +1,6 @@
+What:		/sys/kernel/oops_count
+Date:		November 2022
+KernelVersion:	6.2.0
+Contact:	Linux Kernel Hardening List <linux-hardening@vger.kernel.org>
+Description:
+		Shows how many times the system has Warned since last boot.
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -28,6 +28,7 @@
 #include <linux/console.h>
 #include <linux/bug.h>
 #include <linux/ratelimit.h>
+#include <linux/sysfs.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -68,6 +69,25 @@ static __init int kernel_panic_sysctls_i
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
@@ -145,8 +165,6 @@ EXPORT_SYMBOL(nmi_panic);
 
 void check_panic_on_warn(const char *origin)
 {
-	static atomic_t warn_count = ATOMIC_INIT(0);
-
 	if (panic_on_warn)
 		panic("%s: panic_on_warn set ...\n", origin);
 



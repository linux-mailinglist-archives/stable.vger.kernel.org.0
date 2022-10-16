Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF4060009D
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiJPPXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiJPPXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:23:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522702EF65
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:23:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6B2C60BC8
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5063C433D6;
        Sun, 16 Oct 2022 15:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665933801;
        bh=nkJXUU+AliE6znK1Ff7kRzd0kFKp5nrT92taddvEAWY=;
        h=Subject:To:Cc:From:Date:From;
        b=ydiqajn6w8LqZ3El1rGYh1HwIT0fP0YBVLR03MCA0KBYLfMBWuCZFWglC0Tn/r5Az
         K/HAhkPpB2L0uFTynMpVx1Js3mrrHPb24T6r616uFP/B8MexfpL+Ln+JnP3lWbqJKF
         YbSu76dpplaBkbwvmBj2441Jj+e5Gk9hR3YwFCKs=
Subject: FAILED: patch "[PATCH] tracing: Move duplicate code of trace_kprobe/eprobe.c into" failed to apply to 5.10-stable tree
To:     rostedt@goodmis.org, akpm@linux-foundation.org,
        mhiramat@kernel.org, zanussi@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:24:07 +0200
Message-ID: <16659338479799@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f1d3cbfaafc1 ("tracing: Move duplicate code of trace_kprobe/eprobe.c into header")
7491e2c44278 ("tracing: Add a probe that attaches to trace events")
007517a01995 ("tracing/probe: Change traceprobe_set_print_fmt() to take a type")
bc87cf0a08d4 ("trace: Add a generic function to read/write u64 values from tracefs")
d262271d0483 ("tracing/dynevent: Delegate parsing to create function")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f1d3cbfaafc10464550c6d3a125f4fc802bbaed5 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Wed, 12 Oct 2022 06:40:56 -0400
Subject: [PATCH] tracing: Move duplicate code of trace_kprobe/eprobe.c into
 header

The functions:

  fetch_store_strlen_user()
  fetch_store_strlen()
  fetch_store_string_user()
  fetch_store_string()

are identical in both trace_kprobe.c and trace_eprobe.c. Move them into
a new header file trace_probe_kernel.h to share it. This code will later
be used by the synthetic events as well.

Marked for stable as a fix for a crash in synthetic events requires it.

Link: https://lkml.kernel.org/r/20221012104534.467668078@goodmis.org

Cc: stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tom Zanussi <zanussi@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Fixes: bd82631d7ccdc ("tracing: Add support for dynamic strings to synthetic events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
index c08bde9871ec..5dd0617e5df6 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -16,6 +16,7 @@
 #include "trace_dynevent.h"
 #include "trace_probe.h"
 #include "trace_probe_tmpl.h"
+#include "trace_probe_kernel.h"
 
 #define EPROBE_EVENT_SYSTEM "eprobes"
 
@@ -456,29 +457,14 @@ NOKPROBE_SYMBOL(process_fetch_insn)
 static nokprobe_inline int
 fetch_store_strlen_user(unsigned long addr)
 {
-	const void __user *uaddr =  (__force const void __user *)addr;
-
-	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
+	return kern_fetch_store_strlen_user(addr);
 }
 
 /* Return the length of string -- including null terminal byte */
 static nokprobe_inline int
 fetch_store_strlen(unsigned long addr)
 {
-	int ret, len = 0;
-	u8 c;
-
-#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
-	if (addr < TASK_SIZE)
-		return fetch_store_strlen_user(addr);
-#endif
-
-	do {
-		ret = copy_from_kernel_nofault(&c, (u8 *)addr + len, 1);
-		len++;
-	} while (c && ret == 0 && len < MAX_STRING_SIZE);
-
-	return (ret < 0) ? ret : len;
+	return kern_fetch_store_strlen(addr);
 }
 
 /*
@@ -488,21 +474,7 @@ fetch_store_strlen(unsigned long addr)
 static nokprobe_inline int
 fetch_store_string_user(unsigned long addr, void *dest, void *base)
 {
-	const void __user *uaddr =  (__force const void __user *)addr;
-	int maxlen = get_loc_len(*(u32 *)dest);
-	void *__dest;
-	long ret;
-
-	if (unlikely(!maxlen))
-		return -ENOMEM;
-
-	__dest = get_loc_data(dest, base);
-
-	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
-	if (ret >= 0)
-		*(u32 *)dest = make_data_loc(ret, __dest - base);
-
-	return ret;
+	return kern_fetch_store_string_user(addr, dest, base);
 }
 
 /*
@@ -512,29 +484,7 @@ fetch_store_string_user(unsigned long addr, void *dest, void *base)
 static nokprobe_inline int
 fetch_store_string(unsigned long addr, void *dest, void *base)
 {
-	int maxlen = get_loc_len(*(u32 *)dest);
-	void *__dest;
-	long ret;
-
-#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
-	if ((unsigned long)addr < TASK_SIZE)
-		return fetch_store_string_user(addr, dest, base);
-#endif
-
-	if (unlikely(!maxlen))
-		return -ENOMEM;
-
-	__dest = get_loc_data(dest, base);
-
-	/*
-	 * Try to get string again, since the string can be changed while
-	 * probing.
-	 */
-	ret = strncpy_from_kernel_nofault(__dest, (void *)addr, maxlen);
-	if (ret >= 0)
-		*(u32 *)dest = make_data_loc(ret, __dest - base);
-
-	return ret;
+	return kern_fetch_store_string(addr, dest, base);
 }
 
 static nokprobe_inline int
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 23f7f0ec4f4c..5a75b039e586 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -20,6 +20,7 @@
 #include "trace_kprobe_selftest.h"
 #include "trace_probe.h"
 #include "trace_probe_tmpl.h"
+#include "trace_probe_kernel.h"
 
 #define KPROBE_EVENT_SYSTEM "kprobes"
 #define KRETPROBE_MAXACTIVE_MAX 4096
@@ -1223,29 +1224,14 @@ static const struct file_operations kprobe_profile_ops = {
 static nokprobe_inline int
 fetch_store_strlen_user(unsigned long addr)
 {
-	const void __user *uaddr =  (__force const void __user *)addr;
-
-	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
+	return kern_fetch_store_strlen_user(addr);
 }
 
 /* Return the length of string -- including null terminal byte */
 static nokprobe_inline int
 fetch_store_strlen(unsigned long addr)
 {
-	int ret, len = 0;
-	u8 c;
-
-#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
-	if (addr < TASK_SIZE)
-		return fetch_store_strlen_user(addr);
-#endif
-
-	do {
-		ret = copy_from_kernel_nofault(&c, (u8 *)addr + len, 1);
-		len++;
-	} while (c && ret == 0 && len < MAX_STRING_SIZE);
-
-	return (ret < 0) ? ret : len;
+	return kern_fetch_store_strlen(addr);
 }
 
 /*
@@ -1255,21 +1241,7 @@ fetch_store_strlen(unsigned long addr)
 static nokprobe_inline int
 fetch_store_string_user(unsigned long addr, void *dest, void *base)
 {
-	const void __user *uaddr =  (__force const void __user *)addr;
-	int maxlen = get_loc_len(*(u32 *)dest);
-	void *__dest;
-	long ret;
-
-	if (unlikely(!maxlen))
-		return -ENOMEM;
-
-	__dest = get_loc_data(dest, base);
-
-	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
-	if (ret >= 0)
-		*(u32 *)dest = make_data_loc(ret, __dest - base);
-
-	return ret;
+	return kern_fetch_store_string_user(addr, dest, base);
 }
 
 /*
@@ -1279,29 +1251,7 @@ fetch_store_string_user(unsigned long addr, void *dest, void *base)
 static nokprobe_inline int
 fetch_store_string(unsigned long addr, void *dest, void *base)
 {
-	int maxlen = get_loc_len(*(u32 *)dest);
-	void *__dest;
-	long ret;
-
-#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
-	if ((unsigned long)addr < TASK_SIZE)
-		return fetch_store_string_user(addr, dest, base);
-#endif
-
-	if (unlikely(!maxlen))
-		return -ENOMEM;
-
-	__dest = get_loc_data(dest, base);
-
-	/*
-	 * Try to get string again, since the string can be changed while
-	 * probing.
-	 */
-	ret = strncpy_from_kernel_nofault(__dest, (void *)addr, maxlen);
-	if (ret >= 0)
-		*(u32 *)dest = make_data_loc(ret, __dest - base);
-
-	return ret;
+	return kern_fetch_store_string(addr, dest, base);
 }
 
 static nokprobe_inline int
diff --git a/kernel/trace/trace_probe_kernel.h b/kernel/trace/trace_probe_kernel.h
new file mode 100644
index 000000000000..1d43df29a1f8
--- /dev/null
+++ b/kernel/trace/trace_probe_kernel.h
@@ -0,0 +1,96 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __TRACE_PROBE_KERNEL_H_
+#define __TRACE_PROBE_KERNEL_H_
+
+/*
+ * This depends on trace_probe.h, but can not include it due to
+ * the way trace_probe_tmpl.h is used by trace_kprobe.c and trace_eprobe.c.
+ * Which means that any other user must include trace_probe.h before including
+ * this file.
+ */
+/* Return the length of string -- including null terminal byte */
+static nokprobe_inline int
+kern_fetch_store_strlen_user(unsigned long addr)
+{
+	const void __user *uaddr =  (__force const void __user *)addr;
+
+	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
+}
+
+/* Return the length of string -- including null terminal byte */
+static nokprobe_inline int
+kern_fetch_store_strlen(unsigned long addr)
+{
+	int ret, len = 0;
+	u8 c;
+
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	if (addr < TASK_SIZE)
+		return kern_fetch_store_strlen_user(addr);
+#endif
+
+	do {
+		ret = copy_from_kernel_nofault(&c, (u8 *)addr + len, 1);
+		len++;
+	} while (c && ret == 0 && len < MAX_STRING_SIZE);
+
+	return (ret < 0) ? ret : len;
+}
+
+/*
+ * Fetch a null-terminated string from user. Caller MUST set *(u32 *)buf
+ * with max length and relative data location.
+ */
+static nokprobe_inline int
+kern_fetch_store_string_user(unsigned long addr, void *dest, void *base)
+{
+	const void __user *uaddr =  (__force const void __user *)addr;
+	int maxlen = get_loc_len(*(u32 *)dest);
+	void *__dest;
+	long ret;
+
+	if (unlikely(!maxlen))
+		return -ENOMEM;
+
+	__dest = get_loc_data(dest, base);
+
+	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
+	if (ret >= 0)
+		*(u32 *)dest = make_data_loc(ret, __dest - base);
+
+	return ret;
+}
+
+/*
+ * Fetch a null-terminated string. Caller MUST set *(u32 *)buf with max
+ * length and relative data location.
+ */
+static nokprobe_inline int
+kern_fetch_store_string(unsigned long addr, void *dest, void *base)
+{
+	int maxlen = get_loc_len(*(u32 *)dest);
+	void *__dest;
+	long ret;
+
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	if ((unsigned long)addr < TASK_SIZE)
+		return kern_fetch_store_string_user(addr, dest, base);
+#endif
+
+	if (unlikely(!maxlen))
+		return -ENOMEM;
+
+	__dest = get_loc_data(dest, base);
+
+	/*
+	 * Try to get string again, since the string can be changed while
+	 * probing.
+	 */
+	ret = strncpy_from_kernel_nofault(__dest, (void *)addr, maxlen);
+	if (ret >= 0)
+		*(u32 *)dest = make_data_loc(ret, __dest - base);
+
+	return ret;
+}
+
+#endif /* __TRACE_PROBE_KERNEL_H_ */


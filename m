Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82E85FC3E2
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 12:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiJLKp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 06:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiJLKp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 06:45:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E59604BB;
        Wed, 12 Oct 2022 03:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2A404CE1B46;
        Wed, 12 Oct 2022 10:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D1FC43470;
        Wed, 12 Oct 2022 10:45:19 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oiZF0-0047Rm-21;
        Wed, 12 Oct 2022 06:45:34 -0400
Message-ID: <20221012104534.467668078@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 12 Oct 2022 06:40:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/3] tracing: Move duplicate code of trace_kprobe/eprobe.c into header
References: <20221012104055.421393330@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The functions:

  fetch_store_strlen_user()
  fetch_store_strlen()
  fetch_store_string_user()
  fetch_store_string()

are identical in both trace_kprobe.c and trace_eprobe.c. Move them into
a new header file trace_probe_kernel.h to share it. This code will later
be used by the synthetic events as well.

Marked for stable as a fix for a crash in synthetic events requires it.

Cc: stable@vger.kernel.org
Fixes: bd82631d7ccdc ("tracing: Add support for dynamic strings to synthetic events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_eprobe.c       | 60 ++-----------------
 kernel/trace/trace_kprobe.c       | 60 ++-----------------
 kernel/trace/trace_probe_kernel.h | 96 +++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+), 110 deletions(-)
 create mode 100644 kernel/trace/trace_probe_kernel.h

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
-- 
2.35.1

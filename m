Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78769608668
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiJVHtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbiJVHsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:48:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C22C167F5B;
        Sat, 22 Oct 2022 00:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43B6A60B84;
        Sat, 22 Oct 2022 07:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BF7C433C1;
        Sat, 22 Oct 2022 07:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424450;
        bh=rA4gQhD1vlVIuOg+qDE2RA9EQNMcPflJeXMhQw7nZmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAL21IIkoATmg96WmQmf9Xm3ARGyCSrIHP5alIpKJZQCGDA0KYOGQFXChnxvYp1Ys
         McQLfwEs9DXVPfVNVF8+gK0ErkAG4B1ytH/d5cTizeuZQ6ckUHVaEP42q41j00vzHN
         3VzjJqwXSVWnOE6qsANhS5y/HyPEwR8tlAzdloKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.19 150/717] tracing: Move duplicate code of trace_kprobe/eprobe.c into header
Date:   Sat, 22 Oct 2022 09:20:29 +0200
Message-Id: <20221022072442.014195241@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit f1d3cbfaafc10464550c6d3a125f4fc802bbaed5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c       |   60 +----------------------
 kernel/trace/trace_kprobe.c       |   60 +----------------------
 kernel/trace/trace_probe_kernel.h |   96 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+), 110 deletions(-)
 create mode 100644 kernel/trace/trace_probe_kernel.h

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -16,6 +16,7 @@
 #include "trace_dynevent.h"
 #include "trace_probe.h"
 #include "trace_probe_tmpl.h"
+#include "trace_probe_kernel.h"
 
 #define EPROBE_EVENT_SYSTEM "eprobes"
 
@@ -452,29 +453,14 @@ NOKPROBE_SYMBOL(process_fetch_insn)
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
@@ -484,21 +470,7 @@ fetch_store_strlen(unsigned long addr)
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
@@ -508,29 +480,7 @@ fetch_store_string_user(unsigned long ad
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
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -20,6 +20,7 @@
 #include "trace_kprobe_selftest.h"
 #include "trace_probe.h"
 #include "trace_probe_tmpl.h"
+#include "trace_probe_kernel.h"
 
 #define KPROBE_EVENT_SYSTEM "kprobes"
 #define KRETPROBE_MAXACTIVE_MAX 4096
@@ -1219,29 +1220,14 @@ static const struct file_operations kpro
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
@@ -1251,21 +1237,7 @@ fetch_store_strlen(unsigned long addr)
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
@@ -1275,29 +1247,7 @@ fetch_store_string_user(unsigned long ad
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



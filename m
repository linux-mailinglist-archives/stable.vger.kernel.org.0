Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D4C5FCE08
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 00:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiJLWD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 18:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiJLWCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 18:02:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F141125719;
        Wed, 12 Oct 2022 15:00:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E56A61632;
        Wed, 12 Oct 2022 22:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D97C433B5;
        Wed, 12 Oct 2022 22:00:35 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oijmW-0049Cc-0G;
        Wed, 12 Oct 2022 18:00:52 -0400
Message-ID: <20221012220051.926552531@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 12 Oct 2022 17:59:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>
Subject: [for-linus][PATCH 4/5] tracing: Add "(fault)" name injection to kernel probes
References: <20221012215911.735621065@goodmis.org>
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

Have the specific functions for kernel probes that read strings to inject
the "(fault)" name directly. trace_probes.c does this too (for uprobes)
but as the code to read strings are going to be used by synthetic events
(and perhaps other utilities), it simplifies the code by making sure those
other uses do not need to implement the "(fault)" name injection as well.

Link: https://lkml.kernel.org/r/20221012104534.644803645@goodmis.org

Cc: stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tom Zanussi <zanussi@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Fixes: bd82631d7ccdc ("tracing: Add support for dynamic strings to synthetic events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_probe_kernel.h | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_probe_kernel.h b/kernel/trace/trace_probe_kernel.h
index 1d43df29a1f8..77dbd9ff9782 100644
--- a/kernel/trace/trace_probe_kernel.h
+++ b/kernel/trace/trace_probe_kernel.h
@@ -2,6 +2,8 @@
 #ifndef __TRACE_PROBE_KERNEL_H_
 #define __TRACE_PROBE_KERNEL_H_
 
+#define FAULT_STRING "(fault)"
+
 /*
  * This depends on trace_probe.h, but can not include it due to
  * the way trace_probe_tmpl.h is used by trace_kprobe.c and trace_eprobe.c.
@@ -13,8 +15,16 @@ static nokprobe_inline int
 kern_fetch_store_strlen_user(unsigned long addr)
 {
 	const void __user *uaddr =  (__force const void __user *)addr;
+	int ret;
 
-	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
+	ret = strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
+	/*
+	 * strnlen_user_nofault returns zero on fault, insert the
+	 * FAULT_STRING when that occurs.
+	 */
+	if (ret <= 0)
+		return strlen(FAULT_STRING) + 1;
+	return ret;
 }
 
 /* Return the length of string -- including null terminal byte */
@@ -34,7 +44,18 @@ kern_fetch_store_strlen(unsigned long addr)
 		len++;
 	} while (c && ret == 0 && len < MAX_STRING_SIZE);
 
-	return (ret < 0) ? ret : len;
+	/* For faults, return enough to hold the FAULT_STRING */
+	return (ret < 0) ? strlen(FAULT_STRING) + 1 : len;
+}
+
+static nokprobe_inline void set_data_loc(int ret, void *dest, void *__dest, void *base, int len)
+{
+	if (ret >= 0) {
+		*(u32 *)dest = make_data_loc(ret, __dest - base);
+	} else {
+		strscpy(__dest, FAULT_STRING, len);
+		ret = strlen(__dest) + 1;
+	}
 }
 
 /*
@@ -55,8 +76,7 @@ kern_fetch_store_string_user(unsigned long addr, void *dest, void *base)
 	__dest = get_loc_data(dest, base);
 
 	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
-	if (ret >= 0)
-		*(u32 *)dest = make_data_loc(ret, __dest - base);
+	set_data_loc(ret, dest, __dest, base, maxlen);
 
 	return ret;
 }
@@ -87,8 +107,7 @@ kern_fetch_store_string(unsigned long addr, void *dest, void *base)
 	 * probing.
 	 */
 	ret = strncpy_from_kernel_nofault(__dest, (void *)addr, maxlen);
-	if (ret >= 0)
-		*(u32 *)dest = make_data_loc(ret, __dest - base);
+	set_data_loc(ret, dest, __dest, base, maxlen);
 
 	return ret;
 }
-- 
2.35.1

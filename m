Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3F360009E
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiJPPXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiJPPXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:23:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E3E27DE1
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:23:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 124D960BCA
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE121C433D6;
        Sun, 16 Oct 2022 15:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665933823;
        bh=BWy9yAu9JeJ2SqedReEjh+UA51xYelMSAp7qbWMJ0x8=;
        h=Subject:To:Cc:From:Date:From;
        b=HL9EHLb0cZubwHu2J0Dn900E59ZrjC677tcZCiTdsnt+KhYnORDdx2f2VzlOypg1R
         aM81oI7uCMzqCYS/QQ1GudZYzTUkyb2yBIHjZBq6KaFeVVcalSHMJTxmZQ+MdWZogt
         go13WjAPWHO8NZr9/1rUybgNcTeZqApv7wozDkUI=
Subject: FAILED: patch "[PATCH] tracing: Add "(fault)" name injection to kernel probes" failed to apply to 5.10-stable tree
To:     rostedt@goodmis.org, akpm@linux-foundation.org,
        mhiramat@kernel.org, zanussi@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:24:29 +0200
Message-ID: <166593386918829@kroah.com>
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

2e9906f84fc7 ("tracing: Add "(fault)" name injection to kernel probes")
f1d3cbfaafc1 ("tracing: Move duplicate code of trace_kprobe/eprobe.c into header")
7491e2c44278 ("tracing: Add a probe that attaches to trace events")
007517a01995 ("tracing/probe: Change traceprobe_set_print_fmt() to take a type")
bc87cf0a08d4 ("trace: Add a generic function to read/write u64 values from tracefs")
d262271d0483 ("tracing/dynevent: Delegate parsing to create function")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2e9906f84fc7c99388bb7123ade167250d50f1c0 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Wed, 12 Oct 2022 06:40:57 -0400
Subject: [PATCH] tracing: Add "(fault)" name injection to kernel probes

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


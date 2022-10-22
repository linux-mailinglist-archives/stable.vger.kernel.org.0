Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8C860871B
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbiJVH4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbiJVHyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:54:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD992C500F;
        Sat, 22 Oct 2022 00:47:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE13B60B8C;
        Sat, 22 Oct 2022 07:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4302C433C1;
        Sat, 22 Oct 2022 07:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424453;
        bh=a6b1NSqvH/b6gAlJZYFh0Q5qf/RCTEE7cuX29pmcyhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clXgU8gfLFw35OCd/ydkPh4ali+3CmLvxEVnESrFTv1pPOQAy71IljC7R2SvCH0la
         ew9moy1CBnDn0D4Tn0b9/Mvh5Y9GBpNkDiQrd2Mx9JdYBUzwwHSnNrfHWT1ecv+Poe
         pByMPprxXFVwrNP5g/up3uYdsZRkfMeL2I2mlRLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.19 151/717] tracing: Add "(fault)" name injection to kernel probes
Date:   Sat, 22 Oct 2022 09:20:30 +0200
Message-Id: <20221022072442.154265885@linuxfoundation.org>
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

commit 2e9906f84fc7c99388bb7123ade167250d50f1c0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe_kernel.h |   31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

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
@@ -34,7 +44,18 @@ kern_fetch_store_strlen(unsigned long ad
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
@@ -55,8 +76,7 @@ kern_fetch_store_string_user(unsigned lo
 	__dest = get_loc_data(dest, base);
 
 	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
-	if (ret >= 0)
-		*(u32 *)dest = make_data_loc(ret, __dest - base);
+	set_data_loc(ret, dest, __dest, base, maxlen);
 
 	return ret;
 }
@@ -87,8 +107,7 @@ kern_fetch_store_string(unsigned long ad
 	 * probing.
 	 */
 	ret = strncpy_from_kernel_nofault(__dest, (void *)addr, maxlen);
-	if (ret >= 0)
-		*(u32 *)dest = make_data_loc(ret, __dest - base);
+	set_data_loc(ret, dest, __dest, base, maxlen);
 
 	return ret;
 }



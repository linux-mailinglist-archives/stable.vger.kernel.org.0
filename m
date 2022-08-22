Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B7659C3E0
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 18:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbiHVQRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 12:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236091AbiHVQRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 12:17:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C084356DC
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 09:17:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 72937CE137A
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 16:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6F8C433C1;
        Mon, 22 Aug 2022 16:17:24 +0000 (UTC)
Date:   Mon, 22 Aug 2022 12:17:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, mhiramat@kernel.org, mingo@kernel.org,
        tz.stoyanov@gmail.com, zanussi@kernel.org, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing/probes: Have kprobes and uprobes
 use $COMM too" failed to apply to 5.10-stable tree
Message-ID: <20220822121740.03e5c1c9@gandalf.local.home>
In-Reply-To: <166115335415514@kroah.com>
References: <166115335415514@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Below is the backport to 5.10 and 5.4.

-- Steve

------------------ original commit in Linus's tree ------------------

>From ab8384442ee512fc0fc72deeb036110843d0e7ff Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Sat, 20 Aug 2022 09:43:21 -0400
Subject: [PATCH] tracing/probes: Have kprobes and uprobes use $COMM too

Both $comm and $COMM can be used to get current->comm in eprobes and the
filtering and histogram logic. Make kprobes and uprobes consistent in this
regard and allow both $comm and $COMM as well. Currently kprobes and
uprobes only handle $comm, which is inconsistent with the other utilities,
and can be confusing to users.

Link: https://lkml.kernel.org/r/20220820134401.317014913@goodmis.org
Link: https://lore.kernel.org/all/20220820220442.776e1ddaf8836e82edb34d01@kernel.org/

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Fixes: 533059281ee5 ("tracing: probeevent: Introduce new argument fetching code")
Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

---
 kernel/trace/trace_probe.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-test.git/kernel/trace/trace_probe.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace_probe.c	2022-08-22 11:11:31.068828616 -0400
+++ linux-test.git/kernel/trace/trace_probe.c	2022-08-22 11:13:36.916829113 -0400
@@ -300,7 +300,7 @@ static int parse_probe_vars(char *arg, c
 			}
 		} else
 			goto inval_var;
-	} else if (strcmp(arg, "comm") == 0) {
+	} else if (strcmp(arg, "comm") == 0 || strcmp(arg, "COMM") == 0) {
 		code->op = FETCH_OP_COMM;
 #ifdef CONFIG_HAVE_FUNCTION_ARG_ACCESS_API
 	} else if (((flags & TPARG_FL_MASK) ==
@@ -595,7 +595,8 @@ static int traceprobe_parse_probe_arg_bo
 	 * Since $comm and immediate string can not be dereferred,
 	 * we can find those by strcmp.
 	 */
-	if (strcmp(arg, "$comm") == 0 || strncmp(arg, "\\\"", 2) == 0) {
+	if (strcmp(arg, "$comm") == 0 || strcmp(arg, "$COMM") == 0 ||
+	    strncmp(arg, "\\\"", 2) == 0) {
 		/* The type of $comm must be "string", and not an array. */
 		if (parg->count || (t && strcmp(t, "string")))
 			return -EINVAL;

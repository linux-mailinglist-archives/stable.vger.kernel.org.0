Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506D359C440
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 18:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbiHVQhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 12:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiHVQhN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 12:37:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3B9419B5
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 09:37:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDB6661211
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 16:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAE9C433D6;
        Mon, 22 Aug 2022 16:37:10 +0000 (UTC)
Date:   Mon, 22 Aug 2022 12:37:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, mhiramat@kernel.org, mingo@kernel.org,
        tz.stoyanov@gmail.com, zanussi@kernel.org, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing/probes: Have kprobes and uprobes
 use $COMM too" failed to apply to 4.19-stable tree
Message-ID: <20220822123727.4345d71c@gandalf.local.home>
In-Reply-To: <16611533562143@kroah.com>
References: <16611533562143@kroah.com>
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


This is the backport for 4.19.

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
 kernel/trace/trace_probe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-test.git/kernel/trace/trace_probe.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace_probe.c	2022-08-22 12:13:58.964843406 -0400
+++ linux-test.git/kernel/trace/trace_probe.c	2022-08-22 12:15:44.808843824 -0400
@@ -361,7 +361,7 @@ static int parse_probe_vars(char *arg, c
 			}
 		} else
 			ret = -EINVAL;
-	} else if (strcmp(arg, "comm") == 0) {
+	} else if (strcmp(arg, "comm") == 0 || strcmp(arg, "COMM") == 0) {
 		if (strcmp(t->name, "string") != 0 &&
 		    strcmp(t->name, "string_size") != 0)
 			return -EINVAL;
@@ -544,7 +544,7 @@ int traceprobe_parse_probe_arg(char *arg
 	 * The default type of $comm should be "string", and it can't be
 	 * dereferenced.
 	 */
-	if (!t && strcmp(arg, "$comm") == 0)
+	if (!t && (strcmp(arg, "$comm") == 0 || strcmp(arg, "$COMM") == 0))
 		t = "string";
 	parg->type = find_fetch_type(t, ftbl);
 	if (!parg->type) {

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496B459BA41
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 09:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiHVH3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 03:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbiHVH32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 03:29:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB082A26A
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 00:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36B2260FE0
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 07:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F95C433D6;
        Mon, 22 Aug 2022 07:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661153366;
        bh=VPFfn6K5p+WcnggFLqHsa31woDbbbOjSreZPcov4cfE=;
        h=Subject:To:Cc:From:Date:From;
        b=Q6gEroGClCP1OCjrAgVG+3aMN172jIMDfqo52C5ngbQa82b9IQyNqqoAn7+V/CRMb
         K2ZDLrqt4+VZLIa20LHhOP95iH7LTS+wtD0REtcQOd66vw2cR2fE5NoeMSXraz9wbj
         9VVPKEuVsbuk8fsItnxL0H/X8RKc240IU6nZaTwk=
Subject: FAILED: patch "[PATCH] tracing/probes: Have kprobes and uprobes use $COMM too" failed to apply to 5.4-stable tree
To:     rostedt@goodmis.org, akpm@linux-foundation.org,
        mhiramat@kernel.org, mingo@kernel.org, tz.stoyanov@gmail.com,
        zanussi@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 09:29:15 +0200
Message-ID: <166115335579185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ab8384442ee512fc0fc72deeb036110843d0e7ff Mon Sep 17 00:00:00 2001
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

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 4daabbb8b772..36dff277de46 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -314,7 +314,7 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 			}
 		} else
 			goto inval_var;
-	} else if (strcmp(arg, "comm") == 0) {
+	} else if (strcmp(arg, "comm") == 0 || strcmp(arg, "COMM") == 0) {
 		code->op = FETCH_OP_COMM;
 #ifdef CONFIG_HAVE_FUNCTION_ARG_ACCESS_API
 	} else if (((flags & TPARG_FL_MASK) ==
@@ -625,7 +625,8 @@ static int traceprobe_parse_probe_arg_body(const char *argv, ssize_t *size,
 	 * we can find those by strcmp. But ignore for eprobes.
 	 */
 	if (!(flags & TPARG_FL_TPOINT) &&
-	    (strcmp(arg, "$comm") == 0 || strncmp(arg, "\\\"", 2) == 0)) {
+	    (strcmp(arg, "$comm") == 0 || strcmp(arg, "$COMM") == 0 ||
+	     strncmp(arg, "\\\"", 2) == 0)) {
 		/* The type of $comm must be "string", and not an array. */
 		if (parg->count || (t && strcmp(t, "string")))
 			goto out;


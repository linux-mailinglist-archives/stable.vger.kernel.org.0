Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA99759AE7F
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 15:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347303AbiHTNoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 09:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346970AbiHTNny (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 09:43:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2DE24F25;
        Sat, 20 Aug 2022 06:43:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63519B80CDE;
        Sat, 20 Aug 2022 13:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E870C43143;
        Sat, 20 Aug 2022 13:43:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oPOld-005AO3-1b;
        Sat, 20 Aug 2022 09:44:01 -0400
Message-ID: <20220820134401.317014913@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 20 Aug 2022 09:43:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 5/6] tracing/probes: Have kprobes and uprobes use $COMM too
References: <20220820134316.156058831@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Both $comm and $COMM can be used to get current->comm in eprobes and the
filtering and histogram logic. Make kprobes and uprobes consistent in this
regard and allow both $comm and $COMM as well. Currently kprobes and
uprobes only handle $comm, which is inconsistent with the other utilities,
and can be confusing to users.

Link: https://lore.kernel.org/all/20220820220442.776e1ddaf8836e82edb34d01@kernel.org/

Cc: stable@vger.kernel.org
Fixes: 533059281ee5 ("tracing: probeevent: Introduce new argument fetching code")
Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_probe.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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
-- 
2.35.1

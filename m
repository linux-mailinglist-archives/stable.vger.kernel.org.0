Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63605F5EB1
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 04:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiJFCVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 22:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiJFCVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 22:21:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF754685C;
        Wed,  5 Oct 2022 19:21:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2BF7617E1;
        Thu,  6 Oct 2022 02:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F506C433D7;
        Thu,  6 Oct 2022 02:21:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1ogGWI-002gPP-0m;
        Wed, 05 Oct 2022 22:21:54 -0400
Message-ID: <20221006022154.075407402@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 05 Oct 2022 22:21:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [for-next][PATCH 1/2] ftrace: Still disable enabled records marked as disabled
References: <20221006022126.894976366@goodmis.org>
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

Weak functions started causing havoc as they showed up in the
"available_filter_functions" and this confused people as to why some
functions marked as "notrace" were listed, but when enabled they did
nothing. This was because weak functions can still have fentry calls, and
these addresses get added to the "available_filter_functions" file.
kallsyms is what converts those addresses to names, and since the weak
functions are not listed in kallsyms, it would just pick the function
before that.

To solve this, there was a trick to detect weak functions listed, and
these records would be marked as DISABLED so that they do not get enabled
and are mostly ignored. As the processing of the list of all functions to
figure out what is weak or not can take a long time, this process is put
off into a kernel thread and run in parallel with the rest of start up.

Now the issue happens whet function tracing is enabled via the kernel
command line. As it starts very early in boot up, it can be enabled before
the records that are weak are marked to be disabled. This causes an issue
in the accounting, as the weak records are enabled by the command line
function tracing, but after boot up, they are not disabled.

The ftrace records have several accounting flags and a ref count. The
DISABLED flag is just one. If the record is enabled before it is marked
DISABLED it will get an ENABLED flag and also have its ref counter
incremented. After it is marked for DISABLED, neither the ENABLED flag nor
the ref counter is cleared. There's sanity checks on the records that are
performed after an ftrace function is registered or unregistered, and this
detected that there were records marked as ENABLED with ref counter that
should not have been.

Note, the module loading code uses the DISABLED flag as well to keep its
functions from being modified while its being loaded and some of these
flags may get set in this process. So changing the verification code to
ignore DISABLED records is a no go, as it still needs to verify that the
module records are working too.

Also, the weak functions still are calling a trampoline. Even though they
should never be called, it is dangerous to leave these weak functions
calling a trampoline that is freed, so they should still be set back to
nops.

There's two places that need to not skip records that have the ENABLED
and the DISABLED flags set. That is where the ftrace_ops is processed and
sets the records ref counts, and then later when the function itself is to
be updated, and the ENABLED flag gets removed. Add a helper function
"skip_record()" that returns true if the record has the DISABLED flag set
but not the ENABLED flag.

Link: https://lkml.kernel.org/r/20221005003809.27d2b97b@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Fixes: b39181f7c6907 ("ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding weak function")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 406d0597c409..83362a155791 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1644,6 +1644,18 @@ ftrace_find_tramp_ops_any_other(struct dyn_ftrace *rec, struct ftrace_ops *op_ex
 static struct ftrace_ops *
 ftrace_find_tramp_ops_next(struct dyn_ftrace *rec, struct ftrace_ops *ops);
 
+static bool skip_record(struct dyn_ftrace *rec)
+{
+	/*
+	 * At boot up, weak functions are set to disable. Function tracing
+	 * can be enabled before they are, and they still need to be disabled now.
+	 * If the record is disabled, still continue if it is marked as already
+	 * enabled (this is needed to keep the accounting working).
+	 */
+	return rec->flags & FTRACE_FL_DISABLED &&
+		!(rec->flags & FTRACE_FL_ENABLED);
+}
+
 static bool __ftrace_hash_rec_update(struct ftrace_ops *ops,
 				     int filter_hash,
 				     bool inc)
@@ -1693,7 +1705,7 @@ static bool __ftrace_hash_rec_update(struct ftrace_ops *ops,
 		int in_hash = 0;
 		int match = 0;
 
-		if (rec->flags & FTRACE_FL_DISABLED)
+		if (skip_record(rec))
 			continue;
 
 		if (all) {
@@ -2126,7 +2138,7 @@ static int ftrace_check_record(struct dyn_ftrace *rec, bool enable, bool update)
 
 	ftrace_bug_type = FTRACE_BUG_UNKNOWN;
 
-	if (rec->flags & FTRACE_FL_DISABLED)
+	if (skip_record(rec))
 		return FTRACE_UPDATE_IGNORE;
 
 	/*
@@ -2241,7 +2253,7 @@ static int ftrace_check_record(struct dyn_ftrace *rec, bool enable, bool update)
 	if (update) {
 		/* If there's no more users, clear all flags */
 		if (!ftrace_rec_count(rec))
-			rec->flags = 0;
+			rec->flags &= FTRACE_FL_DISABLED;
 		else
 			/*
 			 * Just disable the record, but keep the ops TRAMP
@@ -2634,7 +2646,7 @@ void __weak ftrace_replace_code(int mod_flags)
 
 	do_for_each_ftrace_rec(pg, rec) {
 
-		if (rec->flags & FTRACE_FL_DISABLED)
+		if (skip_record(rec))
 			continue;
 
 		failed = __ftrace_replace_code(rec, enable);
-- 
2.35.1

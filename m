Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36135608603
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiJVHnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbiJVHml (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:42:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E7E2AF664;
        Sat, 22 Oct 2022 00:41:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D696DB82DFA;
        Sat, 22 Oct 2022 07:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297F1C433C1;
        Sat, 22 Oct 2022 07:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424418;
        bh=n0fGfRBiT9uOih5KFRg5N8AxE8nZsfp4iCYMC7KBs8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XtPcmWPL0lpmEDGSY4jr7pHxo2P2oZAhKnmaa7g4EV6nfcDM+t5lU9vqEn02LpOAu
         bJcthNXfN/+Rc+rKCqv63Ye6vmbDhFBPyIXf0ZWjmbPt37XofmXZEWEC6YgiphX93T
         qmp5+acZSClgi1YIIslYetf83JlYeylIboIYMNlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.19 139/717] ftrace: Still disable enabled records marked as disabled
Date:   Sat, 22 Oct 2022 09:20:18 +0200
Message-Id: <20221022072440.144700622@linuxfoundation.org>
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

commit cf04f2d5df0037741207382ac8fe289e8bf84ced upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1644,6 +1644,18 @@ ftrace_find_tramp_ops_any_other(struct d
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
@@ -1693,7 +1705,7 @@ static bool __ftrace_hash_rec_update(str
 		int in_hash = 0;
 		int match = 0;
 
-		if (rec->flags & FTRACE_FL_DISABLED)
+		if (skip_record(rec))
 			continue;
 
 		if (all) {
@@ -2090,7 +2102,7 @@ static int ftrace_check_record(struct dy
 
 	ftrace_bug_type = FTRACE_BUG_UNKNOWN;
 
-	if (rec->flags & FTRACE_FL_DISABLED)
+	if (skip_record(rec))
 		return FTRACE_UPDATE_IGNORE;
 
 	/*
@@ -2205,7 +2217,7 @@ static int ftrace_check_record(struct dy
 	if (update) {
 		/* If there's no more users, clear all flags */
 		if (!ftrace_rec_count(rec))
-			rec->flags = 0;
+			rec->flags &= FTRACE_FL_DISABLED;
 		else
 			/*
 			 * Just disable the record, but keep the ops TRAMP
@@ -2599,7 +2611,7 @@ void __weak ftrace_replace_code(int mod_
 
 	do_for_each_ftrace_rec(pg, rec) {
 
-		if (rec->flags & FTRACE_FL_DISABLED)
+		if (skip_record(rec))
 			continue;
 
 		failed = __ftrace_replace_code(rec, enable);



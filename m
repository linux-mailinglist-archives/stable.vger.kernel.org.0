Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C571C65D52D
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbjADOMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239543AbjADOLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:11:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB58E3FA0B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:10:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 769B0B81677
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6DAC433D2;
        Wed,  4 Jan 2023 14:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672841434;
        bh=9XGrOlaIKqpLvJbwv6KGadxa7z8TIAyukj81KdN/SjI=;
        h=Subject:To:Cc:From:Date:From;
        b=lqwpboJ3TZYwGmeNlldw0veuDvM1umhrkBmvuNZQSjwLod1AWUoWL3QJwnNfyYZQw
         Lbmw8smUmwG5sYwUltSpJVJCSjYpRaeUzVK0Vo/cFoYR4U+SPWz4t4/F+m1icc0Apz
         KOMYwr8OuFowkJ4mw1XcIFfVLOaquXJfdo2TVpPg=
Subject: FAILED: patch "[PATCH] tracing/probes: Handle system names with hyphens" failed to apply to 5.4-stable tree
To:     rostedt@goodmis.org, mhiramat@kernel.org, rafaelmendsr@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:10:23 +0100
Message-ID: <167284142318334@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

575b76cb8855 ("tracing/probes: Handle system names with hyphens")
7491e2c44278 ("tracing: Add a probe that attaches to trace events")
007517a01995 ("tracing/probe: Change traceprobe_set_print_fmt() to take a type")
bc87cf0a08d4 ("trace: Add a generic function to read/write u64 values from tracefs")
d262271d0483 ("tracing/dynevent: Delegate parsing to create function")
d4d704637d93 ("tracing: Add synthetic event error logging")
9bbb33291f8e ("tracing: Check that the synthetic event and field names are legal")
42d120e2dda5 ("tracing: Move is_good_name() from trace_probe.h to trace.h")
bd82631d7ccd ("tracing: Add support for dynamic strings to synthetic events")
8fbeb52a598c ("tracing: Fix parse_synth_field() error handling")
3aa8fdc37d16 ("tracing/probe: Fix memleak in fetch_op_data operations")
726721a51838 ("tracing: Move synthetic events to a separate file")
1b94b3aed367 ("tracing: Check state.disabled in synth event trace functions")
91ad64a84e9e ("Merge tag 'trace-v5.6-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 575b76cb885532aae13a9d979fd476bb2b156cb9 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Tue, 22 Nov 2022 12:23:45 -0500
Subject: [PATCH] tracing/probes: Handle system names with hyphens

When creating probe names, a check is done to make sure it matches basic C
standard variable naming standards. Basically, starts with alphabetic or
underline, and then the rest of the characters have alpha-numeric or
underline in them.

But system names do not have any true naming conventions, as they are
created by the TRACE_SYSTEM macro and nothing tests to see what they are.
The "xhci-hcd" trace events has a '-' in the system name. When trying to
attach a eprobe to one of these trace points, it fails because the system
name does not follow the variable naming convention because of the
hyphen, and the eprobe checks fail on this.

Allow hyphens in the system name so that eprobes can attach to the
"xhci-hcd" trace events.

Link: https://lore.kernel.org/all/Y3eJ8GiGnEvVd8%2FN@macondo/
Link: https://lore.kernel.org/linux-trace-kernel/20221122122345.160f5077@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 5b7a96220900e ("tracing/probe: Check event/group naming rule at parsing")
Reported-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 48643f07bc01..8f37ff032b4f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1954,17 +1954,30 @@ static __always_inline void trace_iterator_reset(struct trace_iterator *iter)
 }
 
 /* Check the name is good for event/group/fields */
-static inline bool is_good_name(const char *name)
+static inline bool __is_good_name(const char *name, bool hash_ok)
 {
-	if (!isalpha(*name) && *name != '_')
+	if (!isalpha(*name) && *name != '_' && (!hash_ok || *name != '-'))
 		return false;
 	while (*++name != '\0') {
-		if (!isalpha(*name) && !isdigit(*name) && *name != '_')
+		if (!isalpha(*name) && !isdigit(*name) && *name != '_' &&
+		    (!hash_ok || *name != '-'))
 			return false;
 	}
 	return true;
 }
 
+/* Check the name is good for event/group/fields */
+static inline bool is_good_name(const char *name)
+{
+	return __is_good_name(name, false);
+}
+
+/* Check the name is good for system */
+static inline bool is_good_system_name(const char *name)
+{
+	return __is_good_name(name, true);
+}
+
 /* Convert certain expected symbols into '_' when generating event names */
 static inline void sanitize_event_name(char *name)
 {
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 36dff277de46..bb2f95d7175c 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -246,7 +246,7 @@ int traceprobe_parse_event_name(const char **pevent, const char **pgroup,
 			return -EINVAL;
 		}
 		strlcpy(buf, event, slash - event + 1);
-		if (!is_good_name(buf)) {
+		if (!is_good_system_name(buf)) {
 			trace_probe_log_err(offset, BAD_GROUP_NAME);
 			return -EINVAL;
 		}


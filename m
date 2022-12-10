Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BAF648EFC
	for <lists+stable@lfdr.de>; Sat, 10 Dec 2022 14:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiLJN6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Dec 2022 08:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiLJN61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Dec 2022 08:58:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CC6275;
        Sat, 10 Dec 2022 05:58:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FD6560C21;
        Sat, 10 Dec 2022 13:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D709EC43445;
        Sat, 10 Dec 2022 13:58:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1p40My-000kpL-2w;
        Sat, 10 Dec 2022 08:58:24 -0500
Message-ID: <20221210135824.775707099@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 10 Dec 2022 08:58:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Rafael Mendonca <rafaelmendsr@gmail.com>
Subject: [for-next][PATCH 10/25] tracing/probes: Handle system names with hyphens
References: <20221210135750.425719934@goodmis.org>
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
---
 kernel/trace/trace.h       | 19 ++++++++++++++++---
 kernel/trace/trace_probe.c |  2 +-
 2 files changed, 17 insertions(+), 4 deletions(-)

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
-- 
2.35.1



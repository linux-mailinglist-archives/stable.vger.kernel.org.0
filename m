Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0321C97FB
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 19:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgEGRjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 13:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727117AbgEGRja (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 13:39:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0526724959;
        Thu,  7 May 2020 17:39:30 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jWkUa-000DnC-UH; Thu, 07 May 2020 13:39:28 -0400
Message-ID: <20200507173928.816083926@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 07 May 2020 13:39:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [for-linus][PATCH 4/9] tracing/kprobes: Reject new event if loc is NULL
References: <20200507173904.729935165@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

Reject the new event which has NULL location for kprobes.
For kprobes, user must specify at least the location.

Link: http://lkml.kernel.org/r/158779376597.6082.1411212055469099461.stgit@devnote2

Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 2a588dd1d5d6 ("tracing: Add kprobe event command generation functions")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 0d9300c3b084..35989383ae11 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -940,6 +940,9 @@ EXPORT_SYMBOL_GPL(kprobe_event_cmd_init);
  * complete command or only the first part of it; in the latter case,
  * kprobe_event_add_fields() can be used to add more fields following this.
  *
+ * Unlikely the synth_event_gen_cmd_start(), @loc must be specified. This
+ * returns -EINVAL if @loc == NULL.
+ *
  * Return: 0 if successful, error otherwise.
  */
 int __kprobe_event_gen_cmd_start(struct dynevent_cmd *cmd, bool kretprobe,
@@ -953,6 +956,9 @@ int __kprobe_event_gen_cmd_start(struct dynevent_cmd *cmd, bool kretprobe,
 	if (cmd->type != DYNEVENT_TYPE_KPROBE)
 		return -EINVAL;
 
+	if (!loc)
+		return -EINVAL;
+
 	if (kretprobe)
 		snprintf(buf, MAX_EVENT_NAME_LEN, "r:kprobes/%s", name);
 	else
-- 
2.26.2



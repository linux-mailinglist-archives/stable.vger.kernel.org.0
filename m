Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3860A20E6F3
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391451AbgF2VwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgF2Sfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B9A4247CA;
        Mon, 29 Jun 2020 15:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444135;
        bh=MouZSTVrUh0LDNHZw9RYHNyEcfZHloCjp7rQlYscy9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XH8p8jSRkJ+jfTF/dRoMV6i2WLIPNkNjiW7oRa2V2DRgVBMcXyfGrNj2A7BG//0zF
         x+XA3PpESEFIp0IUfQq6R666UI6VQK0ikQ+UvNMNDAEQMIRlqcdkYhqIxllQO0chAu
         gliNhtui64tM8f3VIDp/IGindt7PfRMkuBM0dwAA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 242/265] tracing: Fix event trigger to accept redundant spaces
Date:   Mon, 29 Jun 2020 11:17:55 -0400
Message-Id: <20200629151818.2493727-243-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 6784beada631800f2c5afd567e5628c843362cee upstream.

Fix the event trigger to accept redundant spaces in
the trigger input.

For example, these return -EINVAL

echo " traceon" > events/ftrace/print/trigger
echo "traceon  if common_pid == 0" > events/ftrace/print/trigger
echo "disable_event:kmem:kmalloc " > events/ftrace/print/trigger

But these are hard to find what is wrong.

To fix this issue, use skip_spaces() to remove spaces
in front of actual tokens, and set NULL if there is no
token.

Link: http://lkml.kernel.org/r/159262476352.185015.5261566783045364186.stgit@devnote2

Cc: Tom Zanussi <zanussi@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 85f2b08268c0 ("tracing: Add basic event trigger framework")
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_trigger.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 3a74736da363a..f725802160c0b 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -216,11 +216,17 @@ static int event_trigger_regex_open(struct inode *inode, struct file *file)
 
 int trigger_process_regex(struct trace_event_file *file, char *buff)
 {
-	char *command, *next = buff;
+	char *command, *next;
 	struct event_command *p;
 	int ret = -EINVAL;
 
+	next = buff = skip_spaces(buff);
 	command = strsep(&next, ": \t");
+	if (next) {
+		next = skip_spaces(next);
+		if (!*next)
+			next = NULL;
+	}
 	command = (command[0] != '!') ? command : command + 1;
 
 	mutex_lock(&trigger_cmd_mutex);
@@ -630,8 +636,14 @@ event_trigger_callback(struct event_command *cmd_ops,
 	int ret;
 
 	/* separate the trigger from the filter (t:n [if filter]) */
-	if (param && isdigit(param[0]))
+	if (param && isdigit(param[0])) {
 		trigger = strsep(&param, " \t");
+		if (param) {
+			param = skip_spaces(param);
+			if (!*param)
+				param = NULL;
+		}
+	}
 
 	trigger_ops = cmd_ops->get_trigger_ops(cmd, trigger);
 
@@ -1368,6 +1380,11 @@ int event_enable_trigger_func(struct event_command *cmd_ops,
 	trigger = strsep(&param, " \t");
 	if (!trigger)
 		return -EINVAL;
+	if (param) {
+		param = skip_spaces(param);
+		if (!*param)
+			param = NULL;
+	}
 
 	system = strsep(&trigger, ":");
 	if (!trigger)
-- 
2.25.1


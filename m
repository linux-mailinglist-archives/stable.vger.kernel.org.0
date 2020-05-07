Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674EE1C97FC
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 19:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgEGRjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 13:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgEGRja (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 13:39:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7B2D24955;
        Thu,  7 May 2020 17:39:29 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jWkUa-000Dmg-Pc; Thu, 07 May 2020 13:39:28 -0400
Message-ID: <20200507173928.673562862@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 07 May 2020 13:39:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [for-linus][PATCH 3/9] tracing/boottime: Fix kprobe event API usage
References: <20200507173904.729935165@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

Fix boottime kprobe events to use API correctly for
multiple events.

For example, when we set a multiprobe kprobe events in
bootconfig like below,

  ftrace.event.kprobes.myevent {
  	probes = "vfs_read $arg1 $arg2", "vfs_write $arg1 $arg2"
  }

This cause an error;

  trace_boot: Failed to add probe: p:kprobes/myevent (null)  vfs_read $arg1 $arg2  vfs_write $arg1 $arg2

This shows the 1st argument becomes NULL and multiprobes
are merged to 1 probe.

Link: http://lkml.kernel.org/r/158779375766.6082.201939936008972838.stgit@devnote2

Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 29a154810546 ("tracing: Change trace_boot to use kprobe_event interface")
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_boot.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 06d7feb5255f..9de29bb45a27 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -95,24 +95,20 @@ trace_boot_add_kprobe_event(struct xbc_node *node, const char *event)
 	struct xbc_node *anode;
 	char buf[MAX_BUF_LEN];
 	const char *val;
-	int ret;
+	int ret = 0;
 
-	kprobe_event_cmd_init(&cmd, buf, MAX_BUF_LEN);
+	xbc_node_for_each_array_value(node, "probes", anode, val) {
+		kprobe_event_cmd_init(&cmd, buf, MAX_BUF_LEN);
 
-	ret = kprobe_event_gen_cmd_start(&cmd, event, NULL);
-	if (ret)
-		return ret;
+		ret = kprobe_event_gen_cmd_start(&cmd, event, val);
+		if (ret)
+			break;
 
-	xbc_node_for_each_array_value(node, "probes", anode, val) {
-		ret = kprobe_event_add_field(&cmd, val);
+		ret = kprobe_event_gen_cmd_end(&cmd);
 		if (ret)
-			return ret;
+			pr_err("Failed to add probe: %s\n", buf);
 	}
 
-	ret = kprobe_event_gen_cmd_end(&cmd);
-	if (ret)
-		pr_err("Failed to add probe: %s\n", buf);
-
 	return ret;
 }
 #else
-- 
2.26.2



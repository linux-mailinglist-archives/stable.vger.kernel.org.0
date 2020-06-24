Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679C8206AB8
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 05:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388572AbgFXDjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 23:39:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388575AbgFXDjf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 23:39:35 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05D5020FC3;
        Wed, 24 Jun 2020 03:39:35 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jnwG6-003uA8-2C; Tue, 23 Jun 2020 23:39:34 -0400
Message-ID: <20200624033933.949590227@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 23 Jun 2020 23:39:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, linux-kernel@i4.cs.fau.de,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Maximilian Werner <maximilian.werner96@gmail.com>,
        Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de>
Subject: [for-linus][PATCH 4/4] tracing/boottime: Fix kprobe multiple events
References: <20200624033858.651927570@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de>

Fix boottime kprobe events to report and abort after each failure when
adding probes.

As an example, when we try to set multiprobe kprobe events in
bootconfig like this:

ftrace.event.kprobes.vfsevents {
        probes = "vfs_read $arg1 $arg2,,
                 !error! not reported;?", // leads to error
                 "vfs_write $arg1 $arg2"
}

This will not work as expected. After
commit da0f1f4167e3af69e ("tracing/boottime: Fix kprobe event API usage"),
the function trace_boot_add_kprobe_event will not produce any error
message when adding a probe fails at kprobe_event_gen_cmd_start.
Furthermore, we continue to add probes when kprobe_event_gen_cmd_end fails
(and kprobe_event_gen_cmd_start did not fail). In this case the function
even returns successfully when the last call to kprobe_event_gen_cmd_end
is successful.

The behaviour of reporting and aborting after failures is not
consistent.

The function trace_boot_add_kprobe_event now reports each failure and
stops adding probes immediately.

Link: https://lkml.kernel.org/r/20200618163301.25854-1-sascha.ortmann@stud.uni-hannover.de

Cc: stable@vger.kernel.org
Cc: linux-kernel@i4.cs.fau.de
Co-developed-by: Maximilian Werner <maximilian.werner96@gmail.com>
Fixes: da0f1f4167e3 ("tracing/boottime: Fix kprobe event API usage")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Maximilian Werner <maximilian.werner96@gmail.com>
Signed-off-by: Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_boot.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 8b5490cb02bb..fa0fc08c6ef8 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -101,12 +101,16 @@ trace_boot_add_kprobe_event(struct xbc_node *node, const char *event)
 		kprobe_event_cmd_init(&cmd, buf, MAX_BUF_LEN);
 
 		ret = kprobe_event_gen_cmd_start(&cmd, event, val);
-		if (ret)
+		if (ret) {
+			pr_err("Failed to generate probe: %s\n", buf);
 			break;
+		}
 
 		ret = kprobe_event_gen_cmd_end(&cmd);
-		if (ret)
+		if (ret) {
 			pr_err("Failed to add probe: %s\n", buf);
+			break;
+		}
 	}
 
 	return ret;
-- 
2.26.2



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E810B8807
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 01:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406653AbfISXYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 19:24:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405687AbfISXYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 19:24:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3624D21929;
        Thu, 19 Sep 2019 23:24:01 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1iB5mK-0000hZ-DF; Thu, 19 Sep 2019 19:24:00 -0400
Message-Id: <20190919232400.299074257@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 19 Sep 2019 19:23:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
Subject: [for-next][PATCH 6/8] tracing/probe: Fix to allow user to enable events on unloaded modules
References: <20190919232313.198902049@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

Fix to allow user to enable probe events on unloaded modules.

This operations was allowed before commit 60d53e2c3b75 ("tracing/probe:
Split trace_event related data from trace_probe"), because if users
need to probe module init functions, they have to enable those probe
events before loading module.

Link: http://lkml.kernel.org/r/156879693733.31056.9331322616994665167.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: 60d53e2c3b75 ("tracing/probe: Split trace_event related data from trace_probe")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7579c53bb053..0ba3239c0270 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -371,31 +371,24 @@ static int enable_trace_kprobe(struct trace_event_call *call,
 	if (enabled)
 		return 0;
 
-	enabled = false;
 	list_for_each_entry(pos, trace_probe_probe_list(tp), list) {
 		tk = container_of(pos, struct trace_kprobe, tp);
 		if (trace_kprobe_has_gone(tk))
 			continue;
 		ret = __enable_trace_kprobe(tk);
-		if (ret) {
-			if (enabled) {
-				__disable_trace_kprobe(tp);
-				enabled = false;
-			}
+		if (ret)
 			break;
-		}
 		enabled = true;
 	}
 
-	if (!enabled) {
-		/* No probe is enabled. Roll back */
+	if (ret) {
+		/* Failed to enable one of them. Roll back all */
+		if (enabled)
+			__disable_trace_kprobe(tp);
 		if (file)
 			trace_probe_remove_file(tp, file);
 		else
 			trace_probe_clear_flag(tp, TP_FLAG_PROFILE);
-		if (!ret)
-			/* Since all probes are gone, this is not available */
-			ret = -EADDRNOTAVAIL;
 	}
 
 	return ret;
-- 
2.20.1



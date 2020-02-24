Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF70816AD28
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 18:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgBXRVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 12:21:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727903AbgBXRVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Feb 2020 12:21:18 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00DB424650;
        Mon, 24 Feb 2020 17:21:18 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1j6HPw-001AeM-Ts; Mon, 24 Feb 2020 12:21:16 -0500
Message-Id: <20200224172116.787739363@goodmis.org>
User-Agent: quilt/0.65
Date:   Mon, 24 Feb 2020 12:20:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        stable@vger.kernel.org
Subject: [for-linus][PATCH 06/15] tracing: Disable trace_printk() on post poned tests
References: <20200224172022.330525468@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The tracing seftests checks various aspects of the tracing infrastructure,
and one is filtering. If trace_printk() is active during a self test, it can
cause the filtering to fail, which will disable that part of the trace.

To keep the selftests from failing because of trace_printk() calls,
trace_printk() checks the variable tracing_selftest_running, and if set, it
does not write to the tracing buffer.

As some tracers were registered earlier in boot, the selftest they triggered
would fail because not all the infrastructure was set up for the full
selftest. Thus, some of the tests were post poned to when their
infrastructure was ready (namely file system code). The postpone code did
not set the tracing_seftest_running variable, and could fail if a
trace_printk() was added and executed during their run.

Cc: stable@vger.kernel.org
Fixes: 9afecfbb95198 ("tracing: Postpone tracer start-up tests till the system is more robust")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 183b031a3828..a89c562ffb8f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1837,6 +1837,7 @@ static __init int init_trace_selftests(void)
 
 	pr_info("Running postponed tracer tests:\n");
 
+	tracing_selftest_running = true;
 	list_for_each_entry_safe(p, n, &postponed_selftests, list) {
 		/* This loop can take minutes when sanitizers are enabled, so
 		 * lets make sure we allow RCU processing.
@@ -1859,6 +1860,7 @@ static __init int init_trace_selftests(void)
 		list_del(&p->list);
 		kfree(p);
 	}
+	tracing_selftest_running = false;
 
  out:
 	mutex_unlock(&trace_types_lock);
-- 
2.25.0



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFA4B143FBF
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 15:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgAUOj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 09:39:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729096AbgAUOj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jan 2020 09:39:58 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 453C72467C;
        Tue, 21 Jan 2020 14:39:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1ituhB-000dz4-5x; Tue, 21 Jan 2020 09:39:57 -0500
Message-Id: <20200121143957.062447110@goodmis.org>
User-Agent: quilt/0.65
Date:   Tue, 21 Jan 2020 09:38:52 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Masami Ichikawa <masami256@gmail.com>
Subject: [for-linus][PATCH 5/5] tracing: Do not set trace clock if tracefs lockdown is in effect
References: <20200121143847.609307852@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Ichikawa <masami256@gmail.com>

When trace_clock option is not set and unstable clcok detected,
tracing_set_default_clock() sets trace_clock(ThinkPad A285 is one of
case). In that case, if lockdown is in effect, null pointer
dereference error happens in ring_buffer_set_clock().

Link: http://lkml.kernel.org/r/20200116131236.3866925-1-masami256@gmail.com

Cc: stable@vger.kernel.org
Fixes: 17911ff38aa58 ("tracing: Add locked_down checks to the open calls of files created for tracefs")
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1788488
Signed-off-by: Masami Ichikawa <masami256@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ddb7e7f5fe8d..5b6ee4aadc26 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9420,6 +9420,11 @@ __init static int tracing_set_default_clock(void)
 {
 	/* sched_clock_stable() is determined in late_initcall */
 	if (!trace_boot_clock && !sched_clock_stable()) {
+		if (security_locked_down(LOCKDOWN_TRACEFS)) {
+			pr_warn("Can not set tracing clock due to lockdown\n");
+			return -EPERM;
+		}
+
 		printk(KERN_WARNING
 		       "Unstable clock detected, switching default tracing clock to \"global\"\n"
 		       "If you want to keep using the local clock, then add:\n"
-- 
2.24.1



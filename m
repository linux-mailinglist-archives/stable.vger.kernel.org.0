Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2103ACC0A
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 15:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhFRNXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 09:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232723AbhFRNXg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 09:23:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC0D3613EC;
        Fri, 18 Jun 2021 13:21:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1luER3-003VF6-V6; Fri, 18 Jun 2021 09:21:25 -0400
Message-ID: <20210618132125.796134019@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 18 Jun 2021 09:20:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [for-linus][PATCH 2/4] tracing: Do not stop recording cmdlines when tracing is off
References: <20210618132046.600413369@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The saved_cmdlines is used to map pids to the task name, such that the
output of the tracing does not just show pids, but also gives a human
readable name for the task.

If the name is not mapped, the output looks like this:

    <...>-1316          [005] ...2   132.044039: ...

Instead of this:

    gnome-shell-1316    [005] ...2   132.044039: ...

The names are updated when tracing is running, but are skipped if tracing
is stopped. Unfortunately, this stops the recording of the names if the
top level tracer is stopped, and not if there's other tracers active.

The recording of a name only happens when a new event is written into a
ring buffer, so there is no need to test if tracing is on or not. If
tracing is off, then no event is written and no need to test if tracing is
off or not.

Remove the check, as it hides the names of tasks for events in the
instance buffers.

Cc: stable@vger.kernel.org
Fixes: 7ffbd48d5cab2 ("tracing: Cache comms only after an event occurred")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9299057feb56..e220b37e29c6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2486,8 +2486,6 @@ static bool tracing_record_taskinfo_skip(int flags)
 {
 	if (unlikely(!(flags & (TRACE_RECORD_CMDLINE | TRACE_RECORD_TGID))))
 		return true;
-	if (atomic_read(&trace_record_taskinfo_disabled) || !tracing_is_on())
-		return true;
 	if (!__this_cpu_read(trace_taskinfo_save))
 		return true;
 	return false;
-- 
2.30.2

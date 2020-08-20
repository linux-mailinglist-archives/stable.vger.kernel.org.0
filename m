Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF0D24BC1A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgHTJrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729389AbgHTJrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:47:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 048AD20724;
        Thu, 20 Aug 2020 09:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916824;
        bh=deq8yjCJDG8hwhZ8bxTLDfbAbLOszTp7MSKDmQytPtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpXjdeWeMrp430veB2dB+gxZK05IRYnsSt2Qi3WUtR70Tftzq2u/pCsayl95rwKVm
         +U94kECPG6lxOFQDLdRuz5dYP+HSkZaZ2LfqzgjzOX+C3w1xunejT64J0MexeJ4weN
         JIwtzNnv15/R9P+2jDkMSafs5Vi6OO5HMo3n+ICM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 060/152] tracing: Use trace_sched_process_free() instead of exit() for pid tracing
Date:   Thu, 20 Aug 2020 11:20:27 +0200
Message-Id: <20200820091556.794463417@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit afcab636657421f7ebfa0783a91f90256bba0091 upstream.

On exit, if a process is preempted after the trace_sched_process_exit()
tracepoint but before the process is done exiting, then when it gets
scheduled in, the function tracers will not filter it properly against the
function tracing pid filters.

That is because the function tracing pid filters hooks to the
sched_process_exit() tracepoint to remove the exiting task's pid from the
filter list. Because the filtering happens at the sched_switch tracepoint,
when the exiting task schedules back in to finish up the exit, it will no
longer be in the function pid filtering tables.

This was noticeable in the notrace self tests on a preemptable kernel, as
the tests would fail as it exits and preempted after being taken off the
notrace filter table and on scheduling back in it would not be in the
notrace list, and then the ending of the exit function would trace. The test
detected this and would fail.

Cc: stable@vger.kernel.org
Cc: Namhyung Kim <namhyung@kernel.org>
Fixes: 1e10486ffee0a ("ftrace: Add 'function-fork' trace option")
Fixes: c37775d57830a ("tracing: Add infrastructure to allow set_event_pid to follow children"
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c       |    4 ++--
 kernel/trace/trace_events.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6462,12 +6462,12 @@ void ftrace_pid_follow_fork(struct trace
 	if (enable) {
 		register_trace_sched_process_fork(ftrace_pid_follow_sched_process_fork,
 						  tr);
-		register_trace_sched_process_exit(ftrace_pid_follow_sched_process_exit,
+		register_trace_sched_process_free(ftrace_pid_follow_sched_process_exit,
 						  tr);
 	} else {
 		unregister_trace_sched_process_fork(ftrace_pid_follow_sched_process_fork,
 						    tr);
-		unregister_trace_sched_process_exit(ftrace_pid_follow_sched_process_exit,
+		unregister_trace_sched_process_free(ftrace_pid_follow_sched_process_exit,
 						    tr);
 	}
 }
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -527,12 +527,12 @@ void trace_event_follow_fork(struct trac
 	if (enable) {
 		register_trace_prio_sched_process_fork(event_filter_pid_sched_process_fork,
 						       tr, INT_MIN);
-		register_trace_prio_sched_process_exit(event_filter_pid_sched_process_exit,
+		register_trace_prio_sched_process_free(event_filter_pid_sched_process_exit,
 						       tr, INT_MAX);
 	} else {
 		unregister_trace_sched_process_fork(event_filter_pid_sched_process_fork,
 						    tr);
-		unregister_trace_sched_process_exit(event_filter_pid_sched_process_exit,
+		unregister_trace_sched_process_free(event_filter_pid_sched_process_exit,
 						    tr);
 	}
 }



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C15724BC19
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729615AbgHTMjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbgHTJrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:47:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D9BA22B43;
        Thu, 20 Aug 2020 09:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916827;
        bh=bHJHwNmJXUROGFe8pMHB6dazDbjUUBkWXzGhIAmLMSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ueqXuxmXWENoEUD/P4vioIfyPyKAbfUZkAj/ndZuqlOM91xp3zF3WUefkEE7bLhfz
         3MVFczUHwNpzi08X5c4GX9kLLe1LnYRs7BttOlv4nvMpoLGvLSNNZpNIGjmNrw9Gx8
         MaDqm0uZeL4uqkHggvVKQIPic4XcoQIgLgxQQBZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        dann frazier <dann.frazier@canonical.com>
Subject: [PATCH 5.4 061/152] tracing: Move pipe reference to trace array instead of current_tracer
Date:   Thu, 20 Aug 2020 11:20:28 +0200
Message-Id: <20200820091556.846156608@linuxfoundation.org>
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

commit 7ef282e05132d56b6f6b71e3873f317664bea78b upstream.

If a process has the trace_pipe open on a trace_array, the current tracer
for that trace array should not be changed. This was original enforced by a
global lock, but when instances were introduced, it was moved to the
current_trace. But this structure is shared by all instances, and a
trace_pipe is for a single instance. There's no reason that a process that
has trace_pipe open on one instance should prevent another instance from
changing its current tracer. Move the reference counter to the trace_array
instead.

This is marked as "Fixes" but is more of a clean up than a true fix.
Backport if you want, but its not critical.

Fixes: cf6ab6d9143b1 ("tracing: Add ref count to tracer for when they are being read by pipe")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
[Resolved conflict in __remove_instance()]
Signed-off-by: dann frazier <dann.frazier@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |   12 ++++++------
 kernel/trace/trace.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5686,7 +5686,7 @@ static int tracing_set_tracer(struct tra
 	}
 
 	/* If trace pipe files are being read, we can't change the tracer */
-	if (tr->current_trace->ref) {
+	if (tr->trace_ref) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -5902,7 +5902,7 @@ static int tracing_open_pipe(struct inod
 
 	nonseekable_open(inode, filp);
 
-	tr->current_trace->ref++;
+	tr->trace_ref++;
 out:
 	mutex_unlock(&trace_types_lock);
 	return ret;
@@ -5921,7 +5921,7 @@ static int tracing_release_pipe(struct i
 
 	mutex_lock(&trace_types_lock);
 
-	tr->current_trace->ref--;
+	tr->trace_ref--;
 
 	if (iter->trace->pipe_close)
 		iter->trace->pipe_close(iter);
@@ -7230,7 +7230,7 @@ static int tracing_buffers_open(struct i
 
 	filp->private_data = info;
 
-	tr->current_trace->ref++;
+	tr->trace_ref++;
 
 	mutex_unlock(&trace_types_lock);
 
@@ -7331,7 +7331,7 @@ static int tracing_buffers_release(struc
 
 	mutex_lock(&trace_types_lock);
 
-	iter->tr->current_trace->ref--;
+	iter->tr->trace_ref--;
 
 	__trace_array_put(iter->tr);
 
@@ -8470,7 +8470,7 @@ static int __remove_instance(struct trac
 {
 	int i;
 
-	if (tr->ref || (tr->current_trace && tr->current_trace->ref))
+	if (tr->ref || (tr->current_trace && tr->trace_ref))
 		return -EBUSY;
 
 	list_del(&tr->list);
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -309,6 +309,7 @@ struct trace_array {
 	struct trace_event_file *trace_marker_file;
 	cpumask_var_t		tracing_cpumask; /* only trace on set CPUs */
 	int			ref;
+	int			trace_ref;
 #ifdef CONFIG_FUNCTION_TRACER
 	struct ftrace_ops	*ops;
 	struct trace_pid_list	__rcu *function_pids;
@@ -498,7 +499,6 @@ struct tracer {
 	struct tracer		*next;
 	struct tracer_flags	*flags;
 	int			enabled;
-	int			ref;
 	bool			print_max;
 	bool			allow_instances;
 #ifdef CONFIG_TRACER_MAX_TRACE



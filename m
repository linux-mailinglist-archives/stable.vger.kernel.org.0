Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7C046098D
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 21:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhK1UEG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 28 Nov 2021 15:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbhK1UCF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 15:02:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6893C06175A
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 11:58:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F58EB80D5D
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 19:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A61C004E1;
        Sun, 28 Nov 2021 19:58:39 +0000 (UTC)
Date:   Sun, 28 Nov 2021 14:58:36 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Check pid filtering when
 creating events" failed to apply to 5.4-stable tree
Message-ID: <20211128145836.28b69d78@oasis.local.home>
In-Reply-To: <16380998769827@kroah.com>
References: <16380998769827@kroah.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 28 Nov 2021 12:44:36 +0100
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> 
> >From 6cb206508b621a9a0a2c35b60540e399225c8243 Mon Sep 17 00:00:00 2001  

And this should be good for 5.4 down to 4.4.

-- Steve

From 4a6f624a7472c41d0ca5e309c90b0b5b6f5b5d43 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Fri, 26 Nov 2021 13:35:26 -0500
Subject: [PATCH] tracing: Check pid filtering when creating events

When pid filtering is activated in an instance, all of the events trace
files for that instance has the PID_FILTER flag set. This determines
whether or not pid filtering needs to be done on the event, otherwise the
event is executed as normal.

If pid filtering is enabled when an event is created (via a dynamic event
or modules), its flag is not updated to reflect the current state, and the
events are not filtered properly.

Cc: stable@vger.kernel.org
Fixes: 3fdaf80f4a836 ("tracing: Implement event pid filtering")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-test.git/kernel/trace/trace_events.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace_events.c
+++ linux-test.git/kernel/trace/trace_events.c
@@ -2341,12 +2341,19 @@ static struct trace_event_file *
 trace_create_new_event(struct trace_event_call *call,
 		       struct trace_array *tr)
 {
+	struct trace_pid_list *pid_list;
 	struct trace_event_file *file;
 
 	file = kmem_cache_alloc(file_cachep, GFP_TRACE);
 	if (!file)
 		return NULL;
 
+	pid_list = rcu_dereference_protected(tr->filtered_pids,
+					     lockdep_is_held(&event_mutex));
+
+	if (pid_list)
+		file->flags |= EVENT_FILE_FL_PID_FILTER;
+
 	file->event_call = call;
 	file->tr = tr;
 	atomic_set(&file->sm_ref, 0);


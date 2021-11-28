Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB25B4605F6
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 12:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343974AbhK1Ltz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 06:49:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35934 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344115AbhK1Lrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 06:47:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3B7C60FC0
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 11:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BAFC004E1;
        Sun, 28 Nov 2021 11:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638099879;
        bh=nQ0ona/34HsoIVeZV5pkuc/YJBoGeATmEQz4XmofBq0=;
        h=Subject:To:Cc:From:Date:From;
        b=whV2byRWlV+BDeoqPZxujH0YEMgYNmMnoGMDdbEaz9y7VAiqU9ytyW1lEe4L8uPxQ
         JO5CGsIQyil+k2ZuKmw/gUp+uTczTOK78Oz8DWegycpa89WO46KKthEZyHYvWq5qwN
         ecbb0qnm5T0TflwGNN/56MaY/amGbbRQh2hJvzLY=
Subject: FAILED: patch "[PATCH] tracing: Check pid filtering when creating events" failed to apply to 5.4-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Nov 2021 12:44:36 +0100
Message-ID: <16380998769827@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6cb206508b621a9a0a2c35b60540e399225c8243 Mon Sep 17 00:00:00 2001
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

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 4021b9a79f93..f8965fd50d3b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2678,12 +2678,24 @@ static struct trace_event_file *
 trace_create_new_event(struct trace_event_call *call,
 		       struct trace_array *tr)
 {
+	struct trace_pid_list *no_pid_list;
+	struct trace_pid_list *pid_list;
 	struct trace_event_file *file;
+	unsigned int first;
 
 	file = kmem_cache_alloc(file_cachep, GFP_TRACE);
 	if (!file)
 		return NULL;
 
+	pid_list = rcu_dereference_protected(tr->filtered_pids,
+					     lockdep_is_held(&event_mutex));
+	no_pid_list = rcu_dereference_protected(tr->filtered_no_pids,
+					     lockdep_is_held(&event_mutex));
+
+	if (!trace_pid_list_first(pid_list, &first) ||
+	    !trace_pid_list_first(pid_list, &first))
+		file->flags |= EVENT_FILE_FL_PID_FILTER;
+
 	file->event_call = call;
 	file->tr = tr;
 	atomic_set(&file->sm_ref, 0);


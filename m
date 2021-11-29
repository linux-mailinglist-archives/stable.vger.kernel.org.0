Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE42461DAD
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378683AbhK2S1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:27:48 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47760 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350992AbhK2SZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:25:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 75A6FCE13E1;
        Mon, 29 Nov 2021 18:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23727C53FC7;
        Mon, 29 Nov 2021 18:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210142;
        bh=vzhx6vWqZfWnp7avfUISClBR51auH5IO6cIJ107wOxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xURmtXxwq4Q+psGygGQCDGlPObQ6FP8dcaMq38JqGfdf2GSZ08QO+9qTz1ujHcJm2
         SZG1BaH/F8rxBKSUlG9IO0Qoh11eVGY7SGaGwbVjCv4jndvXqzJa635RaZ/hhXtO9C
         xkxXoBr+yOafA6NUVwhX1ICRKvkB49/6Jx+7Lso8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 56/69] tracing: Check pid filtering when creating events
Date:   Mon, 29 Nov 2021 19:18:38 +0100
Message-Id: <20211129181705.471337676@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 6cb206508b621a9a0a2c35b60540e399225c8243 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2255,12 +2255,19 @@ static struct trace_event_file *
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



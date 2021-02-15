Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B6931BD12
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhBOPj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:39:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231284AbhBOPhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB8CC64EC4;
        Mon, 15 Feb 2021 15:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403131;
        bh=nd+74Ivruz0O1CFSFEyWbEz5jI05EjRHuPkqjvRvKdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+x6sNt1pYKFN0TuLlunbQLM2nlyY7rYEdl3kMZ8uIUnRzEdwf4ZRdqDFlwijy3Y6
         dvEuaKEvTMO2AaTS2kggLDTp7uw9GH63c+U1q+B0y7W6HdIP+lpl2gfhPw6UouURxS
         cPd3NeMjJVKk7fTt4QKtkT46XqWM7vWDvEES1bxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 006/104] tracing: Do not count ftrace events in top level enable output
Date:   Mon, 15 Feb 2021 16:26:19 +0100
Message-Id: <20210215152719.674067103@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 256cfdd6fdf70c6fcf0f7c8ddb0ebd73ce8f3bc9 upstream.

The file /sys/kernel/tracing/events/enable is used to enable all events by
echoing in "1", or disabling all events when echoing in "0". To know if all
events are enabled, disabled, or some are enabled but not all of them,
cating the file should show either "1" (all enabled), "0" (all disabled), or
"X" (some enabled but not all of them). This works the same as the "enable"
files in the individule system directories (like tracing/events/sched/enable).

But when all events are enabled, the top level "enable" file shows "X". The
reason is that its checking the "ftrace" events, which are special events
that only exist for their format files. These include the format for the
function tracer events, that are enabled when the function tracer is
enabled, but not by the "enable" file. The check includes these events,
which will always be disabled, and even though all true events are enabled,
the top level "enable" file will show "X" instead of "1".

To fix this, have the check test the event's flags to see if it has the
"IGNORE_ENABLE" flag set, and if so, not test it.

Cc: stable@vger.kernel.org
Fixes: 553552ce1796c ("tracing: Combine event filter_active and enable into single flags field")
Reported-by: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1212,7 +1212,8 @@ system_enable_read(struct file *filp, ch
 	mutex_lock(&event_mutex);
 	list_for_each_entry(file, &tr->events, list) {
 		call = file->event_call;
-		if (!trace_event_name(call) || !call->class || !call->class->reg)
+		if ((call->flags & TRACE_EVENT_FL_IGNORE_ENABLE) ||
+		    !trace_event_name(call) || !call->class || !call->class->reg)
 			continue;
 
 		if (system && strcmp(call->class->system, system->name) != 0)



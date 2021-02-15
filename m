Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E61631BC77
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhBOP3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:29:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbhBOP3A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:29:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6458A64E34;
        Mon, 15 Feb 2021 15:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402899;
        bh=jaNdeTeK14iSyDQKo9Y1WRCNgd0hDf2cFfuvNIG1D1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+4/TG7YuD46uF/a61tD6pAfFZoWSosWjMfjc16lyQGXyGheIdo1FGl5vNC2M83rQ
         a8P79OYRp0OSW/gH5d/Sq6hJJqjDNGnY0+BJXz4yQKexaA2qJJNcdt/uaB6CbP7jEZ
         J3gXf/a/MIbAcQMvdKC6JUmskAfW/puuKUlbthbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 03/60] tracing: Do not count ftrace events in top level enable output
Date:   Mon, 15 Feb 2021 16:26:51 +0100
Message-Id: <20210215152715.504296444@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
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
@@ -1107,7 +1107,8 @@ system_enable_read(struct file *filp, ch
 	mutex_lock(&event_mutex);
 	list_for_each_entry(file, &tr->events, list) {
 		call = file->event_call;
-		if (!trace_event_name(call) || !call->class || !call->class->reg)
+		if ((call->flags & TRACE_EVENT_FL_IGNORE_ENABLE) ||
+		    !trace_event_name(call) || !call->class || !call->class->reg)
 			continue;
 
 		if (system && strcmp(call->class->system, system->name) != 0)



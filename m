Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB4D32175C
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhBVMqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:46:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:53738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231344AbhBVMnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:43:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD6D064F4D;
        Mon, 22 Feb 2021 12:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997669;
        bh=PAhDxoh25r9ZRjgcNFVyer0czDoYbfLSTXvoDWJzDR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ZKBMqOH4m61o/+E/Lzf0vyCy8tSrbtaT+/pR+yxSovNiQ9+p0jf3kV5KbpnuFeUK
         aP6+pTwKcHus4T6UXiHX9FwLCNtIA3Fzw0JXQHCpBI+NNsAv772FaVL0TdoAao/Az1
         cLtOalvtiPzMy8h4mYzBlYUBZZZ0J3yu/RySp15Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.9 19/49] tracing: Do not count ftrace events in top level enable output
Date:   Mon, 22 Feb 2021 13:36:17 +0100
Message-Id: <20210222121026.324576882@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
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
@@ -1105,7 +1105,8 @@ system_enable_read(struct file *filp, ch
 	mutex_lock(&event_mutex);
 	list_for_each_entry(file, &tr->events, list) {
 		call = file->event_call;
-		if (!trace_event_name(call) || !call->class || !call->class->reg)
+		if ((call->flags & TRACE_EVENT_FL_IGNORE_ENABLE) ||
+		    !trace_event_name(call) || !call->class || !call->class->reg)
 			continue;
 
 		if (system && strcmp(call->class->system, system->name) != 0)



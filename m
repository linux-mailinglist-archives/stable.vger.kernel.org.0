Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BD64605E8
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 12:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhK1Lmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 06:42:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37296 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbhK1Lkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 06:40:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A0C4B80CC8
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 11:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D13CC004E1;
        Sun, 28 Nov 2021 11:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638099457;
        bh=52jEZcNLWfNHlPY3KxnJ7ajvW0PbOy/RFtWscHUA6Eg=;
        h=Subject:To:Cc:From:Date:From;
        b=i6PLtlq6zWyuk9bmVjzOVuUOSZSU7Y7fo6fzoY+c0py+uuXWAmOsskRfwtnbOrljg
         o7REUCuKJcWzOzoRkx8hBu1mtY/X61kEl577n4qIE32xw8m2wYwog4QEl2sl3TvsQi
         KUL3PcypZ3LmjgRVWSvuNVgklv65LNy06LurjxxA=
Subject: FAILED: patch "[PATCH] tracing: Fix pid filtering when triggers are attached" failed to apply to 4.4-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Nov 2021 12:37:34 +0100
Message-ID: <16380994544650@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a55f224ff5f238013de8762c4287117e47b86e22 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Fri, 26 Nov 2021 17:34:42 -0500
Subject: [PATCH] tracing: Fix pid filtering when triggers are attached

If a event is filtered by pid and a trigger that requires processing of
the event to happen is a attached to the event, the discard portion does
not take the pid filtering into account, and the event will then be
recorded when it should not have been.

Cc: stable@vger.kernel.org
Fixes: 3fdaf80f4a836 ("tracing: Implement event pid filtering")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6b60ab9475ed..38715aa6cfdf 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1366,14 +1366,26 @@ __event_trigger_test_discard(struct trace_event_file *file,
 	if (eflags & EVENT_FILE_FL_TRIGGER_COND)
 		*tt = event_triggers_call(file, buffer, entry, event);
 
-	if (test_bit(EVENT_FILE_FL_SOFT_DISABLED_BIT, &file->flags) ||
-	    (unlikely(file->flags & EVENT_FILE_FL_FILTERED) &&
-	     !filter_match_preds(file->filter, entry))) {
-		__trace_event_discard_commit(buffer, event);
-		return true;
-	}
+	if (likely(!(file->flags & (EVENT_FILE_FL_SOFT_DISABLED |
+				    EVENT_FILE_FL_FILTERED |
+				    EVENT_FILE_FL_PID_FILTER))))
+		return false;
+
+	if (file->flags & EVENT_FILE_FL_SOFT_DISABLED)
+		goto discard;
+
+	if (file->flags & EVENT_FILE_FL_FILTERED &&
+	    !filter_match_preds(file->filter, entry))
+		goto discard;
+
+	if ((file->flags & EVENT_FILE_FL_PID_FILTER) &&
+	    trace_event_ignore_this_pid(file))
+		goto discard;
 
 	return false;
+ discard:
+	__trace_event_discard_commit(buffer, event);
+	return true;
 }
 
 /**


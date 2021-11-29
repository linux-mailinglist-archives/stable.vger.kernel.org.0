Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B525F461DCA
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378264AbhK2S31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:29:27 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48602 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378275AbhK2S1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:27:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01F19CE1414;
        Mon, 29 Nov 2021 18:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5667C53FCD;
        Mon, 29 Nov 2021 18:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210243;
        bh=epesHwdv7SYWwn9Dt6wonZgyx4QLUNQlVx0680D9Bvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmvQ+MrPHiuviUZghKsMXNhnbYFDTmR6FwlrcSZ3I1M6tgMnj3TtaQhdyYhMzqoE8
         bnDPPnIdB6gXePvBKc1IvyA/Lgi1rhIBAoeUtNXvdR9IZ02HWpmmq2TAtKvKRcJEn9
         xZ17Bgbjkie4V5zPse+5eaiJkAMcTUUWg3Fp1nhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 20/92] tracing: Fix pid filtering when triggers are attached
Date:   Mon, 29 Nov 2021 19:17:49 +0100
Message-Id: <20211129181708.093066993@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit a55f224ff5f238013de8762c4287117e47b86e22 upstream.

If a event is filtered by pid and a trigger that requires processing of
the event to happen is a attached to the event, the discard portion does
not take the pid filtering into account, and the event will then be
recorded when it should not have been.

Cc: stable@vger.kernel.org
Fixes: 3fdaf80f4a836 ("tracing: Implement event pid filtering")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.h |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1423,14 +1423,26 @@ __event_trigger_test_discard(struct trac
 	if (eflags & EVENT_FILE_FL_TRIGGER_COND)
 		*tt = event_triggers_call(file, entry, event);
 
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



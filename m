Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22288462518
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbhK2WfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbhK2We7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:34:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826EDC03AA3D;
        Mon, 29 Nov 2021 10:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 470CAB815BB;
        Mon, 29 Nov 2021 18:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73549C53FCD;
        Mon, 29 Nov 2021 18:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210016;
        bh=218dG2nF0EfOxOZcdN/bH47mgV4Wysbn5LVfcFczhaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aw+crcZdi3PoWwtHFjXoEoOxr2jwupTWOBkiWtr3tg542AfKEaUsC6orEdqAVLd8y
         vhWPzuMf1qIm2q8dXn3cHq2YUFtq0WLAwqumleAx+d4rVCFK7MtqWQ02u/joIPtZMv
         DIyApcgOMkreKNWqxsnBOtauEvs9yZQzJ+zjkvI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 14/69] tracing: Fix pid filtering when triggers are attached
Date:   Mon, 29 Nov 2021 19:17:56 +0100
Message-Id: <20211129181704.132801814@linuxfoundation.org>
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
@@ -1365,14 +1365,26 @@ __event_trigger_test_discard(struct trac
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



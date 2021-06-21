Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67AA33AEDBD
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhFUQW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231169AbhFUQVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:21:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12E2761164;
        Mon, 21 Jun 2021 16:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292344;
        bh=FAkSYqFfFnVQkOIYEvmy4UTRP3DWfQSBA4Q2+Z0e23c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PcTkBO+CQVOHCtKW/TQks1yj4SDdhVC98voCTXfS7tfE67DR7XoyRLl+OXuB4Rs+x
         q0OoGbLhzQRY1IslMXQ6hI3Jy6idYYP8DM6oZI3y670JSfvJV/uNr+ek3NFh1ZgStA
         dq0lDuyzT3jXoEBSBpSkx6QGJGcGM0BkPS+aVStQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 56/90] tracing: Do not stop recording comms if the trace file is being read
Date:   Mon, 21 Jun 2021 18:15:31 +0200
Message-Id: <20210621154906.050692153@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 4fdd595e4f9a1ff6d93ec702eaecae451cfc6591 upstream.

A while ago, when the "trace" file was opened, tracing was stopped, and
code was added to stop recording the comms to saved_cmdlines, for mapping
of the pids to the task name.

Code has been added that only records the comm if a trace event occurred,
and there's no reason to not trace it if the trace file is opened.

Cc: stable@vger.kernel.org
Fixes: 7ffbd48d5cab2 ("tracing: Cache comms only after an event occurred")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1948,9 +1948,6 @@ struct saved_cmdlines_buffer {
 };
 static struct saved_cmdlines_buffer *savedcmd;
 
-/* temporary disable recording */
-static atomic_t trace_record_taskinfo_disabled __read_mostly;
-
 static inline char *get_saved_cmdlines(int idx)
 {
 	return &savedcmd->saved_cmdlines[idx * TASK_COMM_LEN];
@@ -3458,9 +3455,6 @@ static void *s_start(struct seq_file *m,
 		return ERR_PTR(-EBUSY);
 #endif
 
-	if (!iter->snapshot)
-		atomic_inc(&trace_record_taskinfo_disabled);
-
 	if (*pos != iter->pos) {
 		iter->ent = NULL;
 		iter->cpu = 0;
@@ -3503,9 +3497,6 @@ static void s_stop(struct seq_file *m, v
 		return;
 #endif
 
-	if (!iter->snapshot)
-		atomic_dec(&trace_record_taskinfo_disabled);
-
 	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
 }



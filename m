Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D453B62CB
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbhF1Ota (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:49:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235438AbhF1OpD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:45:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E8D961D06;
        Mon, 28 Jun 2021 14:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890841;
        bh=7H1gF4APE212UAPJY+7xGcaw49mKV6PHL83tDqh4hiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Om8OAtM/ktG+921gi8vH8IhmaYswJsq/iQOTKuvJLJGw8yEoDHsXcUZstDbNLA4YK
         JGQfDimvvjg6tj2A0CxE6eCeRYwjqnB321f+W//hH8Z2jkAjYnaenASk7KWmLj6apX
         snUW0qvguqd5tyF1voaNqY8tLF6FJ+PXMAWTa1lNei4DvyL5C38ykNF6s79e5QybUs
         dhE0uzB0sC36vsmbsWHB6PoRxK3Q211nW4AnaQp2RbLqmJr1B6sTkgnUf1YZtFMERl
         xb2mJA/ENJlW57oRSPsDjACJ95U34UR5/t9gAdiTNhWZaCIMtQMEAtCKxoBiX25vyB
         yWzKNzqM/YnBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 062/109] tracing: Do not stop recording comms if the trace file is being read
Date:   Mon, 28 Jun 2021 10:32:18 -0400
Message-Id: <20210628143305.32978-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

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
 kernel/trace/trace.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 133cf8d125a3..71bc808fe03a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1743,9 +1743,6 @@ struct saved_cmdlines_buffer {
 };
 static struct saved_cmdlines_buffer *savedcmd;
 
-/* temporary disable recording */
-static atomic_t trace_record_taskinfo_disabled __read_mostly;
-
 static inline char *get_saved_cmdlines(int idx)
 {
 	return &savedcmd->saved_cmdlines[idx * TASK_COMM_LEN];
@@ -3259,9 +3256,6 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 		return ERR_PTR(-EBUSY);
 #endif
 
-	if (!iter->snapshot)
-		atomic_inc(&trace_record_taskinfo_disabled);
-
 	if (*pos != iter->pos) {
 		iter->ent = NULL;
 		iter->cpu = 0;
@@ -3304,9 +3298,6 @@ static void s_stop(struct seq_file *m, void *p)
 		return;
 #endif
 
-	if (!iter->snapshot)
-		atomic_dec(&trace_record_taskinfo_disabled);
-
 	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
 }
-- 
2.30.2


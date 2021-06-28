Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170903B6339
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbhF1OxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235023AbhF1OvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:51:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80E7A61C8C;
        Mon, 28 Jun 2021 14:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891030;
        bh=Uu1pE3wGjVqDP8N0XpPqMROJkfkhcNss+oR6hC684NI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LUgTBAjPvDQLfKuIU6BA45NrnkvgTc10WL+4jmBnejwOmYbWnj1yhx6QntT6gI33H
         fxYvC4JAaH52cpS8J5s8syzYuKM4wtUMzzPjB5JZW+FSH/28HwnFoHiaHpB6b6leO1
         FmTTMCm0a08ENgjP/Nvg9xY2A9PmxGRl2pvNTxuk3RKaZ86hwayD08rQWd7+Ael8f1
         tq6lFj3O1moFFMtAKa0yxg5wwPrUv2IDqDEKhsWcHmOIk6zXW/xlQhiK2Z6Au6hzgD
         C3mDepupGfAQoPAaKxJMAG8QgGNsXmiozdGr6LXq3hnKV4uOHPQPbSGLA7MMPreSEY
         143NQaaEqFCOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 47/88] tracing: Do not stop recording comms if the trace file is being read
Date:   Mon, 28 Jun 2021 10:35:47 -0400
Message-Id: <20210628143628.33342-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
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
index badc7c13da46..0cc67bc0666e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1737,9 +1737,6 @@ struct saved_cmdlines_buffer {
 };
 static struct saved_cmdlines_buffer *savedcmd;
 
-/* temporary disable recording */
-static atomic_t trace_record_taskinfo_disabled __read_mostly;
-
 static inline char *get_saved_cmdlines(int idx)
 {
 	return &savedcmd->saved_cmdlines[idx * TASK_COMM_LEN];
@@ -3257,9 +3254,6 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 		return ERR_PTR(-EBUSY);
 #endif
 
-	if (!iter->snapshot)
-		atomic_inc(&trace_record_taskinfo_disabled);
-
 	if (*pos != iter->pos) {
 		iter->ent = NULL;
 		iter->cpu = 0;
@@ -3302,9 +3296,6 @@ static void s_stop(struct seq_file *m, void *p)
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


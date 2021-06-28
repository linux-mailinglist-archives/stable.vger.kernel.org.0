Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9193B63E8
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236664AbhF1PCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236494AbhF1PAN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E07361D64;
        Mon, 28 Jun 2021 14:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891246;
        bh=lhYlZohQOjQkWi4YVKwrN8xVuF2Zx6Sam0x0aFrl+gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbapW1G49VQDfuKtPtKGwnidMYx3pKATnORvAovzyJpbEAhEjaARyUrRKN1FhSPsa
         zJsXDXbEhPs9x8tA1QNs7IhnL2nmZnqfWIcjxfWrPljzaWFWOfyTJzPlaZ35X5nM2Q
         Bs/73+n2d2F23LVBO8LXGR7lGwPvB4F2kKDAKWRi8R/vogFBJPwReZ9Mo1d+vPD4ob
         e3UNLq6bpCU6lXALf3XNb2cDN8RXHaz6m0zojvEhTbiNsTGY+qT/H46IlmuyS3j8K3
         TfBynNPom2fAp0viufw/1iaI6nrA66wZWuqvsLlKREiwBHQGCQWK90ZTKEolGX9K1Z
         7X662efZ3geaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 48/71] tracing: Do not stop recording comms if the trace file is being read
Date:   Mon, 28 Jun 2021 10:39:40 -0400
Message-Id: <20210628144003.34260-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
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
index 74ec372a3286..e8bd8de856de 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1616,9 +1616,6 @@ struct saved_cmdlines_buffer {
 };
 static struct saved_cmdlines_buffer *savedcmd;
 
-/* temporary disable recording */
-static atomic_t trace_record_cmdline_disabled __read_mostly;
-
 static inline char *get_saved_cmdlines(int idx)
 {
 	return &savedcmd->saved_cmdlines[idx * TASK_COMM_LEN];
@@ -2825,9 +2822,6 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 		return ERR_PTR(-EBUSY);
 #endif
 
-	if (!iter->snapshot)
-		atomic_inc(&trace_record_cmdline_disabled);
-
 	if (*pos != iter->pos) {
 		iter->ent = NULL;
 		iter->cpu = 0;
@@ -2870,9 +2864,6 @@ static void s_stop(struct seq_file *m, void *p)
 		return;
 #endif
 
-	if (!iter->snapshot)
-		atomic_dec(&trace_record_cmdline_disabled);
-
 	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
 }
-- 
2.30.2


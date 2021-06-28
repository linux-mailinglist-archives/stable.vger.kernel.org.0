Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242343B645A
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbhF1PHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:07:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237253AbhF1PF2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:05:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 462CB61D01;
        Mon, 28 Jun 2021 14:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891411;
        bh=5BkMdi8kyv2pNBlc7l9DW5r/QWoBOp5Vz+nSo/jhBLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itGn5/Nok6/b8ZNZXwSePkHJWvFj7DDEAIG+dYc/kzSseFT2/pbZifZJ8k8WvwJs+
         +Hxy5KLRMQZ1ORCTL6Qn+oLcSG9LBHscxOcLKLOmZS6JT7KA77Iq5/hrdC/EPEnMxR
         pJ4GM8U1257CHxGpYiPuJnN2BoMMeWae2RlcjsBBYjckzRT2W/rrMRP5PrvcQNTwlQ
         9tOzh7mCQWt27XnUo0jNjurVRagajBj9oKnzazYGoUE1v2HGtPMHm3LhnjHsCDQRYp
         ZZUeyWqaH6dgV4Hpx5aVrtVt6JQBzuOcwNyYjxIVAr5w5j8HF9svj4oFXstdBBladc
         cGL1BLxympTpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 39/57] tracing: Do not stop recording cmdlines when tracing is off
Date:   Mon, 28 Jun 2021 10:42:38 -0400
Message-Id: <20210628144256.34524-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

commit 85550c83da421fb12dc1816c45012e1e638d2b38 upstream.

The saved_cmdlines is used to map pids to the task name, such that the
output of the tracing does not just show pids, but also gives a human
readable name for the task.

If the name is not mapped, the output looks like this:

    <...>-1316          [005] ...2   132.044039: ...

Instead of this:

    gnome-shell-1316    [005] ...2   132.044039: ...

The names are updated when tracing is running, but are skipped if tracing
is stopped. Unfortunately, this stops the recording of the names if the
top level tracer is stopped, and not if there's other tracers active.

The recording of a name only happens when a new event is written into a
ring buffer, so there is no need to test if tracing is on or not. If
tracing is off, then no event is written and no need to test if tracing is
off or not.

Remove the check, as it hides the names of tasks for events in the
instance buffers.

Cc: stable@vger.kernel.org
Fixes: 7ffbd48d5cab2 ("tracing: Cache comms only after an event occurred")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9483bd527247..6b879ff120d6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1635,9 +1635,6 @@ void trace_find_cmdline(int pid, char comm[])
 
 void tracing_record_cmdline(struct task_struct *tsk)
 {
-	if (atomic_read(&trace_record_cmdline_disabled) || !tracing_is_on())
-		return;
-
 	if (!__this_cpu_read(trace_cmdline_save))
 		return;
 
-- 
2.30.2


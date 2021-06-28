Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6A83B63EE
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbhF1PCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236478AbhF1PAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:00:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC60D61D61;
        Mon, 28 Jun 2021 14:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891246;
        bh=t6L9j0lOhpSCsIRzBJNCm+dDScW9tSN830gCfIZO8d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxBmtMy/VonbMrJx9emt0H5ZFtob4voMIXZ7PMXvxpoU53+SleBKAXdKaPUb4LWxa
         mWwhlf/EdWSedIDhcn+Md5dYSM4weTBt4vqzqvnkJ7NigJcYoRn0nllcNYvHvgmace
         OPCqEIXE+hwfiTAbK5ljg/k6f3f1DzJSBu4f4Mk8VJ4lYfhcv6P+ds/oYsxqN2g8eX
         pI6c563/CkxwMPDQH9U4qqm9FzFeIs1pvhb2wlYOIzMeov2+0Z5mC2trbXr43VSw+V
         enYk9HX5wNOWq09v/WBgsZRTQ7mEe52RMJUa7qE1PN+U+zMDD8HpIpYUfHi9vd/dQK
         ZyCjW3i+cHz4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 47/71] tracing: Do not stop recording cmdlines when tracing is off
Date:   Mon, 28 Jun 2021 10:39:39 -0400
Message-Id: <20210628144003.34260-48-sashal@kernel.org>
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
index cdf614943aa3..74ec372a3286 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1882,9 +1882,6 @@ void trace_find_cmdline(int pid, char comm[])
 
 void tracing_record_cmdline(struct task_struct *tsk)
 {
-	if (atomic_read(&trace_record_cmdline_disabled) || !tracing_is_on())
-		return;
-
 	if (!__this_cpu_read(trace_cmdline_save))
 		return;
 
-- 
2.30.2


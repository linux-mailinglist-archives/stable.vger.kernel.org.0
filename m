Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91843B6336
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbhF1OxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233992AbhF1OvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:51:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D025E61CAF;
        Mon, 28 Jun 2021 14:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891030;
        bh=t+yiovBACkxoR7+CJ/O/MUx8MwDAl/0d5j3/Eod5+s4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RbOiPJA/Su5zCiKwrfhNtuBGB+PPtK0T6ni8zl6p5QqgECq+kKMapQ012SYCaerTY
         8jdXac94zM7POLGgT0fhive6fGZ1UyfGd39eKwBYVs2Mg9LDu0GhUxUFxL3LQjn4KO
         6OxR2Z0C9PlTCKGvxIUuEgRdcykn/eCs2MoRCYIEo3nFPbJ+D738b0UbojTMasFzMQ
         qiy9fVFWFGuy11FUXfI8eY58FCAowwQvQPvgdbJ0qBsxKRimBQQ7yKOAiqVqGCJIbS
         yRjIKvX074GtW3sxfHXdOIKUaFz8ZyGLZTji6SsaubQZ+dS4/TRpInkZQNqIv3nH2A
         sRbrBsFNXB2Ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 46/88] tracing: Do not stop recording cmdlines when tracing is off
Date:   Mon, 28 Jun 2021 10:35:46 -0400
Message-Id: <20210628143628.33342-47-sashal@kernel.org>
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
 kernel/trace/trace.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 42531ee852ff..badc7c13da46 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2024,8 +2024,6 @@ static bool tracing_record_taskinfo_skip(int flags)
 {
 	if (unlikely(!(flags & (TRACE_RECORD_CMDLINE | TRACE_RECORD_TGID))))
 		return true;
-	if (atomic_read(&trace_record_taskinfo_disabled) || !tracing_is_on())
-		return true;
 	if (!__this_cpu_read(trace_taskinfo_save))
 		return true;
 	return false;
-- 
2.30.2


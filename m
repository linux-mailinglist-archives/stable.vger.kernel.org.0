Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749EF3B6291
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbhF1Osa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235121AbhF1OoP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:44:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80A0F61D00;
        Mon, 28 Jun 2021 14:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890840;
        bh=5rUVk5kaFCskHmg5u4LMNu4o0S3reEM8yZUVuOCRFI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJuLAAw7xqkEh3NnpmOfPPgBTlopKx568BOkKod62FQGH8wYt5/kFEiy+qwSsUGi2
         V89BwEP0DjVCgi/DvPo97B49mXJB9EEPxUZGQfWGRzwFUm7+cOuoWTJQ0gAc3vyKE3
         SqsmjpQpMdut93dFru+Dc3JSaWbYQIk8VUl1N4R70z+1vk1AgcT9cS58D3xFljK1QC
         Id6GEDKcb04tuzXyzKO6+GFEA99ueyp5B/kQmylfX5i+UvCahQxFH4cWPvFqzFaVPq
         328d/SSCPxyZoi47zq/NDMA1TXohg/SUI5sGwk93+7YWcVkMz6qE6FZL4jEpH4b+gr
         26LBly4bs1mOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 061/109] tracing: Do not stop recording cmdlines when tracing is off
Date:   Mon, 28 Jun 2021 10:32:17 -0400
Message-Id: <20210628143305.32978-62-sashal@kernel.org>
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
index f8aaa7879d7d..133cf8d125a3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2031,8 +2031,6 @@ static bool tracing_record_taskinfo_skip(int flags)
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


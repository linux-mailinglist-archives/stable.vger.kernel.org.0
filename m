Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D573E81DE
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236633AbhHJSDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:03:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237657AbhHJSBa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:01:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7198B613CF;
        Tue, 10 Aug 2021 17:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617625;
        bh=G8lrQHm1yBvrEMOOKL50FarquT70ja8gKFV60lbVm8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCkWC3joavFQwlyCSu8citEspl71DRje8aMqaMfanc29Oz3ZWCVX9W9O79cB9GcW7
         hPEZVYhspSVovzoH7rqkIVBYrHDHuDEXcY4M3MUywmNkfr6pxWtu4OCZOJZIpS+FFk
         6BNHkhyeqcJjuI9dV3X4VjXkzNhwIJslpybFSBpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.13 134/175] perf: Fix required permissions if sigtrap is requested
Date:   Tue, 10 Aug 2021 19:30:42 +0200
Message-Id: <20210810173005.356407159@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

commit 9d7a6c95f62bc335b62aaf9d50590122bd03a796 upstream.

If perf_event_open() is called with another task as target and
perf_event_attr::sigtrap is set, and the target task's user does not
match the calling user, also require the CAP_KILL capability or
PTRACE_MODE_ATTACH permissions.

Otherwise, with the CAP_PERFMON capability alone it would be possible
for a user to send SIGTRAP signals via perf events to another user's
tasks. This could potentially result in those tasks being terminated if
they cannot handle SIGTRAP signals.

Note: The check complements the existing capability check, but is not
supposed to supersede the ptrace_may_access() check. At a high level we
now have:

	capable of CAP_PERFMON and (CAP_KILL if sigtrap)
		OR
	ptrace_may_access(...) // also checks for same thread-group and uid

Fixes: 97ba62b27867 ("perf: Add support for SIGTRAP on perf events")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org> # 5.13+
Link: https://lore.kernel.org/r/20210705084453.2151729-1-elver@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12159,10 +12159,33 @@ SYSCALL_DEFINE5(perf_event_open,
 	}
 
 	if (task) {
+		unsigned int ptrace_mode = PTRACE_MODE_READ_REALCREDS;
+		bool is_capable;
+
 		err = down_read_interruptible(&task->signal->exec_update_lock);
 		if (err)
 			goto err_file;
 
+		is_capable = perfmon_capable();
+		if (attr.sigtrap) {
+			/*
+			 * perf_event_attr::sigtrap sends signals to the other
+			 * task. Require the current task to also have
+			 * CAP_KILL.
+			 */
+			rcu_read_lock();
+			is_capable &= ns_capable(__task_cred(task)->user_ns, CAP_KILL);
+			rcu_read_unlock();
+
+			/*
+			 * If the required capabilities aren't available, checks
+			 * for ptrace permissions: upgrade to ATTACH, since
+			 * sending signals can effectively change the target
+			 * task.
+			 */
+			ptrace_mode = PTRACE_MODE_ATTACH_REALCREDS;
+		}
+
 		/*
 		 * Preserve ptrace permission check for backwards compatibility.
 		 *
@@ -12172,7 +12195,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * perf_event_exit_task() that could imply).
 		 */
 		err = -EACCES;
-		if (!perfmon_capable() && !ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
+		if (!is_capable && !ptrace_may_access(task, ptrace_mode))
 			goto err_cred;
 	}
 



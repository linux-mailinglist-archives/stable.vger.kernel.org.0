Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3703D77A8
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236688AbhG0N7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236693AbhG0N66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 09:58:58 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BD3C0613C1;
        Tue, 27 Jul 2021 06:58:58 -0700 (PDT)
Date:   Tue, 27 Jul 2021 13:58:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1627394337;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FJELXVKON9rpomW9vzhx58n0wJti5C/fQyrsu8RzLIw=;
        b=4Fmdqr32muwJNwOHRwEEoN+c4GvY75Y/PTZLRJfg9L7iEO6edhBQeGZzDCJO/uzM0INAUO
        N1mHS+0sz4L8pRUZnFxlYENlixBP7XzNY6nWqHVzZtIdlMH4J8YS73hqAYg6EbKk71rC1s
        K15TGW+3j+Rgi1jjymk56h5EDWTrl1eHw50bJXE6LXpbBnP8amwQ5mDRvr6OVZmQifngec
        Z4ryvh0dnD2M20dv1dranNGiGHWB63JqYIrPcnCdh5wRAobND1pcciZGNWptKkw6pugxbr
        Ojcd3z5Nrra0LJn4ARYpmboy/x5VJCk0oWqXPt5wLucnLSPIY2I0j+YVXX77Yg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1627394337;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FJELXVKON9rpomW9vzhx58n0wJti5C/fQyrsu8RzLIw=;
        b=+fVqRAECbZPU74HosKiusZVSkCqSsbeLUfdAXxD8jWNJLhCY3xJWZXBCI+mc3d3Y9dF+pI
        1O21hJq0ufz8A7BQ==
From:   "tip-bot2 for Marco Elver" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf: Fix required permissions if sigtrap is requested
Cc:     Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210705084453.2151729-1-elver@google.com>
References: <20210705084453.2151729-1-elver@google.com>
MIME-Version: 1.0
Message-ID: <162739433639.395.3916733257686194035.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     9d7a6c95f62bc335b62aaf9d50590122bd03a796
Gitweb:        https://git.kernel.org/tip/9d7a6c95f62bc335b62aaf9d50590122bd03a796
Author:        Marco Elver <elver@google.com>
AuthorDate:    Mon, 05 Jul 2021 10:44:52 +02:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Fri, 16 Jul 2021 18:46:38 +02:00

perf: Fix required permissions if sigtrap is requested

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
---
 kernel/events/core.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4649170..c13730b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12158,10 +12158,33 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -12171,7 +12194,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * perf_event_exit_task() that could imply).
 		 */
 		err = -EACCES;
-		if (!perfmon_capable() && !ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
+		if (!is_capable && !ptrace_may_access(task, ptrace_mode))
 			goto err_cred;
 	}
 

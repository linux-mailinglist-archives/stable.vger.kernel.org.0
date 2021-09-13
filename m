Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5D7408C8D
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240326AbhIMNUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239450AbhIMNTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:19:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE530610CE;
        Mon, 13 Sep 2021 13:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539049;
        bh=uUIWVZz5XUg/rEj4UYTgGO8eQs3sAcwNHViLVpRV0QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEvHID81TH4elvWsxCui7YKewn+9ZN5cD1VVLd5Is73dz2LiHB3alVsrcRGTDSUlC
         JTgHat1Bj7Dgl4NBxgEjGuoWA49DBJ8FKDpeztjatvfs/YmKrGgDUrPwlybtN3t64K
         OU/dNJERu/9YoMvLT4NHHwbpiwANTgOy9XPLKby8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Perret <qperret@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 004/144] sched/deadline: Fix reset_on_fork reporting of DL tasks
Date:   Mon, 13 Sep 2021 15:13:05 +0200
Message-Id: <20210913131048.118188162@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

[ Upstream commit f95091536f78971b269ec321b057b8d630b0ad8a ]

It is possible for sched_getattr() to incorrectly report the state of
the reset_on_fork flag when called on a deadline task.

Indeed, if the flag was set on a deadline task using sched_setattr()
with flags (SCHED_FLAG_RESET_ON_FORK | SCHED_FLAG_KEEP_PARAMS), then
p->sched_reset_on_fork will be set, but __setscheduler() will bail out
early, which means that the dl_se->flags will not get updated by
__setscheduler_params()->__setparam_dl(). Consequently, if
sched_getattr() is then called on the task, __getparam_dl() will
override kattr.sched_flags with the now out-of-date copy in dl_se->flags
and report the stale value to userspace.

To fix this, make sure to only copy the flags that are relevant to
sched_deadline to and from the dl_se->flags field.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20210727101103.2729607-2-qperret@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 7 ++++---
 kernel/sched/sched.h    | 2 ++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 3cf776d5bce8..7ab0b80cb12d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2622,7 +2622,7 @@ void __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 	dl_se->dl_runtime = attr->sched_runtime;
 	dl_se->dl_deadline = attr->sched_deadline;
 	dl_se->dl_period = attr->sched_period ?: dl_se->dl_deadline;
-	dl_se->flags = attr->sched_flags;
+	dl_se->flags = attr->sched_flags & SCHED_DL_FLAGS;
 	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
 	dl_se->dl_density = to_ratio(dl_se->dl_deadline, dl_se->dl_runtime);
 }
@@ -2635,7 +2635,8 @@ void __getparam_dl(struct task_struct *p, struct sched_attr *attr)
 	attr->sched_runtime = dl_se->dl_runtime;
 	attr->sched_deadline = dl_se->dl_deadline;
 	attr->sched_period = dl_se->dl_period;
-	attr->sched_flags = dl_se->flags;
+	attr->sched_flags &= ~SCHED_DL_FLAGS;
+	attr->sched_flags |= dl_se->flags;
 }
 
 /*
@@ -2710,7 +2711,7 @@ bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr)
 	if (dl_se->dl_runtime != attr->sched_runtime ||
 	    dl_se->dl_deadline != attr->sched_deadline ||
 	    dl_se->dl_period != attr->sched_period ||
-	    dl_se->flags != attr->sched_flags)
+	    dl_se->flags != (attr->sched_flags & SCHED_DL_FLAGS))
 		return true;
 
 	return false;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4e490e3db2f8..fe755c1a0af9 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -209,6 +209,8 @@ static inline int task_has_dl_policy(struct task_struct *p)
  */
 #define SCHED_FLAG_SUGOV	0x10000000
 
+#define SCHED_DL_FLAGS (SCHED_FLAG_RECLAIM | SCHED_FLAG_DL_OVERRUN | SCHED_FLAG_SUGOV)
+
 static inline bool dl_entity_is_special(struct sched_dl_entity *dl_se)
 {
 #ifdef CONFIG_CPU_FREQ_GOV_SCHEDUTIL
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EE3255AB0
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 14:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbgH1M4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 08:56:46 -0400
Received: from foss.arm.com ([217.140.110.172]:48520 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729471AbgH1M4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Aug 2020 08:56:34 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4186D6E;
        Fri, 28 Aug 2020 05:56:33 -0700 (PDT)
Received: from e107158-lin.cambridge.arm.com (e107158-lin.cambridge.arm.com [10.1.195.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 89E183F66B;
        Fri, 28 Aug 2020 05:56:32 -0700 (PDT)
From:   Qais Yousef <qais.yousef@arm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH 2/2] sched/uclamp: Fix a deadlock when enabling uclamp static key
Date:   Fri, 28 Aug 2020 13:56:10 +0100
Message-Id: <20200828125610.30943-3-qais.yousef@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200828125610.30943-1-qais.yousef@arm.com>
References: <20200828125610.30943-1-qais.yousef@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following splat was caught when setting uclamp value of a task:

  BUG: sleeping function called from invalid context at ./include/linux/percpu-rwsem.h:49

   cpus_read_lock+0x68/0x130
   static_key_enable+0x1c/0x38
   __sched_setscheduler+0x900/0xad8

Fix by ensuring we enable the key outside of the critical section in
__sched_setscheduler()

Fixes: 46609ce22703 ("sched/uclamp: Protect uclamp fast path code with static key")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200716110347.19553-4-qais.yousef@arm.com
(cherry picked from commit e65855a52b479f98674998cb23b21ef5a8144b04)
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
---
 kernel/sched/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a8ab68aa189a..352239c411a4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1249,6 +1249,15 @@ static int uclamp_validate(struct task_struct *p,
 	if (upper_bound > SCHED_CAPACITY_SCALE)
 		return -EINVAL;
 
+	/*
+	 * We have valid uclamp attributes; make sure uclamp is enabled.
+	 *
+	 * We need to do that here, because enabling static branches is a
+	 * blocking operation which obviously cannot be done while holding
+	 * scheduler locks.
+	 */
+	static_branch_enable(&sched_uclamp_used);
+
 	return 0;
 }
 
@@ -1279,8 +1288,6 @@ static void __setscheduler_uclamp(struct task_struct *p,
 	if (likely(!(attr->sched_flags & SCHED_FLAG_UTIL_CLAMP)))
 		return;
 
-	static_branch_enable(&sched_uclamp_used);
-
 	if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP_MIN) {
 		uclamp_se_set(&p->uclamp_req[UCLAMP_MIN],
 			      attr->sched_util_min, true);
-- 
2.17.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C427D24B31C
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgHTJlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728307AbgHTJla (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:41:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1F4C207DE;
        Thu, 20 Aug 2020 09:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916490;
        bh=y95aqhMghBTuYzwc96pgSXwzVNjO3rBpSfMV1LhH2hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0uMQBOEX3afTNZx8sX8TpDlzk73i9K++eSxJJR00+j/nsZMVl1tbJS0JSXddWUwS
         v1onKzTydz0wUjhnVonA66dbniTws1YXt0TQhaSyibuZsBo9QwIoKleHaWVtuM4fRG
         rWuRV/LEOn23eXZdu94iR0ThIcx5T5N3p9cbhHBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 146/204] sched/uclamp: Fix a deadlock when enabling uclamp static key
Date:   Thu, 20 Aug 2020 11:20:43 +0200
Message-Id: <20200820091613.539576056@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit e65855a52b479f98674998cb23b21ef5a8144b04 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 49b5c5cf9271d..ebecf1cc3b788 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1248,6 +1248,15 @@ static int uclamp_validate(struct task_struct *p,
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
 
@@ -1278,8 +1287,6 @@ static void __setscheduler_uclamp(struct task_struct *p,
 	if (likely(!(attr->sched_flags & SCHED_FLAG_UTIL_CLAMP)))
 		return;
 
-	static_branch_enable(&sched_uclamp_used);
-
 	if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP_MIN) {
 		uclamp_se_set(&p->uclamp_req[UCLAMP_MIN],
 			      attr->sched_util_min, true);
-- 
2.25.1




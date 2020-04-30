Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6561BFA61
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 15:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgD3NxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728637AbgD3NxJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:53:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3E5024954;
        Thu, 30 Apr 2020 13:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254788;
        bh=r7xi7xjZ6Fsdw2v6jyWidSzLPNaMqwe4mVlfuLkfu6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCm0d6nR9UYfJIpcYZHq6HnJY2KxZidjTcV5KyQgcTS/aDSl8GGkQWuRqBh8Lulza
         5HRTjIq05yVpLNooe38UY0n0FWPb/EzGwBbTY9Lk3Utvt+qfZrdMlpjSD+aHnGeQmr
         DjkxDUKBH4JtP0ucmZ24IbGttsPGDHGqnt0q8m38=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quentin Perret <qperret@google.com>,
        Chitti Babu Theegala <ctheegal@codeaurora.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Patrick Bellasi <patrick.bellasi@matbug.net>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 44/57] sched/core: Fix reset-on-fork from RT with uclamp
Date:   Thu, 30 Apr 2020 09:52:05 -0400
Message-Id: <20200430135218.20372-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135218.20372-1-sashal@kernel.org>
References: <20200430135218.20372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

[ Upstream commit eaf5a92ebde5bca3bb2565616115bd6d579486cd ]

uclamp_fork() resets the uclamp values to their default when the
reset-on-fork flag is set. It also checks whether the task has a RT
policy, and sets its uclamp.min to 1024 accordingly. However, during
reset-on-fork, the task's policy is lowered to SCHED_NORMAL right after,
hence leading to an erroneous uclamp.min setting for the new task if it
was forked from RT.

Fix this by removing the unnecessary check on rt_task() in
uclamp_fork() as this doesn't make sense if the reset-on-fork flag is
set.

Fixes: 1a00d999971c ("sched/uclamp: Set default clamps for RT tasks")
Reported-by: Chitti Babu Theegala <ctheegal@codeaurora.org>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Patrick Bellasi <patrick.bellasi@matbug.net>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lkml.kernel.org/r/20200416085956.217587-1-qperret@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 195d0019e6bb5..e99d326fa5693 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1233,13 +1233,8 @@ static void uclamp_fork(struct task_struct *p)
 		return;
 
 	for_each_clamp_id(clamp_id) {
-		unsigned int clamp_value = uclamp_none(clamp_id);
-
-		/* By default, RT tasks always get 100% boost */
-		if (unlikely(rt_task(p) && clamp_id == UCLAMP_MIN))
-			clamp_value = uclamp_none(UCLAMP_MAX);
-
-		uclamp_se_set(&p->uclamp_req[clamp_id], clamp_value, false);
+		uclamp_se_set(&p->uclamp_req[clamp_id],
+			      uclamp_none(clamp_id), false);
 	}
 }
 
-- 
2.20.1


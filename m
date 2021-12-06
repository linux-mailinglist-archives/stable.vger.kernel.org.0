Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3327E469D2E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357903AbhLFP2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38978 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358915AbhLFPYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:24:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A8C461309;
        Mon,  6 Dec 2021 15:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF2EC341C1;
        Mon,  6 Dec 2021 15:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804044;
        bh=8ZFSuPn7+r7bBqe3Vgh0e7Q8oD5+dJ3P2gMCzTmiPsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbV5zIPT2D/Z8xUsc4DlZoFjpBi/e+hFJCjj/2qQ8Fl/wWwjY1TnYHKKiOS5gwdto
         hjcBqT+xEO/TPk3ql0bqzxK+UG4BjwRVb39JRMayzwocbgIaNabU0KPOL9MGhJCCvF
         CPHbyzirlJptcB3Lv2O3ZPUuPGn5nvgIxzC/4uHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/130] sched/uclamp: Fix rq->uclamp_max not set on first enqueue
Date:   Mon,  6 Dec 2021 15:57:05 +0100
Message-Id: <20211206145603.367006033@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit 315c4f884800c45cb6bd8c90422fad554a8b9588 ]

Commit d81ae8aac85c ("sched/uclamp: Fix initialization of struct
uclamp_rq") introduced a bug where uclamp_max of the rq is not reset to
match the woken up task's uclamp_max when the rq is idle.

The code was relying on rq->uclamp_max initialized to zero, so on first
enqueue

	static inline void uclamp_rq_inc_id(struct rq *rq, struct task_struct *p,
					    enum uclamp_id clamp_id)
	{
		...

		if (uc_se->value > READ_ONCE(uc_rq->value))
			WRITE_ONCE(uc_rq->value, uc_se->value);
	}

was actually resetting it. But since commit d81ae8aac85c changed the
default to 1024, this no longer works. And since rq->uclamp_flags is
also initialized to 0, neither above code path nor uclamp_idle_reset()
update the rq->uclamp_max on first wake up from idle.

This is only visible from first wake up(s) until the first dequeue to
idle after enabling the static key. And it only matters if the
uclamp_max of this task is < 1024 since only then its uclamp_max will be
effectively ignored.

Fix it by properly initializing rq->uclamp_flags = UCLAMP_FLAG_IDLE to
ensure uclamp_idle_reset() is called which then will update the rq
uclamp_max value as expected.

Fixes: d81ae8aac85c ("sched/uclamp: Fix initialization of struct uclamp_rq")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <Valentin.Schneider@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lkml.kernel.org/r/20211202112033.1705279-1-qais.yousef@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 304aad997da11..0a5f9fad45e4b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1526,7 +1526,7 @@ static void __init init_uclamp_rq(struct rq *rq)
 		};
 	}
 
-	rq->uclamp_flags = 0;
+	rq->uclamp_flags = UCLAMP_FLAG_IDLE;
 }
 
 static void __init init_uclamp(void)
-- 
2.33.0




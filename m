Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EFC469C3F
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349743AbhLFPV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238755AbhLFPTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:19:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BCCC0698C8;
        Mon,  6 Dec 2021 07:13:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA44161319;
        Mon,  6 Dec 2021 15:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB63C341C2;
        Mon,  6 Dec 2021 15:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803605;
        bh=kDLHJz7+1iszJ+bcYlCI0lFO6iKvuT4W9cMx767BR4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vN3xlP7wMktQga42j5oDIiAgMYjfUlFkj82T00Y3GrUHcBW3XU0dj1Z+zL0GE5OW
         cpNns+m2zWi0YUI2GdWYQ7qeBf3ANE8Xt5yAztLGcP6KCGApv4Rb22QEyCikWrDplP
         QeH4vGrE/HIp7wl0oF/ukBSUai5i9oztUIissS8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 52/70] sched/uclamp: Fix rq->uclamp_max not set on first enqueue
Date:   Mon,  6 Dec 2021 15:56:56 +0100
Message-Id: <20211206145553.715751226@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
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
index f8ca0738d729e..5befdecefe947 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1337,7 +1337,7 @@ static void __init init_uclamp_rq(struct rq *rq)
 		};
 	}
 
-	rq->uclamp_flags = 0;
+	rq->uclamp_flags = UCLAMP_FLAG_IDLE;
 }
 
 static void __init init_uclamp(void)
-- 
2.33.0




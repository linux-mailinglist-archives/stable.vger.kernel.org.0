Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27A0469F77
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390491AbhLFPpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390733AbhLFPmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD80CC07E5DF;
        Mon,  6 Dec 2021 07:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AED761344;
        Mon,  6 Dec 2021 15:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3277BC34902;
        Mon,  6 Dec 2021 15:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804612;
        bh=4pw0VYv5mwlJ72LATuT61xZUe9q2l/VHPts0GY/zCo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v03s4sayjXNADtmWxxvWZVSGUjn9cw4d/wNTNnKPheMQe2ZB2Ft7Jd0IUaS2oU7Wm
         Yho3Z0va9akM4Lm5yFjgOGJe5FJus6hkFVXI7QAsme8fouvg8X9XNH62MCOQN+3ZEy
         YLwi7phNe3IxcfqJMr0QT2iOtx2XgKYTBEnqm6Dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 177/207] sched/uclamp: Fix rq->uclamp_max not set on first enqueue
Date:   Mon,  6 Dec 2021 15:57:11 +0100
Message-Id: <20211206145616.395751048@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
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
index 4170ec15926ee..0d12ec7be3017 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1914,7 +1914,7 @@ static void __init init_uclamp_rq(struct rq *rq)
 		};
 	}
 
-	rq->uclamp_flags = 0;
+	rq->uclamp_flags = UCLAMP_FLAG_IDLE;
 }
 
 static void __init init_uclamp(void)
-- 
2.33.0




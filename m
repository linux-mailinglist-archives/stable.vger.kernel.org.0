Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23521320FE9
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 05:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhBVD7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 22:59:49 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12562 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhBVD7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Feb 2021 22:59:49 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DkT035kFLzMYdY;
        Mon, 22 Feb 2021 11:57:07 +0800 (CST)
Received: from code-website.localdomain (10.175.127.227) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Feb 2021 11:58:58 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <stable@vger.kernel.org>
CC:     <judy.chenhui@huawei.com>, <zhangjinhao2@huawei.com>,
        <lee.jones@linaro.org>, <tglx@linutronix.de>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 1/1] futex: Fix OWNER_DEAD fixup
Date:   Mon, 22 Feb 2021 12:06:18 +0800
Message-ID: <20210222040618.2911498-2-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210222040618.2911498-1-zhengyejian1@huawei.com>
References: <20210222040618.2911498-1-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit a97cb0e7b3f4c6297fd857055ae8e895f402f501 upstream.

Both Geert and DaveJ reported that the recent futex commit:

  c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")

introduced a problem with setting OWNER_DEAD. We set the bit on an
uninitialized variable and then entirely optimize it away as a
dead-store.

Move the setting of the bit to where it is more useful.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reported-by: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
Link: http://lkml.kernel.org/r/20180122103947.GD2228@hirez.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
---
 kernel/futex.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 199e63c5b612..70ad21bbb1d5 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2248,10 +2248,6 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 
 	oldowner = pi_state->owner;
 
-	/* Owner died? */
-	if (!pi_state->owner)
-		newtid |= FUTEX_OWNER_DIED;
-
 	/*
 	 * We are here because either:
 	 *
@@ -2309,6 +2305,9 @@ retry:
 	}
 
 	newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
+	/* Owner died? */
+	if (!pi_state->owner)
+		newtid |= FUTEX_OWNER_DIED;
 
 	if (get_futex_value_locked(&uval, uaddr))
 		goto handle_fault;
-- 
2.25.4


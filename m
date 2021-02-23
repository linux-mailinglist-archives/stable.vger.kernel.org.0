Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E21322C73
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 15:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbhBWOfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 09:35:46 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12947 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbhBWOfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 09:35:41 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DlM3m0cfWzjPqq;
        Tue, 23 Feb 2021 22:33:24 +0800 (CST)
Received: from code-website.localdomain (10.175.127.227) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Tue, 23 Feb 2021 22:34:33 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <gregkh@linuxfoundation.org>, <lee.jones@linaro.org>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <tglx@linutronix.de>, <cj.chengjian@huawei.com>,
        <judy.chenhui@huawei.com>, <zhangjinhao2@huawei.com>
Subject: [PATCH 4.9.y 1/1] futex: Fix OWNER_DEAD fixup
Date:   Tue, 23 Feb 2021 22:41:51 +0800
Message-ID: <20210223144151.916675-2-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210223144151.916675-1-zhengyejian1@huawei.com>
References: <20210223144151.916675-1-zhengyejian1@huawei.com>
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
 kernel/futex.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index b65dbb5d60bb..604d1cb9839d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2424,9 +2424,6 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	int err = 0;
 
 	oldowner = pi_state->owner;
-	/* Owner died? */
-	if (!pi_state->owner)
-		newtid |= FUTEX_OWNER_DIED;
 
 	/*
 	 * We are here because either:
@@ -2484,6 +2481,9 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	}
 
 	newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
+	/* Owner died? */
+	if (!pi_state->owner)
+		newtid |= FUTEX_OWNER_DIED;
 
 	if (get_futex_value_locked(&uval, uaddr))
 		goto handle_fault;
-- 
2.25.4


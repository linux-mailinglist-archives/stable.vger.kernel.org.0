Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83A83DD7D1
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbhHBNsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:17 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:12337 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234284AbhHBNrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 09:47:36 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GdfM33TBhz81w6;
        Mon,  2 Aug 2021 21:42:23 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 21:47:12 +0800
Received: from thunder-town.china.huawei.com (10.174.179.0) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 21:47:11 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Mike Galbraith <efault@gmx.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4.4 01/11] futex: Rename free_pi_state() to put_pi_state()
Date:   Mon, 2 Aug 2021 21:46:14 +0800
Message-ID: <20210802134624.1934-2-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210802134624.1934-1-thunder.leizhen@huawei.com>
References: <20210802134624.1934-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.0]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 29e9ee5d48c35d6cf8afe09bdf03f77125c9ac11 ]

free_pi_state() is confusing as it is in fact only freeing/caching the
pi state when the last reference is gone. Rename it to put_pi_state()
which reflects better what it is doing.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <darren@dvhart.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Bhuvanesh_Surachari@mentor.com
Cc: Andy Lowe <Andy_Lowe@mentor.com>
Link: http://lkml.kernel.org/r/20151219200607.259636467@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/futex.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index ff5499b0c5b34f7..dbb38e14f6fcc8e 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -859,9 +859,12 @@ static void pi_state_update_owner(struct futex_pi_state *pi_state,
 }
 
 /*
+ * Drops a reference to the pi_state object and frees or caches it
+ * when the last reference is gone.
+ *
  * Must be called with the hb lock held.
  */
-static void free_pi_state(struct futex_pi_state *pi_state)
+static void put_pi_state(struct futex_pi_state *pi_state)
 {
 	if (!pi_state)
 		return;
@@ -2121,7 +2124,7 @@ retry_private:
 		case 0:
 			break;
 		case -EFAULT:
-			free_pi_state(pi_state);
+			put_pi_state(pi_state);
 			pi_state = NULL;
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
@@ -2139,7 +2142,7 @@ retry_private:
 			 *   exit to complete.
 			 * - EAGAIN: The user space value changed.
 			 */
-			free_pi_state(pi_state);
+			put_pi_state(pi_state);
 			pi_state = NULL;
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
@@ -2214,7 +2217,7 @@ retry_private:
 			} else if (ret) {
 				/* -EDEADLK */
 				this->pi_state = NULL;
-				free_pi_state(pi_state);
+				put_pi_state(pi_state);
 				goto out_unlock;
 			}
 		}
@@ -2223,7 +2226,7 @@ retry_private:
 	}
 
 out_unlock:
-	free_pi_state(pi_state);
+	put_pi_state(pi_state);
 	double_unlock_hb(hb1, hb2);
 	wake_up_q(&wake_q);
 	hb_waiters_dec(hb2);
@@ -2376,7 +2379,7 @@ static void unqueue_me_pi(struct futex_q *q)
 	__unqueue_futex(q);
 
 	BUG_ON(!q->pi_state);
-	free_pi_state(q->pi_state);
+	put_pi_state(q->pi_state);
 	q->pi_state = NULL;
 
 	spin_unlock(q->lock_ptr);
@@ -3210,7 +3213,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 			 * Drop the reference to the pi state which
 			 * the requeue_pi() code acquired for us.
 			 */
-			free_pi_state(q.pi_state);
+			put_pi_state(q.pi_state);
 			spin_unlock(q.lock_ptr);
 			/*
 			 * Adjust the return value. It's either -EFAULT or
-- 
2.26.0.106.g9fadedd


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EECB3E3965
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 09:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhHHHXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 03:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229597AbhHHHXJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 03:23:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B04860EB5;
        Sun,  8 Aug 2021 07:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628407370;
        bh=XtDAjX3F6gbb8u7WB9jFRNSWKJRTjIzxZak8kv4FB5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dE3EsjovAOYSo6ttY2YDRKfHPrZbhhuZxzp/Org21wPdHebP1jGZp0QRyf3wPPJYx
         oTk52n5sKJITUBuGEpMHGjL27BLslCNpeOBKuzkdAdm9CBEVhJJ2OLN61/iv2jOu7o
         znTj5LK4+PbHwoIk3TjDJ9ijqw6qm/2m9zY9OwXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <darren@dvhart.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Bhuvanesh_Surachari@mentor.com, Andy Lowe <Andy_Lowe@mentor.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Joe Korty <joe.korty@concurrent-rt.com>
Subject: [PATCH 4.4 01/11] futex: Rename free_pi_state() to put_pi_state()
Date:   Sun,  8 Aug 2021 09:22:36 +0200
Message-Id: <20210808072217.370033756@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210808072217.322468704@linuxfoundation.org>
References: <20210808072217.322468704@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Acked-by: Joe Korty <joe.korty@concurrent-rt.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -859,9 +859,12 @@ static void pi_state_update_owner(struct
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
@@ -2376,7 +2379,7 @@ static void unqueue_me_pi(struct futex_q
 	__unqueue_futex(q);
 
 	BUG_ON(!q->pi_state);
-	free_pi_state(q->pi_state);
+	put_pi_state(q->pi_state);
 	q->pi_state = NULL;
 
 	spin_unlock(q->lock_ptr);
@@ -3210,7 +3213,7 @@ static int futex_wait_requeue_pi(u32 __u
 			 * Drop the reference to the pi state which
 			 * the requeue_pi() code acquired for us.
 			 */
-			free_pi_state(q.pi_state);
+			put_pi_state(q.pi_state);
 			spin_unlock(q.lock_ptr);
 			/*
 			 * Adjust the return value. It's either -EFAULT or



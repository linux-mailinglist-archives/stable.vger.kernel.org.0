Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19A632EAFE
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhCEMl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:41:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233216AbhCEMlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:41:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 503F46501C;
        Fri,  5 Mar 2021 12:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948065;
        bh=7npBarqLA0Rsh9MC+V4ykiDQW5h1UgNyiRXiWlKKHFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAAjoT0FMncmQwqaE60nJdSYfDgmI86kwaS7gcUP1PyYpQY3Op6V4qWAe042LdPpA
         8pmsZjoVUFGUlAL6+q2fLSbwNGVYK7UDYUqzpp8AiZeYHHRJV9CEjXl3WRa8om9aQ4
         NS/StAdegEdEPEW5ghQNCA7f9g1ZbrnDmYJ8w0+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gratian Crisan <gratian.crisan@ni.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, dvhart@infradead.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 05/41] futex: Fix pi_state->owner serialization
Date:   Fri,  5 Mar 2021 13:22:12 +0100
Message-Id: <20210305120851.538190367@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.255002428@linuxfoundation.org>
References: <20210305120851.255002428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

From: Peter Zijlstra <peterz@infradead.org>

commit c74aef2d06a9f59cece89093eecc552933cba72a upstream.

There was a reported suspicion about a race between exit_pi_state_list()
and put_pi_state(). The same report mentioned the comment with
put_pi_state() said it should be called with hb->lock held, and it no
longer is in all places.

As it turns out, the pi_state->owner serialization is indeed broken. As per
the new rules:

  734009e96d19 ("futex: Change locking rules")

pi_state->owner should be serialized by pi_state->pi_mutex.wait_lock.
For the sites setting pi_state->owner we already hold wait_lock (where
required) but exit_pi_state_list() and put_pi_state() were not and
raced on clearing it.

Fixes: 734009e96d19 ("futex: Change locking rules")
Reported-by: Gratian Crisan <gratian.crisan@ni.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: dvhart@infradead.org
Cc: stable@vger.kernel.org
Link:
https://lkml.kernel.org/r/20170922154806.jd3ffltfk24m4o4y@hirez.programming.kicks-ass.net
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -868,8 +868,6 @@ static void get_pi_state(struct futex_pi
 /*
  * Drops a reference to the pi_state object and frees or caches it
  * when the last reference is gone.
- *
- * Must be called with the hb lock held.
  */
 static void put_pi_state(struct futex_pi_state *pi_state)
 {
@@ -884,13 +882,15 @@ static void put_pi_state(struct futex_pi
 	 * and has cleaned up the pi_state already
 	 */
 	if (pi_state->owner) {
+		raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 		pi_state_update_owner(pi_state, NULL);
 		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
+		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 	}
 
-	if (current->pi_state_cache)
+	if (current->pi_state_cache) {
 		kfree(pi_state);
-	else {
+	} else {
 		/*
 		 * pi_state->list is already empty.
 		 * clear pi_state->owner.
@@ -949,13 +949,14 @@ static void exit_pi_state_list(struct ta
 		raw_spin_unlock_irq(&curr->pi_lock);
 
 		spin_lock(&hb->lock);
-
-		raw_spin_lock_irq(&curr->pi_lock);
+		raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
+		raw_spin_lock(&curr->pi_lock);
 		/*
 		 * We dropped the pi-lock, so re-check whether this
 		 * task still owns the PI-state:
 		 */
 		if (head->next != next) {
+			raw_spin_unlock(&pi_state->pi_mutex.wait_lock);
 			spin_unlock(&hb->lock);
 			continue;
 		}
@@ -964,9 +965,10 @@ static void exit_pi_state_list(struct ta
 		WARN_ON(list_empty(&pi_state->list));
 		list_del_init(&pi_state->list);
 		pi_state->owner = NULL;
-		raw_spin_unlock_irq(&curr->pi_lock);
+		raw_spin_unlock(&curr->pi_lock);
 
 		get_pi_state(pi_state);
+		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 		spin_unlock(&hb->lock);
 
 		rt_mutex_futex_unlock(&pi_state->pi_mutex);
@@ -1349,6 +1351,10 @@ static int attach_to_pi_owner(u32 __user
 
 	WARN_ON(!list_empty(&pi_state->list));
 	list_add(&pi_state->list, &p->pi_state_list);
+	/*
+	 * Assignment without holding pi_state->pi_mutex.wait_lock is safe
+	 * because there is no concurrency as the object is not published yet.
+	 */
 	pi_state->owner = p;
 	raw_spin_unlock_irq(&p->pi_lock);
 
@@ -3027,6 +3033,7 @@ retry:
 		raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 		spin_unlock(&hb->lock);
 
+		/* drops pi_state->pi_mutex.wait_lock */
 		ret = wake_futex_pi(uaddr, uval, pi_state);
 
 		put_pi_state(pi_state);



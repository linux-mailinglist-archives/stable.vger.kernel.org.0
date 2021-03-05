Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D28232EB00
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbhCEMl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:41:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:57068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230098AbhCEMlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:41:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0310465026;
        Fri,  5 Mar 2021 12:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948068;
        bh=6jVLCmahcAqD4Du+/GFvsamNdK/11cFu0c+HA7u07dU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xcE1jnaDTA3mquAXCOW4Epd5xQLbELDINlfg39h0Cimf254GCnPiT8u0SWANwNBrj
         RLX9nWhCVq3Sg99zSl8UhuW01mz5jkBhnVZ8Tm8ELsfCXqQ/NvOuhR2XLDG3/rE+7J
         RWlOLourv90rd4xVxAB7VRCYWkzwXC9nhS1pDiZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gratian Crisan <gratian.crisan@ni.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        dvhart@infradead.org,
        syzbot 
        <bot+2af19c9e1ffe4d4ee1d16c56ae7580feaee75765@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com, Ingo Molnar <mingo@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 06/41] futex: Fix more put_pi_state() vs. exit_pi_state_list() races
Date:   Fri,  5 Mar 2021 13:22:13 +0100
Message-Id: <20210305120851.592796620@linuxfoundation.org>
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

commit 153fbd1226fb30b8630802aa5047b8af5ef53c9f upstream.

Dmitry (through syzbot) reported being able to trigger the WARN in
get_pi_state() and a use-after-free on:

	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);

Both are due to this race:

  exit_pi_state_list()				put_pi_state()

  lock(&curr->pi_lock)
  while() {
	pi_state = list_first_entry(head);
	hb = hash_futex(&pi_state->key);
	unlock(&curr->pi_lock);

						dec_and_test(&pi_state->refcount);

	lock(&hb->lock)
	lock(&pi_state->pi_mutex.wait_lock)	// uaf if pi_state free'd
	lock(&curr->pi_lock);

	....

	unlock(&curr->pi_lock);
	get_pi_state();				// WARN; refcount==0

The problem is we take the reference count too late, and don't allow it
being 0. Fix it by using inc_not_zero() and simply retrying the loop
when we fail to get a refcount. In that case put_pi_state() should
remove the entry from the list.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Gratian Crisan <gratian.crisan@ni.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: dvhart@infradead.org
Cc: syzbot <bot+2af19c9e1ffe4d4ee1d16c56ae7580feaee75765@syzkaller.appspotmail.com>
Cc: syzkaller-bugs@googlegroups.com
Cc: <stable@vger.kernel.org>
Fixes: c74aef2d06a9 ("futex: Fix pi_state->owner serialization")
Link: http://lkml.kernel.org/r/20171031101853.xpfh72y643kdfhjs@hirez.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -941,11 +941,27 @@ static void exit_pi_state_list(struct ta
 	 */
 	raw_spin_lock_irq(&curr->pi_lock);
 	while (!list_empty(head)) {
-
 		next = head->next;
 		pi_state = list_entry(next, struct futex_pi_state, list);
 		key = pi_state->key;
 		hb = hash_futex(&key);
+
+		/*
+		 * We can race against put_pi_state() removing itself from the
+		 * list (a waiter going away). put_pi_state() will first
+		 * decrement the reference count and then modify the list, so
+		 * its possible to see the list entry but fail this reference
+		 * acquire.
+		 *
+		 * In that case; drop the locks to let put_pi_state() make
+		 * progress and retry the loop.
+		 */
+		if (!atomic_inc_not_zero(&pi_state->refcount)) {
+			raw_spin_unlock_irq(&curr->pi_lock);
+			cpu_relax();
+			raw_spin_lock_irq(&curr->pi_lock);
+			continue;
+		}
 		raw_spin_unlock_irq(&curr->pi_lock);
 
 		spin_lock(&hb->lock);
@@ -956,8 +972,10 @@ static void exit_pi_state_list(struct ta
 		 * task still owns the PI-state:
 		 */
 		if (head->next != next) {
+			/* retain curr->pi_lock for the loop invariant */
 			raw_spin_unlock(&pi_state->pi_mutex.wait_lock);
 			spin_unlock(&hb->lock);
+			put_pi_state(pi_state);
 			continue;
 		}
 
@@ -965,9 +983,8 @@ static void exit_pi_state_list(struct ta
 		WARN_ON(list_empty(&pi_state->list));
 		list_del_init(&pi_state->list);
 		pi_state->owner = NULL;
-		raw_spin_unlock(&curr->pi_lock);
 
-		get_pi_state(pi_state);
+		raw_spin_unlock(&curr->pi_lock);
 		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 		spin_unlock(&hb->lock);
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94754CF6EA
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237710AbiCGJnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238131AbiCGJiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:38:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D706E8DF;
        Mon,  7 Mar 2022 01:32:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2747B810B2;
        Mon,  7 Mar 2022 09:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011DEC340F3;
        Mon,  7 Mar 2022 09:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645514;
        bh=+EcvuLiYreX1Jyhq0no6qLpd/p1oetWYBxNEQaICPm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vD1SL8NtdhDU8J+26MrKmA6WXTBXQKoBUR/flPV3wyC6QA0qBxKNALDZ67AP5ptTu
         DpS81sq5SIHM7e3L/xoyC0XI+an8htumWrrq0dCzvYBbU+bS1Wl/3dBkkLTonEJGy1
         LumYp07IhI0Gxr+8iJA9wWoVvJqmz5TI3HiBw2DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 5.10 054/105] rcu/nocb: Fix missed nocb_timer requeue
Date:   Mon,  7 Mar 2022 10:18:57 +0100
Message-Id: <20220307091645.702572430@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

commit b2fcf2102049f6e56981e0ab3d9b633b8e2741da upstream.

This sequence of events can lead to a failure to requeue a CPU's
->nocb_timer:

1.	There are no callbacks queued for any CPU covered by CPU 0-2's
	->nocb_gp_kthread.  Note that ->nocb_gp_kthread is associated
	with CPU 0.

2.	CPU 1 enqueues its first callback with interrupts disabled, and
	thus must defer awakening its ->nocb_gp_kthread.  It therefore
	queues its rcu_data structure's ->nocb_timer.  At this point,
	CPU 1's rdp->nocb_defer_wakeup is RCU_NOCB_WAKE.

3.	CPU 2, which shares the same ->nocb_gp_kthread, also enqueues a
	callback, but with interrupts enabled, allowing it to directly
	awaken the ->nocb_gp_kthread.

4.	The newly awakened ->nocb_gp_kthread associates both CPU 1's
	and CPU 2's callbacks with a future grace period and arranges
	for that grace period to be started.

5.	This ->nocb_gp_kthread goes to sleep waiting for the end of this
	future grace period.

6.	This grace period elapses before the CPU 1's timer fires.
	This is normally improbably given that the timer is set for only
	one jiffy, but timers can be delayed.  Besides, it is possible
	that kernel was built with CONFIG_RCU_STRICT_GRACE_PERIOD=y.

7.	The grace period ends, so rcu_gp_kthread awakens the
	->nocb_gp_kthread, which in turn awakens both CPU 1's and
	CPU 2's ->nocb_cb_kthread.  Then ->nocb_gb_kthread sleeps
	waiting for more newly queued callbacks.

8.	CPU 1's ->nocb_cb_kthread invokes its callback, then sleeps
	waiting for more invocable callbacks.

9.	Note that neither kthread updated any ->nocb_timer state,
	so CPU 1's ->nocb_defer_wakeup is still set to RCU_NOCB_WAKE.

10.	CPU 1 enqueues its second callback, this time with interrupts
 	enabled so it can wake directly	->nocb_gp_kthread.
	It does so with calling wake_nocb_gp() which also cancels the
	pending timer that got queued in step 2. But that doesn't reset
	CPU 1's ->nocb_defer_wakeup which is still set to RCU_NOCB_WAKE.
	So CPU 1's ->nocb_defer_wakeup and its ->nocb_timer are now
	desynchronized.

11.	->nocb_gp_kthread associates the callback queued in 10 with a new
	grace period, arranges for that grace period to start and sleeps
	waiting for it to complete.

12.	The grace period ends, rcu_gp_kthread awakens ->nocb_gp_kthread,
	which in turn wakes up CPU 1's ->nocb_cb_kthread which then
	invokes the callback queued in 10.

13.	CPU 1 enqueues its third callback, this time with interrupts
	disabled so it must queue a timer for a deferred wakeup. However
	the value of its ->nocb_defer_wakeup is RCU_NOCB_WAKE which
	incorrectly indicates that a timer is already queued.  Instead,
	CPU 1's ->nocb_timer was cancelled in 10.  CPU 1 therefore fails
	to queue the ->nocb_timer.

14.	CPU 1 has its pending callback and it may go unnoticed until
	some other CPU ever wakes up ->nocb_gp_kthread or CPU 1 ever
	calls an explicit deferred wakeup, for example, during idle entry.

This commit fixes this bug by resetting rdp->nocb_defer_wakeup everytime
we delete the ->nocb_timer.

It is quite possible that there is a similar scenario involving
->nocb_bypass_timer and ->nocb_defer_wakeup.  However, despite some
effort from several people, a failure scenario has not yet been located.
However, that by no means guarantees that no such scenario exists.
Finding a failure scenario is left as an exercise for the reader, and the
"Fixes:" tag below relates to ->nocb_bypass_timer instead of ->nocb_timer.

Fixes: d1b222c6be1f (rcu/nocb: Add bypass callback queueing)
Cc: <stable@vger.kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tree_plugin.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1646,7 +1646,11 @@ static void wake_nocb_gp(struct rcu_data
 		rcu_nocb_unlock_irqrestore(rdp, flags);
 		return;
 	}
-	del_timer(&rdp->nocb_timer);
+
+	if (READ_ONCE(rdp->nocb_defer_wakeup) > RCU_NOCB_WAKE_NOT) {
+		WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
+		del_timer(&rdp->nocb_timer);
+	}
 	rcu_nocb_unlock_irqrestore(rdp, flags);
 	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
 	if (force || READ_ONCE(rdp_gp->nocb_gp_sleep)) {
@@ -2164,7 +2168,6 @@ static void do_nocb_deferred_wakeup_comm
 		return;
 	}
 	ndw = READ_ONCE(rdp->nocb_defer_wakeup);
-	WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
 	wake_nocb_gp(rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
 	trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("DeferredWake"));
 }



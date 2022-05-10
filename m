Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADCA521A0E
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243298AbiEJNxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245002AbiEJNrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072053B3CF;
        Tue, 10 May 2022 06:33:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0F57B81D24;
        Tue, 10 May 2022 13:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA72EC385C2;
        Tue, 10 May 2022 13:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189607;
        bh=irB8NTev9xa9lpY3OQpWk1fLdyWlxyfi8AVBIBkf/Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jw97UV4SHoLcX5ChbJvMpjlNlbN97ZoksGsvFZqqS7uLD5FVOMcSpW7gFa8rm2nDC
         WDBMQ+/adYk5gfMmGR4mHfYKWJRvBf/6EOaWDMwzsCbe9e4Bqj0ZtxPfNd71CWkCMg
         ZGeRkr5slDi2oS5v/EIpMUal6WdXnFnT/1SZWjJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.15 105/135] rcu: Apply callbacks processing time limit only on softirq
Date:   Tue, 10 May 2022 15:08:07 +0200
Message-Id: <20220510130743.419301937@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

commit a554ba288845fd3f6f12311fd76a51694233458a upstream.

Time limit only makes sense when callbacks are serviced in softirq mode
because:

_ In case we need to get back to the scheduler,
  cond_resched_tasks_rcu_qs() is called after each callback.

_ In case some other softirq vector needs the CPU, the call to
  local_bh_enable() before cond_resched_tasks_rcu_qs() takes care about
  them via a call to do_softirq().

Therefore, make sure the time limit only applies to softirq mode.

Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Tested-by: Valentin Schneider <valentin.schneider@arm.com>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
[UR: backport to 5.15-stable]
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tree.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2476,7 +2476,7 @@ static void rcu_do_batch(struct rcu_data
 	div = READ_ONCE(rcu_divisor);
 	div = div < 0 ? 7 : div > sizeof(long) * 8 - 2 ? sizeof(long) * 8 - 2 : div;
 	bl = max(rdp->blimit, pending >> div);
-	if (unlikely(bl > 100)) {
+	if (in_serving_softirq() && unlikely(bl > 100)) {
 		long rrn = READ_ONCE(rcu_resched_ns);
 
 		rrn = rrn < NSEC_PER_MSEC ? NSEC_PER_MSEC : rrn > NSEC_PER_SEC ? NSEC_PER_SEC : rrn;
@@ -2517,6 +2517,18 @@ static void rcu_do_batch(struct rcu_data
 			if (count >= bl && (need_resched() ||
 					(!is_idle_task(current) && !rcu_is_callbacks_kthread())))
 				break;
+
+			/*
+			 * Make sure we don't spend too much time here and deprive other
+			 * softirq vectors of CPU cycles.
+			 */
+			if (unlikely(tlimit)) {
+				/* only call local_clock() every 32 callbacks */
+				if (likely((count & 31) || local_clock() < tlimit))
+					continue;
+				/* Exceeded the time limit, so leave. */
+				break;
+			}
 		} else {
 			local_bh_enable();
 			lockdep_assert_irqs_enabled();
@@ -2524,18 +2536,6 @@ static void rcu_do_batch(struct rcu_data
 			lockdep_assert_irqs_enabled();
 			local_bh_disable();
 		}
-
-		/*
-		 * Make sure we don't spend too much time here and deprive other
-		 * softirq vectors of CPU cycles.
-		 */
-		if (unlikely(tlimit)) {
-			/* only call local_clock() every 32 callbacks */
-			if (likely((count & 31) || local_clock() < tlimit))
-				continue;
-			/* Exceeded the time limit, so leave. */
-			break;
-		}
 	}
 
 	local_irq_save(flags);



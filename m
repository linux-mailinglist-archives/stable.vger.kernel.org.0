Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A8E5218CF
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243411AbiEJNkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245163AbiEJNig (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09353262643;
        Tue, 10 May 2022 06:27:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5B33B81DA2;
        Tue, 10 May 2022 13:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE139C385C6;
        Tue, 10 May 2022 13:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189267;
        bh=NMFFJtZLPoq1knCC/w0d1kwtFNpn/m+HxWT5aO4P7g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFzrkqqWcFHuqGknCvnPOwA0OMAtzq+rgdMjObePyDRbBqrnWG6bgRXucIkRKtyo0
         WImRhGo6kv3kCCxN5G+B0jLVTnaUcvpHBNAL08RsTAOOW4UbUEvMxwKOQXxiZ/Rr1K
         ey36orMIPitqIVvVLETCESkONDR+2VYYZYX+g2CQ=
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
Subject: [PATCH 5.10 64/70] rcu: Fix callbacks processing time limit retaining cond_resched()
Date:   Tue, 10 May 2022 15:08:23 +0200
Message-Id: <20220510130734.740079392@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
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

commit 3e61e95e2d095e308616cba4ffb640f95a480e01 upstream.

The callbacks processing time limit makes sure we are not exceeding a
given amount of time executing the queue.

However its "continue" clause bypasses the cond_resched() call on
rcuc and NOCB kthreads, delaying it until we reach the limit, which can
be very long...

Make sure the scheduler has a higher priority than the time limit.

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
[UR: backport to 5.10-stable + commit update]
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tree.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2490,10 +2490,22 @@ static void rcu_do_batch(struct rcu_data
 		 * Stop only if limit reached and CPU has something to do.
 		 * Note: The rcl structure counts down from zero.
 		 */
-		if (-rcl.len >= bl && !offloaded &&
-		    (need_resched() ||
-		     (!is_idle_task(current) && !rcu_is_callbacks_kthread())))
-			break;
+		if (in_serving_softirq()) {
+			if (-rcl.len >= bl && (need_resched() ||
+					(!is_idle_task(current) && !rcu_is_callbacks_kthread())))
+				break;
+		} else {
+			local_bh_enable();
+			lockdep_assert_irqs_enabled();
+			cond_resched_tasks_rcu_qs();
+			lockdep_assert_irqs_enabled();
+			local_bh_disable();
+		}
+
+		/*
+		 * Make sure we don't spend too much time here and deprive other
+		 * softirq vectors of CPU cycles.
+		 */
 		if (unlikely(tlimit)) {
 			/* only call local_clock() every 32 callbacks */
 			if (likely((-rcl.len & 31) || local_clock() < tlimit))
@@ -2501,14 +2513,6 @@ static void rcu_do_batch(struct rcu_data
 			/* Exceeded the time limit, so leave. */
 			break;
 		}
-		if (offloaded) {
-			WARN_ON_ONCE(in_serving_softirq());
-			local_bh_enable();
-			lockdep_assert_irqs_enabled();
-			cond_resched_tasks_rcu_qs();
-			lockdep_assert_irqs_enabled();
-			local_bh_disable();
-		}
 	}
 
 	local_irq_save(flags);



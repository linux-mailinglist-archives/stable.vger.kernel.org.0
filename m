Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BDE518D11
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 21:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241813AbiECTU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 15:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238334AbiECTU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 15:20:57 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95BD3FBCD;
        Tue,  3 May 2022 12:17:23 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id bu29so32001755lfb.0;
        Tue, 03 May 2022 12:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VUDBLTzcrH8vC349gdMLFCYtJCq5Ckdh0XpucRjLafo=;
        b=StEY7wd6bWbpqY3DWwBVkQ3lW3AE3eDV2wGkFjK+wHJaNW7TuL7JtpI+Jr2GKTVQI/
         xqRWA1cE7194UW09Lei+nh+/UJ3iCn4CISTYIR6cZzpqMEdwNJu4atO6LUM+3RNPnch+
         e7MWO1z15p60qXCJOiKKybKZAtEg389wphipgSpGPjNVZ1ZFt1tKR63rtgMd/DltLU0g
         p6T1T8AJn5Zk+Hh+VsZDQ0IWWWDp5jFnUc1QAT/HXQXXk32wxKb8VyC2H+eZPWFJRYt9
         d4+AQbZFMq7FlPKP3MvVzEudz91/RmMMthX7KNnsl0XLzPWNxrKKQPcy4lNmhkfwNBmX
         wjHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VUDBLTzcrH8vC349gdMLFCYtJCq5Ckdh0XpucRjLafo=;
        b=zblw/Mo+3pwcMrwmmfbQ/byQWtYden7E0PdKehH9HD0JivTjfKD6aebAyxhR4V4KtR
         ClEETvbx8iaG0VOX3Ll2LmBW2459+6z4PxiYl09cGgILm82GRyE3fFJ5B73zW3F9XxdB
         3Dcl/RV7guJX+AFKKkAnmgQFlkQQb3MnBd6kF8arAHKA1HnPPlMOI63EBWu4dOfcpUKS
         muLxAPvVgLb9O86iMCAJ2gCMbseekVG3QK7FnFz2INNw7emdsRR2mS7nrHpyUyAvOulj
         r2iNq6L9X8mqiHG0pqkwSfIQNGA3OMjFXI++EnEdaDmKv2p4nqk4fnmBbuerPJdQ41Fw
         We+Q==
X-Gm-Message-State: AOAM531mxVfREJ+tj3GdHMzGNJosQSXBEEPX/Dh7JT9OBfZjGnN0+SFx
        BBrhLm3wG2TMraXRKw8sSJgU+QLBU6yAxA==
X-Google-Smtp-Source: ABdhPJwOzCgBuVapVlbRcJNeEnrC+m++HC5URXzcRN9/GXSUmzK+X+jG7tK3LIwAh8zXVczWXs/M9g==
X-Received: by 2002:a05:6512:31d3:b0:473:a680:2616 with SMTP id j19-20020a05651231d300b00473a6802616mr3796778lfe.570.1651605442078;
        Tue, 03 May 2022 12:17:22 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id f13-20020ac2532d000000b0047255d211bfsm1014094lfh.238.2022.05.03.12.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 12:17:21 -0700 (PDT)
From:   "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To:     stable@vger.kernel.org
Cc:     RCU <rcu@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Neeraj Upadhyay <neeraj.iitr10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] rcu: [for 5.15 stable] Apply callbacks processing time limit only on softirq
Date:   Tue,  3 May 2022 21:17:09 +0200
Message-Id: <20220503191709.155266-3-urezki@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220503191709.155266-1-urezki@gmail.com>
References: <20220503191709.155266-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
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

Fixes: cfcdef5e30469 ("rcu: Allow rcu_do_batch() to dynamically adjust batch sizes")
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
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
[UR: backport to 5.15-stable]
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 kernel/rcu/tree.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index a968cc67b2bd..a4a9d68b1fdc 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2476,7 +2476,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
 	div = READ_ONCE(rcu_divisor);
 	div = div < 0 ? 7 : div > sizeof(long) * 8 - 2 ? sizeof(long) * 8 - 2 : div;
 	bl = max(rdp->blimit, pending >> div);
-	if (unlikely(bl > 100)) {
+	if (in_serving_softirq() && unlikely(bl > 100)) {
 		long rrn = READ_ONCE(rcu_resched_ns);
 
 		rrn = rrn < NSEC_PER_MSEC ? NSEC_PER_MSEC : rrn > NSEC_PER_SEC ? NSEC_PER_SEC : rrn;
@@ -2517,6 +2517,18 @@ static void rcu_do_batch(struct rcu_data *rdp)
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
@@ -2524,18 +2536,6 @@ static void rcu_do_batch(struct rcu_data *rdp)
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
-- 
2.30.2


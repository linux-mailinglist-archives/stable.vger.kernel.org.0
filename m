Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59A1517728
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 21:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbiEBTMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 15:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbiEBTMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 15:12:15 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7ABEDE9C;
        Mon,  2 May 2022 12:08:44 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id p10so26840965lfa.12;
        Mon, 02 May 2022 12:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hPZZ6L003TnmtW8H/x7i4WT6RIl/IYaipngJo7yayTU=;
        b=VHwxRKMsyiaZP7rVTuzt5IKY13rMrfD2ktP58pwhfCDmsqaj61PLgQH5EfbZozhWo5
         P1X5cx0Zx4SzuMWSGE7ucGyGnUFbz27uF4aLen60uDiwbuxsAAwahtaVpUZ7jXH8gScI
         SdlnJ7FPEXMC/Ys6zLRb47Rh10DOUxmfDmQVx3vNw2rhEJK4Y5J5bqHNWj7oixN43RB2
         1LAdgu4eNXYSkIQftPihX9tS3hGgJqK9Tkx3YCpjSFwOL6c0uDMzCT+1VDqD08puaIbK
         ApCO17sSkoFEMB6pEdk5w91kndYiznlYjJqEKwAVRn6AwZEh3sSFRaISdSJhj4QR9Egb
         Zrlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hPZZ6L003TnmtW8H/x7i4WT6RIl/IYaipngJo7yayTU=;
        b=wXtAhXKNzu0Y6lL9lBZME42r7W5KyC0XJtETWeY60hfG0geSLblyFAg/YWH++TpeSa
         bUI3eMTRwpy6Of8KiVWxR91UQBkVPtR2tYrCxrNKb9srTtVoeeObCbmOCx2javjJ5KxS
         rFXj9P/YmJPHrDk1UnFRn/iDOx4o9I1z0y26sbo5O+r1Zd2mkp+mSfD3AHMuOvKrMVom
         KLX4TXWpFlPcY4HJxhK+C8M2rNiMpsuyjBDUtzNiaaAKjnVXiZXdykIL7YKJnOCQbrTn
         sScht3xeyf/Rk5cEPd7Mca5g9fGTz5lHxcrLmvkh4kfOvgKQQRnBw23BdwHksYozaqvV
         njWA==
X-Gm-Message-State: AOAM531AmCSyjCojpHuWE6nCfhhZbDkAk1t1p+y1T0lwiIRt16iJBEVH
        sVrA5va3ou2dy/KuALXCfdewsPwQg3RaAw==
X-Google-Smtp-Source: ABdhPJxKwAb8OvJzdWoxLCaxLRf87nidkm7kdcXRK2yNHl/KdekNX+TLDNZ46FgTFFClOMgo4d7I7g==
X-Received: by 2002:a05:6512:c0a:b0:473:7b98:8d42 with SMTP id z10-20020a0565120c0a00b004737b988d42mr4490658lfu.511.1651518522967;
        Mon, 02 May 2022 12:08:42 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id bj39-20020a2eaaa7000000b0024f3d1daeadsm1131483ljb.53.2022.05.02.12.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 12:08:42 -0700 (PDT)
From:   "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To:     stable@vger.kernel.org
Cc:     RCU <rcu@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: [PATCH 1/2] rcu: Fix callbacks processing time limit retaining cond_resched()
Date:   Mon,  2 May 2022 21:08:32 +0200
Message-Id: <20220502190833.3352-2-urezki@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220502190833.3352-1-urezki@gmail.com>
References: <20220502190833.3352-1-urezki@gmail.com>
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

commit 3e61e95e2d095e308616cba4ffb640f95a480e01 upstream.

The callbacks processing time limit makes sure we are not exceeding a
given amount of time executing the queue.

However its "continue" clause bypasses the cond_resched() call on
rcuc and NOCB kthreads, delaying it until we reach the limit, which can
be very long...

Make sure the scheduler has a higher priority than the time limit.

Motivation of backport:
-----------------------

1. The cfcdef5e30469 ("rcu: Allow rcu_do_batch() to dynamically adjust batch sizes")
broke the default behaviour of "offloading rcu callbacks" setup. In that scenario
after each callback the caller context was used to check if it has to be rescheduled
giving a CPU time for others. After that change an "offloaded" setup can switch to
time-based RCU callbacks processing, what can be long for latency sensitive workloads
and SCHED_FIFO processes, i.e. callbacks are invoked for a long time with keeping
preemption off and without checking cond_resched().

2. Our devices which run Android and 5.10 kernel have some critical areas which
are sensitive to latency. It is a low latency audio, 8k video, UI stack and so on.
For example below is a trace that illustrates a delay of "irq/396-5-0072" RT task
to complete IRQ processing:

<snip>
 rcuop/6-54  [000] d.h2  183.752989: irq_handler_entry:    irq=85 name=i2c_geni
 rcuop/6-54  [000] d.h5  183.753007: sched_waking:         comm=irq/396-5-0072 pid=12675 prio=49 target_cpu=000
 rcuop/6-54  [000] dNh6  183.753014: sched_wakeup:         irq/396-5-0072:12675 [49] success=1 CPU:000
 rcuop/6-54  [000] dNh2  183.753015: irq_handler_exit:     irq=85 ret=handled
 rcuop/6-54  [000] .N..  183.753018: rcu_invoke_callback:  rcu_preempt rhp=0xffffff88ffd440b0 func=__d_free.cfi_jt
 rcuop/6-54  [000] .N..  183.753020: rcu_invoke_callback:  rcu_preempt rhp=0xffffff892ffd8400 func=inode_free_by_rcu.cfi_jt
 rcuop/6-54  [000] .N..  183.753021: rcu_invoke_callback:  rcu_preempt rhp=0xffffff89327cd708 func=i_callback.cfi_jt
 ...
 rcuop/6-54  [000] .N..  183.755941: rcu_invoke_callback:  rcu_preempt rhp=0xffffff8993c5a968 func=i_callback.cfi_jt
 rcuop/6-54  [000] .N..  183.755942: rcu_invoke_callback:  rcu_preempt rhp=0xffffff8993c4bd20 func=__d_free.cfi_jt
 rcuop/6-54  [000] dN..  183.755944: rcu_batch_end:        rcu_preempt CBs-invoked=2112 idle=>c<>c<>c<>c<
 rcuop/6-54  [000] dN..  183.755946: rcu_utilization:      Start context switch
 rcuop/6-54  [000] dN..  183.755946: rcu_utilization:      End context switch
 rcuop/6-54  [000] d..2  183.755959: sched_switch:         rcuop/6:54 [120] R ==> migration/0:16 [0]
 ...
 migratio-16 [000] d..2  183.756021: sched_switch:         migration/0:16 [0] S ==> irq/396-5-0072:12675 [49]
<snip>

The "irq/396-5-0072:12675" was delayed for ~3 milliseconds due to introduced side effect.
Please note, on our Android devices we get ~70 000 callbacks registered to be invoked by
the "rcuop/x" workers. This is during 1 seconds time interval and regular handset usage.
Latencies bigger that 3 milliseconds affect our high-resolution audio streaming over the
LDAC/Bluetooth stack.

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
[UR: backport to 5.10-stable + commit update]
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 kernel/rcu/tree.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 844c35803739..f340df6ebd86 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2490,10 +2490,22 @@ static void rcu_do_batch(struct rcu_data *rdp)
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
@@ -2501,14 +2513,6 @@ static void rcu_do_batch(struct rcu_data *rdp)
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
-- 
2.30.2


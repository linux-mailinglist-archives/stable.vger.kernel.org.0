Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E74664A0C
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239104AbjAJS3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239373AbjAJS2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:28:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3510D38AFE
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:24:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBEF7B818EF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCEFC433D2;
        Tue, 10 Jan 2023 18:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375038;
        bh=kcSBweqE1m8UESWclii2tT3H9nH29LcQbkd5nxOTB/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNbB7aCUTm7ifprSzr1TBqghRxelr8ZL4siFL8m9kKLlMNOG9+sRtwBal3xbnSLYT
         vgzSMGOts19eXL1a/YFlRjfaPP9/U0k427E6l8Dv0tQw1/90rHBgKLE9AhuTGH0hGX
         B5eyBKwJHOQHcZ2giI5Nw6r5Z0dDpo0Q+5VXswQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paul E. McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 5.15 057/290] rcu-tasks: Simplify trc_read_check_handler() atomic operations
Date:   Tue, 10 Jan 2023 19:02:29 +0100
Message-Id: <20230110180033.597780936@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

commit 96017bf9039763a2e02dcc6adaa18592cd73a39d upstream.

Currently, trc_wait_for_one_reader() atomically increments
the trc_n_readers_need_end counter before sending the IPI
invoking trc_read_check_handler().  All failure paths out of
trc_read_check_handler() and also from the smp_call_function_single()
within trc_wait_for_one_reader() must carefully atomically decrement
this counter.  This is more complex than it needs to be.

This commit therefore simplifies things and saves a few lines of
code by dispensing with the atomic decrements in favor of having
trc_read_check_handler() do the atomic increment only in the success case.
In theory, this represents no change in functionality.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tasks.h |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -892,32 +892,24 @@ static void trc_read_check_handler(void
 
 	// If the task is no longer running on this CPU, leave.
 	if (unlikely(texp != t)) {
-		if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
-			wake_up(&trc_wait);
 		goto reset_ipi; // Already on holdout list, so will check later.
 	}
 
 	// If the task is not in a read-side critical section, and
 	// if this is the last reader, awaken the grace-period kthread.
 	if (likely(!READ_ONCE(t->trc_reader_nesting))) {
-		if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
-			wake_up(&trc_wait);
-		// Mark as checked after decrement to avoid false
-		// positives on the above WARN_ON_ONCE().
 		WRITE_ONCE(t->trc_reader_checked, true);
 		goto reset_ipi;
 	}
 	// If we are racing with an rcu_read_unlock_trace(), try again later.
-	if (unlikely(READ_ONCE(t->trc_reader_nesting) < 0)) {
-		if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
-			wake_up(&trc_wait);
+	if (unlikely(READ_ONCE(t->trc_reader_nesting) < 0))
 		goto reset_ipi;
-	}
 	WRITE_ONCE(t->trc_reader_checked, true);
 
 	// Get here if the task is in a read-side critical section.  Set
 	// its state so that it will awaken the grace-period kthread upon
 	// exit from that critical section.
+	atomic_inc(&trc_n_readers_need_end); // One more to wait on.
 	WARN_ON_ONCE(READ_ONCE(t->trc_reader_special.b.need_qs));
 	WRITE_ONCE(t->trc_reader_special.b.need_qs, true);
 
@@ -1017,21 +1009,15 @@ static void trc_wait_for_one_reader(stru
 		if (per_cpu(trc_ipi_to_cpu, cpu) || t->trc_ipi_to_cpu >= 0)
 			return;
 
-		atomic_inc(&trc_n_readers_need_end);
 		per_cpu(trc_ipi_to_cpu, cpu) = true;
 		t->trc_ipi_to_cpu = cpu;
 		rcu_tasks_trace.n_ipis++;
-		if (smp_call_function_single(cpu,
-					     trc_read_check_handler, t, 0)) {
+		if (smp_call_function_single(cpu, trc_read_check_handler, t, 0)) {
 			// Just in case there is some other reason for
 			// failure than the target CPU being offline.
 			rcu_tasks_trace.n_ipis_fails++;
 			per_cpu(trc_ipi_to_cpu, cpu) = false;
 			t->trc_ipi_to_cpu = cpu;
-			if (atomic_dec_and_test(&trc_n_readers_need_end)) {
-				WARN_ON_ONCE(1);
-				wake_up(&trc_wait);
-			}
 		}
 	}
 }



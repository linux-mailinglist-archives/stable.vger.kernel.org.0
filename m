Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED191574E7
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgBJMgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:36:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728168AbgBJMgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:48 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30AD320661;
        Mon, 10 Feb 2020 12:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338207;
        bh=ywE+2FJ+PAiUzazmZl6NKJX4wW8Rj4CDmFjwrtQ+9mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5gSFNMir9zKQ/0d+rjwudqpGdoD2dKjcgJjDKi8/yzLRBFzPXTksbT1Ar4g1WJkw
         PMFZw62860ZHrla7IkmdladUptl9DjBQpcERqpcDVnEhy51zGUDE75XQ0XWKGcT+5R
         m4bkSv0B4K0Um0kf+YXJqM2HqPv2MsbufVQA57ZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Marco Elver <elver@google.com>
Subject: [PATCH 5.4 028/309] rcu: Use *_ONCE() to protect lockless ->expmask accesses
Date:   Mon, 10 Feb 2020 04:29:44 -0800
Message-Id: <20200210122408.714844035@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

commit 15c7c972cd26d89a26788e609c53b5a465324a6c upstream.

The rcu_node structure's ->expmask field is accessed locklessly when
starting a new expedited grace period and when reporting an expedited
RCU CPU stall warning.  This commit therefore handles the former by
taking a snapshot of ->expmask while the lock is held and the latter
by applying READ_ONCE() to lockless reads and WRITE_ONCE() to the
corresponding updates.

Link: https://lore.kernel.org/lkml/CANpmjNNmSOagbTpffHr4=Yedckx9Rm2NuGqC9UqE+AOz5f1-ZQ@mail.gmail.com
Reported-by: syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Marco Elver <elver@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/rcu/tree_exp.h |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -134,7 +134,7 @@ static void __maybe_unused sync_exp_rese
 	rcu_for_each_node_breadth_first(rnp) {
 		raw_spin_lock_irqsave_rcu_node(rnp, flags);
 		WARN_ON_ONCE(rnp->expmask);
-		rnp->expmask = rnp->expmaskinit;
+		WRITE_ONCE(rnp->expmask, rnp->expmaskinit);
 		raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 	}
 }
@@ -211,7 +211,7 @@ static void __rcu_report_exp_rnp(struct
 		rnp = rnp->parent;
 		raw_spin_lock_rcu_node(rnp); /* irqs already disabled */
 		WARN_ON_ONCE(!(rnp->expmask & mask));
-		rnp->expmask &= ~mask;
+		WRITE_ONCE(rnp->expmask, rnp->expmask & ~mask);
 	}
 }
 
@@ -241,7 +241,7 @@ static void rcu_report_exp_cpu_mult(stru
 		raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 		return;
 	}
-	rnp->expmask &= ~mask;
+	WRITE_ONCE(rnp->expmask, rnp->expmask & ~mask);
 	__rcu_report_exp_rnp(rnp, wake, flags); /* Releases rnp->lock. */
 }
 
@@ -372,12 +372,10 @@ static void sync_rcu_exp_select_node_cpu
 	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 
 	/* IPI the remaining CPUs for expedited quiescent state. */
-	for_each_leaf_node_cpu_mask(rnp, cpu, rnp->expmask) {
+	for_each_leaf_node_cpu_mask(rnp, cpu, mask_ofl_ipi) {
 		unsigned long mask = leaf_node_cpu_bit(rnp, cpu);
 		struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
 
-		if (!(mask_ofl_ipi & mask))
-			continue;
 retry_ipi:
 		if (rcu_dynticks_in_eqs_since(rdp, rdp->exp_dynticks_snap)) {
 			mask_ofl_test |= mask;
@@ -491,7 +489,7 @@ static void synchronize_sched_expedited_
 				struct rcu_data *rdp;
 
 				mask = leaf_node_cpu_bit(rnp, cpu);
-				if (!(rnp->expmask & mask))
+				if (!(READ_ONCE(rnp->expmask) & mask))
 					continue;
 				ndetected++;
 				rdp = per_cpu_ptr(&rcu_data, cpu);
@@ -503,7 +501,8 @@ static void synchronize_sched_expedited_
 		}
 		pr_cont(" } %lu jiffies s: %lu root: %#lx/%c\n",
 			jiffies - jiffies_start, rcu_state.expedited_sequence,
-			rnp_root->expmask, ".T"[!!rnp_root->exp_tasks]);
+			READ_ONCE(rnp_root->expmask),
+			".T"[!!rnp_root->exp_tasks]);
 		if (ndetected) {
 			pr_err("blocking rcu_node structures:");
 			rcu_for_each_node_breadth_first(rnp) {
@@ -513,7 +512,7 @@ static void synchronize_sched_expedited_
 					continue;
 				pr_cont(" l=%u:%d-%d:%#lx/%c",
 					rnp->level, rnp->grplo, rnp->grphi,
-					rnp->expmask,
+					READ_ONCE(rnp->expmask),
 					".T"[!!rnp->exp_tasks]);
 			}
 			pr_cont("\n");
@@ -521,7 +520,7 @@ static void synchronize_sched_expedited_
 		rcu_for_each_leaf_node(rnp) {
 			for_each_leaf_node_possible_cpu(rnp, cpu) {
 				mask = leaf_node_cpu_bit(rnp, cpu);
-				if (!(rnp->expmask & mask))
+				if (!(READ_ONCE(rnp->expmask) & mask))
 					continue;
 				dump_cpu_task(cpu);
 			}



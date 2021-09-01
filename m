Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D013FDB85
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344383AbhIAMl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344973AbhIAMkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 414E961181;
        Wed,  1 Sep 2021 12:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499788;
        bh=q7RROOiRPZQrDGwzjDGrzalpq4ni0uBixtZ6G5lFGRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdwHxc9A+FAMIHnTGeGje/OCcgYCI3Tkd0kcKngedHUzLC2dInA8aGMrhevgsSbtr
         qfPSluIP2awWMzd7dM4OXL8Qqc1KJcbnx2LrMmFHxlRowkkO47Zqe1CbuyiOx4bONm
         1afYF0esFHA2rztbBvJTUmrdHUyWTJM1Oan5wVLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.10 086/103] srcu: Provide internal interface to start a Tree SRCU grace period
Date:   Wed,  1 Sep 2021 14:28:36 +0200
Message-Id: <20210901122303.437639677@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

commit 29d2bb94a8a126ce80ffbb433b648b32fdea524e upstream.

There is a need for a polling interface for SRCU grace periods.
This polling needs to initiate an SRCU grace period without having
to queue (and manage) a callback.  This commit therefore splits the
Tree SRCU __call_srcu() function into callback-initialization and
queuing/start-grace-period portions, with the latter in a new function
named srcu_gp_start_if_needed().  This function may be passed a NULL
callback pointer, in which case it will refrain from queuing anything.

Why have the new function mess with queuing?  Locking considerations,
of course!

Link: https://lore.kernel.org/rcu/20201112201547.GF3365678@moria.home.lan/
Reported-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/srcutree.c |   66 ++++++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 29 deletions(-)

--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -809,6 +809,42 @@ static void srcu_leak_callback(struct rc
 }
 
 /*
+ * Start an SRCU grace period, and also queue the callback if non-NULL.
+ */
+static void srcu_gp_start_if_needed(struct srcu_struct *ssp, struct rcu_head *rhp, bool do_norm)
+{
+	unsigned long flags;
+	int idx;
+	bool needexp = false;
+	bool needgp = false;
+	unsigned long s;
+	struct srcu_data *sdp;
+
+	idx = srcu_read_lock(ssp);
+	sdp = raw_cpu_ptr(ssp->sda);
+	spin_lock_irqsave_rcu_node(sdp, flags);
+	rcu_segcblist_enqueue(&sdp->srcu_cblist, rhp);
+	rcu_segcblist_advance(&sdp->srcu_cblist,
+			      rcu_seq_current(&ssp->srcu_gp_seq));
+	s = rcu_seq_snap(&ssp->srcu_gp_seq);
+	(void)rcu_segcblist_accelerate(&sdp->srcu_cblist, s);
+	if (ULONG_CMP_LT(sdp->srcu_gp_seq_needed, s)) {
+		sdp->srcu_gp_seq_needed = s;
+		needgp = true;
+	}
+	if (!do_norm && ULONG_CMP_LT(sdp->srcu_gp_seq_needed_exp, s)) {
+		sdp->srcu_gp_seq_needed_exp = s;
+		needexp = true;
+	}
+	spin_unlock_irqrestore_rcu_node(sdp, flags);
+	if (needgp)
+		srcu_funnel_gp_start(ssp, sdp, s, do_norm);
+	else if (needexp)
+		srcu_funnel_exp_start(ssp, sdp->mynode, s);
+	srcu_read_unlock(ssp, idx);
+}
+
+/*
  * Enqueue an SRCU callback on the srcu_data structure associated with
  * the current CPU and the specified srcu_struct structure, initiating
  * grace-period processing if it is not already running.
@@ -839,13 +875,6 @@ static void srcu_leak_callback(struct rc
 static void __call_srcu(struct srcu_struct *ssp, struct rcu_head *rhp,
 			rcu_callback_t func, bool do_norm)
 {
-	unsigned long flags;
-	int idx;
-	bool needexp = false;
-	bool needgp = false;
-	unsigned long s;
-	struct srcu_data *sdp;
-
 	check_init_srcu_struct(ssp);
 	if (debug_rcu_head_queue(rhp)) {
 		/* Probable double call_srcu(), so leak the callback. */
@@ -854,28 +883,7 @@ static void __call_srcu(struct srcu_stru
 		return;
 	}
 	rhp->func = func;
-	idx = srcu_read_lock(ssp);
-	sdp = raw_cpu_ptr(ssp->sda);
-	spin_lock_irqsave_rcu_node(sdp, flags);
-	rcu_segcblist_enqueue(&sdp->srcu_cblist, rhp);
-	rcu_segcblist_advance(&sdp->srcu_cblist,
-			      rcu_seq_current(&ssp->srcu_gp_seq));
-	s = rcu_seq_snap(&ssp->srcu_gp_seq);
-	(void)rcu_segcblist_accelerate(&sdp->srcu_cblist, s);
-	if (ULONG_CMP_LT(sdp->srcu_gp_seq_needed, s)) {
-		sdp->srcu_gp_seq_needed = s;
-		needgp = true;
-	}
-	if (!do_norm && ULONG_CMP_LT(sdp->srcu_gp_seq_needed_exp, s)) {
-		sdp->srcu_gp_seq_needed_exp = s;
-		needexp = true;
-	}
-	spin_unlock_irqrestore_rcu_node(sdp, flags);
-	if (needgp)
-		srcu_funnel_gp_start(ssp, sdp, s, do_norm);
-	else if (needexp)
-		srcu_funnel_exp_start(ssp, sdp->mynode, s);
-	srcu_read_unlock(ssp, idx);
+	srcu_gp_start_if_needed(ssp, rhp, do_norm);
 }
 
 /**



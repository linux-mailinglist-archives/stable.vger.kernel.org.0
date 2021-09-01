Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAED53FDB82
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344349AbhIAMl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344984AbhIAMkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68E7661184;
        Wed,  1 Sep 2021 12:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499790;
        bh=QniMzGO9NwTkHBNPTSqdroEUVKV2X1WJF+3iaSE9EuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgyoZxdGiMs76KVZThGafYPI78sXvMBkUYisej0jNzclLMKXc4ihHM2Uu55KTaeoq
         EoI5Mbnc0qpC9kgHNItOSlNv2yU+0VME0kOzrRJwjQC/Stt+1BKrQCPmw5RHbQPxQQ
         CBm1EzF0AoNSYejckCPNvmEfuMRIrurgztJ037fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.10 087/103] srcu: Provide polling interfaces for Tree SRCU grace periods
Date:   Wed,  1 Sep 2021 14:28:37 +0200
Message-Id: <20210901122303.467744090@linuxfoundation.org>
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

commit 5358c9fa54b09b5d3d7811b033aa0838c1bbaaf2 upstream.

There is a need for a polling interface for SRCU grace
periods, so this commit supplies get_state_synchronize_srcu(),
start_poll_synchronize_srcu(), and poll_state_synchronize_srcu() for this
purpose.  The first can be used if future grace periods are inevitable
(perhaps due to a later call_srcu() invocation), the second if future
grace periods might not otherwise happen, and the third to check if a
grace period has elapsed since the corresponding call to either of the
first two.

As with get_state_synchronize_rcu() and cond_synchronize_rcu(),
the return value from either get_state_synchronize_srcu() or
start_poll_synchronize_srcu() must be passed in to a later call to
poll_state_synchronize_srcu().

Link: https://lore.kernel.org/rcu/20201112201547.GF3365678@moria.home.lan/
Reported-by: Kent Overstreet <kent.overstreet@gmail.com>
[ paulmck: Add EXPORT_SYMBOL_GPL() per kernel test robot feedback. ]
[ paulmck: Apply feedback from Neeraj Upadhyay. ]
Link: https://lore.kernel.org/lkml/20201117004017.GA7444@paulmck-ThinkPad-P72/
Reviewed-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/srcutree.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 63 insertions(+), 4 deletions(-)

--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -811,7 +811,8 @@ static void srcu_leak_callback(struct rc
 /*
  * Start an SRCU grace period, and also queue the callback if non-NULL.
  */
-static void srcu_gp_start_if_needed(struct srcu_struct *ssp, struct rcu_head *rhp, bool do_norm)
+static unsigned long srcu_gp_start_if_needed(struct srcu_struct *ssp,
+					     struct rcu_head *rhp, bool do_norm)
 {
 	unsigned long flags;
 	int idx;
@@ -820,10 +821,12 @@ static void srcu_gp_start_if_needed(stru
 	unsigned long s;
 	struct srcu_data *sdp;
 
+	check_init_srcu_struct(ssp);
 	idx = srcu_read_lock(ssp);
 	sdp = raw_cpu_ptr(ssp->sda);
 	spin_lock_irqsave_rcu_node(sdp, flags);
-	rcu_segcblist_enqueue(&sdp->srcu_cblist, rhp);
+	if (rhp)
+		rcu_segcblist_enqueue(&sdp->srcu_cblist, rhp);
 	rcu_segcblist_advance(&sdp->srcu_cblist,
 			      rcu_seq_current(&ssp->srcu_gp_seq));
 	s = rcu_seq_snap(&ssp->srcu_gp_seq);
@@ -842,6 +845,7 @@ static void srcu_gp_start_if_needed(stru
 	else if (needexp)
 		srcu_funnel_exp_start(ssp, sdp->mynode, s);
 	srcu_read_unlock(ssp, idx);
+	return s;
 }
 
 /*
@@ -875,7 +879,6 @@ static void srcu_gp_start_if_needed(stru
 static void __call_srcu(struct srcu_struct *ssp, struct rcu_head *rhp,
 			rcu_callback_t func, bool do_norm)
 {
-	check_init_srcu_struct(ssp);
 	if (debug_rcu_head_queue(rhp)) {
 		/* Probable double call_srcu(), so leak the callback. */
 		WRITE_ONCE(rhp->func, srcu_leak_callback);
@@ -883,7 +886,7 @@ static void __call_srcu(struct srcu_stru
 		return;
 	}
 	rhp->func = func;
-	srcu_gp_start_if_needed(ssp, rhp, do_norm);
+	(void)srcu_gp_start_if_needed(ssp, rhp, do_norm);
 }
 
 /**
@@ -1012,6 +1015,62 @@ void synchronize_srcu(struct srcu_struct
 }
 EXPORT_SYMBOL_GPL(synchronize_srcu);
 
+/**
+ * get_state_synchronize_srcu - Provide an end-of-grace-period cookie
+ * @ssp: srcu_struct to provide cookie for.
+ *
+ * This function returns a cookie that can be passed to
+ * poll_state_synchronize_srcu(), which will return true if a full grace
+ * period has elapsed in the meantime.  It is the caller's responsibility
+ * to make sure that grace period happens, for example, by invoking
+ * call_srcu() after return from get_state_synchronize_srcu().
+ */
+unsigned long get_state_synchronize_srcu(struct srcu_struct *ssp)
+{
+	// Any prior manipulation of SRCU-protected data must happen
+	// before the load from ->srcu_gp_seq.
+	smp_mb();
+	return rcu_seq_snap(&ssp->srcu_gp_seq);
+}
+EXPORT_SYMBOL_GPL(get_state_synchronize_srcu);
+
+/**
+ * start_poll_synchronize_srcu - Provide cookie and start grace period
+ * @ssp: srcu_struct to provide cookie for.
+ *
+ * This function returns a cookie that can be passed to
+ * poll_state_synchronize_srcu(), which will return true if a full grace
+ * period has elapsed in the meantime.  Unlike get_state_synchronize_srcu(),
+ * this function also ensures that any needed SRCU grace period will be
+ * started.  This convenience does come at a cost in terms of CPU overhead.
+ */
+unsigned long start_poll_synchronize_srcu(struct srcu_struct *ssp)
+{
+	return srcu_gp_start_if_needed(ssp, NULL, true);
+}
+EXPORT_SYMBOL_GPL(start_poll_synchronize_srcu);
+
+/**
+ * poll_state_synchronize_srcu - Has cookie's grace period ended?
+ * @ssp: srcu_struct to provide cookie for.
+ * @cookie: Return value from get_state_synchronize_srcu() or start_poll_synchronize_srcu().
+ *
+ * This function takes the cookie that was returned from either
+ * get_state_synchronize_srcu() or start_poll_synchronize_srcu(), and
+ * returns @true if an SRCU grace period elapsed since the time that the
+ * cookie was created.
+ */
+bool poll_state_synchronize_srcu(struct srcu_struct *ssp, unsigned long cookie)
+{
+	if (!rcu_seq_done(&ssp->srcu_gp_seq, cookie))
+		return false;
+	// Ensure that the end of the SRCU grace period happens before
+	// any subsequent code that the caller might execute.
+	smp_mb(); // ^^^
+	return true;
+}
+EXPORT_SYMBOL_GPL(poll_state_synchronize_srcu);
+
 /*
  * Callback function for srcu_barrier() use.
  */



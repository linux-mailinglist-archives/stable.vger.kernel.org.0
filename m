Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3A647AD9D
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238224AbhLTOxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:53:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57246 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237136AbhLTOvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:51:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A1DFB80EEA;
        Mon, 20 Dec 2021 14:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94E6C36AE8;
        Mon, 20 Dec 2021 14:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011878;
        bh=PMhfV8jqau9aY5M5UMhGD2SwWPmIg4h8xrk3OUwlSoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNFHEMhygt756nbnQTp1Ldu7gKL+mEnVZjwMB2kf0yoF9tvdRzxHXHCUTRWdVfPAN
         Q2VFRneiZw21Gz5nbuQqa+ospARw2rx7/RkUYSqRsrtbxxkLUEf55G+uFQ7v81Eqxz
         BoV7g57koj4L7YWXXZkH0tmRclVRYkz+378oVllk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e08a83a1940ec3846cd5@syzkaller.appspotmail.com,
        Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.10 92/99] rcu: Mark accesses to rcu_state.n_force_qs
Date:   Mon, 20 Dec 2021 15:35:05 +0100
Message-Id: <20211220143032.491507034@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

commit 2431774f04d1050292054c763070021bade7b151 upstream.

This commit marks accesses to the rcu_state.n_force_qs.  These data
races are hard to make happen, but syzkaller was equal to the task.

Reported-by: syzbot+e08a83a1940ec3846cd5@syzkaller.appspotmail.com
Acked-by: Marco Elver <elver@google.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tree.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1888,7 +1888,7 @@ static void rcu_gp_fqs(bool first_time)
 	struct rcu_node *rnp = rcu_get_root();
 
 	WRITE_ONCE(rcu_state.gp_activity, jiffies);
-	rcu_state.n_force_qs++;
+	WRITE_ONCE(rcu_state.n_force_qs, rcu_state.n_force_qs + 1);
 	if (first_time) {
 		/* Collect dyntick-idle snapshots. */
 		force_qs_rnp(dyntick_save_progress_counter);
@@ -2530,7 +2530,7 @@ static void rcu_do_batch(struct rcu_data
 	/* Reset ->qlen_last_fqs_check trigger if enough CBs have drained. */
 	if (count == 0 && rdp->qlen_last_fqs_check != 0) {
 		rdp->qlen_last_fqs_check = 0;
-		rdp->n_force_qs_snap = rcu_state.n_force_qs;
+		rdp->n_force_qs_snap = READ_ONCE(rcu_state.n_force_qs);
 	} else if (count < rdp->qlen_last_fqs_check - qhimark)
 		rdp->qlen_last_fqs_check = count;
 
@@ -2876,10 +2876,10 @@ static void __call_rcu_core(struct rcu_d
 		} else {
 			/* Give the grace period a kick. */
 			rdp->blimit = DEFAULT_MAX_RCU_BLIMIT;
-			if (rcu_state.n_force_qs == rdp->n_force_qs_snap &&
+			if (READ_ONCE(rcu_state.n_force_qs) == rdp->n_force_qs_snap &&
 			    rcu_segcblist_first_pend_cb(&rdp->cblist) != head)
 				rcu_force_quiescent_state();
-			rdp->n_force_qs_snap = rcu_state.n_force_qs;
+			rdp->n_force_qs_snap = READ_ONCE(rcu_state.n_force_qs);
 			rdp->qlen_last_fqs_check = rcu_segcblist_n_cbs(&rdp->cblist);
 		}
 	}
@@ -3986,7 +3986,7 @@ int rcutree_prepare_cpu(unsigned int cpu
 	/* Set up local state, ensuring consistent view of global state. */
 	raw_spin_lock_irqsave_rcu_node(rnp, flags);
 	rdp->qlen_last_fqs_check = 0;
-	rdp->n_force_qs_snap = rcu_state.n_force_qs;
+	rdp->n_force_qs_snap = READ_ONCE(rcu_state.n_force_qs);
 	rdp->blimit = blimit;
 	if (rcu_segcblist_empty(&rdp->cblist) && /* No early-boot CBs? */
 	    !rcu_segcblist_is_offloaded(&rdp->cblist))



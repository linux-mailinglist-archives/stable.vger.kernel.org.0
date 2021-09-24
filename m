Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CE541728C
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344159AbhIXMtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:49:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344204AbhIXMs3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:48:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39C866124D;
        Fri, 24 Sep 2021 12:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487616;
        bh=98OmaOsqsiaPG8nAK0MzoQ4ZPDrTNDgUGygrcvZICrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=danjC8iQl6zJ2U6h9Pzfdz5BbvPGG4GOv0pU6BowlHzcCPBr/g+/BWLkZsqmkUQ4N
         Rx1W3/rQ3xuR8CZDLfMlhFHFSoquPr87O3KhSX2XaHhKZgY9uPthengHRtCz4iNH+G
         yEPtMTgozHOa2sMCQiygMLLwOz6SdHKsBoM3+HgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neeraj Upadhyay <neeraju@codeaurora.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        David Chen <david.chen@nutanix.com>
Subject: [PATCH 4.14 02/27] rcu: Fix missed wakeup of exp_wq waiters
Date:   Fri, 24 Sep 2021 14:43:56 +0200
Message-Id: <20210924124329.259394431@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.173674820@linuxfoundation.org>
References: <20210924124329.173674820@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neeraj Upadhyay <neeraju@codeaurora.org>

commit fd6bc19d7676a060a171d1cf3dcbf6fd797eb05f upstream.

Tasks waiting within exp_funnel_lock() for an expedited grace period to
elapse can be starved due to the following sequence of events:

1.	Tasks A and B both attempt to start an expedited grace
	period at about the same time.	This grace period will have
	completed when the lower four bits of the rcu_state structure's
	->expedited_sequence field are 0b'0100', for example, when the
	initial value of this counter is zero.	Task A wins, and thus
	does the actual work of starting the grace period, including
	acquiring the rcu_state structure's .exp_mutex and sets the
	counter to 0b'0001'.

2.	Because task B lost the race to start the grace period, it
	waits on ->expedited_sequence to reach 0b'0100' inside of
	exp_funnel_lock(). This task therefore blocks on the rcu_node
	structure's ->exp_wq[1] field, keeping in mind that the
	end-of-grace-period value of ->expedited_sequence (0b'0100')
	is shifted down two bits before indexing the ->exp_wq[] field.

3.	Task C attempts to start another expedited grace period,
	but blocks on ->exp_mutex, which is still held by Task A.

4.	The aforementioned expedited grace period completes, so that
	->expedited_sequence now has the value 0b'0100'.  A kworker task
	therefore acquires the rcu_state structure's ->exp_wake_mutex
	and starts awakening any tasks waiting for this grace period.

5.	One of the first tasks awakened happens to be Task A.  Task A
	therefore releases the rcu_state structure's ->exp_mutex,
	which allows Task C to start the next expedited grace period,
	which causes the lower four bits of the rcu_state structure's
	->expedited_sequence field to become 0b'0101'.

6.	Task C's expedited grace period completes, so that the lower four
	bits of the rcu_state structure's ->expedited_sequence field now
	become 0b'1000'.

7.	The kworker task from step 4 above continues its wakeups.
	Unfortunately, the wake_up_all() refetches the rcu_state
	structure's .expedited_sequence field:

	wake_up_all(&rnp->exp_wq[rcu_seq_ctr(rcu_state.expedited_sequence) & 0x3]);

	This results in the wakeup being applied to the rcu_node
	structure's ->exp_wq[2] field, which is unfortunate given that
	Task B is instead waiting on ->exp_wq[1].

On a busy system, no harm is done (or at least no permanent harm is done).
Some later expedited grace period will redo the wakeup.  But on a quiet
system, such as many embedded systems, it might be a good long time before
there was another expedited grace period.  On such embedded systems,
this situation could therefore result in a system hang.

This issue manifested as DPM device timeout during suspend (which
usually qualifies as a quiet time) due to a SCSI device being stuck in
_synchronize_rcu_expedited(), with the following stack trace:

	schedule()
	synchronize_rcu_expedited()
	synchronize_rcu()
	scsi_device_quiesce()
	scsi_bus_suspend()
	dpm_run_callback()
	__device_suspend()

This commit therefore prevents such delays, timeouts, and hangs by
making rcu_exp_wait_wake() use its "s" argument consistently instead of
refetching from rcu_state.expedited_sequence.

Fixes: 3b5f668e715b ("rcu: Overlap wakeups with next expedited grace period")
Signed-off-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: David Chen <david.chen@nutanix.com>
Acked-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tree_exp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -534,7 +534,7 @@ static void rcu_exp_wait_wake(struct rcu
 			spin_unlock(&rnp->exp_lock);
 		}
 		smp_mb(); /* All above changes before wakeup. */
-		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(rsp->expedited_sequence) & 0x3]);
+		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(s) & 0x3]);
 	}
 	trace_rcu_exp_grace_period(rsp->name, s, TPS("endwake"));
 	mutex_unlock(&rsp->exp_wake_mutex);



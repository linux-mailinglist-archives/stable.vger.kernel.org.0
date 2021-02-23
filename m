Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F19B3222F0
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 01:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhBWAK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 19:10:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhBWAK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 19:10:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED49E601FF;
        Tue, 23 Feb 2021 00:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614039017;
        bh=aUWRhREIoI4Ot8y8zjIOgpAt3Pq6EOt5+NuB98SlsS0=;
        h=From:To:Cc:Subject:Date:From;
        b=Ybxj1TmDEx6C2TWQh7GLd3EKBQdyknc/il2n1rDl0EMjma5dLY/RXyyzJ2De4mOdO
         7SFHPIaL2gTIjIgdhOVDYYySXIemE+hzCs11xe1Labfm943yRL2V14Xk4JVi70o7uD
         RmQbv+Qs5jhIC9xCgieD7Ks5PwxuPNnzitegPx96EZ64sowI7i+tupgcqahHe3goae
         Nj0W3pBvNty3yjF1wnLjs4F7nxRXiech0rcgmhBrd0qsAG+uSgYvGi4rvKyc7nD9ML
         z5J6brSh3KwgixP4TnR1IOAhPdXgX+DAZiyJnUftR4JPZAMFgWdPMdBQwtJjmBErWm
         MCezOvYbKwa5w==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 00/13] rcu/nocb updates v2 
Date:   Tue, 23 Feb 2021 01:09:58 +0100
Message-Id: <20210223001011.127063-1-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's a v2 of the previous set (https://lore.kernel.org/lkml/20210128171222.131380-1-frederic@kernel.org/)
minus the patches already applied in rcu/dev. And this is based on 
latest rcu/dev.

Changelog since v1:

"rcu/nocb: Fix potential missed nocb_timer rearm"
	* Remove nocb_defer_wakeup reset from do_nocb_deferred_wakeup_common() (paulmck)
	* Only reset/del if the timer is actually armed
	* Add secondary potential cause for missed rearm in the changelog

"rcu/nocb: Disable bypass when CPU isn't completely offloaded"
	* Improve comments on state machine (paulmck)
	* Add comment (a full quote from Paul) explaining why early flush is enough (paulmck)
	* Move sanity check to the very end of deoffloading (paulmck)
	* Clarify some comments about nocb locking on de-offloading (paulmck)

"rcu/nocb: Remove stale comment above rcu_segcblist_offload()"
	* New patch, reported by (paulmck)

"rcu/nocb: Merge nocb_timer to the rdp leader"
	* Remove rcu_running_nocb_timer() and its use in rcu_rdp_is_offloaded()
	  debugging since the timer doesn't refer to any rdp offloading anymore.
	* Only delete nocb_timer when armed, in nocb_gp_wait()
	* Clarify some comments about nocb locking on de-offloading (paulmck)
	* Remove stale code "re-enabling" nocb timer on offloading. Not necessary
	  anymore and even buggy.

"timer: Revert "timer: Add timer_curr_running()""
	* New patch

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	rcu/dev-v2

HEAD: 925ee3076eb694db893e2c6664d90ad8fb9cb6e5

Thanks,
	Frederic
---

Frederic Weisbecker (13):
      rcu/nocb: Fix potential missed nocb_timer rearm
      rcu/nocb: Disable bypass when CPU isn't completely offloaded
      rcu/nocb: Remove stale comment above rcu_segcblist_offload()
      rcu/nocb: Move trace_rcu_nocb_wake() calls outside nocb_lock when possible
      rcu/nocb: Merge nocb_timer to the rdp leader
      timer: Revert "timer: Add timer_curr_running()"
      rcu/nocb: Directly call __wake_nocb_gp() from bypass timer
      rcu/nocb: Allow de-offloading rdp leader
      rcu/nocb: Cancel nocb_timer upon nocb_gp wakeup
      rcu/nocb: Delete bypass_timer upon nocb_gp wakeup
      rcu/nocb: Only cancel nocb timer if not polling
      rcu/nocb: Prepare for finegrained deferred wakeup
      rcu/nocb: Unify timers


 include/linux/rcu_segcblist.h |   7 +-
 include/linux/timer.h         |   2 -
 include/trace/events/rcu.h    |   1 +
 kernel/rcu/rcu_segcblist.c    |   3 +-
 kernel/rcu/tree.c             |   2 +-
 kernel/rcu/tree.h             |   9 +-
 kernel/rcu/tree_plugin.h      | 233 +++++++++++++++++++++++-------------------
 kernel/time/timer.c           |  14 ---
 8 files changed, 141 insertions(+), 130 deletions(-)

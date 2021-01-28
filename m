Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DAE307CE8
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhA1Rpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:45:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232976AbhA1RNK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 12:13:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DEA164DE2;
        Thu, 28 Jan 2021 17:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853948;
        bh=qX4hPkooYavvdfeBxEHrdI51Oy51iA33R7jRCvW3kfU=;
        h=From:To:Cc:Subject:Date:From;
        b=d1T2BttiKci680XY937MvmDCtHihETa/YRPO57hKDucKypnoSkQDkCW4SvSTXigs9
         3714uz/7sKEIm+2Uvfq3XoioOmLCkfacjAyC1TkxRzol/oFryWxkuCsVJ+R6raMLFx
         kbJuKEY8nUCurVKya34H0Gj3YutJYD+yv9Ca8MLyeNqGWiobhMXBtsQP/pjrCLdR24
         gWslLDFV7ku5MMu6Z+flnYNiHmEdKOKB9aMqO6mL8OwvmivS19A2h1uFH5R28DzyFv
         ns6fJlQ9/wwVsEiSqhdiSs5xKk3/T5DWsPptnZko9ouT+N3cIJZeKcwgDi4LA+akhu
         QzQeshHuflWlw==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 00/16] rcu/nocb updates
Date:   Thu, 28 Jan 2021 18:12:06 +0100
Message-Id: <20210128171222.131380-1-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

So this set has grown further than I expected.

This addresses most reviews from Paul and also consolidates the nocb
timers code.

Please mind the very first patch that is a stable bugfix.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	rcu/dev

HEAD: 75991420c246c26f598602da1a70947b5bdf77b6

Thanks,
	Frederic
---

Frederic Weisbecker (16):
      rcu/nocb: Fix potential missed nocb_timer rearm
      rcu/nocb: Comment the reason behind BH disablement on batch processing
      rcu/nocb: Forbid NOCB toggling on offline CPUs
      rcu/nocb: Only (re-)initialize segcblist when needed on CPU up
      rcu/nocb: Disable bypass when CPU isn't completely offloaded
      rcu/nocb: Avoid confusing double write of rdp->nocb_cb_sleep
      rcu/nocb: Rename nocb_gp_update_state to nocb_gp_update_state_deoffloading
      rcu/nocb: Move trace_rcu_nocb_wake() calls outside nocb_lock when possible
      rcu/nocb: Merge nocb_timer to the rdp leader
      rcu/nocb: Directly call __wake_nocb_gp() from bypass timer
      rcu/nocb: Allow de-offloading rdp leader
      rcu/nocb: Cancel nocb_timer upon nocb_gp wakeup
      rcu/nocb: Delete bypass_timer upon nocb_gp wakeup
      rcu/nocb: Only cancel nocb timer if not polling
      rcu/nocb: Prepare for finegrained deferred wakeup
      rcu/nocb: Unify timers


 include/linux/rcu_segcblist.h |   7 +-
 include/trace/events/rcu.h    |   1 +
 kernel/rcu/tree.c             |  12 +-
 kernel/rcu/tree.h             |   9 +-
 kernel/rcu/tree_plugin.h      | 280 ++++++++++++++++++++++--------------------
 5 files changed, 163 insertions(+), 146 deletions(-)

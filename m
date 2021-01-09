Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F992EFCF7
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 03:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbhAICGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 21:06:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:41424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbhAICGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 21:06:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB2AB23A3C;
        Sat,  9 Jan 2021 02:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610157942;
        bh=HEm/ZNT9r386IPpf+DpT4StTZr10yItI+392ToDDCE4=;
        h=From:To:Cc:Subject:Date:From;
        b=Zkl4R9hjPnUwdHvxlrxwNz4+t8MeFau/aXEuOiCdo/PXhuUhddNj7tyhRmQVbfzkK
         ORqLOR0djnH6Cg5UsD0cIjP/OoCdenCMoZDqW2gbgiKE4ij48PZS/Afo9t5f9IpFGO
         pBBWnQe8hngst4urfSDxUW5W9ruKUJ2V1dUQd3Hk8zdWX4fCgrBIa3JHbTFw+lz6eX
         r0HuCkFhyvegyEOVFy6Df9JdOIItGYjv8nEkiE1Q26pOSIjNbEwLniY1eCEB0FGskN
         h2RAM1KL4gIXi20fTjJeNnjbQ81YIyGnaOPDHYD/vLYpnS8vyEbchjQqoAuJ8OPY3r
         XG2anb1Tbzp+Q==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [RFC PATCH 0/8] rcu/sched: Fix ignored rescheduling after rcu_eqs_enter() v3
Date:   Sat,  9 Jan 2021 03:05:28 +0100
Message-Id: <20210109020536.127953-1-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(This was [PATCH 0/4] sched/idle: Fix missing need_resched() checks after rcu_idle_enter() v2)

I initially followed Peterz review but eventually I tried a different
approach. Instead of handling the late wake up from rcu_idle_enter(),
I've split the delayed rcuog wake up and moved it right before
the last generic need_resched() check, it makes more sense and we don't
need to fiddle with cpuidle core and drivers anymore. It's also less
error prone.

I also fixed the nohz_full case and (hopefully) the guest case.

And this comes with debugging to prevent from that pattern to happen
again.

Only lightly tested so far.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	sched/idle-v3

HEAD: d95fc510e804a5c4658a823ff12d9caba1d906c7

Thanks,
	Frederic
---

Frederic Weisbecker (8):
      rcu: Remove superfluous rdp fetch
      rcu: Pull deferred rcuog wake up to rcu_eqs_enter() callers
      rcu/nocb: Perform deferred wake up before last idle's need_resched() check
      rcu/nocb: Trigger self-IPI on late deferred wake up before user resume
      entry: Explicitly flush pending rcuog wakeup before last rescheduling points
      sched: Report local wake up on resched blind zone within idle loop
      entry: Report local wake up on resched blind zone while resuming to user
      timer: Report ignored local enqueue in nohz mode


 include/linux/rcupdate.h |  2 ++
 include/linux/sched.h    | 11 ++++++++
 kernel/entry/common.c    | 10 ++++++++
 kernel/rcu/tree.c        | 27 ++++++++++++++++++--
 kernel/rcu/tree.h        |  2 +-
 kernel/rcu/tree_plugin.h | 30 +++++++++++++++-------
 kernel/sched/core.c      | 66 +++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/idle.c      |  6 +++++
 kernel/sched/sched.h     |  3 +++
 9 files changed, 144 insertions(+), 13 deletions(-)

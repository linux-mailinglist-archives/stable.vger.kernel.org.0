Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6941D309F53
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 00:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhAaXGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 18:06:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229624AbhAaXGf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 31 Jan 2021 18:06:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2FF264DDF;
        Sun, 31 Jan 2021 23:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612134354;
        bh=oQn4rTwbOg9qH0Pvwu7BpnSKkTm+GCONYYj9CVlVHww=;
        h=From:To:Cc:Subject:Date:From;
        b=XviEaSClCSxN7LXMZVDJBnaPu+Og3FCYoOBZvbsZewM0Z8L6luxJ34EocPDxDbeEH
         cIgbLXT14oIaI6GmzDjcvD3CNJE7vrM1ai1YgAeHb1hOqgdpViMY9thGbNu+eVgycG
         EVfzhnRmDRmxz5rabhuBb7iWJnjqo2fzUMlLy+q0+uiRBBIHaB0VUmLIV1cQwlVbVm
         v3rBe9/hZReRJhyel63sLgazmYV9eXLJmqFbP52Wchk9ioelpdojTH3F//rGvt8MMf
         GbfoP9i2Eq93n4cw+xaYXk5i9BdqBqlmFSimHXM1zIxLBbl1/XeoW5RYnmMgWQofmp
         cRCZfyB4yS+qQ==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 0/5] rcu/sched: Fix ignored rescheduling after rcu_eqs_enter() v4
Date:   Mon,  1 Feb 2021 00:05:43 +0100
Message-Id: <20210131230548.32970-1-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

So, here is a hopefully improved version with the following changes:

* No more late wake up debugging, objtool should debug that later with
  noinstr code calling into the scheduler (Peter suggestion)

* Dropped the double rdp fetch patch, just keep the fix part for now

* Properly protect irq work call from rcu_user_enter() inside
  instrumention_begin()

* Handle CONFIG_KVM_XFER_TO_GUEST_WORK (as per Peter suggestion)

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	sched/idle-v4

HEAD: d3e956d0b693a572bd5f56241816a6390c5b2797

Thanks,
	Frederic
---

Frederic Weisbecker (5):
      rcu: Pull deferred rcuog wake up to rcu_eqs_enter() callers
      rcu/nocb: Perform deferred wake up before last idle's need_resched() check
      rcu/nocb: Trigger self-IPI on late deferred wake up before user resume
      entry: Explicitly flush pending rcuog wakeup before last rescheduling point
      entry/kvm: Explicitly flush pending rcuog wakeup before last rescheduling point


 arch/x86/kvm/x86.c        |  1 +
 include/linux/entry-kvm.h | 14 +++++++++++++
 include/linux/rcupdate.h  |  2 ++
 kernel/entry/common.c     |  7 +++++++
 kernel/rcu/tree.c         | 53 ++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/rcu/tree.h         |  2 +-
 kernel/rcu/tree_plugin.h  | 31 +++++++++++++++++++--------
 kernel/sched/idle.c       |  3 +++
 8 files changed, 102 insertions(+), 11 deletions(-)

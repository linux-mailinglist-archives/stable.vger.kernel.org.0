Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68F32E03E4
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 02:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgLVBiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 20:38:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgLVBiU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Dec 2020 20:38:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA22722A83;
        Tue, 22 Dec 2020 01:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608601059;
        bh=e7GHyBCLykEq+OsooOpe6AvMkhb0yvGEjUzLLmtB5IE=;
        h=From:To:Cc:Subject:Date:From;
        b=S7TnUXef7HAgNM9UvcVjzz9/YclUeXE2EBjXHv5/T6NTyXeiBMnX6El6uTPGRz8dY
         dqxOvd99PntUO68BcqKlKkcx6X/Hbq1nP38mTmSRcVsj41rlZ7FUCujyZiqZUJ1KEE
         yHb68dgxti+G3QWfGI3IYW33oogMLTlffaO92JePCJtruNW/TGC49JVnWM/JYL65CV
         kh5ZOvUE6PDPzZ3c5Fmdgk56EzW5JUROpIebdKMKhlIZqi5nkhSmrLWqpNUbpQMsij
         MI7s2xYizsPCdpDx2Sm/pNOuujG2wJaBH9c1TelE0XNwAY2EqNHKjUJIALX0rtzkkD
         qcGJn6dMhOR+g==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 0/4] sched/idle: Fix missing need_resched() checks after rcu_idle_enter()
Date:   Tue, 22 Dec 2020 02:37:08 +0100
Message-Id: <20201222013712.15056-1-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With Paul, we've been thinking that the idle loop wasn't twisted enough
yet to deserve 2020.

rcutorture, after some recent parameter changes, has been complaining
about a hung task.

It appears that rcu_idle_enter() may wake up a NOCB kthread but this
happens after the last generic need_resched() check. Some cpuidle drivers
fix it by chance but many others don't.

Here is a proposed bunch of fixes. I will need to also fix the
rcu_user_enter() case, likely using irq_work, since nohz_full requires
irq work to support self IPI.

Also more generally, this raise the question of local task wake_up()
under disabled interrupts. When a wake up occurs in a preempt disabled
section, it gets handled by the outer preempt_enable() call. There is no
similar mechanism when a wake up occurs with interrupts disabled. I guess
it is assumed to be handled, at worst, in the next tick. But a local irq
work would provide instant preemption once IRQs are re-enabled. Of course
this would only make sense in CONFIG_PREEMPTION, and when the tick is
disabled...

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	sched/idle

HEAD: f2fa6e4a070c1535b9edc9ee097167fd2b15d235

Thanks,
	Frederic
---

Frederic Weisbecker (4):
      sched/idle: Fix missing need_resched() check after rcu_idle_enter()
      cpuidle: Fix missing need_resched() check after rcu_idle_enter()
      ARM: imx6q: Fix missing need_resched() check after rcu_idle_enter()
      ACPI: processor: Fix missing need_resched() check after rcu_idle_enter()


 arch/arm/mach-imx/cpuidle-imx6q.c |  7 ++++++-
 drivers/acpi/processor_idle.c     | 10 ++++++++--
 drivers/cpuidle/cpuidle.c         | 33 +++++++++++++++++++++++++--------
 kernel/sched/idle.c               | 18 ++++++++++++------
 4 files changed, 51 insertions(+), 17 deletions(-)

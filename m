Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA96211903
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbgGBBaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728581AbgGBB0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:26:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22BC520899;
        Thu,  2 Jul 2020 01:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653208;
        bh=r1l8rlJAUSY2hyGPsXnzZAowg9qrH+DFXzNPOvLHJPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbQY7Vjh9INg82b5ff5WlNY8AMg1tLL6DT9Bvmo6HBEM1eNu2wFO32ED+xK1vXHeT
         wT8LUA55OWpeGu3jb5/LUh0ZE/KmqrW/u9rINqXq8/CEpG897pjtnYmKS/8Z6JkVaS
         wVPmfAj9mLCFZC6mxj/QCRtcMmPM/XkbBWfb5nnc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 27/27] kgdb: Avoid suspicious RCU usage warning
Date:   Wed,  1 Jul 2020 21:26:15 -0400
Message-Id: <20200702012615.2701532-27-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012615.2701532-1-sashal@kernel.org>
References: <20200702012615.2701532-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 440ab9e10e2e6e5fd677473ee6f9e3af0f6904d6 ]

At times when I'm using kgdb I see a splat on my console about
suspicious RCU usage.  I managed to come up with a case that could
reproduce this that looked like this:

  WARNING: suspicious RCU usage
  5.7.0-rc4+ #609 Not tainted
  -----------------------------
  kernel/pid.c:395 find_task_by_pid_ns() needs rcu_read_lock() protection!

  other info that might help us debug this:

    rcu_scheduler_active = 2, debug_locks = 1
  3 locks held by swapper/0/1:
   #0: ffffff81b6b8e988 (&dev->mutex){....}-{3:3}, at: __device_attach+0x40/0x13c
   #1: ffffffd01109e9e8 (dbg_master_lock){....}-{2:2}, at: kgdb_cpu_enter+0x20c/0x7ac
   #2: ffffffd01109ea90 (dbg_slave_lock){....}-{2:2}, at: kgdb_cpu_enter+0x3ec/0x7ac

  stack backtrace:
  CPU: 7 PID: 1 Comm: swapper/0 Not tainted 5.7.0-rc4+ #609
  Hardware name: Google Cheza (rev3+) (DT)
  Call trace:
   dump_backtrace+0x0/0x1b8
   show_stack+0x1c/0x24
   dump_stack+0xd4/0x134
   lockdep_rcu_suspicious+0xf0/0x100
   find_task_by_pid_ns+0x5c/0x80
   getthread+0x8c/0xb0
   gdb_serial_stub+0x9d4/0xd04
   kgdb_cpu_enter+0x284/0x7ac
   kgdb_handle_exception+0x174/0x20c
   kgdb_brk_fn+0x24/0x30
   call_break_hook+0x6c/0x7c
   brk_handler+0x20/0x5c
   do_debug_exception+0x1c8/0x22c
   el1_sync_handler+0x3c/0xe4
   el1_sync+0x7c/0x100
   rpmh_rsc_probe+0x38/0x420
   platform_drv_probe+0x94/0xb4
   really_probe+0x134/0x300
   driver_probe_device+0x68/0x100
   __device_attach_driver+0x90/0xa8
   bus_for_each_drv+0x84/0xcc
   __device_attach+0xb4/0x13c
   device_initial_probe+0x18/0x20
   bus_probe_device+0x38/0x98
   device_add+0x38c/0x420

If I understand properly we should just be able to blanket kgdb under
one big RCU read lock and the problem should go away.  We'll add it to
the beast-of-a-function known as kgdb_cpu_enter().

With this I no longer get any splats and things seem to work fine.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20200602154729.v2.1.I70e0d4fd46d5ed2aaf0c98a355e8e1b7a5bb7e4e@changeid
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/debug_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 6a1dc2613bb92..fbb1bfdd2fa53 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -489,6 +489,7 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs,
 		arch_kgdb_ops.disable_hw_break(regs);
 
 acquirelock:
+	rcu_read_lock();
 	/*
 	 * Interrupts will be restored by the 'trap return' code, except when
 	 * single stepping.
@@ -545,6 +546,7 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs,
 			atomic_dec(&slaves_in_kgdb);
 			dbg_touch_watchdogs();
 			local_irq_restore(flags);
+			rcu_read_unlock();
 			return 0;
 		}
 		cpu_relax();
@@ -563,6 +565,7 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs,
 		raw_spin_unlock(&dbg_master_lock);
 		dbg_touch_watchdogs();
 		local_irq_restore(flags);
+		rcu_read_unlock();
 
 		goto acquirelock;
 	}
@@ -686,6 +689,7 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs,
 	raw_spin_unlock(&dbg_master_lock);
 	dbg_touch_watchdogs();
 	local_irq_restore(flags);
+	rcu_read_unlock();
 
 	return kgdb_info[cpu].ret_state;
 }
-- 
2.25.1


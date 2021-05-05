Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59953741A3
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbhEEQkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234926AbhEEQiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:38:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16E44613EB;
        Wed,  5 May 2021 16:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232417;
        bh=9RnHg4hAxhCZQ4ROytOcGpMWjTxBkjW+LC0fYCtyNnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1PnKms1AoenSTU+eIc+GxTdL1X2c+HbE+JJeHZGFycUMzp8NtKXkoLJuMtr1keSL
         A1IcRSoBUBm57xNSCo/7DtwJeSd6WjUQx0l9EKi/ecVT83sJJ4Bh/85iQWVVm9i+8K
         eLuNxJxOKIwFjuBifpff5A/KVKXlFUHrIXFGN48ZFKlIQoxgsmBldoCrTeSmnuv+A8
         N7f00yP8lh903GFf23WbrCVsW3tunGM5UMikBWWkIr7BRm3Q9TTe0nwASkAZwUonFx
         P6pyJRG2/Ca4B9BRFIaIp1uSkqDSU+wS60M6VSpnybWrzd9P1MNy4zcsEJO2hV7v5Y
         7JNw317au9SUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.12 094/116] powerpc/pseries: Stop calling printk in rtas_stop_self()
Date:   Wed,  5 May 2021 12:31:02 -0400
Message-Id: <20210505163125.3460440-94-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit ed8029d7b472369a010a1901358567ca3b6dbb0d ]

RCU complains about us calling printk() from an offline CPU:

  =============================
  WARNING: suspicious RCU usage
  5.12.0-rc7-02874-g7cf90e481cb8 #1 Not tainted
  -----------------------------
  kernel/locking/lockdep.c:3568 RCU-list traversed in non-reader section!!

  other info that might help us debug this:

  RCU used illegally from offline CPU!
  rcu_scheduler_active = 2, debug_locks = 1
  no locks held by swapper/0/0.

  stack backtrace:
  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.12.0-rc7-02874-g7cf90e481cb8 #1
  Call Trace:
    dump_stack+0xec/0x144 (unreliable)
    lockdep_rcu_suspicious+0x124/0x144
    __lock_acquire+0x1098/0x28b0
    lock_acquire+0x128/0x600
    _raw_spin_lock_irqsave+0x6c/0xc0
    down_trylock+0x2c/0x70
    __down_trylock_console_sem+0x60/0x140
    vprintk_emit+0x1a8/0x4b0
    vprintk_func+0xcc/0x200
    printk+0x40/0x54
    pseries_cpu_offline_self+0xc0/0x120
    arch_cpu_idle_dead+0x54/0x70
    do_idle+0x174/0x4a0
    cpu_startup_entry+0x38/0x40
    rest_init+0x268/0x388
    start_kernel+0x748/0x790
    start_here_common+0x1c/0x614

Which happens because by the time we get to rtas_stop_self() we are
already offline. In addition the message can be spammy, and is not that
helpful for users, so remove it.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210418135413.1204031-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/hotplug-cpu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index 12cbffd3c2e3..325f3b220f36 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -47,9 +47,6 @@ static void rtas_stop_self(void)
 
 	BUG_ON(rtas_stop_self_token == RTAS_UNKNOWN_SERVICE);
 
-	printk("cpu %u (hwid %u) Ready to die...\n",
-	       smp_processor_id(), hard_smp_processor_id());
-
 	rtas_call_unlocked(&args, rtas_stop_self_token, 0, 1, NULL);
 
 	panic("Alas, I survived.\n");
-- 
2.30.2


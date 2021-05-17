Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F4E382FAD
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbhEQOTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:19:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238865AbhEQOQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:16:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCC1661401;
        Mon, 17 May 2021 14:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260579;
        bh=9RnHg4hAxhCZQ4ROytOcGpMWjTxBkjW+LC0fYCtyNnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQUXfHIkQD/tWQrqbL2mwdY5E+90i1EmXx0hvR6RjG1/Dugf4ZfE4YESHM/sK3RTU
         CPMzNXydG1PJtOURubCEM4niDmMGfC5LM6nHunKc7dYbhLN7xE5VNzyZiZa96vKTq0
         UYdaDX61IMntlO5KGGlqs1AhahHEZpLTeaYjuvfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 101/363] powerpc/pseries: Stop calling printk in rtas_stop_self()
Date:   Mon, 17 May 2021 15:59:27 +0200
Message-Id: <20210517140306.006746138@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




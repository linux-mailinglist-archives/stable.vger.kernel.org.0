Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9249E2ABA93
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387483AbgKINUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:20:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387475AbgKINUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:20:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 032282083B;
        Mon,  9 Nov 2020 13:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928030;
        bh=v/A80OfUdI2AyrGVlqxGk0BEl2vN5DxgvY1qGsxjCmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMmfLZyI6PhtrfYhjhT9+Tpy4hO5y/pdcHfGlidj7Qrhbsz4oPse4MtHzfd6EgsCi
         xUcWQYsouiYlOW6ltTXMVkc/xYKNs0OkbH5Ikjg4oEfpibDYjqiXyvUmUrxA+hkbCC
         DGNt61jS+X2earo31Otn6X6Cfhyx/JlaVXAArg6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 104/133] arm64/smp: Move rcu_cpu_starting() earlier
Date:   Mon,  9 Nov 2020 13:56:06 +0100
Message-Id: <20201109125035.690427751@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@redhat.com>

[ Upstream commit ce3d31ad3cac765484463b4f5a0b6b1f8f1a963e ]

The call to rcu_cpu_starting() in secondary_start_kernel() is not early
enough in the CPU-hotplug onlining process, which results in lockdep
splats as follows:

 WARNING: suspicious RCU usage
 -----------------------------
 kernel/locking/lockdep.c:3497 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 RCU used illegally from offline CPU!
 rcu_scheduler_active = 1, debug_locks = 1
 no locks held by swapper/1/0.

 Call trace:
  dump_backtrace+0x0/0x3c8
  show_stack+0x14/0x60
  dump_stack+0x14c/0x1c4
  lockdep_rcu_suspicious+0x134/0x14c
  __lock_acquire+0x1c30/0x2600
  lock_acquire+0x274/0xc48
  _raw_spin_lock+0xc8/0x140
  vprintk_emit+0x90/0x3d0
  vprintk_default+0x34/0x40
  vprintk_func+0x378/0x590
  printk+0xa8/0xd4
  __cpuinfo_store_cpu+0x71c/0x868
  cpuinfo_store_cpu+0x2c/0xc8
  secondary_start_kernel+0x244/0x318

This is avoided by moving the call to rcu_cpu_starting up near the
beginning of the secondary_start_kernel() function.

Signed-off-by: Qian Cai <cai@redhat.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/lkml/160223032121.7002.1269740091547117869.tip-bot2@tip-bot2/
Link: https://lore.kernel.org/r/20201028182614.13655-1-cai@redhat.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/smp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 355ee9eed4dde..98c059b6bacae 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -213,6 +213,7 @@ asmlinkage notrace void secondary_start_kernel(void)
 	if (system_uses_irq_prio_masking())
 		init_gic_priority_masking();
 
+	rcu_cpu_starting(cpu);
 	preempt_disable();
 	trace_hardirqs_off();
 
-- 
2.27.0




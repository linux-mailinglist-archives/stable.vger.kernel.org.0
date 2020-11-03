Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126A62A3997
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbgKCB0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:26:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbgKCBT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:19:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F40F22264;
        Tue,  3 Nov 2020 01:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366366;
        bh=v/A80OfUdI2AyrGVlqxGk0BEl2vN5DxgvY1qGsxjCmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKu1CIMi4kjzfidAYRaxiylvLnG4I9DPIrf3DzPnWZGHI2QHQOy3drrMpxyQIDqVm
         3AASXq2NkV2xsEfdS0S5qefHcGovdlBTL4ePcbYYICwBOvDi6tR5h1E/78aiIiqQ/0
         VwqXMuz7CIGKjtBQ4iL2zIRLj9ScKaEXvmIqXTFA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 35/35] arm64/smp: Move rcu_cpu_starting() earlier
Date:   Mon,  2 Nov 2020 20:18:40 -0500
Message-Id: <20201103011840.182814-35-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103011840.182814-1-sashal@kernel.org>
References: <20201103011840.182814-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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


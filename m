Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD5A2B5FE6
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgKQM5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:57:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728561AbgKQM5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90E592225B;
        Tue, 17 Nov 2020 12:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617832;
        bh=np4gkClCu/IG0KMtmwyrWwgIOOEPiPKW8reOaJ/AqKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=olkTEps7mWg2c4H48Zk0yDb3dub9ecVK3mzUtef8iiGtYsWJsw1pIHpIBxhHDHzNg
         zh3itPYnBaQY/lWdjbVvZ68RvOLLQDgU/pTtRMyqGd27g4fXD2eqzCy0945GP6jc9h
         LY9VIW1bL6TIXgDnlbOzll2aBqMeXJ+XzkuvA+C0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Qian Cai <cai@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 12/21] arm64: smp: Tell RCU about CPUs that fail to come online
Date:   Tue, 17 Nov 2020 07:56:43 -0500
Message-Id: <20201117125652.599614-12-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125652.599614-1-sashal@kernel.org>
References: <20201117125652.599614-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit 04e613ded8c26489b3e0f9101b44462f780d1a35 ]

Commit ce3d31ad3cac ("arm64/smp: Move rcu_cpu_starting() earlier") ensured
that RCU is informed early about incoming CPUs that might end up calling
into printk() before they are online. However, if such a CPU fails the
early CPU feature compatibility checks in check_local_cpu_capabilities(),
then it will be powered off or parked without informing RCU, leading to
an endless stream of stalls:

  | rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  | rcu:	2-O...: (0 ticks this GP) idle=002/1/0x4000000000000000 softirq=0/0 fqs=2593
  | (detected by 0, t=5252 jiffies, g=9317, q=136)
  | Task dump for CPU 2:
  | task:swapper/2       state:R  running task     stack:    0 pid:    0 ppid:     1 flags:0x00000028
  | Call trace:
  | ret_from_fork+0x0/0x30

Ensure that the dying CPU invokes rcu_report_dead() prior to being powered
off or parked.

Cc: Qian Cai <cai@redhat.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Suggested-by: Qian Cai <cai@redhat.com>
Link: https://lore.kernel.org/r/20201105222242.GA8842@willie-the-truck
Link: https://lore.kernel.org/r/20201106103602.9849-3-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/smp.c | 1 +
 kernel/rcu/tree.c       | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 98c059b6bacae..361cfc55cf5a7 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -401,6 +401,7 @@ void cpu_die_early(void)
 
 	/* Mark this CPU absent */
 	set_cpu_present(cpu, 0);
+	rcu_report_dead(cpu);
 
 	if (IS_ENABLED(CONFIG_HOTPLUG_CPU)) {
 		update_cpu_boot_status(CPU_KILL_ME);
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index c8f62e2d02761..b4924fefe2745 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4024,7 +4024,6 @@ void rcu_cpu_starting(unsigned int cpu)
 	smp_mb(); /* Ensure RCU read-side usage follows above initialization. */
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 /*
  * The outgoing function has no further need of RCU, so remove it from
  * the rcu_node tree's ->qsmaskinitnext bit masks.
@@ -4064,6 +4063,7 @@ void rcu_report_dead(unsigned int cpu)
 	per_cpu(rcu_cpu_started, cpu) = 0;
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
 /*
  * The outgoing CPU has just passed through the dying-idle state, and we
  * are being invoked from the CPU that was IPIed to continue the offline
-- 
2.27.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16342ACD5E
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733039AbgKJDzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:55:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733115AbgKJDzX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:55:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEA6221D93;
        Tue, 10 Nov 2020 03:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980522;
        bh=/hZ9nWbGGjFN9qdOakvapm58eAu1ac2ctQXS8eUyNkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sK8Z1PZ9mQf5Ku5ravqE3AoK86WLzCNGeBbu/jmMW8qYl22V5R+yt9SWiaY/lupwU
         gtRkqgu3cRW+JOUVH90UEAGTFXkkHXPa2/ZOvDfZRo5W4jPsPZ/SIu+es5M9MhUiFa
         XbigoRx1LavmAQPAEKtH0aP0M4zr8HEnsA0BUayI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 30/42] s390/smp: move rcu_cpu_starting() earlier
Date:   Mon,  9 Nov 2020 22:54:28 -0500
Message-Id: <20201110035440.424258-30-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035440.424258-1-sashal@kernel.org>
References: <20201110035440.424258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@redhat.com>

[ Upstream commit de5d9dae150ca1c1b5c7676711a9ca139d1a8dec ]

The call to rcu_cpu_starting() in smp_init_secondary() is not early
enough in the CPU-hotplug onlining process, which results in lockdep
splats as follows:

 WARNING: suspicious RCU usage
 -----------------------------
 kernel/locking/lockdep.c:3497 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 RCU used illegally from offline CPU!
 rcu_scheduler_active = 1, debug_locks = 1
 no locks held by swapper/1/0.

 Call Trace:
 show_stack+0x158/0x1f0
 dump_stack+0x1f2/0x238
 __lock_acquire+0x2640/0x4dd0
 lock_acquire+0x3a8/0xd08
 _raw_spin_lock_irqsave+0xc0/0xf0
 clockevents_register_device+0xa8/0x528
 init_cpu_timer+0x33e/0x468
 smp_init_secondary+0x11a/0x328
 smp_start_secondary+0x82/0x88

This is avoided by moving the call to rcu_cpu_starting up near the
beginning of the smp_init_secondary() function. Note that the
raw_smp_processor_id() is required in order to avoid calling into
lockdep before RCU has declared the CPU to be watched for readers.

Link: https://lore.kernel.org/lkml/160223032121.7002.1269740091547117869.tip-bot2@tip-bot2/
Signed-off-by: Qian Cai <cai@redhat.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/smp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index ad426cc656e56..66d7ba61803c8 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -845,13 +845,14 @@ void __init smp_detect_cpus(void)
 
 static void smp_init_secondary(void)
 {
-	int cpu = smp_processor_id();
+	int cpu = raw_smp_processor_id();
 
 	S390_lowcore.last_update_clock = get_tod_clock();
 	restore_access_regs(S390_lowcore.access_regs_save_area);
 	set_cpu_flag(CIF_ASCE_PRIMARY);
 	set_cpu_flag(CIF_ASCE_SECONDARY);
 	cpu_init();
+	rcu_cpu_starting(cpu);
 	preempt_disable();
 	init_cpu_timer();
 	vtime_init();
-- 
2.27.0


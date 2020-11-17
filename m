Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552522B6574
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbgKQNUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:20:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:54118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729499AbgKQNUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:20:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A0D1241A6;
        Tue, 17 Nov 2020 13:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619237;
        bh=6Yev0pjRKHStnjnyUM7qIny4PcOwexPPhGLSFztfQ90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1JFSVskz5KnrPpq1dZVgeexiAmIgih7eY1CiBCBXbvcWPtDFjkEw1UW9lRg+p3kzn
         syxdAKYtCoAOyzRDObfKZzsqZxQVvd6jJr7aJFzsnnZ4CQq/pmC4vpKq2M+oTf+S55
         tbKyV6y7z82PHGJ4cWbsD7t7rOx795+2WIhLsQeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 044/101] s390/smp: move rcu_cpu_starting() earlier
Date:   Tue, 17 Nov 2020 14:05:11 +0100
Message-Id: <20201117122115.242580393@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8e31dfd85de32..888f247c9261a 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -831,7 +831,7 @@ void __init smp_detect_cpus(void)
  */
 static void smp_start_secondary(void *cpuvoid)
 {
-	int cpu = smp_processor_id();
+	int cpu = raw_smp_processor_id();
 
 	S390_lowcore.last_update_clock = get_tod_clock();
 	S390_lowcore.restart_stack = (unsigned long) restart_stack;
@@ -844,6 +844,7 @@ static void smp_start_secondary(void *cpuvoid)
 	set_cpu_flag(CIF_ASCE_PRIMARY);
 	set_cpu_flag(CIF_ASCE_SECONDARY);
 	cpu_init();
+	rcu_cpu_starting(cpu);
 	preempt_disable();
 	init_cpu_timer();
 	vtime_init();
-- 
2.27.0




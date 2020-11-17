Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241112B6325
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732461AbgKQNfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:35:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732455AbgKQNfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:35:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF7BC2466D;
        Tue, 17 Nov 2020 13:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620119;
        bh=6DIxz/ib5e4NY8x17EduEG3JMHRG1WPKsMLGX1UO9Bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNfNpvNup/pUy6OB6Wayy4WpzHtEKnTxdVZNzZZXFr8JTlsFYN+iDu483sWmlo7GR
         YG/E9uGGF2VZZ61tcQTMbDRsCIwaasDBrF/FapfSvp61cPRahqF+44VEKCHTZm3lzn
         azh2lIDNoAs/nI1uBIZPlTL+v6OullmABPT6ISo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 113/255] s390/smp: move rcu_cpu_starting() earlier
Date:   Tue, 17 Nov 2020 14:04:13 +0100
Message-Id: <20201117122144.446679032@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
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
index 85700bd85f98d..3b4c3140c18e7 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -855,13 +855,14 @@ void __init smp_detect_cpus(void)
 
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




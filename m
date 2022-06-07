Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D26B541166
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353807AbiFGThL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355651AbiFGTe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:34:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98DF1AAD9A;
        Tue,  7 Jun 2022 11:13:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1BA0B81F38;
        Tue,  7 Jun 2022 18:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3985CC385A2;
        Tue,  7 Jun 2022 18:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625582;
        bh=YSX/7n1oVQm+uQERVnQy9bL87Xolwzrtf3PB0jMBJVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FrCAD3QmnZXOiPQ5xZXIIGZbXzKK+WzcBFoGutF4WYybtLh56NJaKNd/gOM2xQ86P
         dER6FGsDQyaPZPrkoB9OOCMNA0EIomlSq28n11uBEibvKgIAfZ8bvHs9duauqg5AYe
         neo27yP35dpKqBBcya/FS0xbqRHOoVzeX/vNFYXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Padmanabha Srinivasaiah <treasure4paddy@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 069/772] rcu-tasks: Fix race in schedule and flush work
Date:   Tue,  7 Jun 2022 18:54:21 +0200
Message-Id: <20220607164951.074003431@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Padmanabha Srinivasaiah <treasure4paddy@gmail.com>

[ Upstream commit f75fd4b9221d93177c50dcfde671b2e907f53e86 ]

While booting secondary CPUs, cpus_read_[lock/unlock] is not keeping
online cpumask stable. The transient online mask results in below
calltrace.

[    0.324121] CPU1: Booted secondary processor 0x0000000001 [0x410fd083]
[    0.346652] Detected PIPT I-cache on CPU2
[    0.347212] CPU2: Booted secondary processor 0x0000000002 [0x410fd083]
[    0.377255] Detected PIPT I-cache on CPU3
[    0.377823] CPU3: Booted secondary processor 0x0000000003 [0x410fd083]
[    0.379040] ------------[ cut here ]------------
[    0.383662] WARNING: CPU: 0 PID: 10 at kernel/workqueue.c:3084 __flush_work+0x12c/0x138
[    0.384850] Modules linked in:
[    0.385403] CPU: 0 PID: 10 Comm: rcu_tasks_rude_ Not tainted 5.17.0-rc3-v8+ #13
[    0.386473] Hardware name: Raspberry Pi 4 Model B Rev 1.4 (DT)
[    0.387289] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.388308] pc : __flush_work+0x12c/0x138
[    0.388970] lr : __flush_work+0x80/0x138
[    0.389620] sp : ffffffc00aaf3c60
[    0.390139] x29: ffffffc00aaf3d20 x28: ffffffc009c16af0 x27: ffffff80f761df48
[    0.391316] x26: 0000000000000004 x25: 0000000000000003 x24: 0000000000000100
[    0.392493] x23: ffffffffffffffff x22: ffffffc009c16b10 x21: ffffffc009c16b28
[    0.393668] x20: ffffffc009e53861 x19: ffffff80f77fbf40 x18: 00000000d744fcc9
[    0.394842] x17: 000000000000000b x16: 00000000000001c2 x15: ffffffc009e57550
[    0.396016] x14: 0000000000000000 x13: ffffffffffffffff x12: 0000000100000000
[    0.397190] x11: 0000000000000462 x10: ffffff8040258008 x9 : 0000000100000000
[    0.398364] x8 : 0000000000000000 x7 : ffffffc0093c8bf4 x6 : 0000000000000000
[    0.399538] x5 : 0000000000000000 x4 : ffffffc00a976e40 x3 : ffffffc00810444c
[    0.400711] x2 : 0000000000000004 x1 : 0000000000000000 x0 : 0000000000000000
[    0.401886] Call trace:
[    0.402309]  __flush_work+0x12c/0x138
[    0.402941]  schedule_on_each_cpu+0x228/0x278
[    0.403693]  rcu_tasks_rude_wait_gp+0x130/0x144
[    0.404502]  rcu_tasks_kthread+0x220/0x254
[    0.405264]  kthread+0x174/0x1ac
[    0.405837]  ret_from_fork+0x10/0x20
[    0.406456] irq event stamp: 102
[    0.406966] hardirqs last  enabled at (101): [<ffffffc0093c8468>] _raw_spin_unlock_irq+0x78/0xb4
[    0.408304] hardirqs last disabled at (102): [<ffffffc0093b8270>] el1_dbg+0x24/0x5c
[    0.409410] softirqs last  enabled at (54): [<ffffffc0081b80c8>] local_bh_enable+0xc/0x2c
[    0.410645] softirqs last disabled at (50): [<ffffffc0081b809c>] local_bh_disable+0xc/0x2c
[    0.411890] ---[ end trace 0000000000000000 ]---
[    0.413000] smp: Brought up 1 node, 4 CPUs
[    0.413762] SMP: Total of 4 processors activated.
[    0.414566] CPU features: detected: 32-bit EL0 Support
[    0.415414] CPU features: detected: 32-bit EL1 Support
[    0.416278] CPU features: detected: CRC32 instructions
[    0.447021] Callback from call_rcu_tasks_rude() invoked.
[    0.506693] Callback from call_rcu_tasks() invoked.

This commit therefore fixes this issue by applying a single-CPU
optimization to the RCU Tasks Rude grace-period process.  The key point
here is that the purpose of this RCU flavor is to force a schedule on
each online CPU since some past event.  But the rcu_tasks_rude_wait_gp()
function runs in the context of the RCU Tasks Rude's grace-period kthread,
so there must already have been a context switch on the current CPU since
the call to either synchronize_rcu_tasks_rude() or call_rcu_tasks_rude().
So if there is only a single CPU online, RCU Tasks Rude's grace-period
kthread does not need to anything at all.

It turns out that the rcu_tasks_rude_wait_gp() function's call to
schedule_on_each_cpu() causes problems during early boot.  During that
time, there is only one online CPU, namely the boot CPU.  Therefore,
applying this single-CPU optimization fixes early-boot instances of
this problem.

Link: https://lore.kernel.org/lkml/20220210184319.25009-1-treasure4paddy@gmail.com/T/
Suggested-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Padmanabha Srinivasaiah <treasure4paddy@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index d64f0b1d8cd3..30c42797f53b 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -950,6 +950,9 @@ static void rcu_tasks_be_rude(struct work_struct *work)
 // Wait for one rude RCU-tasks grace period.
 static void rcu_tasks_rude_wait_gp(struct rcu_tasks *rtp)
 {
+	if (num_online_cpus() <= 1)
+		return;	// Fastpath for only one CPU.
+
 	rtp->n_ipis += cpumask_weight(cpu_online_mask);
 	schedule_on_each_cpu(rcu_tasks_be_rude);
 }
-- 
2.35.1




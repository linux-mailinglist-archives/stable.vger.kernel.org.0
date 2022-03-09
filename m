Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5A64D345D
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbiCIQYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238287AbiCIQVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:21:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54547B71;
        Wed,  9 Mar 2022 08:20:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4CA6B82020;
        Wed,  9 Mar 2022 16:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEADC340E8;
        Wed,  9 Mar 2022 16:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842846;
        bh=sy3aP4fnh8SyAGLvHPsjL4Mx6PXZBmUBSdow+IfmEWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3cHu07jRkrYDDqWy/V7KVhT0YWOT0YhO3ODgo07hGx2qNyS/K95x2n0nz/+cVDxX
         8/HBHiKhTLYbJJhuWNq1G2FIzRMe9CFMXQoFeV4O+LXdORk9yF+wAJ/H3rje/Smo3W
         8Uld2t5r1C/4lzlqjcIVv5aCm/yYVUtVRbDWXOqYha2G3TBjw9lcAzaOpc1p4di5Oh
         3VA5m1lJk9Zq/mxykPNIXHtO7H7TOo5Zh8GIaIc6+PI79VVgwaKlMHrXs1RevLZBxc
         hGXmFN5PV7jk0xcp3zNWujFbXSjj7VmzBKnP0NjjG/PJuCM/OHRtZHJdk1P57VfMSt
         BmhfyXY6Vh+zQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@pm.me>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, peterz@infradead.org,
        mingo@kernel.org, valentin.schneider@arm.com,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/24] MIPS: smp: fill in sibling and core maps earlier
Date:   Wed,  9 Mar 2022 11:19:30 -0500
Message-Id: <20220309161946.136122-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161946.136122-1-sashal@kernel.org>
References: <20220309161946.136122-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

[ Upstream commit f2703def339c793674010cc9f01bfe4980231808 ]

After enabling CONFIG_SCHED_CORE (landed during 5.14 cycle),
2-core 2-thread-per-core interAptiv (CPS-driven) started emitting
the following:

[    0.025698] CPU1 revision is: 0001a120 (MIPS interAptiv (multi))
[    0.048183] ------------[ cut here ]------------
[    0.048187] WARNING: CPU: 1 PID: 0 at kernel/sched/core.c:6025 sched_core_cpu_starting+0x198/0x240
[    0.048220] Modules linked in:
[    0.048233] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.17.0-rc3+ #35 b7b319f24073fd9a3c2aa7ad15fb7993eec0b26f
[    0.048247] Stack : 817f0000 00000004 327804c8 810eb050 00000000 00000004 00000000 c314fdd1
[    0.048278]         830cbd64 819c0000 81800000 817f0000 83070bf4 00000001 830cbd08 00000000
[    0.048307]         00000000 00000000 815fcbc4 00000000 00000000 00000000 00000000 00000000
[    0.048334]         00000000 00000000 00000000 00000000 817f0000 00000000 00000000 817f6f34
[    0.048361]         817f0000 818a3c00 817f0000 00000004 00000000 00000000 4dc33260 0018c933
[    0.048389]         ...
[    0.048396] Call Trace:
[    0.048399] [<8105a7bc>] show_stack+0x3c/0x140
[    0.048424] [<8131c2a0>] dump_stack_lvl+0x60/0x80
[    0.048440] [<8108b5c0>] __warn+0xc0/0xf4
[    0.048454] [<8108b658>] warn_slowpath_fmt+0x64/0x10c
[    0.048467] [<810bd418>] sched_core_cpu_starting+0x198/0x240
[    0.048483] [<810c6514>] sched_cpu_starting+0x14/0x80
[    0.048497] [<8108c0f8>] cpuhp_invoke_callback_range+0x78/0x140
[    0.048510] [<8108d914>] notify_cpu_starting+0x94/0x140
[    0.048523] [<8106593c>] start_secondary+0xbc/0x280
[    0.048539]
[    0.048543] ---[ end trace 0000000000000000 ]---
[    0.048636] Synchronize counters for CPU 1: done.

...for each but CPU 0/boot.
Basic debug printks right before the mentioned line say:

[    0.048170] CPU: 1, smt_mask:

So smt_mask, which is sibling mask obviously, is empty when entering
the function.
This is critical, as sched_core_cpu_starting() calculates
core-scheduling parameters only once per CPU start, and it's crucial
to have all the parameters filled in at that moment (at least it
uses cpu_smt_mask() which in fact is `&cpu_sibling_map[cpu]` on
MIPS).

A bit of debugging led me to that set_cpu_sibling_map() performing
the actual map calculation, was being invocated after
notify_cpu_start(), and exactly the latter function starts CPU HP
callback round (sched_core_cpu_starting() is basically a CPU HP
callback).
While the flow is same on ARM64 (maps after the notifier, although
before calling set_cpu_online()), x86 started calculating sibling
maps earlier than starting the CPU HP callbacks in Linux 4.14 (see
[0] for the reference). Neither me nor my brief tests couldn't find
any potential caveats in calculating the maps right after performing
delay calibration, but the WARN splat is now gone.
The very same debug prints now yield exactly what I expected from
them:

[    0.048433] CPU: 1, smt_mask: 0-1

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mips/linux.git/commit/?id=76ce7cfe35ef

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/smp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index d542fb7af3ba..1986d1309410 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -351,6 +351,9 @@ asmlinkage void start_secondary(void)
 	cpu = smp_processor_id();
 	cpu_data[cpu].udelay_val = loops_per_jiffy;
 
+	set_cpu_sibling_map(cpu);
+	set_cpu_core_map(cpu);
+
 	cpumask_set_cpu(cpu, &cpu_coherent_mask);
 	notify_cpu_starting(cpu);
 
@@ -362,9 +365,6 @@ asmlinkage void start_secondary(void)
 	/* The CPU is running and counters synchronised, now mark it online */
 	set_cpu_online(cpu, true);
 
-	set_cpu_sibling_map(cpu);
-	set_cpu_core_map(cpu);
-
 	calculate_cpu_foreign_map();
 
 	/*
-- 
2.34.1


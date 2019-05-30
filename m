Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7C52ED1D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388115AbfE3D3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388114AbfE3D3t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:29:49 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 393AE24AC1;
        Thu, 30 May 2019 03:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186988;
        bh=Ii7qMkYcjjVzozbmnE/rugwNgmWxmQdi3t8GEyWlHUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eag/3AEF6Fj8RLN8XLG/UX4i0cSeSA7cb/5soZfKAlEarrDvCzIkS9J4+8osdMn33
         qO2/B4h8twqO4R9OXFYT3xuG8EeLTEX1+73M3av6xgYhLk38GlfpUiVFbhZUs/as2V
         FranlJ0bnuTzoaokNF6kG74FCWw5Xkod2v4Wkf2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Li, Meng" <Meng.Li@windriver.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 151/405] perf/arm-cci: Remove broken race mitigation
Date:   Wed, 29 May 2019 20:02:29 -0700
Message-Id: <20190530030548.785235781@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0d2e2a82d4de298d006bf8eddc86829e3c7da820 ]

Uncore PMU drivers face an awkward cyclic dependency wherein:

 - They have to pick a valid online CPU to associate with before
   registering the PMU device, since it will get exposed to userspace
   immediately.
 - The PMU registration has to be be at least partly complete before
   hotplug events can be handled, since trying to migrate an
   uninitialised context would be bad.
 - The hotplug handler has to be ready as soon as a CPU is chosen, lest
   it go offline without the user-visible cpumask value getting updated.

The arm-cci driver has tried to solve this by using get_cpu() to pick
the current CPU and prevent it from disappearing while both
registrations are performed, but that results in taking mutexes with
preemption disabled, which makes certain configurations very unhappy:

[ 1.983337] BUG: sleeping function called from invalid context at kernel/locking/rtmutex.c:2004
[ 1.983340] in_atomic(): 1, irqs_disabled(): 0, pid: 1, name: swapper/0
[ 1.983342] Preemption disabled at:
[ 1.983353] [<ffffff80089801f4>] cci_pmu_probe+0x1dc/0x488
[ 1.983360] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.18.20-rt8-yocto-preempt-rt #1
[ 1.983362] Hardware name: ZynqMP ZCU102 Rev1.0 (DT)
[ 1.983364] Call trace:
[ 1.983369] dump_backtrace+0x0/0x158
[ 1.983372] show_stack+0x24/0x30
[ 1.983378] dump_stack+0x80/0xa4
[ 1.983383] ___might_sleep+0x138/0x160
[ 1.983386] __might_sleep+0x58/0x90
[ 1.983391] __rt_mutex_lock_state+0x30/0xc0
[ 1.983395] _mutex_lock+0x24/0x30
[ 1.983400] perf_pmu_register+0x2c/0x388
[ 1.983404] cci_pmu_probe+0x2bc/0x488
[ 1.983409] platform_drv_probe+0x58/0xa8

It is not feasible to resolve all the possible races outside of the perf
core itself, so address the immediate bug by following the example of
nearly every other PMU driver and not even trying to do so. Registering
the hotplug notifier first should minimise the window in which things
can go wrong, so that's about as much as we can reasonably do here. This
also revealed an additional race in assigning the global pointer too
late relative to the hotplug notifier, which gets fixed in the process.

Reported-by: Li, Meng <Meng.Li@windriver.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cci.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/perf/arm-cci.c b/drivers/perf/arm-cci.c
index bfd03e0233084..8f8606b9bc9ee 100644
--- a/drivers/perf/arm-cci.c
+++ b/drivers/perf/arm-cci.c
@@ -1684,21 +1684,24 @@ static int cci_pmu_probe(struct platform_device *pdev)
 	raw_spin_lock_init(&cci_pmu->hw_events.pmu_lock);
 	mutex_init(&cci_pmu->reserve_mutex);
 	atomic_set(&cci_pmu->active_events, 0);
-	cci_pmu->cpu = get_cpu();
-
-	ret = cci_pmu_init(cci_pmu, pdev);
-	if (ret) {
-		put_cpu();
-		return ret;
-	}
 
+	cci_pmu->cpu = raw_smp_processor_id();
+	g_cci_pmu = cci_pmu;
 	cpuhp_setup_state_nocalls(CPUHP_AP_PERF_ARM_CCI_ONLINE,
 				  "perf/arm/cci:online", NULL,
 				  cci_pmu_offline_cpu);
-	put_cpu();
-	g_cci_pmu = cci_pmu;
+
+	ret = cci_pmu_init(cci_pmu, pdev);
+	if (ret)
+		goto error_pmu_init;
+
 	pr_info("ARM %s PMU driver probed", cci_pmu->model->name);
 	return 0;
+
+error_pmu_init:
+	cpuhp_remove_state(CPUHP_AP_PERF_ARM_CCI_ONLINE);
+	g_cci_pmu = NULL;
+	return ret;
 }
 
 static int cci_pmu_remove(struct platform_device *pdev)
-- 
2.20.1




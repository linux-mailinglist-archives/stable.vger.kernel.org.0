Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B640247381
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388592AbgHQS5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730872AbgHQPuO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:50:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13CCC2065D;
        Mon, 17 Aug 2020 15:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679413;
        bh=uuMTeL7/mJ6LPBIWYPxtOVDrOKl9ZtXuIdNwtd3RTHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wGHxqecpkbWM8JBkI96dh+Zo9+w5HN9/PJzuMZ0UH24r5UNzX3tc9qHnJm2kb3MAE
         JnjKt/gEhge6M+z5YW8Eibx+ddcqtPDp47ghNzrx+lhDJUs0oiLaEW6t8OFPno8ptz
         Ht4EczXYMedKhUkxGlqf83k4kWsXF92EK8vwG8Zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 203/393] powerpc/rtas: dont online CPUs for partition suspend
Date:   Mon, 17 Aug 2020 17:14:13 +0200
Message-Id: <20200817143829.474079959@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit ec2fc2a9e9bbad9023aab65bc472ce7a3ca8608f ]

Partition suspension, used for hibernation and migration, requires
that the OS place all but one of the LPAR's processor threads into one
of two states prior to calling the ibm,suspend-me RTAS function:

  * the architected offline state (via RTAS stop-self); or
  * the H_JOIN hcall, which does not return until the partition
    resumes execution

Using H_CEDE as the offline mode, introduced by
commit 3aa565f53c39 ("powerpc/pseries: Add hooks to put the CPU into
an appropriate offline state"), means that any threads which are
offline from Linux's point of view must be moved to one of those two
states before a partition suspension can proceed.

This was eventually addressed in commit 120496ac2d2d ("powerpc: Bring
all threads online prior to migration/hibernation"), which added code
to temporarily bring up any offline processor threads so they can call
H_JOIN. Conceptually this is fine, but the implementation has had
multiple races with cpu hotplug operations initiated from user
space[1][2][3], the error handling is fragile, and it generates
user-visible cpu hotplug events which is a lot of noise for a platform
feature that's supposed to minimize disruption to workloads.

With commit 3aa565f53c39 ("powerpc/pseries: Add hooks to put the CPU
into an appropriate offline state") reverted, this code becomes
unnecessary, so remove it. Since any offline CPUs now are truly
offline from the platform's point of view, it is no longer necessary
to bring up CPUs only to have them call H_JOIN and then go offline
again upon resuming. Only active threads are required to call H_JOIN;
stopped threads can be left alone.

[1] commit a6717c01ddc2 ("powerpc/rtas: use device model APIs and
    serialization during LPM")
[2] commit 9fb603050ffd ("powerpc/rtas: retry when cpu offline races
    with suspend/migration")
[3] commit dfd718a2ed1f ("powerpc/rtas: Fix a potential race between
    CPU-Offline & Migration")

Fixes: 120496ac2d2d ("powerpc: Bring all threads online prior to migration/hibernation")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200612051238.1007764-3-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/rtas.h          |   2 -
 arch/powerpc/kernel/rtas.c               | 122 +----------------------
 arch/powerpc/platforms/pseries/suspend.c |  22 +---
 3 files changed, 3 insertions(+), 143 deletions(-)

diff --git a/arch/powerpc/include/asm/rtas.h b/arch/powerpc/include/asm/rtas.h
index 3c1887351c713..bd227e0eab07b 100644
--- a/arch/powerpc/include/asm/rtas.h
+++ b/arch/powerpc/include/asm/rtas.h
@@ -368,8 +368,6 @@ extern int rtas_set_indicator_fast(int indicator, int index, int new_value);
 extern void rtas_progress(char *s, unsigned short hex);
 extern int rtas_suspend_cpu(struct rtas_suspend_me_data *data);
 extern int rtas_suspend_last_cpu(struct rtas_suspend_me_data *data);
-extern int rtas_online_cpus_mask(cpumask_var_t cpus);
-extern int rtas_offline_cpus_mask(cpumask_var_t cpus);
 extern int rtas_ibm_suspend_me(u64 handle);
 
 struct rtc_time;
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index c5fa251b8950c..01210593d60c3 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -842,96 +842,6 @@ static void rtas_percpu_suspend_me(void *info)
 	__rtas_suspend_cpu((struct rtas_suspend_me_data *)info, 1);
 }
 
-enum rtas_cpu_state {
-	DOWN,
-	UP,
-};
-
-#ifndef CONFIG_SMP
-static int rtas_cpu_state_change_mask(enum rtas_cpu_state state,
-				cpumask_var_t cpus)
-{
-	if (!cpumask_empty(cpus)) {
-		cpumask_clear(cpus);
-		return -EINVAL;
-	} else
-		return 0;
-}
-#else
-/* On return cpumask will be altered to indicate CPUs changed.
- * CPUs with states changed will be set in the mask,
- * CPUs with status unchanged will be unset in the mask. */
-static int rtas_cpu_state_change_mask(enum rtas_cpu_state state,
-				cpumask_var_t cpus)
-{
-	int cpu;
-	int cpuret = 0;
-	int ret = 0;
-
-	if (cpumask_empty(cpus))
-		return 0;
-
-	for_each_cpu(cpu, cpus) {
-		struct device *dev = get_cpu_device(cpu);
-
-		switch (state) {
-		case DOWN:
-			cpuret = device_offline(dev);
-			break;
-		case UP:
-			cpuret = device_online(dev);
-			break;
-		}
-		if (cpuret < 0) {
-			pr_debug("%s: cpu_%s for cpu#%d returned %d.\n",
-					__func__,
-					((state == UP) ? "up" : "down"),
-					cpu, cpuret);
-			if (!ret)
-				ret = cpuret;
-			if (state == UP) {
-				/* clear bits for unchanged cpus, return */
-				cpumask_shift_right(cpus, cpus, cpu);
-				cpumask_shift_left(cpus, cpus, cpu);
-				break;
-			} else {
-				/* clear bit for unchanged cpu, continue */
-				cpumask_clear_cpu(cpu, cpus);
-			}
-		}
-		cond_resched();
-	}
-
-	return ret;
-}
-#endif
-
-int rtas_online_cpus_mask(cpumask_var_t cpus)
-{
-	int ret;
-
-	ret = rtas_cpu_state_change_mask(UP, cpus);
-
-	if (ret) {
-		cpumask_var_t tmp_mask;
-
-		if (!alloc_cpumask_var(&tmp_mask, GFP_KERNEL))
-			return ret;
-
-		/* Use tmp_mask to preserve cpus mask from first failure */
-		cpumask_copy(tmp_mask, cpus);
-		rtas_offline_cpus_mask(tmp_mask);
-		free_cpumask_var(tmp_mask);
-	}
-
-	return ret;
-}
-
-int rtas_offline_cpus_mask(cpumask_var_t cpus)
-{
-	return rtas_cpu_state_change_mask(DOWN, cpus);
-}
-
 int rtas_ibm_suspend_me(u64 handle)
 {
 	long state;
@@ -939,8 +849,6 @@ int rtas_ibm_suspend_me(u64 handle)
 	unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
 	struct rtas_suspend_me_data data;
 	DECLARE_COMPLETION_ONSTACK(done);
-	cpumask_var_t offline_mask;
-	int cpuret;
 
 	if (!rtas_service_present("ibm,suspend-me"))
 		return -ENOSYS;
@@ -961,9 +869,6 @@ int rtas_ibm_suspend_me(u64 handle)
 		return -EIO;
 	}
 
-	if (!alloc_cpumask_var(&offline_mask, GFP_KERNEL))
-		return -ENOMEM;
-
 	atomic_set(&data.working, 0);
 	atomic_set(&data.done, 0);
 	atomic_set(&data.error, 0);
@@ -972,24 +877,8 @@ int rtas_ibm_suspend_me(u64 handle)
 
 	lock_device_hotplug();
 
-	/* All present CPUs must be online */
-	cpumask_andnot(offline_mask, cpu_present_mask, cpu_online_mask);
-	cpuret = rtas_online_cpus_mask(offline_mask);
-	if (cpuret) {
-		pr_err("%s: Could not bring present CPUs online.\n", __func__);
-		atomic_set(&data.error, cpuret);
-		goto out;
-	}
-
 	cpu_hotplug_disable();
 
-	/* Check if we raced with a CPU-Offline Operation */
-	if (!cpumask_equal(cpu_present_mask, cpu_online_mask)) {
-		pr_info("%s: Raced against a concurrent CPU-Offline\n", __func__);
-		atomic_set(&data.error, -EAGAIN);
-		goto out_hotplug_enable;
-	}
-
 	/* Call function on all CPUs.  One of us will make the
 	 * rtas call
 	 */
@@ -1000,18 +889,11 @@ int rtas_ibm_suspend_me(u64 handle)
 	if (atomic_read(&data.error) != 0)
 		printk(KERN_ERR "Error doing global join\n");
 
-out_hotplug_enable:
-	cpu_hotplug_enable();
 
-	/* Take down CPUs not online prior to suspend */
-	cpuret = rtas_offline_cpus_mask(offline_mask);
-	if (cpuret)
-		pr_warn("%s: Could not restore CPUs to offline state.\n",
-				__func__);
+	cpu_hotplug_enable();
 
-out:
 	unlock_device_hotplug();
-	free_cpumask_var(offline_mask);
+
 	return atomic_read(&data.error);
 }
 #else /* CONFIG_PPC_PSERIES */
diff --git a/arch/powerpc/platforms/pseries/suspend.c b/arch/powerpc/platforms/pseries/suspend.c
index 0a24a5a185f02..f789693f61f40 100644
--- a/arch/powerpc/platforms/pseries/suspend.c
+++ b/arch/powerpc/platforms/pseries/suspend.c
@@ -132,15 +132,11 @@ static ssize_t store_hibernate(struct device *dev,
 			       struct device_attribute *attr,
 			       const char *buf, size_t count)
 {
-	cpumask_var_t offline_mask;
 	int rc;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!alloc_cpumask_var(&offline_mask, GFP_KERNEL))
-		return -ENOMEM;
-
 	stream_id = simple_strtoul(buf, NULL, 16);
 
 	do {
@@ -150,32 +146,16 @@ static ssize_t store_hibernate(struct device *dev,
 	} while (rc == -EAGAIN);
 
 	if (!rc) {
-		/* All present CPUs must be online */
-		cpumask_andnot(offline_mask, cpu_present_mask,
-				cpu_online_mask);
-		rc = rtas_online_cpus_mask(offline_mask);
-		if (rc) {
-			pr_err("%s: Could not bring present CPUs online.\n",
-					__func__);
-			goto out;
-		}
-
 		stop_topology_update();
 		rc = pm_suspend(PM_SUSPEND_MEM);
 		start_topology_update();
-
-		/* Take down CPUs not online prior to suspend */
-		if (!rtas_offline_cpus_mask(offline_mask))
-			pr_warn("%s: Could not restore CPUs to offline "
-					"state.\n", __func__);
 	}
 
 	stream_id = 0;
 
 	if (!rc)
 		rc = count;
-out:
-	free_cpumask_var(offline_mask);
+
 	return rc;
 }
 
-- 
2.25.1




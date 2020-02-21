Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E85F167610
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731663AbgBUIH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:07:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732056AbgBUIH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:07:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39CFA20722;
        Fri, 21 Feb 2020 08:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272446;
        bh=pf9UaLxOlUPcCx5P27LQuskjK8DWuCRpQhEgZzW9TH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2BmsQoSI9ZIZYjY7/xt0H90D1ly2PZCc3wy24p0OogVd7KbMzIF1r1I+EsT23OGc3
         RBWf+EBUVUk93y/n/tHCSJUAgou6eB5LXEwwiYbo5oH4FQviq0lu/8QDNUo9i8FNBX
         lyXxa8h9zWlBCgOlBOpGlejwKvupeZj3da4E6Q2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/344] padata: validate cpumask without removed CPU during offline
Date:   Fri, 21 Feb 2020 08:38:31 +0100
Message-Id: <20200221072359.075822824@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

[ Upstream commit 894c9ef9780c5cf2f143415e867ee39a33ecb75d ]

Configuring an instance's parallel mask without any online CPUs...

  echo 2 > /sys/kernel/pcrypt/pencrypt/parallel_cpumask
  echo 0 > /sys/devices/system/cpu/cpu1/online

...makes tcrypt mode=215 crash like this:

  divide error: 0000 [#1] SMP PTI
  CPU: 4 PID: 283 Comm: modprobe Not tainted 5.4.0-rc8-padata-doc-v2+ #2
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20191013_105130-anatol 04/01/2014
  RIP: 0010:padata_do_parallel+0x114/0x300
  Call Trace:
   pcrypt_aead_encrypt+0xc0/0xd0 [pcrypt]
   crypto_aead_encrypt+0x1f/0x30
   do_mult_aead_op+0x4e/0xdf [tcrypt]
   test_mb_aead_speed.constprop.0.cold+0x226/0x564 [tcrypt]
   do_test+0x28c2/0x4d49 [tcrypt]
   tcrypt_mod_init+0x55/0x1000 [tcrypt]
   ...

cpumask_weight() in padata_cpu_hash() returns 0 because the mask has no
CPUs.  The problem is __padata_remove_cpu() checks for valid masks too
early and so doesn't mark the instance PADATA_INVALID as expected, which
would have made padata_do_parallel() return error before doing the
division.

Fix by introducing a second padata CPU hotplug state before
CPUHP_BRINGUP_CPU so that __padata_remove_cpu() sees the online mask
without @cpu.  No need for the second argument to padata_replace() since
@cpu is now already missing from the online mask.

Fixes: 33e54450683c ("padata: Handle empty padata cpumasks")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cpuhotplug.h |  1 +
 kernel/padata.c            | 30 ++++++++++++++++++------------
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 068793a619ca8..2d55cee638fc6 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -59,6 +59,7 @@ enum cpuhp_state {
 	CPUHP_IOMMU_INTEL_DEAD,
 	CPUHP_LUSTRE_CFS_DEAD,
 	CPUHP_AP_ARM_CACHE_B15_RAC_DEAD,
+	CPUHP_PADATA_DEAD,
 	CPUHP_WORKQUEUE_PREP,
 	CPUHP_POWER_NUMA_PREPARE,
 	CPUHP_HRTIMERS_PREPARE,
diff --git a/kernel/padata.c b/kernel/padata.c
index 9c82ee4a97323..fda7a7039422d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -512,7 +512,7 @@ static int padata_replace_one(struct padata_shell *ps)
 	return 0;
 }
 
-static int padata_replace(struct padata_instance *pinst, int cpu)
+static int padata_replace(struct padata_instance *pinst)
 {
 	int notification_mask = 0;
 	struct padata_shell *ps;
@@ -523,16 +523,12 @@ static int padata_replace(struct padata_instance *pinst, int cpu)
 	cpumask_copy(pinst->omask, pinst->rcpumask.pcpu);
 	cpumask_and(pinst->rcpumask.pcpu, pinst->cpumask.pcpu,
 		    cpu_online_mask);
-	if (cpu >= 0)
-		cpumask_clear_cpu(cpu, pinst->rcpumask.pcpu);
 	if (!cpumask_equal(pinst->omask, pinst->rcpumask.pcpu))
 		notification_mask |= PADATA_CPU_PARALLEL;
 
 	cpumask_copy(pinst->omask, pinst->rcpumask.cbcpu);
 	cpumask_and(pinst->rcpumask.cbcpu, pinst->cpumask.cbcpu,
 		    cpu_online_mask);
-	if (cpu >= 0)
-		cpumask_clear_cpu(cpu, pinst->rcpumask.cbcpu);
 	if (!cpumask_equal(pinst->omask, pinst->rcpumask.cbcpu))
 		notification_mask |= PADATA_CPU_SERIAL;
 
@@ -624,7 +620,7 @@ out_replace:
 	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
 	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
 
-	err = padata_setup_cpumasks(pinst) ?: padata_replace(pinst, -1);
+	err = padata_setup_cpumasks(pinst) ?: padata_replace(pinst);
 
 	if (valid)
 		__padata_start(pinst);
@@ -715,7 +711,7 @@ static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
 	int err = 0;
 
 	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
-		err = padata_replace(pinst, -1);
+		err = padata_replace(pinst);
 
 		if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu) &&
 		    padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
@@ -729,12 +725,12 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 {
 	int err = 0;
 
-	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
+	if (!cpumask_test_cpu(cpu, cpu_online_mask)) {
 		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
 		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
 			__padata_stop(pinst);
 
-		err = padata_replace(pinst, cpu);
+		err = padata_replace(pinst);
 	}
 
 	return err;
@@ -796,7 +792,7 @@ static int padata_cpu_online(unsigned int cpu, struct hlist_node *node)
 	return ret;
 }
 
-static int padata_cpu_prep_down(unsigned int cpu, struct hlist_node *node)
+static int padata_cpu_dead(unsigned int cpu, struct hlist_node *node)
 {
 	struct padata_instance *pinst;
 	int ret;
@@ -817,6 +813,7 @@ static enum cpuhp_state hp_online;
 static void __padata_free(struct padata_instance *pinst)
 {
 #ifdef CONFIG_HOTPLUG_CPU
+	cpuhp_state_remove_instance_nocalls(CPUHP_PADATA_DEAD, &pinst->node);
 	cpuhp_state_remove_instance_nocalls(hp_online, &pinst->node);
 #endif
 
@@ -1024,6 +1021,8 @@ static struct padata_instance *padata_alloc(const char *name,
 
 #ifdef CONFIG_HOTPLUG_CPU
 	cpuhp_state_add_instance_nocalls_cpuslocked(hp_online, &pinst->node);
+	cpuhp_state_add_instance_nocalls_cpuslocked(CPUHP_PADATA_DEAD,
+						    &pinst->node);
 #endif
 
 	put_online_cpus();
@@ -1136,17 +1135,24 @@ static __init int padata_driver_init(void)
 	int ret;
 
 	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "padata:online",
-				      padata_cpu_online,
-				      padata_cpu_prep_down);
+				      padata_cpu_online, NULL);
 	if (ret < 0)
 		return ret;
 	hp_online = ret;
+
+	ret = cpuhp_setup_state_multi(CPUHP_PADATA_DEAD, "padata:dead",
+				      NULL, padata_cpu_dead);
+	if (ret < 0) {
+		cpuhp_remove_multi_state(hp_online);
+		return ret;
+	}
 	return 0;
 }
 module_init(padata_driver_init);
 
 static __exit void padata_driver_exit(void)
 {
+	cpuhp_remove_multi_state(CPUHP_PADATA_DEAD);
 	cpuhp_remove_multi_state(hp_online);
 }
 module_exit(padata_driver_exit);
-- 
2.20.1




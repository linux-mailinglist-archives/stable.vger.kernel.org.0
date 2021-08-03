Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C733DEE20
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 14:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbhHCMrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 08:47:13 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:16037 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236105AbhHCMrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 08:47:12 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GfF0Z23hfzZwFc;
        Tue,  3 Aug 2021 20:43:26 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 3 Aug 2021 20:46:59 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 3 Aug 2021
 20:46:58 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     <steffen.klassert@secunet.com>, <daniel.m.jordan@oracle.com>,
        <herbert@gondor.apana.org.au>, <gregkh@linuxfoundation.org>,
        <sashal@kernel.org>
Subject: [PATCH 4.19 1/2] padata: validate cpumask without removed CPU during offline
Date:   Tue, 3 Aug 2021 20:53:00 +0800
Message-ID: <20210803125301.77629-2-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803125301.77629-1-yangyingliang@huawei.com>
References: <20210803125301.77629-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
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
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 include/linux/cpuhotplug.h |  1 +
 kernel/padata.c            | 18 ++++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 3d323c6c85260..b51da879d7be0 100644
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
index 93e4fb2d9f2ee..4401b4f13d0be 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -682,7 +682,7 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 {
 	struct parallel_data *pd = NULL;
 
-	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
+	if (!cpumask_test_cpu(cpu, cpu_online_mask)) {
 
 		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
 		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
@@ -758,7 +758,7 @@ static int padata_cpu_online(unsigned int cpu, struct hlist_node *node)
 	return ret;
 }
 
-static int padata_cpu_prep_down(unsigned int cpu, struct hlist_node *node)
+static int padata_cpu_dead(unsigned int cpu, struct hlist_node *node)
 {
 	struct padata_instance *pinst;
 	int ret;
@@ -779,6 +779,7 @@ static enum cpuhp_state hp_online;
 static void __padata_free(struct padata_instance *pinst)
 {
 #ifdef CONFIG_HOTPLUG_CPU
+	cpuhp_state_remove_instance_nocalls(CPUHP_PADATA_DEAD, &pinst->node);
 	cpuhp_state_remove_instance_nocalls(hp_online, &pinst->node);
 #endif
 
@@ -964,6 +965,8 @@ static struct padata_instance *padata_alloc(struct workqueue_struct *wq,
 
 #ifdef CONFIG_HOTPLUG_CPU
 	cpuhp_state_add_instance_nocalls_cpuslocked(hp_online, &pinst->node);
+	cpuhp_state_add_instance_nocalls_cpuslocked(CPUHP_PADATA_DEAD,
+						    &pinst->node);
 #endif
 	return pinst;
 
@@ -1010,17 +1013,24 @@ static __init int padata_driver_init(void)
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
2.25.1


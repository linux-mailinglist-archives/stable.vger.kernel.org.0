Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0F73E2525
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243806AbhHFISA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:18:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243995AbhHFIQ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:16:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6A7E611EF;
        Fri,  6 Aug 2021 08:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237774;
        bh=s2bWJEORa+DqWmMyAsTBwaCD6kYNZqRTyDUNsRsO6RQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvatL+gZhNYnvtMQmtdMmXtiDfodx8xOY05MKAanGlbxo+s/RfmjEqcSv4pwKjpke
         nQx0m45OtYLPU4dYMxUFWXAWsZzofTVdGB4BD6Ba4rEa0qhiP9nCdZG5VvYz5JnYu2
         iFeYBPsQG8dUBKx6dE5owPneuK3qoskUz++9aI9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 4.19 15/16] padata: validate cpumask without removed CPU during offline
Date:   Fri,  6 Aug 2021 10:15:06 +0200
Message-Id: <20210806081111.628446735@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081111.144943357@linuxfoundation.org>
References: <20210806081111.144943357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

commit 894c9ef9780c5cf2f143415e867ee39a33ecb75d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cpuhotplug.h |    1 +
 kernel/padata.c            |   18 ++++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

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
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -682,7 +682,7 @@ static int __padata_remove_cpu(struct pa
 {
 	struct parallel_data *pd = NULL;
 
-	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
+	if (!cpumask_test_cpu(cpu, cpu_online_mask)) {
 
 		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
 		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
@@ -758,7 +758,7 @@ static int padata_cpu_online(unsigned in
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
 
@@ -964,6 +965,8 @@ static struct padata_instance *padata_al
 
 #ifdef CONFIG_HOTPLUG_CPU
 	cpuhp_state_add_instance_nocalls_cpuslocked(hp_online, &pinst->node);
+	cpuhp_state_add_instance_nocalls_cpuslocked(CPUHP_PADATA_DEAD,
+						    &pinst->node);
 #endif
 	return pinst;
 
@@ -1010,17 +1013,24 @@ static __init int padata_driver_init(voi
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



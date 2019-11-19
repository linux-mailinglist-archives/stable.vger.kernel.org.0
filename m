Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4D9101593
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730957AbfKSFpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:45:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730953AbfKSFpY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:45:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B82E12071B;
        Tue, 19 Nov 2019 05:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142323;
        bh=OYfmMb3m2nCIOs2EeM9NS1uXNPRrO6cIesaP/zHuJJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtPVNGLbOOOpEq239OjKLgSKHYWNk+WfXtYOqepcrH0IQ5xatU0mxSkfsqLrVY2NZ
         tEwycatKXh1RF+BwIqUoGldvYEOLTHSP5l6enm2xY7RuUsciTDN+9c3rfbCwgidoBs
         GLrymaWn5bMf2KERKZrM5wae/zk1opZlJKMdae9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anju T Sudhakar <anju@linux.vnet.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Donnellan <ajd@linux.ibm.com>
Subject: [PATCH 4.14 007/239] powerpc/perf: Fix kfree memory allocated for nest pmus
Date:   Tue, 19 Nov 2019 06:16:47 +0100
Message-Id: <20191119051258.907487839@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anju T Sudhakar <anju@linux.vnet.ibm.com>

commit 110df8bd3e418b3476cae80babe8add48a8ea523 upstream.

imc_common_cpuhp_mem_free() is the common function for all
IMC (In-memory Collection counters) domains to unregister cpuhotplug
callback and free memory. Since kfree of memory allocated for
nest-imc (per_nest_pmu_arr) is in the common code, all
domains (core/nest/thread) can do the kfree in the failure case.

This could potentially create a call trace as shown below, where
core(/thread/nest) imc pmu initialization fails and in the failure
path imc_common_cpuhp_mem_free() free the memory(per_nest_pmu_arr),
which is allocated by successfully registered nest units.

The call trace is generated in a scenario where core-imc
initialization is made to fail and a cpuhotplug is performed in a p9
system. During cpuhotplug ppc_nest_imc_cpu_offline() tries to access
per_nest_pmu_arr, which is already freed by core-imc.

  NIP [c000000000cb6a94] mutex_lock+0x34/0x90
  LR [c000000000cb6a88] mutex_lock+0x28/0x90
  Call Trace:
    mutex_lock+0x28/0x90 (unreliable)
    perf_pmu_migrate_context+0x90/0x3a0
    ppc_nest_imc_cpu_offline+0x190/0x1f0
    cpuhp_invoke_callback+0x160/0x820
    cpuhp_thread_fun+0x1bc/0x270
    smpboot_thread_fn+0x250/0x290
    kthread+0x1a8/0x1b0
    ret_from_kernel_thread+0x5c/0x74

To address this scenario do the kfree(per_nest_pmu_arr) only in case
of nest-imc initialization failure, and when there is no other nest
units registered.

Fixes: 73ce9aec65b1 ("powerpc/perf: Fix IMC_MAX_PMU macro")
Signed-off-by: Anju T Sudhakar <anju@linux.vnet.ibm.com>
Reviewed-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/perf/imc-pmu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/powerpc/perf/imc-pmu.c
+++ b/arch/powerpc/perf/imc-pmu.c
@@ -1189,6 +1189,7 @@ static void imc_common_cpuhp_mem_free(st
 		if (nest_pmus == 1) {
 			cpuhp_remove_state(CPUHP_AP_PERF_POWERPC_NEST_IMC_ONLINE);
 			kfree(nest_imc_refc);
+			kfree(per_nest_pmu_arr);
 		}
 
 		if (nest_pmus > 0)
@@ -1213,7 +1214,6 @@ static void imc_common_cpuhp_mem_free(st
 		kfree(pmu_ptr->attr_groups[IMC_EVENT_ATTR]->attrs);
 	kfree(pmu_ptr->attr_groups[IMC_EVENT_ATTR]);
 	kfree(pmu_ptr);
-	kfree(per_nest_pmu_arr);
 	return;
 }
 
@@ -1327,6 +1327,8 @@ int init_imc_pmu(struct device_node *par
 			ret = nest_pmu_cpumask_init();
 			if (ret) {
 				mutex_unlock(&nest_init_lock);
+				kfree(nest_imc_refc);
+				kfree(per_nest_pmu_arr);
 				goto err_free;
 			}
 		}



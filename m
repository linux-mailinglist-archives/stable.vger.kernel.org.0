Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57B568D90C
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbjBGNPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbjBGNPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:15:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84DB6EB1
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:14:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 864E561383
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFE8C4339B;
        Tue,  7 Feb 2023 13:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775692;
        bh=+s5+//UZUMAfurAdBz5IcqHOlSK/cOB8mnUbgrORodI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V00G0zIB+XTkdf2px/s1Ao6KiegfIeEUUQnConJ9QH/H+JWFl15ivOY1v/cBjFYMb
         sPNDa+TKyuHzMIuVbf+FahjCzd7XzgGy7Z8IBrOL+5zGt/pdX640EUHFC0IXN+Zy3a
         4Msv8+RGZnz7SBiu58FhtM46mnsOMLtbjzSBsbMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kajol Jain <kjain@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 112/120] powerpc/imc-pmu: Revert nest_init_lock to being a mutex
Date:   Tue,  7 Feb 2023 13:58:03 +0100
Message-Id: <20230207125623.536839519@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit ad53db4acb415976761d7302f5b02e97f2bd097e upstream.

The recent commit 76d588dddc45 ("powerpc/imc-pmu: Fix use of mutex in
IRQs disabled section") fixed warnings (and possible deadlocks) in the
IMC PMU driver by converting the locking to use spinlocks.

It also converted the init-time nest_init_lock to a spinlock, even
though it's not used at runtime in IRQ disabled sections or while
holding other spinlocks.

This leads to warnings such as:

  BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:49
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
  preempt_count: 1, expected: 0
  CPU: 7 PID: 1 Comm: swapper/0 Not tainted 6.2.0-rc2-14719-gf12cd06109f4-dirty #1
  Hardware name: Mambo,Simulated-System POWER9 0x4e1203 opal:v6.6.6 PowerNV
  Call Trace:
    dump_stack_lvl+0x74/0xa8 (unreliable)
    __might_resched+0x178/0x1a0
    __cpuhp_setup_state+0x64/0x1e0
    init_imc_pmu+0xe48/0x1250
    opal_imc_counters_probe+0x30c/0x6a0
    platform_probe+0x78/0x110
    really_probe+0x104/0x420
    __driver_probe_device+0xb0/0x170
    driver_probe_device+0x58/0x180
    __driver_attach+0xd8/0x250
    bus_for_each_dev+0xb4/0x140
    driver_attach+0x34/0x50
    bus_add_driver+0x1e8/0x2d0
    driver_register+0xb4/0x1c0
    __platform_driver_register+0x38/0x50
    opal_imc_driver_init+0x2c/0x40
    do_one_initcall+0x80/0x360
    kernel_init_freeable+0x310/0x3b8
    kernel_init+0x30/0x1a0
    ret_from_kernel_thread+0x5c/0x64

Fix it by converting nest_init_lock back to a mutex, so that we can call
sleeping functions while holding it. There is no interaction between
nest_init_lock and the runtime spinlocks used by the actual PMU routines.

Fixes: 76d588dddc45 ("powerpc/imc-pmu: Fix use of mutex in IRQs disabled section")
Tested-by: Kajol Jain<kjain@linux.ibm.com>
Reviewed-by: Kajol Jain<kjain@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230130014401.540543-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/perf/imc-pmu.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/arch/powerpc/perf/imc-pmu.c
+++ b/arch/powerpc/perf/imc-pmu.c
@@ -21,7 +21,7 @@
  * Used to avoid races in counting the nest-pmu units during hotplug
  * register and unregister
  */
-static DEFINE_SPINLOCK(nest_init_lock);
+static DEFINE_MUTEX(nest_init_lock);
 static DEFINE_PER_CPU(struct imc_pmu_ref *, local_nest_imc_refc);
 static struct imc_pmu **per_nest_pmu_arr;
 static cpumask_t nest_imc_cpumask;
@@ -1622,7 +1622,7 @@ static void imc_common_mem_free(struct i
 static void imc_common_cpuhp_mem_free(struct imc_pmu *pmu_ptr)
 {
 	if (pmu_ptr->domain == IMC_DOMAIN_NEST) {
-		spin_lock(&nest_init_lock);
+		mutex_lock(&nest_init_lock);
 		if (nest_pmus == 1) {
 			cpuhp_remove_state(CPUHP_AP_PERF_POWERPC_NEST_IMC_ONLINE);
 			kfree(nest_imc_refc);
@@ -1632,7 +1632,7 @@ static void imc_common_cpuhp_mem_free(st
 
 		if (nest_pmus > 0)
 			nest_pmus--;
-		spin_unlock(&nest_init_lock);
+		mutex_unlock(&nest_init_lock);
 	}
 
 	/* Free core_imc memory */
@@ -1789,11 +1789,11 @@ int init_imc_pmu(struct device_node *par
 		* rest. To handle the cpuhotplug callback unregister, we track
 		* the number of nest pmus in "nest_pmus".
 		*/
-		spin_lock(&nest_init_lock);
+		mutex_lock(&nest_init_lock);
 		if (nest_pmus == 0) {
 			ret = init_nest_pmu_ref();
 			if (ret) {
-				spin_unlock(&nest_init_lock);
+				mutex_unlock(&nest_init_lock);
 				kfree(per_nest_pmu_arr);
 				per_nest_pmu_arr = NULL;
 				goto err_free_mem;
@@ -1801,7 +1801,7 @@ int init_imc_pmu(struct device_node *par
 			/* Register for cpu hotplug notification. */
 			ret = nest_pmu_cpumask_init();
 			if (ret) {
-				spin_unlock(&nest_init_lock);
+				mutex_unlock(&nest_init_lock);
 				kfree(nest_imc_refc);
 				kfree(per_nest_pmu_arr);
 				per_nest_pmu_arr = NULL;
@@ -1809,7 +1809,7 @@ int init_imc_pmu(struct device_node *par
 			}
 		}
 		nest_pmus++;
-		spin_unlock(&nest_init_lock);
+		mutex_unlock(&nest_init_lock);
 		break;
 	case IMC_DOMAIN_CORE:
 		ret = core_imc_pmu_cpumask_init();



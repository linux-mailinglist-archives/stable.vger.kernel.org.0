Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E945A452483
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350654AbhKPBj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:39:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:42232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241352AbhKOSbi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:31:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F019C611C3;
        Mon, 15 Nov 2021 17:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999133;
        bh=/eAyvJcOIIskG6EktApnuPDSLl0zARuaaGExkp6GUy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyOXc18Ggi4oDNRBG/BEnLYnxjqs75YZb/05hmDq6E4rudz6c7ulpbiHZOLr0T4OW
         n4MKJTSLR+JvPJR/dlU6BM43PWlKfVK/bqjM4eBKQ94F+n2m7034VfFWuKcaDGxWyP
         Js/+dAH24oCK4bJxZcv94h7GouupWG3n0daq6amM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bransilav Rankov <branislav.rankov@arm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.14 189/849] coresight: trbe: Defer the probe on offline CPUs
Date:   Mon, 15 Nov 2021 17:54:32 +0100
Message-Id: <20211115165426.574439088@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit a08025b3fe56185290a1ea476581f03ca733f967 upstream.

If a CPU is offline during the driver init, we could end up causing
a kernel crash trying to register the coresight device for the TRBE
instance. The trbe_cpudata for the TRBE instance is initialized only
when it is probed. Otherwise, we could end up dereferencing a NULL
cpudata->drvdata.

e.g:

[    0.149999] coresight ete0: CPU0: ete v1.1 initialized
[    0.149999] coresight-etm4x ete_1: ETM arch init failed
[    0.149999] coresight-etm4x: probe of ete_1 failed with error -22
[    0.150085] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000050
[    0.150085] Mem abort info:
[    0.150085]   ESR = 0x96000005
[    0.150085]   EC = 0x25: DABT (current EL), IL = 32 bits
[    0.150085]   SET = 0, FnV = 0
[    0.150085]   EA = 0, S1PTW = 0
[    0.150085] Data abort info:
[    0.150085]   ISV = 0, ISS = 0x00000005
[    0.150085]   CM = 0, WnR = 0
[    0.150085] [0000000000000050] user address but active_mm is swapper
[    0.150085] Internal error: Oops: 96000005 [#1] PREEMPT SMP
[    0.150085] Modules linked in:
[    0.150085] Hardware name: FVP Base RevC (DT)
[    0.150085] pstate: 00800009 (nzcv daif -PAN +UAO -TCO BTYPE=--)
[    0.150155] pc : arm_trbe_register_coresight_cpu+0x74/0x144
[    0.150155] lr : arm_trbe_register_coresight_cpu+0x48/0x144
  ...

[    0.150237] Call trace:
[    0.150237]  arm_trbe_register_coresight_cpu+0x74/0x144
[    0.150237]  arm_trbe_device_probe+0x1c0/0x2d8
[    0.150259]  platform_drv_probe+0x94/0xbc
[    0.150259]  really_probe+0x1bc/0x4a8
[    0.150266]  driver_probe_device+0x7c/0xb8
[    0.150266]  device_driver_attach+0x6c/0xac
[    0.150266]  __driver_attach+0xc4/0x148
[    0.150266]  bus_for_each_dev+0x7c/0xc8
[    0.150266]  driver_attach+0x24/0x30
[    0.150266]  bus_add_driver+0x100/0x1e0
[    0.150266]  driver_register+0x78/0x110
[    0.150266]  __platform_driver_register+0x44/0x50
[    0.150266]  arm_trbe_init+0x28/0x84
[    0.150266]  do_one_initcall+0x94/0x2bc
[    0.150266]  do_initcall_level+0xa4/0x158
[    0.150266]  do_initcalls+0x54/0x94
[    0.150319]  do_basic_setup+0x24/0x30
[    0.150319]  kernel_init_freeable+0xe8/0x14c
[    0.150319]  kernel_init+0x14/0x18c
[    0.150319]  ret_from_fork+0x10/0x30
[    0.150319] Code: f94012c8 b0004ce2 9134a442 52819801 (f9402917)
[    0.150319] ---[ end trace d23e0cfe5098535e ]---
[    0.150346] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Fix this by skipping the step, if we are unable to probe the CPU.

Fixes: 3fbf7f011f24 ("coresight: sink: Add TRBE driver")
Reported-by: Bransilav Rankov <branislav.rankov@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: stable <stable@vger.kernel.org>
Tested-by: Branislav Rankov <branislav.rankov@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20211014142238.2221248-1-suzuki.poulose@arm.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-trbe.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -869,6 +869,10 @@ static void arm_trbe_register_coresight_
 	if (WARN_ON(trbe_csdev))
 		return;
 
+	/* If the TRBE was not probed on the CPU, we shouldn't be here */
+	if (WARN_ON(!cpudata->drvdata))
+		return;
+
 	dev = &cpudata->drvdata->pdev->dev;
 	desc.name = devm_kasprintf(dev, GFP_KERNEL, "trbe%d", cpu);
 	if (!desc.name)
@@ -950,7 +954,9 @@ static int arm_trbe_probe_coresight(stru
 		return -ENOMEM;
 
 	for_each_cpu(cpu, &drvdata->supported_cpus) {
-		smp_call_function_single(cpu, arm_trbe_probe_cpu, drvdata, 1);
+		/* If we fail to probe the CPU, let us defer it to hotplug callbacks */
+		if (smp_call_function_single(cpu, arm_trbe_probe_cpu, drvdata, 1))
+			continue;
 		if (cpumask_test_cpu(cpu, &drvdata->supported_cpus))
 			arm_trbe_register_coresight_cpu(drvdata, cpu);
 		if (cpumask_test_cpu(cpu, &drvdata->supported_cpus))



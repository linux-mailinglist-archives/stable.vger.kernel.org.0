Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D59440D70
	for <lists+stable@lfdr.de>; Sun, 31 Oct 2021 08:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhJaH20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Oct 2021 03:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhJaH20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 31 Oct 2021 03:28:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6070960E9B;
        Sun, 31 Oct 2021 07:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635665155;
        bh=iWyZIEBnREv0F7c7/cvV+618SMyePRcJ9UJVt8hH+ds=;
        h=Subject:To:From:Date:From;
        b=P7vqoQqWbSfkZpBpv1C7qFNfe6RpUPjghUh0nq8Fh+Rd7SEm+3b0azQA8/Zi7xOnS
         4YTR05rkdKxyvkOR1Zz//eGearG/YkGud4jb5h72rEwiR7QQir958JpdgodGITEiP7
         sDP38s1DBXCjeXhGH/niEWw91vzkslq2clW8dI9Y=
Subject: patch "coresight: trbe: Defer the probe on offline CPUs" added to char-misc-next
To:     suzuki.poulose@arm.com, anshuman.khandual@arm.com,
        branislav.rankov@arm.com, leo.yan@linaro.org,
        mathieu.poirier@linaro.org, mike.leach@linaro.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 31 Oct 2021 08:24:51 +0100
Message-ID: <163566509024168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    coresight: trbe: Defer the probe on offline CPUs

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From a08025b3fe56185290a1ea476581f03ca733f967 Mon Sep 17 00:00:00 2001
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Date: Thu, 14 Oct 2021 15:22:38 +0100
Subject: coresight: trbe: Defer the probe on offline CPUs

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
---
 drivers/hwtracing/coresight/coresight-trbe.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
index 2825ccb0cf39..5d77baba8b0f 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -893,6 +893,10 @@ static void arm_trbe_register_coresight_cpu(struct trbe_drvdata *drvdata, int cp
 	if (WARN_ON(trbe_csdev))
 		return;
 
+	/* If the TRBE was not probed on the CPU, we shouldn't be here */
+	if (WARN_ON(!cpudata->drvdata))
+		return;
+
 	dev = &cpudata->drvdata->pdev->dev;
 	desc.name = devm_kasprintf(dev, GFP_KERNEL, "trbe%d", cpu);
 	if (!desc.name)
@@ -974,7 +978,9 @@ static int arm_trbe_probe_coresight(struct trbe_drvdata *drvdata)
 		return -ENOMEM;
 
 	for_each_cpu(cpu, &drvdata->supported_cpus) {
-		smp_call_function_single(cpu, arm_trbe_probe_cpu, drvdata, 1);
+		/* If we fail to probe the CPU, let us defer it to hotplug callbacks */
+		if (smp_call_function_single(cpu, arm_trbe_probe_cpu, drvdata, 1))
+			continue;
 		if (cpumask_test_cpu(cpu, &drvdata->supported_cpus))
 			arm_trbe_register_coresight_cpu(drvdata, cpu);
 		if (cpumask_test_cpu(cpu, &drvdata->supported_cpus))
-- 
2.33.1



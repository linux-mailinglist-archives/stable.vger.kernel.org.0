Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBC766C4B9
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbjAPP5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjAPP5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:57:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6EB2195A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:57:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7969E61031
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C517C433D2;
        Mon, 16 Jan 2023 15:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884646;
        bh=7S7sPXus9ya8WM6wu3x/h7oGMZkWi720jOhNxYYUaa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pfCEvwR5E0SCmyKjtMJNqrDlffCivEQP9s8gXZvRCJCXwgRST1LH1040E6FAywVp5
         JUgLGupPqvT3lE8Se6CqTxuBXEUSkCiVlilupu+k6blPehOslbX0xAepJuzpFBx9+X
         WWNdbDIQ4/Rtyjyh8RiGLuqI5Vwg06GsptnQWNv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 086/183] iommu/arm-smmu: Dont unregister on shutdown
Date:   Mon, 16 Jan 2023 16:50:09 +0100
Message-Id: <20230116154807.051527046@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit ce31e6ca68bd7639bd3e5ef97be215031842bbab upstream.

Michael Walle says he noticed the following stack trace while performing
a shutdown with "reboot -f". He suggests he got "lucky" and just hit the
correct spot for the reboot while there was a packet transmission in
flight.

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000098
CPU: 0 PID: 23 Comm: kworker/0:1 Not tainted 6.1.0-rc5-00088-gf3600ff8e322 #1930
Hardware name: Kontron KBox A-230-LS (DT)
pc : iommu_get_dma_domain+0x14/0x20
lr : iommu_dma_map_page+0x9c/0x254
Call trace:
 iommu_get_dma_domain+0x14/0x20
 dma_map_page_attrs+0x1ec/0x250
 enetc_start_xmit+0x14c/0x10b0
 enetc_xmit+0x60/0xdc
 dev_hard_start_xmit+0xb8/0x210
 sch_direct_xmit+0x11c/0x420
 __dev_queue_xmit+0x354/0xb20
 ip6_finish_output2+0x280/0x5b0
 __ip6_finish_output+0x15c/0x270
 ip6_output+0x78/0x15c
 NF_HOOK.constprop.0+0x50/0xd0
 mld_sendpack+0x1bc/0x320
 mld_ifc_work+0x1d8/0x4dc
 process_one_work+0x1e8/0x460
 worker_thread+0x178/0x534
 kthread+0xe0/0xe4
 ret_from_fork+0x10/0x20
Code: d503201f f9416800 d503233f d50323bf (f9404c00)
---[ end trace 0000000000000000 ]---
Kernel panic - not syncing: Oops: Fatal exception in interrupt

This appears to be reproducible when the board has a fixed IP address,
is ping flooded from another host, and "reboot -f" is used.

The following is one more manifestation of the issue:

$ reboot -f
kvm: exiting hardware virtualization
cfg80211: failed to load regulatory.db
arm-smmu 5000000.iommu: disabling translation
sdhci-esdhc 2140000.mmc: Removing from iommu group 11
sdhci-esdhc 2150000.mmc: Removing from iommu group 12
fsl-edma 22c0000.dma-controller: Removing from iommu group 17
dwc3 3100000.usb: Removing from iommu group 9
dwc3 3110000.usb: Removing from iommu group 10
ahci-qoriq 3200000.sata: Removing from iommu group 2
fsl-qdma 8380000.dma-controller: Removing from iommu group 20
platform f080000.display: Removing from iommu group 0
etnaviv-gpu f0c0000.gpu: Removing from iommu group 1
etnaviv etnaviv: Removing from iommu group 1
caam_jr 8010000.jr: Removing from iommu group 13
caam_jr 8020000.jr: Removing from iommu group 14
caam_jr 8030000.jr: Removing from iommu group 15
caam_jr 8040000.jr: Removing from iommu group 16
fsl_enetc 0000:00:00.0: Removing from iommu group 4
arm-smmu 5000000.iommu: Blocked unknown Stream ID 0x429; boot with "arm-smmu.disable_bypass=0" to allow, but this may have security implications
arm-smmu 5000000.iommu:         GFSR 0x80000002, GFSYNR0 0x00000002, GFSYNR1 0x00000429, GFSYNR2 0x00000000
fsl_enetc 0000:00:00.1: Removing from iommu group 5
arm-smmu 5000000.iommu: Blocked unknown Stream ID 0x429; boot with "arm-smmu.disable_bypass=0" to allow, but this may have security implications
arm-smmu 5000000.iommu:         GFSR 0x80000002, GFSYNR0 0x00000002, GFSYNR1 0x00000429, GFSYNR2 0x00000000
arm-smmu 5000000.iommu: Blocked unknown Stream ID 0x429; boot with "arm-smmu.disable_bypass=0" to allow, but this may have security implications
arm-smmu 5000000.iommu:         GFSR 0x80000002, GFSYNR0 0x00000000, GFSYNR1 0x00000429, GFSYNR2 0x00000000
fsl_enetc 0000:00:00.2: Removing from iommu group 6
fsl_enetc_mdio 0000:00:00.3: Removing from iommu group 8
mscc_felix 0000:00:00.5: Removing from iommu group 3
fsl_enetc 0000:00:00.6: Removing from iommu group 7
pcieport 0001:00:00.0: Removing from iommu group 18
arm-smmu 5000000.iommu: Blocked unknown Stream ID 0x429; boot with "arm-smmu.disable_bypass=0" to allow, but this may have security implications
arm-smmu 5000000.iommu:         GFSR 0x00000002, GFSYNR0 0x00000000, GFSYNR1 0x00000429, GFSYNR2 0x00000000
pcieport 0002:00:00.0: Removing from iommu group 19
Unable to handle kernel NULL pointer dereference at virtual address 00000000000000a8
pc : iommu_get_dma_domain+0x14/0x20
lr : iommu_dma_unmap_page+0x38/0xe0
Call trace:
 iommu_get_dma_domain+0x14/0x20
 dma_unmap_page_attrs+0x38/0x1d0
 enetc_unmap_tx_buff.isra.0+0x6c/0x80
 enetc_poll+0x170/0x910
 __napi_poll+0x40/0x1e0
 net_rx_action+0x164/0x37c
 __do_softirq+0x128/0x368
 run_ksoftirqd+0x68/0x90
 smpboot_thread_fn+0x14c/0x190
Code: d503201f f9416800 d503233f d50323bf (f9405400)
---[ end trace 0000000000000000 ]---
Kernel panic - not syncing: Oops: Fatal exception in interrupt
---[ end Kernel panic - not syncing: Oops: Fatal exception in interrupt ]---

The problem seems to be that iommu_group_remove_device() is allowed to
run with no coordination whatsoever with the shutdown procedure of the
enetc PCI device. In fact, it almost seems as if it implies that the
pci_driver :: shutdown() method is mandatory if DMA is used with an
IOMMU, otherwise this is inevitable. That was never the case; shutdown
methods are optional in device drivers.

This is the call stack that leads to iommu_group_remove_device() during
reboot:

kernel_restart
-> device_shutdown
   -> platform_shutdown
      -> arm_smmu_device_shutdown
         -> arm_smmu_device_remove
            -> iommu_device_unregister
               -> bus_for_each_dev
                  -> remove_iommu_group
                     -> iommu_release_device
                        -> iommu_group_remove_device

I don't know much about the arm_smmu driver, but
arm_smmu_device_shutdown() invoking arm_smmu_device_remove() looks
suspicious, since it causes the IOMMU device to unregister and that's
where everything starts to unravel. It forces all other devices which
depend on IOMMU groups to also point their ->shutdown() to ->remove(),
which will make reboot slower overall.

There are 2 moments relevant to this behavior. First was commit
b06c076ea962 ("Revert "iommu/arm-smmu: Make arm-smmu explicitly
non-modular"") when arm_smmu_device_shutdown() was made to run the exact
same thing as arm_smmu_device_remove(). Prior to that, there was no
iommu_device_unregister() call in arm_smmu_device_shutdown(). However,
that was benign until commit 57365a04c921 ("iommu: Move bus setup to
IOMMU device registration"), which made iommu_device_unregister() call
remove_iommu_group().

Restore the old shutdown behavior by making remove() call shutdown(),
but shutdown() does not call the remove() specific bits.

Fixes: 57365a04c921 ("iommu: Move bus setup to IOMMU device registration")
Reported-by: Michael Walle <michael@walle.cc>
Tested-by: Michael Walle <michael@walle.cc> # on kontron-sl28
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20221215141251.3688780-1-vladimir.oltean@nxp.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -2188,19 +2188,16 @@ static int arm_smmu_device_probe(struct
 	return 0;
 }
 
-static int arm_smmu_device_remove(struct platform_device *pdev)
+static void arm_smmu_device_shutdown(struct platform_device *pdev)
 {
 	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
 
 	if (!smmu)
-		return -ENODEV;
+		return;
 
 	if (!bitmap_empty(smmu->context_map, ARM_SMMU_MAX_CBS))
 		dev_notice(&pdev->dev, "disabling translation\n");
 
-	iommu_device_unregister(&smmu->iommu);
-	iommu_device_sysfs_remove(&smmu->iommu);
-
 	arm_smmu_rpm_get(smmu);
 	/* Turn the thing off */
 	arm_smmu_gr0_write(smmu, ARM_SMMU_GR0_sCR0, ARM_SMMU_sCR0_CLIENTPD);
@@ -2212,12 +2209,21 @@ static int arm_smmu_device_remove(struct
 		clk_bulk_disable(smmu->num_clks, smmu->clks);
 
 	clk_bulk_unprepare(smmu->num_clks, smmu->clks);
-	return 0;
 }
 
-static void arm_smmu_device_shutdown(struct platform_device *pdev)
+static int arm_smmu_device_remove(struct platform_device *pdev)
 {
-	arm_smmu_device_remove(pdev);
+	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
+
+	if (!smmu)
+		return -ENODEV;
+
+	iommu_device_unregister(&smmu->iommu);
+	iommu_device_sysfs_remove(&smmu->iommu);
+
+	arm_smmu_device_shutdown(pdev);
+
+	return 0;
 }
 
 static int __maybe_unused arm_smmu_runtime_resume(struct device *dev)



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDD52558E
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 18:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfEUQ2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 12:28:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8228 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728273AbfEUQ2V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 12:28:21 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3B87D98008AC68E1E6B5;
        Wed, 22 May 2019 00:28:19 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Wed, 22 May 2019 00:27:16 +0800
From:   John Garry <john.garry@huawei.com>
To:     <stable@vger.kernel.org>
CC:     <robin.murphy@arm.com>, <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH stable 4.20 - 5.1] driver core: Postpone DMA tear-down until after devres release for probe failure
Date:   Wed, 22 May 2019 00:26:22 +0800
Message-ID: <1558455982-17806-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 0b777eee88d712256ba8232a9429edb17c4f9ceb upstream

In commit 376991db4b64 ("driver core: Postpone DMA tear-down until after
devres release"), we changed the ordering of tearing down the device DMA
ops and releasing all the device's resources; this was because the DMA ops
should be maintained until we release the device's managed DMA memories.

However, we have seen another crash on an arm64 system when a
device driver probe fails:

  hisi_sas_v3_hw 0000:74:02.0: Adding to iommu group 2
  scsi host1: hisi_sas_v3_hw
  BUG: Bad page state in process swapper/0  pfn:313f5
  page:ffff7e0000c4fd40 count:1 mapcount:0
  mapping:0000000000000000 index:0x0
  flags: 0xfffe00000001000(reserved)
  raw: 0fffe00000001000 ffff7e0000c4fd48 ffff7e0000c4fd48
0000000000000000
  raw: 0000000000000000 0000000000000000 00000001ffffffff
0000000000000000
  page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
  bad because of flags: 0x1000(reserved)
  Modules linked in:
  CPU: 49 PID: 1 Comm: swapper/0 Not tainted
5.1.0-rc1-43081-g22d97fd-dirty #1433
  Hardware name: Huawei D06/D06, BIOS Hisilicon D06 UEFI
RC0 - V1.12.01 01/29/2019
  Call trace:
  dump_backtrace+0x0/0x118
  show_stack+0x14/0x1c
  dump_stack+0xa4/0xc8
  bad_page+0xe4/0x13c
  free_pages_check_bad+0x4c/0xc0
  __free_pages_ok+0x30c/0x340
  __free_pages+0x30/0x44
  __dma_direct_free_pages+0x30/0x38
  dma_direct_free+0x24/0x38
  dma_free_attrs+0x9c/0xd8
  dmam_release+0x20/0x28
  release_nodes+0x17c/0x220
  devres_release_all+0x34/0x54
  really_probe+0xc4/0x2c8
  driver_probe_device+0x58/0xfc
  device_driver_attach+0x68/0x70
  __driver_attach+0x94/0xdc
  bus_for_each_dev+0x5c/0xb4
  driver_attach+0x20/0x28
  bus_add_driver+0x14c/0x200
  driver_register+0x6c/0x124
  __pci_register_driver+0x48/0x50
  sas_v3_pci_driver_init+0x20/0x28
  do_one_initcall+0x40/0x25c
  kernel_init_freeable+0x2b8/0x3c0
  kernel_init+0x10/0x100
  ret_from_fork+0x10/0x18
  Disabling lock debugging due to kernel taint
  BUG: Bad page state in process swapper/0  pfn:313f6
  page:ffff7e0000c4fd80 count:1 mapcount:0
mapping:0000000000000000 index:0x0
[   89.322983] flags: 0xfffe00000001000(reserved)
  raw: 0fffe00000001000 ffff7e0000c4fd88 ffff7e0000c4fd88
0000000000000000
  raw: 0000000000000000 0000000000000000 00000001ffffffff
0000000000000000

The crash occurs for the same reason.

In this case, on the really_probe() failure path, we are still clearing
the DMA ops prior to releasing the device's managed memories.

This patch fixes this issue by reordering the DMA ops teardown and the
call to devres_release_all() on the failure path.

Reported-by: Xiang Chen <chenxiang66@hisilicon.com>
Tested-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Cc: stable <stable@vger.kernel.org> # 4.20.x - 5.1.x
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index b4ee11d6e665..b55d372e9aba 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -483,7 +483,7 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	if (dev->bus->dma_configure) {
 		ret = dev->bus->dma_configure(dev);
 		if (ret)
-			goto dma_failed;
+			goto probe_failed;
 	}
 
 	if (driver_sysfs_add(dev)) {
@@ -539,14 +539,13 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	goto done;
 
 probe_failed:
-	arch_teardown_dma_ops(dev);
-dma_failed:
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_DRIVER_NOT_BOUND, dev);
 pinctrl_bind_failed:
 	device_links_no_driver(dev);
 	devres_release_all(dev);
+	arch_teardown_dma_ops(dev);
 	driver_sysfs_remove(dev);
 	dev->driver = NULL;
 	dev_set_drvdata(dev, NULL);
-- 
2.17.1


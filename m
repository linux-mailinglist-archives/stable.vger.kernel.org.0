Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACAE28864
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391191AbfEWTZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391186AbfEWTZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:25:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F54B206BA;
        Thu, 23 May 2019 19:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639548;
        bh=fwmeCfDZ20HDTpbecOgdPky9OzvqrTm3C4iBp/oF8U0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wU5eYge96YX57JYSpoLyal4Sz2LMtUPI0wkxemf/eiZ6RGyPSwsaOjb3ubUSrs0sS
         RwYeTiVsAxobU+j5TWxsru5YW4rxrYh4rhlss5yz1k0Y8Hnl6j4OztAj4mw48MAV3q
         chZzQDweCl6vdzoG+GvPO5kPnn7zqa95W+4atyi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 5.0 136/139] driver core: Postpone DMA tear-down until after devres release for probe failure
Date:   Thu, 23 May 2019 21:07:04 +0200
Message-Id: <20190523181736.566787237@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

commit 0b777eee88d712256ba8232a9429edb17c4f9ceb upstream.

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
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/dd.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -486,7 +486,7 @@ re_probe:
 	if (dev->bus->dma_configure) {
 		ret = dev->bus->dma_configure(dev);
 		if (ret)
-			goto dma_failed;
+			goto probe_failed;
 	}
 
 	if (driver_sysfs_add(dev)) {
@@ -542,14 +542,13 @@ re_probe:
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



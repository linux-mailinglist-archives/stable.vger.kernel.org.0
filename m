Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9864BF2B5
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 08:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiBVHlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 02:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiBVHlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 02:41:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD89D127D78
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 23:40:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BBBA3CE12FE
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 07:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C636C340E8;
        Tue, 22 Feb 2022 07:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645515641;
        bh=F72nzu5AzJZV8tlqf9nIForjQFMgox8nj7lTK2/X2oE=;
        h=Subject:To:From:Date:From;
        b=AUJOAWHGuFliMqUUTY6V/23M2GGANknlumH+8zUBLbMorwggsi4VX3VcGLA9j5kEY
         a2DKbaRVDFAjEMTqAXlqwAk+IzZZyjYLmXHgyEHohr/ifWp87f8x3RU7Aq8MSA+LIN
         krTH53mZMZOfSh3KSHvLKYELtGpRikbo3oumk088=
Subject: patch "driver core: Free DMA range map when device is released" added to driver-core-linus
To:     marten.lindahl@axis.com, gregkh@linuxfoundation.org,
        robh@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 22 Feb 2022 08:40:38 +0100
Message-ID: <164551563877162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    driver core: Free DMA range map when device is released

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d8f7a5484f2188e9af2d9e4e587587d724501b12 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>
Date: Wed, 16 Feb 2022 10:41:28 +0100
Subject: driver core: Free DMA range map when device is released
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When unbinding/binding a driver with DMA mapped memory, the DMA map is
not freed before the driver is reloaded. This leads to a memory leak
when the DMA map is overwritten when reprobing the driver.

This can be reproduced with a platform driver having a dma-range:

dummy {
	...
	#address-cells = <0x2>;
	#size-cells = <0x2>;
	ranges;
	dma-ranges = <...>;
	...
};

and then unbinding/binding it:

~# echo soc:dummy >/sys/bus/platform/drivers/<driver>/unbind

DMA map object 0xffffff800b0ae540 still being held by &pdev->dev

~# echo soc:dummy >/sys/bus/platform/drivers/<driver>/bind
~# echo scan > /sys/kernel/debug/kmemleak
~# cat /sys/kernel/debug/kmemleak
unreferenced object 0xffffff800b0ae540 (size 64):
  comm "sh", pid 833, jiffies 4295174550 (age 2535.352s)
  hex dump (first 32 bytes):
    00 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 80 00 00 00 00 00 00 00 80 00 00 00 00  ................
  backtrace:
    [<ffffffefd1694708>] create_object.isra.0+0x108/0x344
    [<ffffffefd1d1a850>] kmemleak_alloc+0x8c/0xd0
    [<ffffffefd167e2d0>] __kmalloc+0x440/0x6f0
    [<ffffffefd1a960a4>] of_dma_get_range+0x124/0x220
    [<ffffffefd1a8ce90>] of_dma_configure_id+0x40/0x2d0
    [<ffffffefd198b68c>] platform_dma_configure+0x5c/0xa4
    [<ffffffefd198846c>] really_probe+0x8c/0x514
    [<ffffffefd1988990>] __driver_probe_device+0x9c/0x19c
    [<ffffffefd1988cd8>] device_driver_attach+0x54/0xbc
    [<ffffffefd1986634>] bind_store+0xc4/0x120
    [<ffffffefd19856e0>] drv_attr_store+0x30/0x44
    [<ffffffefd173c9b0>] sysfs_kf_write+0x50/0x60
    [<ffffffefd173c1c4>] kernfs_fop_write_iter+0x124/0x1b4
    [<ffffffefd16a013c>] new_sync_write+0xdc/0x160
    [<ffffffefd16a256c>] vfs_write+0x23c/0x2a0
    [<ffffffefd16a2758>] ksys_write+0x64/0xec

To prevent this we should free the dma_range_map when the device is
released.

Fixes: e0d072782c73 ("dma-mapping: introduce DMA range map, supplanting dma_pfn_offset")
Cc: stable <stable@vger.kernel.org>
Suggested-by: Rob Herring <robh@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Mårten Lindahl <marten.lindahl@axis.com>
Link: https://lore.kernel.org/r/20220216094128.4025861-1-marten.lindahl@axis.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 9eaaff2f556c..f47cab21430f 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -629,6 +629,9 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 			drv->remove(dev);
 
 		devres_release_all(dev);
+		arch_teardown_dma_ops(dev);
+		kfree(dev->dma_range_map);
+		dev->dma_range_map = NULL;
 		driver_sysfs_remove(dev);
 		dev->driver = NULL;
 		dev_set_drvdata(dev, NULL);
@@ -1209,6 +1212,8 @@ static void __device_release_driver(struct device *dev, struct device *parent)
 
 		devres_release_all(dev);
 		arch_teardown_dma_ops(dev);
+		kfree(dev->dma_range_map);
+		dev->dma_range_map = NULL;
 		dev->driver = NULL;
 		dev_set_drvdata(dev, NULL);
 		if (dev->pm_domain && dev->pm_domain->dismiss)
-- 
2.35.1



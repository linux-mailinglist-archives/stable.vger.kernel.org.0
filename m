Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CA84C7477
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236405AbiB1RpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238962AbiB1Rnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:43:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDCB954B2;
        Mon, 28 Feb 2022 09:35:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 95D3DCE17C5;
        Mon, 28 Feb 2022 17:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708A1C340E7;
        Mon, 28 Feb 2022 17:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069724;
        bh=75MWno/6iwHpcgT6nktESUZAi0xeKcfnKzoYK9SOqBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCe8JC2ODNt86LPWDueHWVnyGulgUj8rcrEIS+K/VOXXiZ6IxBL1LAK3dzR0WHvMj
         aGZ4I3FbDsvlMUghZj8Pk00+aVKF4C4uV5n9IORdgNFPyq0sSriQg96rJSzhHkwO+q
         ZVqbr8lTHeB6brTDElwAkl17geb+B+OBBGD2ksqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        =?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>
Subject: [PATCH 5.10 70/80] driver core: Free DMA range map when device is released
Date:   Mon, 28 Feb 2022 18:24:51 +0100
Message-Id: <20220228172320.196970358@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mårten Lindahl <marten.lindahl@axis.com>

commit d8f7a5484f2188e9af2d9e4e587587d724501b12 upstream.

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
 drivers/base/dd.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -592,6 +592,9 @@ re_probe:
 			drv->remove(dev);
 
 		devres_release_all(dev);
+		arch_teardown_dma_ops(dev);
+		kfree(dev->dma_range_map);
+		dev->dma_range_map = NULL;
 		driver_sysfs_remove(dev);
 		dev->driver = NULL;
 		dev_set_drvdata(dev, NULL);
@@ -1168,6 +1171,8 @@ static void __device_release_driver(stru
 
 		devres_release_all(dev);
 		arch_teardown_dma_ops(dev);
+		kfree(dev->dma_range_map);
+		dev->dma_range_map = NULL;
 		dev->driver = NULL;
 		dev_set_drvdata(dev, NULL);
 		if (dev->pm_domain && dev->pm_domain->dismiss)



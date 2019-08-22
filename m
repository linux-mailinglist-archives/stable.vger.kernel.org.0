Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB93099ADD
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389489AbfHVRQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390335AbfHVRId (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:33 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53FC1233FD;
        Thu, 22 Aug 2019 17:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493712;
        bh=3w3ZFvZEBkLnWfqd124DPOwoElsTvGZnk1/aoxdS6YA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cIJFlNyRhLaJxVAPo69mlq7z32w9bdvfQoh4rtXIwwAyGqHqcN2wYv81sBaT2tvSu
         gEU80+zxjkJnbV4Vo9KOeqCYbzozqVtYOTmW0SlW5DbHC9+8jVxjhEG02zrLiaRPm8
         Q3iVSNnQL7y5r5PIz5TSV63N3KrU5lIG0mzm/4OY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <festevam@gmail.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 034/135] Revert "i2c: imx: improve the error handling in i2c_imx_dma_request()"
Date:   Thu, 22 Aug 2019 13:06:30 -0400
Message-Id: <20190822170811.13303-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit e8c220fac415d9f4a994b0c2871b835feac1eb4e upstream.

Since commit e1ab9a468e3b ("i2c: imx: improve the error handling in
i2c_imx_dma_request()") when booting with the DMA driver as module (such
as CONFIG_FSL_EDMA=m) the following endless clk warnings are seen:

[  153.077831] ------------[ cut here ]------------
[  153.082528] WARNING: CPU: 0 PID: 15 at drivers/clk/clk.c:924 clk_core_disable_lock+0x18/0x24
[  153.093077] i2c0 already disabled
[  153.096416] Modules linked in:
[  153.099521] CPU: 0 PID: 15 Comm: kworker/0:1 Tainted: G        W         5.2.0+ #321
[  153.107290] Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
[  153.113772] Workqueue: events deferred_probe_work_func
[  153.118979] [<c0019560>] (unwind_backtrace) from [<c0014734>] (show_stack+0x10/0x14)
[  153.126778] [<c0014734>] (show_stack) from [<c083f8dc>] (dump_stack+0x9c/0xd4)
[  153.134051] [<c083f8dc>] (dump_stack) from [<c0031154>] (__warn+0xf8/0x124)
[  153.141056] [<c0031154>] (__warn) from [<c0031248>] (warn_slowpath_fmt+0x38/0x48)
[  153.148580] [<c0031248>] (warn_slowpath_fmt) from [<c040fde0>] (clk_core_disable_lock+0x18/0x24)
[  153.157413] [<c040fde0>] (clk_core_disable_lock) from [<c058f520>] (i2c_imx_probe+0x554/0x6ec)
[  153.166076] [<c058f520>] (i2c_imx_probe) from [<c04b9178>] (platform_drv_probe+0x48/0x98)
[  153.174297] [<c04b9178>] (platform_drv_probe) from [<c04b7298>] (really_probe+0x1d8/0x2c0)
[  153.182605] [<c04b7298>] (really_probe) from [<c04b7554>] (driver_probe_device+0x5c/0x174)
[  153.190909] [<c04b7554>] (driver_probe_device) from [<c04b58c8>] (bus_for_each_drv+0x44/0x8c)
[  153.199480] [<c04b58c8>] (bus_for_each_drv) from [<c04b746c>] (__device_attach+0xa0/0x108)
[  153.207782] [<c04b746c>] (__device_attach) from [<c04b65a4>] (bus_probe_device+0x88/0x90)
[  153.215999] [<c04b65a4>] (bus_probe_device) from [<c04b6a04>] (deferred_probe_work_func+0x60/0x90)
[  153.225003] [<c04b6a04>] (deferred_probe_work_func) from [<c004f190>] (process_one_work+0x204/0x634)
[  153.234178] [<c004f190>] (process_one_work) from [<c004f618>] (worker_thread+0x20/0x484)
[  153.242315] [<c004f618>] (worker_thread) from [<c0055c2c>] (kthread+0x118/0x150)
[  153.249758] [<c0055c2c>] (kthread) from [<c00090b4>] (ret_from_fork+0x14/0x20)
[  153.257006] Exception stack(0xdde43fb0 to 0xdde43ff8)
[  153.262095] 3fa0:                                     00000000 00000000 00000000 00000000
[  153.270306] 3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  153.278520] 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  153.285159] irq event stamp: 3323022
[  153.288787] hardirqs last  enabled at (3323021): [<c0861c4c>] _raw_spin_unlock_irq+0x24/0x2c
[  153.297261] hardirqs last disabled at (3323022): [<c040d7a0>] clk_enable_lock+0x10/0x124
[  153.305392] softirqs last  enabled at (3322092): [<c000a504>] __do_softirq+0x344/0x540
[  153.313352] softirqs last disabled at (3322081): [<c00385c0>] irq_exit+0x10c/0x128
[  153.320946] ---[ end trace a506731ccd9bd703 ]---

This endless clk warnings behaviour is well explained by Andrey Smirnov:

"Allocating DMA after registering I2C adapter can lead to infinite
probing loop, for example, consider the following scenario:

    1. i2c_imx_probe() is called and successfully registers an I2C
       adapter via i2c_add_numbered_adapter()

    2. As a part of i2c_add_numbered_adapter() new I2C slave devices
       are added from DT which results in a call to
       driver_deferred_probe_trigger()

    3. i2c_imx_probe() continues and calls i2c_imx_dma_request() which
       due to lack of proper DMA driver returns -EPROBE_DEFER

    4. i2c_imx_probe() fails, removes I2C adapter and returns
       -EPROBE_DEFER, which places it into deferred probe list

    5. Deferred probe work triggered in #2 above kicks in and calls
       i2c_imx_probe() again thus bringing us to step #1"

So revert commit e1ab9a468e3b ("i2c: imx: improve the error handling in
i2c_imx_dma_request()") and restore the old behaviour, in order to
avoid regressions on existing setups.

Cc: <stable@vger.kernel.org>
Reported-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Reported-by: Russell King <linux@armlinux.org.uk>
Fixes: e1ab9a468e3b ("i2c: imx: improve the error handling in i2c_imx_dma_request()")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index fd70b110e8f4e..87564010ddbe6 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -273,8 +273,8 @@ static inline unsigned char imx_i2c_read_reg(struct imx_i2c_struct *i2c_imx,
 }
 
 /* Functions for DMA support */
-static int i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx,
-			       dma_addr_t phy_addr)
+static void i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx,
+						dma_addr_t phy_addr)
 {
 	struct imx_i2c_dma *dma;
 	struct dma_slave_config dma_sconfig;
@@ -283,7 +283,7 @@ static int i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx,
 
 	dma = devm_kzalloc(dev, sizeof(*dma), GFP_KERNEL);
 	if (!dma)
-		return -ENOMEM;
+		return;
 
 	dma->chan_tx = dma_request_chan(dev, "tx");
 	if (IS_ERR(dma->chan_tx)) {
@@ -328,7 +328,7 @@ static int i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx,
 	dev_info(dev, "using %s (tx) and %s (rx) for DMA transfers\n",
 		dma_chan_name(dma->chan_tx), dma_chan_name(dma->chan_rx));
 
-	return 0;
+	return;
 
 fail_rx:
 	dma_release_channel(dma->chan_rx);
@@ -336,8 +336,6 @@ static int i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx,
 	dma_release_channel(dma->chan_tx);
 fail_al:
 	devm_kfree(dev, dma);
-	/* return successfully if there is no dma support */
-	return ret == -ENODEV ? 0 : ret;
 }
 
 static void i2c_imx_dma_callback(void *arg)
@@ -1165,17 +1163,13 @@ static int i2c_imx_probe(struct platform_device *pdev)
 	dev_dbg(&i2c_imx->adapter.dev, "device resources: %pR\n", res);
 	dev_dbg(&i2c_imx->adapter.dev, "adapter name: \"%s\"\n",
 		i2c_imx->adapter.name);
+	dev_info(&i2c_imx->adapter.dev, "IMX I2C adapter registered\n");
 
 	/* Init DMA config if supported */
-	ret = i2c_imx_dma_request(i2c_imx, phy_addr);
-	if (ret < 0)
-		goto del_adapter;
+	i2c_imx_dma_request(i2c_imx, phy_addr);
 
-	dev_info(&i2c_imx->adapter.dev, "IMX I2C adapter registered\n");
 	return 0;   /* Return OK */
 
-del_adapter:
-	i2c_del_adapter(&i2c_imx->adapter);
 clk_notifier_unregister:
 	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
 rpm_disable:
-- 
2.20.1


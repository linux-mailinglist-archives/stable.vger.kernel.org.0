Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60F04ABD24
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349981AbiBGLjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386178AbiBGLdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:33:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9803C043181;
        Mon,  7 Feb 2022 03:33:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8484CB80EBD;
        Mon,  7 Feb 2022 11:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04032C004E1;
        Mon,  7 Feb 2022 11:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233628;
        bh=o1t4E6p5M9wQ+MHWk250rjIPmobh5t6vtkwJdpEGO38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oo82QG5XgnEcm6ioYhn6Z9qClGtujVqmQs0JIAq1mlxD2JS1UG5jCLA+2uiRgim5l
         TlkOQBUu11Cnz6svqUtOCH4jCeOJgK03UX/7gojPTUscI9NbfElznOH0lDjhEeVkqV
         u+Ne7iCNCkppRUkmFAkQ8kGQd7qGprYA+14uakAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jisheng Zhang <jszhang@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 072/126] net: stmmac: properly handle with runtime pm in stmmac_dvr_remove()
Date:   Mon,  7 Feb 2022 12:06:43 +0100
Message-Id: <20220207103806.598653654@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jisheng Zhang <jszhang@kernel.org>

commit 6449520391dfc3d2cef134f11a91251a054ff7d0 upstream.

There are two issues with runtime pm handling in stmmac_dvr_remove():

1. the mac is runtime suspended before stopping dma and rx/tx. We
need to ensure the device is properly resumed back.

2. the stmmaceth clk enable/disable isn't balanced in both exit and
error handling code path. Take the exit code path for example, when we
unbind the driver or rmmod the driver module, the mac is runtime
suspended as said above, so the stmmaceth clk is disabled, but
	stmmac_dvr_remove()
	  stmmac_remove_config_dt()
	    clk_disable_unprepare()
CCF will complain this time. The error handling code path suffers
from the similar situtaion.

Here are kernel warnings in error handling code path on Allwinner D1
platform:

[    1.604695] ------------[ cut here ]------------
[    1.609328] bus-emac already disabled
[    1.613015] WARNING: CPU: 0 PID: 38 at drivers/clk/clk.c:952 clk_core_disable+0xcc/0xec
[    1.621039] CPU: 0 PID: 38 Comm: kworker/u2:1 Not tainted 5.14.0-rc4#1
[    1.627653] Hardware name: Allwinner D1 NeZha (DT)
[    1.632443] Workqueue: events_unbound deferred_probe_work_func
[    1.638286] epc : clk_core_disable+0xcc/0xec
[    1.642561]  ra : clk_core_disable+0xcc/0xec
[    1.646835] epc : ffffffff8023c2ec ra : ffffffff8023c2ec sp : ffffffd00411bb10
[    1.654054]  gp : ffffffff80ec9988 tp : ffffffe00143a800 t0 : ffffffff80ed6a6f
[    1.661272]  t1 : ffffffff80ed6a60 t2 : 0000000000000000 s0 : ffffffe001509e00
[    1.668489]  s1 : 0000000000000001 a0 : 0000000000000019 a1 : ffffffff80e80bd8
[    1.675707]  a2 : 00000000ffffefff a3 : 00000000000000f4 a4 : 0000000000000002
[    1.682924]  a5 : 0000000000000001 a6 : 0000000000000030 a7 : 00000000028f5c29
[    1.690141]  s2 : 0000000000000800 s3 : ffffffe001375000 s4 : ffffffe01fdf7a80
[    1.697358]  s5 : ffffffe001375010 s6 : ffffffff8001fc10 s7 : ffffffffffffffff
[    1.704577]  s8 : 0000000000000001 s9 : ffffffff80ecb248 s10: ffffffe001b80000
[    1.711794]  s11: ffffffe001b80760 t3 : 0000000000000062 t4 : ffffffffffffffff
[    1.719012]  t5 : ffffffff80e0f6d8 t6 : ffffffd00411b8f0
[    1.724321] status: 8000000201800100 badaddr: 0000000000000000 cause: 0000000000000003
[    1.732233] [<ffffffff8023c2ec>] clk_core_disable+0xcc/0xec
[    1.737810] [<ffffffff80240430>] clk_disable+0x38/0x78
[    1.742956] [<ffffffff8001fc0c>] worker_thread+0x1a8/0x4d8
[    1.748451] [<ffffffff8031a500>] stmmac_remove_config_dt+0x1c/0x4c
[    1.754646] [<ffffffff8031c8ec>] sun8i_dwmac_probe+0x378/0x82c
[    1.760484] [<ffffffff8001fc0c>] worker_thread+0x1a8/0x4d8
[    1.765975] [<ffffffff8029a6c8>] platform_probe+0x64/0xf0
[    1.771382] [<ffffffff8029833c>] really_probe.part.0+0x8c/0x30c
[    1.777305] [<ffffffff8029865c>] __driver_probe_device+0xa0/0x148
[    1.783402] [<ffffffff8029873c>] driver_probe_device+0x38/0x138
[    1.789324] [<ffffffff802989cc>] __device_attach_driver+0xd0/0x170
[    1.795508] [<ffffffff802988f8>] __driver_attach_async_helper+0xbc/0xc0
[    1.802125] [<ffffffff802965ac>] bus_for_each_drv+0x68/0xb4
[    1.807701] [<ffffffff80298d1c>] __device_attach+0xd8/0x184
[    1.813277] [<ffffffff802967b0>] bus_probe_device+0x98/0xbc
[    1.818852] [<ffffffff80297904>] deferred_probe_work_func+0x90/0xd4
[    1.825122] [<ffffffff8001f8b8>] process_one_work+0x1e4/0x390
[    1.830872] [<ffffffff8001fd80>] worker_thread+0x31c/0x4d8
[    1.836362] [<ffffffff80026bf4>] kthreadd+0x94/0x188
[    1.841335] [<ffffffff80026bf4>] kthreadd+0x94/0x188
[    1.846304] [<ffffffff8001fa60>] process_one_work+0x38c/0x390
[    1.852054] [<ffffffff80026564>] kthread+0x124/0x160
[    1.857021] [<ffffffff8002643c>] set_kthread_struct+0x5c/0x60
[    1.862770] [<ffffffff80001f08>] ret_from_syscall_rejected+0x8/0xc
[    1.868956] ---[ end trace 8d5c6046255f84a0 ]---
[    1.873675] ------------[ cut here ]------------
[    1.878366] bus-emac already unprepared
[    1.882378] WARNING: CPU: 0 PID: 38 at drivers/clk/clk.c:810 clk_core_unprepare+0xe4/0x168
[    1.890673] CPU: 0 PID: 38 Comm: kworker/u2:1 Tainted: G        W	5.14.0-rc4 #1
[    1.898674] Hardware name: Allwinner D1 NeZha (DT)
[    1.903464] Workqueue: events_unbound deferred_probe_work_func
[    1.909305] epc : clk_core_unprepare+0xe4/0x168
[    1.913840]  ra : clk_core_unprepare+0xe4/0x168
[    1.918375] epc : ffffffff8023d6cc ra : ffffffff8023d6cc sp : ffffffd00411bb10
[    1.925593]  gp : ffffffff80ec9988 tp : ffffffe00143a800 t0 : 0000000000000002
[    1.932811]  t1 : ffffffe01f743be0 t2 : 0000000000000040 s0 : ffffffe001509e00
[    1.940029]  s1 : 0000000000000001 a0 : 000000000000001b a1 : ffffffe00143a800
[    1.947246]  a2 : 0000000000000000 a3 : 00000000000000f4 a4 : 0000000000000001
[    1.954463]  a5 : 0000000000000000 a6 : 0000000005fce2a5 a7 : 0000000000000001
[    1.961680]  s2 : 0000000000000800 s3 : ffffffff80afeb90 s4 : ffffffe01fdf7a80
[    1.968898]  s5 : ffffffe001375010 s6 : ffffffff8001fc10 s7 : ffffffffffffffff
[    1.976115]  s8 : 0000000000000001 s9 : ffffffff80ecb248 s10: ffffffe001b80000
[    1.983333]  s11: ffffffe001b80760 t3 : ffffffff80b39120 t4 : 0000000000000001
[    1.990550]  t5 : 0000000000000000 t6 : ffffffe001600002
[    1.995859] status: 8000000201800120 badaddr: 0000000000000000 cause: 0000000000000003
[    2.003771] [<ffffffff8023d6cc>] clk_core_unprepare+0xe4/0x168
[    2.009609] [<ffffffff802403a0>] clk_unprepare+0x24/0x3c
[    2.014929] [<ffffffff8031a508>] stmmac_remove_config_dt+0x24/0x4c
[    2.021125] [<ffffffff8031c8ec>] sun8i_dwmac_probe+0x378/0x82c
[    2.026965] [<ffffffff8001fc0c>] worker_thread+0x1a8/0x4d8
[    2.032463] [<ffffffff8029a6c8>] platform_probe+0x64/0xf0
[    2.037871] [<ffffffff8029833c>] really_probe.part.0+0x8c/0x30c
[    2.043795] [<ffffffff8029865c>] __driver_probe_device+0xa0/0x148
[    2.049892] [<ffffffff8029873c>] driver_probe_device+0x38/0x138
[    2.055815] [<ffffffff802989cc>] __device_attach_driver+0xd0/0x170
[    2.061999] [<ffffffff802988f8>] __driver_attach_async_helper+0xbc/0xc0
[    2.068616] [<ffffffff802965ac>] bus_for_each_drv+0x68/0xb4
[    2.074193] [<ffffffff80298d1c>] __device_attach+0xd8/0x184
[    2.079769] [<ffffffff802967b0>] bus_probe_device+0x98/0xbc
[    2.085345] [<ffffffff80297904>] deferred_probe_work_func+0x90/0xd4
[    2.091616] [<ffffffff8001f8b8>] process_one_work+0x1e4/0x390
[    2.097367] [<ffffffff8001fd80>] worker_thread+0x31c/0x4d8
[    2.102858] [<ffffffff80026bf4>] kthreadd+0x94/0x188
[    2.107830] [<ffffffff80026bf4>] kthreadd+0x94/0x188
[    2.112800] [<ffffffff8001fa60>] process_one_work+0x38c/0x390
[    2.118551] [<ffffffff80026564>] kthread+0x124/0x160
[    2.123520] [<ffffffff8002643c>] set_kthread_struct+0x5c/0x60
[    2.129268] [<ffffffff80001f08>] ret_from_syscall_rejected+0x8/0xc
[    2.135455] ---[ end trace 8d5c6046255f84a1 ]---

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7137,6 +7137,10 @@ int stmmac_dvr_remove(struct device *dev
 
 	netdev_info(priv->dev, "%s: removing driver", __func__);
 
+	pm_runtime_get_sync(dev);
+	pm_runtime_disable(dev);
+	pm_runtime_put_noidle(dev);
+
 	stmmac_stop_all_dma(priv);
 	stmmac_mac_set(priv, priv->ioaddr, false);
 	netif_carrier_off(ndev);
@@ -7155,8 +7159,6 @@ int stmmac_dvr_remove(struct device *dev
 	if (priv->plat->stmmac_rst)
 		reset_control_assert(priv->plat->stmmac_rst);
 	reset_control_assert(priv->plat->stmmac_ahb_rst);
-	pm_runtime_put(dev);
-	pm_runtime_disable(dev);
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
 		stmmac_mdio_unregister(ndev);



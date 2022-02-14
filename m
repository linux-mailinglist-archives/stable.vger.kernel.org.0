Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E2F4B4B5A
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346497AbiBNKVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:21:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346753AbiBNKUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:20:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057137C7B5;
        Mon, 14 Feb 2022 01:55:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60DC0B80DC8;
        Mon, 14 Feb 2022 09:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A595C340E9;
        Mon, 14 Feb 2022 09:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832511;
        bh=QtDiWEcSmKNrDcBtsN8v0rSVjLkbZyrSSGtXPtH3eQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/tJqyLrQstZ2+t9nh8v4B6QqmBW3YzvvVhP6WGX7inzyt5/6CJwY4eHn4CoYtWYH
         1BxXsReS6VNgn+ES7TkuUC2+klRl0P5un8MC8umBRfxfmhNiHJkyB5woRpuSD2hsAR
         7HqqVVA4qcuLj6oCJkWBc67S03+daPCGtShuEMnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Padmanabha Srinivasaiah <treasure4paddy@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 036/203] drm/vc4: Fix deadlock on DSI device attach error
Date:   Mon, 14 Feb 2022 10:24:40 +0100
Message-Id: <20220214092511.434199460@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Padmanabha Srinivasaiah <treasure4paddy@gmail.com>

[ Upstream commit 0a3d12ab5097b1d045e693412e6b366b7e82031b ]

DSI device attach to DSI host will be done with host device's lock
held.

Un-registering host in "device attach" error path (ex: probe retry)
will result in deadlock with below call trace and non operational
DSI display.

Startup Call trace:
[   35.043036]  rt_mutex_slowlock.constprop.21+0x184/0x1b8
[   35.043048]  mutex_lock_nested+0x7c/0xc8
[   35.043060]  device_del+0x4c/0x3e8
[   35.043075]  device_unregister+0x20/0x40
[   35.043082]  mipi_dsi_remove_device_fn+0x18/0x28
[   35.043093]  device_for_each_child+0x68/0xb0
[   35.043105]  mipi_dsi_host_unregister+0x40/0x90
[   35.043115]  vc4_dsi_host_attach+0xf0/0x120 [vc4]
[   35.043199]  mipi_dsi_attach+0x30/0x48
[   35.043209]  tc358762_probe+0x128/0x164 [tc358762]
[   35.043225]  mipi_dsi_drv_probe+0x28/0x38
[   35.043234]  really_probe+0xc0/0x318
[   35.043244]  __driver_probe_device+0x80/0xe8
[   35.043254]  driver_probe_device+0xb8/0x118
[   35.043263]  __device_attach_driver+0x98/0xe8
[   35.043273]  bus_for_each_drv+0x84/0xd8
[   35.043281]  __device_attach+0xf0/0x150
[   35.043290]  device_initial_probe+0x1c/0x28
[   35.043300]  bus_probe_device+0xa4/0xb0
[   35.043308]  deferred_probe_work_func+0xa0/0xe0
[   35.043318]  process_one_work+0x254/0x700
[   35.043330]  worker_thread+0x4c/0x448
[   35.043339]  kthread+0x19c/0x1a8
[   35.043348]  ret_from_fork+0x10/0x20

Shutdown Call trace:
[  365.565417] Call trace:
[  365.565423]  __switch_to+0x148/0x200
[  365.565452]  __schedule+0x340/0x9c8
[  365.565467]  schedule+0x48/0x110
[  365.565479]  schedule_timeout+0x3b0/0x448
[  365.565496]  wait_for_completion+0xac/0x138
[  365.565509]  __flush_work+0x218/0x4e0
[  365.565523]  flush_work+0x1c/0x28
[  365.565536]  wait_for_device_probe+0x68/0x158
[  365.565550]  device_shutdown+0x24/0x348
[  365.565561]  kernel_restart_prepare+0x40/0x50
[  365.565578]  kernel_restart+0x20/0x70
[  365.565591]  __do_sys_reboot+0x10c/0x220
[  365.565605]  __arm64_sys_reboot+0x2c/0x38
[  365.565619]  invoke_syscall+0x4c/0x110
[  365.565634]  el0_svc_common.constprop.3+0xfc/0x120
[  365.565648]  do_el0_svc+0x2c/0x90
[  365.565661]  el0_svc+0x4c/0xf0
[  365.565671]  el0t_64_sync_handler+0x90/0xb8
[  365.565682]  el0t_64_sync+0x180/0x184

Signed-off-by: Padmanabha Srinivasaiah <treasure4paddy@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220118005127.29015-1-treasure4paddy@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_dsi.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_dsi.c b/drivers/gpu/drm/vc4/vc4_dsi.c
index a229da58962a2..9300d3354c512 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -1262,7 +1262,6 @@ static int vc4_dsi_host_attach(struct mipi_dsi_host *host,
 			       struct mipi_dsi_device *device)
 {
 	struct vc4_dsi *dsi = host_to_dsi(host);
-	int ret;
 
 	dsi->lanes = device->lanes;
 	dsi->channel = device->channel;
@@ -1297,18 +1296,15 @@ static int vc4_dsi_host_attach(struct mipi_dsi_host *host,
 		return 0;
 	}
 
-	ret = component_add(&dsi->pdev->dev, &vc4_dsi_ops);
-	if (ret) {
-		mipi_dsi_host_unregister(&dsi->dsi_host);
-		return ret;
-	}
-
-	return 0;
+	return component_add(&dsi->pdev->dev, &vc4_dsi_ops);
 }
 
 static int vc4_dsi_host_detach(struct mipi_dsi_host *host,
 			       struct mipi_dsi_device *device)
 {
+	struct vc4_dsi *dsi = host_to_dsi(host);
+
+	component_del(&dsi->pdev->dev, &vc4_dsi_ops);
 	return 0;
 }
 
@@ -1686,9 +1682,7 @@ static int vc4_dsi_dev_remove(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct vc4_dsi *dsi = dev_get_drvdata(dev);
 
-	component_del(&pdev->dev, &vc4_dsi_ops);
 	mipi_dsi_host_unregister(&dsi->dsi_host);
-
 	return 0;
 }
 
-- 
2.34.1




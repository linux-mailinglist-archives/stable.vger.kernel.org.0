Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB826B4998
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbjCJPOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbjCJPNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:13:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763C7126F3C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:05:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA14DB822F5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6C5C4339B;
        Fri, 10 Mar 2023 14:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459931;
        bh=lSMvMQpOZh+Dms/qGfSfgrP6eWp/HXSmoKGu35dTz5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ie34rwzctoSZKqnUFPlGr4l58BNXqICYtrQhzJWiDkkI1/tu0f1T53I1Zs3HfbMwY
         W8r2O373yDF6smVIFmi9n1lAEc8dVY5cYKc+PyQKg0HXk+wYgCjWO1I7baq3LyCDlE
         4R4wHAYt61ABdR9PIygN5ehGndVSsnDfvENL/f0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akhil P Oommen <quic_akhilpo@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/529] drm/msm/adreno: Fix null ptr access in adreno_gpu_cleanup()
Date:   Fri, 10 Mar 2023 14:35:10 +0100
Message-Id: <20230310133812.683845095@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akhil P Oommen <quic_akhilpo@quicinc.com>

[ Upstream commit dbeedbcb268d055d8895aceca427f897e12c2b50 ]

Fix the below kernel panic due to null pointer access:
[   18.504431] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000048
[   18.513464] Mem abort info:
[   18.516346]   ESR = 0x0000000096000005
[   18.520204]   EC = 0x25: DABT (current EL), IL = 32 bits
[   18.525706]   SET = 0, FnV = 0
[   18.528878]   EA = 0, S1PTW = 0
[   18.532117]   FSC = 0x05: level 1 translation fault
[   18.537138] Data abort info:
[   18.540110]   ISV = 0, ISS = 0x00000005
[   18.544060]   CM = 0, WnR = 0
[   18.547109] user pgtable: 4k pages, 39-bit VAs, pgdp=0000000112826000
[   18.553738] [0000000000000048] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000
[   18.562690] Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP
**Snip**
[   18.696758] Call trace:
[   18.699278]  adreno_gpu_cleanup+0x30/0x88
[   18.703396]  a6xx_destroy+0xc0/0x130
[   18.707066]  a6xx_gpu_init+0x308/0x424
[   18.710921]  adreno_bind+0x178/0x288
[   18.714590]  component_bind_all+0xe0/0x214
[   18.718797]  msm_drm_bind+0x1d4/0x614
[   18.722566]  try_to_bring_up_aggregate_device+0x16c/0x1b8
[   18.728105]  __component_add+0xa0/0x158
[   18.732048]  component_add+0x20/0x2c
[   18.735719]  adreno_probe+0x40/0xc0
[   18.739300]  platform_probe+0xb4/0xd4
[   18.743068]  really_probe+0xfc/0x284
[   18.746738]  __driver_probe_device+0xc0/0xec
[   18.751129]  driver_probe_device+0x48/0x110
[   18.755421]  __device_attach_driver+0xa8/0xd0
[   18.759900]  bus_for_each_drv+0x90/0xdc
[   18.763843]  __device_attach+0xfc/0x174
[   18.767786]  device_initial_probe+0x20/0x2c
[   18.772090]  bus_probe_device+0x40/0xa0
[   18.776032]  deferred_probe_work_func+0x94/0xd0
[   18.780686]  process_one_work+0x190/0x3d0
[   18.784805]  worker_thread+0x280/0x3d4
[   18.788659]  kthread+0x104/0x1c0
[   18.791981]  ret_from_fork+0x10/0x20
[   18.795654] Code: f9400408 aa0003f3 aa1f03f4 91142015 (f9402516)
[   18.801913] ---[ end trace 0000000000000000 ]---
[   18.809039] Kernel panic - not syncing: Oops: Fatal exception

Fixes: 17e822f7591f ("drm/msm: fix unbalanced pm_runtime_enable in adreno_gpu_{init, cleanup}")
Signed-off-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/515605/
Link: https://lore.kernel.org/r/20221221203925.v2.1.Ib978de92c4bd000b515486aad72e96c2481f84d0@changeid
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index de8cc25506d61..78181e2d78a97 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -954,13 +954,13 @@ int adreno_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 void adreno_gpu_cleanup(struct adreno_gpu *adreno_gpu)
 {
 	struct msm_gpu *gpu = &adreno_gpu->base;
-	struct msm_drm_private *priv = gpu->dev->dev_private;
+	struct msm_drm_private *priv = gpu->dev ? gpu->dev->dev_private : NULL;
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(adreno_gpu->info->fw); i++)
 		release_firmware(adreno_gpu->fw[i]);
 
-	if (pm_runtime_enabled(&priv->gpu_pdev->dev))
+	if (priv && pm_runtime_enabled(&priv->gpu_pdev->dev))
 		pm_runtime_disable(&priv->gpu_pdev->dev);
 
 	msm_gpu_cleanup(&adreno_gpu->base);
-- 
2.39.2




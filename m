Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E566AEA29
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbjCGRbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbjCGRa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:30:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1A9A677B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:26:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 351C9614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F06C4339B;
        Tue,  7 Mar 2023 17:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209976;
        bh=bl52fF4H+JBKZcTWLCy1RLWVNgd0uVSnYQI6iT4N4hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMsjiglrs+4xPIfGqMnDnrQcb+9Qj5M2vAWW3q8xH2KqKBBW+zebVy9+gB9G5vDPr
         TfD1eZSVsEhSE19NAdnZOwkt1tv5zs6RHKpL83Qisg0KCkm8z+9CEzPBZZ1MO476sp
         6gobaG6Fa6ySV6WSoDKEKSINjzf+RYsBco6BKGR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akhil P Oommen <quic_akhilpo@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0361/1001] drm/msm/adreno: Fix null ptr access in adreno_gpu_cleanup()
Date:   Tue,  7 Mar 2023 17:52:13 +0100
Message-Id: <20230307170037.082392138@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 3605f095b2de2..8175997663299 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -1083,13 +1083,13 @@ int adreno_gpu_init(struct drm_device *drm, struct platform_device *pdev,
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




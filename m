Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC49D55C2DA
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbiF0LXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234631AbiF0LXg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:23:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481026577;
        Mon, 27 Jun 2022 04:23:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1F14B8111B;
        Mon, 27 Jun 2022 11:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FE3C3411D;
        Mon, 27 Jun 2022 11:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329012;
        bh=qzetOW1Jp66JS63g4ewuXcBAqW1P3SoXZXzoRSZ5kJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCuhoNIycXjHkW2U99oQbxgKD15p9qM/aaEezXWNXQobVFEhTjN12X9HpDaShdVVs
         l8dNy0guc1WCBonccpYaGFWaDBknKFupWe/ExCzYh/0b2SbNWvwFFIvwmp/aOWd+jE
         638kMcKbs2D4kNZI9sOyfyT5M1l6w++n63Ube1ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/102] drm/msm: Fix double pm_runtime_disable() call
Date:   Mon, 27 Jun 2022 13:20:32 +0200
Message-Id: <20220627111934.093577662@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
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

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit ce0db505bc0c51ef5e9ba446c660de7e26f78f29 ]

Following commit 17e822f7591f ("drm/msm: fix unbalanced
pm_runtime_enable in adreno_gpu_{init, cleanup}"), any call to
adreno_unbind() will disable runtime PM twice, as indicated by the call
trees below:

  adreno_unbind()
   -> pm_runtime_force_suspend()
   -> pm_runtime_disable()

  adreno_unbind()
   -> gpu->funcs->destroy() [= aNxx_destroy()]
   -> adreno_gpu_cleanup()
   -> pm_runtime_disable()

Note that pm_runtime_force_suspend() is called right before
gpu->funcs->destroy() and both functions are called unconditionally.

With recent addition of the eDP AUX bus code, this problem manifests
itself when the eDP panel cannot be found yet and probing is deferred.
On the first probe attempt, we disable runtime PM twice as described
above. This then causes any later probe attempt to fail with

  [drm:adreno_load_gpu [msm]] *ERROR* Couldn't power up the GPU: -13

preventing the driver from loading.

As there seem to be scenarios where the aNxx_destroy() functions are not
called from adreno_unbind(), simply removing pm_runtime_disable() from
inside adreno_unbind() does not seem to be the proper fix. This is what
commit 17e822f7591f ("drm/msm: fix unbalanced pm_runtime_enable in
adreno_gpu_{init, cleanup}") intended to fix. Therefore, instead check
whether runtime PM is still enabled, and only disable it in that case.

Fixes: 17e822f7591f ("drm/msm: fix unbalanced pm_runtime_enable in adreno_gpu_{init, cleanup}")
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Link: https://lore.kernel.org/r/20220606211305.189585-1-luzmaximilian@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 458b5b26d3c2..de8cc25506d6 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -960,7 +960,8 @@ void adreno_gpu_cleanup(struct adreno_gpu *adreno_gpu)
 	for (i = 0; i < ARRAY_SIZE(adreno_gpu->info->fw); i++)
 		release_firmware(adreno_gpu->fw[i]);
 
-	pm_runtime_disable(&priv->gpu_pdev->dev);
+	if (pm_runtime_enabled(&priv->gpu_pdev->dev))
+		pm_runtime_disable(&priv->gpu_pdev->dev);
 
 	msm_gpu_cleanup(&adreno_gpu->base);
 
-- 
2.35.1




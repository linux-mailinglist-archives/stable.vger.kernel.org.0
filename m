Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622F16ABAF5
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 11:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjCFKJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 05:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjCFKJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 05:09:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41CB22001;
        Mon,  6 Mar 2023 02:09:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42D0E60DC1;
        Mon,  6 Mar 2023 10:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A49C433A1;
        Mon,  6 Mar 2023 10:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678097358;
        bh=oHtOiiLls+D/brpZp/GfYW0LOJJAvdIWo6VBajIFJFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWY4vLrWgV44TRuLq2J4Mfxnhm4vWWeRrePKjiND/BjJ8pjdbtFYWkdbOY6u28fXF
         5xSUDav0bMngErNyVJQ+EUR/6z0MUMlsJza97tywfH2jjIl4DMMQo/kKC0COBlsvzr
         n48eO7snFlpxYT9QcvifF2L3xPa2krIgZfprVnQSVoKfU2YRz8L4BVCR/SEy8YN/iq
         MCi98skpVAP2AJR4oj1k9b4zqai4ho+ID6Q2Ph0+411m7N2u2ESgJFKoMKkCO52Gcp
         wHJb6uzimOIeRgVzRn/ZJEt/p/e7CzZtjzu0i4QHtw++GBWcPYCWnb+XPp+Oj6z1gI
         LYvQOqHte8c6A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pZ7n5-0007Qf-71; Mon, 06 Mar 2023 11:09:59 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Rob Clark <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Sean Paul <sean@poorly.run>, David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 03/10] drm/msm: fix NULL-deref on snapshot tear down
Date:   Mon,  6 Mar 2023 11:07:15 +0100
Message-Id: <20230306100722.28485-4-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230306100722.28485-1-johan+linaro@kernel.org>
References: <20230306100722.28485-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In case of early initialisation errors and on platforms that do not use
the DPU controller, the deinitilisation code can be called with the kms
pointer set to NULL.

Fixes: 98659487b845 ("drm/msm: add support to take dpu snapshot")
Cc: stable@vger.kernel.org      # 5.14
Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 9ded384acba4..17a59d73fe01 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -242,7 +242,8 @@ static int msm_drm_uninit(struct device *dev)
 		msm_fbdev_free(ddev);
 #endif
 
-	msm_disp_snapshot_destroy(ddev);
+	if (kms)
+		msm_disp_snapshot_destroy(ddev);
 
 	drm_mode_config_cleanup(ddev);
 
-- 
2.39.2


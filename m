Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A67D5B5D72
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 17:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiILPl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 11:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiILPl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 11:41:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811F2387;
        Mon, 12 Sep 2022 08:41:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24BEA61255;
        Mon, 12 Sep 2022 15:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C72C4347C;
        Mon, 12 Sep 2022 15:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662997286;
        bh=Q+bfFqjYpYH8FLx0wDO8gWAsRaCXfRayuVMg8azBXGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Za3sazuEvM92RtTsY538WlS+mfRdLOvYX9RyzhnwsAXvTz7XN1H6miDFoiegEBIJU
         V7tZWti+3bCBjczUbC4Rg2UofCZv/qjq8F4+2L5Ij4Y8e3fLmnSMQ7E7a7o/pAt2z/
         aari64ZgyABmQKrV+5lSonZmhQgsoXRt5KYKCwkZ1bqW8LjBTX/Jbp6W36yBw8UgVH
         e3l7qmnR0gZmYEEK9I42vshA7aB0AVWhEUGTIoapr/Oc7AcvjMktZJb7wdSjpS5FSZ
         8PQL+FhWiVfjmb4vE69nvlHNic83Nj21b7VtxMwAb5GPg7AE53bATQGPRpZx0JFHeB
         2VzqBxzmmf+xw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1oXlYp-0003Ms-Bi; Mon, 12 Sep 2022 17:41:23 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Douglas Anderson <dianders@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@gmail.com>
Cc:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Sean Paul <sean@poorly.run>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 3/7] drm/msm/dp: fix IRQ lifetime
Date:   Mon, 12 Sep 2022 17:40:42 +0200
Message-Id: <20220912154046.12900-4-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912154046.12900-1-johan+linaro@kernel.org>
References: <20220912154046.12900-1-johan+linaro@kernel.org>
MIME-Version: 1.0
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

Device-managed resources allocated post component bind must be tied to
the lifetime of the aggregate DRM device or they will not necessarily be
released when binding of the aggregate device is deferred.

This is specifically true for the DP IRQ, which will otherwise remain
requested so that the next bind attempt fails when requesting the IRQ a
second time.

Since commit c3bf8e21b38a ("drm/msm/dp: Add eDP support via aux_bus")
this can happen when the aux-bus panel driver has not yet been loaded so
that probe is deferred.

Fix this by tying the device-managed lifetime of the DP IRQ to the DRM
device so that it is released when bind fails.

Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
Cc: stable@vger.kernel.org      # 5.10
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index fbe950edaefe..ba557328710a 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -1258,7 +1258,7 @@ int dp_display_request_irq(struct msm_dp *dp_display)
 		return -EINVAL;
 	}
 
-	rc = devm_request_irq(&dp->pdev->dev, dp->irq,
+	rc = devm_request_irq(dp_display->drm_dev->dev, dp->irq,
 			dp_display_irq_handler,
 			IRQF_TRIGGER_HIGH, "dp_display_isr", dp);
 	if (rc < 0) {
-- 
2.35.1


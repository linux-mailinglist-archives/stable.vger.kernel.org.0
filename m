Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033A35B5D82
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 17:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiILPld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 11:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiILPla (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 11:41:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906402BB0A;
        Mon, 12 Sep 2022 08:41:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B596B80DC5;
        Mon, 12 Sep 2022 15:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD99FC433B5;
        Mon, 12 Sep 2022 15:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662997286;
        bh=ALSz/B3OueKx+xZxACNFavtF4u1RlQ9F0qOMVhGzjfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUwdM4ufVB2zUMRE9GHgTO1hq77E/4lJ6JjDt/l3vi91cV1Hyl7n8G2eTTBFiJ8dH
         J5XfPSM2XNTzsqA9dOo8Ia2+KClBREr8/KBFJO9eGzfz2wHJj6DV+Dw/NNlKIdDeB0
         31/jPacD68161L8dw1zp0zrsr1dUW5bpkhFGPURWnGfTK4jVSJfy6IEvnthlIRuwVx
         Fsvf6zDf1Uy57b/IXS4bN9C3vPioIoIGj+kN76xEI2PW28wQZk7MWwfdFTAIDlfqjK
         44HM19zvCfV9JLqNlelDqO8oJ9Hs0zlqgWbyDOMQF2tdfkv6Zldin+PjptyO+Ix51J
         eRVESEgMqqlFw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1oXlYp-0003My-Kp; Mon, 12 Sep 2022 17:41:23 +0200
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
Subject: [PATCH 6/7] drm/msm/hdmi: fix IRQ lifetime
Date:   Mon, 12 Sep 2022 17:40:45 +0200
Message-Id: <20220912154046.12900-7-johan+linaro@kernel.org>
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

This is specifically true for the HDMI IRQ, which will otherwise remain
requested so that the next bind attempt fails when requesting the IRQ a
second time.

Fix this by tying the device-managed lifetime of the HDMI IRQ to the DRM
device so that it is released when bind fails.

Fixes: 067fef372c73 ("drm/msm/hdmi: refactor bind/init")
Cc: stable@vger.kernel.org      # 3.19
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index a0ed6aa8e4e1..f28fb21e3891 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -344,7 +344,7 @@ int msm_hdmi_modeset_init(struct hdmi *hdmi,
 		goto fail;
 	}
 
-	ret = devm_request_irq(&pdev->dev, hdmi->irq,
+	ret = devm_request_irq(dev->dev, hdmi->irq,
 			msm_hdmi_irq, IRQF_TRIGGER_HIGH,
 			"hdmi_isr", hdmi);
 	if (ret < 0) {
-- 
2.35.1


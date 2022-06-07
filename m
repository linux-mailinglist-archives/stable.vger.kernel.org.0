Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE63540603
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245174AbiFGRcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347298AbiFGRaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082EF110462;
        Tue,  7 Jun 2022 10:26:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89C6860DE0;
        Tue,  7 Jun 2022 17:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACDCC385A5;
        Tue,  7 Jun 2022 17:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622774;
        bh=R0+ycyeuUKrA8o8i3EmIVl88MqRtSro7Ii1+ymFkPwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ur4DCzGzopsFlOtV5hpbXCz+TW2AZ7ifhCV5zZ1rPG8WDboS3t0pNWaP2iWwDk8+H
         DreVOcLNpSIVBkk/F7iWPeT2YKAIC0otQ3w8+8UvWvVcnkGWAjZ4Nf/nqKX+IB/3Pb
         Q28/JRNrzF+cfGr0EEtTaVfi5EOCeo0A6Lgp9Elk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Lv Ruyi <lv.ruyi@zte.com.cn>,
        Stephen Boyd <swboyd@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/452] drm/msm/hdmi: fix error check return value of irq_of_parse_and_map()
Date:   Tue,  7 Jun 2022 19:00:35 +0200
Message-Id: <20220607164913.865269532@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit 03371e4fbdeb7f596cbceacb59e474248b6d95ac ]

The irq_of_parse_and_map() function returns 0 on failure, and does not
return a negative value anyhow, so never enter this conditional branch.

Fixes: f6a8eaca0ea1 ("drm/msm/mdp5: use irqdomains")
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/483294/
Link: https://lore.kernel.org/r/20220425091831.3500487-1-lv.ruyi@zte.com.cn
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index 2758b51aa4e0..28b33b35a30c 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -315,9 +315,9 @@ int msm_hdmi_modeset_init(struct hdmi *hdmi,
 	}
 
 	hdmi->irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
-	if (hdmi->irq < 0) {
-		ret = hdmi->irq;
-		DRM_DEV_ERROR(dev->dev, "failed to get irq: %d\n", ret);
+	if (!hdmi->irq) {
+		ret = -EINVAL;
+		DRM_DEV_ERROR(dev->dev, "failed to get irq\n");
 		goto fail;
 	}
 
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3815541A99
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376390AbiFGVgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380526AbiFGVf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:35:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DAA170661;
        Tue,  7 Jun 2022 12:04:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 027F261277;
        Tue,  7 Jun 2022 19:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1251EC385A2;
        Tue,  7 Jun 2022 19:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628678;
        bh=Ztqhd0TbowCC03CC7VBugIukC/iEmK/9YAQ1b5xz4RU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMDkRzx2T3r8lnStIXydvygSKbKcyw2TFJ+3Cm291cFri9mKkjj417DsFlx0Wwu9p
         RamVP2Dp7JY88qdhwy27mUdZmWEqr7UzzedEncHCPUEknQYa/z9B/bj3wcYSAYcR8S
         EgGFM1PrbPRPIodAyfMyV6V0b1+Gm7xanSga3kMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Lv Ruyi <lv.ruyi@zte.com.cn>,
        Stephen Boyd <swboyd@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 375/879] drm/msm/hdmi: fix error check return value of irq_of_parse_and_map()
Date:   Tue,  7 Jun 2022 18:58:13 +0200
Message-Id: <20220607165013.755957146@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 07e2ad527af9..f6229262dcb0 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -302,9 +302,9 @@ int msm_hdmi_modeset_init(struct hdmi *hdmi,
 	drm_connector_attach_encoder(hdmi->connector, hdmi->encoder);
 
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




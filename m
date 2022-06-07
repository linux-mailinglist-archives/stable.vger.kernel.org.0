Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1CDF540631
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346833AbiFGRdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347245AbiFGRaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BBB10F353;
        Tue,  7 Jun 2022 10:26:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3036B822B1;
        Tue,  7 Jun 2022 17:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601BFC385A5;
        Tue,  7 Jun 2022 17:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622765;
        bh=GWRc+kAFAjOPErKv+G7Iow1IuvazDj6DgnxCEKcmZ9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hbNauST3jz1RH1mFHE7cLi7WN7xPDofV2fabkKCrGak1y0fc+54NzYhEU5J5pGEIQ
         gldpyWsgrIrA5y7atmaLqnXcxZLXcn3uYmS2Wi63l+Q1N/9GJ0j19YFo6HXD+Tb8nJ
         8xgWXj3XCff18i1grZYdQrEtsZf4usI2CrKoGv4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Lv Ruyi <lv.ruyi@zte.com.cn>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/452] drm/msm/dp: fix error check return value of irq_of_parse_and_map()
Date:   Tue,  7 Jun 2022 19:00:32 +0200
Message-Id: <20220607164913.776149475@linuxfoundation.org>
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

[ Upstream commit e92d0d93f86699b7b25c7906613fdc374d66c8ca ]

The irq_of_parse_and_map() function returns 0 on failure, and does not
return an negative value.

Fixes: 8ede2ecc3e5e ("drm/msm/dp: Add DP compliance tests on Snapdragon Chipsets")
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/483176/
Link: https://lore.kernel.org/r/20220424032418.3173632-1-lv.ruyi@zte.com.cn
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 36caf3d5a9f9..09c8e50da68d 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -1147,10 +1147,9 @@ int dp_display_request_irq(struct msm_dp *dp_display)
 	dp = container_of(dp_display, struct dp_display_private, dp_display);
 
 	dp->irq = irq_of_parse_and_map(dp->pdev->dev.of_node, 0);
-	if (dp->irq < 0) {
-		rc = dp->irq;
-		DRM_ERROR("failed to get irq: %d\n", rc);
-		return rc;
+	if (!dp->irq) {
+		DRM_ERROR("failed to get irq\n");
+		return -EINVAL;
 	}
 
 	rc = devm_request_irq(&dp->pdev->dev, dp->irq,
-- 
2.35.1




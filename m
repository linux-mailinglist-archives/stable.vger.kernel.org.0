Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43ED548B01
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348075AbiFMK4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350120AbiFMKym (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:54:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD7ADFF1;
        Mon, 13 Jun 2022 03:29:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 024A9B80E95;
        Mon, 13 Jun 2022 10:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6FDC34114;
        Mon, 13 Jun 2022 10:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116162;
        bh=k9u9j8aY1zKKEsAw274pxYRcOYeWowMXMlTUdX+0YAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UIWGjvyxEOiKpA4dT7tpFKg4zEP5ZwwZOpXNpYlgGjKZIQwAniGlCs7EBvE4B4NeN
         0XDASlfS+boapZmKteDeD6yxt5jNi9y1MlQBnPeZ9s9ESFfn3yc68nT1/wvWwuyNfF
         gAskch8TILkIS8/Ik8szmL4lhxFIwoPlTs0zT6NU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Lv Ruyi <lv.ruyi@zte.com.cn>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/411] drm: msm: fix error check return value of irq_of_parse_and_map()
Date:   Mon, 13 Jun 2022 12:05:08 +0200
Message-Id: <20220613094929.557760411@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

[ Upstream commit b9e4f1d2b505df8e2439b63e67afaa287c1c43e2 ]

The irq_of_parse_and_map() function returns 0 on failure, and does not
return an negative value.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/483175/
Link: https://lore.kernel.org/r/20220424031959.3172406-1-lv.ruyi@zte.com.cn
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
index 77823ccdd0f8..39d0082eedcc 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
@@ -698,9 +698,9 @@ struct msm_kms *mdp5_kms_init(struct drm_device *dev)
 	pdev = mdp5_kms->pdev;
 
 	irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
-	if (irq < 0) {
-		ret = irq;
-		DRM_DEV_ERROR(&pdev->dev, "failed to get irq: %d\n", ret);
+	if (!irq) {
+		ret = -EINVAL;
+		DRM_DEV_ERROR(&pdev->dev, "failed to get irq\n");
 		goto fail;
 	}
 
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4828B537C2F
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237195AbiE3Nbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237486AbiE3Na4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:30:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A30587A37;
        Mon, 30 May 2022 06:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CE5AB80D84;
        Mon, 30 May 2022 13:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3218FC385B8;
        Mon, 30 May 2022 13:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917247;
        bh=dMH/huRRqAdoiUb0Rl7RxxXYfjvxgvx+UaGWVg1/P4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H2bPr5GGIwESpH86icOZLx1s4YgU/0/L/hZxnwwycC31y4wQNps/MRog5x9tNyRXN
         VRQgw2237BjA4MO9TQfmroVF8kTQzG9CciALAfcApwF8Wxb9duNclw54fXOeLOP1lD
         lzDpQiS0L4hklBbxRVP+yvP49jOsDv6Ice8RFwbKmZyZzDbS/AxljMfgdCa25eUO4L
         sseaC5Ns+LAF/3MW1MAUkh4/OcDkrhY0yToGK9TIgg0CbGYZqmjUNErUrikG/3Buj9
         wmUrCl/qh9LSt+BhSWMVylLcP49d1PVmUBp696nxY/ZUuwLYehy3G0VW92Q/eIe+Rr
         eAEPzcQ5ln6KQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        quic_abhinavk@quicinc.com, airlied@linux.ie, daniel@ffwll.ch,
        swboyd@chromium.org, angelogioacchino.delregno@collabora.com,
        vulab@iscas.ac.cn, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 070/159] drm: msm: fix error check return value of irq_of_parse_and_map()
Date:   Mon, 30 May 2022 09:22:55 -0400
Message-Id: <20220530132425.1929512-70-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 3b92372e7bdf..1d4bbde29320 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
@@ -570,9 +570,9 @@ struct msm_kms *mdp5_kms_init(struct drm_device *dev)
 	}
 
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


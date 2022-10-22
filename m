Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E84D608787
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiJVIDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiJVIBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:01:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6ACC290681;
        Sat, 22 Oct 2022 00:50:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10F22B82E28;
        Sat, 22 Oct 2022 07:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D313C433D6;
        Sat, 22 Oct 2022 07:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425020;
        bh=iHwbAIKGTFm2iePSccsgJpuXwAdrLKOvAqCJRJ1QZhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWfHPER+swwzta6BPhIQ8QD4RYTKmGeYQl/Mpe9dUHk1lRENvtH/3rBwj/dsp504E
         8NKQcQy9gXegJj0BYXrMSu2UhGpUEz31M5yZAg4eolf0wI2tC/QxoD7J+QH/vJiaGJ
         0WzirN9IHjHCbRrZn9Uh7xzx3kEeMMkUFaj4BhpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 332/717] drm/msm/dp: correct 1.62G link rate at dp_catalog_ctrl_config_msa()
Date:   Sat, 22 Oct 2022 09:23:31 +0200
Message-Id: <20221022072509.689881431@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

[ Upstream commit aa0bff10af1c4b92e6b56e3e1b7f81c660d3ba78 ]

At current implementation there is an extra 0 at 1.62G link rate which
cause no correct pixel_div selected for 1.62G link rate to calculate
mvid and nvid. This patch delete the extra 0 to have mvid and nvid be
calculated correctly.

Changes in v2:
-- fix Fixes tag's text

Changes in v3:
-- fix misspelling of "Reviewed-by"

Fixes: 937f941ca06f  ("drm/msm/dp: Use qmp phy for DP PLL and PHY")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/499328/
Link: https://lore.kernel.org/r/1661372150-3764-1-git-send-email-quic_khsieh@quicinc.com
[DB: rewrapped commit message]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_catalog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_catalog.c b/drivers/gpu/drm/msm/dp/dp_catalog.c
index 7257515871a9..676279d0ca8d 100644
--- a/drivers/gpu/drm/msm/dp/dp_catalog.c
+++ b/drivers/gpu/drm/msm/dp/dp_catalog.c
@@ -431,7 +431,7 @@ void dp_catalog_ctrl_config_msa(struct dp_catalog *dp_catalog,
 
 	if (rate == link_rate_hbr3)
 		pixel_div = 6;
-	else if (rate == 1620000 || rate == 270000)
+	else if (rate == 162000 || rate == 270000)
 		pixel_div = 2;
 	else if (rate == link_rate_hbr2)
 		pixel_div = 4;
-- 
2.35.1




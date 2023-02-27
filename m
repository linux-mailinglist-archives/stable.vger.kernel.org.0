Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D1B6A378B
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjB0CKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbjB0CJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:09:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAB91ADCE;
        Sun, 26 Feb 2023 18:08:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93FAEB80C9C;
        Mon, 27 Feb 2023 02:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA057C433EF;
        Mon, 27 Feb 2023 02:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463335;
        bh=h1yZD+l4ViMaLCqSGrX0WvRwzliCwFCb/X+s+oVTcdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTsV67NetdEfzLyiMRwrmhIl5hu+mGHTwK6dku4l6ixQAu/WdHNQa4BKxJW7SbCWF
         jfTWkgxozn0xeugsNyKCiTigwgUk6UvRoDN4n6NWexnVGspBH1z3yxN0iHNysahji/
         8G+To1XErmONTCVyXukjL6GG+S9O/uJcngs7YIHWvn7z01V7iXYR7YSKC6gMuO6sCY
         ez2RiBdzVofMztl6IZGn14HT5ECEnz15ajtdlyVVkQzDUDnTI3wY19qDj5jP7qLCT0
         aMg3Lu+OIDrbtFbXW1x/nyvbDmnEUntmg37TqTGdm8K3stS/S84JRwKvUAf3cafAnS
         XKM75BPLmVVoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Andersson <quic_bjorande@quicinc.com>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        quic_abhinavk@quicinc.com, airlied@gmail.com, daniel@ffwll.ch,
        swboyd@chromium.org, johan+linaro@kernel.org,
        quic_sbillaka@quicinc.com, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 18/60] drm/msm/dp: Remove INIT_SETUP delay
Date:   Sun, 26 Feb 2023 21:00:03 -0500
Message-Id: <20230227020045.1045105-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit e17af1c9d861dc177e5b56009bd4f71ace688d97 ]

During initalization of the DisplayPort controller an EV_HPD_INIT_SETUP
event is generated, but with a delay of 100 units. This delay existed to
circumvent bug in the QMP combo PHY driver, where if the DP part was
powered up before USB, the common properties would not be properly
initialized - and USB wouldn't work.

This issue was resolved in the recent refactoring of the QMP driver,
so it's now possible to remove this delay.

While there is still a timing dependency in the current implementation,
test indicates that it's now possible to boot with an external display
on USB Type-C and have the display power up, without disconnecting and
reconnecting the cable.

Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/518729/
Link: https://lore.kernel.org/r/20230117172951.2748456-1-quic_bjorande@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 7ff60e5ff3258..ed4159f6d344e 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -1497,7 +1497,7 @@ void msm_dp_irq_postinstall(struct msm_dp *dp_display)
 	dp = container_of(dp_display, struct dp_display_private, dp_display);
 
 	if (!dp_display->is_edp)
-		dp_add_event(dp, EV_HPD_INIT_SETUP, 0, 100);
+		dp_add_event(dp, EV_HPD_INIT_SETUP, 0, 0);
 }
 
 bool msm_dp_wide_bus_available(const struct msm_dp *dp_display)
-- 
2.39.0


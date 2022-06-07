Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D11541A8F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380184AbiFGVek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379545AbiFGVcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:32:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3229422D640;
        Tue,  7 Jun 2022 12:04:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91E6E6181D;
        Tue,  7 Jun 2022 19:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC28C34115;
        Tue,  7 Jun 2022 19:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628659;
        bh=3oW9Tx/Id2jpAA18HoDTbbm0Aq9/0ChE827W/WUnirc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4f5YslFEvaktzu5e5hDeB0GcCNjQ9NZFmbodSOPwL/xGkZOryiY4wqBayQ0jGzvu
         yDKW6F/vDckCAaXoYpoJbDjJC5l02VbJbcZDUHAiPZh6MEA7wrnodJj4G7iMYM5PMr
         RBNBRgfSm1w3v/bdE+etmyhecRuciKUbJIMimpR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 372/879] drm/msm/dp: do not stop transmitting phy test pattern during DP phy compliance test
Date:   Tue,  7 Jun 2022 18:58:10 +0200
Message-Id: <20220607165013.669857838@linuxfoundation.org>
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

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

[ Upstream commit 2788b4efa60c1e03ac10a156f3fdbd3be0f9198c ]

At normal operation, transmit phy test pattern has to be terminated before
DP controller switch to video ready state. However during phy compliance
testing, transmit phy test pattern should not be terminated until end of
compliance test which usually indicated by unplugged interrupt.

Only stop sending the train pattern in dp_ctrl_on_stream() if we're not
doing compliance testing. We also no longer reset 'p_level' and
'v_level' within dp_ctrl_on_link() due to both 'p_level' and 'v_level'
are acquired from link status at previous dpcd read and we like to use
those level to start link training.

Changes in v2:
-- add more details commit text
-- correct Fixes

Changes in v3:
-- drop unnecessary braces

Fixes: 2e0adc765d88 ("drm/msm/dp: do not end dp link training until video is ready")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/483564/
Link: https://lore.kernel.org/r/1650995939-28467-3-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 193cc1a597ff..08cc48af03b7 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1699,8 +1699,6 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 		ctrl->link->link_params.rate,
 		ctrl->link->link_params.num_lanes, ctrl->dp_ctrl.pixel_rate);
 
-	ctrl->link->phy_params.p_level = 0;
-	ctrl->link->phy_params.v_level = 0;
 
 	rc = dp_ctrl_enable_mainlink_clocks(ctrl);
 	if (rc)
@@ -1822,12 +1820,6 @@ int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl)
 		}
 	}
 
-	if (!dp_ctrl_channel_eq_ok(ctrl))
-		dp_ctrl_link_retrain(ctrl);
-
-	/* stop txing train pattern to end link training */
-	dp_ctrl_clear_training_pattern(ctrl);
-
 	ret = dp_ctrl_enable_stream_clocks(ctrl);
 	if (ret) {
 		DRM_ERROR("Failed to start pixel clocks. ret=%d\n", ret);
@@ -1839,6 +1831,12 @@ int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl)
 		return 0;
 	}
 
+	if (!dp_ctrl_channel_eq_ok(ctrl))
+		dp_ctrl_link_retrain(ctrl);
+
+	/* stop txing train pattern to end link training */
+	dp_ctrl_clear_training_pattern(ctrl);
+
 	/*
 	 * Set up transfer unit values and set controller state to send
 	 * video.
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124C55AEADA
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbiIFNo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239243AbiIFNnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:43:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0687DF48;
        Tue,  6 Sep 2022 06:38:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A9F2B81632;
        Tue,  6 Sep 2022 13:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AEAC433C1;
        Tue,  6 Sep 2022 13:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471417;
        bh=y7JAdxKTnOGJ1kKhCTc+UzAJMh4qE6vjtAQKYyGRH4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=setJIvXOb4Wvyt8+Y9zgUXHkMVpSUKf1MOFp4vs0GYTGlWny9j/Q5s+ymw0fxRtXC
         yFDdrb/oMji8IrTAaYBYMj3Hb3cSR9roRSp8xrel0Jca1yrWuZBr64qx6wDfT3JrC9
         hk92wRekA4gXRFbe1sEm/ZKjWvU8vu6b2+JXDu/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/107] drm/msm/dp: delete DP_RECOVERED_CLOCK_OUT_EN to fix tps4
Date:   Tue,  6 Sep 2022 15:29:43 +0200
Message-Id: <20220906132821.819225997@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

[ Upstream commit 032d57960176ac01cc5adff5bcc5eb51317f8781 ]

Data Symbols scrambled is required for tps4 at link training 2.
Therefore SCRAMBLING_DISABLE bit should not be set for tps4 to
work.

RECOVERED_CLOCK_OUT_EN is for enable simple EYE test for jitter
measurement with minimal equipment for embedded applications purpose
and is not required to be set during normal operation. Current
implementation always have RECOVERED_CLOCK_OUT_EN bit set which
cause SCRAMBLING_DISABLE bit wrongly set at tps4 which prevent
tps4 from working.

This patch delete setting RECOVERED_CLOCK_OUT_EN to fix
SCRAMBLING_DISABLE be wrongly set at tps4.

Changes in v2:
-- fix Fixes tag

Changes in v3:
-- revise commit text

Changes in v4:
-- fix commit text newline

Changes in v5:
-- fix commit text line over 75 chars

Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>

Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/497194/
Link: https://lore.kernel.org/r/1660258670-4200-1-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index b6f4ce2a48afe..6d9eec98e0d38 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1198,7 +1198,7 @@ static int dp_ctrl_link_train_2(struct dp_ctrl_private *ctrl,
 	if (ret)
 		return ret;
 
-	dp_ctrl_train_pattern_set(ctrl, pattern | DP_RECOVERED_CLOCK_OUT_EN);
+	dp_ctrl_train_pattern_set(ctrl, pattern);
 
 	for (tries = 0; tries <= maximum_retries; tries++) {
 		drm_dp_link_train_channel_eq_delay(ctrl->aux, ctrl->panel->dpcd);
-- 
2.35.1




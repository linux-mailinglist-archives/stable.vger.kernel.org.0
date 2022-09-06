Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FD55AEBD5
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240754AbiIFOAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240856AbiIFN6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:58:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12D38285B;
        Tue,  6 Sep 2022 06:42:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4016D60F89;
        Tue,  6 Sep 2022 13:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488E4C433D7;
        Tue,  6 Sep 2022 13:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471773;
        bh=QwqLXj55wPRteB3A34vpnzJ86LNL8i7W/9dMEmN9lio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqk3ynvZckeiJPiP5Bpx6jlbUpKlT5K2IHccMDobTx84IoltMm1yUOOzYww6EIY1b
         0MNH5vLeGMCfRdBX0LCIW2sdhqd8PYssF4vjpNwIVfiXJDOMORt8pnPiCBrQ44OB4J
         KA+XvlclrFM/0zjcpaR5Q2AeVJSDo7oHvFiYyyEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 004/155] drm/msm/dp: delete DP_RECOVERED_CLOCK_OUT_EN to fix tps4
Date:   Tue,  6 Sep 2022 15:29:12 +0200
Message-Id: <20220906132829.606602221@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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
index 703249384e7c7..45aa06a31a9fd 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1214,7 +1214,7 @@ static int dp_ctrl_link_train_2(struct dp_ctrl_private *ctrl,
 	if (ret)
 		return ret;
 
-	dp_ctrl_train_pattern_set(ctrl, pattern | DP_RECOVERED_CLOCK_OUT_EN);
+	dp_ctrl_train_pattern_set(ctrl, pattern);
 
 	for (tries = 0; tries <= maximum_retries; tries++) {
 		drm_dp_link_train_channel_eq_delay(ctrl->aux, ctrl->panel->dpcd);
-- 
2.35.1




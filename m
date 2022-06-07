Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E52541A73
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379826AbiFGVdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381011AbiFGVbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:31:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AAB22C49F;
        Tue,  7 Jun 2022 12:03:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ACBD617F7;
        Tue,  7 Jun 2022 19:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0D2C385A5;
        Tue,  7 Jun 2022 19:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628628;
        bh=Kacrr2MuoitFijxvKKIMt/koonpQyVamPq3KJQ9FeW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoQV51+gJa87mUwINY2UfCpI4P56iEegz0CNXDeQcXGs5GDd/4cpNG30ZO1IRDaKU
         igAu5LCuVov3gbWm+wvtjiSiJfjtzBKJqEgJR20380mS6wUgdezVYXYn6DePkPF4PB
         rVNfUlYYCGLKIQBvAfEKwTo7e5RFlxrhLOzt76V0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 371/879] drm/msm/dp: reset DP controller before transmit phy test pattern
Date:   Tue,  7 Jun 2022 18:58:09 +0200
Message-Id: <20220607165013.641051369@linuxfoundation.org>
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

[ Upstream commit 581d69981159b00f0443d171a4b900089f34ccfe ]

DP controller state can not switch from video ready state to
transmit phy pattern state at run time. DP mainlink has to be
teared down followed by reset controller to default state to have
DP controller switch to transmit phy test pattern state and start
generate specified phy test pattern to sinker once main link setup
again.

Changes in v2:
-- correct Fixes's commit id

Fixes: 52352fe2f866 ("drm/msm/dp: use dp_ctrl_off_link_stream during PHY compliance test run")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/483563/
Link: https://lore.kernel.org/r/1650995939-28467-2-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 53568567e05b..193cc1a597ff 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1532,7 +1532,7 @@ static int dp_ctrl_process_phy_test_request(struct dp_ctrl_private *ctrl)
 	 * running. Add the global reset just before disabling the
 	 * link clocks and core clocks.
 	 */
-	ret = dp_ctrl_off_link_stream(&ctrl->dp_ctrl);
+	ret = dp_ctrl_off(&ctrl->dp_ctrl);
 	if (ret) {
 		DRM_ERROR("failed to disable DP controller\n");
 		return ret;
-- 
2.35.1




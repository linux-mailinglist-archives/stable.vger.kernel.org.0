Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2BF4F2E71
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbiDEJDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237091AbiDEIRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2987B0A4F;
        Tue,  5 Apr 2022 01:05:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FD43B81BB0;
        Tue,  5 Apr 2022 08:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DBAC385A1;
        Tue,  5 Apr 2022 08:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145902;
        bh=7kR5Em9KAFPcdr/UzJk7L2Vdy1QzIZOvLSTG4t3zRps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sy4oiWvy7873qRMDO+moYKD+SU1RjK2eyjNvs3Yu/kt+wBi5DnacRLqnaJkPXL/bM
         UfIcFPiFlW6GP4zxOAf0tu+tb3kMBmm2hchkEHV0EekCS5jsQ4qsRsk/xHW/Il/d2G
         6ysqHHu7j4hw1oaLTwYygCFFuPx8yX+P7Amj2oUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0571/1126] drm/msm/dsi/phy: fix 7nm v4.0 settings for C-PHY mode
Date:   Tue,  5 Apr 2022 09:21:58 +0200
Message-Id: <20220405070424.394652316@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit bb07af2ed2a47dc6c4d0681f275bb27d4f845465 ]

The dsi_7nm_phy_enable() disagrees with downstream for
glbl_str_swi_cal_sel_ctrl and glbl_hstx_str_ctrl_0 values. Update
programmed settings to match downstream driver. To remove the
possibility for such errors in future drop less_than_1500_mhz
assignment and specify settings explicitly.

Fixes: 5ac178381d26 ("drm/msm/dsi: support CPHY mode for 7nm pll/phy")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Link: https://lore.kernel.org/r/20220217000837.435340-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
index 36eb6109cb88..6e506feb111f 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
@@ -864,20 +864,26 @@ static int dsi_7nm_phy_enable(struct msm_dsi_phy *phy,
 	/* Alter PHY configurations if data rate less than 1.5GHZ*/
 	less_than_1500_mhz = (clk_req->bitclk_rate <= 1500000000);
 
-	/* For C-PHY, no low power settings for lower clk rate */
-	if (phy->cphy_mode)
-		less_than_1500_mhz = false;
-
 	if (phy->cfg->quirks & DSI_PHY_7NM_QUIRK_V4_1) {
 		vreg_ctrl_0 = less_than_1500_mhz ? 0x53 : 0x52;
-		glbl_rescode_top_ctrl = less_than_1500_mhz ? 0x3d :  0x00;
-		glbl_rescode_bot_ctrl = less_than_1500_mhz ? 0x39 :  0x3c;
+		if (phy->cphy_mode) {
+			glbl_rescode_top_ctrl = 0x00;
+			glbl_rescode_bot_ctrl = 0x3c;
+		} else {
+			glbl_rescode_top_ctrl = less_than_1500_mhz ? 0x3d :  0x00;
+			glbl_rescode_bot_ctrl = less_than_1500_mhz ? 0x39 :  0x3c;
+		}
 		glbl_str_swi_cal_sel_ctrl = 0x00;
 		glbl_hstx_str_ctrl_0 = 0x88;
 	} else {
 		vreg_ctrl_0 = less_than_1500_mhz ? 0x5B : 0x59;
-		glbl_str_swi_cal_sel_ctrl = less_than_1500_mhz ? 0x03 : 0x00;
-		glbl_hstx_str_ctrl_0 = less_than_1500_mhz ? 0x66 : 0x88;
+		if (phy->cphy_mode) {
+			glbl_str_swi_cal_sel_ctrl = 0x03;
+			glbl_hstx_str_ctrl_0 = 0x66;
+		} else {
+			glbl_str_swi_cal_sel_ctrl = less_than_1500_mhz ? 0x03 : 0x00;
+			glbl_hstx_str_ctrl_0 = less_than_1500_mhz ? 0x66 : 0x88;
+		}
 		glbl_rescode_top_ctrl = 0x03;
 		glbl_rescode_bot_ctrl = 0x3c;
 	}
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD785F961C
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbiJJA0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbiJJAXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:23:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA43120AF;
        Sun,  9 Oct 2022 16:56:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38E8BB80DEE;
        Sun,  9 Oct 2022 23:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B007C433C1;
        Sun,  9 Oct 2022 23:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359810;
        bh=BdfJixTWVY9uxH5Y7CFWtnrm9ZR7+RkdkXJtLPFhc3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQ2Cwlwpb2IhFXSUVPdei9mtkvPn6V3kkdxSxt3Z5y8O5nB3jGDAFHPy6oBc0wK7g
         UcwS10TYoPj5yMFK94tLIwaWRP+6AgQ67AhhIRvz8e1cYJPxeiAFBtXP+NKcsniraL
         o9Swq2eoehKFf9dLDOiC/DPh6YhDAyUoNszGbpdSxR7lVgOqtEC1f8cobXomKT4xDb
         p4enQZJ3REz7+Wy8v1Kw1XiW0uhpicrPl61QIHOrM6lMeT0H5WHZBKC1E0gLM51Ra0
         xohLBFJq5T3pHSSEQkdl8h66cFQrAk3/8nkRbTlZisil8ECjsNfXwLzqUe21MOjZ/F
         A8jrltQGvc8IQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Khaled Almahallawy <khaled.almahallawy@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Or Cochvi <or.cochvi@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 20/22] drm/dp: Don't rewrite link config when setting phy test pattern
Date:   Sun,  9 Oct 2022 19:55:38 -0400
Message-Id: <20221009235540.1231640-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235540.1231640-1-sashal@kernel.org>
References: <20221009235540.1231640-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Khaled Almahallawy <khaled.almahallawy@intel.com>

[ Upstream commit 7b4d8db657192066bc6f1f6635d348413dac1e18 ]

The sequence for Source DP PHY CTS automation is [2][1]:
1- Emulate successful Link Training(LT)
2- Short HPD and change link rates and number of lanes by LT.
(This is same flow for Link Layer CTS)
3- Short HPD and change PHY test pattern and swing/pre-emphasis
levels (This step should not trigger LT)

The problem is with DP PHY compliance setup as follow:

     [DPTX + on board LTTPR]------Main Link--->[Scope]
     	     	        ^                         |
			|                         |
			|                         |
			----------Aux Ch------>[Aux Emulator]

At step 3, before writing TRAINING_LANEx_SET/LINK_QUAL_PATTERN_SET
to declare the pattern/swing requested by scope, we write link
config in LINK_BW_SET/LANE_COUNT_SET on a port that has LTTPR.
As LTTPR snoops aux transaction, LINK_BW_SET/LANE_COUNT_SET writes
indicate a LT will start [Check DP 2.0 E11 -Sec 3.6.8.2 & 3.6.8.6.3],
and LTTPR will reset the link and stop sending DP signals to
DPTX/Scope causing the measurements to fail. Note that step 3 will
not trigger LT and DP link will never recovered by the
Aux Emulator/Scope.

The reset of link can be tested with a monitor connected to LTTPR
port simply by writing to LINK_BW_SET or LANE_COUNT_SET as follow

  igt/tools/dpcd_reg write --offset=0x100 --value 0x14 --device=2

OR

  printf '\x14' | sudo dd of=/dev/drm_dp_aux2 bs=1 count=1 conv=notrunc
  seek=$((0x100))

This single aux write causes the screen to blank, sending short HPD to
DPTX, setting LINK_STATUS_UPDATE = 1 in DPCD 0x204, and triggering LT.

As stated in [1]:
"Before any TX electrical testing can be performed, the link between a
DPTX and DPRX (in this case, a piece of test equipment), including all
LTTPRs within the path, shall be trained as defined in this Standard."

In addition, changing Phy pattern/Swing/Pre-emphasis (Step 3) uses the
same link rate and lane count applied on step 2, so no need to redo LT.

The fix is to not rewrite link config in step 3, and just writes
TRAINING_LANEx_SET and LINK_QUAL_PATTERN_SET

[1]: DP 2.0 E11 - 3.6.11.1 LTTPR DPTX_PHY Electrical Compliance

[2]: Configuring UnigrafDPTC Controller - Automation Test Sequence
https://www.keysight.com/us/en/assets/9922-01244/help-files/
D9040DPPC-DisplayPort-Test-Software-Online-Help-latest.chm

Cc: Imre Deak <imre.deak@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Or Cochvi <or.cochvi@intel.com>
Signed-off-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220916054900.415804-1-khaled.almahallawy@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_helper.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
index 3c55753bab16..6ba16db77500 100644
--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -2172,17 +2172,8 @@ int drm_dp_set_phy_test_pattern(struct drm_dp_aux *aux,
 				struct drm_dp_phy_test_params *data, u8 dp_rev)
 {
 	int err, i;
-	u8 link_config[2];
 	u8 test_pattern;
 
-	link_config[0] = drm_dp_link_rate_to_bw_code(data->link_rate);
-	link_config[1] = data->num_lanes;
-	if (data->enhanced_frame_cap)
-		link_config[1] |= DP_LANE_COUNT_ENHANCED_FRAME_EN;
-	err = drm_dp_dpcd_write(aux, DP_LINK_BW_SET, link_config, 2);
-	if (err < 0)
-		return err;
-
 	test_pattern = data->phy_pattern;
 	if (dp_rev < 0x12) {
 		test_pattern = (test_pattern << 2) &
-- 
2.35.1


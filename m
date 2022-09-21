Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583E05C03A7
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbiIUQIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbiIUQHG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:07:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61DAA405E;
        Wed, 21 Sep 2022 08:55:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48E07B830CD;
        Wed, 21 Sep 2022 15:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BB1C433D7;
        Wed, 21 Sep 2022 15:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663775657;
        bh=50kLM76nyyhdmXbushh3HRygRTZC0Oc3WRLlXQ6F6Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WK58r9DbxBDQbbIgeXghOwl/2i+R5sGPVeEU8QCsbOJV5NEmWcxUTdK9h8Pt86l9F
         UjAZpKulTHAU3v6NHDooRkl4/aZVuUAQ5HhwWPFQ1ufD1S7x7Q88JP+u8Sc1gxpxM5
         BNp2655fMcaxvgkFErPQ015uhNu/qgRaxJBXDcSkFC14L+UVnKGhcwZwDOnUasHA+P
         VW9Ov43WW3U9b5TAsegwrPTWKRg6mPRp2N1728238PK6G6/kQl9eXZpSgjRrUduEtj
         qh9CivhFgmcQ+8RmKSsrLTLsYYgO4jM2HrtChcU/TA5hOHWo5KEkzjhD1RP21WQ7hM
         ofCZfJlBSHHUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yao Wang1 <Yao.Wang1@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Krunoslav Kovac <Krunoslav.Kovac@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Pavle Kotarac <Pavle.Kotarac@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, HaoPing.Liu@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 06/10] drm/amd/display: Limit user regamma to a valid value
Date:   Wed, 21 Sep 2022 11:54:03 -0400
Message-Id: <20220921155407.235132-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921155407.235132-1-sashal@kernel.org>
References: <20220921155407.235132-1-sashal@kernel.org>
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

From: Yao Wang1 <Yao.Wang1@amd.com>

[ Upstream commit 3601d620f22e37740cf73f8278eabf9f2aa19eb7 ]

[Why]
For HDR mode, we get total 512 tf_point and after switching to SDR mode
we actually get 400 tf_point and the rest of points(401~512) still use
dirty value from HDR mode. We should limit the rest of the points to max
value.

[How]
Limit the value when coordinates_x.x > 1, just like what we do in
translate_from_linear_space for other re-gamma build paths.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Krunoslav Kovac <Krunoslav.Kovac@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Pavle Kotarac <Pavle.Kotarac@amd.com>
Signed-off-by: Yao Wang1 <Yao.Wang1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
index ef742d95ef05..c707c9bfed43 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -1597,6 +1597,7 @@ static void interpolate_user_regamma(uint32_t hw_points_num,
 	struct fixed31_32 lut2;
 	struct fixed31_32 delta_lut;
 	struct fixed31_32 delta_index;
+	const struct fixed31_32 one = dc_fixpt_from_int(1);
 
 	i = 0;
 	/* fixed_pt library has problems handling too small values */
@@ -1625,6 +1626,9 @@ static void interpolate_user_regamma(uint32_t hw_points_num,
 			} else
 				hw_x = coordinates_x[i].x;
 
+			if (dc_fixpt_le(one, hw_x))
+				hw_x = one;
+
 			norm_x = dc_fixpt_mul(norm_factor, hw_x);
 			index = dc_fixpt_floor(norm_x);
 			if (index < 0 || index > 255)
-- 
2.35.1


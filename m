Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DB75C0375
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbiIUQFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbiIUQEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:04:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34C06110F;
        Wed, 21 Sep 2022 08:54:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0405CB830F3;
        Wed, 21 Sep 2022 15:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C07C433C1;
        Wed, 21 Sep 2022 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663775687;
        bh=7lT88kymb+yHRk7aKUfmIghEeBPzIMSI+gUmp/ehBBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6fT0S4psDxGGHTGvSbrio5jO5h+rHJMSTKSP++DCOnJ8uUiQYcKe5Dd9Hyg/TFyR
         bz527MMphcRp/xlSOU1PgmsOKRnkp24EmAZsyQzS9l4PJ5mdMLkPE3o5JYHk3blHaL
         8ZSeLSfkdtFm+kr36MgzXarAif7WXfD2epMia3QqVb0BJEMsNKleb0qmoIk1gjZeYi
         2nhf7rzvkmYh6JGubOQzISoXsbmPtcTybfOUeL1v/e69E+798zX8ft/d2x59Esek4L
         hOL3MZ8Dxu20E5GjOoMO6PG4xcxUEjFixzo61o6siGZYK6lfKkPbiMTpNNVnKWQqVg
         EzVLcww0boZ3w==
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
        daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 2/3] drm/amd/display: Limit user regamma to a valid value
Date:   Wed, 21 Sep 2022 11:54:42 -0400
Message-Id: <20220921155444.235446-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921155444.235446-1-sashal@kernel.org>
References: <20220921155444.235446-1-sashal@kernel.org>
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
index 11ea1a0e629b..4e866317ec25 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -1206,6 +1206,7 @@ static void interpolate_user_regamma(uint32_t hw_points_num,
 	struct fixed31_32 lut2;
 	struct fixed31_32 delta_lut;
 	struct fixed31_32 delta_index;
+	const struct fixed31_32 one = dc_fixpt_from_int(1);
 
 	i = 0;
 	/* fixed_pt library has problems handling too small values */
@@ -1234,6 +1235,9 @@ static void interpolate_user_regamma(uint32_t hw_points_num,
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


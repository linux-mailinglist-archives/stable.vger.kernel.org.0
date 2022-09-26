Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C7B5EA027
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbiIZKfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235882AbiIZKdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:33:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9E337FB0;
        Mon, 26 Sep 2022 03:20:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92690B80924;
        Mon, 26 Sep 2022 10:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5B5C433D6;
        Mon, 26 Sep 2022 10:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187609;
        bh=7lT88kymb+yHRk7aKUfmIghEeBPzIMSI+gUmp/ehBBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vq9j9A1HYZW/FFCr/9iYrNELwYVk3edG9WN0cC8vN1FEJQmP0oPIQNSOK3pxVk+1e
         EJErgr2e2LMyxU6kJvWHUx/vzpnYWAzrwNMhRaWDe5FWbsmWEGyfUSC7Xv9EV5/04M
         de/EYYOS5kv7o1OTIUB3qR9yCBQ9Ey6A2xkDvOTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Krunoslav Kovac <Krunoslav.Kovac@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Pavle Kotarac <Pavle.Kotarac@amd.com>,
        Yao Wang1 <Yao.Wang1@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 54/58] drm/amd/display: Limit user regamma to a valid value
Date:   Mon, 26 Sep 2022 12:12:13 +0200
Message-Id: <20220926100743.464586670@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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




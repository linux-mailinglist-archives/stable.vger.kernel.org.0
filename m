Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231C46A3936
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 04:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjB0DHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 22:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjB0DHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 22:07:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024E9EB7B;
        Sun, 26 Feb 2023 19:07:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C9A660D45;
        Mon, 27 Feb 2023 02:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FAFC433EF;
        Mon, 27 Feb 2023 02:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463710;
        bh=nRnMrqT7K6CLFB3J4zShaT3eHPeMrkNxZjzeMmqR5iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MsxpKkbF+fRX2a5NIWST99gcUa4XWyI3YUCl9ujYtDRJ+3Sk8gQlZDGuCVe/VpZAp
         QXV7ydm4wJj2vnBAeuI5DvJmpE5Vn7cVcS5OXcfcKJUul0yBUuXyL7/l9sXEr9CvXP
         MNtH6wKLdHcZu96n0so6uPPoPbFxbPoKs//xNvvwMotD35LhVnTHlrVpTgaAXJEkyi
         h6xyMW11Yf5qR3c0m2jKLeTdTgK/BCV5W8Ps0MO0euQtLkxdGPkvuzZFzPjFeBvyMm
         wcltKAl3kbVnlrUVktQfzAeLbr+0mITJwKYuSfWUVjf7BRHB5tJvmfd+znZ2A/fISK
         c0JqsOG0mWnzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Hansen Dsouza <hansen.dsouza@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Charlene.Liu@amd.com, alex.hung@amd.com,
        sancchen@amd.com, mwen@igalia.com, Daniel.Miess@amd.com,
        roman.li@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 50/58] drm/amd/display: Enable P-state validation checks for DCN314
Date:   Sun, 26 Feb 2023 21:04:48 -0500
Message-Id: <20230227020457.1048737-50-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 37d184b548db0f64d4a878960b2c6988b38a3e7e ]

[Why]
To align with DCN31 behavior. This helps avoid p-state hangs in
the case where underflow does occur.

[How]
Flip the bit to true.

Reviewed-by: Hansen Dsouza <hansen.dsouza@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
index c80c8c8f51e97..5985ce8df4e08 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -897,7 +897,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.max_downscale_src_width = 4096,/*upto true 4k*/
 	.disable_pplib_wm_range = false,
 	.scl_reset_length10 = true,
-	.sanity_checks = false,
+	.sanity_checks = true,
 	.underflow_assert_delay_us = 0xFFFFFFFF,
 	.dwb_fi_phase = -1, // -1 = disable,
 	.dmub_command_table = true,
-- 
2.39.0


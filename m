Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7551715F3B9
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389555AbgBNSOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:14:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730973AbgBNPwW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:52:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E964B222C4;
        Fri, 14 Feb 2020 15:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695541;
        bh=mCOEe5nfmTF5/aZn0fqadNVXIBDE7qooNGqNGL1thUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5fezyZ67ZAz8XKzPI0Uxw74xhC//vz0HPYzzWPWC2Cwxap72COMJ/NZdhqCjBAxk
         +EktHa1URSPTtkkF8VBrGaIGY9h4yQXEszdzvOd50f0P06isdGKL5u+o8kywu9u/cr
         UioSdx7d2eES/z3MUepS7BsiW61JWM0i3pgjP8kU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Hulk Robot <hulkci@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 159/542] drm/amd/display: remove set but not used variable 'min_content'
Date:   Fri, 14 Feb 2020 10:42:31 -0500
Message-Id: <20200214154854.6746-159-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit 8f72bfe8d85a827f638141d0f07de42d0c24a36f ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/amd/display/modules/color/color_gamma.c: In function build_freesync_hdr:
drivers/gpu/drm/amd/display/modules/color/color_gamma.c:830:20: warning: variable min_content set but not used [-Wunused-but-set-variable]

It is not used since commit 50575eb5b339 ("drm/amd/display:
Only use EETF when maxCL > max display")

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
index 1de4805cb8c7f..9b121b08c8063 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -937,7 +937,6 @@ static bool build_freesync_hdr(struct pwl_float_data_ex *rgb_regamma,
 	struct fixed31_32 max_display;
 	struct fixed31_32 min_display;
 	struct fixed31_32 max_content;
-	struct fixed31_32 min_content;
 	struct fixed31_32 clip = dc_fixpt_one;
 	struct fixed31_32 output;
 	bool use_eetf = false;
@@ -951,7 +950,6 @@ static bool build_freesync_hdr(struct pwl_float_data_ex *rgb_regamma,
 	max_display = dc_fixpt_from_int(fs_params->max_display);
 	min_display = dc_fixpt_from_fraction(fs_params->min_display, 10000);
 	max_content = dc_fixpt_from_int(fs_params->max_content);
-	min_content = dc_fixpt_from_fraction(fs_params->min_content, 10000);
 	sdr_white_level = dc_fixpt_from_int(fs_params->sdr_white_level);
 
 	if (fs_params->min_display > 1000) // cap at 0.1 at the bottom
-- 
2.20.1


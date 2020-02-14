Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B69F15DC5B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731009AbgBNPwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:52:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730602AbgBNPwb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:52:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C9DA24684;
        Fri, 14 Feb 2020 15:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695550;
        bh=4HCmXbuWpLBfwxdVNssIxL9w5lNhZNqYmfydz4zxs7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6zOCy9T6J107El4Ty/+OqOzYxiZ684dpK+5urGekIozSaMa/8AaHZWrO8//d+3RY
         dUQvfxvz1zWwMbHdMRbar/fCaFkLNVoMyNko/dAHM7EidWf59E3CEI5LHYVbPq3138
         cdediRVTyh4QWafB20F+86I6e4VN0/gp69q5jF6I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 166/542] drm/radeon: remove set but not used variable 'tv_pll_cntl1'
Date:   Fri, 14 Feb 2020 10:42:38 -0500
Message-Id: <20200214154854.6746-166-sashal@kernel.org>
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

[ Upstream commit dc9b3dbd28744510b78490dc6312848a8f918749 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/radeon/radeon_legacy_tv.c: In function radeon_legacy_tv_mode_set:
drivers/gpu/drm/radeon/radeon_legacy_tv.c:538:24: warning: variable tv_pll_cntl1 set but not used [-Wunused-but-set-variable]

It is introduced by commit 4ce001abafaf ("drm/radeon/kms:
add initial radeon tv-out support."), but never used,
so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_legacy_tv.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_legacy_tv.c b/drivers/gpu/drm/radeon/radeon_legacy_tv.c
index f132eec737adf..d9df7f311e761 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_tv.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_tv.c
@@ -537,7 +537,7 @@ void radeon_legacy_tv_mode_set(struct drm_encoder *encoder,
 	uint32_t tv_master_cntl, tv_rgb_cntl, tv_dac_cntl;
 	uint32_t tv_modulator_cntl1, tv_modulator_cntl2;
 	uint32_t tv_vscaler_cntl1, tv_vscaler_cntl2;
-	uint32_t tv_pll_cntl, tv_pll_cntl1, tv_ftotal;
+	uint32_t tv_pll_cntl, tv_ftotal;
 	uint32_t tv_y_fall_cntl, tv_y_rise_cntl, tv_y_saw_tooth_cntl;
 	uint32_t m, n, p;
 	const uint16_t *hor_timing;
@@ -709,12 +709,6 @@ void radeon_legacy_tv_mode_set(struct drm_encoder *encoder,
 		(((n >> 9) & RADEON_TV_N0HI_MASK) << RADEON_TV_N0HI_SHIFT) |
 		((p & RADEON_TV_P_MASK) << RADEON_TV_P_SHIFT);
 
-	tv_pll_cntl1 = (((4 & RADEON_TVPCP_MASK) << RADEON_TVPCP_SHIFT) |
-			((4 & RADEON_TVPVG_MASK) << RADEON_TVPVG_SHIFT) |
-			((1 & RADEON_TVPDC_MASK) << RADEON_TVPDC_SHIFT) |
-			RADEON_TVCLK_SRC_SEL_TVPLL |
-			RADEON_TVPLL_TEST_DIS);
-
 	tv_dac->tv.tv_uv_adr = 0xc8;
 
 	if (tv_dac->tv_std == TV_STD_NTSC ||
-- 
2.20.1


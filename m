Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A00BE15E430
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389207AbgBNQZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:25:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:34352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393359AbgBNQZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:25:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34EE9247B5;
        Fri, 14 Feb 2020 16:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697509;
        bh=rWKJNV9Sbr1m7wRyPB2Ede1g5VawtcrzSvOZgyNhgN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RvNLADaAM6kmitXq6tjt5//ERnZtpWDTySs7wl2v9i6Kfq2Y4tJgwL8KY+fHjJngF
         W2MBrf/6N1IUoqdVN+hhPbRJmRsvxj93iXsehlLfTc9bBW1LOUFcu5smPlrPGgKEaA
         1cG7Rl9oqyQts13Vua9coYTfHtj/NoEemfgX0yQA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 035/100] drm/radeon: remove set but not used variable 'tv_pll_cntl1'
Date:   Fri, 14 Feb 2020 11:23:19 -0500
Message-Id: <20200214162425.21071-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
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
index 49750d07ab7d4..3133f5dfc239a 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_tv.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_tv.c
@@ -544,7 +544,7 @@ void radeon_legacy_tv_mode_set(struct drm_encoder *encoder,
 	uint32_t tv_master_cntl, tv_rgb_cntl, tv_dac_cntl;
 	uint32_t tv_modulator_cntl1, tv_modulator_cntl2;
 	uint32_t tv_vscaler_cntl1, tv_vscaler_cntl2;
-	uint32_t tv_pll_cntl, tv_pll_cntl1, tv_ftotal;
+	uint32_t tv_pll_cntl, tv_ftotal;
 	uint32_t tv_y_fall_cntl, tv_y_rise_cntl, tv_y_saw_tooth_cntl;
 	uint32_t m, n, p;
 	const uint16_t *hor_timing;
@@ -716,12 +716,6 @@ void radeon_legacy_tv_mode_set(struct drm_encoder *encoder,
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


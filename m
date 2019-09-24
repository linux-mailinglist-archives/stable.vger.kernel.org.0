Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57893BCFBD
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409891AbfIXQor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409888AbfIXQoq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:44:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21DD821783;
        Tue, 24 Sep 2019 16:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343485;
        bh=n4EK9lFlhG+7vx2FsuKOoovwxv61xtY/g7zcyr254u0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P99RJLA7s4vN848YhkadZaZS/c19xKH9mf4MoPS3H4ze4TCMc+Co/JthdHn1WeyF2
         PCn9wFRU62DWYUHE5NM69sPlqHbsm9LQUsmStOhXhcWawD5URkYwprxvWbXKodeORI
         YaZw8yv9FmGhN2/B+GYzg8Ge8wEfEZeJ7bvVEPJA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.de>, Ken Wang <Qingqing.Wang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "David (ChunMing) Zhou" <David1.Zhou@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 65/87] drm/amdgpu/si: fix ASIC tests
Date:   Tue, 24 Sep 2019 12:41:21 -0400
Message-Id: <20190924164144.25591-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

[ Upstream commit 77efe48a729588527afb4d5811b9e0acb29f5e51 ]

Comparing adev->family with CHIP constants is not correct.
adev->family can only be compared with AMDGPU_FAMILY constants and
adev->asic_type is the struct member to compare with CHIP constants.
They are separate identification spaces.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: 62a37553414a ("drm/amdgpu: add si implementation v10")
Cc: Ken Wang <Qingqing.Wang@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: "David (ChunMing) Zhou" <David1.Zhou@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/si.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/si.c b/drivers/gpu/drm/amd/amdgpu/si.c
index 4d74453f3cfbd..602397016b641 100644
--- a/drivers/gpu/drm/amd/amdgpu/si.c
+++ b/drivers/gpu/drm/amd/amdgpu/si.c
@@ -1881,7 +1881,7 @@ static void si_program_aspm(struct amdgpu_device *adev)
 			if (orig != data)
 				si_pif_phy1_wreg(adev,PB1_PIF_PWRDOWN_1, data);
 
-			if ((adev->family != CHIP_OLAND) && (adev->family != CHIP_HAINAN)) {
+			if ((adev->asic_type != CHIP_OLAND) && (adev->asic_type != CHIP_HAINAN)) {
 				orig = data = si_pif_phy0_rreg(adev,PB0_PIF_PWRDOWN_0);
 				data &= ~PLL_RAMP_UP_TIME_0_MASK;
 				if (orig != data)
@@ -1930,14 +1930,14 @@ static void si_program_aspm(struct amdgpu_device *adev)
 
 			orig = data = si_pif_phy0_rreg(adev,PB0_PIF_CNTL);
 			data &= ~LS2_EXIT_TIME_MASK;
-			if ((adev->family == CHIP_OLAND) || (adev->family == CHIP_HAINAN))
+			if ((adev->asic_type == CHIP_OLAND) || (adev->asic_type == CHIP_HAINAN))
 				data |= LS2_EXIT_TIME(5);
 			if (orig != data)
 				si_pif_phy0_wreg(adev,PB0_PIF_CNTL, data);
 
 			orig = data = si_pif_phy1_rreg(adev,PB1_PIF_CNTL);
 			data &= ~LS2_EXIT_TIME_MASK;
-			if ((adev->family == CHIP_OLAND) || (adev->family == CHIP_HAINAN))
+			if ((adev->asic_type == CHIP_OLAND) || (adev->asic_type == CHIP_HAINAN))
 				data |= LS2_EXIT_TIME(5);
 			if (orig != data)
 				si_pif_phy1_wreg(adev,PB1_PIF_CNTL, data);
-- 
2.20.1


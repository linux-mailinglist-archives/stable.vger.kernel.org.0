Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195302E16E4
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgLWDDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:03:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728643AbgLWCT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE86622525;
        Wed, 23 Dec 2020 02:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689935;
        bh=zk6cO27GUJVeOS+ID0F0Ks1lYJ3QJxO4vuZrb3FjT/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYafhoPP/ELwfg+H2JF1jdofTTmjDcCZzPELv+w9iCzlk8IGE/RfMK0TpHPPKmFM7
         RNelKBOn44aSMEvPqTMRtNGNWKEVNJ8PbsdC6liw9aCBCegmPinJZOuoCTPCeiGuF9
         /7hdFxFLTS0SuniPC3DjhxzO2eWOA29AsMHCHeH5GUra59nm4T/LllGEhTJdgsIIYs
         hH8N9d8dxO8JcVoRvPFN6xaY74fpB3OrvFp1h975aciT3eVilia3/SKBu5pjZX56W0
         VtC9SJ71f1T9BuTrw5vBfHizydULdgiJ1uVhL/UWn8nZ5qzOBtbaL8jm+OEr+azZbb
         CWfvKNW6rrnxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bokun Zhang <Bokun.Zhang@amd.com>, Monk Liu <monk.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 032/130] drm/amd/amdgpu: Add rev_id workaround logic for SRIOV setup
Date:   Tue, 22 Dec 2020 21:16:35 -0500
Message-Id: <20201223021813.2791612-32-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bokun Zhang <Bokun.Zhang@amd.com>

[ Upstream commit de21e4aeb2b26128dcc5be1bcb2fafa73d041e51 ]

- When we are under SRIOV setup, the rev_id cannot be read
  properly. Therefore, we will return default value for it

Signed-off-by: Bokun Zhang <Bokun.Zhang@amd.com>
Reviewed-by: Monk Liu <monk.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
index c05d78d4efc66..56887affc13be 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
@@ -34,8 +34,17 @@
 
 static u32 nbio_v2_3_get_rev_id(struct amdgpu_device *adev)
 {
-	u32 tmp = RREG32_SOC15(NBIO, 0, mmRCC_DEV0_EPF0_STRAP0);
+	u32 tmp;
 
+	/*
+	 * guest vm gets 0xffffffff when reading RCC_DEV0_EPF0_STRAP0,
+	 * therefore we force rev_id to 0 (which is the default value)
+	 */
+	if (amdgpu_sriov_vf(adev)) {
+		return 0;
+	}
+
+	tmp = RREG32_SOC15(NBIO, 0, mmRCC_DEV0_EPF0_STRAP0);
 	tmp &= RCC_DEV0_EPF0_STRAP0__STRAP_ATI_REV_ID_DEV0_F0_MASK;
 	tmp >>= RCC_DEV0_EPF0_STRAP0__STRAP_ATI_REV_ID_DEV0_F0__SHIFT;
 
-- 
2.27.0


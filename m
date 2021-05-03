Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154BE371974
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhECQgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231408AbhECQgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:36:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F067560D07;
        Mon,  3 May 2021 16:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059728;
        bh=XJhRDno84dxoR28e7Bc0BSzpSZh3YNnxBxVu+ZIK1BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+wC9B8hFB6zdyBTH0XVKSEpA5Q4LBi2CsFz0ku0XdVT8QIr7yZFKBfDseiChbMJV
         xFagaCoIRb4giapHhJOOT4H4meXVaHmQTGk5gTmEaPUhgkymDeZo/dsTQP7Sx6fLKs
         oT2fNccWKaOu31l24x3PJ3nEexv81LWgI/gsagodvh7Y5w16AIevBoilUqpYBB+YJE
         5fwnML7L/UyVJZRG4JerPxBFXUEEl13MajUJOhbM9NGOFCwKogGG2goTq5NVoz1Ohz
         LDIou5qLlpVr5ktSdE9uXFW2oSjZaO+MjGu/Bv/INelDsVsO2c+R2McBdy1dIR0oNb
         Q0NGWwk8LaHNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eryk Brol <eryk.brol@amd.com>, Bindu Ramamurthy <bindu.r@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 009/134] drm/amd/display: Check for DSC support instead of ASIC revision
Date:   Mon,  3 May 2021 12:33:08 -0400
Message-Id: <20210503163513.2851510-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eryk Brol <eryk.brol@amd.com>

[ Upstream commit 349a19b2f1b01e713268c7de9944ad669ccdf369 ]

[why]
This check for ASIC revision is no longer useful and causes
lightup issues after a topology change in MST DSC scenario.
In this case, DSC configs should be recalculated for the new
topology. This check prevented that from happening on certain
ASICs that do, in fact, support DSC.

[how]
Change the ASIC revision to instead check if DSC is supported.

Signed-off-by: Eryk Brol <eryk.brol@amd.com>
Acked-by: Bindu Ramamurthy <bindu.r@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index d699a5cf6c11..8ad83ccfcc6a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9383,7 +9383,7 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	}
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
-	if (adev->asic_type >= CHIP_NAVI10) {
+	if (dc_resource_is_dsc_encoding_supported(dc)) {
 		for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
 			if (drm_atomic_crtc_needs_modeset(new_crtc_state)) {
 				ret = add_affected_mst_dsc_crtcs(state, crtc);
-- 
2.30.2


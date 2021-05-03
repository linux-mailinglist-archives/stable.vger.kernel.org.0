Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D39371BF6
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhECQu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232304AbhECQrq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:47:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 287FF6161F;
        Mon,  3 May 2021 16:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059987;
        bh=9D/Q0VxAMiYdeIcFr/NNyxXHgJsYy4ABWVkzL6zh4CI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFyQ9iX4swbTnjJfbbpgP2ZIssQHnJ2GNSElpurE0k45hthk8Kk/7YfNEivI9s4Pf
         4HEUJxkyYvri/cIQVN1X4cQm9ChnA4/WCnE4SmwhsnVwS3mc9/KIbWs/ORvxhkiO8E
         MCb1ApaQ/DpdFq+t1MobCn0reIiDU/vNLbsMgKV0cIDIBOLF3C34bP39ekT48Akehq
         kIvT3WjntzfmOSdA9oQqzejsHMn2wGKyGy5EfwuQEskBMcZMA+tE5VwrZ+ThwD4eMD
         f5qklMLEfK4ntnlY/2DxcZ7y94lr5TrOnQUEnIRuEoYcOzGf5jPBhrRPVRhYTDMqqE
         x9xATvaMa5LPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eryk Brol <eryk.brol@amd.com>, Bindu Ramamurthy <bindu.r@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 03/57] drm/amd/display: Check for DSC support instead of ASIC revision
Date:   Mon,  3 May 2021 12:38:47 -0400
Message-Id: <20210503163941.2853291-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
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
index fbbe611d4873..2626aacf492f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7330,7 +7330,7 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	}
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
-	if (adev->asic_type >= CHIP_NAVI10) {
+	if (dc_resource_is_dsc_encoding_supported(dc)) {
 		for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
 			if (drm_atomic_crtc_needs_modeset(new_crtc_state)) {
 				ret = add_affected_mst_dsc_crtcs(state, crtc);
-- 
2.30.2


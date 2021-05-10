Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0B5378432
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhEJKvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232544AbhEJKrv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:47:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8DE76193F;
        Mon, 10 May 2021 10:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643067;
        bh=eTN+de3NHgpVDaYMabz2GfZkvrhhJsTxTr5eGN63y5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAgh6IsOBt0c9R3DqF3CYWSoEhjc5/mRLJjzCWWXJe4t2rbT5Nglqv+ek1mQPJhkC
         Mruyij5lYY0Kq9vV23B8c73rnG8uJe3f2bi74J+Yyt0L5WvY/g1H6ORYExRAe6PChr
         tkP7HQbosyrPsQvzITyONZaegH5IYc11CvK1W3Q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eryk Brol <eryk.brol@amd.com>,
        Bindu Ramamurthy <bindu.r@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/299] drm/amd/display: Check for DSC support instead of ASIC revision
Date:   Mon, 10 May 2021 12:18:36 +0200
Message-Id: <20210510102008.904924849@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c07737c45677..830d302be045 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8659,7 +8659,7 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	}
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
-	if (adev->asic_type >= CHIP_NAVI10) {
+	if (dc_resource_is_dsc_encoding_supported(dc)) {
 		for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
 			if (drm_atomic_crtc_needs_modeset(new_crtc_state)) {
 				ret = add_affected_mst_dsc_crtcs(state, crtc);
-- 
2.30.2




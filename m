Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A10167564
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730661AbgBUI0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:26:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388598AbgBUIYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:24:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7B072469D;
        Fri, 21 Feb 2020 08:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273448;
        bh=WfyRji/FvQF4TG98tKGWVFWrcCVN4w/9py2R/eS+vXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7oxcgSus5ePOaTghRoAV4woKtuoiHHoNrR7anGhgqJliEKrJwkPAQO4zNOZri11J
         sSmCEf7dZFP83+mBe1ZLl8Bpy4fd4B+wQJfEh7NeE1p8azVl5q/ucYAAOzhHiMW5g6
         UpHwbGFnCF+vETMseK28nX2TGAfFs64C0ZfBh0B4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 175/191] radeon: insert 10ms sleep in dce5_crtc_load_lut
Date:   Fri, 21 Feb 2020 08:42:28 +0100
Message-Id: <20200221072311.718262780@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit ec3d65082d7dabad6fa8f66a8ef166f2d522d6b2 ]

Per at least one tester this is enough magic to recover the regression
introduced for some people (but not all) in

commit b8e2b0199cc377617dc238f5106352c06dcd3fa2
Author: Peter Rosin <peda@axentia.se>
Date:   Tue Jul 4 12:36:57 2017 +0200

    drm/fb-helper: factor out pseudo-palette

which for radeon had the side-effect of refactoring out a seemingly
redudant writing of the color palette.

10ms in a fairly slow modeset path feels like an acceptable form of
duct-tape, so maybe worth a shot and see what sticks.

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_display.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index d8e2d7b3b8365..7d1e14f0140a2 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -121,6 +121,8 @@ static void dce5_crtc_load_lut(struct drm_crtc *crtc)
 
 	DRM_DEBUG_KMS("%d\n", radeon_crtc->crtc_id);
 
+	msleep(10);
+
 	WREG32(NI_INPUT_CSC_CONTROL + radeon_crtc->crtc_offset,
 	       (NI_INPUT_CSC_GRPH_MODE(NI_INPUT_CSC_BYPASS) |
 		NI_INPUT_CSC_OVL_MODE(NI_INPUT_CSC_BYPASS)));
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF3F1EAB05
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbgFASNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:13:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731354AbgFASNg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:13:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26A15206E2;
        Mon,  1 Jun 2020 18:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035215;
        bh=jq73E0XRcEVooUoKZS79XlgjeVA7SExlr3KiK8w//p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jgh9inpinX68aecypgwlKYCSbwp10nkg/ls2i4dsyDTF5VaEzHx7c/wJJknNlVgzr
         Us2GSMMAO0g2gE4hd9N5NpagAiZb9nJnUwwea8xGUQ+OmAzds4S6Jhg1iW5QdrfIDz
         XK5Si0mVvyC7xvedFEl8OheNKhyUE0LX8tQLc2tQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 060/177] drm/amdgpu: drop unnecessary cancel_delayed_work_sync on PG ungate
Date:   Mon,  1 Jun 2020 19:53:18 +0200
Message-Id: <20200601174053.981337540@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 1fe48ec08d9f2e26d893a6c05bd6c99a3490f9ef ]

As this is already properly handled in amdgpu_gfx_off_ctrl(). In fact,
this unnecessary cancel_delayed_work_sync may leave a small time window
for race condition and is dangerous.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |  6 +-----
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c  | 12 +++---------
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 02702597ddeb..012df3d574bf 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -4241,11 +4241,7 @@ static int gfx_v10_0_set_powergating_state(void *handle,
 	switch (adev->asic_type) {
 	case CHIP_NAVI10:
 	case CHIP_NAVI14:
-		if (!enable) {
-			amdgpu_gfx_off_ctrl(adev, false);
-			cancel_delayed_work_sync(&adev->gfx.gfx_off_delay_work);
-		} else
-			amdgpu_gfx_off_ctrl(adev, true);
+		amdgpu_gfx_off_ctrl(adev, enable);
 		break;
 	default:
 		break;
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 906648fca9ef..914dbd901b98 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -4734,10 +4734,9 @@ static int gfx_v9_0_set_powergating_state(void *handle,
 	switch (adev->asic_type) {
 	case CHIP_RAVEN:
 	case CHIP_RENOIR:
-		if (!enable) {
+		if (!enable)
 			amdgpu_gfx_off_ctrl(adev, false);
-			cancel_delayed_work_sync(&adev->gfx.gfx_off_delay_work);
-		}
+
 		if (adev->pg_flags & AMD_PG_SUPPORT_RLC_SMU_HS) {
 			gfx_v9_0_enable_sck_slow_down_on_power_up(adev, true);
 			gfx_v9_0_enable_sck_slow_down_on_power_down(adev, true);
@@ -4761,12 +4760,7 @@ static int gfx_v9_0_set_powergating_state(void *handle,
 			amdgpu_gfx_off_ctrl(adev, true);
 		break;
 	case CHIP_VEGA12:
-		if (!enable) {
-			amdgpu_gfx_off_ctrl(adev, false);
-			cancel_delayed_work_sync(&adev->gfx.gfx_off_delay_work);
-		} else {
-			amdgpu_gfx_off_ctrl(adev, true);
-		}
+		amdgpu_gfx_off_ctrl(adev, enable);
 		break;
 	default:
 		break;
-- 
2.25.1




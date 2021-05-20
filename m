Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D03638A54A
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbhETKPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235844AbhETKMv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:12:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECD2261976;
        Thu, 20 May 2021 09:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503838;
        bh=gYpF8uet3VyewPAhW9qfpbhgkCdU5x4pNvjZ5nzg/28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcLnVtuau0MXIL710MMi3P5SXiCSIr9qpnhGaN+PaymAVVUDfSJvNy0bHTniJ/Tdg
         sE2HU+qJ+W+D/6bQ/iPEKV1DXO2uxP1tC5c+mU1+Nfeh5EocE79qImw1gmcONhCFjv
         Zp36tJy5Hjdjd/rjZ7eVKzSRfiYzPrybWrEKtA3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 368/425] drm/radeon/dpm: Disable sclk switching on Oland when two 4K 60Hz monitors are connected
Date:   Thu, 20 May 2021 11:22:17 +0200
Message-Id: <20210520092143.497364985@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 227545b9a08c68778ddd89428f99c351fc9315ac upstream.

Screen flickers rapidly when two 4K 60Hz monitors are in use. This issue
doesn't happen when one monitor is 4K 60Hz (pixelclock 594MHz) and
another one is 4K 30Hz (pixelclock 297MHz).

The issue is gone after setting "power_dpm_force_performance_level" to
"high". Following the indication, we found that the issue occurs when
sclk is too low.

So resolve the issue by disabling sclk switching when there are two
monitors requires high pixelclock (> 297MHz).

v2:
 - Only apply the fix to Oland.
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon.h    |    1 +
 drivers/gpu/drm/radeon/radeon_pm.c |    8 ++++++++
 drivers/gpu/drm/radeon/si_dpm.c    |    3 +++
 3 files changed, 12 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1558,6 +1558,7 @@ struct radeon_dpm {
 	void                    *priv;
 	u32			new_active_crtcs;
 	int			new_active_crtc_count;
+	int			high_pixelclock_count;
 	u32			current_active_crtcs;
 	int			current_active_crtc_count;
 	bool single_display;
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1715,6 +1715,7 @@ static void radeon_pm_compute_clocks_dpm
 	struct drm_device *ddev = rdev->ddev;
 	struct drm_crtc *crtc;
 	struct radeon_crtc *radeon_crtc;
+	struct radeon_connector *radeon_connector;
 
 	if (!rdev->pm.dpm_enabled)
 		return;
@@ -1724,6 +1725,7 @@ static void radeon_pm_compute_clocks_dpm
 	/* update active crtc counts */
 	rdev->pm.dpm.new_active_crtcs = 0;
 	rdev->pm.dpm.new_active_crtc_count = 0;
+	rdev->pm.dpm.high_pixelclock_count = 0;
 	if (rdev->num_crtc && rdev->mode_info.mode_config_initialized) {
 		list_for_each_entry(crtc,
 				    &ddev->mode_config.crtc_list, head) {
@@ -1731,6 +1733,12 @@ static void radeon_pm_compute_clocks_dpm
 			if (crtc->enabled) {
 				rdev->pm.dpm.new_active_crtcs |= (1 << radeon_crtc->crtc_id);
 				rdev->pm.dpm.new_active_crtc_count++;
+				if (!radeon_crtc->connector)
+					continue;
+
+				radeon_connector = to_radeon_connector(radeon_crtc->connector);
+				if (radeon_connector->pixelclock_for_modeset > 297000)
+					rdev->pm.dpm.high_pixelclock_count++;
 			}
 		}
 	}
--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -3000,6 +3000,9 @@ static void si_apply_state_adjust_rules(
 		    (rdev->pdev->device == 0x6605)) {
 			max_sclk = 75000;
 		}
+
+		if (rdev->pm.dpm.high_pixelclock_count > 1)
+			disable_sclk_switching = true;
 	}
 
 	if (rps->vce_active) {



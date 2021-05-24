Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5161938E9EA
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhEXOvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233385AbhEXOte (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:49:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7559D61405;
        Mon, 24 May 2021 14:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867653;
        bh=iP6DUxWfATu6isZ8a35AHOw79kmKV9EKH10uabLKLFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4eC1wVCgZ7cRn+SfInEyUWR8sVeq5y6dQmfU/o6ObA1/oilSo1B3Deb6v5VvmITK
         PrFiiFtOGvCaimT1asoJf/5MpzLUGRnVmX+uxy3aZXPi+U5N4nYWaxCzz2EYEZjgCN
         Y+A3xJx78jG0R+U7eXVS1bAalZU19/KYfeVlbGJ/KCdYyam5leRYmLAGdFH+bxCuuM
         rauy2bDJnJQsQovzhn1ahSrbv939bsAHl4bI3rWdoLHEEqdf7sFNIS9gZxa8NZ8Qw6
         p8TJZYC8dDOtlJCTuDyu1uqQ8rsiIdtbKENQRmE5LK6rRjQEyY66hJXVsbBnq5mrPo
         4XV/26CSGt/PA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Park <Chris.Park@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 56/63] drm/amd/display: Disconnect non-DP with no EDID
Date:   Mon, 24 May 2021 10:46:13 -0400
Message-Id: <20210524144620.2497249-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Park <Chris.Park@amd.com>

[ Upstream commit 080039273b126eeb0185a61c045893a25dbc046e ]

[Why]
Active DP dongles return no EDID when dongle
is connected, but VGA display is taken out.
Current driver behavior does not remove the
active display when this happens, and this is
a gap between dongle DTP and dongle behavior.

[How]
For active DP dongles and non-DP scenario,
disconnect sink on detection when no EDID
is read due to timeout.

Signed-off-by: Chris Park <Chris.Park@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 440bf0a0e12a..204928479c95 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -1067,6 +1067,24 @@ static bool dc_link_detect_helper(struct dc_link *link,
 			    dc_is_dvi_signal(link->connector_signal)) {
 				if (prev_sink)
 					dc_sink_release(prev_sink);
+				link_disconnect_sink(link);
+
+				return false;
+			}
+			/*
+			 * Abort detection for DP connectors if we have
+			 * no EDID and connector is active converter
+			 * as there are no display downstream
+			 *
+			 */
+			if (dc_is_dp_sst_signal(link->connector_signal) &&
+				(link->dpcd_caps.dongle_type ==
+						DISPLAY_DONGLE_DP_VGA_CONVERTER ||
+				link->dpcd_caps.dongle_type ==
+						DISPLAY_DONGLE_DP_DVI_CONVERTER)) {
+				if (prev_sink)
+					dc_sink_release(prev_sink);
+				link_disconnect_sink(link);
 
 				return false;
 			}
-- 
2.30.2


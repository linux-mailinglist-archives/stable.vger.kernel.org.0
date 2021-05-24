Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8526F38EB71
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbhEXPDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233009AbhEXPA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:00:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7AC161474;
        Mon, 24 May 2021 14:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867803;
        bh=iTFHOW+j+J+7qE5PeNjpJG59ARpmR1B1eKLj1kqXsnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8ihFpP1OnagbL8XwCZbe9rsZtPCXxWJbGDIJ/Ld5KNutKiNOVUzzd3zN+cvhP6nh
         6AO9UFvF2v0rflmRu2gtWENbRuvrNaJyT+Su4KeXWmLbSAL0isoL0/pvQhScj4+0A0
         xfrpKRpngf+jPsTlE5k1y+seLgMX4xOUM2AkJxGhq8PEX4B2cqj2+lF0a1X/8jTxTq
         xec3RlcEqH1Lvdjkzq33Xp0xmhbVan/saCJfDclm9klRjYTa0JH/tFYHFF9TLgxtvr
         lTrsPjQ0kr+DSoHNjDE4IOIzOQtBGd8sgt9WVh0PJr7n8l5n9FiuQDwSJKfgGYMLwB
         W6u1ipO9yETpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Park <Chris.Park@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 49/52] drm/amd/display: Disconnect non-DP with no EDID
Date:   Mon, 24 May 2021 10:48:59 -0400
Message-Id: <20210524144903.2498518-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
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
index 40041c61a100..6b03267021ea 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -936,6 +936,24 @@ bool dc_link_detect(struct dc_link *link, enum dc_detect_reason reason)
 			    dc_is_dvi_signal(link->connector_signal)) {
 				if (prev_sink != NULL)
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


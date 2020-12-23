Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A51B2E176F
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgLWDKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:10:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728127AbgLWCSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C235423137;
        Wed, 23 Dec 2020 02:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689811;
        bh=it+HTgVVO1MflBnmaXHlqr5E0XdrcaWNL0+XY5KXdgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FuqLfvRoOZQ/Mk6R6X5NiAbM/AANFVfMDIrD5iQbsQTUvHna5BV95r3Ukt1vYi8T4
         9/YcG5f9K7swpagcnPMI+/qCcwoB0OnODhleXg74VSK6t5mhRQHqWepockZULO1pVu
         4ZeGXgIWi33Ygm2pTlWbZHS0T7W0mRStB/t8mxftcd4+7pWpMSb1iOWLAz8LZSQiv+
         57MxPMDeYcVM+icR25JyhBIgJUdN3zPOYMn/bEEuJRW4mDbZkOqx9R8VvchrmfwCD6
         WQGxWItvNddYJzSauuVqveLv2htBBXrkw9ubrbuOW6fRgWl2fEu/dAjcCT4ZPaPWfI
         4uVe2Wo7GHcLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Isabel Zhang <isabel.zhang@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 019/217] drm/amd/display: Force prefetch mode to 0
Date:   Tue, 22 Dec 2020 21:13:08 -0500
Message-Id: <20201223021626.2790791-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Isabel Zhang <isabel.zhang@amd.com>

[ Upstream commit 685b4d8142dcbf11b817f74c2bc5b94eca7ee7f2 ]

[Why]
On APU should be always using prefetch mode 0.
Currently, sometimes prefetch mode 1 is being
used causing system to hard hang due to
minTTUVBlank being too low.

[How]
Any ASIC running DCN21 will by default allow
self refresh and mclk switch. This sets both
min and max prefetch mode to 0 by default.

Signed-off-by: Isabel Zhang <isabel.zhang@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index e73785e74cba8..202a677a1bd78 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -301,7 +301,9 @@ struct _vcs_dpi_soc_bounding_box_st dcn2_1_soc = {
 	.xfc_bus_transport_time_us = 4,
 	.xfc_xbuf_latency_tolerance_us = 4,
 	.use_urgent_burst_bw = 1,
-	.num_states = 8
+	.num_states = 8,
+	.allow_dram_self_refresh_or_dram_clock_change_in_vblank
+			= dm_allow_self_refresh_and_mclk_switch
 };
 
 #ifndef MAX
-- 
2.27.0


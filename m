Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE4C29A1D8
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409464AbgJ0AoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409316AbgJZXvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C59E121655;
        Mon, 26 Oct 2020 23:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756267;
        bh=Atl5i6ZnorOnVHtF/Pl07jVSKX/qfgrU588BkajKXY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqRWrzX1Mq6Jj8WSMxOJNvbY7An3MF7KA56slMLbI2qWpkA/LEj/7itHw3hckQYkv
         bcFIMiaEINha0IrdyYhJFRt4wdP5qB8tvuv6ToEwGt5VTd4L3f1OqRQCELWhCUB/pV
         CE0YWcfOj+IkiXXN3h76hQ56XG783uOe9pD75O1g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fangzhi Zuo <Jerry.Zuo@amd.com>, Hersen Wu <hersenxs.wu@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.9 100/147] drm/amd/display: HDMI remote sink need mode validation for Linux
Date:   Mon, 26 Oct 2020 19:48:18 -0400
Message-Id: <20201026234905.1022767-100-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit 95d620adb48f7728e67d82f56f756e8d451cf8d2 ]

[Why]
Currently mode validation is bypassed if remote sink exists. That
leads to mode set issue when a BW bottle neck exists in the link path,
e.g., a DP-to-HDMI converter that only supports HDMI 1.4.

Any invalid mode passed to Linux user space will cause the modeset
failure due to limitation of Linux user space implementation.

[How]
Mode validation is skipped only if in edid override. For real remote
sink, clock limit check should be done for HDMI remote sink.

Have HDMI related remote sink going through mode validation to
elimiate modes which pixel clock exceeds BW limitation.

Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Acked-by: Eryk Brol <eryk.brol@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 437d1a7a16fe7..b0f8bfd48d102 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -2441,7 +2441,7 @@ enum dc_status dc_link_validate_mode_timing(
 	/* A hack to avoid failing any modes for EDID override feature on
 	 * topology change such as lower quality cable for DP or different dongle
 	 */
-	if (link->remote_sinks[0])
+	if (link->remote_sinks[0] && link->remote_sinks[0]->sink_signal == SIGNAL_TYPE_VIRTUAL)
 		return DC_OK;
 
 	/* Passive Dongle */
-- 
2.25.1


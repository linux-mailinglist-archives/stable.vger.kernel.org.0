Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969702E42F6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407163AbgL1Nwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:52:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:54592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407158AbgL1Nwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:52:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2BB7205CB;
        Mon, 28 Dec 2020 13:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163520;
        bh=wkgRYiQ9peJU+x7wP2bPPnDxmwh+pI6/UVGrQmVkiko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1fPQn35SDE4bJmR00iMhViCOK6ijhH2dTfGIryjNS1sYCJUgvDXLYsMJeyKIIZEZ9
         FoIGNgjLCCs0n8y4FHvMtk1VQkvlc8Ozfg1rHeHTMne5jQeLjnJeKATpdN+5GAPgcD
         goUK1CqUYYfuG2DXnkrPXPV506/Z6CiFLwfU3xCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Park <Chris.Park@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 315/453] drm/amd/display: Prevent bandwidth overflow
Date:   Mon, 28 Dec 2020 13:49:11 +0100
Message-Id: <20201228124952.365781046@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Park <Chris.Park@amd.com>

[ Upstream commit 80089dd8410f356d5104496d5ab71a66a4f4646b ]

[Why]
At very high pixel clock, bandwidth calculation exceeds 32 bit size
and overflow value. This causes the resulting selection of link rate
to be inaccurate.

[How]
Change order of operation and use fixed point to deal with integer
accuracy. Also address bug found when forcing link rate.

Signed-off-by: Chris Park <Chris.Park@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Eryk Brol <eryk.brol@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 47cefc05fd3f5..f933791f1fbbb 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -2906,11 +2906,14 @@ uint32_t dc_bandwidth_in_kbps_from_timing(
 {
 	uint32_t bits_per_channel = 0;
 	uint32_t kbps;
+	struct fixed31_32 link_bw_kbps;
 
 #ifdef CONFIG_DRM_AMD_DC_DSC_SUPPORT
 	if (timing->flags.DSC) {
-		kbps = (timing->pix_clk_100hz * timing->dsc_cfg.bits_per_pixel);
-		kbps = kbps / 160 + ((kbps % 160) ? 1 : 0);
+		link_bw_kbps = dc_fixpt_from_int(timing->pix_clk_100hz);
+		link_bw_kbps = dc_fixpt_div_int(link_bw_kbps, 160);
+		link_bw_kbps = dc_fixpt_mul_int(link_bw_kbps, timing->dsc_cfg.bits_per_pixel);
+		kbps = dc_fixpt_ceil(link_bw_kbps);
 		return kbps;
 	}
 #endif
-- 
2.27.0




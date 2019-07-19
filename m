Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1B296D9FC
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 05:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbfGSD6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728216AbfGSD6q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:58:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2139421851;
        Fri, 19 Jul 2019 03:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508725;
        bh=TI0TPOQn5WRhgeZCy07aXRVhI2CGOzL2HZJKi35gJgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vFaxJwwb7fXtwQHwdbk1B6i3tWGP5Afa1MJCq/IEIXTKl73lltp9GZVCX41j1q+Up
         SPL8rlnJyOWJ2p81DjPoNdWFXyXeDqVS9QMTTO6pK+OTtSVKXt0Kti1Km+HmJ48TsC
         jSNNiAcwrfGyJRGnsMi6O+wr/YW9hf9fyBtcFZoM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 053/171] drm/amd/display: Update link rate from DPCD 10
Date:   Thu, 18 Jul 2019 23:54:44 -0400
Message-Id: <20190719035643.14300-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Chalmers <Wesley.Chalmers@amd.com>

[ Upstream commit 53c81fc7875bc2dca358485dac3999e14ec91a00 ]

[WHY]
Some panels return a link rate of 0 (unknown) in DPCD 0. In this case,
an appropriate mode cannot be set, and certain panels will show
corruption as they are forced to use a mode they do not support.

[HOW]
Read DPCD 10 in the case where supported link rate from DPCD 0 is
unknown, and pass that value on to the reported link rate.
This re-introduces behaviour present in previous versions that appears
to have been accidentally removed.

Signed-off-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 1ee544a32ebb..253311864cdd 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1624,8 +1624,7 @@ static bool decide_edp_link_settings(struct dc_link *link, struct dc_link_settin
 	uint32_t link_bw;
 
 	if (link->dpcd_caps.dpcd_rev.raw < DPCD_REV_14 ||
-			link->dpcd_caps.edp_supported_link_rates_count == 0 ||
-			link->dc->config.optimize_edp_link_rate == false) {
+			link->dpcd_caps.edp_supported_link_rates_count == 0) {
 		*link_setting = link->verified_link_cap;
 		return true;
 	}
@@ -2597,7 +2596,8 @@ void detect_edp_sink_caps(struct dc_link *link)
 	memset(supported_link_rates, 0, sizeof(supported_link_rates));
 
 	if (link->dpcd_caps.dpcd_rev.raw >= DPCD_REV_14 &&
-			link->dc->config.optimize_edp_link_rate) {
+			(link->dc->config.optimize_edp_link_rate ||
+			link->reported_link_cap.link_rate == LINK_RATE_UNKNOWN)) {
 		// Read DPCD 00010h - 0001Fh 16 bytes at one shot
 		core_link_read_dpcd(link, DP_SUPPORTED_LINK_RATES,
 							supported_link_rates, sizeof(supported_link_rates));
@@ -2612,6 +2612,9 @@ void detect_edp_sink_caps(struct dc_link *link)
 				link_rate = linkRateInKHzToLinkRateMultiplier(link_rate_in_khz);
 				link->dpcd_caps.edp_supported_link_rates[link->dpcd_caps.edp_supported_link_rates_count] = link_rate;
 				link->dpcd_caps.edp_supported_link_rates_count++;
+
+				if (link->reported_link_cap.link_rate < link_rate)
+					link->reported_link_cap.link_rate = link_rate;
 			}
 		}
 	}
-- 
2.20.1


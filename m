Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 086D1797DC
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388564AbfG2UC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390377AbfG2Trp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:47:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BC332054F;
        Mon, 29 Jul 2019 19:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429664;
        bh=Hrbc675MLAsFjEaFA9El9Z7mjy9taTlDFUs376GO9O4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m26QAPY3qY+gP7x6MqURAipOjs6PaI50wVrsluMBACoNo2sTxXJk/zRR+iLMSnulm
         HXBQQoW6pC2aglgp6xd15j88mM0sjthcGQYvrIHlPG/dwqHsDhAuuGEJxILGnXjisK
         lk4o6brkDvfS7jeovEl9YXEh1doOQt1dvXUIZ+LM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 055/215] drm/amd/display: Update link rate from DPCD 10
Date:   Mon, 29 Jul 2019 21:20:51 +0200
Message-Id: <20190729190750.056856446@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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




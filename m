Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC5D1E6060
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 14:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388732AbgE1L40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 07:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388722AbgE1L4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 07:56:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4956121475;
        Thu, 28 May 2020 11:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666985;
        bh=5ytxPpxU0m3lHoVVGX4RTX2V48UhxcGD1rEGh/T19/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtvdPOe0e6/W3gMWiWhdPP5ntZg4jhLIXwqLQNkk2H9dbfTq7MV8iXdvgvMB/k+5G
         hSX6/5jqkYtSwil4p2jUOKTwixBpioynqnmEuCwQOi8ZSRZbsk3mQQ1qRYSE/zxYOR
         aFJTliP5cLGxmjVObcp44fx9YYmDfjYb4gx294FQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Stempen <vladimir.stempen@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 21/47] drm/amd/display: DP training to set properly SCRAMBLING_DISABLE
Date:   Thu, 28 May 2020 07:55:34 -0400
Message-Id: <20200528115600.1405808-21-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Stempen <vladimir.stempen@amd.com>

[ Upstream commit b6ef55ccba7ed00fc10e3e6f619c8f886162427f ]

[Why]
DP training sequence to set SCRAMBLING_DISABLE bit properly based on
training pattern - per DP Spec.

[How]
Update dpcd_pattern.v1_4.SCRAMBLING_DISABLE with 1 for TPS1, TPS2, TPS3,
but not for TPS4.

Signed-off-by: Vladimir Stempen <vladimir.stempen@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/core/dc_link_dp.c  | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 1b6c75a4dd60..fbcd979438e2 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -220,6 +220,30 @@ static enum dpcd_training_patterns
 	return dpcd_tr_pattern;
 }
 
+static uint8_t dc_dp_initialize_scrambling_data_symbols(
+	struct dc_link *link,
+	enum dc_dp_training_pattern pattern)
+{
+	uint8_t disable_scrabled_data_symbols = 0;
+
+	switch (pattern) {
+	case DP_TRAINING_PATTERN_SEQUENCE_1:
+	case DP_TRAINING_PATTERN_SEQUENCE_2:
+	case DP_TRAINING_PATTERN_SEQUENCE_3:
+		disable_scrabled_data_symbols = 1;
+		break;
+	case DP_TRAINING_PATTERN_SEQUENCE_4:
+		disable_scrabled_data_symbols = 0;
+		break;
+	default:
+		ASSERT(0);
+		DC_LOG_HW_LINK_TRAINING("%s: Invalid HW Training pattern: %d\n",
+			__func__, pattern);
+		break;
+	}
+	return disable_scrabled_data_symbols;
+}
+
 static inline bool is_repeater(struct dc_link *link, uint32_t offset)
 {
 	return (!link->is_lttpr_mode_transparent && offset != 0);
@@ -252,6 +276,9 @@ static void dpcd_set_lt_pattern_and_lane_settings(
 	dpcd_pattern.v1_4.TRAINING_PATTERN_SET =
 		dc_dp_training_pattern_to_dpcd_training_pattern(link, pattern);
 
+	dpcd_pattern.v1_4.SCRAMBLING_DISABLE =
+		dc_dp_initialize_scrambling_data_symbols(link, pattern);
+
 	dpcd_lt_buffer[DP_TRAINING_PATTERN_SET - DP_TRAINING_PATTERN_SET]
 		= dpcd_pattern.raw;
 
-- 
2.25.1


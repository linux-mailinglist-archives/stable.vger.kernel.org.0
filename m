Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3617B1EFA5B
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgFEOQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728298AbgFEOQs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:16:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 631CF20835;
        Fri,  5 Jun 2020 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366607;
        bh=5ytxPpxU0m3lHoVVGX4RTX2V48UhxcGD1rEGh/T19/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+1Zk3GAHb5VyLeSqvzIn8rFSkxF22GRvyWvmJ3bCsw7XweT7MRuF6ZaVLWEhYS9e
         g8qCa0G94t8548Xox4rwvzrNuxzni6ei7FZwZ9ZaON6gUuf+pmiO5TSgR1qkxrPLOh
         OTpIEllt3EpU4HhduuDlCDunrndA2Ya9fzCvOXdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Stempen <vladimir.stempen@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 21/43] drm/amd/display: DP training to set properly SCRAMBLING_DISABLE
Date:   Fri,  5 Jun 2020 16:14:51 +0200
Message-Id: <20200605140153.634806305@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




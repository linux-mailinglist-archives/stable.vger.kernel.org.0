Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 090C61199FE
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbfLJVsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:48:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727977AbfLJVIx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A26C124681;
        Tue, 10 Dec 2019 21:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012132;
        bh=fDlCz48UzNqMTToEOtxJXxL6opyU7MqwTF3ydeStP4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3/nxT3fD2dJCd9ZTn0ZJAvMBdfSiLsweYiMpQuSZl62BedSFkJn9L1ybXqux/vaL
         IZ0bDtf5llnQRbQjiKE9STS/QFyuf0LTSKPmwMAjgJpSnN93fZGPzEYk5l6WxozJ9s
         TBTodpBGf4ettpkbcqwAR5EGAKxD1VQD/Na8ci8s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Galiffi <david.galiffi@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 100/350] drm/amd/display: Fix dongle_caps containing stale information.
Date:   Tue, 10 Dec 2019 16:03:25 -0500
Message-Id: <20191210210735.9077-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Galiffi <david.galiffi@amd.com>

[ Upstream commit dd998291dbe92106d8c4a7581c409b356928d711 ]

[WHY]

During detection:
function: get_active_converter_info populates link->dpcd_caps.dongle_caps
only when dpcd_rev >= DPCD_REV_11 and DWN_STRM_PORTX_TYPE is
DOWN_STREAM_DETAILED_HDMI or DOWN_STREAM_DETAILED_DP_PLUS_PLUS.
Otherwise, it is not cleared, and stale information remains.

During mode validation:
function: dp_active_dongle_validate_timing reads
link->dpcd_caps.dongle_caps->dongle_type to determine the maximum
pixel clock to support. This information is now stale and no longer
valid.

[HOW]
dp_active_dongle_validate_timing should be using
link->dpcd_caps->dongle_type instead.

Signed-off-by: David Galiffi <david.galiffi@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c    | 2 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index de1b61595ffbf..efc1d30544bb6 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -2219,7 +2219,7 @@ static bool dp_active_dongle_validate_timing(
 		break;
 	}
 
-	if (dongle_caps->dongle_type != DISPLAY_DONGLE_DP_HDMI_CONVERTER ||
+	if (dpcd_caps->dongle_type != DISPLAY_DONGLE_DP_HDMI_CONVERTER ||
 		dongle_caps->extendedCapValid == false)
 		return true;
 
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 9e261dbf2e493..5a583707d198a 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -2545,6 +2545,7 @@ static void get_active_converter_info(
 	uint8_t data, struct dc_link *link)
 {
 	union dp_downstream_port_present ds_port = { .byte = data };
+	memset(&link->dpcd_caps.dongle_caps, 0, sizeof(link->dpcd_caps.dongle_caps));
 
 	/* decode converter info*/
 	if (!ds_port.fields.PORT_PRESENT) {
-- 
2.20.1


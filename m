Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D283B1A5410
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgDKXEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbgDKXEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E60E215A4;
        Sat, 11 Apr 2020 23:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646248;
        bh=YcOvtEFVJrutp/9W1WRv5YDCngfPlONYfoUpGWnRMjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0goR96Hdb4JkTwkju5o9d6U93etYzOmjQZViP7sHiNGtj2piXqliwi1f19i4XU0aY
         1W2Fl1xBA2GyI0KG2ex02hixQZoq84jYmRQDtPVu/h7T8mwgtGj8qRPtdt+P8enwIx
         B8OHeOQ7GJgSrWtKyEVgWGVAkbNn3og9ehs3R8uU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jerry (Fangzhi) Zuo" <Jerry.Zuo@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 016/149] drm/amd/display: Fix test pattern color space inconsistency for Linux
Date:   Sat, 11 Apr 2020 19:01:33 -0400
Message-Id: <20200411230347.22371-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jerry (Fangzhi) Zuo" <Jerry.Zuo@amd.com>

[ Upstream commit ef65c702d40637ed9ee25edc8e8a994168a32377 ]

[why]
When reprogram MSA with updated color space, the test color space shows
inconsistency. Linux has separate routine to set up test pattern color
space, but it fails to configure RGB.

[How]
Add RGB to test pattern.

Fixes: 43563bc2e6a769 ("drm/amd/display: update MSA and VSC SDP on video test pattern request")
Signed-off-by: Jerry (Fangzhi) Zuo <Jerry.Zuo@amd.com>
Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index fd9e69634c50a..f01bc378a51ee 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -2654,9 +2654,12 @@ static void dp_test_send_link_test_pattern(struct dc_link *link)
 	break;
 	}
 
-	test_pattern_color_space = dpcd_test_params.bits.YCBCR_COEFS ?
-			DP_TEST_PATTERN_COLOR_SPACE_YCBCR709 :
-			DP_TEST_PATTERN_COLOR_SPACE_YCBCR601;
+	if (dpcd_test_params.bits.CLR_FORMAT == 0)
+		test_pattern_color_space = DP_TEST_PATTERN_COLOR_SPACE_RGB;
+	else
+		test_pattern_color_space = dpcd_test_params.bits.YCBCR_COEFS ?
+				DP_TEST_PATTERN_COLOR_SPACE_YCBCR709 :
+				DP_TEST_PATTERN_COLOR_SPACE_YCBCR601;
 
 	dc_link_dp_set_test_pattern(
 			link,
-- 
2.20.1


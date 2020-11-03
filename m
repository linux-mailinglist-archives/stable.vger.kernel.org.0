Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEB72A39AB
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbgKCBTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:19:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:32794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbgKCBTM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:19:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD9E8223EA;
        Tue,  3 Nov 2020 01:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366351;
        bh=QIZEqvD2h/I2HvtgB4hTMz3vjJb6nXdCQk+CbZKlPBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w9ayF3aMkYh8JXsS0JBMdnaS0ZK+HFVC/+WdNwOhBqRYD+lHYJges+7iglV9QeWKM
         PmeqfgkCQDRTWSfxqZG/+547rCUfSsq0822lvzjgHkkrwdeK7DaUadMBD2TYYDWr6Y
         bsEFb8r6xNg2OKsHMcC+Pl9adUa848VQZAKnuXdo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Galiffi <David.Galiffi@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.9 23/35] drm/amd/display: Fixed panic during seamless boot.
Date:   Mon,  2 Nov 2020 20:18:28 -0500
Message-Id: <20201103011840.182814-23-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103011840.182814-1-sashal@kernel.org>
References: <20201103011840.182814-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Galiffi <David.Galiffi@amd.com>

[ Upstream commit 866e09f0110c6e86071954033e3067975946592a ]

[why]
get_pixel_clk_frequency_100hz is undefined in clock_source_funcs.

[how]
set function pointer: ".get_pixel_clk_frequency_100hz = get_pixel_clk_frequency_100hz"

Signed-off-by: David Galiffi <David.Galiffi@amd.com>
Reviewed-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
index 9cc65dc1970f8..49ae5ff12da63 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
@@ -1149,7 +1149,8 @@ static uint32_t dcn3_get_pix_clk_dividers(
 static const struct clock_source_funcs dcn3_clk_src_funcs = {
 	.cs_power_down = dce110_clock_source_power_down,
 	.program_pix_clk = dcn3_program_pix_clk,
-	.get_pix_clk_dividers = dcn3_get_pix_clk_dividers
+	.get_pix_clk_dividers = dcn3_get_pix_clk_dividers,
+	.get_pixel_clk_frequency_100hz = get_pixel_clk_frequency_100hz
 };
 #endif
 /*****************************************/
-- 
2.27.0


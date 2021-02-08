Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2EF313C39
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbhBHSDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:03:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235258AbhBHSAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:00:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E981764EBE;
        Mon,  8 Feb 2021 17:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807114;
        bh=K1aMfQFonvXHYyiQK0hl5trGHrfEt1bpMziYEyre7wE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOE9FlirVFO7twCvwZVDaBITca+04nhua5OZUAOqvNoGalYA4lkOulwDnsovoYzoe
         KW5KBECyX+W5MxbzsW+b5uCjs0gDw09R0wZxxIjlxo/HDMBVtrTim6B5sdaDJtS7AK
         sus6oWAwRI2zes2UkYXstLXUOia9mAem7dQ0OLvFVXaUwH/Msad5A1RR+CColCFEt9
         Do4KgnaPuPxS99u7TND1KS7HAI3GHwcEc7o3DhsZ97Ba7OV0L0kbJIrAG1rQkI9xx6
         CJNGJlTKcYS6Nc0DUAMX1fpswRmmTYMppUbplvgfhJlC5EkNl5BMUtX128D7Rd7764
         lFDJ4Psnq1V8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George Shen <george.shen@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 20/36] drm/amd/display: Fix DPCD translation for LTTPR AUX_RD_INTERVAL
Date:   Mon,  8 Feb 2021 12:57:50 -0500
Message-Id: <20210208175806.2091668-20-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Shen <george.shen@amd.com>

[ Upstream commit 2b6b7ab4b1cabfbee1af5d818efcab5d51d62c7e ]

[Why]
The translation between the DPCD value and the specified AUX_RD_INTERVAL
in the DP spec do not match.

[How]
Update values to match the spec.

Signed-off-by: George Shen <george.shen@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 17e6fd8201395..32b73ea866737 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -877,13 +877,13 @@ static uint32_t translate_training_aux_read_interval(uint32_t dpcd_aux_read_inte
 
 	switch (dpcd_aux_read_interval) {
 	case 0x01:
-		aux_rd_interval_us = 400;
+		aux_rd_interval_us = 4000;
 		break;
 	case 0x02:
-		aux_rd_interval_us = 4000;
+		aux_rd_interval_us = 8000;
 		break;
 	case 0x03:
-		aux_rd_interval_us = 8000;
+		aux_rd_interval_us = 12000;
 		break;
 	case 0x04:
 		aux_rd_interval_us = 16000;
-- 
2.27.0


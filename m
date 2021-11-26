Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187A945E512
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357989AbhKZCjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:39:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357992AbhKZChR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:37:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7D51611CB;
        Fri, 26 Nov 2021 02:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893970;
        bh=jK80ZHaxoeA8DYw/BapI3GJl6uWcr+lliEp3Ys1Uwmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AyI0I4gXmCtTljydgdR6irJ+LgeXzsTSoSQRSTzw/CFHBWKMCGxJF5uM+0mBrtWvC
         CdPCb8ebi1dbhPeKyi/LMSOCh/PBvW0UdUGk2F6Z7fpaFKOf/o/L78oghwEGFMbVLX
         LG2aUERT0fX8GivdNCjNH+wHDTPRfY8yy69dHlRLkLkdyXB40MuacvS7VXhiHoSWnz
         gGBZAHkUDZk2j9JM2GyedYI4ZO+uhGx/6MDN/sfp3coZ/TV+jlCOxoupc/xQsccXih
         at/yuMo9iaIqBi6h2M3tnxAW2FwA4wnNwqewclCRi1YlM4k6Yr3qw0JLqMlhJdTJcC
         n1Gv0WGgG2Y4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lijo Lazar <lijo.lazar@amd.com>, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        luben.tuikov@amd.com, andrey.grodzovsky@amd.com,
        darren.powell@amd.com, david.nieto@amd.com, lee.jones@linaro.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 24/39] drm/amd/pm: Remove artificial freq level on Navi1x
Date:   Thu, 25 Nov 2021 21:31:41 -0500
Message-Id: <20211126023156.441292-24-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit be83a5676767c99c2417083c29d42aa1e109a69d ]

Print Navi1x fine grained clocks in a consistent manner with other SOCs.
Don't show aritificial DPM level when the current clock equals min or max.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index b1ad451af06bd..dfba0bc732073 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -1265,7 +1265,7 @@ static int navi10_print_clk_levels(struct smu_context *smu,
 			enum smu_clk_type clk_type, char *buf)
 {
 	uint16_t *curve_settings;
-	int i, size = 0, ret = 0;
+	int i, levels, size = 0, ret = 0;
 	uint32_t cur_value = 0, value = 0, count = 0;
 	uint32_t freq_values[3] = {0};
 	uint32_t mark_index = 0;
@@ -1319,14 +1319,17 @@ static int navi10_print_clk_levels(struct smu_context *smu,
 			freq_values[1] = cur_value;
 			mark_index = cur_value == freq_values[0] ? 0 :
 				     cur_value == freq_values[2] ? 2 : 1;
-			if (mark_index != 1)
-				freq_values[1] = (freq_values[0] + freq_values[2]) / 2;
 
-			for (i = 0; i < 3; i++) {
+			levels = 3;
+			if (mark_index != 1) {
+				levels = 2;
+				freq_values[1] = freq_values[2];
+			}
+
+			for (i = 0; i < levels; i++) {
 				size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n", i, freq_values[i],
 						i == mark_index ? "*" : "");
 			}
-
 		}
 		break;
 	case SMU_PCIE:
-- 
2.33.0


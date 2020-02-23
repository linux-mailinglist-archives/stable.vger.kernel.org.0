Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC69169528
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 03:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgBWCVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 21:21:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbgBWCVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 21:21:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAFA0214DB;
        Sun, 23 Feb 2020 02:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424511;
        bh=2REOLpkCJd4hYNiNITF5nO4LqXdwtJyusVRdt6oSl5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C53XMo2VkjduZurMvNdBbfDvQwoeLR1HUTQrwyn4JPBeNcEYTkCvS/hZbn5oZGfSR
         6nOdn5bkUovA315d0G4hQ39H7+01XHQn93zftvfRhMJ0LE0XbBmr8ZuNPgEvf8bkEF
         2GZFVSnyQz6yvlg2dy5tx/7NX/f7Gb77pJ4cMDtg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Isabel Zhang <isabel.zhang@amd.com>,
        Eric Yang <eric.yang2@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 26/58] drm/amd/display: Add initialitions for PLL2 clock source
Date:   Sat, 22 Feb 2020 21:20:47 -0500
Message-Id: <20200223022119.707-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022119.707-1-sashal@kernel.org>
References: <20200223022119.707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Isabel Zhang <isabel.zhang@amd.com>

[ Upstream commit c134c3cabae46a56ab2e1f5e5fa49405e1758838 ]

[Why]
Starting from 14nm, the PLL is built into the PHY and the PLL is mapped
to PHY on 1 to 1 basis. In the code, the DP port is mapped to a PLL that was not
initialized. This causes DP to HDMI dongle to not light up the display.

[How]
Initializations added for PLL2 when creating resources.

Signed-off-by: Isabel Zhang <isabel.zhang@amd.com>
Reviewed-by: Eric Yang <eric.yang2@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index b29b2c99a564e..554062859866d 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -57,6 +57,7 @@
 #include "dcn20/dcn20_dccg.h"
 #include "dcn21_hubbub.h"
 #include "dcn10/dcn10_resource.h"
+#include "dce110/dce110_resource.h"
 
 #include "dcn20/dcn20_dwb.h"
 #include "dcn20/dcn20_mmhubbub.h"
@@ -866,6 +867,7 @@ static const struct dc_debug_options debug_defaults_diags = {
 enum dcn20_clk_src_array_id {
 	DCN20_CLK_SRC_PLL0,
 	DCN20_CLK_SRC_PLL1,
+	DCN20_CLK_SRC_PLL2,
 	DCN20_CLK_SRC_TOTAL_DCN21
 };
 
@@ -1736,6 +1738,10 @@ static bool construct(
 			dcn21_clock_source_create(ctx, ctx->dc_bios,
 				CLOCK_SOURCE_COMBO_PHY_PLL1,
 				&clk_src_regs[1], false);
+	pool->base.clock_sources[DCN20_CLK_SRC_PLL2] =
+			dcn21_clock_source_create(ctx, ctx->dc_bios,
+				CLOCK_SOURCE_COMBO_PHY_PLL2,
+				&clk_src_regs[2], false);
 
 	pool->base.clk_src_count = DCN20_CLK_SRC_TOTAL_DCN21;
 
-- 
2.20.1


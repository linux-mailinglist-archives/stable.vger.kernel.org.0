Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C05F9C9106
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 20:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbfJBSmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 14:42:32 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43186 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfJBSmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 14:42:32 -0400
Received: by mail-qk1-f194.google.com with SMTP id h126so16060001qke.10
        for <stable@vger.kernel.org>; Wed, 02 Oct 2019 11:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cf+Bdnxm3JIWcdjnCC6fu4seVwvniwjw8dH7hROC3zM=;
        b=gHsQqR3tIRx395oeP7qhfk9wuQYNyAWd89gb9kDza6aAOvxNZSqyZh1hNWwW8NyXZz
         IFpUTnUywFaX7ifdnoDx1BBwJ6MKSoCtMcRL3bohxgmjR26sx9cveO2uOQCYELmhU+o8
         PZAK/GlXicVW8LaqS9zTyO1G33WEPsrDwO3XXkGIVHwUqVqQ/DAOVBjKrhFnRP0pBEgT
         VkAlJyy6qfstvQF6Vr2lPOImNZciFGr8QjPlIpNuM0q1yizUY59oRInwnXtp5lJhDLep
         6KW4g+cFA/Kq6tffg6D5B3U2iQf0AjAsC5tEmbYY+pe9PtJFVwjI3MuHumdwniMB1tBX
         S5/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cf+Bdnxm3JIWcdjnCC6fu4seVwvniwjw8dH7hROC3zM=;
        b=UHHwj5WwDgPs1DQBUKvrEIjo0Ff/p0mfkXdb6nU9fHkqUpOSvSVR+8pLUhH/MeZ5Dh
         Vv2PVSF6SFl3/c2Ia02K1LzK283NbidqLXFwExaLKDU03RPNt1SXVvtNH9Tv4DGBPH5t
         UBSdn9Mab2Nio4At6YMp6YIoAeJKhmvGCVxbnr5mc1eQszwpT2sZFuZ1Qm7zLZRlwRxO
         oEmlHRxJx4u1/uC1UtDhxjdToxFIng6W54MDRanuEzK0jkkZLQSiyxXB2JsWxbhr7V34
         rNBqgeATKwQ8RtgXpHDtJEVBTQuxp/qPwwqXl5qt6QC39HrtlATMP5FXpXpVHWrI5Iwt
         sd4Q==
X-Gm-Message-State: APjAAAV41C0Vv0v2ufD7kNqsWczfrxyLTyfxICT2/9Ptun+YIutiaybm
        k9S96T3hyL/rgSSerni5rpenJxM5
X-Google-Smtp-Source: APXvYqxSTNt1u1CaCRIwy/ty/O8o4eNOC4aR3uZdUfWp6KJHj3YR4RVqrErzRYLke4ZCB0mMdEKnTA==
X-Received: by 2002:ae9:ee0d:: with SMTP id i13mr162046qkg.417.1570041749207;
        Wed, 02 Oct 2019 11:42:29 -0700 (PDT)
Received: from localhost.localdomain ([71.219.73.178])
        by smtp.gmail.com with ESMTPSA id n125sm1178qkn.129.2019.10.02.11.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 11:42:28 -0700 (PDT)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Zhan Liu <zhan.liu@amd.com>, Roman Li <Roman.Li@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 2/3] drm/amd/display: Add missing HBM support and raise Vega20's uclk.
Date:   Wed,  2 Oct 2019 13:42:18 -0500
Message-Id: <20191002184219.4011-3-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002184219.4011-1-alexander.deucher@amd.com>
References: <20191002184219.4011-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhan Liu <zhan.liu@amd.com>

[Why]
When more than 2 displays are connected to the graphics card,
only the minimum memory clock is needed. However, when more
displays are connected, the minimum memory clock is not
sufficient enough to support the overwhelming bandwidth.
System will hang under this circumstance.

Also, the old code didn't address HBM cards, which has 2
pseudo channels. We need to add the HBM part here.

[How]
When graphics card connects to 2 or more displays,
switch to high memory clock. Also, choose memory
multiplier based on whether its regular DRAM or HBM.

Signed-off-by: Zhan Liu <zhan.liu@amd.com>
Reviewed-by: Roman Li <Roman.Li@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c02d6a161395dfc0c2fdabb9e976a229017288d8)
cc: stable@vger.kernel.org # 5.3.x
---
 .../display/dc/clk_mgr/dce110/dce110_clk_mgr.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
index ee32d2c19305..36277bca0326 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
@@ -174,6 +174,10 @@ void dce11_pplib_apply_display_requirements(
 	struct dc_state *context)
 {
 	struct dm_pp_display_configuration *pp_display_cfg = &context->pp_display_cfg;
+	int memory_type_multiplier = MEMORY_TYPE_MULTIPLIER_CZ;
+
+	if (dc->bw_vbios && dc->bw_vbios->memory_type == bw_def_hbm)
+		memory_type_multiplier = MEMORY_TYPE_HBM;
 
 	pp_display_cfg->all_displays_in_sync =
 		context->bw_ctx.bw.dce.all_displays_in_sync;
@@ -186,8 +190,18 @@ void dce11_pplib_apply_display_requirements(
 	pp_display_cfg->cpu_pstate_separation_time =
 			context->bw_ctx.bw.dce.blackout_recovery_time_us;
 
-	pp_display_cfg->min_memory_clock_khz = context->bw_ctx.bw.dce.yclk_khz
-		/ MEMORY_TYPE_MULTIPLIER_CZ;
+	/*
+	 * TODO: determine whether the bandwidth has reached memory's limitation
+	 * , then change minimum memory clock based on real-time bandwidth
+	 * limitation.
+	 */
+	if (ASICREV_IS_VEGA20_P(dc->ctx->asic_id.hw_internal_rev) && (context->stream_count >= 2)) {
+		pp_display_cfg->min_memory_clock_khz = max(pp_display_cfg->min_memory_clock_khz,
+			(uint32_t) (dc->bw_vbios->high_yclk.value / memory_type_multiplier / 10000));
+	} else {
+		pp_display_cfg->min_memory_clock_khz = context->bw_ctx.bw.dce.yclk_khz
+			/ memory_type_multiplier;
+	}
 
 	pp_display_cfg->min_engine_clock_khz = determine_sclk_from_bounding_box(
 			dc,
-- 
2.20.1


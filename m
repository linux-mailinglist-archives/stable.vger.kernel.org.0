Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFED64CF6F2
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237770AbiCGJnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239567AbiCGJjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:39:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB305723E2;
        Mon,  7 Mar 2022 01:35:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB13C612D3;
        Mon,  7 Mar 2022 09:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44F7C36AF3;
        Mon,  7 Mar 2022 09:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645730;
        bh=4elDJmekbpHSuGzdCGnNgGITkMRxnGVlgc0WvZ0hlY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gviEJugfmMFEZvIYJ7+1JuurM4uB1pJgbD4TBn/Ym5SRqoN9ZzWLftTT/Z0OJsPU8
         us2wzJywoFL6V9jsMAOlGwgvv58GSDlpYUpI7dsOqmptNGoT8wQ6aJsrHOCE1D4UF6
         1J1/7DfCe5nMWz2RC+qMuBGae7T6TnTKFGjmMyPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/262] drm/amd/pm: correct UMD pstate clocks for Dimgrey Cavefish and Beige Goby
Date:   Mon,  7 Mar 2022 10:16:03 +0100
Message-Id: <20220307091702.916393646@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 0136f5844b006e2286f873457c3fcba8c45a3735 ]

Correct the UMD pstate profiling clocks for Dimgrey Cavefish and Beige
Goby.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/pm/swsmu/smu11/sienna_cichlid_ppt.c   | 26 +++++++++++++++----
 .../amd/pm/swsmu/smu11/sienna_cichlid_ppt.h   |  8 ++++++
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index b8896882b6f01..574a9d7f7a5e7 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -1308,21 +1308,37 @@ static int sienna_cichlid_populate_umd_state_clk(struct smu_context *smu)
 				&dpm_context->dpm_tables.soc_table;
 	struct smu_umd_pstate_table *pstate_table =
 				&smu->pstate_table;
+	struct amdgpu_device *adev = smu->adev;
 
 	pstate_table->gfxclk_pstate.min = gfx_table->min;
 	pstate_table->gfxclk_pstate.peak = gfx_table->max;
-	if (gfx_table->max >= SIENNA_CICHLID_UMD_PSTATE_PROFILING_GFXCLK)
-		pstate_table->gfxclk_pstate.standard = SIENNA_CICHLID_UMD_PSTATE_PROFILING_GFXCLK;
 
 	pstate_table->uclk_pstate.min = mem_table->min;
 	pstate_table->uclk_pstate.peak = mem_table->max;
-	if (mem_table->max >= SIENNA_CICHLID_UMD_PSTATE_PROFILING_MEMCLK)
-		pstate_table->uclk_pstate.standard = SIENNA_CICHLID_UMD_PSTATE_PROFILING_MEMCLK;
 
 	pstate_table->socclk_pstate.min = soc_table->min;
 	pstate_table->socclk_pstate.peak = soc_table->max;
-	if (soc_table->max >= SIENNA_CICHLID_UMD_PSTATE_PROFILING_SOCCLK)
+
+	switch (adev->asic_type) {
+	case CHIP_SIENNA_CICHLID:
+	case CHIP_NAVY_FLOUNDER:
+		pstate_table->gfxclk_pstate.standard = SIENNA_CICHLID_UMD_PSTATE_PROFILING_GFXCLK;
+		pstate_table->uclk_pstate.standard = SIENNA_CICHLID_UMD_PSTATE_PROFILING_MEMCLK;
 		pstate_table->socclk_pstate.standard = SIENNA_CICHLID_UMD_PSTATE_PROFILING_SOCCLK;
+		break;
+	case CHIP_DIMGREY_CAVEFISH:
+		pstate_table->gfxclk_pstate.standard = DIMGREY_CAVEFISH_UMD_PSTATE_PROFILING_GFXCLK;
+		pstate_table->uclk_pstate.standard = DIMGREY_CAVEFISH_UMD_PSTATE_PROFILING_MEMCLK;
+		pstate_table->socclk_pstate.standard = DIMGREY_CAVEFISH_UMD_PSTATE_PROFILING_SOCCLK;
+		break;
+	case CHIP_BEIGE_GOBY:
+		pstate_table->gfxclk_pstate.standard = BEIGE_GOBY_UMD_PSTATE_PROFILING_GFXCLK;
+		pstate_table->uclk_pstate.standard = BEIGE_GOBY_UMD_PSTATE_PROFILING_MEMCLK;
+		pstate_table->socclk_pstate.standard = BEIGE_GOBY_UMD_PSTATE_PROFILING_SOCCLK;
+		break;
+	default:
+		break;
+	}
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.h b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.h
index 38cd0ece24f6b..42f705c7a36f8 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.h
@@ -33,6 +33,14 @@ typedef enum {
 #define SIENNA_CICHLID_UMD_PSTATE_PROFILING_SOCCLK    960
 #define SIENNA_CICHLID_UMD_PSTATE_PROFILING_MEMCLK    1000
 
+#define DIMGREY_CAVEFISH_UMD_PSTATE_PROFILING_GFXCLK 1950
+#define DIMGREY_CAVEFISH_UMD_PSTATE_PROFILING_SOCCLK 960
+#define DIMGREY_CAVEFISH_UMD_PSTATE_PROFILING_MEMCLK 676
+
+#define BEIGE_GOBY_UMD_PSTATE_PROFILING_GFXCLK 2200
+#define BEIGE_GOBY_UMD_PSTATE_PROFILING_SOCCLK 960
+#define BEIGE_GOBY_UMD_PSTATE_PROFILING_MEMCLK 1000
+
 extern void sienna_cichlid_set_ppt_funcs(struct smu_context *smu);
 
 #endif
-- 
2.34.1




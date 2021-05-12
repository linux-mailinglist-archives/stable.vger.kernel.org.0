Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FE537C52C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhELPih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233109AbhELPar (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:30:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CAA96194B;
        Wed, 12 May 2021 15:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832552;
        bh=odfnY8xooEd2IfWDub5iWqX4NvfRi3NFV1qhd3pOM8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aqhk7LLr4NLtTDKVpH+C0mHbFeMuqRPx+knsdls2/szWs5cNW+satF8xLzF6f7ZC6
         DK+9TPI/NNJ6M2UrWtuXm0AfnfwVUKH10q84hCF9+cAL7olPmzg16HOyWIdk9VnXhK
         xw6g68nHkxjK83Z7wHvjOFlIEpVqd00zekFH8JVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Nirmoy Das <nirmoy.das@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 325/530] drm/amd/display: use GFP_ATOMIC in dcn20_resource_construct
Date:   Wed, 12 May 2021 16:47:15 +0200
Message-Id: <20210512144830.490715384@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@amd.com>

[ Upstream commit 3bb1105071fb974e3e3ca2f92ddfd69c81285ab6 ]

Replace GFP_KERNEL with GFP_ATOMIC as dcn20_resource_construct()
can't sleep.

Partially fixes: https://bugzilla.kernel.org/show_bug.cgi?id=212311
as dcn20_resource_construct() also calls into SMU functions which does
mutex_lock().

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_abm.c  |  2 +-
 drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c |  6 ++---
 .../gpu/drm/amd/display/dc/dcn20/dcn20_dccg.c |  2 +-
 .../drm/amd/display/dc/dcn20/dcn20_resource.c | 26 +++++++++----------
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c b/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
index 4e87e70237e3..874b132fe1d7 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
@@ -283,7 +283,7 @@ struct abm *dce_abm_create(
 	const struct dce_abm_shift *abm_shift,
 	const struct dce_abm_mask *abm_mask)
 {
-	struct dce_abm *abm_dce = kzalloc(sizeof(*abm_dce), GFP_KERNEL);
+	struct dce_abm *abm_dce = kzalloc(sizeof(*abm_dce), GFP_ATOMIC);
 
 	if (abm_dce == NULL) {
 		BREAK_TO_DEBUGGER();
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c b/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c
index f0cebe721bcc..4216419503af 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c
@@ -925,7 +925,7 @@ struct dmcu *dcn10_dmcu_create(
 	const struct dce_dmcu_shift *dmcu_shift,
 	const struct dce_dmcu_mask *dmcu_mask)
 {
-	struct dce_dmcu *dmcu_dce = kzalloc(sizeof(*dmcu_dce), GFP_KERNEL);
+	struct dce_dmcu *dmcu_dce = kzalloc(sizeof(*dmcu_dce), GFP_ATOMIC);
 
 	if (dmcu_dce == NULL) {
 		BREAK_TO_DEBUGGER();
@@ -946,7 +946,7 @@ struct dmcu *dcn20_dmcu_create(
 	const struct dce_dmcu_shift *dmcu_shift,
 	const struct dce_dmcu_mask *dmcu_mask)
 {
-	struct dce_dmcu *dmcu_dce = kzalloc(sizeof(*dmcu_dce), GFP_KERNEL);
+	struct dce_dmcu *dmcu_dce = kzalloc(sizeof(*dmcu_dce), GFP_ATOMIC);
 
 	if (dmcu_dce == NULL) {
 		BREAK_TO_DEBUGGER();
@@ -967,7 +967,7 @@ struct dmcu *dcn21_dmcu_create(
 	const struct dce_dmcu_shift *dmcu_shift,
 	const struct dce_dmcu_mask *dmcu_mask)
 {
-	struct dce_dmcu *dmcu_dce = kzalloc(sizeof(*dmcu_dce), GFP_KERNEL);
+	struct dce_dmcu *dmcu_dce = kzalloc(sizeof(*dmcu_dce), GFP_ATOMIC);
 
 	if (dmcu_dce == NULL) {
 		BREAK_TO_DEBUGGER();
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dccg.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dccg.c
index 62cc2651e00c..8774406120fc 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dccg.c
@@ -112,7 +112,7 @@ struct dccg *dccg2_create(
 	const struct dccg_shift *dccg_shift,
 	const struct dccg_mask *dccg_mask)
 {
-	struct dcn_dccg *dccg_dcn = kzalloc(sizeof(*dccg_dcn), GFP_KERNEL);
+	struct dcn_dccg *dccg_dcn = kzalloc(sizeof(*dccg_dcn), GFP_ATOMIC);
 	struct dccg *base;
 
 	if (dccg_dcn == NULL) {
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index 4ea53c543e08..33488b3c5c3c 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -1104,7 +1104,7 @@ struct dpp *dcn20_dpp_create(
 	uint32_t inst)
 {
 	struct dcn20_dpp *dpp =
-		kzalloc(sizeof(struct dcn20_dpp), GFP_KERNEL);
+		kzalloc(sizeof(struct dcn20_dpp), GFP_ATOMIC);
 
 	if (!dpp)
 		return NULL;
@@ -1122,7 +1122,7 @@ struct input_pixel_processor *dcn20_ipp_create(
 	struct dc_context *ctx, uint32_t inst)
 {
 	struct dcn10_ipp *ipp =
-		kzalloc(sizeof(struct dcn10_ipp), GFP_KERNEL);
+		kzalloc(sizeof(struct dcn10_ipp), GFP_ATOMIC);
 
 	if (!ipp) {
 		BREAK_TO_DEBUGGER();
@@ -1139,7 +1139,7 @@ struct output_pixel_processor *dcn20_opp_create(
 	struct dc_context *ctx, uint32_t inst)
 {
 	struct dcn20_opp *opp =
-		kzalloc(sizeof(struct dcn20_opp), GFP_KERNEL);
+		kzalloc(sizeof(struct dcn20_opp), GFP_ATOMIC);
 
 	if (!opp) {
 		BREAK_TO_DEBUGGER();
@@ -1156,7 +1156,7 @@ struct dce_aux *dcn20_aux_engine_create(
 	uint32_t inst)
 {
 	struct aux_engine_dce110 *aux_engine =
-		kzalloc(sizeof(struct aux_engine_dce110), GFP_KERNEL);
+		kzalloc(sizeof(struct aux_engine_dce110), GFP_ATOMIC);
 
 	if (!aux_engine)
 		return NULL;
@@ -1194,7 +1194,7 @@ struct dce_i2c_hw *dcn20_i2c_hw_create(
 	uint32_t inst)
 {
 	struct dce_i2c_hw *dce_i2c_hw =
-		kzalloc(sizeof(struct dce_i2c_hw), GFP_KERNEL);
+		kzalloc(sizeof(struct dce_i2c_hw), GFP_ATOMIC);
 
 	if (!dce_i2c_hw)
 		return NULL;
@@ -1207,7 +1207,7 @@ struct dce_i2c_hw *dcn20_i2c_hw_create(
 struct mpc *dcn20_mpc_create(struct dc_context *ctx)
 {
 	struct dcn20_mpc *mpc20 = kzalloc(sizeof(struct dcn20_mpc),
-					  GFP_KERNEL);
+					  GFP_ATOMIC);
 
 	if (!mpc20)
 		return NULL;
@@ -1225,7 +1225,7 @@ struct hubbub *dcn20_hubbub_create(struct dc_context *ctx)
 {
 	int i;
 	struct dcn20_hubbub *hubbub = kzalloc(sizeof(struct dcn20_hubbub),
-					  GFP_KERNEL);
+					  GFP_ATOMIC);
 
 	if (!hubbub)
 		return NULL;
@@ -1253,7 +1253,7 @@ struct timing_generator *dcn20_timing_generator_create(
 		uint32_t instance)
 {
 	struct optc *tgn10 =
-		kzalloc(sizeof(struct optc), GFP_KERNEL);
+		kzalloc(sizeof(struct optc), GFP_ATOMIC);
 
 	if (!tgn10)
 		return NULL;
@@ -1332,7 +1332,7 @@ static struct clock_source *dcn20_clock_source_create(
 	bool dp_clk_src)
 {
 	struct dce110_clk_src *clk_src =
-		kzalloc(sizeof(struct dce110_clk_src), GFP_KERNEL);
+		kzalloc(sizeof(struct dce110_clk_src), GFP_ATOMIC);
 
 	if (!clk_src)
 		return NULL;
@@ -1438,7 +1438,7 @@ struct display_stream_compressor *dcn20_dsc_create(
 	struct dc_context *ctx, uint32_t inst)
 {
 	struct dcn20_dsc *dsc =
-		kzalloc(sizeof(struct dcn20_dsc), GFP_KERNEL);
+		kzalloc(sizeof(struct dcn20_dsc), GFP_ATOMIC);
 
 	if (!dsc) {
 		BREAK_TO_DEBUGGER();
@@ -1572,7 +1572,7 @@ struct hubp *dcn20_hubp_create(
 	uint32_t inst)
 {
 	struct dcn20_hubp *hubp2 =
-		kzalloc(sizeof(struct dcn20_hubp), GFP_KERNEL);
+		kzalloc(sizeof(struct dcn20_hubp), GFP_ATOMIC);
 
 	if (!hubp2)
 		return NULL;
@@ -3391,7 +3391,7 @@ bool dcn20_mmhubbub_create(struct dc_context *ctx, struct resource_pool *pool)
 
 static struct pp_smu_funcs *dcn20_pp_smu_create(struct dc_context *ctx)
 {
-	struct pp_smu_funcs *pp_smu = kzalloc(sizeof(*pp_smu), GFP_KERNEL);
+	struct pp_smu_funcs *pp_smu = kzalloc(sizeof(*pp_smu), GFP_ATOMIC);
 
 	if (!pp_smu)
 		return pp_smu;
@@ -4142,7 +4142,7 @@ struct resource_pool *dcn20_create_resource_pool(
 		struct dc *dc)
 {
 	struct dcn20_resource_pool *pool =
-		kzalloc(sizeof(struct dcn20_resource_pool), GFP_KERNEL);
+		kzalloc(sizeof(struct dcn20_resource_pool), GFP_ATOMIC);
 
 	if (!pool)
 		return NULL;
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19FA24C75BF
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbiB1R4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240758AbiB1Rye (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9515133A;
        Mon, 28 Feb 2022 09:43:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 797DFB815AB;
        Mon, 28 Feb 2022 17:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F9BC340E7;
        Mon, 28 Feb 2022 17:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070184;
        bh=14EMimUpj5GZ9KgacRO25ktm5uKqvBSC3sszDYK6NcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdsQIiZtID+G9RdvBtEXDj30u5CcGNwv2GcHVcYuUxujdlMVCEsGVK7ajGohO96bc
         4/vPEQ23MpjNoWTreJUQ07UbgslWC2bYEl+csW0snP3rV+2ISTh8c6Xh4Nbad+IlrW
         kSoJnLE0cAvvkHhzAI9zA7sIYlN2gcs4voSOj39o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 017/164] drm/amd/display: Protect update_bw_bounding_box FPU code.
Date:   Mon, 28 Feb 2022 18:22:59 +0100
Message-Id: <20220228172401.489267046@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

commit 1432108d00e42ffa383240bcac8d58f89ae19104 upstream.

For DCN3/3.01/3.02 at least these use the fpu.

v2: squash in build fix for when DCN is not enabled (Leo)

Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c |    2 ++
 drivers/gpu/drm/amd/display/dc/core/dc.c                     |    7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
@@ -437,8 +437,10 @@ static void dcn3_get_memclk_states_from_
 	clk_mgr_base->bw_params->clk_table.num_entries = num_levels ? num_levels : 1;
 
 	/* Refresh bounding box */
+	DC_FP_START();
 	clk_mgr_base->ctx->dc->res_pool->funcs->update_bw_bounding_box(
 			clk_mgr->base.ctx->dc, clk_mgr_base->bw_params);
+	DC_FP_END();
 }
 
 static bool dcn3_is_smu_present(struct clk_mgr *clk_mgr_base)
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -999,10 +999,13 @@ static bool dc_construct(struct dc *dc,
 		goto fail;
 #ifdef CONFIG_DRM_AMD_DC_DCN
 	dc->clk_mgr->force_smu_not_present = init_params->force_smu_not_present;
-#endif
 
-	if (dc->res_pool->funcs->update_bw_bounding_box)
+	if (dc->res_pool->funcs->update_bw_bounding_box) {
+		DC_FP_START();
 		dc->res_pool->funcs->update_bw_bounding_box(dc, dc->clk_mgr->bw_params);
+		DC_FP_END();
+	}
+#endif
 
 	/* Creation of current_state must occur after dc->dml
 	 * is initialized in dc_create_resource_pool because



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08AC64C7506
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238612AbiB1Rtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238824AbiB1Rrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:47:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D2E9EBAC;
        Mon, 28 Feb 2022 09:38:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2477B815A2;
        Mon, 28 Feb 2022 17:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDEFC340E7;
        Mon, 28 Feb 2022 17:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069888;
        bh=bLLolrOWP7tHtJCgMogA128YNdxA/2Hb5aHAJ4JDUBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLbj7wTV3l2V0JGti3U8qb6q2xySSJTKpvRFPwMLL2079Hlm5eUaTLFoNo6vwHZfw
         j6kMHjR0ASrDLjGDVfihsgztt0W3FmchF7Z0JsmmnXB+FSZjmuvrIsBTrs6vLEJlNa
         E5ZBNKAXfP85GBoYEV02KpVVzpXxAq6NYz52LpCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 015/139] drm/amd/display: Protect update_bw_bounding_box FPU code.
Date:   Mon, 28 Feb 2022 18:23:09 +0100
Message-Id: <20220228172349.290270685@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
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
@@ -891,10 +891,13 @@ static bool dc_construct(struct dc *dc,
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



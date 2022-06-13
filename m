Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86AEC5496AA
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380830AbiFMOHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381405AbiFMOET (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:04:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF3B2BB21;
        Mon, 13 Jun 2022 04:39:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30416B80E2C;
        Mon, 13 Jun 2022 11:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967D8C34114;
        Mon, 13 Jun 2022 11:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120358;
        bh=vWbARA00wjVLuTq3CJWOYllIBl+Aw2U9+t+Gx7wI78k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BScsI7JPOwwca+4gDIsHekfvXlrBOtW8Tev5m5dJnxTdOxIi/Qfv1drzMHERcMoOW
         Kd/p40syI807/cD+9Uq8o0h4ktmK5so/fIBW23hVVUANiu4pbRr8Q6srj2abvGAgmh
         yr3d9RH65ma8fZM2fXwOYmma8NrILh8dbFmh6WF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.18 331/339] drm/amd/display: remove stale config guards
Date:   Mon, 13 Jun 2022 12:12:36 +0200
Message-Id: <20220613094936.780544733@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

commit fd843d03418ead2bba369159bb19b60e9d4b7b1e upstream.

This code should be executed.

Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c |    2 --
 drivers/gpu/drm/amd/display/dc/dml/dml_wrapper.c               |    2 --
 2 files changed, 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
@@ -41,9 +41,7 @@
 
 #include "dc_dmub_srv.h"
 
-#if defined (CONFIG_DRM_AMD_DC_DP2_0)
 #include "dc_link_dp.h"
-#endif
 
 #define TO_CLK_MGR_DCN315(clk_mgr)\
 	container_of(clk_mgr, struct clk_mgr_dcn315, base)
--- a/drivers/gpu/drm/amd/display/dc/dml/dml_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dml_wrapper.c
@@ -1284,10 +1284,8 @@ static bool is_dtbclk_required(struct dc
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {
 		if (!context->res_ctx.pipe_ctx[i].stream)
 			continue;
-#if defined (CONFIG_DRM_AMD_DC_DP2_0)
 		if (is_dp_128b_132b_signal(&context->res_ctx.pipe_ctx[i]))
 			return true;
-#endif
 	}
 	return false;
 }



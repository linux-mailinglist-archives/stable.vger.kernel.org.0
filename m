Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5059463AF7A
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbiK1Rm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbiK1Rld (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:41:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89EE18394;
        Mon, 28 Nov 2022 09:39:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 483B3612E9;
        Mon, 28 Nov 2022 17:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE365C433C1;
        Mon, 28 Nov 2022 17:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657179;
        bh=FdHzm1ZvsF1Ap/UO72Req/MoTEbJHBn8Dzxrp/8s6T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hutTi1Rj/MIaCD4pIu2e2kdgATMjsa464IMNFgLWB3iiB30eg1o1dp+0DgRPH/IRM
         k3J37Hc0672HwqFIBPHNA4sLfF8Kqz1C60G3qDT4mgqDGKT9LmRrId0AlhLhcxIJ+c
         yDvZUvX1QUpyepjd31ulNgM6icNmpvn3FROCRt+5sQ8hPqzCPE8QntPfZzgK1C5r8U
         P01+KaMV63Rg6Azji6XTOkAC+groutkqe+h0zv86uMEp6jokaR2u1BoaRMObjeiPCO
         vCabEKrCrEr9rmY/3SoonrquUYBxqg6GThq7pW7c+L0qf8/EXhIPNfqsWrI/+GGQM1
         l+oSB1ueXNExA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dillon Varone <Dillon.Varone@amd.com>,
        Alvin Lee <Alvin.Lee2@amd.com>,
        Martin Leung <Martin.Leung@amd.com>,
        Brian Chang <Brian.Chang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Jun.Lei@amd.com, Syed.Hassan@amd.com,
        Ethan.Wellenreiter@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 36/39] drm/amd/display: Use viewport height for subvp mall allocation size
Date:   Mon, 28 Nov 2022 12:36:16 -0500
Message-Id: <20221128173642.1441232-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128173642.1441232-1-sashal@kernel.org>
References: <20221128173642.1441232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dillon Varone <Dillon.Varone@amd.com>

[ Upstream commit dd2c028c1395d622df7ddd6837f8ab2dc94008ee ]

[WHY?]
MALL allocation size depends on the viewport height, not the addressable
vertical lines, which will not match when scaling.

[HOW?]
Base MALL allocation size calculations off viewport height.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Acked-by: Brian Chang <Brian.Chang@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
index 13cd1f2e50ca..902c69d126d5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
@@ -101,7 +101,7 @@ uint32_t dcn32_helper_calculate_num_ways_for_subvp(struct dc *dc, struct dc_stat
 			mall_alloc_width_blk_aligned = full_vp_width_blk_aligned;
 
 			/* mall_alloc_height_blk_aligned_l/c = CEILING(sub_vp_height_l/c - 1, blk_height_l/c) + blk_height_l/c */
-			mall_alloc_height_blk_aligned = (pipe->stream->timing.v_addressable - 1 + mblk_height - 1) /
+			mall_alloc_height_blk_aligned = (pipe->plane_res.scl_data.viewport.height - 1 + mblk_height - 1) /
 					mblk_height * mblk_height + mblk_height;
 
 			/* full_mblk_width_ub_l/c = mall_alloc_width_blk_aligned_l/c;
-- 
2.35.1


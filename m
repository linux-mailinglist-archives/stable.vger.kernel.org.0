Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D41E64FF93
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiLRQEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiLRQDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:03:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A6DBF72;
        Sun, 18 Dec 2022 08:02:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3087C60DCE;
        Sun, 18 Dec 2022 16:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66690C433D2;
        Sun, 18 Dec 2022 16:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379360;
        bh=2z2kx3GfS55LxRLsKjgo8pcqfUBZUKUOXS4w7KtOlKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bgt0jytGj7JY/bWy+7M3WDvU8+6DhXmv/ybFuQ6Z7xYq9pvjKUBe8qGRxvcs5Y4HQ
         kfxMVduKOckCznBKpFlPOHpwT8v/Vo0y9wtxhWU7Yk5I8t0OhPuTv7vRzBtuHT5hum
         FLAV6A4BIHhApKb+QBUAlL0XI9rZwTMUHjtmb+c5Ps+QV2J0rHaQYSG2btvZG9ucmP
         ++AjSXn+IzIlFA6LPjRwMerwDN+DQZIzoXC4gDHtp6uu/JD7HUumlKHELvTcj9jlR7
         +Ra3nrFGMBZ+SmILs/TmFMtqKMiefYvGrJ2v15MQG1y4DMV1J1pWef6oJFN+tNRour
         WsB04VvRhWFNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhikzhai <zhikai.zhai@amd.com>,
        Mark Broadworth <mark.broadworth@amd.com>,
        Dillon Varone <Dillon.Varone@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com,
        airlied@gmail.com, daniel@ffwll.ch, Jun.Lei@amd.com,
        Alvin.Lee2@amd.com, HaoPing.Liu@amd.com,
        meenakshikumar.somasundaram@amd.com, Samson.Tam@amd.com,
        wenjing.liu@amd.com, alex.hung@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 12/85] drm/amd/display: skip commit minimal transition state
Date:   Sun, 18 Dec 2022 11:00:29 -0500
Message-Id: <20221218160142.925394-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
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

From: zhikzhai <zhikai.zhai@amd.com>

[ Upstream commit 1e8fd864afdc7a52df375e888a03b8472fc24f5d ]

[WHY]
Now dynamic ODM will now be disabled when MPO is required safe
transitions to avoid underflow, but we are triggering the way of minimal
transition too often. Commit state of dc with no check will do pipeline
setup which may re-initialize the component with no need such as audio.

[HOW]
Just do the minimal transition when all of pipes are in use, otherwise
return true to skip.

Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Dillon Varone <Dillon.Varone@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: zhikzhai <zhikai.zhai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 997ab031f816..5c00907099c1 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3650,10 +3650,32 @@ static bool commit_minimal_transition_state(struct dc *dc,
 	bool temp_subvp_policy;
 	enum dc_status ret = DC_ERROR_UNEXPECTED;
 	unsigned int i, j;
+	unsigned int pipe_in_use = 0;
 
 	if (!transition_context)
 		return false;
 
+	/* check current pipes in use*/
+	for (i = 0; i < dc->res_pool->pipe_count; i++) {
+		struct pipe_ctx *pipe = &transition_base_context->res_ctx.pipe_ctx[i];
+
+		if (pipe->plane_state)
+			pipe_in_use++;
+	}
+
+	/* When the OS add a new surface if we have been used all of pipes with odm combine
+	 * and mpc split feature, it need use commit_minimal_transition_state to transition safely.
+	 * After OS exit MPO, it will back to use odm and mpc split with all of pipes, we need
+	 * call it again. Otherwise return true to skip.
+	 *
+	 * Reduce the scenarios to use dc_commit_state_no_check in the stage of flip. Especially
+	 * enter/exit MPO when DCN still have enough resources.
+	 */
+	if (pipe_in_use != dc->res_pool->pipe_count) {
+		dc_release_state(transition_context);
+		return true;
+	}
+
 	if (!dc->config.is_vmin_only_asic) {
 		tmp_mpc_policy = dc->debug.pipe_split_policy;
 		dc->debug.pipe_split_policy = MPC_SPLIT_AVOID;
-- 
2.35.1


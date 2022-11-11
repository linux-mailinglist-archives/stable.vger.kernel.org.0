Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F7D62508C
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiKKCgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbiKKCgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:36:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08573CE13;
        Thu, 10 Nov 2022 18:34:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 904FA61E87;
        Fri, 11 Nov 2022 02:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FFDC433B5;
        Fri, 11 Nov 2022 02:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134095;
        bh=oidhLC0L4GAvaunSYFFtf10iPFYKvphjPeoVXma+CRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1Uza1uvPt0PIm7fGK7q0UhxAJ+wf7XKXNtBliGQbjhyKWFt2/38nXNBXxob8dbPw
         W2tcG0wm0GcxNKY5ZwKsk+YZ2SyQvSwzE0iTGDShQFNONIr25iJ24l3LTWcir+JKZU
         t+xgjzgkdk/y4sF6a5pzIM4Io5HbyBtM5eym9tRCORMud0Du2v9ftICl8MIHuVRHwf
         zR1DOIc2mDQ8BvNULjtP+sqMCcSWsoTHyoTq7uT1CPP12Bo0mnOPuuO83klVllc3+M
         xpEX+EKmnFL/91rhusVSuPGvR7Lcn5xMD25s6hV5RH1+gJ7dt8SF1LISa9MiYPMdu7
         AYhBURLbODv1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George Shen <george.shen@amd.com>, Alvin Lee <Alvin.Lee2@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        Mark Broadworth <mark.broadworth@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, jiapeng.chong@linux.alibaba.com,
        aurabindo.pillai@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 24/30] drm/amd/display: Round up DST_after_scaler to nearest int
Date:   Thu, 10 Nov 2022 21:33:32 -0500
Message-Id: <20221111023340.227279-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
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

From: George Shen <george.shen@amd.com>

[ Upstream commit 8dc323133d74518e3b5b07242e2b2f088799ea6e ]

[Why]
The DST_after_scaler value that DML spreadsheet outputs is
generally the driver value round up to the nearest int.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
index a1276f6b9581..395ae8761980 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
@@ -291,8 +291,8 @@ void dml32_rq_dlg_get_dlg_reg(struct display_mode_lib *mode_lib,
 
 	dml_print("DML_DLG: %s: vready_after_vcount0 = %d\n", __func__, dlg_regs->vready_after_vcount0);
 
-	dst_x_after_scaler = get_dst_x_after_scaler(mode_lib, e2e_pipe_param, num_pipes, pipe_idx);
-	dst_y_after_scaler = get_dst_y_after_scaler(mode_lib, e2e_pipe_param, num_pipes, pipe_idx);
+	dst_x_after_scaler = dml_ceil(get_dst_x_after_scaler(mode_lib, e2e_pipe_param, num_pipes, pipe_idx), 1);
+	dst_y_after_scaler = dml_ceil(get_dst_y_after_scaler(mode_lib, e2e_pipe_param, num_pipes, pipe_idx), 1);
 
 	// do some adjustment on the dst_after scaler to account for odm combine mode
 	dml_print("DML_DLG: %s: input dst_x_after_scaler   = %d\n", __func__, dst_x_after_scaler);
-- 
2.35.1


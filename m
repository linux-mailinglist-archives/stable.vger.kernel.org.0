Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EB058FFA0
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbiHKPcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235862AbiHKPb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:31:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512D185A89;
        Thu, 11 Aug 2022 08:30:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5108615FE;
        Thu, 11 Aug 2022 15:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65334C433D6;
        Thu, 11 Aug 2022 15:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231846;
        bh=fryF2K+6C57uC+nNGZ3xhsVa5xsK6PpfOvIDAELGqu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E47K3/OKz1q6iZNPcwjuahy9UxFJuNeG4qNLKIm5y9QPIF2W2qkC0SxZD52nDKvaD
         XU3hbGXIDbeOFDLSwIOYoJzULFI8QMsE2RKDt2SfxWD46MDstEx80t++cpldIeKEhb
         FcJz8T/jD/oBadBb1mlQn7RpLoQTCDA/TsLIvFI+AGGhO8QZ5mTbn82SKFglEH8Txr
         uTph1Q+NN2YS8+IJ9KAroa3tuqt+XxIEGCtKANxDY/u4cENXnZDAMr5Z8hTxKuz5m5
         XXavMNcxFn4LytLgdxajddaQBxj5ExA912aNXmgRUC50mr/sQ8POiguxUkSNT+lJvQ
         EM5vxNIpx0ncQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duncan Ma <duncan.ma@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, alex.hung@amd.com, mwen@igalia.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 016/105] drm/amd/display: Correct min comp buffer size
Date:   Thu, 11 Aug 2022 11:27:00 -0400
Message-Id: <20220811152851.1520029-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duncan Ma <duncan.ma@amd.com>

[ Upstream commit 0c56705d8aae9696348cc320b71d531ede001b79 ]

[Why]
In 3-way mpo pipes, there is a case that we
overbook the CRB buffer size. At rare instances,
overbooking the crb will cause underflow. This only
happens when det_size changes dynamically
based on pipe_cnt.

[How]
Set min compbuff size to 1 segment when preparing BW.

Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Duncan Ma <duncan.ma@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c
index 54db2eca9e6b..1b02f0ebe957 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c
@@ -201,7 +201,7 @@ struct _vcs_dpi_ip_params_st dcn3_15_ip = {
 	.hostvm_max_page_table_levels = 2,
 	.rob_buffer_size_kbytes = 64,
 	.det_buffer_size_kbytes = DCN3_15_DEFAULT_DET_SIZE,
-	.min_comp_buffer_size_kbytes = DCN3_15_MIN_COMPBUF_SIZE_KB,
+	.min_comp_buffer_size_kbytes = 64,
 	.config_return_buffer_size_in_kbytes = 1024,
 	.compressed_buffer_segment_size_in_kbytes = 64,
 	.meta_fifo_size_in_kentries = 32,
@@ -297,6 +297,7 @@ struct _vcs_dpi_ip_params_st dcn3_16_ip = {
 	.hostvm_max_page_table_levels = 2,
 	.rob_buffer_size_kbytes = 64,
 	.det_buffer_size_kbytes = DCN3_16_DEFAULT_DET_SIZE,
+	.min_comp_buffer_size_kbytes = 64,
 	.config_return_buffer_size_in_kbytes = 1024,
 	.compressed_buffer_segment_size_in_kbytes = 64,
 	.meta_fifo_size_in_kentries = 32,
-- 
2.35.1


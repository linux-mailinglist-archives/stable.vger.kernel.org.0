Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBDC4CF6EF
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbiCGJna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241074AbiCGJlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B767E674C6;
        Mon,  7 Mar 2022 01:39:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F2CFB8102B;
        Mon,  7 Mar 2022 09:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C7EC340E9;
        Mon,  7 Mar 2022 09:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645994;
        bh=mwHGz5my3kdOnsfHVXD1eY4BLPH1ibOUm3wCthFc8UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C06GmzR2eQU57997rx9H1fXNAtU+JwPyIvmT6jW2rxzEsB2kRMRBDePwO/maPwR31
         66UUJI9VoYVqNQPz5/Al00Z4dG/uZwjM+RsKcSU/O+8QXK5MdL8QdELoD9GiKyqoV2
         /2KBH0CVDI4tknzByi0I1O/95faD3RZHkkidaLms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/262] drm/amd/display: Wrap dcn301_calculate_wm_and_dlg for FPU.
Date:   Mon,  7 Mar 2022 10:17:26 +0100
Message-Id: <20220307091705.356758501@linuxfoundation.org>
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

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

[ Upstream commit 25f1488bdbba63415239ff301fe61a8546140d9f ]

Mirrors the logic for dcn30. Cue lots of WARNs and some
kernel panics without this fix.

Cc: stable@vger.kernel.org
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dcn301/dcn301_resource.c   | 11 +++++++++++
 .../gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c    |  2 +-
 .../gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.h    |  2 +-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
index d17994bb318f7..34b01cc8f548b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -1387,6 +1387,17 @@ static void set_wm_ranges(
 	pp_smu->nv_funcs.set_wm_ranges(&pp_smu->nv_funcs.pp_smu, &ranges);
 }
 
+static void dcn301_calculate_wm_and_dlg(
+		struct dc *dc, struct dc_state *context,
+		display_e2e_pipe_params_st *pipes,
+		int pipe_cnt,
+		int vlevel)
+{
+	DC_FP_START();
+	dcn301_calculate_wm_and_dlg_fp(dc, context, pipes, pipe_cnt, vlevel);
+	DC_FP_END();
+}
+
 static struct resource_funcs dcn301_res_pool_funcs = {
 	.destroy = dcn301_destroy_resource_pool,
 	.link_enc_create = dcn301_link_encoder_create,
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c
index 94c32832a0e7b..0a7a338649731 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c
@@ -327,7 +327,7 @@ void dcn301_fpu_init_soc_bounding_box(struct bp_soc_bb_info bb_info)
 		dcn3_01_soc.sr_exit_time_us = bb_info.dram_sr_exit_latency_100ns * 10;
 }
 
-void dcn301_calculate_wm_and_dlg(struct dc *dc,
+void dcn301_calculate_wm_and_dlg_fp(struct dc *dc,
 		struct dc_state *context,
 		display_e2e_pipe_params_st *pipes,
 		int pipe_cnt,
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.h b/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.h
index fc7065d178422..774b0fdfc80be 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.h
@@ -34,7 +34,7 @@ void dcn301_fpu_set_wm_ranges(int i,
 
 void dcn301_fpu_init_soc_bounding_box(struct bp_soc_bb_info bb_info);
 
-void dcn301_calculate_wm_and_dlg(struct dc *dc,
+void dcn301_calculate_wm_and_dlg_fp(struct dc *dc,
 		struct dc_state *context,
 		display_e2e_pipe_params_st *pipes,
 		int pipe_cnt,
-- 
2.34.1




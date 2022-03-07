Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67274D0296
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 16:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiCGPVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 10:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237565AbiCGPVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 10:21:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689CD6D4DD
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 07:20:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BBADB815E0
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 15:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CEDC340E9;
        Mon,  7 Mar 2022 15:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646666403;
        bh=rOGo01Ur6Xn5fBbTaPJc0FpG7fxhDIuDDd5Gjs4OlTk=;
        h=Subject:To:Cc:From:Date:From;
        b=NBmZoaDvLSXuYM+5eEA8TTrxIF+3PQiuX4BWcINCo+jTX4Sxi0hsOFqt4DEXL4iAF
         x8J2YIrr5pc9NA/XSzm10N8o26reuny9cIAC3aP0F97FxwFOOlfOy1xC7WNgl6ubrV
         1F/t1QE1sDYpj8j4laK+Yl2VJgjnCQKCCcTGB6c8=
Subject: FAILED: patch "[PATCH] drm/amd/display: Wrap dcn301_calculate_wm_and_dlg for FPU." failed to apply to 5.15-stable tree
To:     bas@basnieuwenhuizen.nl, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Mar 2022 16:20:01 +0100
Message-ID: <164666640152219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 25f1488bdbba63415239ff301fe61a8546140d9f Mon Sep 17 00:00:00 2001
From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Date: Mon, 24 Jan 2022 01:23:36 +0100
Subject: [PATCH] drm/amd/display: Wrap dcn301_calculate_wm_and_dlg for FPU.

Mirrors the logic for dcn30. Cue lots of WARNs and some
kernel panics without this fix.

Cc: stable@vger.kernel.org
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
index b4001233867c..5d9637b07429 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -1380,6 +1380,17 @@ static void set_wm_ranges(
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
index 94c32832a0e7..0a7a33864973 100644
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
index fc7065d17842..774b0fdfc80b 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.h
@@ -34,7 +34,7 @@ void dcn301_fpu_set_wm_ranges(int i,
 
 void dcn301_fpu_init_soc_bounding_box(struct bp_soc_bb_info bb_info);
 
-void dcn301_calculate_wm_and_dlg(struct dc *dc,
+void dcn301_calculate_wm_and_dlg_fp(struct dc *dc,
 		struct dc_state *context,
 		display_e2e_pipe_params_st *pipes,
 		int pipe_cnt,


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBBC4A4356
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359286AbiAaLVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35162 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376700AbiAaLRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:17:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 829C4B82A69;
        Mon, 31 Jan 2022 11:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE1FC340E8;
        Mon, 31 Jan 2022 11:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627858;
        bh=lYE0kPtmAxVnvZiILyZXlKVGIUYUal1vKVXiK+ZR2cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oH5UMKI6+J9bGgGygz/tPE/jByeuI9noOn8IWDP5muIvcuvlXmxHQ5AiqJoFq7nOn
         1s3rmtmuhxEmKvqnGUsrRiT6R+C9aGQOHna4rI/UJUv5O7xQ+jR9I4ZjsH6lsmF5EC
         o6P4iC8fCk3iYS3j9y78aM7MoQIjchLTaykhUh30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 047/200] drm/amd/display: Wrap dcn301_calculate_wm_and_dlg for FPU.
Date:   Mon, 31 Jan 2022 11:55:10 +0100
Message-Id: <20220131105235.140761493@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

commit 25f1488bdbba63415239ff301fe61a8546140d9f upstream.

Mirrors the logic for dcn30. Cue lots of WARNs and some
kernel panics without this fix.

Cc: stable@vger.kernel.org
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c |   11 +++++++++++
 drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c  |    2 +-
 drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.h  |    2 +-
 3 files changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -1391,6 +1391,17 @@ static void set_wm_ranges(
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
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c
@@ -327,7 +327,7 @@ void dcn301_fpu_init_soc_bounding_box(st
 		dcn3_01_soc.sr_exit_time_us = bb_info.dram_sr_exit_latency_100ns * 10;
 }
 
-void dcn301_calculate_wm_and_dlg(struct dc *dc,
+void dcn301_calculate_wm_and_dlg_fp(struct dc *dc,
 		struct dc_state *context,
 		display_e2e_pipe_params_st *pipes,
 		int pipe_cnt,
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.h
@@ -34,7 +34,7 @@ void dcn301_fpu_set_wm_ranges(int i,
 
 void dcn301_fpu_init_soc_bounding_box(struct bp_soc_bb_info bb_info);
 
-void dcn301_calculate_wm_and_dlg(struct dc *dc,
+void dcn301_calculate_wm_and_dlg_fp(struct dc *dc,
 		struct dc_state *context,
 		display_e2e_pipe_params_st *pipes,
 		int pipe_cnt,



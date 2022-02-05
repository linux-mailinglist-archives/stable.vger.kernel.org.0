Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16184AA902
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 14:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379923AbiBENHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 08:07:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50458 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379896AbiBENHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 08:07:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A4BB60EB7
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 13:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16842C340EF;
        Sat,  5 Feb 2022 13:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644066462;
        bh=hgZUQUjR3XUg6ps1U9/0wwTp/EXCAj7bnPgey6OI+cQ=;
        h=Subject:To:Cc:From:Date:From;
        b=lN4j4/r/fqPzKVU324ngeo0qxZQlz7wzRKZpdqngv0jjtmsy062juQM7SuDTqvtSb
         Bzxh30ZJ0SjcMGQRbBeed0Tv7qktWsgWsE4Z8XOKVv/CVL5/065R+YD/XqCK5iilUU
         QvQQ5P12XGfZuk68seV2NschtM0DKCIimp1CGfP4=
Subject: FAILED: patch "[PATCH] drm/amd/display: revert "Reset fifo after enable otg"" failed to apply to 5.10-stable tree
To:     Zhan.Liu@amd.com, Charlene.Liu@amd.com, alexander.deucher@amd.com,
        daniel.wheeler@amd.com, stylon.wang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Feb 2022 14:07:29 +0100
Message-ID: <164406644933165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 49a6ebb95d04bdaa5d57313a380c44249cf02100 Mon Sep 17 00:00:00 2001
From: Zhan Liu <Zhan.Liu@amd.com>
Date: Fri, 28 Jan 2022 22:03:59 +0800
Subject: [PATCH] drm/amd/display: revert "Reset fifo after enable otg"

[Why]
This change causes regression, that prevents some systems
from lighting up internal displays.

[How]
Revert this patch until a new solution is ready.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Signed-off-by: Zhan Liu <Zhan.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index f3ff141b706a..26ec69bb5db9 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -1608,11 +1608,6 @@ static enum dc_status apply_single_controller_ctx_to_hw(
 			pipe_ctx->stream_res.stream_enc,
 			pipe_ctx->stream_res.tg->inst);
 
-	if (dc_is_embedded_signal(pipe_ctx->stream->signal) &&
-		pipe_ctx->stream_res.stream_enc->funcs->reset_fifo)
-		pipe_ctx->stream_res.stream_enc->funcs->reset_fifo(
-			pipe_ctx->stream_res.stream_enc);
-
 	if (dc_is_dp_signal(pipe_ctx->stream->signal))
 		dp_source_sequence_trace(link, DPCD_SOURCE_SEQ_AFTER_CONNECT_DIG_FE_OTG);
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
index bf4436d7aaab..b0c08ee6bc2c 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
@@ -902,19 +902,6 @@ void enc1_stream_encoder_stop_dp_info_packets(
 
 }
 
-void enc1_stream_encoder_reset_fifo(
-	struct stream_encoder *enc)
-{
-	struct dcn10_stream_encoder *enc1 = DCN10STRENC_FROM_STRENC(enc);
-
-	/* set DIG_START to 0x1 to reset FIFO */
-	REG_UPDATE(DIG_FE_CNTL, DIG_START, 1);
-	udelay(100);
-
-	/* write 0 to take the FIFO out of reset */
-	REG_UPDATE(DIG_FE_CNTL, DIG_START, 0);
-}
-
 void enc1_stream_encoder_dp_blank(
 	struct dc_link *link,
 	struct stream_encoder *enc)
@@ -1600,8 +1587,6 @@ static const struct stream_encoder_funcs dcn10_str_enc_funcs = {
 		enc1_stream_encoder_send_immediate_sdp_message,
 	.stop_dp_info_packets =
 		enc1_stream_encoder_stop_dp_info_packets,
-	.reset_fifo =
-		enc1_stream_encoder_reset_fifo,
 	.dp_blank =
 		enc1_stream_encoder_dp_blank,
 	.dp_unblank =
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.h b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.h
index a146a41f68e9..687d7e4bf7ca 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.h
@@ -626,9 +626,6 @@ void enc1_stream_encoder_send_immediate_sdp_message(
 void enc1_stream_encoder_stop_dp_info_packets(
 	struct stream_encoder *enc);
 
-void enc1_stream_encoder_reset_fifo(
-	struct stream_encoder *enc);
-
 void enc1_stream_encoder_dp_blank(
 	struct dc_link *link,
 	struct stream_encoder *enc);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_stream_encoder.c
index 8a70f92795c2..aab25ca8343a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_stream_encoder.c
@@ -593,8 +593,6 @@ static const struct stream_encoder_funcs dcn20_str_enc_funcs = {
 		enc1_stream_encoder_send_immediate_sdp_message,
 	.stop_dp_info_packets =
 		enc1_stream_encoder_stop_dp_info_packets,
-	.reset_fifo =
-		enc1_stream_encoder_reset_fifo,
 	.dp_blank =
 		enc1_stream_encoder_dp_blank,
 	.dp_unblank =
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dio_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dio_stream_encoder.c
index 8daa12730bc1..a04ca4a98392 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dio_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dio_stream_encoder.c
@@ -789,8 +789,6 @@ static const struct stream_encoder_funcs dcn30_str_enc_funcs = {
 		enc3_stream_encoder_update_dp_info_packets,
 	.stop_dp_info_packets =
 		enc1_stream_encoder_stop_dp_info_packets,
-	.reset_fifo =
-		enc1_stream_encoder_reset_fifo,
 	.dp_blank =
 		enc1_stream_encoder_dp_blank,
 	.dp_unblank =
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/stream_encoder.h b/drivers/gpu/drm/amd/display/dc/inc/hw/stream_encoder.h
index 073f8b667eff..c88e113b94d1 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/stream_encoder.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/stream_encoder.h
@@ -164,10 +164,6 @@ struct stream_encoder_funcs {
 	void (*stop_dp_info_packets)(
 		struct stream_encoder *enc);
 
-	void (*reset_fifo)(
-		struct stream_encoder *enc
-	);
-
 	void (*dp_blank)(
 		struct dc_link *link,
 		struct stream_encoder *enc);


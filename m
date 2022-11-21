Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B034D632053
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 12:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiKULWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 06:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiKULVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 06:21:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7842671
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 03:16:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E3116101F
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 11:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FA7C433D6;
        Mon, 21 Nov 2022 11:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669029418;
        bh=KGes2ZWadhpvxwDDqlZ8BRmMmcEnINiPSIeycutcRI4=;
        h=Subject:To:Cc:From:Date:From;
        b=VSmN8XaLwT+VYCBjfX0wRmtSJ9333HTtDPiQp02KW0FpRAC9J7y5pozcgUEDq1RDf
         bOO4jvE3ybxAK3HHSHvPHMXrQm1OyK4vsRUsJNw21XItyhwqwondDueecM2G5pzM37
         ol7mv5S5JsKcfFwy633TIYuWjBAgjTzZJww50UN0=
Subject: FAILED: patch "[PATCH] drm/amd/display: Fix calculation for cursor CAB allocation" failed to apply to 6.0-stable tree
To:     george.shen@amd.com, Alvin.Lee2@amd.com, alexander.deucher@amd.com,
        chiahsuan.chung@amd.com, daniel.wheeler@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 12:16:55 +0100
Message-ID: <166902941562123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

4d2852412306 ("drm/amd/display: Fix calculation for cursor CAB allocation")
525a65c77db5 ("drm/amd/display: Update MALL SS NumWays calculation")
6eef37460584 ("drm/amd/display: Add debug option for allocating extra way for cursor")
5c1a431aaf52 ("drm/amd/display: Added debug option for forcing subvp num ways")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4d285241230676ba8b888701b89684b4e0360fcc Mon Sep 17 00:00:00 2001
From: George Shen <george.shen@amd.com>
Date: Tue, 1 Nov 2022 23:03:03 -0400
Subject: [PATCH] drm/amd/display: Fix calculation for cursor CAB allocation

[Why]
The cursor size (in memory) is currently incorrectly calculated,
resulting not enough CAB being allocated for static screen cursor
in MALL refresh. This results in cursor image corruption.

[How]
Use cursor pitch instead of cursor width when calculating cursor size.
Update num cache lines calculation to use the result of the cursor size
calculation instead of manually recalculating again.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
index cf5bd9713f54..ac41a763bb1d 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -283,8 +283,7 @@ static uint32_t dcn32_calculate_cab_allocation(struct dc *dc, struct dc_state *c
 			using the max for calculation */
 
 		if (hubp->curs_attr.width > 0) {
-				// Round cursor width to next multiple of 64
-				cursor_size = (((hubp->curs_attr.width + 63) / 64) * 64) * hubp->curs_attr.height;
+				cursor_size = hubp->curs_attr.pitch * hubp->curs_attr.height;
 
 				switch (pipe->stream->cursor_attributes.color_format) {
 				case CURSOR_MODE_MONO:
@@ -309,9 +308,9 @@ static uint32_t dcn32_calculate_cab_allocation(struct dc *dc, struct dc_state *c
 						cursor_size > 16384) {
 					/* cursor_num_mblk = CEILING(num_cursors*cursor_width*cursor_width*cursor_Bpe/mblk_bytes, 1)
 					 */
-					cache_lines_used += (((hubp->curs_attr.width * hubp->curs_attr.height * cursor_bpp +
-										DCN3_2_MALL_MBLK_SIZE_BYTES - 1) / DCN3_2_MALL_MBLK_SIZE_BYTES) *
-										DCN3_2_MALL_MBLK_SIZE_BYTES) / dc->caps.cache_line_size + 2;
+					cache_lines_used += (((cursor_size + DCN3_2_MALL_MBLK_SIZE_BYTES - 1) /
+							DCN3_2_MALL_MBLK_SIZE_BYTES) * DCN3_2_MALL_MBLK_SIZE_BYTES) /
+							dc->caps.cache_line_size + 2;
 				}
 				break;
 			}
@@ -727,10 +726,7 @@ void dcn32_update_mall_sel(struct dc *dc, struct dc_state *context)
 		struct hubp *hubp = pipe->plane_res.hubp;
 
 		if (pipe->stream && pipe->plane_state && hubp && hubp->funcs->hubp_update_mall_sel) {
-			//Round cursor width up to next multiple of 64
-			int cursor_width = ((hubp->curs_attr.width + 63) / 64) * 64;
-			int cursor_height = hubp->curs_attr.height;
-			int cursor_size = cursor_width * cursor_height;
+			int cursor_size = hubp->curs_attr.pitch * hubp->curs_attr.height;
 
 			switch (hubp->curs_attr.color_format) {
 			case CURSOR_MODE_MONO:


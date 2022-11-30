Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA8663DFE0
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiK3Svh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbiK3SvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:51:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F209FEE7
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:51:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAF2E61D84
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E79C433D6;
        Wed, 30 Nov 2022 18:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834270;
        bh=RYiL9DUddLCPgw9J51Sa4l2kovyOTMBBMqb6P5ZaWec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLfA3RiVNGIuGp+nBCFP8FBU4DFyFaSn8judcswlMnbhxYu8eyPNEt1UJtjKU0TjT
         srmzm9mbIjfK0z1qC/UWw2vUhabxVG8SRQvyaXa2CF7suVxcJMkUGEUGyNSey83omx
         okE9bTxDY4uvOP+GCmrFgvHZdlHwWYV1NkHj/EjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alvin Lee <Alvin.Lee2@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        George Shen <george.shen@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 191/289] drm/amd/display: Fix calculation for cursor CAB allocation
Date:   Wed, 30 Nov 2022 19:22:56 +0100
Message-Id: <20221130180548.453712583@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit 4d285241230676ba8b888701b89684b4e0360fcc ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
index 84a20ce9bd36..bbc0bfbec6c4 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -284,8 +284,7 @@ static uint32_t dcn32_calculate_cab_allocation(struct dc *dc, struct dc_state *c
 			using the max for calculation */
 
 		if (hubp->curs_attr.width > 0) {
-				// Round cursor width to next multiple of 64
-				cursor_size = (((hubp->curs_attr.width + 63) / 64) * 64) * hubp->curs_attr.height;
+				cursor_size = hubp->curs_attr.pitch * hubp->curs_attr.height;
 
 				switch (pipe->stream->cursor_attributes.color_format) {
 				case CURSOR_MODE_MONO:
@@ -310,9 +309,9 @@ static uint32_t dcn32_calculate_cab_allocation(struct dc *dc, struct dc_state *c
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
@@ -730,10 +729,7 @@ void dcn32_update_mall_sel(struct dc *dc, struct dc_state *context)
 		struct hubp *hubp = pipe->plane_res.hubp;
 
 		if (pipe->stream && pipe->plane_state && hubp && hubp->funcs->hubp_update_mall_sel) {
-			//Round cursor width up to next multiple of 64
-			int cursor_width = ((hubp->curs_attr.width + 63) / 64) * 64;
-			int cursor_height = hubp->curs_attr.height;
-			int cursor_size = cursor_width * cursor_height;
+			int cursor_size = hubp->curs_attr.pitch * hubp->curs_attr.height;
 
 			switch (hubp->curs_attr.color_format) {
 			case CURSOR_MODE_MONO:
-- 
2.35.1




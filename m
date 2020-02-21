Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB2A51678A4
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgBUItt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:49:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:39316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727973AbgBUHof (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:44:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83020222C4;
        Fri, 21 Feb 2020 07:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271074;
        bh=w72o9lcZbaZku5BCWTjN8fzU+n6bQrTtcghNJBGySBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYWAp57dY2cifJSDIFKJQ5F/V+8G+sa70SB4RsrXueP1AmWIOnV9llbWayFP3rY8y
         vmhVfCZc6SeT/UDWHlmvG+1sFBWlB2AVvQLf4GmpOoA8k6PugUoUbaHcAYDm4GxaOk
         YbkWGPGKvDJrVmZoaDvl9Xax3lO2KJpXNQfJy1NI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikola Cornij <nikola.cornij@amd.com>,
        Jun Lei <Jun.Lei@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 029/399] drm/amd/display: Map ODM memory correctly when doing ODM combine
Date:   Fri, 21 Feb 2020 08:35:54 +0100
Message-Id: <20200221072405.176809360@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikola Cornij <nikola.cornij@amd.com>

[ Upstream commit ec5b356c58941bb8930858155d9ce14ceb3d30a0 ]

[why]
Up to 4 ODM memory pieces are required per ODM combine and cannot
overlap, i.e. each ODM "session" has to use its own memory pieces.
The ODM-memory mapping is currently broken for generic case.

The maximum number of memory pieces is ASIC-dependent, but it's always
big enough to satisfy maximum number of ODM combines. Memory pieces
are mapped as a bit-map, i.e. one memory piece corresponds to one bit.
The OPTC doing ODM needs to select memory pieces by setting the
corresponding bits, making sure there's no overlap with other OPTC
instances that might be doing ODM.

The current mapping works only for OPTC instance indexes smaller than
3. For instance indexes 3 and up it practically maps no ODM memory,
causing black, gray or white screen in display configs that include
ODM on OPTC instance 3 or up.

[how]
Statically map two unique ODM memory pieces for each OPTC instance
and piece them together when programming ODM combine mode.

Signed-off-by: Nikola Cornij <nikola.cornij@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dcn20/dcn20_optc.c    | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
index 3b613fb93ef80..0162d3ffe268f 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
@@ -233,12 +233,13 @@ void optc2_set_odm_combine(struct timing_generator *optc, int *opp_id, int opp_c
 		struct dc_crtc_timing *timing)
 {
 	struct optc *optc1 = DCN10TG_FROM_TG(optc);
-	/* 2 pieces of memory required for up to 5120 displays, 4 for up to 8192 */
 	int mpcc_hactive = (timing->h_addressable + timing->h_border_left + timing->h_border_right)
 			/ opp_cnt;
-	int memory_mask = mpcc_hactive <= 2560 ? 0x3 : 0xf;
+	uint32_t memory_mask;
 	uint32_t data_fmt = 0;
 
+	ASSERT(opp_cnt == 2);
+
 	/* TODO: In pseudocode but does not affect maximus, delete comment if we dont need on asic
 	 * REG_SET(OTG_GLOBAL_CONTROL2, 0, GLOBAL_UPDATE_LOCK_EN, 1);
 	 * Program OTG register MASTER_UPDATE_LOCK_DB_X/Y to the position before DP frame start
@@ -246,9 +247,17 @@ void optc2_set_odm_combine(struct timing_generator *optc, int *opp_id, int opp_c
 	 *		MASTER_UPDATE_LOCK_DB_X, 160,
 	 *		MASTER_UPDATE_LOCK_DB_Y, 240);
 	 */
+
+	/* 2 pieces of memory required for up to 5120 displays, 4 for up to 8192,
+	 * however, for ODM combine we can simplify by always using 4.
+	 * To make sure there's no overlap, each instance "reserves" 2 memories and
+	 * they are uniquely combined here.
+	 */
+	memory_mask = 0x3 << (opp_id[0] * 2) | 0x3 << (opp_id[1] * 2);
+
 	if (REG(OPTC_MEMORY_CONFIG))
 		REG_SET(OPTC_MEMORY_CONFIG, 0,
-			OPTC_MEM_SEL, memory_mask << (optc->inst * 4));
+			OPTC_MEM_SEL, memory_mask);
 
 	if (timing->pixel_encoding == PIXEL_ENCODING_YCBCR422)
 		data_fmt = 1;
@@ -257,7 +266,6 @@ void optc2_set_odm_combine(struct timing_generator *optc, int *opp_id, int opp_c
 
 	REG_UPDATE(OPTC_DATA_FORMAT_CONTROL, OPTC_DATA_FORMAT, data_fmt);
 
-	ASSERT(opp_cnt == 2);
 	REG_SET_3(OPTC_DATA_SOURCE_SELECT, 0,
 			OPTC_NUM_OF_INPUT_SEGMENT, 1,
 			OPTC_SEG0_SRC_SEL, opp_id[0],
-- 
2.20.1




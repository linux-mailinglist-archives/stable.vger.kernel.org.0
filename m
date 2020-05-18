Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6833C1D846E
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730666AbgERSCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731969AbgERSCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:02:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E7D920853;
        Mon, 18 May 2020 18:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824936;
        bh=9TQ8eH1qNM1RYSKmIofJoLlaKrOcwsV2rTGyt/yiM/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lPBeuZhQPsc9bRuckyxMqUWaq0FMThAPFhL1krKD8182N0F+7jMiAw6yK/bLDCk9B
         LKRgtovCbiOUXN5J42beJPaBx/ZX5khhI1MupJt0B6pj1Tc4egvNWijQUTvpd1kIcd
         O4vceK5u9vSv0LcgaqQnERdlpVIFBYwV7988uUIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 063/194] drm/amd/display: Defer cursor update around VUPDATE for all ASIC
Date:   Mon, 18 May 2020 19:35:53 +0200
Message-Id: <20200518173536.966424990@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit fdfd2a858590d318cfee483bd1c73e00f77533af ]

[Why]
Fixes the following scenario:

- Flip has been prepared sometime during the frame, update pending
- Cursor update happens right when VUPDATE would happen
- OPTC lock acquired, VUPDATE is blocked until next frame
- Flip is delayed potentially infinitely

With the igt@kms_cursor_legacy cursor-vs-flip-legacy test we can
observe nearly *13* frames of delay for some flips on Navi.

[How]
Apply the Raven workaround generically. When close enough to VUPDATE
block cursor updates from occurring from the dc_stream_set_cursor_*
helpers.

This could perhaps be a little smarter by checking if there were
pending updates or flips earlier in the frame on the HUBP side before
applying the delay, but this should be fine for now.

This fixes the kms_cursor_legacy test.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/core/dc_stream.c   | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
index 6ddbb00ed37a5..8c20e9e907b2f 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
@@ -239,24 +239,24 @@ static void delay_cursor_until_vupdate(struct pipe_ctx *pipe_ctx, struct dc *dc)
 	struct dc_stream_state *stream = pipe_ctx->stream;
 	unsigned int us_per_line;
 
-	if (stream->ctx->asic_id.chip_family == FAMILY_RV &&
-			ASICREV_IS_RAVEN(stream->ctx->asic_id.hw_internal_rev)) {
+	if (!dc->hwss.get_vupdate_offset_from_vsync)
+		return;
 
-		vupdate_line = dc->hwss.get_vupdate_offset_from_vsync(pipe_ctx);
-		if (!dc_stream_get_crtc_position(dc, &stream, 1, &vpos, &nvpos))
-			return;
+	vupdate_line = dc->hwss.get_vupdate_offset_from_vsync(pipe_ctx);
+	if (!dc_stream_get_crtc_position(dc, &stream, 1, &vpos, &nvpos))
+		return;
 
-		if (vpos >= vupdate_line)
-			return;
+	if (vpos >= vupdate_line)
+		return;
 
-		us_per_line = stream->timing.h_total * 10000 / stream->timing.pix_clk_100hz;
-		lines_to_vupdate = vupdate_line - vpos;
-		us_to_vupdate = lines_to_vupdate * us_per_line;
+	us_per_line =
+		stream->timing.h_total * 10000 / stream->timing.pix_clk_100hz;
+	lines_to_vupdate = vupdate_line - vpos;
+	us_to_vupdate = lines_to_vupdate * us_per_line;
 
-		/* 70 us is a conservative estimate of cursor update time*/
-		if (us_to_vupdate < 70)
-			udelay(us_to_vupdate);
-	}
+	/* 70 us is a conservative estimate of cursor update time*/
+	if (us_to_vupdate < 70)
+		udelay(us_to_vupdate);
 #endif
 }
 
-- 
2.20.1




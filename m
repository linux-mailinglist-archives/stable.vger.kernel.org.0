Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8761F6A38D7
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjB0Cia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbjB0CiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:38:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A207E5B85;
        Sun, 26 Feb 2023 18:37:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 977F0B80CC0;
        Mon, 27 Feb 2023 02:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41726C4339C;
        Mon, 27 Feb 2023 02:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463646;
        bh=1rai2uyf8lv86381zgrgK9MHDyRe6ERnZb44jKq2GV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOf3rc7F6s85SnFc9zzdW4lzWCaKxh7Xhio95hmWyQ6YzlqqyH1b03ZymIupiwNHd
         lYnbQD3hgRTrwMlCTwSPlK/WumpWvJETM06boSPdcrinWQWfLZXqlFYmJAEFUFzCBU
         8+ktJF2t1PDD/dneIbGi9hFmlDiHI0+bCtN5j93sjFsIsYdOauKtsLk9ngr0nvtr2C
         vndmIVcG9RgOtQ8nY1YeSsYEtx55w6G0hDJ/w3iEUyVN1nGaUHbxgEqEKJojjh7zy+
         kesEgvtDK6hNnE35SShKie7085ZqYzR5ikPv4aBLDze2iLgQ1NB0CH0wbaBQBT3WI5
         WvZEqGarWoP/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Stempen <vladimir.stempen@amd.com>,
        Nevenko Stupar <Nevenko.Stupar@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, jun.lei@amd.com, Alvin.Lee2@amd.com,
        Dillon.Varone@amd.com, george.shen@amd.com, rdunlap@infradead.org,
        David.Galiffi@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 38/58] drm/amd/display: fix FCLK pstate change underflow
Date:   Sun, 26 Feb 2023 21:04:36 -0500
Message-Id: <20230227020457.1048737-38-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Stempen <vladimir.stempen@amd.com>

[ Upstream commit 972243f973eb0821084e5833d5f7f4ed025f42da ]

[Why]
Currently we set FCLK p-state change
watermark calculated based on dummy
p-state latency when UCLK p-state is
not supported

[How]
Calculate FCLK p-state change watermark
based on on FCLK pstate change latency
in case UCLK p-state is not supported

Reviewed-by: Nevenko Stupar <Nevenko.Stupar@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Vladimir Stempen <vladimir.stempen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index d90216d2fe3a8..04cc96e700981 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -1963,6 +1963,10 @@ void dcn32_calculate_wm_and_dlg_fpu(struct dc *dc, struct dc_state *context,
 		 */
 		context->bw_ctx.bw.dcn.watermarks.a = context->bw_ctx.bw.dcn.watermarks.c;
 		context->bw_ctx.bw.dcn.watermarks.a.cstate_pstate.pstate_change_ns = 0;
+		/* Calculate FCLK p-state change watermark based on FCLK pstate change latency in case
+		 * UCLK p-state is not supported, to avoid underflow in case FCLK pstate is supported
+		 */
+		context->bw_ctx.bw.dcn.watermarks.a.cstate_pstate.fclk_pstate_change_ns = get_fclk_watermark(&context->bw_ctx.dml, pipes, pipe_cnt) * 1000;
 	} else {
 		/* Set A:
 		 * All clocks min.
-- 
2.39.0


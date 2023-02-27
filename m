Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480B06A36DE
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjB0CFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjB0CFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:05:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4900F18171;
        Sun, 26 Feb 2023 18:04:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E52B60D2F;
        Mon, 27 Feb 2023 02:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EF2C4339B;
        Mon, 27 Feb 2023 02:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463397;
        bh=yQgGdAkuKCNSBSX0l9iuEKy4s5I7dzXo2lB6QLxFQWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZ5yCHzInjmYI4SHliiwJTPjX0P43TdBlbGiHaEQI6+TRlHQtYn256aFJ1PIGIE1D
         +ZvuqNuwaaTfoLci9sYftHJyR0SB8dC7krZJ7GSVmikQzCD+Didz0tiC9W6sygHO5t
         bwGSX9xQAZczDy8kgLNC1ghbvIso2vY/VGFXcdjIB6F3axZ3UGs4Ib+uctBuswRr0B
         /gfeL09Rm4eu41z7hgL0Zm+eWmW0M7m3a7DsjisxH/7qvzV755NGrZGNsLlzUp+mK8
         EThxB8u++DVD6CiV6wv3kiz118ouzoMp5DZcDt/UvmPQpY3Gmpx3qTONLq8Da+4nIx
         ducyNlIluheEA==
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
Subject: [PATCH AUTOSEL 6.2 39/60] drm/amd/display: fix FCLK pstate change underflow
Date:   Sun, 26 Feb 2023 21:00:24 -0500
Message-Id: <20230227020045.1045105-39-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
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
index f94abd124021e..8450f59c26186 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -2038,6 +2038,10 @@ void dcn32_calculate_wm_and_dlg_fpu(struct dc *dc, struct dc_state *context,
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


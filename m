Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E3B6EBA68
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 18:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjDVQoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 12:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjDVQoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 12:44:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08741FE4
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 09:44:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B4F26109E
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 16:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B37C433D2;
        Sat, 22 Apr 2023 16:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682181852;
        bh=mY0Yh1HihuEt4VdrPSy7ZYDWcgmz0HSlQDp2b/5yp5o=;
        h=Subject:To:Cc:From:Date:From;
        b=PBzHahxv3mVy2YVRLwNOfRPmgDjVqlaCDUlki12DDCNV+WwPnQP+Mo6wzkkjuhQq9
         KpqVyXklDfI0stgO+RhWCaojlYpZaEZe/d3jh78ZQu+3USj/1fZgtfRkhX0izPTWBr
         +Z7qssKTPFSK+GcatOZgUrMXJKzNi5SvMH0XsNFQ=
Subject: FAILED: patch "[PATCH] drm/amd/display: limit timing for single dimm memory" failed to apply to 6.2-stable tree
To:     Daniel.Miess@amd.com, Nicholas.Kazlauskas@amd.com,
        alexander.deucher@amd.com, daniel.wheeler@amd.com,
        qingqing.zhuo@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 Apr 2023 18:44:04 +0200
Message-ID: <2023042204-threefold-stingy-5bc3@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x 1e994cc0956b8dabd1b1fef315bbd722733b8aa8
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023042204-threefold-stingy-5bc3@gregkh' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

1e994cc0956b ("drm/amd/display: limit timing for single dimm memory")
71c4ca2d3b07 ("drm/amd/display: Remove stutter only configurations")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1e994cc0956b8dabd1b1fef315bbd722733b8aa8 Mon Sep 17 00:00:00 2001
From: Daniel Miess <Daniel.Miess@amd.com>
Date: Tue, 4 Apr 2023 14:04:11 -0400
Subject: [PATCH] drm/amd/display: limit timing for single dimm memory

[Why]
1. It could hit bandwidth limitdation under single dimm
memory when connecting 8K external monitor.
2. IsSupportedVidPn got validation failed with
2K240Hz eDP + 8K24Hz external monitor.
3. It's better to filter out such combination in
EnumVidPnCofuncModality
4. For short term, filter out in dc bandwidth validation.

[How]
Force 2K@240Hz+8K@24Hz timing validation false in dc.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Daniel Miess <Daniel.Miess@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
index 54ed3de869d3..9ffba4c6fe55 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -1697,6 +1697,23 @@ static void dcn314_get_panel_config_defaults(struct dc_panel_config *panel_confi
 	*panel_config = panel_config_defaults;
 }
 
+static bool filter_modes_for_single_channel_workaround(struct dc *dc,
+		struct dc_state *context)
+{
+	// Filter 2K@240Hz+8K@24fps above combination timing if memory only has single dimm LPDDR
+	if (dc->clk_mgr->bw_params->vram_type == 34 && dc->clk_mgr->bw_params->num_channels < 2) {
+		int total_phy_pix_clk = 0;
+
+		for (int i = 0; i < context->stream_count; i++)
+			if (context->res_ctx.pipe_ctx[i].stream)
+				total_phy_pix_clk += context->res_ctx.pipe_ctx[i].stream->phy_pix_clk;
+
+		if (total_phy_pix_clk >= (1148928+826260)) //2K@240Hz+8K@24fps
+			return true;
+	}
+	return false;
+}
+
 bool dcn314_validate_bandwidth(struct dc *dc,
 		struct dc_state *context,
 		bool fast_validate)
@@ -1712,6 +1729,9 @@ bool dcn314_validate_bandwidth(struct dc *dc,
 
 	BW_VAL_TRACE_COUNT();
 
+	if (filter_modes_for_single_channel_workaround(dc, context))
+		goto validate_fail;
+
 	DC_FP_START();
 	// do not support self refresh only
 	out = dcn30_internal_validate_bw(dc, context, pipes, &pipe_cnt, &vlevel, fast_validate, false);


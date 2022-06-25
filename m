Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E59455AB1C
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 16:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbiFYOqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 10:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbiFYOqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 10:46:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69ED12773
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 07:46:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EDB86147D
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 14:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF26C3411C;
        Sat, 25 Jun 2022 14:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656168411;
        bh=eovyaCws+sXA+ucbSgwJ1QjIq9B3us2/BrChStMYjRU=;
        h=Subject:To:Cc:From:Date:From;
        b=x/QWIqhRPfvsvL9yuttlXd0VbyotVzEiMS/x0JhuBzTXA5Bkls20MgsE9y7ZXhgfX
         EHgnhATY74eriMGM7cJKMcn2hpcKGn9pDYM9qLAOl3niQcEgFymkgcAHRZKORRu92V
         8aBYAvk/Fel7L++e6zvLNOSmeucQx21wdTixpAjc=
Subject: FAILED: patch "[PATCH] drm/amd/display: Fix DC warning at driver load" failed to apply to 5.18-stable tree
To:     qingqing.zhuo@amd.com, Dmytro.Laktyushkin@amd.com,
        Rodrigo.Siqueira@amd.com, alexander.deucher@amd.com,
        daniel.wheeler@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 25 Jun 2022 16:46:48 +0200
Message-ID: <1656168408210153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 235870f659687b48b12c28f9427e6ca39dcaa81e Mon Sep 17 00:00:00 2001
From: Qingqing Zhuo <qingqing.zhuo@amd.com>
Date: Fri, 10 Jun 2022 10:43:53 -0400
Subject: [PATCH] drm/amd/display: Fix DC warning at driver load

[Why]
Wrong index was checked for dcfclk_mhz, causing false warning.

[How]
Fix the assertion index.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.18.x

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
index fb4ae800e919..f4381725b210 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
@@ -550,7 +550,7 @@ static void dcn315_clk_mgr_helper_populate_bw_params(
 		if (!bw_params->clk_table.entries[i].dtbclk_mhz)
 			bw_params->clk_table.entries[i].dtbclk_mhz = def_max.dtbclk_mhz;
 	}
-	ASSERT(bw_params->clk_table.entries[i].dcfclk_mhz);
+	ASSERT(bw_params->clk_table.entries[i-1].dcfclk_mhz);
 	bw_params->vram_type = bios_info->memory_type;
 	bw_params->num_channels = bios_info->ma_channel_number;
 	if (!bw_params->num_channels)


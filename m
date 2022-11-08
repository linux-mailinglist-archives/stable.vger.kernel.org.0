Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236946210C4
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbiKHMcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbiKHMcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:32:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2651312AA2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 04:32:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2983B81A9D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 12:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DACC433C1;
        Tue,  8 Nov 2022 12:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667910738;
        bh=g3ZuI/sI4lBaeWUBU+e0VWqv9moyTIJvMl5VtkHLD/o=;
        h=Subject:To:Cc:From:Date:From;
        b=h0NtlaUCEnNoV0pmCmF66a0uBM7vGmwxgv4PqExhv2zQJGlOoEBhDA7pbzbaheNIo
         01YMzlPGh90dnruP11H0R3ynzOVJPX/Xpa0nPoawCA9TZxmOJ4GS6kgF2hXTmbO1iC
         lvf3RbO9Jcr102OV7BVyfnflvgdnYhfB26YMiIs8=
Subject: FAILED: patch "[PATCH] drm/amd/display: Set memclk levels to be at least 1 for dcn32" failed to apply to 6.0-stable tree
To:     Dillon.Varone@amd.com, Martin.Leung@amd.com,
        Rodrigo.Siqueira@amd.com, alexander.deucher@amd.com,
        mark.broadworth@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Nov 2022 13:32:15 +0100
Message-ID: <166791073577136@kroah.com>
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

6cb5cec16c38 ("drm/amd/display: Set memclk levels to be at least 1 for dcn32")
d6170e418d1d ("drm/amd/display: Acquire FCLK DPM levels on DCN32")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6cb5cec16c380be4cf9776a8c23b72e9fe742fd1 Mon Sep 17 00:00:00 2001
From: Dillon Varone <Dillon.Varone@amd.com>
Date: Thu, 20 Oct 2022 11:46:48 -0400
Subject: [PATCH] drm/amd/display: Set memclk levels to be at least 1 for dcn32

[Why]
Cannot report 0 memclk levels even when SMU does not provide any.

[How]
When memclk levels reported by SMU is 0, set levels to 1.

Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
index fd0313468fdb..6f77d8e538ab 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
@@ -669,6 +669,9 @@ static void dcn32_get_memclk_states_from_smu(struct clk_mgr *clk_mgr_base)
 			&clk_mgr_base->bw_params->clk_table.entries[0].memclk_mhz,
 			&num_entries_per_clk->num_memclk_levels);
 
+	/* memclk must have at least one level */
+	num_entries_per_clk->num_memclk_levels = num_entries_per_clk->num_memclk_levels ? num_entries_per_clk->num_memclk_levels : 1;
+
 	dcn32_init_single_clock(clk_mgr, PPCLK_FCLK,
 			&clk_mgr_base->bw_params->clk_table.entries[0].fclk_mhz,
 			&num_entries_per_clk->num_fclk_levels);


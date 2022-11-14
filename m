Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A28E627FDF
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237690AbiKNNCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237692AbiKNNCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:02:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D238628E0F
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:02:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D31961154
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD20C433D6;
        Mon, 14 Nov 2022 13:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430934;
        bh=Ioe3U38OhGE3NWTcpnOnmBj2n/q0hDY/lkjVsTqIFtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oShFbXuXamQC0Uvso+B4lIYWAizNo8TMhe+pUgq26lKGU2G0Da4PTQdiIVideDYWN
         7v0s+Qj5q5vlOThNZo8MbRN5EspfR2WnHWem48ONxLaWQIWkag6qxQboX1qiRYlJoj
         1wZTdu8RZXocC1mfay4zOpXgeRlrEfNEt0c1NFmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Broadworth <mark.broadworth@amd.com>,
        Martin Leung <Martin.Leung@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Dillon Varone <Dillon.Varone@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 010/190] drm/amd/display: Set memclk levels to be at least 1 for dcn32
Date:   Mon, 14 Nov 2022 13:43:54 +0100
Message-Id: <20221114124459.233791084@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Dillon Varone <Dillon.Varone@amd.com>

[ Upstream commit 6cb5cec16c380be4cf9776a8c23b72e9fe742fd1 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
index f3090ead9af5..e7f1d5f8166f 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
@@ -667,6 +667,9 @@ static void dcn32_get_memclk_states_from_smu(struct clk_mgr *clk_mgr_base)
 			&clk_mgr_base->bw_params->clk_table.entries[0].memclk_mhz,
 			&num_entries_per_clk->num_memclk_levels);
 
+	/* memclk must have at least one level */
+	num_entries_per_clk->num_memclk_levels = num_entries_per_clk->num_memclk_levels ? num_entries_per_clk->num_memclk_levels : 1;
+
 	dcn32_init_single_clock(clk_mgr, PPCLK_FCLK,
 			&clk_mgr_base->bw_params->clk_table.entries[0].fclk_mhz,
 			&num_entries_per_clk->num_fclk_levels);
-- 
2.35.1




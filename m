Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2894FD427
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377297AbiDLHtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358598AbiDLHlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:41:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F06153702;
        Tue, 12 Apr 2022 00:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78F8BB81B4F;
        Tue, 12 Apr 2022 07:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24EFC385A1;
        Tue, 12 Apr 2022 07:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747902;
        bh=SpYTWM87dLN5pE3JWM5u1XNsO9uj74qw3Rk8zGXWkc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6uSb+IaQwXDmG8eg3PLUTDyQZF7VV+3U3AHSPKdjXWqsSP4ghOQXHAEbtzg5sQpe
         RwfvYxxhFfiZ7KeLuo8zZlMNw4lp6gQ2ojupLD/ZbQfjg3JnMeII5HRsYNd9qJUfsQ
         539b/AhT+UZvUbRq5XXT6MGGf+CF1KhRrXhuTyak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Koo <Anthony.Koo@amd.com>,
        Eric Yang <Eric.Yang2@amd.com>, Alex Hung <alex.hung@amd.com>,
        Roman Li <Roman.Li@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 248/343] drm/amd/display: Remove redundant dsc power gating from init_hw
Date:   Tue, 12 Apr 2022 08:31:06 +0200
Message-Id: <20220412062958.485919743@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,TVD_SUBJ_WIPE_DEBT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <Roman.Li@amd.com>

[ Upstream commit 95707203407c4cf0b7e520a99d6f46d8aed4b57f ]

[Why]
DSC Power down code has been moved from dcn31_init_hw into init_pipes()
Need to remove it from dcn10_init_hw() as well to avoid duplicated action
on dcn1.x/2.x

[How]
Remove DSC power down code from dcn10_init_hw()

Fixes: 8fa6f4c5715c ("drm/amd/display: fixed the DSC power off sequence during Driver PnP")

Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Reviewed-by: Eric Yang <Eric.Yang2@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 636e2d90ff93..2cefdd96d0cb 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1493,13 +1493,6 @@ void dcn10_init_hw(struct dc *dc)
 			link->link_status.link_active = true;
 	}
 
-	/* Power gate DSCs */
-	if (!is_optimized_init_done) {
-		for (i = 0; i < res_pool->res_cap->num_dsc; i++)
-			if (hws->funcs.dsc_pg_control != NULL)
-				hws->funcs.dsc_pg_control(hws, res_pool->dscs[i]->inst, false);
-	}
-
 	/* we want to turn off all dp displays before doing detection */
 	if (dc->config.power_down_display_on_boot)
 		dc_link_blank_all_dp_displays(dc);
-- 
2.35.1




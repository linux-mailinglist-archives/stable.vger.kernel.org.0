Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CF24B4BE4
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346786AbiBNKYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:24:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346886AbiBNKWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:22:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3B26E4D7;
        Mon, 14 Feb 2022 01:56:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC3C661374;
        Mon, 14 Feb 2022 09:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEE9C340E9;
        Mon, 14 Feb 2022 09:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832561;
        bh=x+JzvzguncQCVOMX0Rg/FQ3pS1phGr2bvV9dF2BG57s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBHvPtzXjKlU6dDUf/U++lEUrdX8wkcH6RQYNX/wixRndh+l80ZKOz1XXemzqLHN3
         Hwc8bOevVHEJ4Ty2u0E6sXTeQpDEq40enmqp3eQMFCLHDHJ/knuFXpJChOY9ass2wJ
         IhCYUCmbYE15yHfG9n8avJY2LFkP5W5sCk+er7Kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhan Liu <zhan.liu@amd.com>,
        Charlene Liu <charlene.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 054/203] drm/amd/display: Correct MPC split policy for DCN301
Date:   Mon, 14 Feb 2022 10:24:58 +0100
Message-Id: <20220214092512.069959392@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhan Liu <zhan.liu@amd.com>

[ Upstream commit ac46d93235074a6c5d280d35771c23fd8620e7d9 ]

[Why]
DCN301 has seamless boot enabled. With MPC split enabled
at the same time, system will hang.

[How]
Revert MPC split policy back to "MPC_SPLIT_AVOID". Since we have
ODM combine enabled on DCN301, pipe split is not necessary here.

Signed-off-by: Zhan Liu <zhan.liu@amd.com>
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
index 9254da120e615..36814d44b19cf 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -686,7 +686,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.disable_clock_gate = true,
 	.disable_pplib_clock_request = true,
 	.disable_pplib_wm_range = true,
-	.pipe_split_policy = MPC_SPLIT_DYNAMIC,
+	.pipe_split_policy = MPC_SPLIT_AVOID,
 	.force_single_disp_pipe_split = false,
 	.disable_dcc = DCC_ENABLE,
 	.vsr_support = true,
-- 
2.34.1




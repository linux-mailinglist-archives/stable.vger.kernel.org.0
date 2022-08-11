Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140D25903EE
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237810AbiHKQYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237812AbiHKQXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:23:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76399E11A;
        Thu, 11 Aug 2022 09:05:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72C596137B;
        Thu, 11 Aug 2022 16:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F65C433C1;
        Thu, 11 Aug 2022 16:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233906;
        bh=HacvzdrZnmxSn3Ds6DRbQwkz80U2LbgSHuzkHWtp9Y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mum3/2FByQ3R4z6AMdZXV8oeVExiqzsQkCjldmdLgMgbc2IeVhtCPpDNsegHTjh84
         WdnBGiOE5FqB1cH7iT/x4jXikIBp4/E39TbkiBIqky/DSE8A1+JCvD68d50leNy15S
         7zciXlmJGwLIwCA/7hBsTPnNTXHWKA1RDzUxQ0fzDCHJLcneZxB0zjCc2pk8qdVyWZ
         jpzwXyWofbRpFfZGLh3yJj38g5vAkUKxDPqtgocc/9tbeDH6Qo+Z2sG/rFrktu9scM
         FQ8wYReYw2V8FGGTwjTkCDacOOk9dH4nYPv4j2qUYl71ZHMXbkp8+qMoeSeceRZdiY
         NQ67DAg0qeR2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duncan Ma <duncan.ma@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Hansen Dsouza <Hansen.Dsouza@amd.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, Aric.Cyr@amd.com, Jun.Lei@amd.com,
        wenjing.liu@amd.com, Yi-Ling.Chen2@amd.com, mwen@igalia.com,
        Jimmy.Kizito@amd.com, Jerry.Zuo@amd.com, gabe.teeger@amd.com,
        Sungjoon.Kim@amd.com, isabbasso@riseup.net,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 09/46] drm/amd/display: Fix dpp dto for disabled pipes
Date:   Thu, 11 Aug 2022 12:03:33 -0400
Message-Id: <20220811160421.1539956-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Duncan Ma <duncan.ma@amd.com>

[ Upstream commit d4965c53b95d7533dfc2309d2fc25838bd33220e ]

[Why]
When switching from 1 pipe to 4to1 mpc combine,
DppDtoClk aren't enabled for the disabled pipes
pior to programming the pipes. Upon optimizing
bandwidth, DppDto are enabled causing intermittent
underflow.

[How]
Update dppclk dto whenever pipe are flagged to
enable.

Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Reviewed-by: Hansen Dsouza <Hansen.Dsouza@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Duncan Ma <duncan.ma@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 3d778760a3b5..7289752d44ad 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1376,11 +1376,15 @@ static void dcn20_update_dchubp_dpp(
 	struct hubp *hubp = pipe_ctx->plane_res.hubp;
 	struct dpp *dpp = pipe_ctx->plane_res.dpp;
 	struct dc_plane_state *plane_state = pipe_ctx->plane_state;
+	struct dccg *dccg = dc->res_pool->dccg;
 	bool viewport_changed = false;
 
 	if (pipe_ctx->update_flags.bits.dppclk)
 		dpp->funcs->dpp_dppclk_control(dpp, false, true);
 
+	if (pipe_ctx->update_flags.bits.enable)
+		dccg->funcs->update_dpp_dto(dccg, dpp->inst, pipe_ctx->plane_res.bw.dppclk_khz);
+
 	/* TODO: Need input parameter to tell current DCHUB pipe tie to which OTG
 	 * VTG is within DCHUBBUB which is commond block share by each pipe HUBP.
 	 * VTG is 1:1 mapping with OTG. Each pipe HUBP will select which VTG
-- 
2.35.1


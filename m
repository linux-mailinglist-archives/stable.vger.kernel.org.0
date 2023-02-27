Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B707F6A372E
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjB0CHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjB0CG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:06:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DE219F39;
        Sun, 26 Feb 2023 18:06:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14BF2B80CAB;
        Mon, 27 Feb 2023 02:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27360C4339B;
        Mon, 27 Feb 2023 02:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463562;
        bh=iZkBiJhWbPVE5XCtUNYSr1AQ3fgrW+1lcbf0WIblXFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBDYiESEIOxv7waa/5HsJjECKTvvL/jOtWpEdVBB8RWzqyn6O57d+4kE92DXvxjfx
         7t5RBL8Afh5QiRun9YOE2/n1WYkjMAsB/TYSE8jMsqP7uzPBh+nx7KfqFMAZj3qhtU
         ki6CQd0R6Aig83sHsdKSwOrJL3787BNvu3e+s62BQ1awpwEqWBQW+DQ1x8QjPDdqpL
         utumq1PlQ0GaYufneAI/wKBihHQc2TOc+zhqmoNjIAjLBaPeqcmWmLkAryylR8IDRo
         SG5ZBqrKCaj4Fcc8JfaKJYzGTpfEjiiO/ukYXxdO67cPKPBiAVprZAPnQ/J4kw+XUQ
         rM/jmJdPy6Lzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, sunpeng.li@amd.com,
        Rodrigo.Siqueira@amd.com, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        SyedSaaem.Rizvi@amd.com, roman.li@amd.com,
        nicholas.kazlauskas@amd.com, Charlene.Liu@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 15/58] drm/amd: Avoid ASSERT for some message failures
Date:   Sun, 26 Feb 2023 21:04:13 -0500
Message-Id: <20230227020457.1048737-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 3e5019ee67760cd61b2a5fd605e1289c2f92d983 ]

On DCN314 when resuming from s0i3 an ASSERT is shown indicating that
`VBIOSSMC_MSG_SetHardMinDcfclkByFreq` returned `VBIOSSMC_Result_Failed`.

This isn't a driver bug; it's a BIOS/configuration bug. To make this
easier to triage, add an explicit warning when this issue happens.

This matches the behavior utilized for failures with
`VBIOSSMC_MSG_TransferTableDram2Smu` configuration.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_smu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_smu.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_smu.c
index 2db595672a469..aa264c600408d 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_smu.c
@@ -146,6 +146,9 @@ static int dcn314_smu_send_msg_with_param(struct clk_mgr_internal *clk_mgr,
 		if (msg_id == VBIOSSMC_MSG_TransferTableDram2Smu &&
 		    param == TABLE_WATERMARKS)
 			DC_LOG_WARNING("Watermarks table not configured properly by SMU");
+		else if (msg_id == VBIOSSMC_MSG_SetHardMinDcfclkByFreq ||
+			 msg_id == VBIOSSMC_MSG_SetMinDeepSleepDcfclk)
+			DC_LOG_WARNING("DCFCLK_DPM is not enabled by BIOS");
 		else
 			ASSERT(0);
 		REG_WRITE(MP1_SMN_C2PMSG_91, VBIOSSMC_Result_OK);
-- 
2.39.0


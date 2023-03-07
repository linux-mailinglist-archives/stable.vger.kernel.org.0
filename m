Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDA26AF12D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbjCGSkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbjCGSkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:40:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DE528D11
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:31:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CD28B819F0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095EBC433A1;
        Tue,  7 Mar 2023 18:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213839;
        bh=VWUA6089KicX3g4n2fMMBNcBw71J3oA/4zbv6JceSIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x810zNRHATyd7e51tvu4e2wEvG8aGpmRkjUSmW38KekBeCqKZ6lrCRH1t5dgufy00
         Y1YslZzP9FjCeJkU2TrXe5i54zydSw5X7p9GKAmZJGoQEA3FI1/PGQxBLLljqov714
         YDgSYBrQKnH5XRRH9mbuWkjFnC/bkvAxFsMm+Yjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 606/885] drm/amd: Avoid ASSERT for some message failures
Date:   Tue,  7 Mar 2023 17:59:00 +0100
Message-Id: <20230307170028.679267071@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
2.39.2




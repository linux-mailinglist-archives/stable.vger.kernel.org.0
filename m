Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0947C4BDC6C
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244274AbiBUJ76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:59:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353903AbiBUJ57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B96962CB;
        Mon, 21 Feb 2022 01:27:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99E1261023;
        Mon, 21 Feb 2022 09:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8FAC340E9;
        Mon, 21 Feb 2022 09:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435634;
        bh=v3MER1/Z/1nChzKsMsoSuaIlZ25Q0/0JMr6nMx6ik68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=monZI0dhumANzrXX1xWUHvvizweAVX0oJevlCMIhNqsrR87SIit3iUEYz2ql2nPWV
         dhT9H5emGi2DjMFh7kjt83NHW5Ca+dDZ3xm/9tM2Dibno6HX5RLVrc+ZkjmFDwIGPo
         upKPuSHgv4lS3DzmXUIM62Mx968vlBya7HhPjY3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 221/227] display/amd: decrease message verbosity about watermarks table failure
Date:   Mon, 21 Feb 2022 09:50:40 +0100
Message-Id: <20220221084942.150864513@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 03ad3093c7c069d6ab4403730009ebafeea9ee37 ]

A number of BIOS versions have a problem with the watermarks table not
being configured properly.  This manifests as a very scary looking warning
during resume from s0i3.  This should be harmless in most cases and is well
understood, so decrease the assertion to a clearer warning about the problem.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
index 162ae71861247..21d2cbc3cbb20 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
@@ -120,7 +120,11 @@ int dcn31_smu_send_msg_with_param(
 	result = dcn31_smu_wait_for_response(clk_mgr, 10, 200000);
 
 	if (result == VBIOSSMC_Result_Failed) {
-		ASSERT(0);
+		if (msg_id == VBIOSSMC_MSG_TransferTableDram2Smu &&
+		    param == TABLE_WATERMARKS)
+			DC_LOG_WARNING("Watermarks table not configured properly by SMU");
+		else
+			ASSERT(0);
 		REG_WRITE(MP1_SMN_C2PMSG_91, VBIOSSMC_Result_OK);
 		return -1;
 	}
-- 
2.34.1




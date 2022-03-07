Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985564CF709
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237912AbiCGJoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241141AbiCGJlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A02F2DF1;
        Mon,  7 Mar 2022 01:40:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2811A611D5;
        Mon,  7 Mar 2022 09:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236B8C340E9;
        Mon,  7 Mar 2022 09:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646043;
        bh=pM04jYT3iEEc+cH4XO1fxzRYFDlUu4wBdsMG/Myc3Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKSuvCxqc4TJBKta+7XK0B9yan3yLj6a/+uSJmlKDIFxcufavIqkVlWpdllyf2y17
         BwDdCr1xvXvwGlMAQyVau9kDu2AdaCGyiT7bpBQsc5yNWrWztt1ZuA6t2LAq9VqMUp
         agYw0PwqP68FNBnfz793+wy77F3kIRlsrJOD8lS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhan Liu <zhan.liu@amd.com>,
        Agustin Gutierrez <agustin.gutierrez@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/262] drm/amd/display: Update watermark values for DCN301
Date:   Mon,  7 Mar 2022 10:17:38 +0100
Message-Id: <20220307091705.686545607@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Agustin Gutierrez <agustin.gutierrez@amd.com>

[ Upstream commit 2d8ae25d233767171942a9fba5fd8f4a620996be ]

[Why]
There is underflow / visual corruption DCN301, for high
bandwidth MST DSC configurations such as 2x1440p144 or 2x4k60.

[How]
Use up-to-date watermark values for DCN301.

Reviewed-by: Zhan Liu <zhan.liu@amd.com>
Signed-off-by: Agustin Gutierrez <agustin.gutierrez@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c   | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
index 3eee32faa208c..329ce4e84b83c 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
@@ -582,32 +582,32 @@ static struct wm_table lpddr5_wm_table = {
 			.wm_inst = WM_A,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 7.95,
-			.sr_enter_plus_exit_time_us = 9,
+			.sr_exit_time_us = 13.5,
+			.sr_enter_plus_exit_time_us = 16.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_B,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 9.82,
-			.sr_enter_plus_exit_time_us = 11.196,
+			.sr_exit_time_us = 13.5,
+			.sr_enter_plus_exit_time_us = 16.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_C,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 9.89,
-			.sr_enter_plus_exit_time_us = 11.24,
+			.sr_exit_time_us = 13.5,
+			.sr_enter_plus_exit_time_us = 16.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_D,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 9.748,
-			.sr_enter_plus_exit_time_us = 11.102,
+			.sr_exit_time_us = 13.5,
+			.sr_enter_plus_exit_time_us = 16.5,
 			.valid = true,
 		},
 	}
-- 
2.34.1




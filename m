Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955394ABCC9
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387121AbiBGLjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385934AbiBGLdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:33:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44100C043181;
        Mon,  7 Feb 2022 03:33:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D561C60A69;
        Mon,  7 Feb 2022 11:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3B6C004E1;
        Mon,  7 Feb 2022 11:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233586;
        bh=4F2nWKHa8/0nbptm9EJn9sUIXqQlFVWQZzv/dM3bWag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VAkM7QTLfG3FYHUD0eIEehaUwe/TuHmwICqHNlBOn69zLshT618KmxsimtdPleOwM
         C6f28YpfIPeXrqeDYv0OF1kDKDvk6nVSNfXLwCelzknnZxrZeLGpku5aYBTx6mKka1
         OdixEw2mRBSUIoJhdUwsTBOhGagM+MFeGi0UjX3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhan Liu <zhan.liu@amd.com>,
        Agustin Gutierrez <agustin.gutierrez@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 026/126] drm/amd/display: Update watermark values for DCN301
Date:   Mon,  7 Feb 2022 12:05:57 +0100
Message-Id: <20220207103805.054427398@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

From: Agustin Gutierrez <agustin.gutierrez@amd.com>

commit 2d8ae25d233767171942a9fba5fd8f4a620996be upstream.

[Why]
There is underflow / visual corruption DCN301, for high
bandwidth MST DSC configurations such as 2x1440p144 or 2x4k60.

[How]
Use up-to-date watermark values for DCN301.

Reviewed-by: Zhan Liu <zhan.liu@amd.com>
Signed-off-by: Agustin Gutierrez <agustin.gutierrez@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c |   16 ++++++-------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
@@ -582,32 +582,32 @@ static struct wm_table lpddr5_wm_table =
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



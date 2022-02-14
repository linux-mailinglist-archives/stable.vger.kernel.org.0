Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC314B4B0A
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346852AbiBNK1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:27:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348418AbiBNK05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:26:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6028302D;
        Mon, 14 Feb 2022 01:57:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5065861291;
        Mon, 14 Feb 2022 09:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30429C340E9;
        Mon, 14 Feb 2022 09:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832663;
        bh=vLP6QBEs6yQfhcdW3YJt9BxzrxtuLathGQXDlJJ08WY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0WJRpZBDorJwDxvicIffaVyOMnBtaT0rrrRVVHFHSRDOAdMowzuaI6q5pRC6Q8dQ
         EtzmFFJ8s8WRzjDpGnE3Zhqdb6EgKwUT8x4DFP2Ye9l5hZSp9PwEM9LVNHK5jy9jsQ
         JvfzvGbgdy/n4Km1ojYfyUxDaOOYNO4sfLwuFptw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 087/203] drm/amdgpu/display: change pipe policy for DCN 2.0
Date:   Mon, 14 Feb 2022 10:25:31 +0100
Message-Id: <20220214092513.227448126@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 6e7545ddb13416fd200e0b91c0acfd0404e2e27b upstream.

Fixes hangs on driver load with multiple displays on
DCN 2.0 parts.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=215511
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1877
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1886
Fixes: ee2698cf79cc ("drm/amd/display: Changed pipe split policy to allow for multi-display pipe split")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -1069,7 +1069,7 @@ static const struct dc_debug_options deb
 		.timing_trace = false,
 		.clock_trace = true,
 		.disable_pplib_clock_request = true,
-		.pipe_split_policy = MPC_SPLIT_DYNAMIC,
+		.pipe_split_policy = MPC_SPLIT_AVOID_MULT_DISP,
 		.force_single_disp_pipe_split = false,
 		.disable_dcc = DCC_ENABLE,
 		.vsr_support = true,



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CE2582F48
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbiG0RWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241848AbiG0RUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:20:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BC45F110;
        Wed, 27 Jul 2022 09:45:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A8A3B821D4;
        Wed, 27 Jul 2022 16:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9504C433C1;
        Wed, 27 Jul 2022 16:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940322;
        bh=MxIqrIPmkawLpmAgdInOx6a9yL6SrBN/IMRL0oRRGK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJNMiQE9V9mvm9y0uGs2s8kkY/DBmF7XSbQGPTlzjDv8x04KAWZUEgZFfcVstQFXU
         yt11ojcdAtTXNb09uwJcUgI8RC8CmSSZxZlgNofJGs/1pmU04DjEnOhekA3oHIsDyV
         DDdFd3xvv9ig2gopy3L2oxCCeIpSnh21bwN3v1JQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom St Denis <tom.stdenis@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.15 184/201] drm/amd/display: Fix surface optimization regression on Carrizo
Date:   Wed, 27 Jul 2022 18:11:28 +0200
Message-Id: <20220727161035.401781717@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 62e5a7e2333a9f5395f6a9db766b7b06c949fe7a upstream.

[Why]
DCE legacy optimization path isn't well tested under new DC optimization
flow which can result in underflow occuring when initializing X11 on
Carrizo.

[How]
Retain the legacy optimization flow for DCE and keep the new one for DCN
to satisfy optimizations being correctly applied for ASIC that can
support it.

Fixes: 34316c1e561db0 ("drm/amd/display: Optimize bandwidth on following fast update")
Reported-by: Tom St Denis <tom.stdenis@amd.com>
Tested-by: Tom St Denis <tom.stdenis@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2979,8 +2979,13 @@ void dc_commit_updates_for_stream(struct
 			if (new_pipe->plane_state && new_pipe->plane_state != old_pipe->plane_state)
 				new_pipe->plane_state->force_full_update = true;
 		}
-	} else if (update_type == UPDATE_TYPE_FAST) {
-		/* Previous frame finished and HW is ready for optimization. */
+	} else if (update_type == UPDATE_TYPE_FAST && dc_ctx->dce_version >= DCE_VERSION_MAX) {
+		/*
+		 * Previous frame finished and HW is ready for optimization.
+		 *
+		 * Only relevant for DCN behavior where we can guarantee the optimization
+		 * is safe to apply - retain the legacy behavior for DCE.
+		 */
 		dc_post_update_surfaces_to_stream(dc);
 	}
 
@@ -3039,6 +3044,12 @@ void dc_commit_updates_for_stream(struct
 		}
 	}
 
+	/* Legacy optimization path for DCE. */
+	if (update_type >= UPDATE_TYPE_FULL && dc_ctx->dce_version < DCE_VERSION_MAX) {
+		dc_post_update_surfaces_to_stream(dc);
+		TRACE_DCE_CLOCK_STATE(&context->bw_ctx.bw.dce);
+	}
+
 	return;
 
 }



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE986582F40
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241999AbiG0RWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241819AbiG0RU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:20:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA254664CF;
        Wed, 27 Jul 2022 09:45:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1C12B8200D;
        Wed, 27 Jul 2022 16:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB90C433C1;
        Wed, 27 Jul 2022 16:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940319;
        bh=q4FJTfADqyAATI/6Vy4O68t1Bj6HIZ0dpHIGC62mgoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJUjcuBb60YyGq92FQOmdfX05hFWVIalbcPwUlKAghWcZ5/V0ie9H+C03pf1FUygJ
         A2EneKa3AXGFR9U1v4FiF8VUhAcyp2qZbYADWqtGv9T4CCHcXRFnr4NSWeg0KxSeJQ
         D5qYsyf1ZEnEittk0HGW6bMiYN50fjOsbU+yh2Fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.15 183/201] drm/amd/display: Optimize bandwidth on following fast update
Date:   Wed, 27 Jul 2022 18:11:27 +0200
Message-Id: <20220727161035.371672809@linuxfoundation.org>
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

commit 34316c1e561db0b24e341029f04a5a5bead9a7bc upstream.

[Why]
The current call to optimize_bandwidth never occurs because flip is
always pending from the FULL and FAST updates.

[How]
Optimize on the following flip when it's a FAST update and we know we
aren't going to be modifying the clocks again.

Reviewed-by: Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>
Acked-by: Mikita Lipski <mikita.lipski@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1788,6 +1788,11 @@ void dc_post_update_surfaces_to_stream(s
 
 	post_surface_trace(dc);
 
+	if (dc->ctx->dce_version >= DCE_VERSION_MAX)
+		TRACE_DCN_CLOCK_STATE(&context->bw_ctx.bw.dcn.clk);
+	else
+		TRACE_DCE_CLOCK_STATE(&context->bw_ctx.bw.dce);
+
 	if (is_flip_pending_in_pipes(dc, context))
 		return;
 
@@ -2974,6 +2979,9 @@ void dc_commit_updates_for_stream(struct
 			if (new_pipe->plane_state && new_pipe->plane_state != old_pipe->plane_state)
 				new_pipe->plane_state->force_full_update = true;
 		}
+	} else if (update_type == UPDATE_TYPE_FAST) {
+		/* Previous frame finished and HW is ready for optimization. */
+		dc_post_update_surfaces_to_stream(dc);
 	}
 
 
@@ -3030,15 +3038,6 @@ void dc_commit_updates_for_stream(struct
 				pipe_ctx->plane_state->force_full_update = false;
 		}
 	}
-	/*let's use current_state to update watermark etc*/
-	if (update_type >= UPDATE_TYPE_FULL) {
-		dc_post_update_surfaces_to_stream(dc);
-
-		if (dc_ctx->dce_version >= DCE_VERSION_MAX)
-			TRACE_DCN_CLOCK_STATE(&context->bw_ctx.bw.dcn.clk);
-		else
-			TRACE_DCE_CLOCK_STATE(&context->bw_ctx.bw.dce);
-	}
 
 	return;
 



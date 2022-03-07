Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1BF4CF801
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbiCGJvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239741AbiCGJuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:50:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740CA71CAD;
        Mon,  7 Mar 2022 01:43:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01CAAB8102B;
        Mon,  7 Mar 2022 09:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E992C340E9;
        Mon,  7 Mar 2022 09:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646207;
        bh=q+pHBw5Es58AND4WYJNiphPXKF5qBaS0miWn7pDZVK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDyPmz78eSKt9tBS74I6m6q6H4W2sm44w2v2vUmvI+GzFmj5L6IzZwQpdc02BgTsK
         IkBDLjXnvoMG1+d+yDtEEIohOnJ8YyvDikjJXz5br76l1fFyxrvLyxQKJMxpAStvCm
         NigeseXl1KHwdt6hjX7cw6yTdO8ZDEJiG/wlx3Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Kizito <Jimmy.Kizito@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/262] drm/amd/display: Fix stream->link_enc unassigned during stream removal
Date:   Mon,  7 Mar 2022 10:17:55 +0100
Message-Id: <20220307091706.156473293@linuxfoundation.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 3743e7f6fcb938b7d8b7967e6a9442805e269b3d ]

[Why]
Found when running igt@kms_atomic.

Userspace attempts to do a TEST_COMMIT when 0 streams which calls
dc_remove_stream_from_ctx. This in turn calls link_enc_unassign
which ends up modifying stream->link = NULL directly, causing the
global link_enc to be removed preventing further link activity
and future link validation from passing.

[How]
We take care of link_enc unassignment at the start of
link_enc_cfg_link_encs_assign so this call is no longer necessary.

Fixes global state from being modified while unlocked.

Reviewed-by: Jimmy Kizito <Jimmy.Kizito@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index e94546187cf15..7ae409f7dcf8d 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1799,9 +1799,6 @@ enum dc_status dc_remove_stream_from_ctx(
 				dc->res_pool,
 			del_pipe->stream_res.stream_enc,
 			false);
-	/* Release link encoder from stream in new dc_state. */
-	if (dc->res_pool->funcs->link_enc_unassign)
-		dc->res_pool->funcs->link_enc_unassign(new_ctx, del_pipe->stream);
 
 	if (del_pipe->stream_res.audio)
 		update_audio_usage(
-- 
2.34.1




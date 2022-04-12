Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1498F4FD486
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351467AbiDLHUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351715AbiDLHMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3752216585;
        Mon, 11 Apr 2022 23:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC302B81B47;
        Tue, 12 Apr 2022 06:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C96BC385A1;
        Tue, 12 Apr 2022 06:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746314;
        bh=l46cSs6DjSOBqAacpO48W9M8+IBy8zm1uWvxKy7t0Bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9MBWCoggNFOVwDf34ALpe5exgxU8Ol/nmg4U2tGmHrYuhOXFYZz9jyV+08fErNPo
         Kl9a9dAhlK3eLaTHsZ1MNM76WrevyESYXeZgc98xlxfNsv87vGbJpTv1UYSjU+Q9Xj
         4Hcve47DPR5bYKq84UZYrH1yuWJNrn1v9Eh+TILU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shirish S <shirish.s@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 239/277] amd/display: set backlight only if required
Date:   Tue, 12 Apr 2022 08:30:42 +0200
Message-Id: <20220412062948.962324739@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Shirish S <shirish.s@amd.com>

commit 4052287a75eb3fc0f487fcc5f768a38bede455c8 upstream.

[Why]
comparing pwm bl values (coverted) with user brightness(converted)
levels in commit_tail leads to continuous setting of backlight via dmub
as they don't to match.
This leads overdrive in queuing of commands to DMCU that sometimes lead
to depending on load on DMCU fw:

"[drm:dc_dmub_srv_wait_idle] *ERROR* Error waiting for DMUB idle: status=3"

[How]
Store last successfully set backlight value and compare with it instead
of pwm reads which is not what we should compare with.

Signed-off-by: Shirish S <shirish.s@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    7 ++++---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |    6 ++++++
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3522,7 +3522,7 @@ static u32 convert_brightness_to_user(co
 				 max - min);
 }
 
-static int amdgpu_dm_backlight_set_level(struct amdgpu_display_manager *dm,
+static void amdgpu_dm_backlight_set_level(struct amdgpu_display_manager *dm,
 					 int bl_idx,
 					 u32 user_brightness)
 {
@@ -3550,7 +3550,8 @@ static int amdgpu_dm_backlight_set_level
 			DRM_DEBUG("DM: Failed to update backlight on eDP[%d]\n", bl_idx);
 	}
 
-	return rc ? 0 : 1;
+	if (rc)
+		dm->actual_brightness[bl_idx] = user_brightness;
 }
 
 static int amdgpu_dm_backlight_update_status(struct backlight_device *bd)
@@ -9316,7 +9317,7 @@ static void amdgpu_dm_atomic_commit_tail
 	/* restore the backlight level */
 	for (i = 0; i < dm->num_of_edps; i++) {
 		if (dm->backlight_dev[i] &&
-		    (amdgpu_dm_backlight_get_level(dm, i) != dm->brightness[i]))
+		    (dm->actual_brightness[i] != dm->brightness[i]))
 			amdgpu_dm_backlight_set_level(dm, i, dm->brightness[i]);
 	}
 #endif
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -446,6 +446,12 @@ struct amdgpu_display_manager {
 	 * cached backlight values.
 	 */
 	u32 brightness[AMDGPU_DM_MAX_NUM_EDP];
+	/**
+	 * @actual_brightness:
+	 *
+	 * last successfully applied backlight values.
+	 */
+	u32 actual_brightness[AMDGPU_DM_MAX_NUM_EDP];
 };
 
 enum dsc_clock_force_state {



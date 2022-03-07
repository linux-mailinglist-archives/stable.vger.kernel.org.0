Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3C24CF85E
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238668AbiCGJxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239856AbiCGJuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:50:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E670515A05;
        Mon,  7 Mar 2022 01:43:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0371F60F62;
        Mon,  7 Mar 2022 09:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11855C340E9;
        Mon,  7 Mar 2022 09:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646225;
        bh=NPONLAZLBstRZEyym2VkP7E0lzKD00RlkxXDT8ej6EE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nikmCttAzMuN0ofQ4s1+LQZEmoikg2L77GSUZXbj0TGOpbbZUZ3uich9iF6j8gKW4
         gIotDN5jQdSGhqRt7WKFvsIYY4mgrP1peS/fkQMloY1da1FoML3RXga9D77RFMgc1G
         3dU/pKU/gqqeexUXSiNxuAjiSDhd4qsfUo5ngTA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/262] drm/amd/display: For vblank_disable_immediate, check PSR is really used
Date:   Mon,  7 Mar 2022 10:17:57 +0100
Message-Id: <20220307091706.211904198@linuxfoundation.org>
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

From: Michel Dänzer <mdaenzer@redhat.com>

[ Upstream commit 4d22336f903930eb94588b939c310743a3640276 ]

Even if PSR is allowed for a present GPU, there might be no eDP link
which supports PSR.

Fixes: 708978487304 ("drm/amdgpu/display: Only set vblank_disable_immediate when PSR is not enabled")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c   | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 76967adc51606..cd611444ad177 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3812,6 +3812,9 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 	}
 #endif
 
+	/* Disable vblank IRQs aggressively for power-saving. */
+	adev_to_drm(adev)->vblank_disable_immediate = true;
+
 	/* loops over all connectors on the board */
 	for (i = 0; i < link_cnt; i++) {
 		struct dc_link *link = NULL;
@@ -3858,19 +3861,17 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 				update_connector_ext_caps(aconnector);
 			if (amdgpu_dc_feature_mask & DC_PSR_MASK)
 				amdgpu_dm_set_psr_caps(link);
+
+			/* TODO: Fix vblank control helpers to delay PSR entry to allow this when
+			 * PSR is also supported.
+			 */
+			if (link->psr_settings.psr_feature_enabled)
+				adev_to_drm(adev)->vblank_disable_immediate = false;
 		}
 
 
 	}
 
-	/*
-	 * Disable vblank IRQs aggressively for power-saving.
-	 *
-	 * TODO: Fix vblank control helpers to delay PSR entry to allow this when PSR
-	 * is also supported.
-	 */
-	adev_to_drm(adev)->vblank_disable_immediate = !psr_feature_enabled;
-
 	/* Software is initialized. Now we can register interrupt handlers. */
 	switch (adev->asic_type) {
 #if defined(CONFIG_DRM_AMD_DC_SI)
-- 
2.34.1




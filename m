Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE87C4C7650
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbiB1SCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239453AbiB1SB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:01:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFDF9BAD5;
        Mon, 28 Feb 2022 09:45:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 859CFB81085;
        Mon, 28 Feb 2022 17:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA73DC340E7;
        Mon, 28 Feb 2022 17:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070347;
        bh=uW5lP9Jlu1qgQDuB/8Sam5qo0Jjx9pzRygNq0AAbrZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6+2wbufnX6eyk9EwLnUUJAKfOC4jPqw/9goBY9pBMY/H1MHzEdLQF6Qz0iPAdwe5
         roFVmMm/7RlXXTdJIA2zLs/LAH8n5bpxHesXOw1a2pC87IfwTQuVinXnDWxLs4rUt9
         RA8jlboUMcfGeZ36WgoCwGPtxK4p+ff0gI+aumxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 076/164] drm/amd/display: For vblank_disable_immediate, check PSR is really used
Date:   Mon, 28 Feb 2022 18:23:58 +0100
Message-Id: <20220228172406.930512356@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michel Dänzer <mdaenzer@redhat.com>

commit 4d22336f903930eb94588b939c310743a3640276 upstream.

Even if PSR is allowed for a present GPU, there might be no eDP link
which supports PSR.

Fixes: 708978487304 ("drm/amdgpu/display: Only set vblank_disable_immediate when PSR is not enabled")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4232,6 +4232,9 @@ static int amdgpu_dm_initialize_drm_devi
 	}
 #endif
 
+	/* Disable vblank IRQs aggressively for power-saving. */
+	adev_to_drm(adev)->vblank_disable_immediate = true;
+
 	/* loops over all connectors on the board */
 	for (i = 0; i < link_cnt; i++) {
 		struct dc_link *link = NULL;
@@ -4277,19 +4280,17 @@ static int amdgpu_dm_initialize_drm_devi
 				update_connector_ext_caps(aconnector);
 			if (psr_feature_enabled)
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



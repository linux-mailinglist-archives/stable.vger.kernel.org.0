Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59E4566CFF
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbiGEMUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237589AbiGEMT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4C81D322;
        Tue,  5 Jul 2022 05:15:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5578B8170A;
        Tue,  5 Jul 2022 12:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE5AC341C8;
        Tue,  5 Jul 2022 12:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023324;
        bh=vAqLUSXYnGusguVFKmIeqit7LtXRJ0gPrimnbNFOycQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XzqIYtFTduPQ5vl7E8/q15Ubz3Nt8otorgJsoFPmnB/qgYGlHnApey0s/iGP1LJII
         zmEUKByeP917B1+SoraSXvLIpJaKLMpQw3ZnB9BVMaRAVwgt3/qnKMgXSvtRh4ea7W
         z7qgQip4ex/9s1TEzoafMBSKnpQfaSDXW1VMO28o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Subject: [PATCH 5.18 002/102] Revert "drm/amdgpu/display: set vblank_disable_immediate for DC"
Date:   Tue,  5 Jul 2022 13:57:28 +0200
Message-Id: <20220705115618.482984868@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit a775e4e4941bf2f326aa36c58f67bd6c96cac717 upstream.

This reverts commit 92020e81ddbeac351ea4a19bcf01743f32b9c800.

This causes stuttering and timeouts with DMCUB for some users
so revert it until we understand why and safely enable it
to save power.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1887
Acked-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c           |    1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -333,6 +333,7 @@ int amdgpu_irq_init(struct amdgpu_device
 	if (!amdgpu_device_has_dc_support(adev)) {
 		if (!adev->enable_virtual_display)
 			/* Disable vblank IRQs aggressively for power-saving */
+			/* XXX: can this be enabled for DC? */
 			adev_to_drm(adev)->vblank_disable_immediate = true;
 
 		r = drm_vblank_init(adev_to_drm(adev), adev->mode_info.num_crtc);
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4286,9 +4286,6 @@ static int amdgpu_dm_initialize_drm_devi
 	}
 #endif
 
-	/* Disable vblank IRQs aggressively for power-saving. */
-	adev_to_drm(adev)->vblank_disable_immediate = true;
-
 	/* loops over all connectors on the board */
 	for (i = 0; i < link_cnt; i++) {
 		struct dc_link *link = NULL;



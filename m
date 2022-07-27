Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A03582FCF
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242157AbiG0RaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242506AbiG0R3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:29:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0447E80F67;
        Wed, 27 Jul 2022 09:47:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86E06B821D4;
        Wed, 27 Jul 2022 16:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61D3C433D7;
        Wed, 27 Jul 2022 16:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940474;
        bh=RfQQQrVVHg+qrqR7Zwd2k658vR9G4P25h5UQdUhcilY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yc/pcTOqvirDRV+o8Gw10yLDExgi5PNEwUvRsXhCNKZ8I9DJ7z76qga+AwJD7bf9C
         lh9M/j39TH0zz6EFqwQ7QDGQcd4UI9qaxC6m7MYlndPnVYbtumq35FvXJz/Q3V+deF
         1rg5HWW5j3kgkHlz26FCN/dUJVeTLm9yVZF3Vhuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.18 009/158] drm/amd/display: Fix new dmub notification enabling in DM
Date:   Wed, 27 Jul 2022 18:11:13 +0200
Message-Id: <20220727161021.801746226@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
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

From: Stylon Wang <stylon.wang@amd.com>

commit 2d4bd81fea1ad6ebba543bd6da3ef5179d130e6a upstream.

[Why]
Changes from "Fix for dmub outbox notification enable" need to land
in DM or DMUB outbox notification would be disabled.

[How]
Enable outbox notification only after interrupt are enabled and IRQ
handlers registered. Any pending notification will be sent by DMUB
once outbox notification is enabled.

Fixes: ed7208706448 ("drm/amd/display: Fix for dmub outbox notification enable")
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   27 +++++++++++++++-------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1670,7 +1670,7 @@ static int amdgpu_dm_init(struct amdgpu_
 #if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
 	adev->dm.crc_rd_wrk = amdgpu_dm_crtc_secure_display_create_work();
 #endif
-	if (dc_enable_dmub_notifications(adev->dm.dc)) {
+	if (dc_is_dmub_outbox_supported(adev->dm.dc)) {
 		init_completion(&adev->dm.dmub_aux_transfer_done);
 		adev->dm.dmub_notify = kzalloc(sizeof(struct dmub_notification), GFP_KERNEL);
 		if (!adev->dm.dmub_notify) {
@@ -1708,6 +1708,13 @@ static int amdgpu_dm_init(struct amdgpu_
 		goto error;
 	}
 
+	/* Enable outbox notification only after IRQ handlers are registered and DMUB is alive.
+	 * It is expected that DMUB will resend any pending notifications at this point, for
+	 * example HPD from DPIA.
+	 */
+	if (dc_is_dmub_outbox_supported(adev->dm.dc))
+		dc_enable_dmub_outbox(adev->dm.dc);
+
 	/* create fake encoders for MST */
 	dm_dp_create_fake_mst_encoders(adev);
 
@@ -2701,9 +2708,6 @@ static int dm_resume(void *handle)
 		 */
 		link_enc_cfg_copy(adev->dm.dc->current_state, dc_state);
 
-		if (dc_enable_dmub_notifications(adev->dm.dc))
-			amdgpu_dm_outbox_init(adev);
-
 		r = dm_dmub_hw_init(adev);
 		if (r)
 			DRM_ERROR("DMUB interface failed to initialize: status=%d\n", r);
@@ -2721,6 +2725,11 @@ static int dm_resume(void *handle)
 			}
 		}
 
+		if (dc_is_dmub_outbox_supported(adev->dm.dc)) {
+			amdgpu_dm_outbox_init(adev);
+			dc_enable_dmub_outbox(adev->dm.dc);
+		}
+
 		WARN_ON(!dc_commit_state(dm->dc, dc_state));
 
 		dm_gpureset_commit_state(dm->cached_dc_state, dm);
@@ -2742,13 +2751,15 @@ static int dm_resume(void *handle)
 	/* TODO: Remove dc_state->dccg, use dc->dccg directly. */
 	dc_resource_state_construct(dm->dc, dm_state->context);
 
-	/* Re-enable outbox interrupts for DPIA. */
-	if (dc_enable_dmub_notifications(adev->dm.dc))
-		amdgpu_dm_outbox_init(adev);
-
 	/* Before powering on DC we need to re-initialize DMUB. */
 	dm_dmub_hw_resume(adev);
 
+	/* Re-enable outbox interrupts for DPIA. */
+	if (dc_is_dmub_outbox_supported(adev->dm.dc)) {
+		amdgpu_dm_outbox_init(adev);
+		dc_enable_dmub_outbox(adev->dm.dc);
+	}
+
 	/* power on hardware */
 	dc_set_power_state(dm->dc, DC_ACPI_CM_POWER_STATE_D0);
 



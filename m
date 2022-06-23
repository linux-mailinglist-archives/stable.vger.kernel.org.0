Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEAD35584E5
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbiFWRvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235245AbiFWRuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:50:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B9DA4E25;
        Thu, 23 Jun 2022 10:12:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E37C8B82490;
        Thu, 23 Jun 2022 17:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C48C3411B;
        Thu, 23 Jun 2022 17:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004319;
        bh=ZPveG1qtBko62rmc1Q9DuVC9fq5IAG68KyUJL+S6yus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pq7BfSUo17LyZUkdMd0KglTea7bNn4sNrcdDne0N1A8y1vme/fzJhXIp9isdlpish
         eIUZsvwZxt6ucf1AFF/OwaBffs/C9ISlKnVqodULkSsodNHDQnj2ws5ZlAeBdiXWpY
         XRVci1UbFWNuKG4s0ZIWlk0eldN6khp9fOFcfeuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Mikita Lipski <Mikita.Lipski@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 5.15 2/9] drm/amd/display: Dont reinitialize DMCUB on s0ix resume
Date:   Thu, 23 Jun 2022 18:44:45 +0200
Message-Id: <20220623164322.363030419@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164322.288837280@linuxfoundation.org>
References: <20220623164322.288837280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 79d6b9351f086e0f914a26915d96ab52286ec46c upstream.

[Why]
PSP will suspend and resume DMCUB. Driver should just wait for DMCUB to
finish the auto load before continuining instead of placing it into
reset, wiping its firmware state and reinitializing.

If we don't let DMCUB fully finish initializing for S0ix then some state
will be lost and screen corruption can occur due to incorrect address
translation.

[How]
Use dmub_srv callbacks to determine in DMCUB is running and wait for
auto-load to complete before continuining.

In S0ix DMCUB will be running and DAL fw so initialize will skip.

In S3 DMCUB will not be running and we will do a full hardware init.

In S3 DMCUB will be running but will not be DAL fw so we will also do
a full hardware init.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Mikita Lipski <Mikita.Lipski@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   30 +++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -989,6 +989,32 @@ static int dm_dmub_hw_init(struct amdgpu
 	return 0;
 }
 
+static void dm_dmub_hw_resume(struct amdgpu_device *adev)
+{
+	struct dmub_srv *dmub_srv = adev->dm.dmub_srv;
+	enum dmub_status status;
+	bool init;
+
+	if (!dmub_srv) {
+		/* DMUB isn't supported on the ASIC. */
+		return;
+	}
+
+	status = dmub_srv_is_hw_init(dmub_srv, &init);
+	if (status != DMUB_STATUS_OK)
+		DRM_WARN("DMUB hardware init check failed: %d\n", status);
+
+	if (status == DMUB_STATUS_OK && init) {
+		/* Wait for firmware load to finish. */
+		status = dmub_srv_wait_for_auto_load(dmub_srv, 100000);
+		if (status != DMUB_STATUS_OK)
+			DRM_WARN("Wait for DMUB auto-load failed: %d\n", status);
+	} else {
+		/* Perform the full hardware initialization. */
+		dm_dmub_hw_init(adev);
+	}
+}
+
 #if defined(CONFIG_DRM_AMD_DC_DCN)
 static void mmhub_read_system_context(struct amdgpu_device *adev, struct dc_phy_addr_space_config *pa_config)
 {
@@ -2268,9 +2294,7 @@ static int dm_resume(void *handle)
 		amdgpu_dm_outbox_init(adev);
 
 	/* Before powering on DC we need to re-initialize DMUB. */
-	r = dm_dmub_hw_init(adev);
-	if (r)
-		DRM_ERROR("DMUB interface failed to initialize: status=%d\n", r);
+	dm_dmub_hw_resume(adev);
 
 	/* power on hardware */
 	dc_set_power_state(dm->dc, DC_ACPI_CM_POWER_STATE_D0);



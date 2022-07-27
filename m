Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3F1582DE0
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiG0REq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241293AbiG0RDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:03:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351D659243;
        Wed, 27 Jul 2022 09:38:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CED8FB8200C;
        Wed, 27 Jul 2022 16:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27571C433C1;
        Wed, 27 Jul 2022 16:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939928;
        bh=JwfJW2ukWURVYGvjwNjCvPygdx8i2v4juOJY2PSaQ+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXrNf/2hf/RP/P82PCGwi7OdqR6svrakzv4gI5M2Z9h+sxd61olWCvYg2nnEYEm7f
         44Gw8nNygl3AVKceVUIqJ/4TR5boGMrxqdWiSyc1EjvjtXs3osfpn+C4yitiW0NeK4
         KPvsUzG5840gQy3XN055IK8kF3vLOVfMeuPp4WLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/201] drm/amd/display: Ignore First MST Sideband Message Return Error
Date:   Wed, 27 Jul 2022 18:09:10 +0200
Message-Id: <20220727161028.781697992@linuxfoundation.org>
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

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit acea108fa067d140bd155161a79b1fcd967f4137 ]

[why]
First MST sideband message returns AUX_RET_ERROR_HPD_DISCON
on certain intel platform. Aux transaction considered failure
if HPD unexpected pulled low. The actual aux transaction success
in such case, hence do not return error.

[how]
Not returning error when AUX_RET_ERROR_HPD_DISCON detected
on the first sideband message.

v2: squash in additional DMI entries
v3: squash in static fix

Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 39 +++++++++++++++++++
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  8 ++++
 .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 17 ++++++++
 3 files changed, 64 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 873cb0051952..7150afacbc4f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -70,6 +70,7 @@
 #include <linux/pci.h>
 #include <linux/firmware.h>
 #include <linux/component.h>
+#include <linux/dmi.h>
 
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_uapi.h>
@@ -1344,6 +1345,41 @@ static bool dm_should_disable_stutter(struct pci_dev *pdev)
 	return false;
 }
 
+static const struct dmi_system_id hpd_disconnect_quirk_table[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3660"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3260"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3460"),
+		},
+	},
+	{}
+};
+
+static void retrieve_dmi_info(struct amdgpu_display_manager *dm)
+{
+	const struct dmi_system_id *dmi_id;
+
+	dm->aux_hpd_discon_quirk = false;
+
+	dmi_id = dmi_first_match(hpd_disconnect_quirk_table);
+	if (dmi_id) {
+		dm->aux_hpd_discon_quirk = true;
+		DRM_INFO("aux_hpd_discon_quirk attached\n");
+	}
+}
+
 static int amdgpu_dm_init(struct amdgpu_device *adev)
 {
 	struct dc_init_data init_data;
@@ -1435,6 +1471,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	init_data.flags.power_down_display_on_boot = true;
 
 	INIT_LIST_HEAD(&adev->dm.da_list);
+
+	retrieve_dmi_info(&adev->dm);
+
 	/* Display Core create. */
 	adev->dm.dc = dc_create(&init_data);
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index cd059af033b4..f9c3e5a41713 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -539,6 +539,14 @@ struct amdgpu_display_manager {
 	 * last successfully applied backlight values.
 	 */
 	u32 actual_brightness[AMDGPU_DM_MAX_NUM_EDP];
+
+	/**
+	 * @aux_hpd_discon_quirk:
+	 *
+	 * quirk for hpd discon while aux is on-going.
+	 * occurred on certain intel platform
+	 */
+	bool aux_hpd_discon_quirk;
 };
 
 enum dsc_clock_force_state {
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 74885ff77f96..652cf108b3c2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -55,6 +55,8 @@ static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
 	ssize_t result = 0;
 	struct aux_payload payload;
 	enum aux_return_code_type operation_result;
+	struct amdgpu_device *adev;
+	struct ddc_service *ddc;
 
 	if (WARN_ON(msg->size > 16))
 		return -E2BIG;
@@ -71,6 +73,21 @@ static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
 	result = dc_link_aux_transfer_raw(TO_DM_AUX(aux)->ddc_service, &payload,
 				      &operation_result);
 
+	/*
+	 * w/a on certain intel platform where hpd is unexpected to pull low during
+	 * 1st sideband message transaction by return AUX_RET_ERROR_HPD_DISCON
+	 * aux transaction is succuess in such case, therefore bypass the error
+	 */
+	ddc = TO_DM_AUX(aux)->ddc_service;
+	adev = ddc->ctx->driver_context;
+	if (adev->dm.aux_hpd_discon_quirk) {
+		if (msg->address == DP_SIDEBAND_MSG_DOWN_REQ_BASE &&
+			operation_result == AUX_RET_ERROR_HPD_DISCON) {
+			result = 0;
+			operation_result = AUX_RET_SUCCESS;
+		}
+	}
+
 	if (payload.write && result >= 0)
 		result = msg->size;
 
-- 
2.35.1




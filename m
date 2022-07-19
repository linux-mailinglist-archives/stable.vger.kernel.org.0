Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFAB579E79
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239939AbiGSNB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239532AbiGSM7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:59:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA2149B60;
        Tue, 19 Jul 2022 05:24:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E056761922;
        Tue, 19 Jul 2022 12:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7962C341DC;
        Tue, 19 Jul 2022 12:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233453;
        bh=mPWFpi/NvBUG7VpmrRy9y9gCA5c8Z8stgsW5SFbdZ2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HaRjCKKSE8fD3UnkQF68uIWrlbNY4odHPONtNfSwq8y/COM3zF+neHLPo1Ab00xN+
         m5b6C/onLGVFcb6EiLJq6QsNEX5h73JFwGoSCe7e9IBqy+tVFPeLBwF7OSNfy2esb8
         ZhadPV2eASJXxMhp9YXm3e2IzP1tXOnuHwkNO+7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 128/231] drm/amd/display: Ignore First MST Sideband Message Return Error
Date:   Tue, 19 Jul 2022 13:53:33 +0200
Message-Id: <20220719114725.221481298@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index b55a433e829e..bfbd701a4c9a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -72,6 +72,7 @@
 #include <linux/pci.h>
 #include <linux/firmware.h>
 #include <linux/component.h>
+#include <linux/dmi.h>
 
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_uapi.h>
@@ -1391,6 +1392,41 @@ static bool dm_should_disable_stutter(struct pci_dev *pdev)
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
@@ -1521,6 +1557,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	}
 
 	INIT_LIST_HEAD(&adev->dm.da_list);
+
+	retrieve_dmi_info(&adev->dm);
+
 	/* Display Core create. */
 	adev->dm.dc = dc_create(&init_data);
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index 7e44b0429448..4844601a5f47 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -546,6 +546,14 @@ struct amdgpu_display_manager {
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
index 31ac1fce36f8..d864cae1af67 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -58,6 +58,8 @@ static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
 	ssize_t result = 0;
 	struct aux_payload payload;
 	enum aux_return_code_type operation_result;
+	struct amdgpu_device *adev;
+	struct ddc_service *ddc;
 
 	if (WARN_ON(msg->size > 16))
 		return -E2BIG;
@@ -76,6 +78,21 @@ static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
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




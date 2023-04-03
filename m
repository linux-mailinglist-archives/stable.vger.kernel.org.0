Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BD26D4895
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbjDCO35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbjDCO35 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:29:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B6A319AC
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:29:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1ED3B81C35
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E07CC433EF;
        Mon,  3 Apr 2023 14:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532192;
        bh=yt2xspnziQyghcapB4fI6CczcjmVRMHNVnKM19RtAUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wyrBoXW3WFZFfMe2pepbPMF0rf9BKXjxpeIdiPSO18G1gI900IFOLVTvut95sJ+lJ
         x9IPrWHUDL4EhHY/vi3tc/f0KUHV4EA9/v6dI2kdhJHMsKBgf0z5moddb1eZFeyvgO
         WUac2wyH0zlTkcPACSX/gk+/K9IkEvdpyNznN5mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hersen Wu <hersenxs.wu@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 163/173] drm/amd/display: Add DSC Support for Synaptics Cascaded MST Hub
Date:   Mon,  3 Apr 2023 16:09:38 +0200
Message-Id: <20230403140419.720099873@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

commit f4f3b7dedbe849e780c779ba67365bb1db0d8637 upstream.

Traditional synaptics hub has one MST branch device without virtual dpcd.
Synaptics cascaded hub has two chained MST branch devices. DSC decoding
is performed via root MST branch device, instead of the second MST branch
device.

Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |   19 ++++++++++++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h |   12 +++++++
 2 files changed, 31 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -164,6 +164,21 @@ static bool needs_dsc_aux_workaround(str
 	return false;
 }
 
+bool is_synaptics_cascaded_panamera(struct dc_link *link, struct drm_dp_mst_port *port)
+{
+	u8 branch_vendor_data[4] = { 0 }; // Vendor data 0x50C ~ 0x50F
+
+	if (drm_dp_dpcd_read(port->mgr->aux, DP_BRANCH_VENDOR_SPECIFIC_START, &branch_vendor_data, 4) == 4) {
+		if (link->dpcd_caps.branch_dev_id == DP_BRANCH_DEVICE_ID_90CC24 &&
+				IS_SYNAPTICS_CASCADED_PANAMERA(link->dpcd_caps.branch_dev_name, branch_vendor_data)) {
+			DRM_INFO("Synaptics Cascaded MST hub\n");
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static bool validate_dsc_caps_on_connector(struct amdgpu_dm_connector *aconnector)
 {
 	struct dc_sink *dc_sink = aconnector->dc_sink;
@@ -185,6 +200,10 @@ static bool validate_dsc_caps_on_connect
 	    needs_dsc_aux_workaround(aconnector->dc_link))
 		aconnector->dsc_aux = &aconnector->mst_port->dm_dp_aux.aux;
 
+	/* synaptics cascaded MST hub case */
+	if (!aconnector->dsc_aux && is_synaptics_cascaded_panamera(aconnector->dc_link, port))
+		aconnector->dsc_aux = port->mgr->aux;
+
 	if (!aconnector->dsc_aux)
 		return false;
 
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
@@ -26,6 +26,18 @@
 #ifndef __DAL_AMDGPU_DM_MST_TYPES_H__
 #define __DAL_AMDGPU_DM_MST_TYPES_H__
 
+#define DP_BRANCH_VENDOR_SPECIFIC_START 0x50C
+
+/**
+ * Panamera MST Hub detection
+ * Offset DPCD 050Eh == 0x5A indicates cascaded MST hub case
+ * Check from beginning of branch device vendor specific field (050Ch)
+ */
+#define IS_SYNAPTICS_PANAMERA(branchDevName) (((int)branchDevName[4] & 0xF0) == 0x50 ? 1 : 0)
+#define BRANCH_HW_REVISION_PANAMERA_A2 0x10
+#define SYNAPTICS_CASCADED_HUB_ID  0x5A
+#define IS_SYNAPTICS_CASCADED_PANAMERA(devName, data) ((IS_SYNAPTICS_PANAMERA(devName) && ((int)data[2] == SYNAPTICS_CASCADED_HUB_ID)) ? 1 : 0)
+
 struct amdgpu_display_manager;
 struct amdgpu_dm_connector;
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9681C6D4ADC
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbjDCOux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbjDCOuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:50:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A3B2D482
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:50:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 67D36CE130A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A022C433EF;
        Mon,  3 Apr 2023 14:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533401;
        bh=j0Jeu4RnpYJiX8Pp4sc66dpNEQtfQUwKb286o999eRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYEktuIVBbDjgKdEWZgvfnarq/wuT4Uy52lu8JDSJ8uTnzvvgDdo3Z9d0qyQRG9mw
         +kdeb7QQHP/foISmzpvX3Yytriq/BddXrA78YK/rkKAxC+x3WJf6NAjKAgR0ml8n3A
         CismIGndmX0j5OgsA/yyaaE1u6hT6PJeoxP6CHGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hersen Wu <hersenxs.wu@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 169/187] drm/amd/display: Add DSC Support for Synaptics Cascaded MST Hub
Date:   Mon,  3 Apr 2023 16:10:14 +0200
Message-Id: <20230403140421.788753406@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
@@ -208,6 +208,21 @@ bool needs_dsc_aux_workaround(struct dc_
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
@@ -231,6 +246,10 @@ static bool validate_dsc_caps_on_connect
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
@@ -34,6 +34,18 @@
 #define SYNAPTICS_RC_OFFSET        0x4BC
 #define SYNAPTICS_RC_DATA          0x4C0
 
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
 



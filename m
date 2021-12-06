Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72828469DD1
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358921AbhLFPdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:33:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45790 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350129AbhLFP2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:28:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 199236132E;
        Mon,  6 Dec 2021 15:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F384BC34900;
        Mon,  6 Dec 2021 15:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804294;
        bh=RoFTdMDvCZNKdsef/NMYsmDS+YG+Znkd4xr9h+oIAq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VkwGt98oDQtXB8zubq+g5A1Bx/uej9smUHZ77i76sMi25G/srMT/XyRM6TjHwJ1cs
         FaDas0iN4WfzfGLLc+OUEEbSdQF+dqaIe1b2uM/T1Brm0LXumR1USvc+3mKfspzQrW
         7BdhlDA8KDODdpKoKC1Ert6ZeHDZujXBonwX26Qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hersen Wu <hersenxs.wu@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 068/207] drm/amd/display: Allow DSC on supported MST branch devices
Date:   Mon,  6 Dec 2021 15:55:22 +0100
Message-Id: <20211206145612.587017042@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 94ebc035456a4ccacfbbef60c444079a256623ad upstream.

[Why]
When trying to lightup two 4k60 non-DSC displays behind a branch device
that supports DSC we can't lightup both at once due to bandwidth
limitations - each requires 48 VCPI slots but we only have 63.

[How]
The workaround already exists in the code but is guarded by a CONFIG
that cannot be set by the user and shouldn't need to be.

Check for specific branch device IDs to device whether to enable
the workaround for multiple display scenarios.

Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |   20 +++++++++---
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -36,6 +36,8 @@
 #include "dm_helpers.h"
 
 #include "dc_link_ddc.h"
+#include "ddc_service_types.h"
+#include "dpcd_defs.h"
 
 #include "i2caux_interface.h"
 #include "dmub_cmd.h"
@@ -155,6 +157,16 @@ static const struct drm_connector_funcs
 };
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
+static bool needs_dsc_aux_workaround(struct dc_link *link)
+{
+	if (link->dpcd_caps.branch_dev_id == DP_BRANCH_DEVICE_ID_90CC24 &&
+	    (link->dpcd_caps.dpcd_rev.raw == DPCD_REV_14 || link->dpcd_caps.dpcd_rev.raw == DPCD_REV_12) &&
+	    link->dpcd_caps.sink_count.bits.SINK_COUNT >= 2)
+		return true;
+
+	return false;
+}
+
 static bool validate_dsc_caps_on_connector(struct amdgpu_dm_connector *aconnector)
 {
 	struct dc_sink *dc_sink = aconnector->dc_sink;
@@ -164,7 +176,7 @@ static bool validate_dsc_caps_on_connect
 	u8 *dsc_branch_dec_caps = NULL;
 
 	aconnector->dsc_aux = drm_dp_mst_dsc_aux_for_port(port);
-#if defined(CONFIG_HP_HOOK_WORKAROUND)
+
 	/*
 	 * drm_dp_mst_dsc_aux_for_port() will return NULL for certain configs
 	 * because it only check the dsc/fec caps of the "port variable" and not the dock
@@ -174,10 +186,10 @@ static bool validate_dsc_caps_on_connect
 	 * Workaround: explicitly check the use case above and use the mst dock's aux as dsc_aux
 	 *
 	 */
-
-	if (!aconnector->dsc_aux && !port->parent->port_parent)
+	if (!aconnector->dsc_aux && !port->parent->port_parent &&
+	    needs_dsc_aux_workaround(aconnector->dc_link))
 		aconnector->dsc_aux = &aconnector->mst_port->dm_dp_aux.aux;
-#endif
+
 	if (!aconnector->dsc_aux)
 		return false;
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3BF45C627
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348516AbhKXOFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353855AbhKXOCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:02:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DEB861A89;
        Wed, 24 Nov 2021 13:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759431;
        bh=Ka+zEGUZOVsoQnCeaK6VRRYvwVFfgRITpizdPCjqItA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jiRd8z8F2H11JdGVmQkvQ1BA4iw3nGBXQbgI6mwGatoVxzy11F4EVCbKhmugo12FX
         vDQVa6bIzIdscNyt6qIrrj36pL6DwsgUTf6fmZd7Q1G+QdhQS+dmDBBJxAdfL85U10
         KwKdGHgLfLwDD3RCWBVPz4baGdWopwOnQl8QKcK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Roman Li <Roman.Li@amd.com>,
        Daniel Wheeler <Daniel.Wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 240/279] drm/amd/display: Limit max DSC target bpp for specific monitors
Date:   Wed, 24 Nov 2021 12:58:47 +0100
Message-Id: <20211124115727.024026560@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <Roman.Li@amd.com>

commit 55eea8ef98641f6e1e1c202bd3a49a57c1dd4059 upstream.

[Why]
Some monitors exhibit corruption at 16bpp DSC.

[How]
- Add helpers for patching edid caps.
- Use it for limiting DSC target bitrate to 15bpp for known monitors

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Cc: stable@vger.kernel.org
Tested-by: Daniel Wheeler <Daniel.Wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |   35 ++++++++++++++
 1 file changed, 35 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -40,6 +40,39 @@
 
 #include "dm_helpers.h"
 
+struct monitor_patch_info {
+	unsigned int manufacturer_id;
+	unsigned int product_id;
+	void (*patch_func)(struct dc_edid_caps *edid_caps, unsigned int param);
+	unsigned int patch_param;
+};
+static void set_max_dsc_bpp_limit(struct dc_edid_caps *edid_caps, unsigned int param);
+
+static const struct monitor_patch_info monitor_patch_table[] = {
+{0x6D1E, 0x5BBF, set_max_dsc_bpp_limit, 15},
+{0x6D1E, 0x5B9A, set_max_dsc_bpp_limit, 15},
+};
+
+static void set_max_dsc_bpp_limit(struct dc_edid_caps *edid_caps, unsigned int param)
+{
+	if (edid_caps)
+		edid_caps->panel_patch.max_dsc_target_bpp_limit = param;
+}
+
+static int amdgpu_dm_patch_edid_caps(struct dc_edid_caps *edid_caps)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < ARRAY_SIZE(monitor_patch_table); i++)
+		if ((edid_caps->manufacturer_id == monitor_patch_table[i].manufacturer_id)
+			&&  (edid_caps->product_id == monitor_patch_table[i].product_id)) {
+			monitor_patch_table[i].patch_func(edid_caps, monitor_patch_table[i].patch_param);
+			ret++;
+		}
+
+	return ret;
+}
+
 /* dm_helpers_parse_edid_caps
  *
  * Parse edid caps
@@ -125,6 +158,8 @@ enum dc_edid_status dm_helpers_parse_edi
 	kfree(sads);
 	kfree(sadb);
 
+	amdgpu_dm_patch_edid_caps(edid_caps);
+
 	return result;
 }
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0AB429078
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241281AbhJKOJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:09:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239884AbhJKOGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:06:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A67AF611EE;
        Mon, 11 Oct 2021 14:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960821;
        bh=wsUlw5FxxfQRI5voO6jhT8HnMV9BwtU80Pozpv5APxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+E5eC5eBw+eY91nWtGExf4/CbBfxxO+TkfmwVnUa4K0F0SRePCFGz/qelwzoRyDu
         effG0FshFAZaCffIDNUYf9RKdtfdU713SHjksroLvVcIWsETgjtoFl1e8bLvWPuhh4
         chtJtLIIsHuVMVTv21fX5+RK/0KGky1ULEwcF608=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Majczak <lma@semihalf.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 085/151] drm/i915/bdb: Fix version check
Date:   Mon, 11 Oct 2021 15:45:57 +0200
Message-Id: <20211011134520.589866937@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Majczak <lma@semihalf.com>

[ Upstream commit fdddf8c3a477f77b3a623f220e78d45e89fc50d5 ]

With patch "drm/i915/vbt: Fix backlight parsing for VBT 234+"
the size of bdb_lfp_backlight_data structure has been increased,
causing if-statement in the parse_lfp_backlight function
that comapres this structure size to the one retrieved from BDB,
always to fail for older revisions.
This patch calculates expected size of the structure for a given
BDB version and compares it with the value gathered from BDB.
Tested on Chromebook Pixelbook (Nocturne) (reports bdb->version = 221)

Fixes: d381baad29b4 ("drm/i915/vbt: Fix backlight parsing for VBT 234+")

Tested-by: Lukasz Majczak <lma@semihalf.com>
Signed-off-by: Lukasz Majczak <lma@semihalf.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210930134606.227234-1-lma@semihalf.com
(cherry picked from commit 4378daf5d04eed59724e6d0e74755e17dce2e105)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_bios.c     | 22 ++++++++++++++-----
 drivers/gpu/drm/i915/display/intel_vbt_defs.h |  5 +++++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index aa667fa71158..106f696e50a0 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -451,13 +451,23 @@ parse_lfp_backlight(struct drm_i915_private *i915,
 	}
 
 	i915->vbt.backlight.type = INTEL_BACKLIGHT_DISPLAY_DDI;
-	if (bdb->version >= 191 &&
-	    get_blocksize(backlight_data) >= sizeof(*backlight_data)) {
-		const struct lfp_backlight_control_method *method;
+	if (bdb->version >= 191) {
+		size_t exp_size;
 
-		method = &backlight_data->backlight_control[panel_type];
-		i915->vbt.backlight.type = method->type;
-		i915->vbt.backlight.controller = method->controller;
+		if (bdb->version >= 236)
+			exp_size = sizeof(struct bdb_lfp_backlight_data);
+		else if (bdb->version >= 234)
+			exp_size = EXP_BDB_LFP_BL_DATA_SIZE_REV_234;
+		else
+			exp_size = EXP_BDB_LFP_BL_DATA_SIZE_REV_191;
+
+		if (get_blocksize(backlight_data) >= exp_size) {
+			const struct lfp_backlight_control_method *method;
+
+			method = &backlight_data->backlight_control[panel_type];
+			i915->vbt.backlight.type = method->type;
+			i915->vbt.backlight.controller = method->controller;
+		}
 	}
 
 	i915->vbt.backlight.pwm_freq_hz = entry->pwm_freq_hz;
diff --git a/drivers/gpu/drm/i915/display/intel_vbt_defs.h b/drivers/gpu/drm/i915/display/intel_vbt_defs.h
index dbe24d7e7375..cf1ffe4a0e46 100644
--- a/drivers/gpu/drm/i915/display/intel_vbt_defs.h
+++ b/drivers/gpu/drm/i915/display/intel_vbt_defs.h
@@ -814,6 +814,11 @@ struct lfp_brightness_level {
 	u16 reserved;
 } __packed;
 
+#define EXP_BDB_LFP_BL_DATA_SIZE_REV_191 \
+	offsetof(struct bdb_lfp_backlight_data, brightness_level)
+#define EXP_BDB_LFP_BL_DATA_SIZE_REV_234 \
+	offsetof(struct bdb_lfp_backlight_data, brightness_precision_bits)
+
 struct bdb_lfp_backlight_data {
 	u8 entry_size;
 	struct lfp_backlight_data_entry data[16];
-- 
2.33.0




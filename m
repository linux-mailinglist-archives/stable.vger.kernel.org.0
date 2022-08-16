Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5DD595E9B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 16:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbiHPOzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 10:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiHPOzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 10:55:20 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6337C508
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 07:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660661719; x=1692197719;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=COQx16o+CLis8ml1K7qamjyZf1B6XhWD5Ah1vKJIE14=;
  b=Ee4VBXQcOOAhhjVBy1levG+yxY8IOsouW/vkorbtTwJhHQEjau5mis6L
   Ol6fwh+W5g5UeoMNl0yStPXqMmjYRBoT/IXxMf3ImDUlEouk+NqNHkM/3
   KnPShg+KHdWLRBwNTlVMKWniRGqJQJwESxtBP+THYt2KyaAmBvXZOZlGT
   mdOtjWeCYf4dWBp+4MVuqsY3ljfu3vHEz6dKXZhAaCaZlP0xG6J54VpUW
   uX5ljTSk3WKQUTbgsqP37YtYdRFlojSJvxZVIYkdnaQMbIhzmoX8xXiYl
   kP/ELY9LJB2WpvS2ydMCsn8V/u+BKykISPpJlzA2fx4rIzk/YNr40SclV
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="293515198"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="293515198"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 07:55:19 -0700
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="635923550"
Received: from kinzelba-mobl.ger.corp.intel.com (HELO localhost) ([10.252.39.194])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 07:55:17 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     jani.nikula@intel.com, stable@vger.kernel.org
Subject: [PATCH 1/3] drm/i915/dsi: filter invalid backlight and CABC ports
Date:   Tue, 16 Aug 2022 17:55:08 +0300
Message-Id: <b0f4f087866257d280eb97d6bcfcefd109cc5fa2.1660661647.git.jani.nikula@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1660661647.git.jani.nikula@intel.com>
References: <cover.1660661647.git.jani.nikula@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Avoid using ports that aren't initialized in case the VBT backlight or
CABC ports have invalid values. This fixes a NULL pointer dereference of
intel_dsi->dsi_hosts[port] in such cases.

Cc: stable@vger.kernel.org
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/display/icl_dsi.c | 7 +++++++
 drivers/gpu/drm/i915/display/vlv_dsi.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
index 5dcfa7feffa9..885c74f60366 100644
--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -2070,7 +2070,14 @@ void icl_dsi_init(struct drm_i915_private *dev_priv)
 	else
 		intel_dsi->ports = BIT(port);
 
+	if (drm_WARN_ON(&dev_priv->drm, intel_connector->panel.vbt.dsi.bl_ports & ~intel_dsi->ports))
+		intel_connector->panel.vbt.dsi.bl_ports &= intel_dsi->ports;
+
 	intel_dsi->dcs_backlight_ports = intel_connector->panel.vbt.dsi.bl_ports;
+
+	if (drm_WARN_ON(&dev_priv->drm, intel_connector->panel.vbt.dsi.cabc_ports & ~intel_dsi->ports))
+		intel_connector->panel.vbt.dsi.cabc_ports &= intel_dsi->ports;
+
 	intel_dsi->dcs_cabc_ports = intel_connector->panel.vbt.dsi.cabc_ports;
 
 	for_each_dsi_port(port, intel_dsi->ports) {
diff --git a/drivers/gpu/drm/i915/display/vlv_dsi.c b/drivers/gpu/drm/i915/display/vlv_dsi.c
index b9b1fed99874..35136d26e517 100644
--- a/drivers/gpu/drm/i915/display/vlv_dsi.c
+++ b/drivers/gpu/drm/i915/display/vlv_dsi.c
@@ -1933,7 +1933,14 @@ void vlv_dsi_init(struct drm_i915_private *dev_priv)
 	else
 		intel_dsi->ports = BIT(port);
 
+	if (drm_WARN_ON(&dev_priv->drm, intel_connector->panel.vbt.dsi.bl_ports & ~intel_dsi->ports))
+		intel_connector->panel.vbt.dsi.bl_ports &= intel_dsi->ports;
+
 	intel_dsi->dcs_backlight_ports = intel_connector->panel.vbt.dsi.bl_ports;
+
+	if (drm_WARN_ON(&dev_priv->drm, intel_connector->panel.vbt.dsi.cabc_ports & ~intel_dsi->ports))
+		intel_connector->panel.vbt.dsi.cabc_ports &= intel_dsi->ports;
+
 	intel_dsi->dcs_cabc_ports = intel_connector->panel.vbt.dsi.cabc_ports;
 
 	/* Create a DSI host (and a device) for each port. */
-- 
2.34.1


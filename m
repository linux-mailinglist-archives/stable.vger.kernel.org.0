Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BEA5EA517
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238342AbiIZL5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238295AbiIZL4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:56:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3070158B75;
        Mon, 26 Sep 2022 03:51:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D66CB80957;
        Mon, 26 Sep 2022 10:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7017C433D6;
        Mon, 26 Sep 2022 10:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188977;
        bh=26rK1kT3JNgahVb+nuTchRLpOamrvO85/nRG2gjSRoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VuBD3P4YZTkqL489sIr31ga/KaANaB68npQ22M8fAPaPb/QdwU4qJxDZxB+zsoOsV
         /qNLNDtVwOLiScucdOAJLIIF83nhNblpDi8GhkTz9So4h/lXIGBUCcun+h4gbykVWi
         RkdsHVMdi+NsN35mvlydMmdXuaVOfWX6XYLcm3T0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 006/207] drm/i915/dsi: filter invalid backlight and CABC ports
Date:   Mon, 26 Sep 2022 12:09:55 +0200
Message-Id: <20220926100806.775793933@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 607f41768a1ef9c7721866b00fbdeeea5359bc07 ]

Avoid using ports that aren't initialized in case the VBT backlight or
CABC ports have invalid values. This fixes a NULL pointer dereference of
intel_dsi->dsi_hosts[port] in such cases.

Cc: stable@vger.kernel.org
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/b0f4f087866257d280eb97d6bcfcefd109cc5fa2.1660664162.git.jani.nikula@intel.com
(cherry picked from commit f4a6c7a454a6e71c5ccf25af82694213a9784013)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/icl_dsi.c | 7 +++++++
 drivers/gpu/drm/i915/display/vlv_dsi.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
index 5c46acb46516..f416499dad6f 100644
--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -2072,7 +2072,14 @@ void icl_dsi_init(struct drm_i915_private *dev_priv)
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
index be8fd3c362df..02f75e95b2ec 100644
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
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4924C761F
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239381AbiB1R7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:59:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239976AbiB1R7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:59:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513FA5B3D1;
        Mon, 28 Feb 2022 09:45:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 93CB1CE17C8;
        Mon, 28 Feb 2022 17:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A705DC340F1;
        Mon, 28 Feb 2022 17:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070306;
        bh=/ZVeTyBo9FlTqOrfp371Pfb9lM361Um3gBqhoOGd0yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YkgeP6nBpye8LOr6fE6Fx6a1//N9eye2OGIrzI4y+nGkj1Atng43RbYwXdempGX9k
         SE1K9nbI/TTxGEhRY0soCBrgIknQYMdIBnSVklGPoOwoAnLYisFhBBVOgNt4k82b1d
         RsPgM1bYzwnyoTnUY96de3F66uJ9u7XFlf9Rizgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.16 024/164] drm/i915: Disconnect PHYs left connected by BIOS on disabled ports
Date:   Mon, 28 Feb 2022 18:23:06 +0100
Message-Id: <20220228172402.290484867@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit a40ee54e9a0958406469d46def03eec62aea0b69 upstream.

BIOS may leave a TypeC PHY in a connected state even though the
corresponding port is disabled. This will prevent any hotplug events
from being signalled (after the monitor deasserts and then reasserts its
HPD) until the PHY is disconnected and so the driver will not detect a
connected sink. Rebooting with the PHY in the connected state also
results in a system hang.

Fix the above by disconnecting TypeC PHYs on disabled ports.

Before commit 64851a32c463e5 the PHY connected state was read out even
for disabled ports and later the PHY got disconnected as a side effect
of a tc_port_lock/unlock() sequence (during connector probing), hence
recovering the port's hotplug functionality.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/5014
Fixes: 64851a32c463 ("drm/i915/tc: Add a mode for the TypeC PHY's disconnected state")
Cc: <stable@vger.kernel.org> # v5.16+
Cc: José Roberto de Souza <jose.souza@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220217152237.670220-1-imre.deak@intel.com
(cherry picked from commit ed0ccf349ffd9c80e7376d4d8c608643de990e86)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_tc.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -691,6 +691,8 @@ void intel_tc_port_sanitize(struct intel
 {
 	struct drm_i915_private *i915 = to_i915(dig_port->base.base.dev);
 	struct intel_encoder *encoder = &dig_port->base;
+	intel_wakeref_t tc_cold_wref;
+	enum intel_display_power_domain domain;
 	int active_links = 0;
 
 	mutex_lock(&dig_port->tc_lock);
@@ -702,12 +704,11 @@ void intel_tc_port_sanitize(struct intel
 
 	drm_WARN_ON(&i915->drm, dig_port->tc_mode != TC_PORT_DISCONNECTED);
 	drm_WARN_ON(&i915->drm, dig_port->tc_lock_wakeref);
-	if (active_links) {
-		enum intel_display_power_domain domain;
-		intel_wakeref_t tc_cold_wref = tc_cold_block(dig_port, &domain);
 
-		dig_port->tc_mode = intel_tc_port_get_current_mode(dig_port);
+	tc_cold_wref = tc_cold_block(dig_port, &domain);
 
+	dig_port->tc_mode = intel_tc_port_get_current_mode(dig_port);
+	if (active_links) {
 		if (!icl_tc_phy_is_connected(dig_port))
 			drm_dbg_kms(&i915->drm,
 				    "Port %s: PHY disconnected with %d active link(s)\n",
@@ -716,10 +717,23 @@ void intel_tc_port_sanitize(struct intel
 
 		dig_port->tc_lock_wakeref = tc_cold_block(dig_port,
 							  &dig_port->tc_lock_power_domain);
-
-		tc_cold_unblock(dig_port, domain, tc_cold_wref);
+	} else {
+		/*
+		 * TBT-alt is the default mode in any case the PHY ownership is not
+		 * held (regardless of the sink's connected live state), so
+		 * we'll just switch to disconnected mode from it here without
+		 * a note.
+		 */
+		if (dig_port->tc_mode != TC_PORT_TBT_ALT)
+			drm_dbg_kms(&i915->drm,
+				    "Port %s: PHY left in %s mode on disabled port, disconnecting it\n",
+				    dig_port->tc_port_name,
+				    tc_port_mode_name(dig_port->tc_mode));
+		icl_tc_phy_disconnect(dig_port);
 	}
 
+	tc_cold_unblock(dig_port, domain, tc_cold_wref);
+
 	drm_dbg_kms(&i915->drm, "Port %s: sanitize mode (%s)\n",
 		    dig_port->tc_port_name,
 		    tc_port_mode_name(dig_port->tc_mode));



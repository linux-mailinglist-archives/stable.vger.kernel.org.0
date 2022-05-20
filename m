Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A25052E945
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 11:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242838AbiETJqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 05:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347946AbiETJqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 05:46:14 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707E04ECE5
        for <stable@vger.kernel.org>; Fri, 20 May 2022 02:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653039968; x=1684575968;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hTTgOjlH4z6Ps7yWa/ajW+B/YdSqd496sJ1eIbnJFhk=;
  b=EksMBkWaa0zT0TGV6qA+dnyIIlzbt65GVe3LY5L2k9BUmu6v5HAX0j+l
   21cdn7r0HOIJks3fp4KvXjb9u2qWlsRw5uGE2WSY6+fx9RpKaYmHT95T+
   RgiNpQb0EC8WtcKnmQ1np1ymOCZAjpCEDnDS1LimdB7RakCTddzmxdsV9
   h7ARL5qdrOP1Pml+zMR3GRBOgj4+r4hdbTQZXIV7Ode7Wg1C+esLtM0zB
   dCtfv8AZGmjNku/vIJsev2daHrIs9xlQYPka7v+e8ZuPwvqCm0G9FKllS
   EzFLSJGPSi4BCGnd56it6Rpaz+Pfzj0ru7Vp6tFX6A/9i19meFJmbMGdm
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="272528562"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="272528562"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 02:46:07 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="546601099"
Received: from kpradzyn-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.134.23])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 02:46:06 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Jani Nikula <jani.nikula@intel.com>, stable@vger.kernel.org,
        Ville Syrjala <ville.syrjala@linux.intel.com>
Subject: [PATCH] drm/i915/dsi: fix VBT send packet port selection for ICL+
Date:   Fri, 20 May 2022 12:46:00 +0300
Message-Id: <20220520094600.2066945-1-jani.nikula@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The VBT send packet port selection was never updated for ICL+ where the
2nd link is on port B instead of port C as in VLV+ DSI.

First, single link DSI needs to use the configured port instead of
relying on the VBT sequence block port. Remove the hard-coded port C
check here and make it generic. For reference, see commit f915084edc5a
("drm/i915: Changes related to the sequence port no for") for the
original VLV specific fix.

Second, the sequence block port number is either 0 or 1, where 1
indicates the 2nd link. Remove the hard-coded port C here for 2nd
link. (This could be a "find second set bit" on DSI ports, but just
check the two possible options.)

Third, sanity check the result with a warning to avoid a NULL pointer
dereference.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/5984
Cc: stable@vger.kernel.org # v4.19+
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c | 33 +++++++++++++-------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
index f370e9c4350d..dd24aef925f2 100644
--- a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
+++ b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
@@ -125,9 +125,25 @@ struct i2c_adapter_lookup {
 #define  ICL_GPIO_DDPA_CTRLCLK_2	8
 #define  ICL_GPIO_DDPA_CTRLDATA_2	9
 
-static enum port intel_dsi_seq_port_to_port(u8 port)
+static enum port intel_dsi_seq_port_to_port(struct intel_dsi *intel_dsi,
+					    u8 seq_port)
 {
-	return port ? PORT_C : PORT_A;
+	/*
+	 * If single link DSI is being used on any port, the VBT sequence block
+	 * send packet apparently always has 0 for the port. Just use the port
+	 * we have configured, and ignore the sequence block port.
+	 */
+	if (hweight8(intel_dsi->ports) == 1)
+		return ffs(intel_dsi->ports) - 1;
+
+	if (seq_port) {
+		if (intel_dsi->ports & PORT_B)
+			return PORT_B;
+		else if (intel_dsi->ports & PORT_C)
+			return PORT_C;
+	}
+
+	return PORT_A;
 }
 
 static const u8 *mipi_exec_send_packet(struct intel_dsi *intel_dsi,
@@ -149,15 +165,10 @@ static const u8 *mipi_exec_send_packet(struct intel_dsi *intel_dsi,
 
 	seq_port = (flags >> MIPI_PORT_SHIFT) & 3;
 
-	/* For DSI single link on Port A & C, the seq_port value which is
-	 * parsed from Sequence Block#53 of VBT has been set to 0
-	 * Now, read/write of packets for the DSI single link on Port A and
-	 * Port C will based on the DVO port from VBT block 2.
-	 */
-	if (intel_dsi->ports == (1 << PORT_C))
-		port = PORT_C;
-	else
-		port = intel_dsi_seq_port_to_port(seq_port);
+	port = intel_dsi_seq_port_to_port(intel_dsi, seq_port);
+
+	if (drm_WARN_ON(&dev_priv->drm, !intel_dsi->dsi_hosts[port]))
+		goto out;
 
 	dsi_device = intel_dsi->dsi_hosts[port]->device;
 	if (!dsi_device) {
-- 
2.30.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3360653EAAE
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239163AbiFFNnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 09:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239142AbiFFNnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 09:43:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4C78A067
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 06:43:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C5A6612E7
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 13:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEF5C385A9;
        Mon,  6 Jun 2022 13:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654523019;
        bh=4/3V/nqHjOgTJXMLeBzQOjSK0yvBVf+0Riw2JchFJFc=;
        h=Subject:To:Cc:From:Date:From;
        b=j7nlnj70bSRZe71bkiYCKTYz3qWMmBKeu3tRw45NRStnoZBRY7tGfSXY91Y8e5n3i
         Mg/dzlyB1an0xLrDwLfAZC3YZgT9XLJeixPB57pzwOIz7Xy/TO9RGVMg0leu3BTpVx
         2KjYH5V6he/pe3x2wwen+cApbjFoDwa4xc7b573o=
Subject: FAILED: patch "[PATCH] drm/i915/dsi: fix VBT send packet port selection for ICL+" failed to apply to 5.4-stable tree
To:     jani.nikula@intel.com, ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 15:43:29 +0200
Message-ID: <165452300995218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0ea917819d12fed41ea4662cc26ffa0060a5c354 Mon Sep 17 00:00:00 2001
From: Jani Nikula <jani.nikula@intel.com>
Date: Fri, 20 May 2022 12:46:00 +0300
Subject: [PATCH] drm/i915/dsi: fix VBT send packet port selection for ICL+
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220520094600.2066945-1-jani.nikula@intel.com
(cherry picked from commit 08c59dde71b73a0ac94e3ed2d431345b01f20485)

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


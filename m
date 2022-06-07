Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93475407CA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346979AbiFGRwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348980AbiFGRuY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:50:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F10137440;
        Tue,  7 Jun 2022 10:37:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56882B822B1;
        Tue,  7 Jun 2022 17:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69A0C385A5;
        Tue,  7 Jun 2022 17:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623456;
        bh=RJrjyvSFLG5vaE/YCedMXiTGe5JIDbSiGT/RnpKzjtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ds1qUW3KKPSHvnlL8cgp4OsU8WZUWJrMNyah5Izpm3YFo3j+3tj9TfbtevTVO1Eg0
         UwP2xPVyE4zn8PcXaEa0hseg27pwg4QyHODTVTKH3IpHIL4V2gCSj2NWYVLTILqM3x
         Prndqd9cWew1oYjZuDwDIkjThnmQJcBIPPtG6kUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 383/452] drm/i915/dsi: fix VBT send packet port selection for ICL+
Date:   Tue,  7 Jun 2022 19:04:00 +0200
Message-Id: <20220607164919.978470651@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jani Nikula <jani.nikula@intel.com>

commit 0ea917819d12fed41ea4662cc26ffa0060a5c354 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c |   33 ++++++++++++++++++---------
 1 file changed, 22 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
+++ b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
@@ -121,9 +121,25 @@ struct i2c_adapter_lookup {
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
@@ -145,15 +161,10 @@ static const u8 *mipi_exec_send_packet(s
 
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



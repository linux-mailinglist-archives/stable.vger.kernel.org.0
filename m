Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7106F635746
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238008AbiKWJk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237752AbiKWJkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:40:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA55A20BCE
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:37:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2715161B43
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04769C433D6;
        Wed, 23 Nov 2022 09:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196268;
        bh=wqasGLDi0jORkIHGew2v/6vQ3u7ANilAOMGOQtetPEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVCkVmAUV0u9oG6VtPiTryd6m2uWtGcKL2usXPKMir6tc01OzWLtO4y0RRBayxQVP
         sMFfFUJlQDYruXMtnQgnUesJRB7H0AgdwlTr/VliXeXCdvDcu+h1/Mo1gGBTaijvoX
         m01i3q2TrF6QM0JGtUW8dvHAVaiOAuzzPDaACn0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Rajat Khandelwal <rajat.khandelwal@linux.intel.com>,
        Lee Shawn C <shawn.c.lee@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 134/181] usb: typec: mux: Enter safe mode only when pins need to be reconfigured
Date:   Wed, 23 Nov 2022 09:51:37 +0100
Message-Id: <20221123084608.133949304@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajat Khandelwal <rajat.khandelwal@linux.intel.com>

commit 40bf8f162d0f95e0716e479d7db41443d931765c upstream.

There is no point to enter safe mode during DP/TBT configuration
if the DP/TBT was already configured in mux. This is because safe
mode is only applicable when there is a need to reconfigure the
pins in order to avoid damage within/to port partner.

In some chrome systems, IOM/mux is already configured before OS
comes up. Thus, when driver is probed, it blindly enters safe
mode due to PD negotiations but only after gfx driver lowers
dp_phy_ownership, will the IOM complete safe mode and send an
ack to PMC.
Since, that never happens, we see IPC timeout.

Hence, allow safe mode only when pin reconfiguration is not
required, which makes sense.

Fixes: 43d596e32276 ("usb: typec: intel_pmc_mux: Check the port status before connect")
Cc: stable <stable@kernel.org>
Signed-off-by: Rajat Khandelwal <rajat.khandelwal@linux.intel.com>
Signed-off-by: Lee Shawn C <shawn.c.lee@intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221024171611.181468-1-rajat.khandelwal@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux/intel_pmc_mux.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -352,13 +352,24 @@ pmc_usb_mux_usb4(struct pmc_usb_port *po
 	return pmc_usb_command(port, (void *)&req, sizeof(req));
 }
 
-static int pmc_usb_mux_safe_state(struct pmc_usb_port *port)
+static int pmc_usb_mux_safe_state(struct pmc_usb_port *port,
+				  struct typec_mux_state *state)
 {
 	u8 msg;
 
 	if (IOM_PORT_ACTIVITY_IS(port->iom_status, SAFE_MODE))
 		return 0;
 
+	if ((IOM_PORT_ACTIVITY_IS(port->iom_status, DP) ||
+	     IOM_PORT_ACTIVITY_IS(port->iom_status, DP_MFD)) &&
+	     state->alt && state->alt->svid == USB_TYPEC_DP_SID)
+		return 0;
+
+	if ((IOM_PORT_ACTIVITY_IS(port->iom_status, TBT) ||
+	     IOM_PORT_ACTIVITY_IS(port->iom_status, ALT_MODE_TBT_USB)) &&
+	     state->alt && state->alt->svid == USB_TYPEC_TBT_SID)
+		return 0;
+
 	msg = PMC_USB_SAFE_MODE;
 	msg |= port->usb3_port << PMC_USB_MSG_USB3_PORT_SHIFT;
 
@@ -426,7 +437,7 @@ pmc_usb_mux_set(struct typec_mux *mux, s
 		return 0;
 
 	if (state->mode == TYPEC_STATE_SAFE)
-		return pmc_usb_mux_safe_state(port);
+		return pmc_usb_mux_safe_state(port, state);
 	if (state->mode == TYPEC_STATE_USB)
 		return pmc_usb_connect(port, port->role);
 



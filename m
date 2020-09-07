Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2585F25FC9E
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 17:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbgIGPGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 11:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730099AbgIGPFa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 11:05:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36067217A0;
        Mon,  7 Sep 2020 15:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599491107;
        bh=zyn6As012uCRhz34xf8H7NGuyWRXRly7RU07YhfUo0M=;
        h=Subject:To:From:Date:From;
        b=amFHI3yVsOKG8qbckmc9CSEN1VwewlvTGmalNtPed4MLU5eEaYcJRQPxsDC1Yp3Hr
         LP0rSeYA+L98TRErqeAQyBJ6cAGADLGTqYYrY3Q9ODchf9pk/Yp6LfVMSCxYssOkWQ
         u2uqvEUORdBm/OCwisR418yUS1h9yy9INd+CQoZ4=
Subject: patch "usb: typec: intel_pmc_mux: Do not configure SBU and HSL Orientation" added to usb-linus
To:     utkarsh.h.patel@intel.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Sep 2020 17:05:14 +0200
Message-ID: <1599491114251214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: intel_pmc_mux: Do not configure SBU and HSL Orientation

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7c6bbdf086ac7f1374bcf1ef0994b15109ecaf48 Mon Sep 17 00:00:00 2001
From: Utkarsh Patel <utkarsh.h.patel@intel.com>
Date: Mon, 7 Sep 2020 17:21:52 +0300
Subject: usb: typec: intel_pmc_mux: Do not configure SBU and HSL Orientation
 in Alternate modes

According to the PMC Type C Subsystem (TCSS) Mux programming guide rev
0.7, bits 4 and 5 are reserved in Alternate modes.
SBU Orientation and HSL Orientation needs to be configured only during
initial cable detection in USB connect flow based on device property of
"sbu-orientation" and "hsl-orientation".
Configuring these reserved bits in the Alternate modes may result in delay
in display link training or some unexpected behaviour.
So do not configure them while issuing Alternate Mode requests.

Fixes: ff4a30d5e243 ("usb: typec: mux: intel_pmc_mux: Support for static SBU/HSL orientation")
Signed-off-by: Utkarsh Patel <utkarsh.h.patel@intel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20200907142152.35678-3-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux/intel_pmc_mux.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index bb9cb4ec4d6f..ec7da0fa3cf8 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -61,8 +61,6 @@ enum {
 
 #define PMC_USB_ALTMODE_ORI_SHIFT	1
 #define PMC_USB_ALTMODE_UFP_SHIFT	3
-#define PMC_USB_ALTMODE_ORI_AUX_SHIFT	4
-#define PMC_USB_ALTMODE_ORI_HSL_SHIFT	5
 
 /* DP specific Mode Data bits */
 #define PMC_USB_ALTMODE_DP_MODE_SHIFT	8
@@ -178,9 +176,6 @@ pmc_usb_mux_dp(struct pmc_usb_port *port, struct typec_mux_state *state)
 	req.mode_data = (port->orientation - 1) << PMC_USB_ALTMODE_ORI_SHIFT;
 	req.mode_data |= (port->role - 1) << PMC_USB_ALTMODE_UFP_SHIFT;
 
-	req.mode_data |= sbu_orientation(port) << PMC_USB_ALTMODE_ORI_AUX_SHIFT;
-	req.mode_data |= hsl_orientation(port) << PMC_USB_ALTMODE_ORI_HSL_SHIFT;
-
 	req.mode_data |= (state->mode - TYPEC_STATE_MODAL) <<
 			 PMC_USB_ALTMODE_DP_MODE_SHIFT;
 
@@ -208,9 +203,6 @@ pmc_usb_mux_tbt(struct pmc_usb_port *port, struct typec_mux_state *state)
 	req.mode_data = (port->orientation - 1) << PMC_USB_ALTMODE_ORI_SHIFT;
 	req.mode_data |= (port->role - 1) << PMC_USB_ALTMODE_UFP_SHIFT;
 
-	req.mode_data |= sbu_orientation(port) << PMC_USB_ALTMODE_ORI_AUX_SHIFT;
-	req.mode_data |= hsl_orientation(port) << PMC_USB_ALTMODE_ORI_HSL_SHIFT;
-
 	if (TBT_ADAPTER(data->device_mode) == TBT_ADAPTER_TBT3)
 		req.mode_data |= PMC_USB_ALTMODE_TBT_TYPE;
 
-- 
2.28.0



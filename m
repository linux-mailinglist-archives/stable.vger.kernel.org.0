Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9607226B3BF
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgIOXJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbgIOOlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:41:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E97F22245;
        Tue, 15 Sep 2020 14:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180270;
        bh=ceAv6Kx1l2siqx92ScRwIOdgwcsL/dWwV5ZKNr2U3nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RK78ZzxVRzULIZYkWdu8zuuqIAQgF7UTQ7GdBYzGdF0R8oQ0LglNhcdCM6Z7d625I
         wL5I95UkkyUlXHTJOb8MpuHMA3v/z1ZDLycTHUObb7mIY+Y7gLZKwKLH/SiI4N4ZUi
         1peTGJcqgDJTqyDeE9dnHdfVM2JuiC6f0fGcG5Ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Utkarsh Patel <utkarsh.h.patel@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.8 175/177] usb: typec: intel_pmc_mux: Do not configure SBU and HSL Orientation in Alternate modes
Date:   Tue, 15 Sep 2020 16:14:06 +0200
Message-Id: <20200915140702.091967714@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Utkarsh Patel <utkarsh.h.patel@intel.com>

commit 7c6bbdf086ac7f1374bcf1ef0994b15109ecaf48 upstream.

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
 drivers/usb/typec/mux/intel_pmc_mux.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -56,8 +56,6 @@ enum {
 
 #define PMC_USB_ALTMODE_ORI_SHIFT	1
 #define PMC_USB_ALTMODE_UFP_SHIFT	3
-#define PMC_USB_ALTMODE_ORI_AUX_SHIFT	4
-#define PMC_USB_ALTMODE_ORI_HSL_SHIFT	5
 
 /* DP specific Mode Data bits */
 #define PMC_USB_ALTMODE_DP_MODE_SHIFT	8
@@ -173,9 +171,6 @@ pmc_usb_mux_dp(struct pmc_usb_port *port
 	req.mode_data = (port->orientation - 1) << PMC_USB_ALTMODE_ORI_SHIFT;
 	req.mode_data |= (port->role - 1) << PMC_USB_ALTMODE_UFP_SHIFT;
 
-	req.mode_data |= sbu_orientation(port) << PMC_USB_ALTMODE_ORI_AUX_SHIFT;
-	req.mode_data |= hsl_orientation(port) << PMC_USB_ALTMODE_ORI_HSL_SHIFT;
-
 	req.mode_data |= (state->mode - TYPEC_STATE_MODAL) <<
 			 PMC_USB_ALTMODE_DP_MODE_SHIFT;
 
@@ -203,9 +198,6 @@ pmc_usb_mux_tbt(struct pmc_usb_port *por
 	req.mode_data = (port->orientation - 1) << PMC_USB_ALTMODE_ORI_SHIFT;
 	req.mode_data |= (port->role - 1) << PMC_USB_ALTMODE_UFP_SHIFT;
 
-	req.mode_data |= sbu_orientation(port) << PMC_USB_ALTMODE_ORI_AUX_SHIFT;
-	req.mode_data |= hsl_orientation(port) << PMC_USB_ALTMODE_ORI_HSL_SHIFT;
-
 	if (TBT_ADAPTER(data->device_mode) == TBT_ADAPTER_TBT3)
 		req.mode_data |= PMC_USB_ALTMODE_TBT_TYPE;
 



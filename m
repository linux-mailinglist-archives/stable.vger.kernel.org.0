Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F792601D9
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 19:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbgIGQbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:31:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:34570 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729793AbgIGOWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 10:22:05 -0400
IronPort-SDR: vIOtwWF8K5+Ue+5c0HPElYbJwgWJZwX1sKlAXSbYct8WB3tWCsk9zT0/FKorBf21uhb/vLDHzi
 AyOqnY6m1AcA==
X-IronPort-AV: E=McAfee;i="6000,8403,9736"; a="158987045"
X-IronPort-AV: E=Sophos;i="5.76,402,1592895600"; 
   d="scan'208";a="158987045"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2020 07:21:57 -0700
IronPort-SDR: J/JYFS3oFVQrkWg9Q3rECnWSXHQBJlmIpzYiV9dHCa38Opyg7lRHU9NAZEZEgtmS2HGPQzz+GG
 d/bmYMnJTtXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,402,1592895600"; 
   d="scan'208";a="406850918"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 07 Sep 2020 07:21:55 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        Utkarsh Patel <utkarsh.h.patel@intel.com>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/2] usb: typec: intel_pmc_mux: Do not configure Altmode HPD High
Date:   Mon,  7 Sep 2020 17:21:51 +0300
Message-Id: <20200907142152.35678-2-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907142152.35678-1-heikki.krogerus@linux.intel.com>
References: <20200907142152.35678-1-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Utkarsh Patel <utkarsh.h.patel@intel.com>

According to the PMC Type C Subsystem (TCSS) Mux programming guide rev
0.7, bit 14 is reserved in Alternate mode.
In DP Alternate Mode state, if the HPD_STATE (bit 7) field in the
status update command VDO is set to HPD_HIGH, HPD is configured via
separate HPD mode request after configuring DP Alternate mode request.
Configuring reserved bit may show unexpected behaviour.
So do not configure them while issuing the Alternate Mode request.

Fixes: 7990be48ef4d ("usb: typec: mux: intel: Handle alt mode HPD_HIGH")
Cc: stable@vger.kernel.org
Signed-off-by: Utkarsh Patel <utkarsh.h.patel@intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/mux/intel_pmc_mux.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index e4021e13af40a..802d443b367c6 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -68,7 +68,6 @@ enum {
 #define PMC_USB_ALTMODE_DP_MODE_SHIFT	8
 
 /* TBT specific Mode Data bits */
-#define PMC_USB_ALTMODE_HPD_HIGH	BIT(14)
 #define PMC_USB_ALTMODE_TBT_TYPE	BIT(17)
 #define PMC_USB_ALTMODE_CABLE_TYPE	BIT(18)
 #define PMC_USB_ALTMODE_ACTIVE_LINK	BIT(20)
@@ -185,9 +184,6 @@ pmc_usb_mux_dp(struct pmc_usb_port *port, struct typec_mux_state *state)
 	req.mode_data |= (state->mode - TYPEC_STATE_MODAL) <<
 			 PMC_USB_ALTMODE_DP_MODE_SHIFT;
 
-	if (data->status & DP_STATUS_HPD_STATE)
-		req.mode_data |= PMC_USB_ALTMODE_HPD_HIGH;
-
 	ret = pmc_usb_command(port, (void *)&req, sizeof(req));
 	if (ret)
 		return ret;
-- 
2.28.0


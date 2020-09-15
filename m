Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3EF26B3BD
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgIOXJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727295AbgIOOlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:41:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B692D229CA;
        Tue, 15 Sep 2020 14:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180268;
        bh=tWB/lWdSiGSUNeo9fQ+gL9/CFry1lWbvuaJXLW1XKPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHHJ6MhewVI3dH7eE7TzYYF41wAr93GVzdlw07wCJfBGCByPNW8ewtofgvYL5i22a
         zWlBeoRTH1uCVN0mPtmif/uq6lNMR+6cKXbSrOyny7Nkzld6Vs80eWUAooQv8+UzSe
         4J32v0/MrQdS3zSEoKu9wGO95wRSO3oUUCo+K9HI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Utkarsh Patel <utkarsh.h.patel@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.8 174/177] usb: typec: intel_pmc_mux: Do not configure Altmode HPD High
Date:   Tue, 15 Sep 2020 16:14:05 +0200
Message-Id: <20200915140702.043664863@linuxfoundation.org>
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

commit 294955fd43dbf1e8f3a84cffa4797c6f22badc31 upstream.

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
Link: https://lore.kernel.org/r/20200907142152.35678-2-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/mux/intel_pmc_mux.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -63,7 +63,6 @@ enum {
 #define PMC_USB_ALTMODE_DP_MODE_SHIFT	8
 
 /* TBT specific Mode Data bits */
-#define PMC_USB_ALTMODE_HPD_HIGH	BIT(14)
 #define PMC_USB_ALTMODE_TBT_TYPE	BIT(17)
 #define PMC_USB_ALTMODE_CABLE_TYPE	BIT(18)
 #define PMC_USB_ALTMODE_ACTIVE_LINK	BIT(20)
@@ -180,9 +179,6 @@ pmc_usb_mux_dp(struct pmc_usb_port *port
 	req.mode_data |= (state->mode - TYPEC_STATE_MODAL) <<
 			 PMC_USB_ALTMODE_DP_MODE_SHIFT;
 
-	if (data->status & DP_STATUS_HPD_STATE)
-		req.mode_data |= PMC_USB_ALTMODE_HPD_HIGH;
-
 	ret = pmc_usb_command(port, (void *)&req, sizeof(req));
 	if (ret)
 		return ret;



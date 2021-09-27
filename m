Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197DA419BCF
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237069AbhI0RWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237072AbhI0RUb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:20:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC84D6120D;
        Mon, 27 Sep 2021 17:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762806;
        bh=W5315l78c0L8L2i4ahAUSSZ1pcFZYf51XWvprPU/VAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXl2kLkqKYb6anKhKF2p/okiXdwsntwb+y6l7mcxPdeDRTbQfHmg1ilH4kdf10Y69
         H+5ET6X8Xmx/BUvzPjXuEuVpFWSSzDf/br9VocAEe9Vamk0c1eoIjVPik1JYXP7Tot
         H2Tw1uj5SXkpkoZDf7DWfQcAGhyfUnEOD2OtoSLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Chris Chiu <chris.chiu@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 5.14 025/162] usb: core: hcd: Add support for deferring roothub registration
Date:   Mon, 27 Sep 2021 19:01:11 +0200
Message-Id: <20210927170234.332823354@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 58877b0824da15698bd85a0a9dbfa8c354e6ecb7 upstream.

It has been observed with certain PCIe USB cards (like Inateck connected
to AM64 EVM or J7200 EVM) that as soon as the primary roothub is
registered, port status change is handled even before xHC is running
leading to cold plug USB devices not detected. For such cases, registering
both the root hubs along with the second HCD is required. Add support for
deferring roothub registration in usb_add_hcd(), so that both primary and
secondary roothubs are registered along with the second HCD.

CC: stable@vger.kernel.org # 5.4+
Suggested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Tested-by: Chris Chiu <chris.chiu@canonical.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Link: https://lore.kernel.org/r/20210909064200.16216-2-kishon@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hcd.c  |   29 +++++++++++++++++++++++------
 include/linux/usb/hcd.h |    2 ++
 2 files changed, 25 insertions(+), 6 deletions(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2775,6 +2775,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 {
 	int retval;
 	struct usb_device *rhdev;
+	struct usb_hcd *shared_hcd;
 
 	if (!hcd->skip_phy_initialization && usb_hcd_is_primary_hcd(hcd)) {
 		hcd->phy_roothub = usb_phy_roothub_alloc(hcd->self.sysdev);
@@ -2935,13 +2936,26 @@ int usb_add_hcd(struct usb_hcd *hcd,
 		goto err_hcd_driver_start;
 	}
 
+	/* starting here, usbcore will pay attention to the shared HCD roothub */
+	shared_hcd = hcd->shared_hcd;
+	if (!usb_hcd_is_primary_hcd(hcd) && shared_hcd && HCD_DEFER_RH_REGISTER(shared_hcd)) {
+		retval = register_root_hub(shared_hcd);
+		if (retval != 0)
+			goto err_register_root_hub;
+
+		if (shared_hcd->uses_new_polling && HCD_POLL_RH(shared_hcd))
+			usb_hcd_poll_rh_status(shared_hcd);
+	}
+
 	/* starting here, usbcore will pay attention to this root hub */
-	retval = register_root_hub(hcd);
-	if (retval != 0)
-		goto err_register_root_hub;
+	if (!HCD_DEFER_RH_REGISTER(hcd)) {
+		retval = register_root_hub(hcd);
+		if (retval != 0)
+			goto err_register_root_hub;
 
-	if (hcd->uses_new_polling && HCD_POLL_RH(hcd))
-		usb_hcd_poll_rh_status(hcd);
+		if (hcd->uses_new_polling && HCD_POLL_RH(hcd))
+			usb_hcd_poll_rh_status(hcd);
+	}
 
 	return retval;
 
@@ -2985,6 +2999,7 @@ EXPORT_SYMBOL_GPL(usb_add_hcd);
 void usb_remove_hcd(struct usb_hcd *hcd)
 {
 	struct usb_device *rhdev = hcd->self.root_hub;
+	bool rh_registered;
 
 	dev_info(hcd->self.controller, "remove, state %x\n", hcd->state);
 
@@ -2995,6 +3010,7 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 
 	dev_dbg(hcd->self.controller, "roothub graceful disconnect\n");
 	spin_lock_irq (&hcd_root_hub_lock);
+	rh_registered = hcd->rh_registered;
 	hcd->rh_registered = 0;
 	spin_unlock_irq (&hcd_root_hub_lock);
 
@@ -3004,7 +3020,8 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 	cancel_work_sync(&hcd->died_work);
 
 	mutex_lock(&usb_bus_idr_lock);
-	usb_disconnect(&rhdev);		/* Sets rhdev to NULL */
+	if (rh_registered)
+		usb_disconnect(&rhdev);		/* Sets rhdev to NULL */
 	mutex_unlock(&usb_bus_idr_lock);
 
 	/*
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -124,6 +124,7 @@ struct usb_hcd {
 #define HCD_FLAG_RH_RUNNING		5	/* root hub is running? */
 #define HCD_FLAG_DEAD			6	/* controller has died? */
 #define HCD_FLAG_INTF_AUTHORIZED	7	/* authorize interfaces? */
+#define HCD_FLAG_DEFER_RH_REGISTER	8	/* Defer roothub registration */
 
 	/* The flags can be tested using these macros; they are likely to
 	 * be slightly faster than test_bit().
@@ -134,6 +135,7 @@ struct usb_hcd {
 #define HCD_WAKEUP_PENDING(hcd)	((hcd)->flags & (1U << HCD_FLAG_WAKEUP_PENDING))
 #define HCD_RH_RUNNING(hcd)	((hcd)->flags & (1U << HCD_FLAG_RH_RUNNING))
 #define HCD_DEAD(hcd)		((hcd)->flags & (1U << HCD_FLAG_DEAD))
+#define HCD_DEFER_RH_REGISTER(hcd) ((hcd)->flags & (1U << HCD_FLAG_DEFER_RH_REGISTER))
 
 	/*
 	 * Specifies if interfaces are authorized by default



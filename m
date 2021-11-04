Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EA3445508
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhKDOT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232088AbhKDOSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:18:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F11661268;
        Thu,  4 Nov 2021 14:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035359;
        bh=sBIAZMU6T3aieZdw+I32pvVeUOz1KvqMRKyoldkZoqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdvRAWcBUbjDtxUsqYPfK9r+WqaeV4ZrBDes5lKw/4auief6n2l0ACt7pto59/MIE
         zZh++Q2S/DAbWi/JLqD7rg63YKL1E26B0AWClaGORbn6IxXN53erG531i12e5vC9ol
         0LBD/K2ThVFuVKels8CqgzSP1ps2jXeMAdMbxrhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Chris Chiu <chris.chiu@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 5.4 6/9] Revert "usb: core: hcd: Add support for deferring roothub registration"
Date:   Thu,  4 Nov 2021 15:12:59 +0100
Message-Id: <20211104141158.591701989@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141158.384397574@linuxfoundation.org>
References: <20211104141158.384397574@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 20c9fdde30fbe797aec0e0a04fb77013fe473886 which is
commit 58877b0824da15698bd85a0a9dbfa8c354e6ecb7 upstream.

It has been reported to be causing problems in Arch and Fedora bug
reports.

Reported-by: Hans de Goede <hdegoede@redhat.com>
Link: https://bbs.archlinux.org/viewtopic.php?pid=2000956#p2000956
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2019542
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2019576
Link: https://lore.kernel.org/r/42bcbea6-5eb8-16c7-336a-2cb72e71bc36@redhat.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Chris Chiu <chris.chiu@canonical.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hcd.c  |   29 ++++++-----------------------
 include/linux/usb/hcd.h |    2 --
 2 files changed, 6 insertions(+), 25 deletions(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2636,7 +2636,6 @@ int usb_add_hcd(struct usb_hcd *hcd,
 {
 	int retval;
 	struct usb_device *rhdev;
-	struct usb_hcd *shared_hcd;
 
 	if (!hcd->skip_phy_initialization && usb_hcd_is_primary_hcd(hcd)) {
 		hcd->phy_roothub = usb_phy_roothub_alloc(hcd->self.sysdev);
@@ -2793,26 +2792,13 @@ int usb_add_hcd(struct usb_hcd *hcd,
 		goto err_hcd_driver_start;
 	}
 
-	/* starting here, usbcore will pay attention to the shared HCD roothub */
-	shared_hcd = hcd->shared_hcd;
-	if (!usb_hcd_is_primary_hcd(hcd) && shared_hcd && HCD_DEFER_RH_REGISTER(shared_hcd)) {
-		retval = register_root_hub(shared_hcd);
-		if (retval != 0)
-			goto err_register_root_hub;
-
-		if (shared_hcd->uses_new_polling && HCD_POLL_RH(shared_hcd))
-			usb_hcd_poll_rh_status(shared_hcd);
-	}
-
 	/* starting here, usbcore will pay attention to this root hub */
-	if (!HCD_DEFER_RH_REGISTER(hcd)) {
-		retval = register_root_hub(hcd);
-		if (retval != 0)
-			goto err_register_root_hub;
+	retval = register_root_hub(hcd);
+	if (retval != 0)
+		goto err_register_root_hub;
 
-		if (hcd->uses_new_polling && HCD_POLL_RH(hcd))
-			usb_hcd_poll_rh_status(hcd);
-	}
+	if (hcd->uses_new_polling && HCD_POLL_RH(hcd))
+		usb_hcd_poll_rh_status(hcd);
 
 	return retval;
 
@@ -2855,7 +2841,6 @@ EXPORT_SYMBOL_GPL(usb_add_hcd);
 void usb_remove_hcd(struct usb_hcd *hcd)
 {
 	struct usb_device *rhdev = hcd->self.root_hub;
-	bool rh_registered;
 
 	dev_info(hcd->self.controller, "remove, state %x\n", hcd->state);
 
@@ -2866,7 +2851,6 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 
 	dev_dbg(hcd->self.controller, "roothub graceful disconnect\n");
 	spin_lock_irq (&hcd_root_hub_lock);
-	rh_registered = hcd->rh_registered;
 	hcd->rh_registered = 0;
 	spin_unlock_irq (&hcd_root_hub_lock);
 
@@ -2876,8 +2860,7 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 	cancel_work_sync(&hcd->died_work);
 
 	mutex_lock(&usb_bus_idr_lock);
-	if (rh_registered)
-		usb_disconnect(&rhdev);		/* Sets rhdev to NULL */
+	usb_disconnect(&rhdev);		/* Sets rhdev to NULL */
 	mutex_unlock(&usb_bus_idr_lock);
 
 	/*
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -124,7 +124,6 @@ struct usb_hcd {
 #define HCD_FLAG_RH_RUNNING		5	/* root hub is running? */
 #define HCD_FLAG_DEAD			6	/* controller has died? */
 #define HCD_FLAG_INTF_AUTHORIZED	7	/* authorize interfaces? */
-#define HCD_FLAG_DEFER_RH_REGISTER	8	/* Defer roothub registration */
 
 	/* The flags can be tested using these macros; they are likely to
 	 * be slightly faster than test_bit().
@@ -135,7 +134,6 @@ struct usb_hcd {
 #define HCD_WAKEUP_PENDING(hcd)	((hcd)->flags & (1U << HCD_FLAG_WAKEUP_PENDING))
 #define HCD_RH_RUNNING(hcd)	((hcd)->flags & (1U << HCD_FLAG_RH_RUNNING))
 #define HCD_DEAD(hcd)		((hcd)->flags & (1U << HCD_FLAG_DEAD))
-#define HCD_DEFER_RH_REGISTER(hcd) ((hcd)->flags & (1U << HCD_FLAG_DEFER_RH_REGISTER))
 
 	/*
 	 * Specifies if interfaces are authorized by default



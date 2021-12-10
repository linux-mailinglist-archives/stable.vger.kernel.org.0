Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CD24702E1
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 15:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238732AbhLJOht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 09:37:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49584 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234805AbhLJOht (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 09:37:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51826B8281C
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 14:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCD3C00446;
        Fri, 10 Dec 2021 14:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639146852;
        bh=STf7s9K9sXQfr1y9OhhoRp0GVMC0NI/4wvYcxkgcBCs=;
        h=Subject:To:From:Date:From;
        b=oS0ZjAsWnEeT1jLJrq9KYQNDxqZ4VkHcEq6woVwa48Rqzl4uVvKLSnaItCt0S7z6U
         GWWivbDKAtVgwybOs9i8hmnK6+GpG2+kGyba20lBuwP7DA7naDGop/kSt+pk3S14gc
         ZuKG90EPL2g3FN9pdn3Uu2Y6pWZTZwBeSzQEGnuw=
Subject: patch "xhci: Remove CONFIG_USB_DEFAULT_PERSIST to prevent xHCI from runtime" added to usb-linus
To:     kai.heng.feng@canonical.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 15:34:09 +0100
Message-ID: <163914684910557@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Remove CONFIG_USB_DEFAULT_PERSIST to prevent xHCI from runtime

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 811ae81320da53a5670c36970cefacca8519f90e Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Fri, 10 Dec 2021 16:17:34 +0200
Subject: xhci: Remove CONFIG_USB_DEFAULT_PERSIST to prevent xHCI from runtime
 suspending

When the xHCI is quirked with XHCI_RESET_ON_RESUME, runtime resume
routine also resets the controller.

This is bad for USB drivers without reset_resume callback, because
there's no subsequent call of usb_dev_complete() ->
usb_resume_complete() to force rebinding the driver to the device. For
instance, btusb device stops working after xHCI controller is runtime
resumed, if the controlled is quirked with XHCI_RESET_ON_RESUME.

So always take XHCI_RESET_ON_RESUME into account to solve the issue.

Cc: <stable@vger.kernel.org>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20211210141735.1384209-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 902f410874e8..af92a9f8ed67 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3934,7 +3934,6 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	struct xhci_slot_ctx *slot_ctx;
 	int i, ret;
 
-#ifndef CONFIG_USB_DEFAULT_PERSIST
 	/*
 	 * We called pm_runtime_get_noresume when the device was attached.
 	 * Decrement the counter here to allow controller to runtime suspend
@@ -3942,7 +3941,6 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	 */
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		pm_runtime_put_noidle(hcd->self.controller);
-#endif
 
 	ret = xhci_check_args(hcd, udev, NULL, 0, true, __func__);
 	/* If the host is halted due to driver unload, we still need to free the
@@ -4094,14 +4092,12 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 
 	xhci_debugfs_create_slot(xhci, slot_id);
 
-#ifndef CONFIG_USB_DEFAULT_PERSIST
 	/*
 	 * If resetting upon resume, we can't put the controller into runtime
 	 * suspend if there is a device attached.
 	 */
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		pm_runtime_get_noresume(hcd->self.controller);
-#endif
 
 	/* Is this a LS or FS device under a HS hub? */
 	/* Hub or peripherial? */
-- 
2.34.1



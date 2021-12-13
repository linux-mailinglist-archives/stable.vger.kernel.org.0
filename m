Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A40B472636
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbhLMJta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:49:30 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:37964 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235661AbhLMJpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:45:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 76E16CE0E29;
        Mon, 13 Dec 2021 09:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25047C341CA;
        Mon, 13 Dec 2021 09:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388698;
        bh=pkpCtSQtbDgi4JYZI0DZmK8zOg9zUCgZ4gvL/yZN4P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhM1ECPi8UMJKdhPqpeCxvTzcXHPV+uMhfqr6yeScVBn4NCJ14FXP/0M+8ZOKx6z+
         jQ9+UK7jN8hQ6Lr63q28Gjpu4yT+GNeKGJHPjmqHEpmdHm1IMsTMHTB5Mbx/ZmBzlC
         XO3CkE2pWPkkWNgMxOFlrMnO7h/OO4L1Yjg6tbHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 67/88] xhci: Remove CONFIG_USB_DEFAULT_PERSIST to prevent xHCI from runtime suspending
Date:   Mon, 13 Dec 2021 10:30:37 +0100
Message-Id: <20211213092935.568825330@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 811ae81320da53a5670c36970cefacca8519f90e upstream.

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
 drivers/usb/host/xhci.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3889,7 +3889,6 @@ static void xhci_free_dev(struct usb_hcd
 	struct xhci_slot_ctx *slot_ctx;
 	int i, ret;
 
-#ifndef CONFIG_USB_DEFAULT_PERSIST
 	/*
 	 * We called pm_runtime_get_noresume when the device was attached.
 	 * Decrement the counter here to allow controller to runtime suspend
@@ -3897,7 +3896,6 @@ static void xhci_free_dev(struct usb_hcd
 	 */
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		pm_runtime_put_noidle(hcd->self.controller);
-#endif
 
 	ret = xhci_check_args(hcd, udev, NULL, 0, true, __func__);
 	/* If the host is halted due to driver unload, we still need to free the
@@ -4049,14 +4047,12 @@ int xhci_alloc_dev(struct usb_hcd *hcd,
 
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



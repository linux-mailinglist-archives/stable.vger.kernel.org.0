Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5614155DB72
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbiF0IRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 04:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbiF0IRt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 04:17:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412DD626D
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 01:17:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0EC860EC7
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 08:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9F2C3411D;
        Mon, 27 Jun 2022 08:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656317867;
        bh=fY7kZKBmNsieCR49/EOVJFWB5C/LQH9DfnFMjOJSfpw=;
        h=Subject:To:Cc:From:Date:From;
        b=YPWIFsIOjq89wD+n09jHfWsdIFXZX/DnquQ3SD2yUlkIcy2SbrSmdZACsEwsRecYM
         w688XMA/CAOyNIPWDe3lmMwFRQKgrb0TIHGS9Vb1Eka59XcwBKGWMABhbiYHpVx6r0
         sJ1ybJhVt9m5KAZu0Wn95tQPybeJYjSTbYm367Qk=
Subject: FAILED: patch "[PATCH] xhci: turn off port power in shutdown" failed to apply to 4.14-stable tree
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jun 2022 10:17:36 +0200
Message-ID: <1656317856102166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 83810f84ecf11dfc5a9414a8b762c3501b328185 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Thu, 23 Jun 2022 14:19:43 +0300
Subject: [PATCH] xhci: turn off port power in shutdown

If ports are not turned off in shutdown then runtime suspended
self-powered USB devices may survive in U3 link state over S5.

During subsequent boot, if firmware sends an IPC command to program
the port in DISCONNECT state, it will time out, causing significant
delay in the boot time.

Turning off roothub port power is also recommended in xhci
specification 4.19.4 "Port Power" in the additional note.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220623111945.1557702-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index c54f2bc23d3f..0fdc014c9401 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -652,7 +652,7 @@ struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd)
  * It will release and re-aquire the lock while calling ACPI
  * method.
  */
-static void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
+void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
 				u16 index, bool on, unsigned long *flags)
 	__must_hold(&xhci->lock)
 {
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index cb99bed5f755..65858f607437 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -791,6 +791,8 @@ static void xhci_stop(struct usb_hcd *hcd)
 void xhci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	unsigned long flags;
+	int i;
 
 	if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
 		usb_disable_xhci_ports(to_pci_dev(hcd->self.sysdev));
@@ -806,12 +808,21 @@ void xhci_shutdown(struct usb_hcd *hcd)
 		del_timer_sync(&xhci->shared_hcd->rh_timer);
 	}
 
-	spin_lock_irq(&xhci->lock);
+	spin_lock_irqsave(&xhci->lock, flags);
 	xhci_halt(xhci);
+
+	/* Power off USB2 ports*/
+	for (i = 0; i < xhci->usb2_rhub.num_ports; i++)
+		xhci_set_port_power(xhci, xhci->main_hcd, i, false, &flags);
+
+	/* Power off USB3 ports*/
+	for (i = 0; i < xhci->usb3_rhub.num_ports; i++)
+		xhci_set_port_power(xhci, xhci->shared_hcd, i, false, &flags);
+
 	/* Workaround for spurious wakeups at shutdown with HSW */
 	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
 		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
-	spin_unlock_irq(&xhci->lock);
+	spin_unlock_irqrestore(&xhci->lock, flags);
 
 	xhci_cleanup_msix(xhci);
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 0bd76c94a4b1..28aaf031f9a8 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2196,6 +2196,8 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex,
 int xhci_hub_status_data(struct usb_hcd *hcd, char *buf);
 int xhci_find_raw_port_number(struct usb_hcd *hcd, int port1);
 struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd);
+void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd, u16 index,
+			 bool on, unsigned long *flags);
 
 void xhci_hc_died(struct xhci_hcd *xhci);
 


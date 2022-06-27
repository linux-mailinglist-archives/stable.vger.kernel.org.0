Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1014555CB16
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbiF0Ldt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbiF0Lch (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:32:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D276B85E;
        Mon, 27 Jun 2022 04:29:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD14BB81122;
        Mon, 27 Jun 2022 11:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4F2C3411D;
        Mon, 27 Jun 2022 11:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329373;
        bh=Oae29rXEpAbedTU0LwPxLpUcqf8CXhY8N15Xyi0ITX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v49qUZ0SeYdzD7aVn3igA8R04ANuJdYI7WQr9BatVcOs8vnE/hSHT2qEG1QEVXyH+
         b2VWJoxh8ONBC39ujn8ittiBsr7N5wBLeq5HAqCJKUMMqnWpiZhWr27NKI7afLpD5a
         ayatkQ/8sdmpC+DmIHMWEpbVGytOmv49g9tKXjS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 36/60] xhci: turn off port power in shutdown
Date:   Mon, 27 Jun 2022 13:21:47 +0200
Message-Id: <20220627111928.753066955@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
References: <20220627111927.641837068@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 83810f84ecf11dfc5a9414a8b762c3501b328185 upstream.

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
---
 drivers/usb/host/xhci-hub.c |    2 +-
 drivers/usb/host/xhci.c     |   15 +++++++++++++--
 drivers/usb/host/xhci.h     |    2 ++
 3 files changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -566,7 +566,7 @@ struct xhci_hub *xhci_get_rhub(struct us
  * It will release and re-aquire the lock while calling ACPI
  * method.
  */
-static void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
+void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
 				u16 index, bool on, unsigned long *flags)
 {
 	struct xhci_hub *rhub;
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -775,6 +775,8 @@ static void xhci_stop(struct usb_hcd *hc
 void xhci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	unsigned long flags;
+	int i;
 
 	if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
 		usb_disable_xhci_ports(to_pci_dev(hcd->self.sysdev));
@@ -790,12 +792,21 @@ void xhci_shutdown(struct usb_hcd *hcd)
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
 
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2155,6 +2155,8 @@ int xhci_hub_control(struct usb_hcd *hcd
 int xhci_hub_status_data(struct usb_hcd *hcd, char *buf);
 int xhci_find_raw_port_number(struct usb_hcd *hcd, int port1);
 struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd);
+void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd, u16 index,
+			 bool on, unsigned long *flags);
 
 void xhci_hc_died(struct xhci_hcd *xhci);
 



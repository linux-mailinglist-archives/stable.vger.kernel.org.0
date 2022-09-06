Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49A25AEBB2
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbiIFOAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240505AbiIFN5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:57:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B393482F92;
        Tue,  6 Sep 2022 06:42:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51DD46153B;
        Tue,  6 Sep 2022 13:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2CDC433D7;
        Tue,  6 Sep 2022 13:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471750;
        bh=o6915RVQ8EKm4UA8QDgCO5CxcNRn5oFQtam/+RKfjNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhqRXVaMKr+eEk7R9VdrI3Zpybd/LbuDeNffSITC5ZVC/fIzQZcHZtL9pa+12jpc4
         LeAzkWs/ZUmJlIe+4Fsdhv0DEDpGVBgfnw8aULT43BJFdmaUxz9P/vBHBWCxFIxfUu
         vp/4fIITvgjitz3gphqImx5XT/+wcLkUHD5oxd3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 025/155] Revert "xhci: turn off port power in shutdown"
Date:   Tue,  6 Sep 2022 15:29:33 +0200
Message-Id: <20220906132830.489162620@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 8531aa1659f7278d4f2ec7408cc000eaa8d85217 ]

This reverts commit 83810f84ecf11dfc5a9414a8b762c3501b328185.

Turning off port power in shutdown did cause issues such as a laptop not
proprly powering off, and some specific usb devies failing to enumerate the
subsequent boot after a warm reset.

So revert this.

Fixes: 83810f84ecf1 ("xhci: turn off port power in shutdown")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220825150840.132216-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-hub.c |  2 +-
 drivers/usb/host/xhci.c     | 15 ++-------------
 drivers/usb/host/xhci.h     |  2 --
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 0fdc014c94011..c54f2bc23d3f8 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -652,7 +652,7 @@ struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd)
  * It will release and re-aquire the lock while calling ACPI
  * method.
  */
-void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
+static void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
 				u16 index, bool on, unsigned long *flags)
 	__must_hold(&xhci->lock)
 {
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 65858f6074377..cb99bed5f755e 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -791,8 +791,6 @@ static void xhci_stop(struct usb_hcd *hcd)
 void xhci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
-	unsigned long flags;
-	int i;
 
 	if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
 		usb_disable_xhci_ports(to_pci_dev(hcd->self.sysdev));
@@ -808,21 +806,12 @@ void xhci_shutdown(struct usb_hcd *hcd)
 		del_timer_sync(&xhci->shared_hcd->rh_timer);
 	}
 
-	spin_lock_irqsave(&xhci->lock, flags);
+	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
-
-	/* Power off USB2 ports*/
-	for (i = 0; i < xhci->usb2_rhub.num_ports; i++)
-		xhci_set_port_power(xhci, xhci->main_hcd, i, false, &flags);
-
-	/* Power off USB3 ports*/
-	for (i = 0; i < xhci->usb3_rhub.num_ports; i++)
-		xhci_set_port_power(xhci, xhci->shared_hcd, i, false, &flags);
-
 	/* Workaround for spurious wakeups at shutdown with HSW */
 	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
 		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
-	spin_unlock_irqrestore(&xhci->lock, flags);
+	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 1960b47acfb28..da51ad90a7006 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2196,8 +2196,6 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex,
 int xhci_hub_status_data(struct usb_hcd *hcd, char *buf);
 int xhci_find_raw_port_number(struct usb_hcd *hcd, int port1);
 struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd);
-void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd, u16 index,
-			 bool on, unsigned long *flags);
 
 void xhci_hc_died(struct xhci_hcd *xhci);
 
-- 
2.35.1




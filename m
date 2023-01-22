Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E58676F09
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbjAVPRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjAVPRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:17:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B8E222E9
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:17:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E595B80B1B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FDEC433D2;
        Sun, 22 Jan 2023 15:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400619;
        bh=7MZ8iWf3b7HzK/lP6rKeQYX3hIGVXuMDllrtpPK40Fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/rNA8lfyaZZHj98mu7JPyV3gZwMW74KBPoGmRd3gyf/h8wUPaTrlEr0zKxxK393H
         qVXlahnqGNUVusGRM3RReF7gnMBiZa3VgO5KwKhgiIWDIKRC6Fp1Ydam63ntFpnLQZ
         KtJXGYAsiGsWw8SA8Nu7jB/16Yf4rggpiNucey7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 045/117] xhci: Add update_hub_device override for PCI xHCI hosts
Date:   Sun, 22 Jan 2023 16:03:55 +0100
Message-Id: <20230122150234.606572132@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 23a3b8d5a2365653fd9bc5a9454d1e7f4facbf85 upstream.

Allow PCI hosts to check and tune roothub and port settings
before the hub is up and running.

This override is needed to turn off U1 and U2 LPM for some ports
based on per port ACPI _DSM, _UPC, or possibly vendor specific mmio
values for Intel xHC hosts.

Usb core calls the host update_hub_device once it creates a hub.

Entering U1 or U2 link power save state on ports with this limitation
will cause link to fail, turning the usb device unusable in that setup.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230116142216.1141605-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    9 +++++++++
 drivers/usb/host/xhci.c     |    5 ++++-
 drivers/usb/host/xhci.h     |    4 ++++
 3 files changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -78,9 +78,12 @@ static const char hcd_name[] = "xhci_hcd
 static struct hc_driver __read_mostly xhci_pci_hc_driver;
 
 static int xhci_pci_setup(struct usb_hcd *hcd);
+static int xhci_pci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
+				      struct usb_tt *tt, gfp_t mem_flags);
 
 static const struct xhci_driver_overrides xhci_pci_overrides __initconst = {
 	.reset = xhci_pci_setup,
+	.update_hub_device = xhci_pci_update_hub_device,
 };
 
 /* called after powerup, by probe or system-pm "wakeup" */
@@ -387,6 +390,12 @@ static int xhci_pci_setup(struct usb_hcd
 	return xhci_pci_reinit(xhci, pdev);
 }
 
+static int xhci_pci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
+				      struct usb_tt *tt, gfp_t mem_flags)
+{
+	return xhci_update_hub_device(hcd, hdev, tt, mem_flags);
+}
+
 /*
  * We need to register our own PCI probe function (instead of the USB core's
  * function) in order to create a second roothub under xHCI.
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5123,7 +5123,7 @@ static int xhci_disable_usb3_lpm_timeout
 /* Once a hub descriptor is fetched for a device, we need to update the xHC's
  * internal data structures for the device.
  */
-static int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
+int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
 			struct usb_tt *tt, gfp_t mem_flags)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
@@ -5223,6 +5223,7 @@ static int xhci_update_hub_device(struct
 	xhci_free_command(xhci, config_cmd);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(xhci_update_hub_device);
 
 static int xhci_get_frame(struct usb_hcd *hcd)
 {
@@ -5500,6 +5501,8 @@ void xhci_init_driver(struct hc_driver *
 			drv->check_bandwidth = over->check_bandwidth;
 		if (over->reset_bandwidth)
 			drv->reset_bandwidth = over->reset_bandwidth;
+		if (over->update_hub_device)
+			drv->update_hub_device = over->update_hub_device;
 	}
 }
 EXPORT_SYMBOL_GPL(xhci_init_driver);
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1948,6 +1948,8 @@ struct xhci_driver_overrides {
 			     struct usb_host_endpoint *ep);
 	int (*check_bandwidth)(struct usb_hcd *, struct usb_device *);
 	void (*reset_bandwidth)(struct usb_hcd *, struct usb_device *);
+	int (*update_hub_device)(struct usb_hcd *hcd, struct usb_device *hdev,
+			    struct usb_tt *tt, gfp_t mem_flags);
 };
 
 #define	XHCI_CFC_DELAY		10
@@ -2104,6 +2106,8 @@ int xhci_drop_endpoint(struct usb_hcd *h
 		       struct usb_host_endpoint *ep);
 int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev);
 void xhci_reset_bandwidth(struct usb_hcd *hcd, struct usb_device *udev);
+int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
+			   struct usb_tt *tt, gfp_t mem_flags);
 int xhci_disable_slot(struct xhci_hcd *xhci, u32 slot_id);
 int xhci_ext_cap_init(struct xhci_hcd *xhci);
 



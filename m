Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57833676F8E
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbjAVPWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbjAVPWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:22:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584091BFA
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:22:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4C0360C44
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EC1C433D2;
        Sun, 22 Jan 2023 15:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400960;
        bh=7EeN2T6subb+8e4ufH5+Y4HYIb/ArwivhTnAs53RFQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcKz8FRhCuZ8ry9DdIuRvaAJAQb27/kFAG0iMAplrAc9jX7gcYLrfzQRU/NuJ/tcf
         aA8Vt7BS2451786S9EG6f5k3Ez8W4JWD51Y7g2fakyS+4X//z5cDIFk56766QTqB36
         nc1RsOPM9Cnf5uy0c+Kreop+gZK6jBTuotWVhRE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 056/193] xhci: Detect lpm incapable xHC USB3 roothub ports from ACPI tables
Date:   Sun, 22 Jan 2023 16:03:05 +0100
Message-Id: <20230122150248.896643889@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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

commit 74622f0a81d0c2bcfc39f9192b788124e8c7f0af upstream.

USB3 ports on xHC hosts may have retimers that cause too long
exit latency to work with native USB3 U1/U2 link power management states.

For now only use usb_acpi_port_lpm_incapable() to evaluate if port lpm
should be disabled while setting up the USB3 roothub.

Other ways to identify lpm incapable ports can be added here later if
ACPI _DSM does not exist.

Limit this to Intel hosts for now, this is to my knowledge only
an Intel issue.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230116142216.1141605-8-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -355,8 +355,38 @@ static void xhci_pme_acpi_rtd3_enable(st
 				NULL);
 	ACPI_FREE(obj);
 }
+
+static void xhci_find_lpm_incapable_ports(struct usb_hcd *hcd, struct usb_device *hdev)
+{
+	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
+	struct xhci_hub *rhub = &xhci->usb3_rhub;
+	int ret;
+	int i;
+
+	/* This is not the usb3 roothub we are looking for */
+	if (hcd != rhub->hcd)
+		return;
+
+	if (hdev->maxchild > rhub->num_ports) {
+		dev_err(&hdev->dev, "USB3 roothub port number mismatch\n");
+		return;
+	}
+
+	for (i = 0; i < hdev->maxchild; i++) {
+		ret = usb_acpi_port_lpm_incapable(hdev, i);
+
+		dev_dbg(&hdev->dev, "port-%d disable U1/U2 _DSM: %d\n", i + 1, ret);
+
+		if (ret >= 0) {
+			rhub->ports[i]->lpm_incapable = ret;
+			continue;
+		}
+	}
+}
+
 #else
 static void xhci_pme_acpi_rtd3_enable(struct pci_dev *dev) { }
+static void xhci_find_lpm_incapable_ports(struct usb_hcd *hcd, struct usb_device *hdev) { }
 #endif /* CONFIG_ACPI */
 
 /* called during probe() after chip reset completes */
@@ -392,6 +422,10 @@ static int xhci_pci_setup(struct usb_hcd
 static int xhci_pci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
 				      struct usb_tt *tt, gfp_t mem_flags)
 {
+	/* Check if acpi claims some USB3 roothub ports are lpm incapable */
+	if (!hdev->parent)
+		xhci_find_lpm_incapable_ports(hcd, hdev);
+
 	return xhci_update_hub_device(hcd, hdev, tt, mem_flags);
 }
 



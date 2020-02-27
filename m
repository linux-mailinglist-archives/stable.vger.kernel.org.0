Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3203E171DE3
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389013AbgB0ONt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:13:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389011AbgB0ONs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:13:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EB3024690;
        Thu, 27 Feb 2020 14:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812828;
        bh=ZY1iDZKCiMk23xFTVQl9UMqSJynqVb1zbUgUTPGQCV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=za3oqd0+jMDDzE1ZVHByfwoxhcx+VjPlfr+mlt2cj5oEbLDpGU8vOeqF27UtImwAw
         t3/oXItjeDSz1G2bU/uynlD+4BVAZ5iJwAyRe/gkwVPQfJQTuOfb6WXUUug1Flarnt
         xQ6brsd4g6rn9YLO4pLAcDrfNQn1sQ7PmAblnBkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.5 032/150] xhci: fix runtime pm enabling for quirky Intel hosts
Date:   Thu, 27 Feb 2020 14:36:09 +0100
Message-Id: <20200227132237.554940059@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 024d411e9c5d49eb96c825af52a3ce2682895676 upstream.

Intel hosts that need the XHCI_PME_STUCK_QUIRK flag should enable
runtime pm by calling xhci_pme_acpi_rtd3_enable() before
usb_hcd_pci_probe() calls pci_dev_run_wake().
Otherwise usage count for the device won't be decreased, and runtime
suspend is prevented.

usb_hcd_pci_probe() only decreases the usage count if device can
generate run-time wake-up events, i.e. when pci_dev_run_wake()
returns true.

This issue was exposed by pci_dev_run_wake() change in
commit 8feaec33b986 ("PCI / PM: Always check PME wakeup capability for
runtime wakeup support")
and should be backported to kernels with that change

Cc: <stable@vger.kernel.org> # 4.13+
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200210134553.9144-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -302,6 +302,9 @@ static int xhci_pci_setup(struct usb_hcd
 	if (!usb_hcd_is_primary_hcd(hcd))
 		return 0;
 
+	if (xhci->quirks & XHCI_PME_STUCK_QUIRK)
+		xhci_pme_acpi_rtd3_enable(pdev);
+
 	xhci_dbg(xhci, "Got SBRN %u\n", (unsigned int) xhci->sbrn);
 
 	/* Find any debug ports */
@@ -359,9 +362,6 @@ static int xhci_pci_probe(struct pci_dev
 			HCC_MAX_PSA(xhci->hcc_params) >= 4)
 		xhci->shared_hcd->can_do_streams = 1;
 
-	if (xhci->quirks & XHCI_PME_STUCK_QUIRK)
-		xhci_pme_acpi_rtd3_enable(dev);
-
 	/* USB-2 and USB-3 roothubs initialized, allow runtime pm suspend */
 	pm_runtime_put_noidle(&dev->dev);
 



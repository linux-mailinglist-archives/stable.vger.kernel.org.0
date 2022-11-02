Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88886158F3
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiKBDCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiKBDCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:02:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D124C23161
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:01:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C032461729
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67021C433D6;
        Wed,  2 Nov 2022 03:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358113;
        bh=1YWHfgarlPkp8jukkXyXIylvIWR4USjW1WdBfSxegp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUdS0FBfcBgj3iJKXKaLMTm9Ua3kKqZzDqYeHfaOnMElp+VAbVSEGFzEoghVF41LT
         BajfIhf1AoAeNixZccufN7QEj7wJTva975hgvfk50ckrD+eUXrf5wLFS4W1Z+mPB31
         gUijCmUcyAvaG6ARWgKj6YecmPTwiBajUkekQFHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 017/132] xhci: Add quirk to reset host back to default state at shutdown
Date:   Wed,  2 Nov 2022 03:32:03 +0100
Message-Id: <20221102022100.077831416@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 34cd2db408d591bc15771cbcc90939ade0a99a21 upstream.

Systems based on Alder Lake P see significant boot time delay if
boot firmware tries to control usb ports in unexpected link states.

This is seen with self-powered usb devices that survive in U3 link
suspended state over S5.

A more generic solution to power off ports at shutdown was attempted in
commit 83810f84ecf1 ("xhci: turn off port power in shutdown")
but it caused regression.

Add host specific XHCI_RESET_TO_DEFAULT quirk which will reset host and
ports back to default state in shutdown.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20221024142720.4122053-3-mathias.nyman@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    4 ++++
 drivers/usb/host/xhci.c     |   10 ++++++++--
 drivers/usb/host/xhci.h     |    1 +
 3 files changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -259,6 +259,10 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_MISSING_CAS;
 
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
+	    pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI)
+		xhci->quirks |= XHCI_RESET_TO_DEFAULT;
+
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
 	    (pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_2C_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_4C_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_LP_XHCI ||
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -795,9 +795,15 @@ void xhci_shutdown(struct usb_hcd *hcd)
 
 	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
-	/* Workaround for spurious wakeups at shutdown with HSW */
-	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
+
+	/*
+	 * Workaround for spurious wakeps at shutdown with HSW, and for boot
+	 * firmware delay in ADL-P PCH if port are left in U3 at shutdown
+	 */
+	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP ||
+	    xhci->quirks & XHCI_RESET_TO_DEFAULT)
 		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
+
 	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1904,6 +1904,7 @@ struct xhci_hcd {
 #define XHCI_BROKEN_D3COLD	BIT_ULL(41)
 #define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
 #define XHCI_SUSPEND_RESUME_CLKS	BIT_ULL(43)
+#define XHCI_RESET_TO_DEFAULT	BIT_ULL(44)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;



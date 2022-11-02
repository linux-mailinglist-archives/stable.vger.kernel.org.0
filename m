Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC236157C0
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiKBCiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiKBCiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:38:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F3E10548
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:38:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7CAC616DB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45611C433D7;
        Wed,  2 Nov 2022 02:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356689;
        bh=y2zyCK7MJ/+5/KB07d1OzG3gYccrU9aHWgo+LW1elc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p1C4+05NQFgbMeGhwMbTEgWfqZ8bPjdRJBzQfeCErvSnSol9yexV7qaMm702SeU18
         9RYQrkkKxVAtA2CJrRT0/PWnA6y6hr3FpIIrAgrQTmP0rEX71VHMLxBtgX/L9DciMg
         Q7WJMpU08a4HArTRr3ANp4h5o9dCnQK0ySGmtPek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.0 043/240] xhci-pci: Set runtime PM as default policy on all xHC 1.2 or later devices
Date:   Wed,  2 Nov 2022 03:30:18 +0100
Message-Id: <20221102022112.375998247@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit a611bf473d1f77b70f7188b5577542cb39b4701b upstream.

For optimal power consumption of USB4 routers the XHCI PCIe endpoint
used for tunneling must be in D3.  Historically this is accomplished
by a long list of PCIe IDs that correspond to these endpoints because
the xhci_hcd driver will not default to allowing runtime PM for all
devices.

As both AMD and Intel have released new products with new XHCI controllers
this list continues to grow. In reviewing the XHCI specification v1.2 on
page 607 there is already a requirement that the PCI power management
states D3hot and D3cold must be supported.

In the quirk list, use this to indicate that runtime PM should be allowed
on XHCI controllers. The following controllers are known to be xHC 1.2 and
dropped explicitly:
* AMD Yellow Carp
* Intel Alder Lake
* Intel Meteor Lake
* Intel Raptor Lake

[keep PCI ID for Alder Lake PCH for recently added quirk -Mathias]

Cc: stable@vger.kernel.org
Suggested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://www.intel.com/content/dam/www/public/us/en/documents/technical-specifications/extensible-host-controler-interface-usb-xhci.pdf
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20221024142720.4122053-4-mathias.nyman@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |   32 ++++----------------------------
 1 file changed, 4 insertions(+), 28 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -58,25 +58,13 @@
 #define PCI_DEVICE_ID_INTEL_CML_XHCI			0xa3af
 #define PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI		0x9a13
 #define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI		0x1138
-#define PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI		0x461e
-#define PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_XHCI		0x464e
-#define PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI	0x51ed
-#define PCI_DEVICE_ID_INTEL_RAPTOR_LAKE_XHCI		0xa71e
-#define PCI_DEVICE_ID_INTEL_METEOR_LAKE_XHCI		0x7ec0
+#define PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI		0x51ed
 
 #define PCI_DEVICE_ID_AMD_RENOIR_XHCI			0x1639
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_2			0x43bb
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_1			0x43bc
-#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_1		0x161a
-#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_2		0x161b
-#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_3		0x161d
-#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_4		0x161e
-#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_5		0x15d6
-#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6		0x15d7
-#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_7		0x161c
-#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_8		0x161f
 
 #define PCI_DEVICE_ID_ASMEDIA_1042_XHCI			0x1042
 #define PCI_DEVICE_ID_ASMEDIA_1042A_XHCI		0x1142
@@ -272,12 +260,7 @@ static void xhci_pci_quirks(struct devic
 	     pdev->device == PCI_DEVICE_ID_INTEL_TITAN_RIDGE_DD_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ICE_LAKE_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_RAPTOR_LAKE_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_METEOR_LAKE_XHCI))
+	     pdev->device == PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI))
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
@@ -346,15 +329,8 @@ static void xhci_pci_quirks(struct devic
 	     pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_4))
 		xhci->quirks |= XHCI_NO_SOFT_RETRY;
 
-	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
-	    (pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_1 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_2 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_3 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_4 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_5 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_7 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_8))
+	/* xHC spec requires PCI devices to support D3hot and D3cold */
+	if (xhci->hci_version >= 0x120)
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)



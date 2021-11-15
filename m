Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B2E452737
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244097AbhKPCUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:20:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:52660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238460AbhKORiS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:38:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20C3861C15;
        Mon, 15 Nov 2021 17:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997156;
        bh=xATrcSB3ks7Jk84LEgrIm8YL4TIZdirdskUhUDs/F0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szEQZltWHjyXU3JT/QcKMs1v75AQ5khI+4J7vQ+0jEVrk2QDAu+D/uu9aa6nAEhm7
         H1qsGmGwlrGKFYPnaUlBnvaMGJyS+ImU7kKcPtGuH3sLSqT6paM49GfNw0S09gku5b
         LDQsYNfGMWVa3DEU6I0JYLNhnPwYHCId8xtgsaQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Nehal Bakulchandra Shah <Nehal-Bakulchandra.shah@amd.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 002/575] usb: xhci: Enable runtime-pm by default on AMD Yellow Carp platform
Date:   Mon, 15 Nov 2021 17:55:27 +0100
Message-Id: <20211115165343.672278274@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nehal Bakulchandra Shah <Nehal-Bakulchandra.shah@amd.com>

commit 660a92a59b9e831a0407e41ff62875656d30006e upstream.

AMD's Yellow Carp platform supports runtime power management for
XHCI Controllers, so enable the same by default for all XHCI Controllers.

[ regrouped and aligned the PCI_DEVICE_ID definitions -Mathias]

Cc: stable <stable@vger.kernel.org>
Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Nehal Bakulchandra Shah <Nehal-Bakulchandra.shah@amd.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20211014121200.75433-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -64,6 +64,13 @@
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_2			0x43bb
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_1			0x43bc
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_1		0x161a
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_2		0x161b
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_3		0x161d
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_4		0x161e
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_5		0x15d6
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6		0x15d7
+
 #define PCI_DEVICE_ID_ASMEDIA_1042_XHCI			0x1042
 #define PCI_DEVICE_ID_ASMEDIA_1042A_XHCI		0x1142
 #define PCI_DEVICE_ID_ASMEDIA_1142_XHCI			0x1242
@@ -312,6 +319,15 @@ static void xhci_pci_quirks(struct devic
 	     pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_4))
 		xhci->quirks |= XHCI_NO_SOFT_RETRY;
 
+	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
+	    (pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_1 ||
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_2 ||
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_3 ||
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_4 ||
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_5 ||
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6))
+		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
+
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
 				"QUIRK: Resetting on resume");



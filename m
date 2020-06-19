Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B422014D9
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390829AbgFSPCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390824AbgFSPCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:02:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E04720776;
        Fri, 19 Jun 2020 15:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578941;
        bh=aeDfgNSdKYjQeKp8W8Kt7VzTAn+DN+6nYPZRvYxhDpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqk9PXXRCitQKpLw4TztSaS5Axu399+hAmadeSahER3hmhemNVUFvNYr5CUidLmcX
         P7gEt9Mptf7VQ+2eFeoVOc/yC/7gT4DDa2u6kge7zTK7x7AbwN36Hv4AalIZ/d2RAu
         vYfYRHcs0RJndwydf8Kx6MqgYpIS4LTkkrW/a6h8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Sahu <abhsahu@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 214/267] PCI: Add NVIDIA GPU multi-function power dependencies
Date:   Fri, 19 Jun 2020 16:33:19 +0200
Message-Id: <20200619141658.994953070@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhishek Sahu <abhsahu@nvidia.com>

[ Upstream commit 6d2e369f0d4c3e6125c886847c04106b03d2609e ]

The NVIDIA Turing GPU is a multi-function PCI device with the following
functions:

  - Function 0: VGA display controller
  - Function 1: Audio controller
  - Function 2: USB xHCI Host controller
  - Function 3: USB Type-C UCSI controller

Function 0 is tightly coupled with other functions in the hardware.  When
function 0 is in D3, it gates power for hardware blocks used by other
functions, which means those functions only work when function 0 is in D0.
If any of these functions (1/2/3) are in D0, then function 0 should also be
in D0.

Commit 07f4f97d7b4b ("vga_switcheroo: Use device link for HDA controller")
already creates a device link to show the dependency of function 1 on
function 0 of this GPU.  Create additional device links to express the
dependencies of functions 2 and 3 on function 0.  This means function 0
will be in D0 if any other function is in D0.

[bhelgaas: I think the PCI spec expectation is that functions can be
power-managed independently, so I don't think this device is technically
compliant.  For example, the PCIe r5.0 spec, sec 1.4, says "the PCI/PCIe
hardware/software model includes architectural constructs necessary to
discover, configure, and use a Function, without needing Function-specific
knowledge" and sec 5.1 says "D states are associated with a particular
Function" and "PM provides ... a mechanism to identify power management
capabilities of a given Function [and] the ability to transition a Function
into a certain power management state."]

Link: https://lore.kernel.org/lkml/20190606092225.17960-3-abhsahu@nvidia.com
Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index d6236bb26950..8ac2d5a4a224 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5094,6 +5094,32 @@ DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_AMD, PCI_ANY_ID,
 DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
 			      PCI_CLASS_MULTIMEDIA_HD_AUDIO, 8, quirk_gpu_hda);
 
+/*
+ * Create device link for NVIDIA GPU with integrated USB xHCI Host
+ * controller to VGA.
+ */
+static void quirk_gpu_usb(struct pci_dev *usb)
+{
+	pci_create_device_link(usb, 2, 0, PCI_BASE_CLASS_DISPLAY, 16);
+}
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
+			      PCI_CLASS_SERIAL_USB, 8, quirk_gpu_usb);
+
+/*
+ * Create device link for NVIDIA GPU with integrated Type-C UCSI controller
+ * to VGA. Currently there is no class code defined for UCSI device over PCI
+ * so using UNKNOWN class for now and it will be updated when UCSI
+ * over PCI gets a class code.
+ */
+#define PCI_CLASS_SERIAL_UNKNOWN	0x0c80
+static void quirk_gpu_usb_typec_ucsi(struct pci_dev *ucsi)
+{
+	pci_create_device_link(ucsi, 3, 0, PCI_BASE_CLASS_DISPLAY, 16);
+}
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
+			      PCI_CLASS_SERIAL_UNKNOWN, 8,
+			      quirk_gpu_usb_typec_ucsi);
+
 /*
  * Some IDT switches incorrectly flag an ACS Source Validation error on
  * completions for config read requests even though PCIe r4.0, sec
-- 
2.25.1




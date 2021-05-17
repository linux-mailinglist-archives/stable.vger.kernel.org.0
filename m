Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8540383720
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243592AbhEQPkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244848AbhEQPhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:37:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D3D661D03;
        Mon, 17 May 2021 14:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262433;
        bh=nLZfFLfIMSjb7iPWswJhagxZlOp3+CzraNRrZ9kLpAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uv0sLhWNknkdui1JS+TY7R+aKsYO0q6BssbgxMr0UTLnMNP0ygqjbrzK0dRgESUWK
         Tv+Ydn1ZQsf78uu/iHL1AXqkCTqlJKNXHXi0bGkrBCD57afesPJNugi4kUoDHDDrAR
         jUl868JzSMOxfE8JKhpV2Ut9sKt51+UhmxrG9XpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhijeet Rao <abhijeet.rao@intel.com>,
        "Nikunj A. Dadhania" <nikunj.dadhania@intel.com>,
        Azhar Shaikh <azhar.shaikh@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.11 290/329] xhci-pci: Allow host runtime PM as default for Intel Alder Lake xHCI
Date:   Mon, 17 May 2021 16:03:21 +0200
Message-Id: <20210517140311.915670647@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhijeet Rao <abhijeet.rao@intel.com>

commit b813511135e8b84fa741afdfbab4937919100bef upstream.

In the same way as Intel Tiger Lake TCSS (Type-C Subsystem) the Alder Lake
TCSS xHCI needs to be runtime suspended whenever possible to allow the
TCSS hardware block to enter D3cold and thus save energy.

Cc: stable@vger.kernel.org
Signed-off-by: Abhijeet Rao <abhijeet.rao@intel.com>
Signed-off-by: Nikunj A. Dadhania <nikunj.dadhania@intel.com>
Signed-off-by: Azhar Shaikh <azhar.shaikh@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210512080816.866037-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -57,6 +57,7 @@
 #define PCI_DEVICE_ID_INTEL_CML_XHCI			0xa3af
 #define PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI		0x9a13
 #define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI		0x1138
+#define PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI		0x461e
 
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
@@ -243,7 +244,8 @@ static void xhci_pci_quirks(struct devic
 	     pdev->device == PCI_DEVICE_ID_INTEL_TITAN_RIDGE_DD_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ICE_LAKE_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI))
+	     pdev->device == PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI))
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&



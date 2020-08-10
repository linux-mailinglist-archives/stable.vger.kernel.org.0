Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A238B240A90
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgHJPWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728257AbgHJPWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:22:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 138D620768;
        Mon, 10 Aug 2020 15:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072970;
        bh=oynhamu8QTED6bHNsmPdQVBcyJa4bxnJmhWfZywmPLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o56j4xc83O7tmFxhSsT3XYZ4dgeWxRJqFcDEphUqTWTVYruVyu9yiA6bMgtFeWkAW
         kb4Q5xQzdb7kcMQy7Zlu5n6k6QmElIS8g8senjgC/LgyDun/lrk82827+6xkKRzacx
         3UG+/RqcLanCPSGBmkV35GLhbvyFE5X6w+8YTLPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Forest Crossman <cyrozap@gmail.com>
Subject: [PATCH 5.7 04/79] usb: xhci: define IDs for various ASMedia host controllers
Date:   Mon, 10 Aug 2020 17:20:23 +0200
Message-Id: <20200810151812.346387469@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Forest Crossman <cyrozap@gmail.com>

commit 1841cb255da41e87bed9573915891d056f80e2e7 upstream.

Not all ASMedia host controllers have a device ID that matches its part
number. #define some of these IDs to make it clearer at a glance which
chips require what quirks.

Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Forest Crossman <cyrozap@gmail.com>
Link: https://lore.kernel.org/r/20200728042408.180529-2-cyrozap@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -56,7 +56,9 @@
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_2			0x43bb
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_1			0x43bc
+#define PCI_DEVICE_ID_ASMEDIA_1042_XHCI			0x1042
 #define PCI_DEVICE_ID_ASMEDIA_1042A_XHCI		0x1142
+#define PCI_DEVICE_ID_ASMEDIA_2142_XHCI			0x2142
 
 static const char hcd_name[] = "xhci_hcd";
 
@@ -250,13 +252,13 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_LPM_SUPPORT;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
-			pdev->device == 0x1042)
+		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI)
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
-			pdev->device == 0x1142)
+		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI)
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
-			pdev->device == 0x2142)
+		pdev->device == PCI_DEVICE_ID_ASMEDIA_2142_XHCI)
 		xhci->quirks |= XHCI_NO_64BIT_SUPPORT;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&



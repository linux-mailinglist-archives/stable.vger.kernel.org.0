Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A7D47AE5D
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238936AbhLTPA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239172AbhLTO63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F37C06139C;
        Mon, 20 Dec 2021 06:49:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44F8E611A1;
        Mon, 20 Dec 2021 14:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24983C36AE7;
        Mon, 20 Dec 2021 14:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011783;
        bh=9MU9XmI+zkuSvokJNq5m6vJ5nEvExHSNHuJDKq/MZsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAeSGIQGNz4xMFIc4FAgNEn6UimYKTixN+W9FDhVPsF2qn6z0RXaQCDnjuCzknJ0s
         TpADALji2wwqQ9xnS3qaSYuzODjRJucWvszSaDZ6UyJfwCmZmLhXHayyyFmxdtzr+w
         mC0s/veSm1dXE8IZl8UBEuCC0vUkhG6OT+XoqzdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nehal Bakulchandra Shah <Nehal-Bakulchandra.shah@amd.com>
Subject: [PATCH 5.10 72/99] usb: xhci: Extend support for runtime power management for AMDs Yellow carp.
Date:   Mon, 20 Dec 2021 15:34:45 +0100
Message-Id: <20211220143031.809422590@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nehal Bakulchandra Shah <Nehal-Bakulchandra.shah@amd.com>

commit f886d4fbb7c97b8f5f447c92d2dab99c841803c0 upstream.

AMD's Yellow Carp platform has few more XHCI controllers,
enable the runtime power management support for the same.

Signed-off-by: Nehal Bakulchandra Shah <Nehal-Bakulchandra.shah@amd.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211215093216.1839065-1-Nehal-Bakulchandra.shah@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -70,6 +70,8 @@
 #define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_4		0x161e
 #define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_5		0x15d6
 #define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6		0x15d7
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_7		0x161c
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_8		0x161f
 
 #define PCI_DEVICE_ID_ASMEDIA_1042_XHCI			0x1042
 #define PCI_DEVICE_ID_ASMEDIA_1042A_XHCI		0x1142
@@ -325,7 +327,9 @@ static void xhci_pci_quirks(struct devic
 	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_3 ||
 	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_4 ||
 	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_5 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6))
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6 ||
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_7 ||
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_8))
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D199B47ACD9
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbhLTOrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:47:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51854 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbhLTOpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:45:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43900B80EDF;
        Mon, 20 Dec 2021 14:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77207C36AE8;
        Mon, 20 Dec 2021 14:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011516;
        bh=P3EB1nX24/jzpEGQbDJ1NUn8WfPO8IXq5VSk39nVxbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0lOjv+VBu5GAxtm7MA6WHZmUfq2H81DedKja9YmOz5fU9zZ7jGD0bfcqfB+3HWEE
         gkh71SDRrq8+qa/ctfbmF04rRuc5N6SUcp5ODBnLd0veitNZu3ecJyfRmVKwZ7MHHS
         Holr/1nMM7AO9y6z2pWfxqRCnbgqGit6AYma700U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nehal Bakulchandra Shah <Nehal-Bakulchandra.shah@amd.com>
Subject: [PATCH 5.4 48/71] usb: xhci: Extend support for runtime power management for AMDs Yellow carp.
Date:   Mon, 20 Dec 2021 15:34:37 +0100
Message-Id: <20211220143027.301361200@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
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
@@ -65,6 +65,8 @@
 #define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_4		0x161e
 #define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_5		0x15d6
 #define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6		0x15d7
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_7		0x161c
+#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_8		0x161f
 
 #define PCI_DEVICE_ID_ASMEDIA_1042_XHCI			0x1042
 #define PCI_DEVICE_ID_ASMEDIA_1042A_XHCI		0x1142
@@ -303,7 +305,9 @@ static void xhci_pci_quirks(struct devic
 	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_3 ||
 	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_4 ||
 	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_5 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6))
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6 ||
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_7 ||
+	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_8))
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09FD11910A9
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgCXNXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:23:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729219AbgCXNXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:23:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADFE720775;
        Tue, 24 Mar 2020 13:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056182;
        bh=dsUFn1fct6hE7+Yo16X7dys63JfXbXmd3O1DfgNk3DY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQ/jjd3jacqhvMWpAGnPqdqSuRSASGl643PD2uwfrT1WeheBdmkBWS0Jk0mASsFRl
         +Ajg6Zudo6ohh9AIMcZ6c0zWbP/eMyxE+oCmxsGwKwvDdNaZ/6SwmvtLMigUJPPv0A
         ZazI30NtZy03JXRnLy/eAx7eILqtzSgFPicFzPm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alberto Mattea <alberto@mattea.info>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.5 048/119] usb: xhci: apply XHCI_SUSPEND_DELAY to AMD XHCI controller 1022:145c
Date:   Tue, 24 Mar 2020 14:10:33 +0100
Message-Id: <20200324130813.107317568@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alberto Mattea <alberto@mattea.info>

commit 16263abc12d09871156a1c8650fb651f0e552f5e upstream.

This controller timeouts during suspend (S3) with
[  240.521724] xhci_hcd 0000:30:00.3: WARN: xHC save state timeout
[  240.521729] xhci_hcd 0000:30:00.3: ERROR mismatched command completion event
thus preventing the system from entering S3.
Moreover it remains in an undefined state where some connected devices stop
working until a reboot.
Apply the XHCI_SUSPEND_DELAY quirk to make it suspend properly.

CC: stable@vger.kernel.org
Signed-off-by: Alberto Mattea <alberto@mattea.info>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200306150858.21904-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -136,7 +136,8 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_AMD_PLL_FIX;
 
 	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
-		(pdev->device == 0x15e0 ||
+		(pdev->device == 0x145c ||
+		 pdev->device == 0x15e0 ||
 		 pdev->device == 0x15e1 ||
 		 pdev->device == 0x43bb))
 		xhci->quirks |= XHCI_SUSPEND_DELAY;



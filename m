Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE0419B214
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389074AbgDAQkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389197AbgDAQkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:40:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3E672063A;
        Wed,  1 Apr 2020 16:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759247;
        bh=m6uTusX3QKM1rf4TxbnopD7lVV6EztOv2sZpf0uTwsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkJUQoc15MrI7IMXEKsW+s4rjUApJBX+PXkgbhq3oFs0khxN7/8DCn2DGlvJhKiR+
         IkPHNt4GYMDr6TUvqXk6kpD9psXiBWFOxZ/cx6WnOeWnryuEelIMrYnBMSqu33Xizg
         5g3FZjbnvCUxgWB1IXrJgJoRoapaWatXRtUEEYvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alberto Mattea <alberto@mattea.info>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.14 020/148] usb: xhci: apply XHCI_SUSPEND_DELAY to AMD XHCI controller 1022:145c
Date:   Wed,  1 Apr 2020 18:16:52 +0200
Message-Id: <20200401161554.357387148@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
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
@@ -140,7 +140,8 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_AMD_PLL_FIX;
 
 	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
-		(pdev->device == 0x15e0 ||
+		(pdev->device == 0x145c ||
+		 pdev->device == 0x15e0 ||
 		 pdev->device == 0x15e1 ||
 		 pdev->device == 0x43bb))
 		xhci->quirks |= XHCI_SUSPEND_DELAY;



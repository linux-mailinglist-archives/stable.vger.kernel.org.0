Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CB633BA2C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbhCOOIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233567AbhCOOCF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFDE064F0B;
        Mon, 15 Mar 2021 14:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816922;
        bh=GmxJ3oFJGKuwbkAxXweIFedbjp1KTNuSELERd50QxTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+X+SrUED5n6vETxOpjtZDaaT9N5cPYfrGW6nORMQNkyCMGA5YJXxotIrodV/sNQ2
         vy7XBYdCIuX3GDzinixUxDgLG+8cu/tvEVnuEKoFrEFZKTyWPVtSkIAkunQzcWi2Vr
         0GyzAnR4ekLE9F89v/0OyBY1hyVa/VcCZsgz7ClQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernhard <bernhard.gebetsberger@gmx.at>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.11 204/306] usb: xhci: do not perform Soft Retry for some xHCI hosts
Date:   Mon, 15 Mar 2021 14:54:27 +0100
Message-Id: <20210315135514.529350771@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

commit a4a251f8c23518899d2078c320cf9ce2fa459c9f upstream.

On some systems rt2800usb and mt7601u devices are unable to operate since
commit f8f80be501aa ("xhci: Use soft retry to recover faster from
transaction errors")

Seems that some xHCI controllers can not perform Soft Retry correctly,
affecting those devices.

To avoid the problem add xhci->quirks flag that restore pre soft retry
xhci behaviour for affected xHCI controllers. Currently those are
AMD_PROMONTORYA_4 and AMD_PROMONTORYA_2, since it was confirmed
by the users: on those xHCI hosts issue happen and is gone after
disabling Soft Retry.

[minor commit message rewording for checkpatch -Mathias]

Fixes: f8f80be501aa ("xhci: Use soft retry to recover faster from transaction errors")
Cc: <stable@vger.kernel.org> # 4.20+
Reported-by: Bernhard <bernhard.gebetsberger@gmx.at>
Tested-by: Bernhard <bernhard.gebetsberger@gmx.at>
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202541
Link: https://lore.kernel.org/r/20210311115353.2137560-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c  |    5 +++++
 drivers/usb/host/xhci-ring.c |    3 ++-
 drivers/usb/host/xhci.h      |    1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -295,6 +295,11 @@ static void xhci_pci_quirks(struct devic
 	     pdev->device == 0x9026)
 		xhci->quirks |= XHCI_RESET_PLL_ON_DISCONNECT;
 
+	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
+	    (pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_2 ||
+	     pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_4))
+		xhci->quirks |= XHCI_NO_SOFT_RETRY;
+
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
 				"QUIRK: Resetting on resume");
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2307,7 +2307,8 @@ static int process_bulk_intr_td(struct x
 		remaining	= 0;
 		break;
 	case COMP_USB_TRANSACTION_ERROR:
-		if ((ep_ring->err_count++ > MAX_SOFT_RETRY) ||
+		if (xhci->quirks & XHCI_NO_SOFT_RETRY ||
+		    (ep_ring->err_count++ > MAX_SOFT_RETRY) ||
 		    le32_to_cpu(slot_ctx->tt_info) & TT_SLOT)
 			break;
 		*status = 0;
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1883,6 +1883,7 @@ struct xhci_hcd {
 #define XHCI_SKIP_PHY_INIT	BIT_ULL(37)
 #define XHCI_DISABLE_SPARSE	BIT_ULL(38)
 #define XHCI_SG_TRB_CACHE_SIZE_QUIRK	BIT_ULL(39)
+#define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;



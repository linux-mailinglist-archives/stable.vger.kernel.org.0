Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A923371EF
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 13:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhCKMDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 07:03:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232881AbhCKMDo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 07:03:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4E4164DCC;
        Thu, 11 Mar 2021 12:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615464223;
        bh=kJ6bp7WUucVH9ltkS3sP3CHLh0ehB/KSRdNVfIdf1sc=;
        h=Subject:To:From:Date:From;
        b=n0fIPNPzAly7BLlshgs4UYeJHKY0gFtKRCjOARqcvshmR2xKNRqRRhkeMULbfhGob
         fJGvsdkFd62wXdiwSbAH1NQKKoZXgKL1jHeVPjfkmczo5KUm+NFCcR/v3KuZXzTJR3
         fL0U8wh6ls+p3g1FFNUTfg39C1iTH23JNJWsf0cU=
Subject: patch "usb: xhci: do not perform Soft Retry for some xHCI hosts" added to usb-linus
To:     stf_xl@wp.pl, bernhard.gebetsberger@gmx.at,
        gregkh@linuxfoundation.org, mathias.nyman@linux.intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 13:03:39 +0100
Message-ID: <161546421942168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci: do not perform Soft Retry for some xHCI hosts

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a4a251f8c23518899d2078c320cf9ce2fa459c9f Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <stf_xl@wp.pl>
Date: Thu, 11 Mar 2021 13:53:50 +0200
Subject: usb: xhci: do not perform Soft Retry for some xHCI hosts

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
 drivers/usb/host/xhci-pci.c  | 5 +++++
 drivers/usb/host/xhci-ring.c | 3 ++-
 drivers/usb/host/xhci.h      | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 84da8406d5b4..1f989a49c8c6 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -295,6 +295,11 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
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
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 5e548a1c93ab..ce38076901e2 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2484,7 +2484,8 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		remaining	= 0;
 		break;
 	case COMP_USB_TRANSACTION_ERROR:
-		if ((ep_ring->err_count++ > MAX_SOFT_RETRY) ||
+		if (xhci->quirks & XHCI_NO_SOFT_RETRY ||
+		    (ep_ring->err_count++ > MAX_SOFT_RETRY) ||
 		    le32_to_cpu(slot_ctx->tt_info) & TT_SLOT)
 			break;
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index d41de5dc0452..ca822ad3b65b 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1891,6 +1891,7 @@ struct xhci_hcd {
 #define XHCI_SKIP_PHY_INIT	BIT_ULL(37)
 #define XHCI_DISABLE_SPARSE	BIT_ULL(38)
 #define XHCI_SG_TRB_CACHE_SIZE_QUIRK	BIT_ULL(39)
+#define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
-- 
2.30.2



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0448D26FDFB
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 15:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgIRNOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 09:14:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:46076 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbgIRNOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 09:14:40 -0400
IronPort-SDR: TSwUB3PVQUtS4IDd5CEgxBP+HPCElrWgvQ7hdeJ+957n4UbzxDRa1PGomEZ7YIC6pkAwvW2b3d
 pRuNpCHLXw+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="160849976"
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="160849976"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 06:14:40 -0700
IronPort-SDR: TKFYOvKGsPPJLJGAFSLHJ5T/6lY51BWrV/6YwTXp7uUmO8fJN+L3BImCkJkC7GOz8cm3WxAab5
 nb0zSz4dLFVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="508871209"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga005.fm.intel.com with ESMTP; 18 Sep 2020 06:14:38 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 09/10] xhci: don't create endpoint debugfs entry before ring buffer is set.
Date:   Fri, 18 Sep 2020 16:17:51 +0300
Message-Id: <20200918131752.16488-10-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200918131752.16488-1-mathias.nyman@linux.intel.com>
References: <20200918131752.16488-1-mathias.nyman@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure xHC completes the configure endpoint command and xhci driver
sets the ring pointers correctly before we create the user readable
debugfs file.

In theory there was a small gap where a user could have read the
debugfs file and cause a NULL pointer dereference error as ring
pointer was not yet set, in practise we want this change to simplify
the upcoming streams debugfs support.

Fixes: 02b6fdc2a153 ("usb: xhci: Add debugfs interface for xHCI driver")
Cc: stable@vger.kernel.org #v4.19+
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 4cfb95104c26..e88f4f953995 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1918,8 +1918,6 @@ static int xhci_add_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
 	ep_ctx = xhci_get_ep_ctx(xhci, virt_dev->in_ctx, ep_index);
 	trace_xhci_add_endpoint(ep_ctx);
 
-	xhci_debugfs_create_endpoint(xhci, virt_dev, ep_index);
-
 	xhci_dbg(xhci, "add ep 0x%x, slot id %d, new drop flags = %#x, new add flags = %#x\n",
 			(unsigned int) ep->desc.bEndpointAddress,
 			udev->slot_id,
@@ -2952,6 +2950,7 @@ static int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 		xhci_check_bw_drop_ep_streams(xhci, virt_dev, i);
 		virt_dev->eps[i].ring = virt_dev->eps[i].new_ring;
 		virt_dev->eps[i].new_ring = NULL;
+		xhci_debugfs_create_endpoint(xhci, virt_dev, i);
 	}
 command_cleanup:
 	kfree(command->completion);
-- 
2.17.1


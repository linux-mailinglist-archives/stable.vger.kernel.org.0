Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C1824D130
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 11:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgHUJMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 05:12:47 -0400
Received: from mga12.intel.com ([192.55.52.136]:18835 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgHUJMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 05:12:47 -0400
IronPort-SDR: u4d8Fd2yVH1CX3OiGtLr+7/JW5Hav2nLgQe2trSXmaPqItcr5Gdq+OAhW6VnSl/9lpneTsW8Jl
 C9YHSII7LjtQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="135030350"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="135030350"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 02:12:46 -0700
IronPort-SDR: 5edi+br547/00TzYXlNZS3wWA82DdxUEtmUQS17uugRd7FXzR1hgm0ceGVAdkkYaRJr3tWtTjB
 kUeH2zXVg49A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="321194905"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga004.fm.intel.com with ESMTP; 21 Aug 2020 02:12:46 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Ding Hui <dinghui@sangfor.com.cn>,
        stable <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3/3] xhci: Always restore EP_SOFT_CLEAR_TOGGLE even if ep reset failed
Date:   Fri, 21 Aug 2020 12:15:49 +0300
Message-Id: <20200821091549.20556-4-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200821091549.20556-1-mathias.nyman@linux.intel.com>
References: <20200821091549.20556-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Hui <dinghui@sangfor.com.cn>

Some device drivers call libusb_clear_halt when target ep queue
is not empty. (eg. spice client connected to qemu for usb redir)

Before commit f5249461b504 ("xhci: Clear the host side toggle
manually when endpoint is soft reset"), that works well.
But now, we got the error log:

    EP not empty, refuse reset

xhci_endpoint_reset failed and left ep_state's EP_SOFT_CLEAR_TOGGLE
bit still set

So all the subsequent urb sumbits to the ep will fail with the
warn log:

    Can't enqueue URB while manually clearing toggle

We need to clear ep_state EP_SOFT_CLEAR_TOGGLE bit after
xhci_endpoint_reset, even if it failed.

Fixes: f5249461b504 ("xhci: Clear the host side toggle manually when endpoint is soft reset"
Cc: stable <stable@vger.kernel.org> # v4.17+
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 3c41b14ecce7..e9884ae9c77d 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3236,10 +3236,11 @@ static void xhci_endpoint_reset(struct usb_hcd *hcd,
 
 	wait_for_completion(cfg_cmd->completion);
 
-	ep->ep_state &= ~EP_SOFT_CLEAR_TOGGLE;
 	xhci_free_command(xhci, cfg_cmd);
 cleanup:
 	xhci_free_command(xhci, stop_cmd);
+	if (ep->ep_state & EP_SOFT_CLEAR_TOGGLE)
+		ep->ep_state &= ~EP_SOFT_CLEAR_TOGGLE;
 }
 
 static int xhci_check_streams_endpoint(struct xhci_hcd *xhci,
-- 
2.17.1


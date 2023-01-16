Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45A266C27B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjAPOoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjAPOn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:43:28 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8B734541;
        Mon, 16 Jan 2023 06:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673878868; x=1705414868;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=niFq//Q1d/rwnmPhKKLOQtYi/x1+pUVmb//kWkulh3A=;
  b=LBBYhqXOZp4QzQactRcvTC3usQXy6a8xbtTGWcS/bpCDWzfBmZgU0k+T
   3NRWyBB/NHQOANJgxbZIUeYLObftZ6Y4bio3gVmLskWLizT+6x/wQIZT0
   7SdXPr9RElSBMxI1vuvkAfhqC9vfP3ifUUuGIp5znvjzAzx7j90TIIQ9Q
   I4c88VLhFIur6jIJy2By6Ycuc6NdGnG4WTx4r4DNLFtVNKkkUckZprSFc
   cDEc+QYx4dXwx8KuKUWv+8hxmOedJtd1FzSlfKN1BHFMJOMuzlrpGxKdZ
   7SIUpvhMmcz1kUajwCdGbnmeIlw8utwucettfyhJzR7aRTzW33roiNt96
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="312322940"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="312322940"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 06:21:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="987817189"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="987817189"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jan 2023 06:21:06 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/7] xhci: Fix null pointer dereference when host dies
Date:   Mon, 16 Jan 2023 16:22:12 +0200
Message-Id: <20230116142216.1141605-4-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230116142216.1141605-1-mathias.nyman@linux.intel.com>
References: <20230116142216.1141605-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure xhci_free_dev() and xhci_kill_endpoint_urbs() do not race
and cause null pointer dereference when host suddenly dies.

Usb core may call xhci_free_dev() which frees the xhci->devs[slot_id]
virt device at the same time that xhci_kill_endpoint_urbs() tries to
loop through all the device's endpoints, checking if there are any
cancelled urbs left to give back.

hold the xhci spinlock while freeing the virt device

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 79d7931c048a..50b41213e827 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3974,6 +3974,7 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 	struct xhci_virt_device *virt_dev;
 	struct xhci_slot_ctx *slot_ctx;
+	unsigned long flags;
 	int i, ret;
 
 	/*
@@ -4000,7 +4001,11 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 		virt_dev->eps[i].ep_state &= ~EP_STOP_CMD_PENDING;
 	virt_dev->udev = NULL;
 	xhci_disable_slot(xhci, udev->slot_id);
+
+	spin_lock_irqsave(&xhci->lock, flags);
 	xhci_free_virt_device(xhci, udev->slot_id);
+	spin_unlock_irqrestore(&xhci->lock, flags);
+
 }
 
 int xhci_disable_slot(struct xhci_hcd *xhci, u32 slot_id)
-- 
2.25.1


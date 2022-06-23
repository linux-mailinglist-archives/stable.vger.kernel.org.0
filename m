Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD2F55788D
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 13:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiFWLSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 07:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiFWLSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 07:18:23 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6104D1EC74;
        Thu, 23 Jun 2022 04:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655983102; x=1687519102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QAMii/IxVR0mF0RTD44R9kOzJdX5VEmTYYc9BpfKwwY=;
  b=bzoBxjvxY/FImwHuN56+Oywn4gb47EaMOysT4ZfRbsqnlJGwtfYL0Dj1
   9+K7ZT72umxLT2v9RxJCrnzDubHoV88nu4Y2WTSwzO3I8VgOYP9OcBk4F
   i3ZQOy4zZL8sw5E4yZUiiy7+fC6757h1HZmeLPCDx1iEOT7HS5oWU5XOO
   n2jAC+GdvM89u39OHnOJUbP55XRghgy5GknXS86dU5toI45LhuzxDkrEw
   M00hquWo33mRYa2k51wPL9/ysydGDdJChKT1FHmD5A6YyWqry71rnNNg+
   2NeLTtc88Ky8BV+dfoXxFC5WgIQXfq7kjKKhNgr9WnDARq8n8Q/xWk/a0
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="367010649"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="367010649"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 04:18:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="915148730"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by fmsmga005.fm.intel.com with ESMTP; 23 Jun 2022 04:18:20 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/4] xhci: turn off port power in shutdown
Date:   Thu, 23 Jun 2022 14:19:43 +0300
Message-Id: <20220623111945.1557702-3-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220623111945.1557702-1-mathias.nyman@linux.intel.com>
References: <20220623111945.1557702-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If ports are not turned off in shutdown then runtime suspended
self-powered USB devices may survive in U3 link state over S5.

During subsequent boot, if firmware sends an IPC command to program
the port in DISCONNECT state, it will time out, causing significant
delay in the boot time.

Turning off roothub port power is also recommended in xhci
specification 4.19.4 "Port Power" in the additional note.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c |  2 +-
 drivers/usb/host/xhci.c     | 15 +++++++++++++--
 drivers/usb/host/xhci.h     |  2 ++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index c54f2bc23d3f..0fdc014c9401 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -652,7 +652,7 @@ struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd)
  * It will release and re-aquire the lock while calling ACPI
  * method.
  */
-static void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
+void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
 				u16 index, bool on, unsigned long *flags)
 	__must_hold(&xhci->lock)
 {
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index cb99bed5f755..65858f607437 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -791,6 +791,8 @@ static void xhci_stop(struct usb_hcd *hcd)
 void xhci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	unsigned long flags;
+	int i;
 
 	if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
 		usb_disable_xhci_ports(to_pci_dev(hcd->self.sysdev));
@@ -806,12 +808,21 @@ void xhci_shutdown(struct usb_hcd *hcd)
 		del_timer_sync(&xhci->shared_hcd->rh_timer);
 	}
 
-	spin_lock_irq(&xhci->lock);
+	spin_lock_irqsave(&xhci->lock, flags);
 	xhci_halt(xhci);
+
+	/* Power off USB2 ports*/
+	for (i = 0; i < xhci->usb2_rhub.num_ports; i++)
+		xhci_set_port_power(xhci, xhci->main_hcd, i, false, &flags);
+
+	/* Power off USB3 ports*/
+	for (i = 0; i < xhci->usb3_rhub.num_ports; i++)
+		xhci_set_port_power(xhci, xhci->shared_hcd, i, false, &flags);
+
 	/* Workaround for spurious wakeups at shutdown with HSW */
 	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
 		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
-	spin_unlock_irq(&xhci->lock);
+	spin_unlock_irqrestore(&xhci->lock, flags);
 
 	xhci_cleanup_msix(xhci);
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 0bd76c94a4b1..28aaf031f9a8 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2196,6 +2196,8 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex,
 int xhci_hub_status_data(struct usb_hcd *hcd, char *buf);
 int xhci_find_raw_port_number(struct usb_hcd *hcd, int port1);
 struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd);
+void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd, u16 index,
+			 bool on, unsigned long *flags);
 
 void xhci_hc_died(struct xhci_hcd *xhci);
 
-- 
2.25.1


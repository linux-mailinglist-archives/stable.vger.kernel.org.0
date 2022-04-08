Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF97F4F9730
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 15:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbiDHNsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 09:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236478AbiDHNso (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 09:48:44 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFE460CEF;
        Fri,  8 Apr 2022 06:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649425601; x=1680961601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2RsBxvZgX52mmyvnnY0IE8cn0uckQN1XXAvC+D/+vJU=;
  b=PGinHrV924gbEGL2gBBl0MGxH4PC4nRwU4fRJQtfze28igfPHDevDBt9
   QswiQ2Hvbfc0yCphj5uTQdtdJBMfhe4tGWC3SSQpmMUnclk/D1MnwXxHw
   uDCssu5m9m0AcZNKLiTFY3Z4vq7WwSvJuP3YyshI+kffWURGFjZm4RE4U
   8lXiVtRpRYozGb+uokoBTdpFkEI7uyjLJAM/MPuomtnCVoSOunXH5YlRX
   IzfhCtNw7LhwCyujsmbvDVE+bhaAFBtjKTvjW43gp0XUO3qMXpAol58my
   4rrpUtqhyHHrAdNectONvJtq5SvD09v+PqNOmYsjAKBHTgbLqeYj/aWXo
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="260432091"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="260432091"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 06:46:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="653263290"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by fmsmga002.fm.intel.com with ESMTP; 08 Apr 2022 06:46:39 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Henry Lin <henryl@nvidia.com>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 2/3] xhci: stop polling roothubs after shutdown
Date:   Fri,  8 Apr 2022 16:48:22 +0300
Message-Id: <20220408134823.2527272-3-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408134823.2527272-1-mathias.nyman@linux.intel.com>
References: <20220408134823.2527272-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henry Lin <henryl@nvidia.com>

While rebooting, XHCI controller and its bus device will be shut down
in order by .shutdown callback. Stopping roothubs polling in
xhci_shutdown() can prevent XHCI driver from accessing port status
after its bus device shutdown.

Take PCIe XHCI controller as example, if XHCI driver doesn't stop roothubs
polling, XHCI driver may access PCIe BAR register for port status after
parent PCIe root port driver is shutdown and cause PCIe bus error.

[check shared hcd exist before stopping its roothub polling -Mathias]
Cc: stable@vger.kernel.org
Signed-off-by: Henry Lin <henryl@nvidia.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 642610c78f58..25b87e99b4dd 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -781,6 +781,17 @@ void xhci_shutdown(struct usb_hcd *hcd)
 	if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
 		usb_disable_xhci_ports(to_pci_dev(hcd->self.sysdev));
 
+	/* Don't poll the roothubs after shutdown. */
+	xhci_dbg(xhci, "%s: stopping usb%d port polling.\n",
+			__func__, hcd->self.busnum);
+	clear_bit(HCD_FLAG_POLL_RH, &hcd->flags);
+	del_timer_sync(&hcd->rh_timer);
+
+	if (xhci->shared_hcd) {
+		clear_bit(HCD_FLAG_POLL_RH, &xhci->shared_hcd->flags);
+		del_timer_sync(&xhci->shared_hcd->rh_timer);
+	}
+
 	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
 	/* Workaround for spurious wakeups at shutdown with HSW */
-- 
2.25.1


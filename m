Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96CC4266AA
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 11:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237656AbhJHJZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 05:25:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:41430 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237621AbhJHJZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 05:25:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="249830689"
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="249830689"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 02:23:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="489390518"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by orsmga008.jf.intel.com with ESMTP; 08 Oct 2021 02:23:17 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3/5] USB: xhci: dbc: fix tty registration race
Date:   Fri,  8 Oct 2021 12:25:45 +0300
Message-Id: <20211008092547.3996295-4-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211008092547.3996295-1-mathias.nyman@linux.intel.com>
References: <20211008092547.3996295-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

Make sure to allocate resources before registering the tty device to
avoid having a racing open() and write() fail to enable rx or
dereference a NULL pointer when accessing the uninitialised fifo.

Fixes: dfba2174dc42 ("usb: xhci: Add DbC support in xHCI driver")
Cc: stable@vger.kernel.org      # 4.16
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-dbgtty.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/host/xhci-dbgtty.c b/drivers/usb/host/xhci-dbgtty.c
index 6e784f2fc26d..eb46e642e87a 100644
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -408,40 +408,38 @@ static int xhci_dbc_tty_register_device(struct xhci_dbc *dbc)
 		return -EBUSY;
 
 	xhci_dbc_tty_init_port(dbc, port);
-	tty_dev = tty_port_register_device(&port->port,
-					   dbc_tty_driver, 0, NULL);
-	if (IS_ERR(tty_dev)) {
-		ret = PTR_ERR(tty_dev);
-		goto register_fail;
-	}
 
 	ret = kfifo_alloc(&port->write_fifo, DBC_WRITE_BUF_SIZE, GFP_KERNEL);
 	if (ret)
-		goto buf_alloc_fail;
+		goto err_exit_port;
 
 	ret = xhci_dbc_alloc_requests(dbc, BULK_IN, &port->read_pool,
 				      dbc_read_complete);
 	if (ret)
-		goto request_fail;
+		goto err_free_fifo;
 
 	ret = xhci_dbc_alloc_requests(dbc, BULK_OUT, &port->write_pool,
 				      dbc_write_complete);
 	if (ret)
-		goto request_fail;
+		goto err_free_requests;
+
+	tty_dev = tty_port_register_device(&port->port,
+					   dbc_tty_driver, 0, NULL);
+	if (IS_ERR(tty_dev)) {
+		ret = PTR_ERR(tty_dev);
+		goto err_free_requests;
+	}
 
 	port->registered = true;
 
 	return 0;
 
-request_fail:
+err_free_requests:
 	xhci_dbc_free_requests(&port->read_pool);
 	xhci_dbc_free_requests(&port->write_pool);
+err_free_fifo:
 	kfifo_free(&port->write_fifo);
-
-buf_alloc_fail:
-	tty_unregister_device(dbc_tty_driver, 0);
-
-register_fail:
+err_exit_port:
 	xhci_dbc_tty_exit_port(port);
 
 	dev_err(dbc->dev, "can't register tty port, err %d\n", ret);
-- 
2.25.1


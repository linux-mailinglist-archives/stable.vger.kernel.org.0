Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967D1431C9A
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbhJRNmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233533AbhJRNkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:40:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4E926136F;
        Mon, 18 Oct 2021 13:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564001;
        bh=yfN7EGh3Al7/4fTwI+49e2k8sdmx5o55f6mHhmRtwjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CP6vPqtjdQwpBgyY1dhT+eURLUBD/sMp6dxaIz7xGUIWcmYXGhXWFU4wosx4dpM+Q
         JMZ892/SgrDti8jxwQ9mh2bkC5sLXEqYskbwmmL7ydx8bbcydLBV0ruJueZjjo9Nk+
         YZ+5bxVXtPG98K4mdCuE1q9B4If/Y1rx4etsgkzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Johan Hovold <johan@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 027/103] USB: xhci: dbc: fix tty registration race
Date:   Mon, 18 Oct 2021 15:24:03 +0200
Message-Id: <20211018132335.628418797@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 880de403777376e50bdf60def359fa50a722006f upstream.

Make sure to allocate resources before registering the tty device to
avoid having a racing open() and write() fail to enable rx or
dereference a NULL pointer when accessing the uninitialised fifo.

Fixes: dfba2174dc42 ("usb: xhci: Add DbC support in xHCI driver")
Cc: stable@vger.kernel.org      # 4.16
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20211008092547.3996295-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgtty.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -408,40 +408,38 @@ static int xhci_dbc_tty_register_device(
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



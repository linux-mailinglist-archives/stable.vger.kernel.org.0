Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42201431333
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 11:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhJRJXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 05:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231149AbhJRJXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 05:23:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40060610A6;
        Mon, 18 Oct 2021 09:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634548895;
        bh=45uHLhSwbxZGqieE58NQBSMQKb+4dloBQaOE2gvnbEI=;
        h=Subject:To:Cc:From:Date:From;
        b=R2ij7LD6CrwOI6D/ZMzffkKkb0XKmvopY2LQmRSfMnxHi+eXNOf21C2Zx8TMZrrZR
         CnoRtTYwLVN5t3RMzGQfsGGlit5KE1jxmfX1ZzPFdSorwhw+nQsfjVUMZLLBBJePve
         Wd2GvqhFDME7QDCViIIFaHBqGhQGSk/Bzl3Cf204=
Subject: FAILED: patch "[PATCH] USB: xhci: dbc: fix tty registration race" failed to apply to 4.19-stable tree
To:     johan@kernel.org, baolu.lu@linux.intel.com,
        gregkh@linuxfoundation.org, mathias.nyman@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 11:21:25 +0200
Message-ID: <163454888522184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 880de403777376e50bdf60def359fa50a722006f Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Fri, 8 Oct 2021 12:25:45 +0300
Subject: [PATCH] USB: xhci: dbc: fix tty registration race

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


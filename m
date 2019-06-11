Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10A7C3D3F7
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 19:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405946AbfFKRYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 13:24:23 -0400
Received: from mga06.intel.com ([134.134.136.31]:13809 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405718AbfFKRYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 13:24:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jun 2019 10:24:22 -0700
X-ExtLoop1: 1
Received: from pipin.fi.intel.com ([10.237.72.175])
  by orsmga005.jf.intel.com with ESMTP; 11 Jun 2019 10:24:20 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     linux-usb@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] usb: xhci: dbc: get rid of global pointer
Date:   Tue, 11 Jun 2019 20:24:16 +0300
Message-Id: <20190611172416.12473-1-felipe.balbi@linux.intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we happen to have two XHCI controllers with DbC capability, then
there's no hope this will ever work as the global pointer will be
overwritten by the controller that probes last.

Avoid this problem by keeping the tty_driver struct pointer inside
struct xhci_dbc.

Fixes: dfba2174dc42 usb: xhci: Add DbC support in xHCI driver
Cc: <stable@vger.kernel.org> # v4.16+
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/usb/host/xhci-dbgcap.c |  4 +--
 drivers/usb/host/xhci-dbgcap.h |  3 +-
 drivers/usb/host/xhci-dbgtty.c | 54 +++++++++++++++++-----------------
 3 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/usb/host/xhci-dbgcap.c b/drivers/usb/host/xhci-dbgcap.c
index 52e32644a4b2..5f56b650c0ea 100644
--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -948,7 +948,7 @@ int xhci_dbc_init(struct xhci_hcd *xhci)
 	return 0;
 
 init_err1:
-	xhci_dbc_tty_unregister_driver();
+	xhci_dbc_tty_unregister_driver(xhci);
 init_err2:
 	xhci_do_dbc_exit(xhci);
 init_err3:
@@ -963,7 +963,7 @@ void xhci_dbc_exit(struct xhci_hcd *xhci)
 		return;
 
 	device_remove_file(dev, &dev_attr_dbc);
-	xhci_dbc_tty_unregister_driver();
+	xhci_dbc_tty_unregister_driver(xhci);
 	xhci_dbc_stop(xhci);
 	xhci_do_dbc_exit(xhci);
 }
diff --git a/drivers/usb/host/xhci-dbgcap.h b/drivers/usb/host/xhci-dbgcap.h
index ce0c6072bd48..30dedf36c566 100644
--- a/drivers/usb/host/xhci-dbgcap.h
+++ b/drivers/usb/host/xhci-dbgcap.h
@@ -151,6 +151,7 @@ struct xhci_dbc {
 	struct dbc_ep			eps[2];
 
 	struct dbc_port			port;
+	struct tty_driver		*tty_driver;
 };
 
 #define dbc_bulkout_ctx(d)		\
@@ -196,7 +197,7 @@ static inline struct dbc_ep *get_out_ep(struct xhci_hcd *xhci)
 int xhci_dbc_init(struct xhci_hcd *xhci);
 void xhci_dbc_exit(struct xhci_hcd *xhci);
 int xhci_dbc_tty_register_driver(struct xhci_hcd *xhci);
-void xhci_dbc_tty_unregister_driver(void);
+void xhci_dbc_tty_unregister_driver(struct xhci_hcd *xhci);
 int xhci_dbc_tty_register_device(struct xhci_hcd *xhci);
 void xhci_dbc_tty_unregister_device(struct xhci_hcd *xhci);
 struct dbc_request *dbc_alloc_request(struct dbc_ep *dep, gfp_t gfp_flags);
diff --git a/drivers/usb/host/xhci-dbgtty.c b/drivers/usb/host/xhci-dbgtty.c
index aff79ff5aba4..300fc770a0d5 100644
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -279,52 +279,52 @@ static const struct tty_operations dbc_tty_ops = {
 	.unthrottle		= dbc_tty_unthrottle,
 };
 
-static struct tty_driver *dbc_tty_driver;
-
 int xhci_dbc_tty_register_driver(struct xhci_hcd *xhci)
 {
 	int			status;
 	struct xhci_dbc		*dbc = xhci->dbc;
 
-	dbc_tty_driver = tty_alloc_driver(1, TTY_DRIVER_REAL_RAW |
+	dbc->tty_driver = tty_alloc_driver(1, TTY_DRIVER_REAL_RAW |
 					  TTY_DRIVER_DYNAMIC_DEV);
-	if (IS_ERR(dbc_tty_driver)) {
-		status = PTR_ERR(dbc_tty_driver);
-		dbc_tty_driver = NULL;
+	if (IS_ERR(dbc->tty_driver)) {
+		status = PTR_ERR(dbc->tty_driver);
+		dbc->tty_driver = NULL;
 		return status;
 	}
 
-	dbc_tty_driver->driver_name = "dbc_serial";
-	dbc_tty_driver->name = "ttyDBC";
+	dbc->tty_driver->driver_name = "dbc_serial";
+	dbc->tty_driver->name = "ttyDBC";
 
-	dbc_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
-	dbc_tty_driver->subtype = SERIAL_TYPE_NORMAL;
-	dbc_tty_driver->init_termios = tty_std_termios;
-	dbc_tty_driver->init_termios.c_cflag =
+	dbc->tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
+	dbc->tty_driver->subtype = SERIAL_TYPE_NORMAL;
+	dbc->tty_driver->init_termios = tty_std_termios;
+	dbc->tty_driver->init_termios.c_cflag =
 			B9600 | CS8 | CREAD | HUPCL | CLOCAL;
-	dbc_tty_driver->init_termios.c_ispeed = 9600;
-	dbc_tty_driver->init_termios.c_ospeed = 9600;
-	dbc_tty_driver->driver_state = &dbc->port;
+	dbc->tty_driver->init_termios.c_ispeed = 9600;
+	dbc->tty_driver->init_termios.c_ospeed = 9600;
+	dbc->tty_driver->driver_state = &dbc->port;
 
-	tty_set_operations(dbc_tty_driver, &dbc_tty_ops);
+	tty_set_operations(dbc->tty_driver, &dbc_tty_ops);
 
-	status = tty_register_driver(dbc_tty_driver);
+	status = tty_register_driver(dbc->tty_driver);
 	if (status) {
 		xhci_err(xhci,
 			 "can't register dbc tty driver, err %d\n", status);
-		put_tty_driver(dbc_tty_driver);
-		dbc_tty_driver = NULL;
+		put_tty_driver(dbc->tty_driver);
+		dbc->tty_driver = NULL;
 	}
 
 	return status;
 }
 
-void xhci_dbc_tty_unregister_driver(void)
+void xhci_dbc_tty_unregister_driver(struct xhci_hcd *xhci)
 {
-	if (dbc_tty_driver) {
-		tty_unregister_driver(dbc_tty_driver);
-		put_tty_driver(dbc_tty_driver);
-		dbc_tty_driver = NULL;
+	struct xhci_dbc		*dbc = xhci->dbc;
+
+	if (dbc->tty_driver) {
+		tty_unregister_driver(dbc->tty_driver);
+		put_tty_driver(dbc->tty_driver);
+		dbc->tty_driver = NULL;
 	}
 }
 
@@ -449,7 +449,7 @@ int xhci_dbc_tty_register_device(struct xhci_hcd *xhci)
 
 	xhci_dbc_tty_init_port(xhci, port);
 	tty_dev = tty_port_register_device(&port->port,
-					   dbc_tty_driver, 0, NULL);
+					   dbc->tty_driver, 0, NULL);
 	if (IS_ERR(tty_dev)) {
 		ret = PTR_ERR(tty_dev);
 		goto register_fail;
@@ -479,7 +479,7 @@ int xhci_dbc_tty_register_device(struct xhci_hcd *xhci)
 	kfifo_free(&port->write_fifo);
 
 buf_alloc_fail:
-	tty_unregister_device(dbc_tty_driver, 0);
+	tty_unregister_device(dbc->tty_driver, 0);
 
 register_fail:
 	xhci_dbc_tty_exit_port(port);
@@ -494,7 +494,7 @@ void xhci_dbc_tty_unregister_device(struct xhci_hcd *xhci)
 	struct xhci_dbc		*dbc = xhci->dbc;
 	struct dbc_port		*port = &dbc->port;
 
-	tty_unregister_device(dbc_tty_driver, 0);
+	tty_unregister_device(dbc->tty_driver, 0);
 	xhci_dbc_tty_exit_port(port);
 	port->registered = false;
 
-- 
2.22.0


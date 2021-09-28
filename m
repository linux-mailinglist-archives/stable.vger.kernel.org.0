Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA30F41AE66
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 14:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240412AbhI1MGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 08:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240410AbhI1MGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 08:06:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18C31611C7;
        Tue, 28 Sep 2021 12:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632830713;
        bh=UW41wA6UexwXfO+ET/Gq/KMyYOkaqqvmSfYGQ2jsm0s=;
        h=From:To:Cc:Subject:Date:From;
        b=f4hVmdUBNE/wqiX0GdCG0EN4TFnatwj3LDS57ZwfPRJ6R/zez1E8VLXfIdWm8cjke
         bQW304KYooguyuW1FS4iQJN/+s+vnq/QS1SA2pH8bIyKdCp8wQusRduYbdEWQ//u7G
         JCDlCtyglb09X0b2bcPusdYWNKZA20TA49s0ceiggLRovsf29n3Lw/vde1NXPQVHpq
         NaVTzMHN3z3HKZHWwBiRsAItRLuMOK38usMq/TpeFins/gT1N7HAb3YA2V5WGDx3o8
         jWVfXStsbOhYRFZXDBraWi9vnvd03Cl6xLys2UEJ0WZo4AN0shzkry3qpVPlaLojgV
         IAid6CTwmzeUQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mVBrF-0005P2-3V; Tue, 28 Sep 2021 14:05:13 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Mathias Nyman <mathias.nyman@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH] USB: xhci: dbc: fix tty registration race
Date:   Tue, 28 Sep 2021 14:04:00 +0200
Message-Id: <20210928120400.20704-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to allocate resources before registering the tty device to
avoid having a racing open() and write() fail to enable rx or
dereference a NULL pointer when accessing the uninitialised fifo.

Fixes: dfba2174dc42 ("usb: xhci: Add DbC support in xHCI driver")
Cc: stable@vger.kernel.org      # 4.16
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
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
2.32.0


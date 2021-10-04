Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB11420CB6
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbhJDNJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233874AbhJDNHx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:07:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C5AE6139F;
        Mon,  4 Oct 2021 13:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352518;
        bh=ai6t8Io9YxNczUiR+Rh8jbyDH7qVOcOTOC9EGJBkAPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5NSQ7Wc1RZD1zd58N4IhppMv9+GtqTGgtKEFkmP2wHABjU8Gfw27daoFUSfLECvO
         ONzIV6uZ8bfE0hc0RTTNSZkn45ErL1byoEo9IwEFnEXsXTB7iJbUYRMEznQVbsaY5Z
         w7TDi2rfzvLH28wM6t9J2O2VHmO5ULKiYhjGf0W0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 18/95] net: hso: fix muxed tty registration
Date:   Mon,  4 Oct 2021 14:51:48 +0200
Message-Id: <20211004125034.148261499@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit e8f69b16ee776da88589b5271e3f46020efc8f6c upstream.

If resource allocation and registration fail for a muxed tty device
(e.g. if there are no more minor numbers) the driver should not try to
deregister the never-registered (or already-deregistered) tty.

Fix up the error handling to avoid dereferencing a NULL pointer when
attempting to remove the character device.

Fixes: 72dc1c096c70 ("HSO: add option hso driver")
Cc: stable@vger.kernel.org	# 2.6.27
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/hso.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2714,14 +2714,14 @@ struct hso_device *hso_create_mux_serial
 
 	serial = kzalloc(sizeof(*serial), GFP_KERNEL);
 	if (!serial)
-		goto exit;
+		goto err_free_dev;
 
 	hso_dev->port_data.dev_serial = serial;
 	serial->parent = hso_dev;
 
 	if (hso_serial_common_create
 	    (serial, 1, CTRL_URB_RX_SIZE, CTRL_URB_TX_SIZE))
-		goto exit;
+		goto err_free_serial;
 
 	serial->tx_data_length--;
 	serial->write_data = hso_mux_serial_write_data;
@@ -2737,11 +2737,9 @@ struct hso_device *hso_create_mux_serial
 	/* done, return it */
 	return hso_dev;
 
-exit:
-	if (serial) {
-		tty_unregister_device(tty_drv, serial->minor);
-		kfree(serial);
-	}
+err_free_serial:
+	kfree(serial);
+err_free_dev:
 	kfree(hso_dev);
 	return NULL;
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F85F419BA8
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235993AbhI0RVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236526AbhI0RT2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:19:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9BCF6128B;
        Mon, 27 Sep 2021 17:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762763;
        bh=2vzcb3332euiA5WEdzIoP5q5xrozkP4NRrZuJ9trr5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=un+jAhR4NX5mnGYBMpDJ7p3AUVQG2jtWFHCYFwV4F0XAIGQnBoXEcn3H9MGg9gZH/
         qHBYjLzJ6azKHLus0mKn/7HUBUIMFw2xInKSvM3YmSlU0jYbAxMZU+K+RjpuNKFnqU
         H9uZ97wVJfWmcWp8SdOQ9B35fLEf0QayOYTwv9yU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 042/162] net: hso: fix muxed tty registration
Date:   Mon, 27 Sep 2021 19:01:28 +0200
Message-Id: <20210927170234.957749187@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
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
@@ -2720,14 +2720,14 @@ struct hso_device *hso_create_mux_serial
 
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
@@ -2743,11 +2743,9 @@ struct hso_device *hso_create_mux_serial
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
 



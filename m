Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69D3419A10
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbhI0RGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235804AbhI0RGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:06:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB7666113D;
        Mon, 27 Sep 2021 17:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762265;
        bh=P05baZsuVmGrScDKFghEoeFNrTjuLwQh/67Nmgt0fSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2rNSXxXLnYklm9hLdturQQq2j2xB3zhDKuSuB1LzSUsgr4xxkyev/gBU6blGBkeX
         F8wFyMWDeL4+bLS8uxEpPQ1LQcOKoASuO7VC1rRHkqhu91tywZiJap7w9sjow5o0+E
         LKn0vs1OFZnyDTb0E5J+fvfyhgmW46tM1Y79RY7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 24/68] net: hso: fix muxed tty registration
Date:   Mon, 27 Sep 2021 19:02:20 +0200
Message-Id: <20210927170220.791697034@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
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
@@ -2704,14 +2704,14 @@ struct hso_device *hso_create_mux_serial
 
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
@@ -2727,11 +2727,9 @@ struct hso_device *hso_create_mux_serial
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
 



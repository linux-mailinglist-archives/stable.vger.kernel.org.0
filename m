Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C838038E2FC
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 11:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbhEXJMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 05:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232313AbhEXJMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 05:12:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69251610A5;
        Mon, 24 May 2021 09:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621847450;
        bh=no7eloZ5sAyp3aCUK6Dcm61tIA1KHGnWOXPSfKyYA68=;
        h=From:To:Cc:Subject:Date:From;
        b=a5/byc3pP7owHplyKRczSzx32j7kd13RAv6HmbPFRw00DoM5pqzEvSJtG6JvvJRma
         GT4oeGSDnDIrtovwKEzqVhBjd+34WXTfa8vwayAtTyzGorzaU2bV4xP+pxDGZjLVvU
         /WOBBgYOnBFSWbP9aW0EdvX0AeiHku0kJSfMKAqqJCTi2XJjdwJCXOUUu9rJU5FGmf
         yQa9p+85MoAOAfTxYyo5Jdv1ArXiWD6pfyUexRD2cxT6xEI54Hmbn1dVIhopwGSiKo
         I/bsKyPdKLPlPPj50CBj0a6dB1OSnBNMQBVbaII88MZ3lP+nLHVcDHFyYtfmiBXMp9
         cFqNltxnkWNcw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ll6bn-00013R-SL; Mon, 24 May 2021 11:10:47 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Wolfram Sang <wsa@kernel.org>
Cc:     linux-i2c@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        syzbot+9d7dadd15b8819d73f41@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH] i2c: robotfuzz-osif: fix control-request directions
Date:   Mon, 24 May 2021 11:09:12 +0200
Message-Id: <20210524090912.3989-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Control transfers without a data stage are treated as OUT requests by
the USB stack and should be using usb_sndctrlpipe(). Failing to do so
will now trigger a warning.

Fix the OSIFI2C_SET_BIT_RATE and OSIFI2C_STOP requests which erroneously
used the osif_usb_read() helper and set the IN direction bit.

Reported-by: syzbot+9d7dadd15b8819d73f41@syzkaller.appspotmail.com
Fixes: 83e53a8f120f ("i2c: Add bus driver for for OSIF USB i2c device.")
Cc: stable@vger.kernel.org      # 3.14
Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/i2c/busses/i2c-robotfuzz-osif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-robotfuzz-osif.c b/drivers/i2c/busses/i2c-robotfuzz-osif.c
index a39f7d092797..66dfa211e736 100644
--- a/drivers/i2c/busses/i2c-robotfuzz-osif.c
+++ b/drivers/i2c/busses/i2c-robotfuzz-osif.c
@@ -83,7 +83,7 @@ static int osif_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs,
 			}
 		}
 
-		ret = osif_usb_read(adapter, OSIFI2C_STOP, 0, 0, NULL, 0);
+		ret = osif_usb_write(adapter, OSIFI2C_STOP, 0, 0, NULL, 0);
 		if (ret) {
 			dev_err(&adapter->dev, "failure sending STOP\n");
 			return -EREMOTEIO;
@@ -153,7 +153,7 @@ static int osif_probe(struct usb_interface *interface,
 	 * Set bus frequency. The frequency is:
 	 * 120,000,000 / ( 16 + 2 * div * 4^prescale).
 	 * Using dev = 52, prescale = 0 give 100KHz */
-	ret = osif_usb_read(&priv->adapter, OSIFI2C_SET_BIT_RATE, 52, 0,
+	ret = osif_usb_write(&priv->adapter, OSIFI2C_SET_BIT_RATE, 52, 0,
 			    NULL, 0);
 	if (ret) {
 		dev_err(&interface->dev, "failure sending bit rate");
-- 
2.26.3


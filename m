Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113543962D2
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhEaPBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234375AbhEaO7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:59:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A0C261943;
        Mon, 31 May 2021 14:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469686;
        bh=YkqUDYWS6J6RK4cCwoTYGe+hTHoCWzpzNwFSw0XN9SA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkJoZflWM71LSjqxk7AKqZB31R89FGX6LWsfv5kO/UJ4LYyIUY5eDyRnKEQcRPaqM
         JXuzodcATX+6PNI2hsbl4Uy5vvEWPbf+BYUsRYgDYbHCjSwY1ydFHEArp/R4TyxDzu
         x9/zi2/xiH89nqnl5rSrowzPdqhnTZg+6lZI12dQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 293/296] net: hso: bail out on interrupt URB allocation failure
Date:   Mon, 31 May 2021 15:15:48 +0200
Message-Id: <20210531130713.561033828@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 4d52ebc7ace491d58f96d1f4a1cb9070c506b2e7 upstream.

Commit 31db0dbd7244 ("net: hso: check for allocation failure in
hso_create_bulk_serial_device()") recently started returning an error
when the driver fails to allocate resources for the interrupt endpoint
and tiocmget functionality.

For consistency let's bail out from probe also if the URB allocation
fails.

Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/hso.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2635,14 +2635,14 @@ static struct hso_device *hso_create_bul
 		}
 
 		tiocmget->urb = usb_alloc_urb(0, GFP_KERNEL);
-		if (tiocmget->urb) {
-			mutex_init(&tiocmget->mutex);
-			init_waitqueue_head(&tiocmget->waitq);
-		} else
-			hso_free_tiomget(serial);
-	}
-	else
+		if (!tiocmget->urb)
+			goto exit;
+
+		mutex_init(&tiocmget->mutex);
+		init_waitqueue_head(&tiocmget->waitq);
+	} else {
 		num_urbs = 1;
+	}
 
 	if (hso_serial_common_create(serial, num_urbs, BULK_URB_RX_SIZE,
 				     BULK_URB_TX_SIZE))



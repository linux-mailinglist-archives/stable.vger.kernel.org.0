Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C592F7C0E
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729536AbfKKSml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:42:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729541AbfKKSmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:42:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3735220674;
        Mon, 11 Nov 2019 18:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497760;
        bh=qcPbvtM5qo4M4GqJ3W/AShFZvu0AH5WXdRDV5Xr6KZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1cezZrPfeBJcWgvhdD5/oB/tAQRqSuuamLT7K6JP0ODDjuyFd33rFzljbfah0v6C
         aHjTktxFuhDnJsbQ3WP54J5cWuZEfTwMMflcoTCIGNMG9wNyjFDojtIVSP8NYh9Usg
         pOiODhqr7xy+wqDU6IbTwcLBNk1mZ+RlcWCDR1t0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Remigiusz=20Ko=C5=82=C5=82=C4=85taj?= 
        <remigiusz.kollataj@mobica.com>,
        syzbot+e29b17e5042bbc56fae9@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.19 050/125] can: mcba_usb: fix use-after-free on disconnect
Date:   Mon, 11 Nov 2019 19:28:09 +0100
Message-Id: <20191111181447.033273849@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 4d6636498c41891d0482a914dd570343a838ad79 upstream.

The driver was accessing its driver data after having freed it.

Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
Cc: stable <stable@vger.kernel.org>     # 4.12
Cc: Remigiusz Kołłątaj <remigiusz.kollataj@mobica.com>
Reported-by: syzbot+e29b17e5042bbc56fae9@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/mcba_usb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -887,9 +887,8 @@ static void mcba_usb_disconnect(struct u
 	netdev_info(priv->netdev, "device disconnected\n");
 
 	unregister_candev(priv->netdev);
-	free_candev(priv->netdev);
-
 	mcba_urb_unlink(priv);
+	free_candev(priv->netdev);
 }
 
 static struct usb_driver mcba_usb_driver = {



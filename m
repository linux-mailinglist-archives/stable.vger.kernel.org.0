Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB0C43952C
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 13:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhJYLsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 07:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233251AbhJYLsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 07:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 821C261076;
        Mon, 25 Oct 2021 11:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635162381;
        bh=SE2uA80Y728ubzRuP43yoQCcRvgaEZWwlnRAZGAxKo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgJnPtUo3c9Qvf4tmiS4gKq+xMeJXkbsONjV7gXXsn++KtvVX3XibOGf6J2jMOhHu
         1nqh3oDIXi4lNuololneAhbCRdaPboGDDxKc1d/zV9o59t8SHiYQbb7XjOGwg1oSLW
         bizcJtaztiViX4yrTZiv64EdTh9ntM37S5bytdzs59hJEAS3X47xxWQ3fe+9tkgAcO
         jkE+QWv9G2oEDee4yWcJ49B/Y76UebeBx5q/l/oov+OToPhVp6Niu9r+fM03qod3mB
         xYeX8nDMshMEpYtWDHS/iadHFAvef4zI/2TSNIMqHM95YUbDCldXdbOC+uXJ9FAWvn
         ji3bMNjiSRrtQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyQW-0001DK-Dp; Mon, 25 Oct 2021 13:46:04 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 4/5] comedi: vmk80xx: fix bulk-buffer overflow
Date:   Mon, 25 Oct 2021 13:45:31 +0200
Message-Id: <20211025114532.4599-5-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025114532.4599-1-johan@kernel.org>
References: <20211025114532.4599-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver is using endpoint-sized buffers but must not assume that the
tx and rx buffers are of equal size or a malicious device could overflow
the slab-allocated receive buffer when doing bulk transfers.

Fixes: 985cafccbf9b ("Staging: Comedi: vmk80xx: Add k8061 support")
Cc: stable@vger.kernel.org      # 2.6.31
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/comedi/drivers/vmk80xx.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/comedi/drivers/vmk80xx.c b/drivers/comedi/drivers/vmk80xx.c
index f2c1572d0cd7..9c56918e3b76 100644
--- a/drivers/comedi/drivers/vmk80xx.c
+++ b/drivers/comedi/drivers/vmk80xx.c
@@ -159,22 +159,20 @@ static void vmk80xx_do_bulk_msg(struct comedi_device *dev)
 	__u8 rx_addr;
 	unsigned int tx_pipe;
 	unsigned int rx_pipe;
-	size_t size;
+	size_t tx_size;
+	size_t rx_size;
 
 	tx_addr = devpriv->ep_tx->bEndpointAddress;
 	rx_addr = devpriv->ep_rx->bEndpointAddress;
 	tx_pipe = usb_sndbulkpipe(usb, tx_addr);
 	rx_pipe = usb_rcvbulkpipe(usb, rx_addr);
-
-	/*
-	 * The max packet size attributes of the K8061
-	 * input/output endpoints are identical
-	 */
-	size = usb_endpoint_maxp(devpriv->ep_tx);
+	tx_size = usb_endpoint_maxp(devpriv->ep_tx);
+	rx_size = usb_endpoint_maxp(devpriv->ep_rx);
 
 	usb_bulk_msg(usb, tx_pipe, devpriv->usb_tx_buf,
-		     size, NULL, devpriv->ep_tx->bInterval);
-	usb_bulk_msg(usb, rx_pipe, devpriv->usb_rx_buf, size, NULL, HZ * 10);
+		     tx_size, NULL, devpriv->ep_tx->bInterval);
+
+	usb_bulk_msg(usb, rx_pipe, devpriv->usb_rx_buf, rx_size, NULL, HZ * 10);
 }
 
 static int vmk80xx_read_packet(struct comedi_device *dev)
-- 
2.32.0


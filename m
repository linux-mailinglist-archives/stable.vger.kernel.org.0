Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E6512EFB3
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgABW2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:28:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729948AbgABW2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:28:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5FD420863;
        Thu,  2 Jan 2020 22:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004126;
        bh=pNuyfZHzd3vJd3D5LJa8qilDNRQL2qZ8n+WF/3mK1ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2RTP/QZT3hC3BhMPuqFpzik52rja5Y7hPg5SASXBKby4gtKUnAwILmXEe26Xdhu6v
         taLm94Iu+rHtKekMERrBp7QE/HGCbFL94cENGRO7s51DJILI5JS7uWUZLkQ1/Ys0OY
         W5LhkqfZ2uwGvJPfSWAcBSNhynU6yZ53xUnCkO00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 011/171] staging: rtl8192u: fix multiple memory leaks on error path
Date:   Thu,  2 Jan 2020 23:05:42 +0100
Message-Id: <20200102220548.532326268@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit ca312438cf176a16d4b89350cade8789ba8d7133 ]

In rtl8192_tx on error handling path allocated urbs and also skb should
be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Link: https://lore.kernel.org/r/20190920025137.29407-1-navid.emamdoost@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192u/r8192U_core.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 5fe95937d811..6ec379056650 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -1509,7 +1509,7 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff *skb)
 		(tx_fwinfo_819x_usb *)(skb->data + USB_HWDESC_HEADER_LEN);
 	struct usb_device *udev = priv->udev;
 	int pend;
-	int status;
+	int status, rt = -1;
 	struct urb *tx_urb = NULL, *tx_urb_zero = NULL;
 	unsigned int idx_pipe;
 
@@ -1653,8 +1653,10 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff *skb)
 		}
 		if (bSend0Byte) {
 			tx_urb_zero = usb_alloc_urb(0, GFP_ATOMIC);
-			if (!tx_urb_zero)
-				return -ENOMEM;
+			if (!tx_urb_zero) {
+				rt = -ENOMEM;
+				goto error;
+			}
 			usb_fill_bulk_urb(tx_urb_zero, udev,
 					  usb_sndbulkpipe(udev, idx_pipe),
 					  &zero, 0, tx_zero_isr, dev);
@@ -1664,7 +1666,7 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff *skb)
 					 "Error TX URB for zero byte %d, error %d",
 					 atomic_read(&priv->tx_pending[tcb_desc->queue_index]),
 					 status);
-				return -1;
+				goto error;
 			}
 		}
 		netif_trans_update(dev);
@@ -1675,7 +1677,12 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff *skb)
 	RT_TRACE(COMP_ERR, "Error TX URB %d, error %d",
 		 atomic_read(&priv->tx_pending[tcb_desc->queue_index]),
 		 status);
-	return -1;
+
+error:
+	dev_kfree_skb_any(skb);
+	usb_free_urb(tx_urb);
+	usb_free_urb(tx_urb_zero);
+	return rt;
 }
 
 static short rtl8192_usb_initendpoints(struct net_device *dev)
-- 
2.20.1




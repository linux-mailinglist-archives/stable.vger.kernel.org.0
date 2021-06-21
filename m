Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF8D3AED8A
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhFUQUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231193AbhFUQUP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:20:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CDAA6124B;
        Mon, 21 Jun 2021 16:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292280;
        bh=R+K1kOTSDi1oBWmc24quiDJrX4YPlcTwKkrI8ACXNSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3sr7HYxsrFw90qzmOGzXrH+KvpNIwmFhyzx1TQ9ItSBFKuFx+p92JbetZH6p9WVh
         kwybypdKyAjcu9J7F5wVBx8M+2Kq+3g/wmeB4sbjBh1qEC6FWT2UfsU4619kDBJq8N
         y1oWrNjuYljivLb4DgQ0W7KpMd/+0d5gqCrEr2Os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 31/90] net: usb: fix possible use-after-free in smsc75xx_bind
Date:   Mon, 21 Jun 2021 18:15:06 +0200
Message-Id: <20210621154905.168947506@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 56b786d86694e079d8aad9b314e015cd4ac02a3d ]

The commit 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
fails to clean up the work scheduled in smsc75xx_reset->
smsc75xx_set_multicast, which leads to use-after-free if the work is
scheduled to start after the deallocation. In addition, this patch
also removes a dangling pointer - dev->data[0].

This patch calls cancel_work_sync to cancel the scheduled work and set
the dangling pointer to NULL.

Fixes: 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc75xx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index d0ae0df34e13..aa848be459ec 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1482,7 +1482,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = smsc75xx_wait_ready(dev, 0);
 	if (ret < 0) {
 		netdev_warn(dev->net, "device not ready in smsc75xx_bind\n");
-		goto err;
+		goto free_pdata;
 	}
 
 	smsc75xx_init_mac_address(dev);
@@ -1491,7 +1491,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = smsc75xx_reset(dev);
 	if (ret < 0) {
 		netdev_warn(dev->net, "smsc75xx_reset error %d\n", ret);
-		goto err;
+		goto cancel_work;
 	}
 
 	dev->net->netdev_ops = &smsc75xx_netdev_ops;
@@ -1502,8 +1502,11 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->max_mtu = MAX_SINGLE_PACKET_SIZE;
 	return 0;
 
-err:
+cancel_work:
+	cancel_work_sync(&pdata->set_multicast);
+free_pdata:
 	kfree(pdata);
+	dev->data[0] = 0;
 	return ret;
 }
 
@@ -1514,7 +1517,6 @@ static void smsc75xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 		cancel_work_sync(&pdata->set_multicast);
 		netif_dbg(dev, ifdown, dev->net, "free pdata\n");
 		kfree(pdata);
-		pdata = NULL;
 		dev->data[0] = 0;
 	}
 }
-- 
2.30.2




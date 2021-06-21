Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8ED53AEFC7
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhFUQl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:41:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233483AbhFUQjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:39:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4234B6143B;
        Mon, 21 Jun 2021 16:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293013;
        bh=AuGAwqgJgeT85QETy3G0wobrKRZDPyUxaYYOJY5VGcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1ZL9wj2EADYLkv8nScblKjr3gFoFjEhfie58+MJYTDL0KqGyqORt0T1XqreXVDRJ
         JX6A++cVXn9n+ju0js7KVmJP6+Xm6HyS7cIJvJJ12TZ7Sjc9W5JzDrUZHCmZ60mfNV
         caPeqvmB/jCww+ZcfGJljhzjQNJTkdEjbfQ3/ztw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 067/178] net: usb: fix possible use-after-free in smsc75xx_bind
Date:   Mon, 21 Jun 2021 18:14:41 +0200
Message-Id: <20210621154924.798191449@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
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
index 76ed79bb1e3f..5281291711af 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1483,7 +1483,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = smsc75xx_wait_ready(dev, 0);
 	if (ret < 0) {
 		netdev_warn(dev->net, "device not ready in smsc75xx_bind\n");
-		goto err;
+		goto free_pdata;
 	}
 
 	smsc75xx_init_mac_address(dev);
@@ -1492,7 +1492,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = smsc75xx_reset(dev);
 	if (ret < 0) {
 		netdev_warn(dev->net, "smsc75xx_reset error %d\n", ret);
-		goto err;
+		goto cancel_work;
 	}
 
 	dev->net->netdev_ops = &smsc75xx_netdev_ops;
@@ -1503,8 +1503,11 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
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
 
@@ -1515,7 +1518,6 @@ static void smsc75xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 		cancel_work_sync(&pdata->set_multicast);
 		netif_dbg(dev, ifdown, dev->net, "free pdata\n");
 		kfree(pdata);
-		pdata = NULL;
 		dev->data[0] = 0;
 	}
 }
-- 
2.30.2




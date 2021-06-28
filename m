Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA1C3B6447
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhF1PGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236105AbhF1PEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:04:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 840EC61CEF;
        Mon, 28 Jun 2021 14:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891398;
        bh=zf+tr+XoxkUPMiEdlXpgM52doBGuoDL8DZH+kXKfwG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8hQYeXqzFVpdo2jpMZN8ilbdWrUoYM7qgrEXfP6/9BqQFCih9YatyjT7vH5OFTsq
         tAq2dDSJgc+4AtVXSyrjOPUKZYaIKfrY+g9oIw1EdyPraLPWgiCHZbkYtGoGrGjQMW
         Ttdipnmi4zq3GjW0RlpFUczr8tgtMsBKSFkL/B2GzVIKACgOjCg8TTne/0RGb7bQrz
         kTyJZsipiX1jjM7XTt3VwN58yUAgYZmfEHRnE4PNz4E3C9sVVNv1BxqOFT8HugcCle
         RDlIATk60EiHQkAXrh6boGhnW9J1n3HlYlUfw0V5F8tbSPrHl7cgE/5RAZIvsS9jlY
         +fRo9sp09vDhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 23/57] net: usb: fix possible use-after-free in smsc75xx_bind
Date:   Mon, 28 Jun 2021 10:42:22 -0400
Message-Id: <20210628144256.34524-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index 850bb147f4b0..9fe6a8d899b0 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1485,7 +1485,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = smsc75xx_wait_ready(dev, 0);
 	if (ret < 0) {
 		netdev_warn(dev->net, "device not ready in smsc75xx_bind\n");
-		goto err;
+		goto free_pdata;
 	}
 
 	smsc75xx_init_mac_address(dev);
@@ -1494,7 +1494,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = smsc75xx_reset(dev);
 	if (ret < 0) {
 		netdev_warn(dev->net, "smsc75xx_reset error %d\n", ret);
-		goto err;
+		goto cancel_work;
 	}
 
 	dev->net->netdev_ops = &smsc75xx_netdev_ops;
@@ -1504,8 +1504,11 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
 	return 0;
 
-err:
+cancel_work:
+	cancel_work_sync(&pdata->set_multicast);
+free_pdata:
 	kfree(pdata);
+	dev->data[0] = 0;
 	return ret;
 }
 
@@ -1516,7 +1519,6 @@ static void smsc75xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 		cancel_work_sync(&pdata->set_multicast);
 		netif_dbg(dev, ifdown, dev->net, "free pdata\n");
 		kfree(pdata);
-		pdata = NULL;
 		dev->data[0] = 0;
 	}
 }
-- 
2.30.2


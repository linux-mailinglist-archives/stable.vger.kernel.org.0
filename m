Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D873B63C9
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbhF1PAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235231AbhF1O62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:58:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0652B61D4E;
        Mon, 28 Jun 2021 14:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891230;
        bh=xFNH0CVNytzv1ZfBLYbFdaBnFQ1ubvpQGExjJ3IN2qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJRryEYBM2vNw/U0qZzwZXvrI5gwgpNCe1OeWlH0nsilH1h/+yolcvmWmGcdZk++t
         1EyTpdT2SiukKjnAlq6yqsV05K1YVLrARCMGLvme2bgSCSDHgEEb21MA/cM7+r5avn
         ymRVED/EgybNGa2s/Uqu8RS9lWulgpyIQfDFHUNrk4rvILZ1GHaCsWRc1OeQodOQ9d
         6oqElYtgobHXlk0FDrMVK1KlSPWZOkwFZ56lIt2NFwqzC4fiaam2zRim+HaCxgt5mp
         dhtqttOpaY6y7endv2PAKPfN1Hl8YQbV4SuqKDKISNhwZDrpOuNyOyMBn2X5DEQGZy
         gfVhuuPEhCeWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 29/71] net: usb: fix possible use-after-free in smsc75xx_bind
Date:   Mon, 28 Jun 2021 10:39:21 -0400
Message-Id: <20210628144003.34260-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
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
index 3a391ae5c4e0..841d97491592 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1497,7 +1497,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = smsc75xx_wait_ready(dev, 0);
 	if (ret < 0) {
 		netdev_warn(dev->net, "device not ready in smsc75xx_bind\n");
-		goto err;
+		goto free_pdata;
 	}
 
 	smsc75xx_init_mac_address(dev);
@@ -1506,7 +1506,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = smsc75xx_reset(dev);
 	if (ret < 0) {
 		netdev_warn(dev->net, "smsc75xx_reset error %d\n", ret);
-		goto err;
+		goto cancel_work;
 	}
 
 	dev->net->netdev_ops = &smsc75xx_netdev_ops;
@@ -1516,8 +1516,11 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
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
 
@@ -1528,7 +1531,6 @@ static void smsc75xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 		cancel_work_sync(&pdata->set_multicast);
 		netif_dbg(dev, ifdown, dev->net, "free pdata\n");
 		kfree(pdata);
-		pdata = NULL;
 		dev->data[0] = 0;
 	}
 }
-- 
2.30.2


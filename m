Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCD56C710
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390105AbfGRDJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:09:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390371AbfGRDJU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:09:20 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBEF020818;
        Thu, 18 Jul 2019 03:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419359;
        bh=vz917OUL0hDd8WSGqcb8O1NaNqgvA/64a88o3nUp1AQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0OElJCB1rPgDr4jU3k4IQ83fGfLxNkqf3QMDmvF9Yd6JNERCxRcfnuu4Un4q53YQ
         xO/cP/OmYe/IiwmVZ8CxxmKMoad5qh7Zj8XlFu3EZVNpTiwmRneb0nWofoFEK2S7li
         EKz6wGhD7EaQkQyE32BMt+bZsvUw1flsRaDA6R/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Reinhard Speyerer <rspmn@arcor.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 30/80] qmi_wwan: avoid RCU stalls on device disconnect when in QMAP mode
Date:   Thu, 18 Jul 2019 12:01:21 +0900
Message-Id: <20190718030101.043700384@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a8fdde1cb830e560208af42b6c10750137f53eb3 ]

Switch qmimux_unregister_device() and qmi_wwan_disconnect() to
use unregister_netdevice_queue() and unregister_netdevice_many()
instead of unregister_netdevice(). This avoids RCU stalls which
have been observed on device disconnect in certain setups otherwise.

Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
Cc: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 75fe5c5abec4..76c4afac71f7 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -247,13 +247,14 @@ static int qmimux_register_device(struct net_device *real_dev, u8 mux_id)
 	return err;
 }
 
-static void qmimux_unregister_device(struct net_device *dev)
+static void qmimux_unregister_device(struct net_device *dev,
+				     struct list_head *head)
 {
 	struct qmimux_priv *priv = netdev_priv(dev);
 	struct net_device *real_dev = priv->real_dev;
 
 	netdev_upper_dev_unlink(real_dev, dev);
-	unregister_netdevice(dev);
+	unregister_netdevice_queue(dev, head);
 
 	/* Get rid of the reference to real_dev */
 	dev_put(real_dev);
@@ -424,7 +425,7 @@ static ssize_t del_mux_store(struct device *d,  struct device_attribute *attr, c
 		ret = -EINVAL;
 		goto err;
 	}
-	qmimux_unregister_device(del_dev);
+	qmimux_unregister_device(del_dev, NULL);
 
 	if (!qmimux_has_slaves(dev))
 		info->flags &= ~QMI_WWAN_FLAG_MUX;
@@ -1423,6 +1424,7 @@ static void qmi_wwan_disconnect(struct usb_interface *intf)
 	struct qmi_wwan_state *info;
 	struct list_head *iter;
 	struct net_device *ldev;
+	LIST_HEAD(list);
 
 	/* called twice if separate control and data intf */
 	if (!dev)
@@ -1435,8 +1437,9 @@ static void qmi_wwan_disconnect(struct usb_interface *intf)
 		}
 		rcu_read_lock();
 		netdev_for_each_upper_dev_rcu(dev->net, ldev, iter)
-			qmimux_unregister_device(ldev);
+			qmimux_unregister_device(ldev, &list);
 		rcu_read_unlock();
+		unregister_netdevice_many(&list);
 		rtnl_unlock();
 		info->flags &= ~QMI_WWAN_FLAG_MUX;
 	}
-- 
2.20.1




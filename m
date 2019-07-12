Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A3666C99
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfGLMVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727627AbfGLMVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:21:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE5DF20863;
        Fri, 12 Jul 2019 12:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934098;
        bh=VsZms4Ebu41p9h8mUbbIv4O/kyaymEWAYms16wI9iH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+VT5OGJUmPX7DvTXe9alYqGFSpl6/btBkEj4rCM2kIwOuL2MZgwuK7orDi3C/yLH
         btIcEzZ50W2+AzmOEXJFCzWTDOlCgWqx5vBpf+E2b9WbnUJ8jgEhtOuk0NARt7VAvW
         lSqjQSjgZxNN1CMQ1RKT/06ZnHFGriGDpffOQfWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Reinhard Speyerer <rspmn@arcor.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/91] qmi_wwan: avoid RCU stalls on device disconnect when in QMAP mode
Date:   Fri, 12 Jul 2019 14:18:46 +0200
Message-Id: <20190712121623.814315766@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
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
index 090227118d3d..44ada5c38756 100644
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
@@ -1434,6 +1435,7 @@ static void qmi_wwan_disconnect(struct usb_interface *intf)
 	struct qmi_wwan_state *info;
 	struct list_head *iter;
 	struct net_device *ldev;
+	LIST_HEAD(list);
 
 	/* called twice if separate control and data intf */
 	if (!dev)
@@ -1446,8 +1448,9 @@ static void qmi_wwan_disconnect(struct usb_interface *intf)
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




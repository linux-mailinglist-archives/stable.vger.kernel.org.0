Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 326425CBAD
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfGBIPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:15:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727869AbfGBIFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:05:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F20AB2184B;
        Tue,  2 Jul 2019 08:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054706;
        bh=H3AGDmzp0Zp1pSbvJRNNH0Kcv9iuWLBCIvSBDtcO4X0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s2pUQHdh1ZN1IqY0M6/TEKr/J1tdlpg5tplyg6LXSBMYDC37lzwGUNAq4+na1dweT
         rKIuHx5NXqK+LcUjKDxTdqYL1oCCj+XFyBc6+/9zbkFE4lu0cd2lUktxNaL95Kw7RY
         K8vmDa8HyF73aWlwDkSgfpzUl90zW8GCDgrl+Ops=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fei Li <lifei.shirley@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 42/55] tun: wake up waitqueues after IFF_UP is set
Date:   Tue,  2 Jul 2019 10:01:50 +0200
Message-Id: <20190702080126.295927263@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fei Li <lifei.shirley@bytedance.com>

[ Upstream commit 72b319dc08b4924a29f5e2560ef6d966fa54c429 ]

Currently after setting tap0 link up, the tun code wakes tx/rx waited
queues up in tun_net_open() when .ndo_open() is called, however the
IFF_UP flag has not been set yet. If there's already a wait queue, it
would fail to transmit when checking the IFF_UP flag in tun_sendmsg().
Then the saving vhost_poll_start() will add the wq into wqh until it
is waken up again. Although this works when IFF_UP flag has been set
when tun_chr_poll detects; this is not true if IFF_UP flag has not
been set at that time. Sadly the latter case is a fatal error, as
the wq will never be waken up in future unless later manually
setting link up on purpose.

Fix this by moving the wakeup process into the NETDEV_UP event
notifying process, this makes sure IFF_UP has been set before all
waited queues been waken up.

Signed-off-by: Fei Li <lifei.shirley@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1024,18 +1024,8 @@ static void tun_net_uninit(struct net_de
 /* Net device open. */
 static int tun_net_open(struct net_device *dev)
 {
-	struct tun_struct *tun = netdev_priv(dev);
-	int i;
-
 	netif_tx_start_all_queues(dev);
 
-	for (i = 0; i < tun->numqueues; i++) {
-		struct tun_file *tfile;
-
-		tfile = rtnl_dereference(tun->tfiles[i]);
-		tfile->socket.sk->sk_write_space(tfile->socket.sk);
-	}
-
 	return 0;
 }
 
@@ -3636,6 +3626,7 @@ static int tun_device_event(struct notif
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct tun_struct *tun = netdev_priv(dev);
+	int i;
 
 	if (dev->rtnl_link_ops != &tun_link_ops)
 		return NOTIFY_DONE;
@@ -3645,6 +3636,14 @@ static int tun_device_event(struct notif
 		if (tun_queue_resize(tun))
 			return NOTIFY_BAD;
 		break;
+	case NETDEV_UP:
+		for (i = 0; i < tun->numqueues; i++) {
+			struct tun_file *tfile;
+
+			tfile = rtnl_dereference(tun->tfiles[i]);
+			tfile->socket.sk->sk_write_space(tfile->socket.sk);
+		}
+		break;
 	default:
 		break;
 	}



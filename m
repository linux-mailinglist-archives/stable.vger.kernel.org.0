Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CA832E8E4
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhCEM3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:29:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:38224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232068AbhCEM3E (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:29:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CA8B65013;
        Fri,  5 Mar 2021 12:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947344;
        bh=1y6AMsKhd7aCYXP8Wlhw2leWXLiWU5UGgVGImqp8jtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPMe9QzTaZQQBIRnvlh9NG6/bvoA2Sp7N10IzEW8cotKUwI8mcb9FZ+4pHyap6l9x
         fNPJ2mkCQebcHTCyY7BSVNADL87PUcerGCVxmfTSh4hPpLz1xRFGamsOTnIH1gnNrS
         ilnQEBfXQ8sjH56VjoS6Ey7i1FE6m14YjmwYKeM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Gong, Sishuai" <sishuai@purdue.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 031/102] net: fix dev_ifsioc_locked() race condition
Date:   Fri,  5 Mar 2021 13:20:50 +0100
Message-Id: <20210305120904.814003997@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

commit 3b23a32a63219f51a5298bc55a65ecee866e79d0 upstream.

dev_ifsioc_locked() is called with only RCU read lock, so when
there is a parallel writer changing the mac address, it could
get a partially updated mac address, as shown below:

Thread 1			Thread 2
// eth_commit_mac_addr_change()
memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
				// dev_ifsioc_locked()
				memcpy(ifr->ifr_hwaddr.sa_data,
					dev->dev_addr,...);

Close this race condition by guarding them with a RW semaphore,
like netdev_get_name(). We can not use seqlock here as it does not
allow blocking. The writers already take RTNL anyway, so this does
not affect the slow path. To avoid bothering existing
dev_set_mac_address() callers in drivers, introduce a new wrapper
just for user-facing callers on ioctl and rtnetlink paths.

Note, bonding also changes slave mac addresses but that requires
a separate patch due to the complexity of bonding code.

Fixes: 3710becf8a58 ("net: RCU locking for simple ioctl()")
Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tap.c         |    7 +++----
 drivers/net/tun.c         |    5 ++---
 include/linux/netdevice.h |    3 +++
 net/core/dev.c            |   42 ++++++++++++++++++++++++++++++++++++++++++
 net/core/dev_ioctl.c      |   20 +++++++-------------
 net/core/rtnetlink.c      |    2 +-
 6 files changed, 58 insertions(+), 21 deletions(-)

--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1093,10 +1093,9 @@ static long tap_ioctl(struct file *file,
 			return -ENOLINK;
 		}
 		ret = 0;
-		u = tap->dev->type;
+		dev_get_mac_address(&sa, dev_net(tap->dev), tap->dev->name);
 		if (copy_to_user(&ifr->ifr_name, tap->dev->name, IFNAMSIZ) ||
-		    copy_to_user(&ifr->ifr_hwaddr.sa_data, tap->dev->dev_addr, ETH_ALEN) ||
-		    put_user(u, &ifr->ifr_hwaddr.sa_family))
+		    copy_to_user(&ifr->ifr_hwaddr, &sa, sizeof(sa)))
 			ret = -EFAULT;
 		tap_put_tap_dev(tap);
 		rtnl_unlock();
@@ -1111,7 +1110,7 @@ static long tap_ioctl(struct file *file,
 			rtnl_unlock();
 			return -ENOLINK;
 		}
-		ret = dev_set_mac_address(tap->dev, &sa, NULL);
+		ret = dev_set_mac_address_user(tap->dev, &sa, NULL);
 		tap_put_tap_dev(tap);
 		rtnl_unlock();
 		return ret;
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3157,15 +3157,14 @@ static long __tun_chr_ioctl(struct file
 
 	case SIOCGIFHWADDR:
 		/* Get hw address */
-		memcpy(ifr.ifr_hwaddr.sa_data, tun->dev->dev_addr, ETH_ALEN);
-		ifr.ifr_hwaddr.sa_family = tun->dev->type;
+		dev_get_mac_address(&ifr.ifr_hwaddr, net, tun->dev->name);
 		if (copy_to_user(argp, &ifr, ifreq_len))
 			ret = -EFAULT;
 		break;
 
 	case SIOCSIFHWADDR:
 		/* Set hw address */
-		ret = dev_set_mac_address(tun->dev, &ifr.ifr_hwaddr, NULL);
+		ret = dev_set_mac_address_user(tun->dev, &ifr.ifr_hwaddr, NULL);
 		break;
 
 	case TUNGETSNDBUF:
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3879,6 +3879,9 @@ int dev_pre_changeaddr_notify(struct net
 			      struct netlink_ext_ack *extack);
 int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
 			struct netlink_ext_ack *extack);
+int dev_set_mac_address_user(struct net_device *dev, struct sockaddr *sa,
+			     struct netlink_ext_ack *extack);
+int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_name);
 int dev_change_carrier(struct net_device *, bool new_carrier);
 int dev_get_phys_port_id(struct net_device *dev,
 			 struct netdev_phys_item_id *ppid);
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8686,6 +8686,48 @@ int dev_set_mac_address(struct net_devic
 }
 EXPORT_SYMBOL(dev_set_mac_address);
 
+static DECLARE_RWSEM(dev_addr_sem);
+
+int dev_set_mac_address_user(struct net_device *dev, struct sockaddr *sa,
+			     struct netlink_ext_ack *extack)
+{
+	int ret;
+
+	down_write(&dev_addr_sem);
+	ret = dev_set_mac_address(dev, sa, extack);
+	up_write(&dev_addr_sem);
+	return ret;
+}
+EXPORT_SYMBOL(dev_set_mac_address_user);
+
+int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_name)
+{
+	size_t size = sizeof(sa->sa_data);
+	struct net_device *dev;
+	int ret = 0;
+
+	down_read(&dev_addr_sem);
+	rcu_read_lock();
+
+	dev = dev_get_by_name_rcu(net, dev_name);
+	if (!dev) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+	if (!dev->addr_len)
+		memset(sa->sa_data, 0, size);
+	else
+		memcpy(sa->sa_data, dev->dev_addr,
+		       min_t(size_t, size, dev->addr_len));
+	sa->sa_family = dev->type;
+
+unlock:
+	rcu_read_unlock();
+	up_read(&dev_addr_sem);
+	return ret;
+}
+EXPORT_SYMBOL(dev_get_mac_address);
+
 /**
  *	dev_change_carrier - Change device carrier
  *	@dev: device
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -123,17 +123,6 @@ static int dev_ifsioc_locked(struct net
 		ifr->ifr_mtu = dev->mtu;
 		return 0;
 
-	case SIOCGIFHWADDR:
-		if (!dev->addr_len)
-			memset(ifr->ifr_hwaddr.sa_data, 0,
-			       sizeof(ifr->ifr_hwaddr.sa_data));
-		else
-			memcpy(ifr->ifr_hwaddr.sa_data, dev->dev_addr,
-			       min(sizeof(ifr->ifr_hwaddr.sa_data),
-				   (size_t)dev->addr_len));
-		ifr->ifr_hwaddr.sa_family = dev->type;
-		return 0;
-
 	case SIOCGIFSLAVE:
 		err = -EINVAL;
 		break;
@@ -274,7 +263,7 @@ static int dev_ifsioc(struct net *net, s
 	case SIOCSIFHWADDR:
 		if (dev->addr_len > sizeof(struct sockaddr))
 			return -EINVAL;
-		return dev_set_mac_address(dev, &ifr->ifr_hwaddr, NULL);
+		return dev_set_mac_address_user(dev, &ifr->ifr_hwaddr, NULL);
 
 	case SIOCSIFHWBROADCAST:
 		if (ifr->ifr_hwaddr.sa_family != dev->type)
@@ -418,6 +407,12 @@ int dev_ioctl(struct net *net, unsigned
 	 */
 
 	switch (cmd) {
+	case SIOCGIFHWADDR:
+		dev_load(net, ifr->ifr_name);
+		ret = dev_get_mac_address(&ifr->ifr_hwaddr, net, ifr->ifr_name);
+		if (colon)
+			*colon = ':';
+		return ret;
 	/*
 	 *	These ioctl calls:
 	 *	- can be done by all.
@@ -427,7 +422,6 @@ int dev_ioctl(struct net *net, unsigned
 	case SIOCGIFFLAGS:
 	case SIOCGIFMETRIC:
 	case SIOCGIFMTU:
-	case SIOCGIFHWADDR:
 	case SIOCGIFSLAVE:
 	case SIOCGIFMAP:
 	case SIOCGIFINDEX:
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2658,7 +2658,7 @@ static int do_setlink(const struct sk_bu
 		sa->sa_family = dev->type;
 		memcpy(sa->sa_data, nla_data(tb[IFLA_ADDRESS]),
 		       dev->addr_len);
-		err = dev_set_mac_address(dev, sa, extack);
+		err = dev_set_mac_address_user(dev, sa, extack);
 		kfree(sa);
 		if (err)
 			goto errout;



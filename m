Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3FF5EA65F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236449AbiIZMnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236558AbiIZMmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:42:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC4911ADC8;
        Mon, 26 Sep 2022 04:19:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23B9460A5C;
        Mon, 26 Sep 2022 10:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326B6C433C1;
        Mon, 26 Sep 2022 10:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188288;
        bh=MSz5lceXVQTEFtNohFJnNhGsGvuO8syg31KTrCCdvHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2nn3ICuqON3PbF1bvyqu3rtxP7aR39x/oJsJQR2UZDHx1m1qZVbzKX6mZzChNekV/
         azJl0ZuorR043KJn+lcSXXM9zho8HfdX8Met73x2u8rida6qDDQZHo8ijVLLQKlY/N
         Zu1mOy2p6igW47KSMrWhngS/bJ0c41j4iu6qwHnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/141] net: socket: remove register_gifconf
Date:   Mon, 26 Sep 2022 12:12:08 +0200
Message-Id: <20220926100758.113771921@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b0e99d03778b2418aec20db99d97d19d25d198b6 ]

Since dynamic registration of the gifconf() helper is only used for
IPv4, and this can not be in a loadable module, this can be simplified
noticeably by turning it into a direct function call as a preparation
for cleaning up the compat handling.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5641c751fe2f ("net: enetc: deny offload of tc-based TSN features on VF interfaces")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/inetdevice.h |  9 ++++++++
 include/linux/netdevice.h  |  8 -------
 net/core/dev_ioctl.c       | 43 +++++++++-----------------------------
 net/ipv4/devinet.c         |  4 +---
 4 files changed, 20 insertions(+), 44 deletions(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index b68fca08be27..3088d94684c1 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -178,6 +178,15 @@ static inline struct net_device *ip_dev_find(struct net *net, __be32 addr)
 
 int inet_addr_onlink(struct in_device *in_dev, __be32 a, __be32 b);
 int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *);
+#ifdef CONFIG_INET
+int inet_gifconf(struct net_device *dev, char __user *buf, int len, int size);
+#else
+static inline int inet_gifconf(struct net_device *dev, char __user *buf,
+			       int len, int size)
+{
+	return 0;
+}
+#endif
 void devinet_init(void);
 struct in_device *inetdev_by_index(struct net *, int);
 __be32 inet_select_addr(const struct net_device *dev, __be32 dst, int scope);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6564fb4ac49e..ef75567efd27 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3201,14 +3201,6 @@ static inline bool dev_has_header(const struct net_device *dev)
 	return dev->header_ops && dev->header_ops->create;
 }
 
-typedef int gifconf_func_t(struct net_device * dev, char __user * bufptr,
-			   int len, int size);
-int register_gifconf(unsigned int family, gifconf_func_t *gifconf);
-static inline int unregister_gifconf(unsigned int family)
-{
-	return register_gifconf(family, NULL);
-}
-
 #ifdef CONFIG_NET_FLOW_LIMIT
 #define FLOW_LIMIT_HISTORY	(1 << 7)  /* must be ^2 and !overflow buckets */
 struct sd_flow_limit {
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 54fb18b4f55e..48afea19d3e1 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/kmod.h>
 #include <linux/netdevice.h>
+#include <linux/inetdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/net_tstamp.h>
@@ -25,26 +26,6 @@ static int dev_ifname(struct net *net, struct ifreq *ifr)
 	return netdev_get_name(net, ifr->ifr_name, ifr->ifr_ifindex);
 }
 
-static gifconf_func_t *gifconf_list[NPROTO];
-
-/**
- *	register_gifconf	-	register a SIOCGIF handler
- *	@family: Address family
- *	@gifconf: Function handler
- *
- *	Register protocol dependent address dumping routines. The handler
- *	that is passed must not be freed or reused until it has been replaced
- *	by another handler.
- */
-int register_gifconf(unsigned int family, gifconf_func_t *gifconf)
-{
-	if (family >= NPROTO)
-		return -EINVAL;
-	gifconf_list[family] = gifconf;
-	return 0;
-}
-EXPORT_SYMBOL(register_gifconf);
-
 /*
  *	Perform a SIOCGIFCONF call. This structure will change
  *	size eventually, and there is nothing I can do about it.
@@ -72,19 +53,15 @@ int dev_ifconf(struct net *net, struct ifconf *ifc, int size)
 
 	total = 0;
 	for_each_netdev(net, dev) {
-		for (i = 0; i < NPROTO; i++) {
-			if (gifconf_list[i]) {
-				int done;
-				if (!pos)
-					done = gifconf_list[i](dev, NULL, 0, size);
-				else
-					done = gifconf_list[i](dev, pos + total,
-							       len - total, size);
-				if (done < 0)
-					return -EFAULT;
-				total += done;
-			}
-		}
+		int done;
+		if (!pos)
+			done = inet_gifconf(dev, NULL, 0, size);
+		else
+			done = inet_gifconf(dev, pos + total,
+					    len - total, size);
+		if (done < 0)
+			return -EFAULT;
+		total += done;
 	}
 
 	/*
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 8f1753875550..88b6120878cd 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1244,7 +1244,7 @@ int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr)
 	return ret;
 }
 
-static int inet_gifconf(struct net_device *dev, char __user *buf, int len, int size)
+int inet_gifconf(struct net_device *dev, char __user *buf, int len, int size)
 {
 	struct in_device *in_dev = __in_dev_get_rtnl(dev);
 	const struct in_ifaddr *ifa;
@@ -2766,8 +2766,6 @@ void __init devinet_init(void)
 		INIT_HLIST_HEAD(&inet_addr_lst[i]);
 
 	register_pernet_subsys(&devinet_ops);
-
-	register_gifconf(PF_INET, inet_gifconf);
 	register_netdevice_notifier(&ip_netdev_notifier);
 
 	queue_delayed_work(system_power_efficient_wq, &check_lifetime_work, 0);
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D1F2870A
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389050AbfEWTPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:15:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389043AbfEWTPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:15:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63103217D7;
        Thu, 23 May 2019 19:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638940;
        bh=Jm4gOeMZDy0CWa0ohmtarmH9iyQ6p78f9xr7urk7Y3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aAIfyRIXppct2aF0c9jRpgiY+1071rvGThtQOi0leYNEiOKVGkTzQ+DVQ+229mtLv
         ewZwQSNN9PHTbUCnYm5/vtngYx96oUS8IM8OJTTiRqDtyZoTQcbLmxz8so4eX7Qk38
         flQTH+jyOc7UFOTQoIUJnEPsrvJfeXaeSAmhUOwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Winship <danw@redhat.com>
Subject: [PATCH 4.19 010/114] rtnetlink: always put IFLA_LINK for links with a link-netnsid
Date:   Thu, 23 May 2019 21:05:09 +0200
Message-Id: <20190523181732.551694485@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit feadc4b6cf42a53a8a93c918a569a0b7e62bd350 ]

Currently, nla_put_iflink() doesn't put the IFLA_LINK attribute when
iflink == ifindex.

In some cases, a device can be created in a different netns with the
same ifindex as its parent. That device will not dump its IFLA_LINK
attribute, which can confuse some userspace software that expects it.
For example, if the last ifindex created in init_net and foo are both
8, these commands will trigger the issue:

    ip link add parent type dummy                   # ifindex 9
    ip link add link parent netns foo type macvlan  # ifindex 9 in ns foo

So, in case a device puts the IFLA_LINK_NETNSID attribute in a dump,
always put the IFLA_LINK attribute as well.

Thanks to Dan Winship for analyzing the original OpenShift bug down to
the missing netlink attribute.

v2: change Fixes tag, it's been here forever, as Nicolas Dichtel said
    add Nicolas' ack
v3: change Fixes tag
    fix subject typo, spotted by Edward Cree

Analyzed-by: Dan Winship <danw@redhat.com>
Fixes: d8a5ec672768 ("[NET]: netlink support for moving devices between network namespaces.")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1496,14 +1496,15 @@ static int put_master_ifindex(struct sk_
 	return ret;
 }
 
-static int nla_put_iflink(struct sk_buff *skb, const struct net_device *dev)
+static int nla_put_iflink(struct sk_buff *skb, const struct net_device *dev,
+			  bool force)
 {
 	int ifindex = dev_get_iflink(dev);
 
-	if (dev->ifindex == ifindex)
-		return 0;
+	if (force || dev->ifindex != ifindex)
+		return nla_put_u32(skb, IFLA_LINK, ifindex);
 
-	return nla_put_u32(skb, IFLA_LINK, ifindex);
+	return 0;
 }
 
 static noinline_for_stack int nla_put_ifalias(struct sk_buff *skb,
@@ -1520,6 +1521,8 @@ static int rtnl_fill_link_netnsid(struct
 				  const struct net_device *dev,
 				  struct net *src_net)
 {
+	bool put_iflink = false;
+
 	if (dev->rtnl_link_ops && dev->rtnl_link_ops->get_link_net) {
 		struct net *link_net = dev->rtnl_link_ops->get_link_net(dev);
 
@@ -1528,10 +1531,12 @@ static int rtnl_fill_link_netnsid(struct
 
 			if (nla_put_s32(skb, IFLA_LINK_NETNSID, id))
 				return -EMSGSIZE;
+
+			put_iflink = true;
 		}
 	}
 
-	return 0;
+	return nla_put_iflink(skb, dev, put_iflink);
 }
 
 static int rtnl_fill_link_af(struct sk_buff *skb,
@@ -1617,7 +1622,6 @@ static int rtnl_fill_ifinfo(struct sk_bu
 #ifdef CONFIG_RPS
 	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
 #endif
-	    nla_put_iflink(skb, dev) ||
 	    put_master_ifindex(skb, dev) ||
 	    nla_put_u8(skb, IFLA_CARRIER, netif_carrier_ok(dev)) ||
 	    (dev->qdisc &&



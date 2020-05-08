Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A631CAF39
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgEHNQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729297AbgEHMp0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5E6B21473;
        Fri,  8 May 2020 12:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941925;
        bh=Hfd/mLI5kpgrtwJPD1FVPGFVF+YLlvb6FT9f59xKZ4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFWUEksmEgDMjqN3vyZVCWqK6qRMT4Ce9PyA8N/tFIUYgHDFNNiXcId02Z3vAavQs
         ppN6BoJSMfIQvKr/vjA/2ZLBJdaNzn23sn4glTtfjghbmSDh8Ql8f1NRC/11HE6qh3
         PchOPh83uVIUI3Vjipc+ZuUlSw4D2OSrTsZyFeTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 190/312] ipv4: do not abuse GFP_ATOMIC in inet_netconf_notify_devconf()
Date:   Fri,  8 May 2020 14:33:01 +0200
Message-Id: <20200508123137.827396603@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit fa17806cde76fb1087532f07e72aa757a30e0500 upstream.

inet_forward_change() runs with RTNL held.
We are allowed to sleep if required.

If we use __in_dev_get_rtnl() instead of __in_dev_get_rcu(),
we no longer have to use GFP_ATOMIC allocations in
inet_netconf_notify_devconf(), meaning we are less likely to miss
notifications under memory pressure, and wont touch precious memory
reserves either and risk dropping incoming packets.

inet_netconf_get_devconf() can also use GFP_KERNEL allocation.

Fixes: edc9e748934c ("rtnl/ipv4: use netconf msg to advertise forwarding status")
Fixes: 9e5511106f99 ("rtnl/ipv4: add support of RTM_GETNETCONF")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/devinet.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1814,7 +1814,7 @@ void inet_netconf_notify_devconf(struct
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 
-	skb = nlmsg_new(inet_netconf_msgsize_devconf(type), GFP_ATOMIC);
+	skb = nlmsg_new(inet_netconf_msgsize_devconf(type), GFP_KERNEL);
 	if (!skb)
 		goto errout;
 
@@ -1826,7 +1826,7 @@ void inet_netconf_notify_devconf(struct
 		kfree_skb(skb);
 		goto errout;
 	}
-	rtnl_notify(skb, net, 0, RTNLGRP_IPV4_NETCONF, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_IPV4_NETCONF, NULL, GFP_KERNEL);
 	return;
 errout:
 	if (err < 0)
@@ -1883,7 +1883,7 @@ static int inet_netconf_get_devconf(stru
 	}
 
 	err = -ENOBUFS;
-	skb = nlmsg_new(inet_netconf_msgsize_devconf(-1), GFP_ATOMIC);
+	skb = nlmsg_new(inet_netconf_msgsize_devconf(-1), GFP_KERNEL);
 	if (!skb)
 		goto errout;
 
@@ -2007,16 +2007,16 @@ static void inet_forward_change(struct n
 
 	for_each_netdev(net, dev) {
 		struct in_device *in_dev;
+
 		if (on)
 			dev_disable_lro(dev);
-		rcu_read_lock();
-		in_dev = __in_dev_get_rcu(dev);
+
+		in_dev = __in_dev_get_rtnl(dev);
 		if (in_dev) {
 			IN_DEV_CONF_SET(in_dev, FORWARDING, on);
 			inet_netconf_notify_devconf(net, NETCONFA_FORWARDING,
 						    dev->ifindex, &in_dev->cnf);
 		}
-		rcu_read_unlock();
 	}
 }
 



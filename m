Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E842188217
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgCQLWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgCQK50 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:57:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41EC220724;
        Tue, 17 Mar 2020 10:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442645;
        bh=nXgozMkuLoOhBNTl0mDmZ/R/xVKVI29dOWMN34GolFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QlgOU+2giftc/wOgWlwV1HI6/vLmkqESXDIXSYQzjrq5eq3DYU8Pa3/oXY2nN+Lvn
         qbJt5mFKbDknLXd7gcSS0EHjMpQzyMbTKBbk6DDdkKY7X3fH7rkoRmoQwrnS2Di4Lu
         ZNCVNW3OLAn0nicB8Ja3U+IzPFgWgt7Z6R9O82NI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Per Sundstrom <per.sundstrom@redqube.se>,
        Jiri Wiesner <jwiesner@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 08/89] ipvlan: do not add hardware address of master to its unicast filter list
Date:   Tue, 17 Mar 2020 11:54:17 +0100
Message-Id: <20200317103300.806460880@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Wiesner <jwiesner@suse.com>

[ Upstream commit 63aae7b17344d4b08a7d05cb07044de4c0f9dcc6 ]

There is a problem when ipvlan slaves are created on a master device that
is a vmxnet3 device (ipvlan in VMware guests). The vmxnet3 driver does not
support unicast address filtering. When an ipvlan device is brought up in
ipvlan_open(), the ipvlan driver calls dev_uc_add() to add the hardware
address of the vmxnet3 master device to the unicast address list of the
master device, phy_dev->uc. This inevitably leads to the vmxnet3 master
device being forced into promiscuous mode by __dev_set_rx_mode().

Promiscuous mode is switched on the master despite the fact that there is
still only one hardware address that the master device should use for
filtering in order for the ipvlan device to be able to receive packets.
The comment above struct net_device describes the uc_promisc member as a
"counter, that indicates, that promiscuous mode has been enabled due to
the need to listen to additional unicast addresses in a device that does
not implement ndo_set_rx_mode()". Moreover, the design of ipvlan
guarantees that only the hardware address of a master device,
phy_dev->dev_addr, will be used to transmit and receive all packets from
its ipvlan slaves. Thus, the unicast address list of the master device
should not be modified by ipvlan_open() and ipvlan_stop() in order to make
ipvlan a workable option on masters that do not support unicast address
filtering.

Fixes: 2ad7bf3638411 ("ipvlan: Initial check-in of the IPVLAN driver")
Reported-by: Per Sundstrom <per.sundstrom@redqube.se>
Signed-off-by: Jiri Wiesner <jwiesner@suse.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Mahesh Bandewar <maheshb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipvlan/ipvlan_main.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -236,7 +236,6 @@ static void ipvlan_uninit(struct net_dev
 static int ipvlan_open(struct net_device *dev)
 {
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
-	struct net_device *phy_dev = ipvlan->phy_dev;
 	struct ipvl_addr *addr;
 
 	if (ipvlan->port->mode == IPVLAN_MODE_L3 ||
@@ -250,7 +249,7 @@ static int ipvlan_open(struct net_device
 		ipvlan_ht_addr_add(ipvlan, addr);
 	rcu_read_unlock();
 
-	return dev_uc_add(phy_dev, phy_dev->dev_addr);
+	return 0;
 }
 
 static int ipvlan_stop(struct net_device *dev)
@@ -262,8 +261,6 @@ static int ipvlan_stop(struct net_device
 	dev_uc_unsync(phy_dev, dev);
 	dev_mc_unsync(phy_dev, dev);
 
-	dev_uc_del(phy_dev, phy_dev->dev_addr);
-
 	rcu_read_lock();
 	list_for_each_entry_rcu(addr, &ipvlan->addrs, anode)
 		ipvlan_ht_addr_del(addr);



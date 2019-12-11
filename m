Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5614311B551
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbfLKPTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:19:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:48572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732246AbfLKPTk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:19:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3340222B48;
        Wed, 11 Dec 2019 15:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077579;
        bh=7i9ksTu/DhjStWJOKf1zSq33TaG1Wy+wzykXut1WSV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ef5tPJqmTBk7AJhpdzl6eUOPGwaXabzljlGiVRyIdPSY2BRzaS/uRcUG8XOckhKMK
         4Fb7+Rk3CdDB6hGUdaetDdTGue69kimMk59Zz4GyeBAidkQj6szhfD1IZwMLJtDWqu
         IE1VkVJo1zIutKDPt5v04Dfpr7vAqWIT0te54zWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianlin Shi <jishi@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 092/243] net/ipv6: re-do dad when interface has IFF_NOARP flag change
Date:   Wed, 11 Dec 2019 16:04:14 +0100
Message-Id: <20191211150345.328740299@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 896585d48e8e9ba44cd1754fbce8537feffcc1a5 ]

When we add a new IPv6 address, we should also join corresponding solicited-node
multicast address, unless the interface has IFF_NOARP flag, as function
addrconf_join_solict() did. But if we remove IFF_NOARP flag later, we do
not do dad and add the mcast address. So we will drop corresponding neighbour
discovery message that came from other nodes.

A typical example is after creating a ipvlan with mode l3, setting up an ipv6
address and changing the mode to l2. Then we will not be able to ping this
address as the interface doesn't join related solicited-node mcast address.

Fix it by re-doing dad when interface changed IFF_NOARP flag. Then we will add
corresponding mcast group and check if there is a duplicate address on the
network.

Reported-by: Jianlin Shi <jishi@redhat.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index d2968a79abea8..ef309a26aba0f 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -179,7 +179,7 @@ static void addrconf_dad_start(struct inet6_ifaddr *ifp);
 static void addrconf_dad_work(struct work_struct *w);
 static void addrconf_dad_completed(struct inet6_ifaddr *ifp, bool bump_id,
 				   bool send_na);
-static void addrconf_dad_run(struct inet6_dev *idev);
+static void addrconf_dad_run(struct inet6_dev *idev, bool restart);
 static void addrconf_rs_timer(struct timer_list *t);
 static void __ipv6_ifa_notify(int event, struct inet6_ifaddr *ifa);
 static void ipv6_ifa_notify(int event, struct inet6_ifaddr *ifa);
@@ -3424,6 +3424,7 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 			   void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct netdev_notifier_change_info *change_info;
 	struct netdev_notifier_changeupper_info *info;
 	struct inet6_dev *idev = __in6_dev_get(dev);
 	struct net *net = dev_net(dev);
@@ -3498,7 +3499,7 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 				break;
 			}
 
-			if (idev) {
+			if (!IS_ERR_OR_NULL(idev)) {
 				if (idev->if_flags & IF_READY) {
 					/* device is already configured -
 					 * but resend MLD reports, we might
@@ -3506,6 +3507,9 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 					 * multicast snooping switches
 					 */
 					ipv6_mc_up(idev);
+					change_info = ptr;
+					if (change_info->flags_changed & IFF_NOARP)
+						addrconf_dad_run(idev, true);
 					rt6_sync_up(dev, RTNH_F_LINKDOWN);
 					break;
 				}
@@ -3540,7 +3544,7 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 
 		if (!IS_ERR_OR_NULL(idev)) {
 			if (run_pending)
-				addrconf_dad_run(idev);
+				addrconf_dad_run(idev, false);
 
 			/* Device has an address by now */
 			rt6_sync_up(dev, RTNH_F_DEAD);
@@ -4158,16 +4162,19 @@ static void addrconf_dad_completed(struct inet6_ifaddr *ifp, bool bump_id,
 		addrconf_verify_rtnl();
 }
 
-static void addrconf_dad_run(struct inet6_dev *idev)
+static void addrconf_dad_run(struct inet6_dev *idev, bool restart)
 {
 	struct inet6_ifaddr *ifp;
 
 	read_lock_bh(&idev->lock);
 	list_for_each_entry(ifp, &idev->addr_list, if_list) {
 		spin_lock(&ifp->lock);
-		if (ifp->flags & IFA_F_TENTATIVE &&
-		    ifp->state == INET6_IFADDR_STATE_DAD)
+		if ((ifp->flags & IFA_F_TENTATIVE &&
+		     ifp->state == INET6_IFADDR_STATE_DAD) || restart) {
+			if (restart)
+				ifp->state = INET6_IFADDR_STATE_PREDAD;
 			addrconf_dad_kick(ifp);
+		}
 		spin_unlock(&ifp->lock);
 	}
 	read_unlock_bh(&idev->lock);
-- 
2.20.1




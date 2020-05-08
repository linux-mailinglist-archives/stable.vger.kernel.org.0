Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D9A1CABA8
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbgEHMpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729317AbgEHMpg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E5252496A;
        Fri,  8 May 2020 12:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941935;
        bh=t3MmTJjftAmvLq23kCtDBWhJvbXS7RsTnd8Pp+kNyqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFhKkWO2rRw091mtc0lK/5d8qmr1GgGdChCYih/Kf1a+ZmcR97XUBbUKhOzV3ORk7
         kR37gDkUimTuxmMJ4hCkSXDQOPueX/QglDdW9IJ1/zm/r68dkBACgitc10GFrVk9Ik
         RiiQzjc7Gyyd56RIx67+5SqDS969YaKOrwlEbxcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsa@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 192/312] net: vrf: Fix dev refcnt leak due to IPv6 prefix route
Date:   Fri,  8 May 2020 14:33:03 +0200
Message-Id: <20200508123137.959916124@linuxfoundation.org>
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

From: David Ahern <dsa@cumulusnetworks.com>

commit 4f7f34eaab9f68c9bcd45386b15c414c38b40587 upstream.

ifupdown2 found a kernel bug with IPv6 routes and movement from the main
table to the VRF table. Sequence of events:

Create the interface and add addresses:
    ip link add dev eth4.105 link eth4 type vlan id 105
    ip addr add dev eth4.105 8.105.105.10/24
    ip -6 addr add dev eth4.105 2008:105:105::10/64

At this point IPv6 has inserted a prefix route in the main table even
though the interface is 'down'. From there the VRF device is created:
    ip link add dev vrf105 type vrf table 105
    ip addr add dev vrf105 9.9.105.10/32
    ip -6 addr add dev vrf105 2000:9:105::10/128
    ip link set vrf105 up

Then the interface is enslaved, while still in the 'down' state:
    ip link set dev eth4.105 master vrf105

Since the device is down the VRF driver cycling the device does not
send the NETDEV_UP and NETDEV_DOWN but rather the NETDEV_CHANGE event
which does not flush the routes inserted prior.

When the link is brought up
    ip link set dev eth4.105 up

the prefix route is added in the VRF table, but does not remove
the route from the main table.

Fix by handling the NETDEV_CHANGEUPPER event similar what was implemented
for IPv4 in 7f49e7a38b77 ("net: Flush local routes when device changes vrf
association")

Fixes: 35402e3136634 ("net: Add IPv6 support to VRF device")

Signed-off-by: David Ahern <dsa@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/addrconf.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3146,6 +3146,7 @@ static int addrconf_notify(struct notifi
 			   void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct netdev_notifier_changeupper_info *info;
 	struct inet6_dev *idev = __in6_dev_get(dev);
 	struct net *net = dev_net(dev);
 	int run_pending = 0;
@@ -3307,6 +3308,15 @@ static int addrconf_notify(struct notifi
 	case NETDEV_POST_TYPE_CHANGE:
 		addrconf_type_change(dev, event);
 		break;
+
+	case NETDEV_CHANGEUPPER:
+		info = ptr;
+
+		/* flush all routes if dev is linked to or unlinked from
+		 * an L3 master device (e.g., VRF)
+		 */
+		if (info->upper_dev && netif_is_l3_master(info->upper_dev))
+			addrconf_ifdown(dev, 0);
 	}
 
 	return NOTIFY_OK;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A3088D38
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfHJUny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:43:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54292 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726640AbfHJUny (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:54 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDP-00053j-B3; Sat, 10 Aug 2019 21:43:51 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-0003gf-Oa; Sat, 10 Aug 2019 21:43:48 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Hangbin Liu" <liuhangbin@gmail.com>,
        "Jiri Pirko" <jiri@mellanox.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.780592421@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 101/157] team: fix possible recursive locking when
 add slaves
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

commit 925b0c841e066b488cc3a60272472b2c56300704 upstream.

If we add a bond device which is already the master of the team interface,
we will hold the team->lock in team_add_slave() first and then request the
lock in team_set_mac_address() again. The functions are called like:

- team_add_slave()
 - team_port_add()
   - team_port_enter()
     - team_modeop_port_enter()
       - __set_port_dev_addr()
         - dev_set_mac_address()
           - bond_set_mac_address()
             - dev_set_mac_address()
  	       - team_set_mac_address

Although team_upper_dev_link() would check the upper devices but it is
called too late. Fix it by adding a checking before processing the slave.

v2: Do not split the string in netdev_err()

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: netlink doesn't support extack]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1116,6 +1116,12 @@ static int team_port_add(struct team *te
 		return -EINVAL;
 	}
 
+	if (netdev_has_upper_dev(dev, port_dev)) {
+		netdev_err(dev, "Device %s is already an upper device of the team interface\n",
+			   portname);
+		return -EBUSY;
+	}
+
 	if (port_dev->features & NETIF_F_VLAN_CHALLENGED &&
 	    vlan_uses_dev(dev)) {
 		netdev_err(dev, "Device %s is VLAN challenged and team device has VLAN set up\n",


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30BC41F441
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfEOK6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 06:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbfEOK6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 06:58:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AD2D2084E;
        Wed, 15 May 2019 10:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557917885;
        bh=XQCzDOTXQac2H9j4wPDSYg1gKYrA3CsNaFBbRwY1ug8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bx5w3w0IXbT+qPGlioPyTGl7DrNLtwcEzmJVqaisli5xDdSAmxwgDVBnPgASalH1C
         OvDraqblo9BzDrDZgkC+Ni8+EpzN1fu9frHqG7eMSeGsR3eBt6fhkNxXgsJ9eiWDQA
         RpLuHGKt7IPq16bwpjKHhr/kN2EvnL8vPRk+m1+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 12/86] team: fix possible recursive locking when add slaves
Date:   Wed, 15 May 2019 12:54:49 +0200
Message-Id: <20190515090644.969008160@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 925b0c841e066b488cc3a60272472b2c56300704 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/team/team.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1137,6 +1137,12 @@ static int team_port_add(struct team *te
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



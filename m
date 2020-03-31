Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B44881991A8
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730366AbgCaJMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731249AbgCaJMv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:12:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D94D20675;
        Tue, 31 Mar 2020 09:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645970;
        bh=ta5DOwF43UEnXN3tbjlCTwPWCTY1gEg4sstmSM9XOX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xkC5DM9ad7/WljPkCS4gjyC8MjGBS+MtZIWNm3c64fVA1okr0V9x4l+SeMg9LOAKY
         1Tf5kpltb2YxLhUw9ATkuhqWeO+yMTV7beskWW/cQp4dGx7+EH/UoYrG/V5g5lOZ89
         IFLincZOK558HbZx/aS15EKwnyehuZVhxnCPnNFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 044/155] net: ip_gre: Separate ERSPAN newlink / changelink callbacks
Date:   Tue, 31 Mar 2020 10:58:04 +0200
Message-Id: <20200331085423.374809123@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit e1f8f78ffe9854308b9e12a73ebe4e909074fc33 ]

ERSPAN shares most of the code path with GRE and gretap code. While that
helps keep the code compact, it is also error prone. Currently a broken
userspace can turn a gretap tunnel into a de facto ERSPAN one by passing
IFLA_GRE_ERSPAN_VER. There has been a similar issue in ip6gretap in the
past.

To prevent these problems in future, split the newlink and changelink code
paths. Split the ERSPAN code out of ipgre_netlink_parms() into a new
function erspan_netlink_parms(). Extract a piece of common logic from
ipgre_newlink() and ipgre_changelink() into ipgre_newlink_encap_setup().
Add erspan_newlink() and erspan_changelink().

Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for ERSPAN")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c |  103 ++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 85 insertions(+), 18 deletions(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1149,6 +1149,22 @@ static int ipgre_netlink_parms(struct ne
 	if (data[IFLA_GRE_FWMARK])
 		*fwmark = nla_get_u32(data[IFLA_GRE_FWMARK]);
 
+	return 0;
+}
+
+static int erspan_netlink_parms(struct net_device *dev,
+				struct nlattr *data[],
+				struct nlattr *tb[],
+				struct ip_tunnel_parm *parms,
+				__u32 *fwmark)
+{
+	struct ip_tunnel *t = netdev_priv(dev);
+	int err;
+
+	err = ipgre_netlink_parms(dev, data, tb, parms, fwmark);
+	if (err)
+		return err;
+
 	if (data[IFLA_GRE_ERSPAN_VER]) {
 		t->erspan_ver = nla_get_u8(data[IFLA_GRE_ERSPAN_VER]);
 
@@ -1272,45 +1288,70 @@ static void ipgre_tap_setup(struct net_d
 	ip_tunnel_setup(dev, gre_tap_net_id);
 }
 
-static int ipgre_newlink(struct net *src_net, struct net_device *dev,
-			 struct nlattr *tb[], struct nlattr *data[],
-			 struct netlink_ext_ack *extack)
+static int
+ipgre_newlink_encap_setup(struct net_device *dev, struct nlattr *data[])
 {
-	struct ip_tunnel_parm p;
 	struct ip_tunnel_encap ipencap;
-	__u32 fwmark = 0;
-	int err;
 
 	if (ipgre_netlink_encap_parms(data, &ipencap)) {
 		struct ip_tunnel *t = netdev_priv(dev);
-		err = ip_tunnel_encap_setup(t, &ipencap);
+		int err = ip_tunnel_encap_setup(t, &ipencap);
 
 		if (err < 0)
 			return err;
 	}
 
+	return 0;
+}
+
+static int ipgre_newlink(struct net *src_net, struct net_device *dev,
+			 struct nlattr *tb[], struct nlattr *data[],
+			 struct netlink_ext_ack *extack)
+{
+	struct ip_tunnel_parm p;
+	__u32 fwmark = 0;
+	int err;
+
+	err = ipgre_newlink_encap_setup(dev, data);
+	if (err)
+		return err;
+
 	err = ipgre_netlink_parms(dev, data, tb, &p, &fwmark);
 	if (err < 0)
 		return err;
 	return ip_tunnel_newlink(dev, tb, &p, fwmark);
 }
 
+static int erspan_newlink(struct net *src_net, struct net_device *dev,
+			  struct nlattr *tb[], struct nlattr *data[],
+			  struct netlink_ext_ack *extack)
+{
+	struct ip_tunnel_parm p;
+	__u32 fwmark = 0;
+	int err;
+
+	err = ipgre_newlink_encap_setup(dev, data);
+	if (err)
+		return err;
+
+	err = erspan_netlink_parms(dev, data, tb, &p, &fwmark);
+	if (err)
+		return err;
+	return ip_tunnel_newlink(dev, tb, &p, fwmark);
+}
+
 static int ipgre_changelink(struct net_device *dev, struct nlattr *tb[],
 			    struct nlattr *data[],
 			    struct netlink_ext_ack *extack)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
-	struct ip_tunnel_encap ipencap;
 	__u32 fwmark = t->fwmark;
 	struct ip_tunnel_parm p;
 	int err;
 
-	if (ipgre_netlink_encap_parms(data, &ipencap)) {
-		err = ip_tunnel_encap_setup(t, &ipencap);
-
-		if (err < 0)
-			return err;
-	}
+	err = ipgre_newlink_encap_setup(dev, data);
+	if (err)
+		return err;
 
 	err = ipgre_netlink_parms(dev, data, tb, &p, &fwmark);
 	if (err < 0)
@@ -1323,8 +1364,34 @@ static int ipgre_changelink(struct net_d
 	t->parms.i_flags = p.i_flags;
 	t->parms.o_flags = p.o_flags;
 
-	if (strcmp(dev->rtnl_link_ops->kind, "erspan"))
-		ipgre_link_update(dev, !tb[IFLA_MTU]);
+	ipgre_link_update(dev, !tb[IFLA_MTU]);
+
+	return 0;
+}
+
+static int erspan_changelink(struct net_device *dev, struct nlattr *tb[],
+			     struct nlattr *data[],
+			     struct netlink_ext_ack *extack)
+{
+	struct ip_tunnel *t = netdev_priv(dev);
+	__u32 fwmark = t->fwmark;
+	struct ip_tunnel_parm p;
+	int err;
+
+	err = ipgre_newlink_encap_setup(dev, data);
+	if (err)
+		return err;
+
+	err = erspan_netlink_parms(dev, data, tb, &p, &fwmark);
+	if (err < 0)
+		return err;
+
+	err = ip_tunnel_changelink(dev, tb, &p, fwmark);
+	if (err < 0)
+		return err;
+
+	t->parms.i_flags = p.i_flags;
+	t->parms.o_flags = p.o_flags;
 
 	return 0;
 }
@@ -1515,8 +1582,8 @@ static struct rtnl_link_ops erspan_link_
 	.priv_size	= sizeof(struct ip_tunnel),
 	.setup		= erspan_setup,
 	.validate	= erspan_validate,
-	.newlink	= ipgre_newlink,
-	.changelink	= ipgre_changelink,
+	.newlink	= erspan_newlink,
+	.changelink	= erspan_changelink,
 	.dellink	= ip_tunnel_dellink,
 	.get_size	= ipgre_get_size,
 	.fill_info	= ipgre_fill_info,



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D821881D0
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgCQLAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727673AbgCQLAw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:00:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B43420735;
        Tue, 17 Mar 2020 11:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442851;
        bh=HRRrl/gxVhH1ZfxEt4j/7UewEaU43uaSVp+a8r/n95c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8k91v7gmMkfeAbp4w422WHUekeGAaH4TB8IbdNR6rKwMtWoLd+9816+lxTnLg6kh
         yOKfiuRdi7ORsu9KazhLGH5ANv3c4FMIkbqgxg+gw+rbPNk+TykAkWe8dZUlDZniX5
         jRTmKgKlF4eZR5usZyi/uUNLezMmI6PWXXnBq3zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 014/123] net: dsa: fix phylink_start()/phylink_stop() calls
Date:   Tue, 17 Mar 2020 11:54:01 +0100
Message-Id: <20200317103309.165012071@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 8640f8dc6d657ebfb4e67c202ad32c5457858a13 ]

Place phylink_start()/phylink_stop() inside dsa_port_enable() and
dsa_port_disable(), which ensures that we call phylink_stop() before
tearing down phylink - which is a documented requirement.  Failure
to do so can cause use-after-free bugs.

Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/dsa_priv.h |    2 ++
 net/dsa/port.c     |   32 ++++++++++++++++++++++++++------
 net/dsa/slave.c    |    8 ++------
 3 files changed, 30 insertions(+), 12 deletions(-)

--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -128,7 +128,9 @@ static inline struct net_device *dsa_mas
 /* port.c */
 int dsa_port_set_state(struct dsa_port *dp, u8 state,
 		       struct switchdev_trans *trans);
+int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
 int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
+void dsa_port_disable_rt(struct dsa_port *dp);
 void dsa_port_disable(struct dsa_port *dp);
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br);
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -63,7 +63,7 @@ static void dsa_port_set_state_now(struc
 		pr_err("DSA: failed to set STP state %u (%d)\n", state, err);
 }
 
-int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
+int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy)
 {
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
@@ -78,14 +78,31 @@ int dsa_port_enable(struct dsa_port *dp,
 	if (!dp->bridge_dev)
 		dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
 
+	if (dp->pl)
+		phylink_start(dp->pl);
+
 	return 0;
 }
 
-void dsa_port_disable(struct dsa_port *dp)
+int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
+{
+	int err;
+
+	rtnl_lock();
+	err = dsa_port_enable_rt(dp, phy);
+	rtnl_unlock();
+
+	return err;
+}
+
+void dsa_port_disable_rt(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
 
+	if (dp->pl)
+		phylink_stop(dp->pl);
+
 	if (!dp->bridge_dev)
 		dsa_port_set_state_now(dp, BR_STATE_DISABLED);
 
@@ -93,6 +110,13 @@ void dsa_port_disable(struct dsa_port *d
 		ds->ops->port_disable(ds, port);
 }
 
+void dsa_port_disable(struct dsa_port *dp)
+{
+	rtnl_lock();
+	dsa_port_disable_rt(dp);
+	rtnl_unlock();
+}
+
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 {
 	struct dsa_notifier_bridge_info info = {
@@ -615,10 +639,6 @@ static int dsa_port_phylink_register(str
 		goto err_phy_connect;
 	}
 
-	rtnl_lock();
-	phylink_start(dp->pl);
-	rtnl_unlock();
-
 	return 0;
 
 err_phy_connect:
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -90,12 +90,10 @@ static int dsa_slave_open(struct net_dev
 			goto clear_allmulti;
 	}
 
-	err = dsa_port_enable(dp, dev->phydev);
+	err = dsa_port_enable_rt(dp, dev->phydev);
 	if (err)
 		goto clear_promisc;
 
-	phylink_start(dp->pl);
-
 	return 0;
 
 clear_promisc:
@@ -119,9 +117,7 @@ static int dsa_slave_close(struct net_de
 	cancel_work_sync(&dp->xmit_work);
 	skb_queue_purge(&dp->xmit_queue);
 
-	phylink_stop(dp->pl);
-
-	dsa_port_disable(dp);
+	dsa_port_disable_rt(dp);
 
 	dev_mc_unsync(master, dev);
 	dev_uc_unsync(master, dev);



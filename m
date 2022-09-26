Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3638B5E9EE4
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbiIZKPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbiIZKPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:15:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FA7E016;
        Mon, 26 Sep 2022 03:14:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2E6060C0B;
        Mon, 26 Sep 2022 10:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0490C433C1;
        Mon, 26 Sep 2022 10:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187257;
        bh=Yq2zNuwlh4qQrtWhiCD9oJKsITCsDdmBPn/mJK9Qrqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjNtjvoJAxHl0oWhh3SqVNLpSi+QgQyKnHjhu/ANHpBegMMgY+kNfPwxEZaNT2+5u
         oTme94c5VGuZhI/lDXJH6DmP6xMZVIjLdcleZWJ6bbdP53jQzti0SArHBtEJ4J4fnv
         7lCBQp4gunbxyfGRtHlTQfnsTqpiKxA+Ew8X3Hwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Poirier <bpoirier@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 21/30] net: team: Unsync device addresses on ndo_stop
Date:   Mon, 26 Sep 2022 12:11:52 +0200
Message-Id: <20220926100736.912292608@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100736.153157100@linuxfoundation.org>
References: <20220926100736.153157100@linuxfoundation.org>
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

From: Benjamin Poirier <bpoirier@nvidia.com>

[ Upstream commit bd60234222b2fd5573526da7bcd422801f271f5f ]

Netdev drivers are expected to call dev_{uc,mc}_sync() in their
ndo_set_rx_mode method and dev_{uc,mc}_unsync() in their ndo_stop method.
This is mentioned in the kerneldoc for those dev_* functions.

The team driver calls dev_{uc,mc}_unsync() during ndo_uninit instead of
ndo_stop. This is ineffective because address lists (dev->{uc,mc}) have
already been emptied in unregister_netdevice_many() before ndo_uninit is
called. This mistake can result in addresses being leftover on former team
ports after a team device has been deleted; see test_LAG_cleanup() in the
last patch in this series.

Add unsync calls at their expected location, team_close().

v3:
* When adding or deleting a port, only sync/unsync addresses if the team
  device is up. In other cases, it is taken care of at the right time by
  ndo_open/ndo_set_rx_mode/ndo_stop.

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 001dea7aaba3..657e12e0b5e2 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1280,10 +1280,12 @@ static int team_port_add(struct team *team, struct net_device *port_dev)
 		}
 	}
 
-	netif_addr_lock_bh(dev);
-	dev_uc_sync_multiple(port_dev, dev);
-	dev_mc_sync_multiple(port_dev, dev);
-	netif_addr_unlock_bh(dev);
+	if (dev->flags & IFF_UP) {
+		netif_addr_lock_bh(dev);
+		dev_uc_sync_multiple(port_dev, dev);
+		dev_mc_sync_multiple(port_dev, dev);
+		netif_addr_unlock_bh(dev);
+	}
 
 	port->index = -1;
 	list_add_tail_rcu(&port->list, &team->port_list);
@@ -1354,8 +1356,10 @@ static int team_port_del(struct team *team, struct net_device *port_dev)
 	netdev_rx_handler_unregister(port_dev);
 	team_port_disable_netpoll(port);
 	vlan_vids_del_by_dev(port_dev, dev);
-	dev_uc_unsync(port_dev, dev);
-	dev_mc_unsync(port_dev, dev);
+	if (dev->flags & IFF_UP) {
+		dev_uc_unsync(port_dev, dev);
+		dev_mc_unsync(port_dev, dev);
+	}
 	dev_close(port_dev);
 	team_port_leave(team, port);
 
@@ -1703,6 +1707,14 @@ static int team_open(struct net_device *dev)
 
 static int team_close(struct net_device *dev)
 {
+	struct team *team = netdev_priv(dev);
+	struct team_port *port;
+
+	list_for_each_entry(port, &team->port_list, list) {
+		dev_uc_unsync(port->dev, dev);
+		dev_mc_unsync(port->dev, dev);
+	}
+
 	return 0;
 }
 
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD735E9FCA
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbiIZK3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235641AbiIZK2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:28:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158964E623;
        Mon, 26 Sep 2022 03:19:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B16B0B80926;
        Mon, 26 Sep 2022 10:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA02C433D6;
        Mon, 26 Sep 2022 10:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187540;
        bh=7GK2AKFlWUrcqmq7eNKe1bJ+5y4F9zZSwGlM48csltU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vrOa5QDabZLoOg7GKsVTA5q6mfXI6PlPbWHKEomfVj1GmNYvu2px2MSvDzyiD0LHH
         UDgFm6emeXn+3B9OseIepAOjqL8Gc2wx7En8yTLkDvOfKyTv4CT6ZaTGrPzsc5b5g+
         5IrzieCYHF+IfUAxdEUI3/PBXThAXQ3sZcv34Q48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Poirier <bpoirier@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/58] net: team: Unsync device addresses on ndo_stop
Date:   Mon, 26 Sep 2022 12:11:59 +0200
Message-Id: <20220926100742.930754398@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
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
index 8a1e9dba1249..2410f08e2bb5 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1280,10 +1280,12 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
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




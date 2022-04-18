Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBA550517A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbiDRMfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239778AbiDRMd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3281B78F;
        Mon, 18 Apr 2022 05:26:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0D3660FB6;
        Mon, 18 Apr 2022 12:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8F8C385A7;
        Mon, 18 Apr 2022 12:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284732;
        bh=tBpwUdixRcwh0wUsFNynhdOn/ivLTX5IRZZzK9fsF6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Rgmj8buU2drCi5x/zv2zv5WqJtnaIApK6tJzdOYsscffmnQMy59TXevA9b6pFEoZ
         L62wRA5iLqdte6qCrwyqASlP4LQH2NmXn5hXdv+3y8AY5Qjz4n28e6yy1Ga+uOaHOu
         oK8L/hdfsreMjXEMVwcvikc+NKxsQGVTHWS/rTeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.17 209/219] Revert "net: dsa: setup master before ports"
Date:   Mon, 18 Apr 2022 14:12:58 +0200
Message-Id: <20220418121212.717936708@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 762c2998c9625f642f0d23da7d3f7e4f90665fdf upstream.

This reverts commit 11fd667dac315ea3f2469961f6d2869271a46cae.

dsa_slave_change_mtu() updates the MTU of the DSA master and of the
associated CPU port, but only if it detects a change to the master MTU.

The blamed commit in the Fixes: tag below addressed a regression where
dsa_slave_change_mtu() would return early and not do anything due to
ds->ops->port_change_mtu() not being implemented.

However, that commit also had the effect that the master MTU got set up
to the correct value by dsa_master_setup(), but the associated CPU port's
MTU did not get updated. This causes breakage for drivers that rely on
the ->port_change_mtu() DSA call to account for the tagging overhead on
the CPU port, and don't set up the initial MTU during the setup phase.

Things actually worked before because they were in a fragile equilibrium
where dsa_slave_change_mtu() was called before dsa_master_setup() was.
So dsa_slave_change_mtu() could actually detect a change and update the
CPU port MTU too.

Restore the code to the way things used to work by reverting the reorder
of dsa_tree_setup_master() and dsa_tree_setup_ports(). That change did
not have a concrete motivation going for it anyway, it just looked
better.

Fixes: 066dfc429040 ("Revert "net: dsa: stop updating master MTU from master.c"")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/dsa2.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -561,7 +561,6 @@ static void dsa_port_teardown(struct dsa
 	struct devlink_port *dlp = &dp->devlink_port;
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a, *tmp;
-	struct net_device *slave;
 
 	if (!dp->setup)
 		return;
@@ -583,11 +582,9 @@ static void dsa_port_teardown(struct dsa
 		dsa_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_USER:
-		slave = dp->slave;
-
-		if (slave) {
+		if (dp->slave) {
+			dsa_slave_destroy(dp->slave);
 			dp->slave = NULL;
-			dsa_slave_destroy(slave);
 		}
 		break;
 	}
@@ -1137,17 +1134,17 @@ static int dsa_tree_setup(struct dsa_swi
 	if (err)
 		goto teardown_cpu_ports;
 
-	err = dsa_tree_setup_master(dst);
+	err = dsa_tree_setup_ports(dst);
 	if (err)
 		goto teardown_switches;
 
-	err = dsa_tree_setup_ports(dst);
+	err = dsa_tree_setup_master(dst);
 	if (err)
-		goto teardown_master;
+		goto teardown_ports;
 
 	err = dsa_tree_setup_lags(dst);
 	if (err)
-		goto teardown_ports;
+		goto teardown_master;
 
 	dst->setup = true;
 
@@ -1155,10 +1152,10 @@ static int dsa_tree_setup(struct dsa_swi
 
 	return 0;
 
-teardown_ports:
-	dsa_tree_teardown_ports(dst);
 teardown_master:
 	dsa_tree_teardown_master(dst);
+teardown_ports:
+	dsa_tree_teardown_ports(dst);
 teardown_switches:
 	dsa_tree_teardown_switches(dst);
 teardown_cpu_ports:
@@ -1176,10 +1173,10 @@ static void dsa_tree_teardown(struct dsa
 
 	dsa_tree_teardown_lags(dst);
 
-	dsa_tree_teardown_ports(dst);
-
 	dsa_tree_teardown_master(dst);
 
+	dsa_tree_teardown_ports(dst);
+
 	dsa_tree_teardown_switches(dst);
 
 	dsa_tree_teardown_cpu_ports(dst);



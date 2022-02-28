Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365754C769A
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbiB1SFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240090AbiB1SDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:03:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9119E9FE;
        Mon, 28 Feb 2022 09:46:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 182EFB815C8;
        Mon, 28 Feb 2022 17:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7215DC340F0;
        Mon, 28 Feb 2022 17:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070363;
        bh=hASjgU5IbImGYbBcnUlqosQGVE2k2Av8fnxVz6ioyzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YqUqIGohxPXSoj6bdRbdvcLzdQoMjpefE0tu/AsKqg72Uru3+ol9ieT+m+jtC8/OI
         SQdB2+cHtYIF5lVK1tcmKZnXt+HYTPlP9NWS4057EXRN/XJ+kPxWhjZe2hD7EKR7pU
         Fe7HEHGHFRzlqWpc2WLReidsv0UgE/XEamxWtPpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 081/164] net: dsa: avoid call to __dev_set_promiscuity() while rtnl_mutex isnt held
Date:   Mon, 28 Feb 2022 18:24:03 +0100
Message-Id: <20220228172407.321734179@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 8940e6b669ca1196ce0a0549c819078096390f76 upstream.

If the DSA master doesn't support IFF_UNICAST_FLT, then the following
call path is possible:

dsa_slave_switchdev_event_work
-> dsa_port_host_fdb_add
   -> dev_uc_add
      -> __dev_set_rx_mode
         -> __dev_set_promiscuity

Since the blamed commit, dsa_slave_switchdev_event_work() no longer
holds rtnl_lock(), which triggers the ASSERT_RTNL() from
__dev_set_promiscuity().

Taking rtnl_lock() around dev_uc_add() is impossible, because all the
code paths that call dsa_flush_workqueue() do so from contexts where the
rtnl_mutex is already held - so this would lead to an instant deadlock.

dev_uc_add() in itself doesn't require the rtnl_mutex for protection.
There is this comment in __dev_set_rx_mode() which assumes so:

		/* Unicast addresses changes may only happen under the rtnl,
		 * therefore calling __dev_set_promiscuity here is safe.
		 */

but it is from commit 4417da668c00 ("[NET]: dev: secondary unicast
address support") dated June 2007, and in the meantime, commit
f1f28aa3510d ("netdev: Add addr_list_lock to struct net_device."), dated
July 2008, has added &dev->addr_list_lock to protect this instead of the
global rtnl_mutex.

Nonetheless, __dev_set_promiscuity() does assume rtnl_mutex protection,
but it is the uncommon path of what we typically expect dev_uc_add()
to do. So since only the uncommon path requires rtnl_lock(), just check
ahead of time whether dev_uc_add() would result into a call to
__dev_set_promiscuity(), and handle that condition separately.

DSA already configures the master interface to be promiscuous if the
tagger requires this. We can extend this to also cover the case where
the master doesn't handle dev_uc_add() (doesn't support IFF_UNICAST_FLT),
and on the premise that we'd end up making it promiscuous during
operation anyway, either if a DSA slave has a non-inherited MAC address,
or if the bridge notifies local FDB entries for its own MAC address, the
address of a station learned on a foreign port, etc.

Fixes: 0faf890fc519 ("net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work")
Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/master.c |    7 ++++++-
 net/dsa/port.c   |   20 ++++++++++++++------
 2 files changed, 20 insertions(+), 7 deletions(-)

--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -260,11 +260,16 @@ static void dsa_netdev_ops_set(struct ne
 	dev->dsa_ptr->netdev_ops = ops;
 }
 
+/* Keep the master always promiscuous if the tagging protocol requires that
+ * (garbles MAC DA) or if it doesn't support unicast filtering, case in which
+ * it would revert to promiscuous mode as soon as we call dev_uc_add() on it
+ * anyway.
+ */
 static void dsa_master_set_promiscuity(struct net_device *dev, int inc)
 {
 	const struct dsa_device_ops *ops = dev->dsa_ptr->tag_ops;
 
-	if (!ops->promisc_on_master)
+	if ((dev->priv_flags & IFF_UNICAST_FLT) && !ops->promisc_on_master)
 		return;
 
 	rtnl_lock();
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -777,9 +777,15 @@ int dsa_port_host_fdb_add(struct dsa_por
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
 
-	err = dev_uc_add(cpu_dp->master, addr);
-	if (err)
-		return err;
+	/* Avoid a call to __dev_set_promiscuity() on the master, which
+	 * requires rtnl_lock(), since we can't guarantee that is held here,
+	 * and we can't take it either.
+	 */
+	if (cpu_dp->master->priv_flags & IFF_UNICAST_FLT) {
+		err = dev_uc_add(cpu_dp->master, addr);
+		if (err)
+			return err;
+	}
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_ADD, &info);
 }
@@ -796,9 +802,11 @@ int dsa_port_host_fdb_del(struct dsa_por
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
 
-	err = dev_uc_del(cpu_dp->master, addr);
-	if (err)
-		return err;
+	if (cpu_dp->master->priv_flags & IFF_UNICAST_FLT) {
+		err = dev_uc_del(cpu_dp->master, addr);
+		if (err)
+			return err;
+	}
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
 }



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CB04FDB09
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377218AbiDLHtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357675AbiDLHkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:40:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661D237A19;
        Tue, 12 Apr 2022 00:16:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AF94B81B4F;
        Tue, 12 Apr 2022 07:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71421C385A5;
        Tue, 12 Apr 2022 07:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747791;
        bh=VZVvP87MYgzbE+UjduvwsVvKXx0jKM82k2v4eWM5gAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w8uVWziAO6Thcmz0Thlu8gWgjxnfL0SoEyztoOYoBfn+MlEa61DmEEjpQ3S8uDtOv
         yekPOexG0IWYloGpZo9Lalrdv+OaAewpOOZt7p63Skel7sn+NPjIRK27dBjnhtoTtk
         7GBzpnoo8p3ShY6P+I2PSkJQz39bBYUA0zuvRJ4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 208/343] Revert "net: dsa: stop updating master MTU from master.c"
Date:   Tue, 12 Apr 2022 08:30:26 +0200
Message-Id: <20220412062957.353260366@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 066dfc4290406b1b0b014ae3267d4266a344efd1 ]

This reverts commit a1ff94c2973c43bc1e2677ac63ebb15b1d1ff846.

Switch drivers that don't implement ->port_change_mtu() will cause the
DSA master to remain with an MTU of 1500, since we've deleted the other
code path. In turn, this causes a regression for those systems, where
MTU-sized traffic can no longer be terminated.

Revert the change taking into account the fact that rtnl_lock() is now
taken top-level from the callers of dsa_master_setup() and
dsa_master_teardown(). Also add a comment in order for it to be
absolutely clear why it is still needed.

Fixes: a1ff94c2973c ("net: dsa: stop updating master MTU from master.c")
Reported-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/master.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index 880f910b23a9..10b51ffbb6f4 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -337,11 +337,24 @@ static const struct attribute_group dsa_group = {
 
 static struct lock_class_key dsa_master_addr_list_lock_key;
 
+static void dsa_master_reset_mtu(struct net_device *dev)
+{
+	int err;
+
+	err = dev_set_mtu(dev, ETH_DATA_LEN);
+	if (err)
+		netdev_dbg(dev,
+			   "Unable to reset MTU to exclude DSA overheads\n");
+}
+
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
+	const struct dsa_device_ops *tag_ops = cpu_dp->tag_ops;
 	struct dsa_switch *ds = cpu_dp->ds;
 	struct device_link *consumer_link;
-	int ret;
+	int mtu, ret;
+
+	mtu = ETH_DATA_LEN + dsa_tag_protocol_overhead(tag_ops);
 
 	/* The DSA master must use SET_NETDEV_DEV for this to work. */
 	consumer_link = device_link_add(ds->dev, dev->dev.parent,
@@ -351,6 +364,15 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 			   "Failed to create a device link to DSA switch %s\n",
 			   dev_name(ds->dev));
 
+	/* The switch driver may not implement ->port_change_mtu(), case in
+	 * which dsa_slave_change_mtu() will not update the master MTU either,
+	 * so we need to do that here.
+	 */
+	ret = dev_set_mtu(dev, mtu);
+	if (ret)
+		netdev_warn(dev, "error %d setting MTU to %d to include DSA overhead\n",
+			    ret, mtu);
+
 	/* If we use a tagging format that doesn't have an ethertype
 	 * field, make sure that all packets from this point on get
 	 * sent to the tag format's receive function.
@@ -388,6 +410,7 @@ void dsa_master_teardown(struct net_device *dev)
 	sysfs_remove_group(&dev->dev.kobj, &dsa_group);
 	dsa_netdev_ops_set(dev, NULL);
 	dsa_master_ethtool_teardown(dev);
+	dsa_master_reset_mtu(dev);
 	dsa_master_set_promiscuity(dev, -1);
 
 	dev->dsa_ptr = NULL;
-- 
2.35.1




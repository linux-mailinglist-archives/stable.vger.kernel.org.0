Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B775555E07E
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbiF0LiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236464AbiF0Lhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:37:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABE7639B;
        Mon, 27 Jun 2022 04:33:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49FFC60920;
        Mon, 27 Jun 2022 11:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586ACC3411D;
        Mon, 27 Jun 2022 11:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329581;
        bh=VjrW0YBVZnN90T39YspyWl6ZPPln3YcYOmG1ArTMSVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1GyUUaZaySG04ti4h4yvJPgud8SrkenQDAuLv9pHoa7jx/RILx8v1VEEQDBMFU0X
         XQAhEgcdQqYbyhFozqhgkVNjykNaw8zXQQ/i2cb3o9kWddkQ1DHjqS3NNrd7vcaBWU
         qRgKrle2ABYDGKHXvMbOPySLGkHJxl5KBMMJIrZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pei Zhang <pezhang@redhat.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/135] net: Write lock dev_base_lock without disabling bottom halves.
Date:   Mon, 27 Jun 2022 13:20:54 +0200
Message-Id: <20220627111939.525398874@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit fd888e85fe6b661e78044dddfec0be5271afa626 ]

The writer acquires dev_base_lock with disabled bottom halves.
The reader can acquire dev_base_lock without disabling bottom halves
because there is no writer in softirq context.

On PREEMPT_RT the softirqs are preemptible and local_bh_disable() acts
as a lock to ensure that resources, that are protected by disabling
bottom halves, remain protected.
This leads to a circular locking dependency if the lock acquired with
disabled bottom halves (as in write_lock_bh()) and somewhere else with
enabled bottom halves (as by read_lock() in netstat_show()) followed by
disabling bottom halves (cxgb_get_stats() -> t4_wr_mbox_meat_timeout()
-> spin_lock_bh()). This is the reverse locking order.

All read_lock() invocation are from sysfs callback which are not invoked
from softirq context. Therefore there is no need to disable bottom
halves while acquiring a write lock.

Acquire the write lock of dev_base_lock without disabling bottom halves.

Reported-by: Pei Zhang <pezhang@redhat.com>
Reported-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c        | 16 ++++++++--------
 net/core/link_watch.c |  4 ++--
 net/core/rtnetlink.c  |  8 ++++----
 net/hsr/hsr_device.c  |  6 +++---
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b9731b267d07..860fc6a98373 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -365,12 +365,12 @@ static void list_netdevice(struct net_device *dev)
 
 	ASSERT_RTNL();
 
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 	list_add_tail_rcu(&dev->dev_list, &net->dev_base_head);
 	netdev_name_node_add(net, dev->name_node);
 	hlist_add_head_rcu(&dev->index_hlist,
 			   dev_index_hash(net, dev->ifindex));
-	write_unlock_bh(&dev_base_lock);
+	write_unlock(&dev_base_lock);
 
 	dev_base_seq_inc(net);
 }
@@ -383,11 +383,11 @@ static void unlist_netdevice(struct net_device *dev)
 	ASSERT_RTNL();
 
 	/* Unlink dev from the device chain */
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 	list_del_rcu(&dev->dev_list);
 	netdev_name_node_del(dev->name_node);
 	hlist_del_rcu(&dev->index_hlist);
-	write_unlock_bh(&dev_base_lock);
+	write_unlock(&dev_base_lock);
 
 	dev_base_seq_inc(dev_net(dev));
 }
@@ -1266,15 +1266,15 @@ int dev_change_name(struct net_device *dev, const char *newname)
 
 	netdev_adjacent_rename_links(dev, oldname);
 
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 	netdev_name_node_del(dev->name_node);
-	write_unlock_bh(&dev_base_lock);
+	write_unlock(&dev_base_lock);
 
 	synchronize_rcu();
 
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 	netdev_name_node_add(net, dev->name_node);
-	write_unlock_bh(&dev_base_lock);
+	write_unlock(&dev_base_lock);
 
 	ret = call_netdevice_notifiers(NETDEV_CHANGENAME, dev);
 	ret = notifier_to_errno(ret);
diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 1a455847da54..9599afd0862d 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -55,7 +55,7 @@ static void rfc2863_policy(struct net_device *dev)
 	if (operstate == dev->operstate)
 		return;
 
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 
 	switch(dev->link_mode) {
 	case IF_LINK_MODE_TESTING:
@@ -74,7 +74,7 @@ static void rfc2863_policy(struct net_device *dev)
 
 	dev->operstate = operstate;
 
-	write_unlock_bh(&dev_base_lock);
+	write_unlock(&dev_base_lock);
 }
 
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 9c0e8ccf9bc5..8c85e93daa73 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -842,9 +842,9 @@ static void set_operstate(struct net_device *dev, unsigned char transition)
 	}
 
 	if (dev->operstate != operstate) {
-		write_lock_bh(&dev_base_lock);
+		write_lock(&dev_base_lock);
 		dev->operstate = operstate;
-		write_unlock_bh(&dev_base_lock);
+		write_unlock(&dev_base_lock);
 		netdev_state_change(dev);
 	}
 }
@@ -2781,11 +2781,11 @@ static int do_setlink(const struct sk_buff *skb,
 	if (tb[IFLA_LINKMODE]) {
 		unsigned char value = nla_get_u8(tb[IFLA_LINKMODE]);
 
-		write_lock_bh(&dev_base_lock);
+		write_lock(&dev_base_lock);
 		if (dev->link_mode ^ value)
 			status |= DO_SETLINK_NOTIFY;
 		dev->link_mode = value;
-		write_unlock_bh(&dev_base_lock);
+		write_unlock(&dev_base_lock);
 	}
 
 	if (tb[IFLA_VFINFO_LIST]) {
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 26c32407f029..ea7b96e296ef 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -30,13 +30,13 @@ static bool is_slave_up(struct net_device *dev)
 
 static void __hsr_set_operstate(struct net_device *dev, int transition)
 {
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 	if (dev->operstate != transition) {
 		dev->operstate = transition;
-		write_unlock_bh(&dev_base_lock);
+		write_unlock(&dev_base_lock);
 		netdev_state_change(dev);
 	} else {
-		write_unlock_bh(&dev_base_lock);
+		write_unlock(&dev_base_lock);
 	}
 }
 
-- 
2.35.1




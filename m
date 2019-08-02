Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B497F26F
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405242AbfHBJsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:48:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405752AbfHBJrz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:47:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02E8B2086A;
        Fri,  2 Aug 2019 09:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739274;
        bh=A8kKjbFSnEC+/QBKfFa7P86LKhVsYi0K7r+xJTwSqLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVxj8BTTh+ol0OuL1YyleSdsLQssQYmw/1yhvPBhVI8w/rBO0AJNCMDuB32kCOcoM
         Rqwu+2BN0M+/QVRLu2Vh5oTKRBBJYsxvc4a6htxDrIW9C61yHIdYiQ5hp0dIHhfMwW
         6CUGp3kqZwBd3Ia3k3G2oOOzzWGlW6zlQD7L8QVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+e5be16aa39ad6e755391@syzkaller.appspotmail.com
Subject: [PATCH 4.9 146/223] bonding: validate ip header before check IPPROTO_IGMP
Date:   Fri,  2 Aug 2019 11:36:11 +0200
Message-Id: <20190802092248.052256687@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 9d1bc24b52fb8c5d859f9a47084bf1179470e04c ]

bond_xmit_roundrobin() checks for IGMP packets but it parses
the IP header even before checking skb->protocol.

We should validate the IP header with pskb_may_pull() before
using iph->protocol.

Reported-and-tested-by: syzbot+e5be16aa39ad6e755391@syzkaller.appspotmail.com
Fixes: a2fd940f4cff ("bonding: fix broken multicast with round-robin mode")
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |   37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3788,8 +3788,8 @@ static u32 bond_rr_gen_slave_id(struct b
 static int bond_xmit_roundrobin(struct sk_buff *skb, struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct iphdr *iph = ip_hdr(skb);
 	struct slave *slave;
+	int slave_cnt;
 	u32 slave_id;
 
 	/* Start with the curr_active_slave that joined the bond as the
@@ -3798,23 +3798,32 @@ static int bond_xmit_roundrobin(struct s
 	 * send the join/membership reports.  The curr_active_slave found
 	 * will send all of this type of traffic.
 	 */
-	if (iph->protocol == IPPROTO_IGMP && skb->protocol == htons(ETH_P_IP)) {
-		slave = rcu_dereference(bond->curr_active_slave);
-		if (slave)
-			bond_dev_queue_xmit(bond, skb, slave->dev);
-		else
-			bond_xmit_slave_id(bond, skb, 0);
-	} else {
-		int slave_cnt = ACCESS_ONCE(bond->slave_cnt);
+	if (skb->protocol == htons(ETH_P_IP)) {
+		int noff = skb_network_offset(skb);
+		struct iphdr *iph;
+
+		if (unlikely(!pskb_may_pull(skb, noff + sizeof(*iph))))
+			goto non_igmp;
 
-		if (likely(slave_cnt)) {
-			slave_id = bond_rr_gen_slave_id(bond);
-			bond_xmit_slave_id(bond, skb, slave_id % slave_cnt);
-		} else {
-			bond_tx_drop(bond_dev, skb);
+		iph = ip_hdr(skb);
+		if (iph->protocol == IPPROTO_IGMP) {
+			slave = rcu_dereference(bond->curr_active_slave);
+			if (slave)
+				bond_dev_queue_xmit(bond, skb, slave->dev);
+			else
+				bond_xmit_slave_id(bond, skb, 0);
+			return NETDEV_TX_OK;
 		}
 	}
 
+non_igmp:
+	slave_cnt = ACCESS_ONCE(bond->slave_cnt);
+	if (likely(slave_cnt)) {
+		slave_id = bond_rr_gen_slave_id(bond);
+		bond_xmit_slave_id(bond, skb, slave_id % slave_cnt);
+	} else {
+		bond_tx_drop(bond_dev, skb);
+	}
 	return NETDEV_TX_OK;
 }
 



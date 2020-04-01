Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6584C19B107
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388137AbgDAQbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:31:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388298AbgDAQbT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:31:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9368E2063A;
        Wed,  1 Apr 2020 16:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758679;
        bh=qTW48sVpSSSVqkcOsFMpmgPKG8SDdLTyQ5tNGaj3Ijo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q7sea7HN7yM4BcTaVpRg+BnmsWaaE6P/Y3qD1eQ+ak2KnAsWhoB3kqcESvlolTnK7
         D3RKdbsy/ooeY9dycAI0FSGeV1pcUCsSfuaESNMwAnFWJzmFllx3eAwe+8tot3GtDF
         zzbVrN9VeIVEY6IFvwYTmSIHwcostk+EyBo0bVwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 42/91] hsr: add restart routine into hsr_get_node_list()
Date:   Wed,  1 Apr 2020 18:17:38 +0200
Message-Id: <20200401161528.249560395@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit ca19c70f5225771c05bcdcb832b4eb84d7271c5e ]

The hsr_get_node_list() is to send node addresses to the userspace.
If there are so many nodes, it could fail because of buffer size.
In order to avoid this failure, the restart routine is added.

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_netlink.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -366,16 +366,14 @@ fail:
  */
 static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 {
-	/* For receiving */
-	struct nlattr *na;
+	unsigned char addr[ETH_ALEN];
 	struct net_device *hsr_dev;
-
-	/* For sending */
 	struct sk_buff *skb_out;
-	void *msg_head;
 	struct hsr_priv *hsr;
-	void *pos;
-	unsigned char addr[ETH_ALEN];
+	bool restart = false;
+	struct nlattr *na;
+	void *pos = NULL;
+	void *msg_head;
 	int res;
 
 	if (!info)
@@ -393,8 +391,9 @@ static int hsr_get_node_list(struct sk_b
 	if (!is_hsr_master(hsr_dev))
 		goto rcu_unlock;
 
+restart:
 	/* Send reply */
-	skb_out = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
+	skb_out = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_ATOMIC);
 	if (!skb_out) {
 		res = -ENOMEM;
 		goto fail;
@@ -408,17 +407,28 @@ static int hsr_get_node_list(struct sk_b
 		goto nla_put_failure;
 	}
 
-	res = nla_put_u32(skb_out, HSR_A_IFINDEX, hsr_dev->ifindex);
-	if (res < 0)
-		goto nla_put_failure;
+	if (!restart) {
+		res = nla_put_u32(skb_out, HSR_A_IFINDEX, hsr_dev->ifindex);
+		if (res < 0)
+			goto nla_put_failure;
+	}
 
 	hsr = netdev_priv(hsr_dev);
 
-	pos = hsr_get_next_node(hsr, NULL, addr);
+	if (!pos)
+		pos = hsr_get_next_node(hsr, NULL, addr);
 	while (pos) {
 		res = nla_put(skb_out, HSR_A_NODE_ADDR, ETH_ALEN, addr);
-		if (res < 0)
+		if (res < 0) {
+			if (res == -EMSGSIZE) {
+				genlmsg_end(skb_out, msg_head);
+				genlmsg_unicast(genl_info_net(info), skb_out,
+						info->snd_portid);
+				restart = true;
+				goto restart;
+			}
 			goto nla_put_failure;
+		}
 		pos = hsr_get_next_node(hsr, pos, addr);
 	}
 	rcu_read_unlock();
@@ -435,7 +445,7 @@ invalid:
 	return 0;
 
 nla_put_failure:
-	kfree_skb(skb_out);
+	nlmsg_free(skb_out);
 	/* Fall through */
 
 fail:



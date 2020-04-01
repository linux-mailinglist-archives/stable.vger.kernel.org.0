Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3530019B263
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389459AbgDAQne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:43:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389624AbgDAQnd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:43:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47D3A206F8;
        Wed,  1 Apr 2020 16:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759412;
        bh=qTW48sVpSSSVqkcOsFMpmgPKG8SDdLTyQ5tNGaj3Ijo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkREa2pALV7gE2qTDvSHhR3BRQ1sJLVy9CUuNAISPppENPuAIPkgGUpXJO48bhC9x
         Ji2q11h0eSvR58g7dZ+iffF44FtJcTfadcqFVxCZHo/7dDh+CaGJeFnazFbO2t514e
         C1clxzqPS7Dm5dw9ApQffjiWiKRRFg+3uC7LdKf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 071/148] hsr: add restart routine into hsr_get_node_list()
Date:   Wed,  1 Apr 2020 18:17:43 +0200
Message-Id: <20200401161600.295802833@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
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



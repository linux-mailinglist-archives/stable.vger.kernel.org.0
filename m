Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE903215FB
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhBVMPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:15:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230291AbhBVMOv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:14:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DB2964EF1;
        Mon, 22 Feb 2021 12:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996036;
        bh=tEgMQRN5efLLeumv2XkB4L1vcBdaTZy6qxXvyImfRwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t50GhUA++QV6d2/PgttcvdWx1/7OyJ1H2SRcf0CA40CnanE8sfKuUzIGbTGTknHpO
         V3LRj3KIeZ8foBTUREszypHqinG409RTVsPpqPDBM5fCK4iK77zftwacTI+qwsAKAz
         1sxGVDfPQc9myaKhvpqTkfMSHSrdVMomaY6FcFCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eelco Chaudron <echaudro@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/29] net: openvswitch: fix TTL decrement exception action execution
Date:   Mon, 22 Feb 2021 13:13:07 +0100
Message-Id: <20210222121022.023081351@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
References: <20210222121019.444399883@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

[ Upstream commit 09d6217254c004f6237cc2c2bfe604af58e9a8c5 ]

Currently, the exception actions are not processed correctly as the wrong
dataset is passed. This change fixes this, including the misleading
comment.

In addition, a check was added to make sure we work on an IPv4 packet,
and not just assume if it's not IPv6 it's IPv4.

This was all tested using OVS with patch,
https://patchwork.ozlabs.org/project/openvswitch/list/?series=21639,
applied and sending packets with a TTL of 1 (and 0), both with IPv4
and IPv6.

Fixes: 69929d4c49e1 ("net: openvswitch: fix TTL decrement action netlink message format")
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Link: https://lore.kernel.org/r/160733569860.3007.12938188180387116741.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index c3a664871cb5a..e8902a7e60f24 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -959,16 +959,13 @@ static int dec_ttl_exception_handler(struct datapath *dp, struct sk_buff *skb,
 				     struct sw_flow_key *key,
 				     const struct nlattr *attr, bool last)
 {
-	/* The first action is always 'OVS_DEC_TTL_ATTR_ARG'. */
-	struct nlattr *dec_ttl_arg = nla_data(attr);
+	/* The first attribute is always 'OVS_DEC_TTL_ATTR_ACTION'. */
+	struct nlattr *actions = nla_data(attr);
 
-	if (nla_len(dec_ttl_arg)) {
-		struct nlattr *actions = nla_data(dec_ttl_arg);
+	if (nla_len(actions))
+		return clone_execute(dp, skb, key, 0, nla_data(actions),
+				     nla_len(actions), last, false);
 
-		if (actions)
-			return clone_execute(dp, skb, key, 0, nla_data(actions),
-					     nla_len(actions), last, false);
-	}
 	consume_skb(skb);
 	return 0;
 }
@@ -1212,7 +1209,7 @@ static int execute_dec_ttl(struct sk_buff *skb, struct sw_flow_key *key)
 			return -EHOSTUNREACH;
 
 		key->ip.ttl = --nh->hop_limit;
-	} else {
+	} else if (skb->protocol == htons(ETH_P_IP)) {
 		struct iphdr *nh;
 		u8 old_ttl;
 
-- 
2.27.0




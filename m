Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6CA51A8BA
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347409AbiEDRQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355897AbiEDRIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:08:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD26E51E65;
        Wed,  4 May 2022 09:54:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49C2E618B0;
        Wed,  4 May 2022 16:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9660CC385B2;
        Wed,  4 May 2022 16:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683280;
        bh=J9fKvkWLHDd+6qz2ZBFVcWFT9ooivv7xE+aNdi+7aEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmwT8Lx7GbizdFnTwo5CXpFV/LQF98p4iPkgabP3LOkiR+ZUL79FOXXTHg9E3Ob+K
         3TSnM/qRcCb88ZL8Moeeu9BESBDckGMi+nRzY9xRcUN2W2FddM5INYbTi987gX/G8l
         twTmAGH/uiB2fIQpU9EZngz11MDpZ/Df8HprnLB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, suresh kumar <suresh2514@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/177] bonding: do not discard lowest hash bit for non layer3+4 hashing
Date:   Wed,  4 May 2022 18:45:26 +0200
Message-Id: <20220504153105.084842283@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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

From: suresh kumar <suresh2514@gmail.com>

[ Upstream commit 49aefd131739df552f83c566d0665744c30b1d70 ]

Commit b5f862180d70 was introduced to discard lowest hash bit for layer3+4 hashing
but it also removes last bit from non layer3+4 hashing

Below script shows layer2+3 hashing will result in same slave to be used with above commit.
$ cat hash.py
#/usr/bin/python3.6

h_dests=[0xa0, 0xa1]
h_source=0xe3
hproto=0x8
saddr=0x1e7aa8c0
daddr=0x17aa8c0

for h_dest in h_dests:
    hash = (h_dest ^ h_source ^ hproto ^ saddr ^ daddr)
    hash ^= hash >> 16
    hash ^= hash >> 8
    print(hash)

print("with last bit removed")
for h_dest in h_dests:
    hash = (h_dest ^ h_source ^ hproto ^ saddr ^ daddr)
    hash ^= hash >> 16
    hash ^= hash >> 8
    hash = hash >> 1
    print(hash)

Output:
$ python3.6 hash.py
522133332
522133333   <-------------- will result in both slaves being used

with last bit removed
261066666
261066666   <-------------- only single slave used

Signed-off-by: suresh kumar <suresh2514@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 46c3301a5e07..2e75b7e8f70b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3817,14 +3817,19 @@ static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb, const v
 	return true;
 }
 
-static u32 bond_ip_hash(u32 hash, struct flow_keys *flow)
+static u32 bond_ip_hash(u32 hash, struct flow_keys *flow, int xmit_policy)
 {
 	hash ^= (__force u32)flow_get_u32_dst(flow) ^
 		(__force u32)flow_get_u32_src(flow);
 	hash ^= (hash >> 16);
 	hash ^= (hash >> 8);
+
 	/* discard lowest hash bit to deal with the common even ports pattern */
-	return hash >> 1;
+	if (xmit_policy == BOND_XMIT_POLICY_LAYER34 ||
+		xmit_policy == BOND_XMIT_POLICY_ENCAP34)
+		return hash >> 1;
+
+	return hash;
 }
 
 /* Generate hash based on xmit policy. If @skb is given it is used to linearize
@@ -3854,7 +3859,7 @@ static u32 __bond_xmit_hash(struct bonding *bond, struct sk_buff *skb, const voi
 			memcpy(&hash, &flow.ports.ports, sizeof(hash));
 	}
 
-	return bond_ip_hash(hash, &flow);
+	return bond_ip_hash(hash, &flow, bond->params.xmit_policy);
 }
 
 /**
@@ -5012,7 +5017,7 @@ static u32 bond_sk_hash_l34(struct sock *sk)
 	/* L4 */
 	memcpy(&hash, &flow.ports.ports, sizeof(hash));
 	/* L3 */
-	return bond_ip_hash(hash, &flow);
+	return bond_ip_hash(hash, &flow, BOND_XMIT_POLICY_LAYER34);
 }
 
 static struct net_device *__bond_sk_get_lower_dev(struct bonding *bond,
-- 
2.35.1




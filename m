Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D0463DF6F
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiK3SrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbiK3SrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:47:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8588A25CB
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:47:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A20FB81CA8
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A360C433D6;
        Wed, 30 Nov 2022 18:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834017;
        bh=0O9aV844pV4E7ds65t3MquOYwuQx+b+DUvmp8pE4YTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuwgbOjURHKDWIiNShjH1oNyFwb4jtFKzWNV7PUZDZ6gKYTWfOKNIdHFc616j/3e0
         zKUAA8UiBDE6LIB74KE2+C0ZPalEaIV1q92BtaKMQp9l1l/TTDO5cwsWKP3JDF1Hl8
         yfAtu6dyOxQ2vlP5dBLqjQrmcJDRjCwMMH0bhxo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liang Li <liali@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 098/289] bonding: fix ICMPv6 header handling when receiving IPv6 messages
Date:   Wed, 30 Nov 2022 19:21:23 +0100
Message-Id: <20221130180546.363185838@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 4d633d1b468b6eb107a81b2fd10b9debddca3d47 ]

Currently, we get icmp6hdr via function icmp6_hdr(), which needs the skb
transport header to be set first. But there is no rule to ask driver set
transport header before netif_receive_skb() and bond_handle_frame(). So
we will not able to get correct icmp6hdr on some drivers.

Fix this by using skb_header_pointer to get the IPv6 and ICMPV6 headers.

Reported-by: Liang Li <liali@redhat.com>
Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Link: https://lore.kernel.org/r/20221118034353.1736727-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 86d42306aa5e..76dd5ff1d99d 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3231,16 +3231,23 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 		       struct slave *slave)
 {
 	struct slave *curr_active_slave, *curr_arp_slave;
-	struct icmp6hdr *hdr = icmp6_hdr(skb);
 	struct in6_addr *saddr, *daddr;
+	struct {
+		struct ipv6hdr ip6;
+		struct icmp6hdr icmp6;
+	} *combined, _combined;
 
 	if (skb->pkt_type == PACKET_OTHERHOST ||
-	    skb->pkt_type == PACKET_LOOPBACK ||
-	    hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
+	    skb->pkt_type == PACKET_LOOPBACK)
+		goto out;
+
+	combined = skb_header_pointer(skb, 0, sizeof(_combined), &_combined);
+	if (!combined || combined->ip6.nexthdr != NEXTHDR_ICMP ||
+	    combined->icmp6.icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
 		goto out;
 
-	saddr = &ipv6_hdr(skb)->saddr;
-	daddr = &ipv6_hdr(skb)->daddr;
+	saddr = &combined->ip6.saddr;
+	daddr = &combined->ip6.saddr;
 
 	slave_dbg(bond->dev, slave->dev, "%s: %s/%d av %d sv %d sip %pI6c tip %pI6c\n",
 		  __func__, slave->dev->name, bond_slave_state(slave),
-- 
2.35.1




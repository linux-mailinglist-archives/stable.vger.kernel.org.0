Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C266E647F
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjDRMtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbjDRMtj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:49:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F57E15467
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:49:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F015633F4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F4BC4339B;
        Tue, 18 Apr 2023 12:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822177;
        bh=8HxHUZ0paipYIcK2buACiAf6Z9RNPAeqzIvetxVKEDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1ijDJJrvBwmScF0ILHGG2YjIiodF3LTLmYzTwcjBHuzThMHGlwYrnj5f8pDEHMJE
         0kRGVr6Hxr8RoXfc/1tBpKNjT3GJX2CxePMP9z3E5E6dJ7AZsWIvGnOgzV+VoJ5tIM
         o4w/6qD4eX0p2SwUg5Fns70CnKoLI/vkEaTpIqcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 052/139] bonding: fix ns validation on backup slaves
Date:   Tue, 18 Apr 2023 14:21:57 +0200
Message-Id: <20230418120315.677262718@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 4598380f9c548aa161eb4e990a1583f0a7d1e0d7 ]

When arp_validate is set to 2, 3, or 6, validation is performed for
backup slaves as well. As stated in the bond documentation, validation
involves checking the broadcast ARP request sent out via the active
slave. This helps determine which slaves are more likely to function in
the event of an active slave failure.

However, when the target is an IPv6 address, the NS message sent from
the active interface is not checked on backup slaves. Additionally,
based on the bond_arp_rcv() rule b, we must reverse the saddr and daddr
when checking the NS message.

Note that when checking the NS message, the destination address is a
multicast address. Therefore, we must convert the target address to
solicited multicast in the bond_get_targets_ip6() function.

Prior to the fix, the backup slaves had a mii status of "down", but
after the fix, all of the slaves' mii status was updated to "UP".

Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Reviewed-by: Jonathan Toppins <jtoppins@redhat.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 5 +++--
 include/net/bonding.h           | 8 ++++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 116d295df0b55..415cd95fb140f 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3267,7 +3267,8 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 
 	combined = skb_header_pointer(skb, 0, sizeof(_combined), &_combined);
 	if (!combined || combined->ip6.nexthdr != NEXTHDR_ICMP ||
-	    combined->icmp6.icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
+	    (combined->icmp6.icmp6_type != NDISC_NEIGHBOUR_SOLICITATION &&
+	     combined->icmp6.icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT))
 		goto out;
 
 	saddr = &combined->ip6.saddr;
@@ -3289,7 +3290,7 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 	else if (curr_active_slave &&
 		 time_after(slave_last_rx(bond, curr_active_slave),
 			    curr_active_slave->last_link_up))
-		bond_validate_na(bond, slave, saddr, daddr);
+		bond_validate_na(bond, slave, daddr, saddr);
 	else if (curr_arp_slave &&
 		 bond_time_in_interval(bond, slave_last_tx(curr_arp_slave), 1))
 		bond_validate_na(bond, slave, saddr, daddr);
diff --git a/include/net/bonding.h b/include/net/bonding.h
index ea36ab7f9e724..c3843239517d5 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -761,13 +761,17 @@ static inline int bond_get_targets_ip(__be32 *targets, __be32 ip)
 #if IS_ENABLED(CONFIG_IPV6)
 static inline int bond_get_targets_ip6(struct in6_addr *targets, struct in6_addr *ip)
 {
+	struct in6_addr mcaddr;
 	int i;
 
-	for (i = 0; i < BOND_MAX_NS_TARGETS; i++)
-		if (ipv6_addr_equal(&targets[i], ip))
+	for (i = 0; i < BOND_MAX_NS_TARGETS; i++) {
+		addrconf_addr_solict_mult(&targets[i], &mcaddr);
+		if ((ipv6_addr_equal(&targets[i], ip)) ||
+		    (ipv6_addr_equal(&mcaddr, ip)))
 			return i;
 		else if (ipv6_addr_any(&targets[i]))
 			break;
+	}
 
 	return -1;
 }
-- 
2.39.2




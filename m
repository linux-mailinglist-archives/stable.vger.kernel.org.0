Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A857F6E63F4
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjDRMox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbjDRMov (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:44:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA32167C3
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:44:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC61763374
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3074C4339E;
        Tue, 18 Apr 2023 12:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821889;
        bh=+IovbCe6nuZ9/16o7TlegxIi4CJTUJrV702zCIZVBG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NeVxQdub/mOLk8pNOyx3gxOHCB5N600fRfH0G+Qi8l1OiPnUVHQ2xhGt6Ofi8jYSI
         8r/3aXviAjbVzBtqnj2l3q165E4ISggd2KY3tYGeYqKoXWFJ/hjn5PwMyVqtUBsRbn
         d+UDC6IzmAkHbwIBuA0G5uwSv84WNJFfA6aI8PR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/134] bonding: fix ns validation on backup slaves
Date:   Tue, 18 Apr 2023 14:21:46 +0200
Message-Id: <20230418120314.687539004@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 45d3cb557de73..9f6824a6537bc 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3266,7 +3266,8 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 
 	combined = skb_header_pointer(skb, 0, sizeof(_combined), &_combined);
 	if (!combined || combined->ip6.nexthdr != NEXTHDR_ICMP ||
-	    combined->icmp6.icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
+	    (combined->icmp6.icmp6_type != NDISC_NEIGHBOUR_SOLICITATION &&
+	     combined->icmp6.icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT))
 		goto out;
 
 	saddr = &combined->ip6.saddr;
@@ -3288,7 +3289,7 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 	else if (curr_active_slave &&
 		 time_after(slave_last_rx(bond, curr_active_slave),
 			    curr_active_slave->last_link_up))
-		bond_validate_na(bond, slave, saddr, daddr);
+		bond_validate_na(bond, slave, daddr, saddr);
 	else if (curr_arp_slave &&
 		 bond_time_in_interval(bond, slave_last_tx(curr_arp_slave), 1))
 		bond_validate_na(bond, slave, saddr, daddr);
diff --git a/include/net/bonding.h b/include/net/bonding.h
index e999f851738bd..768348008d0c9 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -765,13 +765,17 @@ static inline int bond_get_targets_ip(__be32 *targets, __be32 ip)
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




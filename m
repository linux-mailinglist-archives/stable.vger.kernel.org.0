Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1981F5B71AE
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbiIMOuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234663AbiIMOtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:49:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECE970E75;
        Tue, 13 Sep 2022 07:25:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF4C9B80F79;
        Tue, 13 Sep 2022 14:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D08CC433C1;
        Tue, 13 Sep 2022 14:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078506;
        bh=qoc8ER+X5UJoBTchz/XY1RzHdHBrZd4mG2/4VfLup4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXLwle8ZNpwcmbXttABWjwKK5z13M0G2hTpYz5eu2zc4MCx1urX/c7q7do1p/Wniy
         M/a8pEOL7folIwjbZvmCE34YKHlUhE/6ABZTFCA5bJHSimiWAw60mBc9HbpkTn2PF1
         uzAX+mtNrizNLchxRZBH73MId8SrNOppXcV1frvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, LiLiang <liali@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 167/192] bonding: accept unsolicited NA message
Date:   Tue, 13 Sep 2022 16:04:33 +0200
Message-Id: <20220913140418.351316425@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 592335a4164c3c41f57967223a1e1efe3a0c6eb3 ]

The unsolicited NA message with all-nodes multicast dest address should
be valid, as this also means the link could reach the target.

Also rename bond_validate_ns() to bond_validate_na().

Reported-by: LiLiang <liali@redhat.com>
Fixes: 5e1eeef69c0f ("bonding: NS target should accept link local address")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 01b58b7e7f165..bff0bfd10e235 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3174,12 +3174,19 @@ static bool bond_has_this_ip6(struct bonding *bond, struct in6_addr *addr)
 	return ret;
 }
 
-static void bond_validate_ns(struct bonding *bond, struct slave *slave,
+static void bond_validate_na(struct bonding *bond, struct slave *slave,
 			     struct in6_addr *saddr, struct in6_addr *daddr)
 {
 	int i;
 
-	if (ipv6_addr_any(saddr) || !bond_has_this_ip6(bond, daddr)) {
+	/* Ignore NAs that:
+	 * 1. Source address is unspecified address.
+	 * 2. Dest address is neither all-nodes multicast address nor
+	 *    exist on bond interface.
+	 */
+	if (ipv6_addr_any(saddr) ||
+	    (!ipv6_addr_equal(daddr, &in6addr_linklocal_allnodes) &&
+	     !bond_has_this_ip6(bond, daddr))) {
 		slave_dbg(bond->dev, slave->dev, "%s: sip %pI6c tip %pI6c not found\n",
 			  __func__, saddr, daddr);
 		return;
@@ -3222,14 +3229,14 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 	 * see bond_arp_rcv().
 	 */
 	if (bond_is_active_slave(slave))
-		bond_validate_ns(bond, slave, saddr, daddr);
+		bond_validate_na(bond, slave, saddr, daddr);
 	else if (curr_active_slave &&
 		 time_after(slave_last_rx(bond, curr_active_slave),
 			    curr_active_slave->last_link_up))
-		bond_validate_ns(bond, slave, saddr, daddr);
+		bond_validate_na(bond, slave, saddr, daddr);
 	else if (curr_arp_slave &&
 		 bond_time_in_interval(bond, slave_last_tx(curr_arp_slave), 1))
-		bond_validate_ns(bond, slave, saddr, daddr);
+		bond_validate_na(bond, slave, saddr, daddr);
 
 out:
 	return RX_HANDLER_ANOTHER;
-- 
2.35.1




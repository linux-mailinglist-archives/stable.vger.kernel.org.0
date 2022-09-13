Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B785B71E0
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiIMOos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbiIMOn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:43:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713076F24A;
        Tue, 13 Sep 2022 07:23:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45A1D614A1;
        Tue, 13 Sep 2022 14:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58152C433D7;
        Tue, 13 Sep 2022 14:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078409;
        bh=ertaICPu9rD0G5DL/tAXz5eR6bbiL2P1iRYD+22RL2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZclMyc+HrH+mxacgM1GUwToqNBpZHU7ADkgYT/slcPgs2PI7h0rYIXkA/WLBfF5HK
         qHdz32zEWwAFLMYPaUtCKFwcRh773DaetGe6aiEWdnFWtQyMZSbeMjO7ExYjzdffXs
         b/Zu75ToZaOPcN+pgu2hVXBGCyUJGYo3PTDcfV2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, LiLiang <liali@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 128/192] bonding: add all node mcast address when slave up
Date:   Tue, 13 Sep 2022 16:03:54 +0200
Message-Id: <20220913140416.382084278@linuxfoundation.org>
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

[ Upstream commit fd16eb948ea8b28afb03e11a5b11841e6ac2aa2b ]

When a link is enslave to bond, it need to set the interface down first.
This makes the slave remove mac multicast address 33:33:00:00:00:01(The
IPv6 multicast address ff02::1 is kept even when the interface down). When
bond set the slave up, ipv6_mc_up() was not called due to commit c2edacf80e15
("bonding / ipv6: no addrconf for slaves separately from master").

This is not an issue before we adding the lladdr target feature for bonding,
as the mac multicast address will be added back when bond interface up and
join group ff02::1.

But after adding lladdr target feature for bonding. When user set a lladdr
target, the unsolicited NA message with all-nodes multicast dest will be
dropped as the slave interface never add 33:33:00:00:00:01 back.

Fix this by calling ipv6_mc_up() to add 33:33:00:00:00:01 back when
the slave interface up.

Reported-by: LiLiang <liali@redhat.com>
Fixes: 5e1eeef69c0f ("bonding: NS target should accept link local address")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b738eb7e1cae8..04cf06866e765 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3557,11 +3557,15 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 		fallthrough;
 	case NETDEV_UP:
 	case NETDEV_CHANGE:
-		if (dev->flags & IFF_SLAVE)
+		if (idev && idev->cnf.disable_ipv6)
 			break;
 
-		if (idev && idev->cnf.disable_ipv6)
+		if (dev->flags & IFF_SLAVE) {
+			if (event == NETDEV_UP && !IS_ERR_OR_NULL(idev) &&
+			    dev->flags & IFF_UP && dev->flags & IFF_MULTICAST)
+				ipv6_mc_up(idev);
 			break;
+		}
 
 		if (event == NETDEV_UP) {
 			/* restore routes for permanent addresses */
-- 
2.35.1




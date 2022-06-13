Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFE0549123
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378305AbiFMNm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379186AbiFMNkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:40:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E5011152;
        Mon, 13 Jun 2022 04:29:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A7533CE110D;
        Mon, 13 Jun 2022 11:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B90C34114;
        Mon, 13 Jun 2022 11:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119769;
        bh=6nQzew8eWXcwJ/e6eQADK+2ZYHZl3QXmSnJJdhl8oDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DninzJh26n7mxupTT4Xm9BlLONLX778jUsUoRKi3GaXRYgZOXiyUDQEoBOCVpJXsB
         j2wKK9U32Ggdx9O2zxpJKWPl0SQRVZ2kN48Y5tMk84jE4DSdUHDf0WtcwNnbW4DZ2f
         Zc3lM0eXH6ubTbCrwTEGt+YryB3rXb9qhFNqVla4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Liang <liali@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 113/339] bonding: NS target should accept link local address
Date:   Mon, 13 Jun 2022 12:08:58 +0200
Message-Id: <20220613094929.938831564@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 5e1eeef69c0fef6249b794bda5d68f95a65d062f ]

When setting bond NS target, we use bond_is_ip6_target_ok() to check
if the address valid. The link local address was wrongly rejected in
bond_changelink(), as most time the user just set the ARP/NS target to
gateway, while the IPv6 gateway is always a link local address when user
set up interface via SLAAC.

So remove the link local addr check when setting bond NS target.

Fixes: 129e3c1bab24 ("bonding: add new option ns_ip6_target")
Reported-by: Li Liang <liali@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Jonathan Toppins <jtoppins@redhat.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_netlink.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index f427fa1737c7..6f404f9c34e3 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -290,11 +290,6 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 
 			addr6 = nla_get_in6_addr(attr);
 
-			if (ipv6_addr_type(&addr6) & IPV6_ADDR_LINKLOCAL) {
-				NL_SET_ERR_MSG(extack, "Invalid IPv6 addr6");
-				return -EINVAL;
-			}
-
 			bond_opt_initextra(&newval, &addr6, sizeof(addr6));
 			err = __bond_opt_set(bond, BOND_OPT_NS_TARGETS,
 					     &newval);
-- 
2.35.1




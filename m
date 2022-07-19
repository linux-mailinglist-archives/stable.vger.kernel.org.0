Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F13579E66
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242659AbiGSNBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243066AbiGSNAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F785071A;
        Tue, 19 Jul 2022 05:25:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F060661912;
        Tue, 19 Jul 2022 12:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD55C36AE2;
        Tue, 19 Jul 2022 12:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233530;
        bh=sLR9GzEa95OpEvmC8G+YIBsFoFoidxpreXI4ynraqzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=18GJi4a1B3SaBEarBbpHnmv4yK65vGE0m6/sMmMG4tTaGXoAFKN0G/VzLrisbR7fz
         5K+Wi+o9XuWpr65ockucQ3/E6WnJfhQNVlADR3KMh2pUb3inFpjOUOdFoWUL/uh+sp
         IsWrZKd1dIFCDfuaZ6HKTiOKrty6f9lUiON4o6Dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 116/231] icmp: Fix a data-race around sysctl_icmp_errors_use_inbound_ifaddr.
Date:   Tue, 19 Jul 2022 13:53:21 +0200
Message-Id: <20220719114724.257227943@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit d2efabce81db7eed1c98fa1a3f203f0edd738ac3 ]

While reading sysctl_icmp_errors_use_inbound_ifaddr, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 1c2fb7f93cb2 ("[IPV4]: Sysctl configurable icmp error source address.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c            | 2 +-
 net/ipv4/sysctl_net_ipv4.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 1a061d10949f..37ba5f042908 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -693,7 +693,7 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 
 		rcu_read_lock();
 		if (rt_is_input_route(rt) &&
-		    net->ipv4.sysctl_icmp_errors_use_inbound_ifaddr)
+		    READ_ONCE(net->ipv4.sysctl_icmp_errors_use_inbound_ifaddr))
 			dev = dev_get_by_index_rcu(net, inet_iif(skb_in));
 
 		if (dev)
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 4cf2a6f560d4..33e65e79e46e 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -639,6 +639,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE
 	},
 	{
 		.procname	= "icmp_ratelimit",
-- 
2.35.1




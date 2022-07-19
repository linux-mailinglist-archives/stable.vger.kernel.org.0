Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29187579C29
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240617AbiGSMgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240744AbiGSMgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:36:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AA0796B7;
        Tue, 19 Jul 2022 05:14:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BECD6178A;
        Tue, 19 Jul 2022 12:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E4BC341C6;
        Tue, 19 Jul 2022 12:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232848;
        bh=iRdcB/QDuKaxQEa1v+agCnxuXz0oKFDO+q7CXH6ZxRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaT9FFf+VAWS9bAhw8Rm7T8U7Pj/iz+MlnjYkrfiVn5na366ejshJqzjbWd4qWJH0
         W0OiXDSwAkLDxFB1GLiSl3sAl6W0EU5ONi3ALf9tbiMlYIeYdouDIys7S16FFxfXE9
         /ZQXGQS1mGutOA/80vD2Qh6G/BtzBb3XlPnqRpJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/167] icmp: Fix a data-race around sysctl_icmp_errors_use_inbound_ifaddr.
Date:   Tue, 19 Jul 2022 13:53:38 +0200
Message-Id: <20220719114704.885929079@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
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
index 6f444b2b7d1a..e40a79bb0a6e 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -702,7 +702,7 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 
 		rcu_read_lock();
 		if (rt_is_input_route(rt) &&
-		    net->ipv4.sysctl_icmp_errors_use_inbound_ifaddr)
+		    READ_ONCE(net->ipv4.sysctl_icmp_errors_use_inbound_ifaddr))
 			dev = dev_get_by_index_rcu(net, inet_iif(skb_in));
 
 		if (dev)
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 51863031b178..49a8167dda87 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -648,6 +648,8 @@ static struct ctl_table ipv4_net_table[] = {
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




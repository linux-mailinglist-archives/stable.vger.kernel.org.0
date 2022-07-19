Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05D8579C79
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241110AbiGSMkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241115AbiGSMiz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:38:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9916129C87;
        Tue, 19 Jul 2022 05:15:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2798F61632;
        Tue, 19 Jul 2022 12:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC670C341C6;
        Tue, 19 Jul 2022 12:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232925;
        bh=ZJSJzrQ/ud2KmT0rXxvBr/bjJ9OiqqmYvcpZppMlgZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ln5qcJl6xbswf32afhJHoiwk+kJrKVUka0xwfoiFud/b3MU7AEqz14TbLt51PNWa1
         0eXKvMHUxw4mAiuQLl3YcURDZssK8kGdr/ZtGR1PGVlblYflbb1RlMTvFpqoUnWUYH
         kN8ShHt3wZL8WqudDKvsUVZHXtg0xIF3eQupKWNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/167] tcp: Fix a data-race around sysctl_tcp_ecn_fallback.
Date:   Tue, 19 Jul 2022 13:53:42 +0200
Message-Id: <20220719114705.231101817@linuxfoundation.org>
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

[ Upstream commit 12b8d9ca7e678abc48195294494f1815b555d658 ]

While reading sysctl_tcp_ecn_fallback, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 492135557dc0 ("tcp: add rfc3168, section 6.1.1.1. fallback")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/sysctl_net_ipv4.c | 2 ++
 net/ipv4/tcp_output.c      | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 49a8167dda87..616658e7c796 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -696,6 +696,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
 	},
 	{
 		.procname	= "ip_dynaddr",
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index dc3b4668fcde..509aab1b7ac9 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -346,7 +346,7 @@ static void tcp_ecn_send_syn(struct sock *sk, struct sk_buff *skb)
 
 static void tcp_ecn_clear_syn(struct sock *sk, struct sk_buff *skb)
 {
-	if (sock_net(sk)->ipv4.sysctl_tcp_ecn_fallback)
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_ecn_fallback))
 		/* tp->ecn_flags are cleared at a later point in time when
 		 * SYN ACK is ultimatively being received.
 		 */
-- 
2.35.1




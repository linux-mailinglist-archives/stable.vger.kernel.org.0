Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939ED582DF1
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbiG0RE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241551AbiG0RE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:04:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D436F7CA;
        Wed, 27 Jul 2022 09:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0B4560B9E;
        Wed, 27 Jul 2022 16:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D383AC433B5;
        Wed, 27 Jul 2022 16:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939951;
        bh=2OV7QM4VRlC9VoPMrR3G1NY2dsKHxkkbtdoeD4eJBoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chvFBWab/OsCzhk9jzeZs/zp4WeoWKyyDpM/Z5+yDrCdzdnT3pXGzcikcdqUFq0CD
         Y1o/WWRJwlGnpucFipSRvaCteggcPjduGjH+in/RanQP+ta2BBaOtjCSHLTKcNYXR9
         s3d9nF+YYn9WwV6IiLM6jflp0xLjNn0B8OiyMY98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/201] ip: Fix data-races around sysctl_ip_no_pmtu_disc.
Date:   Wed, 27 Jul 2022 18:09:18 +0200
Message-Id: <20220727161029.152740326@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 0968d2a441bf6afb551fd99e60fa65ed67068963 ]

While reading sysctl_ip_no_pmtu_disc, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/af_inet.c    | 2 +-
 net/ipv4/icmp.c       | 2 +-
 net/ipv6/af_inet6.c   | 2 +-
 net/xfrm/xfrm_state.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 44f21278003d..781c595f6880 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -338,7 +338,7 @@ static int inet_create(struct net *net, struct socket *sock, int protocol,
 			inet->hdrincl = 1;
 	}
 
-	if (net->ipv4.sysctl_ip_no_pmtu_disc)
+	if (READ_ONCE(net->ipv4.sysctl_ip_no_pmtu_disc))
 		inet->pmtudisc = IP_PMTUDISC_DONT;
 	else
 		inet->pmtudisc = IP_PMTUDISC_WANT;
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index a5cc89506c1e..609c4ff7edc6 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -887,7 +887,7 @@ static bool icmp_unreach(struct sk_buff *skb)
 			 * values please see
 			 * Documentation/networking/ip-sysctl.rst
 			 */
-			switch (net->ipv4.sysctl_ip_no_pmtu_disc) {
+			switch (READ_ONCE(net->ipv4.sysctl_ip_no_pmtu_disc)) {
 			default:
 				net_dbg_ratelimited("%pI4: fragmentation needed and DF set\n",
 						    &iph->daddr);
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index dab4a047590b..3a91d0d40aec 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -226,7 +226,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 	RCU_INIT_POINTER(inet->mc_list, NULL);
 	inet->rcv_tos	= 0;
 
-	if (net->ipv4.sysctl_ip_no_pmtu_disc)
+	if (READ_ONCE(net->ipv4.sysctl_ip_no_pmtu_disc))
 		inet->pmtudisc = IP_PMTUDISC_DONT;
 	else
 		inet->pmtudisc = IP_PMTUDISC_WANT;
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index f7bfa1916968..b1a04a22166f 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2619,7 +2619,7 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 	int err;
 
 	if (family == AF_INET &&
-	    xs_net(x)->ipv4.sysctl_ip_no_pmtu_disc)
+	    READ_ONCE(xs_net(x)->ipv4.sysctl_ip_no_pmtu_disc))
 		x->props.flags |= XFRM_STATE_NOPMTUDISC;
 
 	err = -EPROTONOSUPPORT;
-- 
2.35.1




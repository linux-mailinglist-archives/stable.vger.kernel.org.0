Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B598582DF6
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241361AbiG0RFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241597AbiG0REf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:04:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608A74C63C;
        Wed, 27 Jul 2022 09:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 224FBB821A6;
        Wed, 27 Jul 2022 16:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824CEC433D6;
        Wed, 27 Jul 2022 16:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939956;
        bh=tcohENSnTn9ApzQNJ8s34HgLrmRyd8mviR5F0X8TjaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03ji6bmeSqvep22fdaLDq5zqjFJ/vwCD7wTiPTISFyR1z8K49hX5vAzLPGe+d+jIx
         JfLUViF4QysrgK3XXgIvk3C0oi6RAlILp5EO2YSZn94fMXi4uSW5JixRss5pKzen4+
         jWKRbPxs2BFYmfSVjiEC9A/bRe32GwegnOGxYWpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/201] ip: Fix data-races around sysctl_ip_fwd_use_pmtu.
Date:   Wed, 27 Jul 2022 18:09:19 +0200
Message-Id: <20220727161029.193381837@linuxfoundation.org>
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

[ Upstream commit 60c158dc7b1f0558f6cadd5b50d0386da0000d50 ]

While reading sysctl_ip_fwd_use_pmtu, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: f87c10a8aa1e ("ipv4: introduce ip_dst_mtu_maybe_forward and protect forwarding path against pmtu spoofing")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h | 2 +-
 net/ipv4/route.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index a77a9e1c6c04..c69dd114f367 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -441,7 +441,7 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 	struct net *net = dev_net(dst->dev);
 	unsigned int mtu;
 
-	if (net->ipv4.sysctl_ip_fwd_use_pmtu ||
+	if (READ_ONCE(net->ipv4.sysctl_ip_fwd_use_pmtu) ||
 	    ip_mtu_locked(dst) ||
 	    !forwarding) {
 		mtu = rt->rt_pmtu;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 1db2fda22830..7f08a30256c5 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1404,7 +1404,7 @@ u32 ip_mtu_from_fib_result(struct fib_result *res, __be32 daddr)
 	struct fib_info *fi = res->fi;
 	u32 mtu = 0;
 
-	if (dev_net(dev)->ipv4.sysctl_ip_fwd_use_pmtu ||
+	if (READ_ONCE(dev_net(dev)->ipv4.sysctl_ip_fwd_use_pmtu) ||
 	    fi->fib_metrics->metrics[RTAX_LOCK - 1] & (1 << RTAX_MTU))
 		mtu = fi->fib_mtu;
 
-- 
2.35.1




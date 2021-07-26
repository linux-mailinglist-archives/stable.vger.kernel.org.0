Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F21F3D5F0D
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235799AbhGZPQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:16:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236563AbhGZPLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:11:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BBA160F5B;
        Mon, 26 Jul 2021 15:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314707;
        bh=BodNKQBivTpSayoZMw7qWtVSOamDOsTcfAu9LdcKFHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luaTdS7GLIyF1l2Y6uOvc5Ob+29OmZeV6Q1pOLVrbi47QXW7Ei0cjk5TcxdRKboQe
         0ikRCKumml9bXckj1HZEU2d9tTZ18FjOQ0Zn07sLyffyz0ZysxwHJBL/zPnO32qZ/N
         8fJ9fu19CyFNix1ptP1vn08oy9Jxu79ZR30N8x5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/120] ipv6: fix disable_policy for fwd packets
Date:   Mon, 26 Jul 2021 17:38:33 +0200
Message-Id: <20210726153834.340216674@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit ccd27f05ae7b8ebc40af5b004e94517a919aa862 ]

The goal of commit df789fe75206 ("ipv6: Provide ipv6 version of
"disable_policy" sysctl") was to have the disable_policy from ipv4
available on ipv6.
However, it's not exactly the same mechanism. On IPv4, all packets coming
from an interface, which has disable_policy set, bypass the policy check.
For ipv6, this is done only for local packets, ie for packets destinated to
an address configured on the incoming interface.

Let's align ipv6 with ipv4 so that the 'disable_policy' sysctl has the same
effect for both protocols.

My first approach was to create a new kind of route cache entries, to be
able to set DST_NOPOLICY without modifying routes. This would have added a
lot of code. Because the local delivery path is already handled, I choose
to focus on the forwarding path to minimize code churn.

Fixes: df789fe75206 ("ipv6: Provide ipv6 version of "disable_policy" sysctl")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index aa8f19f852cc..fc36f3b0dceb 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -459,7 +459,9 @@ int ip6_forward(struct sk_buff *skb)
 	if (skb_warn_if_lro(skb))
 		goto drop;
 
-	if (!xfrm6_policy_check(NULL, XFRM_POLICY_FWD, skb)) {
+	if (!net->ipv6.devconf_all->disable_policy &&
+	    !idev->cnf.disable_policy &&
+	    !xfrm6_policy_check(NULL, XFRM_POLICY_FWD, skb)) {
 		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
 		goto drop;
 	}
-- 
2.30.2




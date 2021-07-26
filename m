Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4723D600A
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237024AbhGZPU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237026AbhGZPUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:20:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0604760F6E;
        Mon, 26 Jul 2021 16:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315252;
        bh=hcgH7wMWk/1foFuGFCMmUC4j5wDqeARulTA0YLc3R6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkYin3xNOt/6n+q4GNyTXG1Yq9jdxKhBXCJT0YmCjku6styMh6ot53MAC8+lM64Xn
         HtJelkF8kl9H3xE+wrGjNvTnI6ALb23J5EPojqGptKTXmplAB7IvDS4TfzFhZrOzKm
         f9hgKyEPbLr8N0W5ibfwxYqsSC75y3pETJCEPSzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/167] ipv6: fix disable_policy for fwd packets
Date:   Mon, 26 Jul 2021 17:37:36 +0200
Message-Id: <20210726153840.143102902@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
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
index e889655ca0e2..341d0c7acc8b 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -478,7 +478,9 @@ int ip6_forward(struct sk_buff *skb)
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




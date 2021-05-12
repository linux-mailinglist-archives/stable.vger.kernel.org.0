Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7802637CA8C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241798AbhELQau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238587AbhELQYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:24:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BF20619BE;
        Wed, 12 May 2021 15:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834491;
        bh=sNF3x2SHpTi1o1JTRJkxKOtCsZY/QCGhZ5Ung2zOL+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HByk2pt2s76IHV0curIM70Uko8wyP151Jm8oCEtbj4b17k+fayRFTVJH3q7cgQ5mO
         R1UsnWS6u+V5UOrc1Aqi5nZz3ux4u0ScobNesv4MkbKDBrgrvZdIChkkRNS4v93ugQ
         0M5MkQfNUU2a6IICt6VaNvYAFtUSihqb2JFwjzpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Phillip Potter <phil@philpotter.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 566/601] net: geneve: modify IP header check in geneve6_xmit_skb and geneve_xmit_skb
Date:   Wed, 12 May 2021 16:50:43 +0200
Message-Id: <20210512144846.484314713@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

[ Upstream commit d13f048dd40e8577260cd43faea8ec9b77520197 ]

Modify the header size check in geneve6_xmit_skb and geneve_xmit_skb
to use pskb_inet_may_pull rather than pskb_network_may_pull. This fixes
two kernel selftest failures introduced by the commit introducing the
checks:
IPv4 over geneve6: PMTU exceptions
IPv4 over geneve6: PMTU exceptions - nexthop objects

It does this by correctly accounting for the fact that IPv4 packets may
transit over geneve IPv6 tunnels (and vice versa), and still fixes the
uninit-value bug fixed by the original commit.

Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: 6628ddfec758 ("net: geneve: check skb is large enough for IPv4/IPv6 header")
Suggested-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Acked-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 040edc6fc560..0d8eb4a1dc2f 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -891,7 +891,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
-	if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
+	if (!pskb_inet_may_pull(skb))
 		return -EINVAL;
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
@@ -988,7 +988,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
-	if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
+	if (!pskb_inet_may_pull(skb))
 		return -EINVAL;
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
-- 
2.30.2




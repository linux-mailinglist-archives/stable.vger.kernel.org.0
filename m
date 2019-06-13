Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCCC4402E
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390087AbfFMQDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:03:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731385AbfFMIra (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:47:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAD54206BA;
        Thu, 13 Jun 2019 08:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415649;
        bh=DeNlzJLtA8Ej7mSRIV2Tc6d2E89fV2s+lRmEKvF1UQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHdt8Ncit/0y0uNlqQ7ZudtzAY3DHPi2NeU6mQ5N0tEtG7aBz2fTon65VBePaQInI
         0eFW/6f3SH0vEEX1DR0rYpl9qaw/oMsbhz41G+E6/CQkMw+mT4eHIPb8+/SpWhSNT+
         K3Xba0Ag2O6ZT/gRAtvSIFhlqinQjaJQxa7oNB1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 077/155] netfilter: nf_flow_table: check ttl value in flow offload data path
Date:   Thu, 13 Jun 2019 10:33:09 +0200
Message-Id: <20190613075657.315479856@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 33cc3c0cfa64c86b6c4bbee86997aea638534931 ]

nf_flow_offload_ip_hook() and nf_flow_offload_ipv6_hook() do not check
ttl value. So, ttl value overflow may occur.

Fixes: 97add9f0d66d ("netfilter: flow table support for IPv4")
Fixes: 0995210753a2 ("netfilter: flow table support for IPv6")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 1d291a51cd45..46022a2867d7 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -181,6 +181,9 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	    iph->protocol != IPPROTO_UDP)
 		return -1;
 
+	if (iph->ttl <= 1)
+		return -1;
+
 	thoff = iph->ihl * 4;
 	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
 		return -1;
@@ -411,6 +414,9 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	    ip6h->nexthdr != IPPROTO_UDP)
 		return -1;
 
+	if (ip6h->hop_limit <= 1)
+		return -1;
+
 	thoff = sizeof(*ip6h);
 	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
 		return -1;
-- 
2.20.1




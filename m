Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D8111EB9
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbfEBPj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:39:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728426AbfEBP31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:29:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08341216FD;
        Thu,  2 May 2019 15:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810966;
        bh=bYW8/Xmc7CpnAqWyvgEBWI/CoTdqcYb11ufflwpm/rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjN7Nd/6WCH3oo5f7N5LJAbcIKbfmzmy9sT4bgj/ogI/jVWb6AXQwnfW1bM6chNDB
         /0qpd5wlW1l9IoauLtQVcfBn9k8o6eQ+xuLaVxRYQR3Fnfsr0/qaXxkTeWiljXEwiW
         5pSJHBfM7Z+2BPXQVaS+nJ1tEW04bp31gQO8RmQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Shuang <shuali@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Xin Long <lucien.xin@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Florian Westphal <fw@strlen.de>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 024/101] netfilter: bridge: set skb transport_header before entering NF_INET_PRE_ROUTING
Date:   Thu,  2 May 2019 17:20:26 +0200
Message-Id: <20190502143341.423182462@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e166e4fdaced850bee3d5ee12a5740258fb30587 ]

Since Commit 21d1196a35f5 ("ipv4: set transport header earlier"),
skb->transport_header has been always set before entering INET
netfilter. This patch is to set skb->transport_header for bridge
before entering INET netfilter by bridge-nf-call-iptables.

It also fixes an issue that sctp_error() couldn't compute a right
csum due to unset skb->transport_header.

Fixes: e6d8b64b34aa ("net: sctp: fix and consolidate SCTP checksumming code")
Reported-by: Li Shuang <shuali@redhat.com>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 net/bridge/br_netfilter_hooks.c | 1 +
 net/bridge/br_netfilter_ipv6.c  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 40d058378b52..fc605758323b 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -502,6 +502,7 @@ static unsigned int br_nf_pre_routing(void *priv,
 	nf_bridge->ipv4_daddr = ip_hdr(skb)->daddr;
 
 	skb->protocol = htons(ETH_P_IP);
+	skb->transport_header = skb->network_header + ip_hdr(skb)->ihl * 4;
 
 	NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
 		skb->dev, NULL,
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index 564710f88f93..e88d6641647b 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -235,6 +235,8 @@ unsigned int br_nf_pre_routing_ipv6(void *priv,
 	nf_bridge->ipv6_daddr = ipv6_hdr(skb)->daddr;
 
 	skb->protocol = htons(ETH_P_IPV6);
+	skb->transport_header = skb->network_header + sizeof(struct ipv6hdr);
+
 	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
 		skb->dev, NULL,
 		br_nf_pre_routing_finish_ipv6);
-- 
2.19.1




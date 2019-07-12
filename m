Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36B2866CEF
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbfGLMYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:24:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728144AbfGLMYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:24:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 590122084B;
        Fri, 12 Jul 2019 12:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934273;
        bh=jJIdsp0EhhdWqql7R9UjK47yBHa1g72/qTxDgzXP6Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ynkro9EYy9LTk+cnDNAKKuNUwUE9iqbxg5s9P4O5Jrtr7clhX57RGDm8W36S8nxhG
         pRjPGukFhx/TxMdK3KdjWwOXmX01i5rM5aoYL8JmDdr800X6bJgvB7sOdtFGy/TGtc
         gWhlMCNcEgquZ/Mv09q4g2laD1dXr70N2PqhIpTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 49/91] ip6_tunnel: allow not to count pkts on tstats by passing dev as NULL
Date:   Fri, 12 Jul 2019 14:18:52 +0200
Message-Id: <20190712121624.257889987@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6f6a8622057c92408930c31698394fae1557b188 ]

A similar fix to Patch "ip_tunnel: allow not to count pkts on tstats by
setting skb's dev to NULL" is also needed by ip6_tunnel.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip6_tunnel.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
index 236e40ba06bf..f594eb71c274 100644
--- a/include/net/ip6_tunnel.h
+++ b/include/net/ip6_tunnel.h
@@ -156,9 +156,12 @@ static inline void ip6tunnel_xmit(struct sock *sk, struct sk_buff *skb,
 	memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
 	pkt_len = skb->len - skb_inner_network_offset(skb);
 	err = ip6_local_out(dev_net(skb_dst(skb)->dev), sk, skb);
-	if (unlikely(net_xmit_eval(err)))
-		pkt_len = -1;
-	iptunnel_xmit_stats(dev, pkt_len);
+
+	if (dev) {
+		if (unlikely(net_xmit_eval(err)))
+			pkt_len = -1;
+		iptunnel_xmit_stats(dev, pkt_len);
+	}
 }
 #endif
 #endif
-- 
2.20.1




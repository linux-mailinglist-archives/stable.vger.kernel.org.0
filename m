Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD3E6C614
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391598AbfGRDNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:13:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391597AbfGRDNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:13:09 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B85F205F4;
        Thu, 18 Jul 2019 03:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419589;
        bh=F2P+Yuwxw/g0SuFWpPwa09atz9Iz1QQ2c+V6E8O1Jzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=No83PIsAXoe5Kgsr5nJEzbFXyYroStJKqen+JOnXsFEpx+3P2LNmIKS4wA4ExAJc7
         vOSULEyPpv+Lhx5RsSO/OBwnGgRLGCnxyEYnH0ddh9kV81fa0CnC8fF0Ttf4bSm41K
         C+d5wVbLGmcRc4Cs4prS+PwzFp+fuEirtMrPMs3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 20/54] ip6_tunnel: allow not to count pkts on tstats by passing dev as NULL
Date:   Thu, 18 Jul 2019 12:01:50 +0900
Message-Id: <20190718030050.910095217@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030048.392549994@linuxfoundation.org>
References: <20190718030048.392549994@linuxfoundation.org>
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
index 1b1cf33cbfb0..2b6abd046087 100644
--- a/include/net/ip6_tunnel.h
+++ b/include/net/ip6_tunnel.h
@@ -149,9 +149,12 @@ static inline void ip6tunnel_xmit(struct sock *sk, struct sk_buff *skb,
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




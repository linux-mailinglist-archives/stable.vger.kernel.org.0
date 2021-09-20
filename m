Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0980441261E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348300AbhITSxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385533AbhITSue (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:50:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2C1C63392;
        Mon, 20 Sep 2021 17:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159309;
        bh=gRFSAITfTuC4f8wJ31FrDKiHmtxEGLwA5hnuzmRXpps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKK5+c5e+RtFOWlXg5dpEmJ3it46841pr5498XjOXQZd1gfIVIiZ5A4zSw7iVLQOR
         SlRS026JpCefezDum36nHAL/HKTLHiZgLy6m/HOzL6b0DIyTXtSuGLbnmHW5hsuArG
         VhG2FUsWjD3QZNMy0JEdObi+PO697ZwIwbjmoLng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 165/168] ip6_gre: Revert "ip6_gre: add validation for csum_start"
Date:   Mon, 20 Sep 2021 18:45:03 +0200
Message-Id: <20210920163927.102531590@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit fe63339ef36bfb1cc12962015a9b254170eea057 ]

This reverts commit 9cf448c200ba9935baa94e7a0964598ce947db9d.

This commit was added for equivalence with a similar fix to ip_gre.
That fix proved to have a bug. Upon closer inspection, ip6_gre is not
susceptible to the original bug.

So revert the unnecessary extra check.

In short, ipgre_xmit calls skb_pull to remove ipv4 headers previously
inserted by dev_hard_header. ip6gre_tunnel_xmit does not.

Link: https://lore.kernel.org/netdev/CA+FuTSe+vJgTVLc9SojGuN-f9YQ+xWLPKE_S4f=f+w+_P2hgUg@mail.gmail.com/#t
Fixes: 9cf448c200ba ("ip6_gre: add validation for csum_start")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_gre.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 7a5e90e09363..bc224f917bbd 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -629,8 +629,6 @@ drop:
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
-	if (csum && skb_checksum_start(skb) < skb->data)
-		return -EINVAL;
 	return iptunnel_handle_offloads(skb,
 					csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }
-- 
2.30.2




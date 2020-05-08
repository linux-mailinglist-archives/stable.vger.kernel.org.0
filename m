Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECC81CABDA
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgEHMrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729571AbgEHMrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B9ED221F7;
        Fri,  8 May 2020 12:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942059;
        bh=lAWvsf08nZvSQrfzMExadqGz3aL2prjAHcmVRlzYXZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGNdz8lZwZ3kZY97w3pSEMAvvhh7dn4Stde5hNe0kNCdKG7FNjmuBGtWkcJt4v8+K
         rMLwlOiuDGZH0tvB6/W9/cZz4C2Q0ShogXGUC2AR+We+GQwWrcF9SAf94gAxwSJRAy
         96BL/d5htW9ok+xfgeuasAKfTQ/DeFpJslUCpcR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyeyoon Park <kyeyoonp@codeaurora.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 281/312] net: bridge: dont increment tx_dropped in br_do_proxy_arp
Date:   Fri,  8 May 2020 14:34:32 +0200
Message-Id: <20200508123144.177646487@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

commit 85a3d4a9356b595d5440c3f1bf07ee7cecca1567 upstream.

pskb_may_pull may fail due to various reasons (e.g. alloc failure), but the
skb isn't changed/dropped and processing continues so we shouldn't
increment tx_dropped.

CC: Kyeyoon Park <kyeyoonp@codeaurora.org>
CC: Roopa Prabhu <roopa@cumulusnetworks.com>
CC: Stephen Hemminger <stephen@networkplumber.org>
CC: bridge@lists.linux-foundation.org
Fixes: 958501163ddd ("bridge: Add support for IEEE 802.11 Proxy ARP")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bridge/br_input.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -78,13 +78,10 @@ static void br_do_proxy_arp(struct sk_bu
 
 	BR_INPUT_SKB_CB(skb)->proxyarp_replied = false;
 
-	if (dev->flags & IFF_NOARP)
+	if ((dev->flags & IFF_NOARP) ||
+	    !pskb_may_pull(skb, arp_hdr_len(dev)))
 		return;
 
-	if (!pskb_may_pull(skb, arp_hdr_len(dev))) {
-		dev->stats.tx_dropped++;
-		return;
-	}
 	parp = arp_hdr(skb);
 
 	if (parp->ar_pro != htons(ETH_P_IP) ||



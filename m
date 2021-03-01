Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E55328A06
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbhCASKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:10:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:54156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234860AbhCASDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:03:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADB356511E;
        Mon,  1 Mar 2021 17:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618173;
        bh=452moKIc6TwuzRdS9Pe3ofv+4LHyBGggXPdSMhgEIeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxbmSInmsHsj3vXPtvhpoviSI0IOyRMAYo+gWB0u+JFWnH5rCt4iR585FPRqzo0yz
         gR3t/YTsCmRubHLrgYBt5rYwv8GlNYISSfJbWRUgRI4oZ4F2g7vP2FONXV/Lg8vLhi
         1Vch0KjJPTXz2Q7pMsgNHcqd7E7cQUBmS/alOUCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Shannon Nelson <shannon.nelson@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 333/340] sunvnet: use icmp_ndo_send helper
Date:   Mon,  1 Mar 2021 17:14:37 +0100
Message-Id: <20210301161104.682465910@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 67c9a7e1e3ac491b5df018803639addc36f154ba upstream.

Because sunvnet is calling icmp from network device context, it should use
the ndo helper so that the rate limiting applies correctly. While we're
at it, doing the additional route lookup before calling icmp_ndo_send is
superfluous, since this is the job of the icmp code in the first place.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Shannon Nelson <shannon.nelson@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sun/sunvnet_common.c |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1353,27 +1353,12 @@ sunvnet_start_xmit_common(struct sk_buff
 		if (vio_version_after_eq(&port->vio, 1, 3))
 			localmtu -= VLAN_HLEN;
 
-		if (skb->protocol == htons(ETH_P_IP)) {
-			struct flowi4 fl4;
-			struct rtable *rt = NULL;
-
-			memset(&fl4, 0, sizeof(fl4));
-			fl4.flowi4_oif = dev->ifindex;
-			fl4.flowi4_tos = RT_TOS(ip_hdr(skb)->tos);
-			fl4.daddr = ip_hdr(skb)->daddr;
-			fl4.saddr = ip_hdr(skb)->saddr;
-
-			rt = ip_route_output_key(dev_net(dev), &fl4);
-			if (!IS_ERR(rt)) {
-				skb_dst_set(skb, &rt->dst);
-				icmp_send(skb, ICMP_DEST_UNREACH,
-					  ICMP_FRAG_NEEDED,
-					  htonl(localmtu));
-			}
-		}
+		if (skb->protocol == htons(ETH_P_IP))
+			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
+				      htonl(localmtu));
 #if IS_ENABLED(CONFIG_IPV6)
 		else if (skb->protocol == htons(ETH_P_IPV6))
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, localmtu);
+			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, localmtu);
 #endif
 		goto out_dropped;
 	}



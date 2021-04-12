Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC7835BFE5
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239412AbhDLJHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240325AbhDLJFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:05:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ACF86008E;
        Mon, 12 Apr 2021 09:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218183;
        bh=mdAifZk2zZYG/QNFN9n7LfMQCF+EmY6hI2zzl0Z9Sl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2Uql4CKORsccIYL5670EINJWkc8oT1LLmSPxrsXLwI80v/f6HT1vYy7pXfWTKDza
         GoQ5Ic6RRHGFriqHv8cl1GGz5jVSsi4RaTRxTiVcSE4XX0cL0U81tTl+MwvvTudNLY
         cAosrRJQcND7xLyjZIsXykNuVilH/8vvlbCG6SYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 103/210] xfrm: interface: fix ipv4 pmtu check to honor ip header df
Date:   Mon, 12 Apr 2021 10:40:08 +0200
Message-Id: <20210412084019.442945484@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eyal Birger <eyal.birger@gmail.com>

[ Upstream commit 8fc0e3b6a8666d656923d214e4dc791e9a17164a ]

Frag needed should only be sent if the header enables DF.

This fix allows packets larger than MTU to pass the xfrm interface
and be fragmented after encapsulation, aligning behavior with
non-interface xfrm.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_interface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 697cdcfbb5e1..3f42c2f15ba4 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -305,6 +305,8 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 
 			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 		} else {
+			if (!(ip_hdr(skb)->frag_off & htons(IP_DF)))
+				goto xmit;
 			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 				      htonl(mtu));
 		}
@@ -313,6 +315,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 		return -EMSGSIZE;
 	}
 
+xmit:
 	xfrmi_scrub_packet(skb, !net_eq(xi->net, dev_net(dev)));
 	skb_dst_set(skb, dst);
 	skb->dev = tdev;
-- 
2.30.2




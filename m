Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB3488DDF
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfHJUtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:49:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54574 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726496AbfHJUn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDS-00058M-6R; Sat, 10 Aug 2019 21:43:54 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDP-0003lR-3A; Sat, 10 Aug 2019 21:43:51 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Vladislav Yasevich" <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sabrina Dubroca" <sd@queasysnail.net>,
        "Matt Grant" <matt@mattgrant.net.nz>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.28529511@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 150/157] ipv6: call ipv6_proxy_select_ident instead
 of ipv6_select_ident in udp6_ufo_fragment
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

commit 8e199dfd82ee097b522b00344af6448715d8ee0c upstream.

Matt Grant reported frequent crashes in ipv6_select_ident when
udp6_ufo_fragment is called from openvswitch on a skb that doesn't
have a dst_entry set.

ipv6_proxy_select_ident generates the frag_id without using the dst
associated with the skb.  This approach was suggested by Vladislav
Yasevich.

Fixes: 0508c07f5e0c ("ipv6: Select fragment id during UFO segmentation if not set.")
Cc: Vladislav Yasevich <vyasevic@redhat.com>
Reported-by: Matt Grant <matt@mattgrant.net.nz>
Tested-by: Matt Grant <matt@mattgrant.net.nz>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Acked-by: Vladislav Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/udp_offload.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -124,11 +124,9 @@ static struct sk_buff *udp6_ufo_fragment
 		fptr = (struct frag_hdr *)(skb_network_header(skb) + unfrag_ip6hlen);
 		fptr->nexthdr = nexthdr;
 		fptr->reserved = 0;
-		if (skb_shinfo(skb)->ip6_frag_id)
-			fptr->identification = skb_shinfo(skb)->ip6_frag_id;
-		else
-			ipv6_select_ident(fptr,
-					  (struct rt6_info *)skb_dst(skb));
+		if (!skb_shinfo(skb)->ip6_frag_id)
+			ipv6_proxy_select_ident(skb);
+		fptr->identification = skb_shinfo(skb)->ip6_frag_id;
 
 		/* Fragment the skb. ipv6 header and the remaining fields of the
 		 * fragment header are updated in ipv6_gso_segment()


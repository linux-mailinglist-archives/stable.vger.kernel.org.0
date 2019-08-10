Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713B188DEA
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbfHJUuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:50:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54558 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726736AbfHJUn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDS-00053t-LB; Sat, 10 Aug 2019 21:43:54 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDO-0003l9-Vp; Sat, 10 Aug 2019 21:43:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Vlad Yasevich" <vyasevich@gmail.com>,
        "Vladislav Yasevich" <vyasevic@redhat.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.416808818@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 148/157] ipv6: Fix fragment id assignment on LE arches.
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

From: Vlad Yasevich <vyasevich@gmail.com>

commit 51f30770e50eb787200f30a79105e2615b379334 upstream.

Recent commit:
0508c07f5e0c94f38afd5434e8b2a55b84553077
Author: Vlad Yasevich <vyasevich@gmail.com>
Date:   Tue Feb 3 16:36:15 2015 -0500

    ipv6: Select fragment id during UFO segmentation if not set.

Introduced a bug on LE in how ipv6 fragment id is assigned.
This was cought by nightly sparce check:

Resolve the following sparce error:
 net/ipv6/output_core.c:57:38: sparse: incorrect type in assignment
 (different base types)
   net/ipv6/output_core.c:57:38:    expected restricted __be32
[usertype] ip6_frag_id
   net/ipv6/output_core.c:57:38:    got unsigned int [unsigned]
[assigned] [usertype] id

Fixes: 0508c07f5e0c9 (ipv6: Select fragment id during UFO segmentation if not set.)
Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/output_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -54,7 +54,7 @@ void ipv6_proxy_select_ident(struct sk_b
 
 	id = __ipv6_select_ident(ip6_proxy_idents_hashrnd,
 				 &addrs[1], &addrs[0]);
-	skb_shinfo(skb)->ip6_frag_id = id;
+	skb_shinfo(skb)->ip6_frag_id = htonl(id);
 }
 EXPORT_SYMBOL_GPL(ipv6_proxy_select_ident);
 


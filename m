Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2915E88DEE
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfHJUu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:50:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54518 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726719AbfHJUn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDS-00053L-6K; Sat, 10 Aug 2019 21:43:54 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDP-0003lJ-0l; Sat, 10 Aug 2019 21:43:51 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Vlad Yasevich" <vyasevich@gmail.com>,
        "Vladislav Yasevich" <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.411774246@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 149/157] ipv6: Make __ipv6_select_ident static
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

commit 8381eacf5c3b35cf7755f4bc521c4d56d24c1cd9 upstream.

Make __ipv6_select_ident() static as it isn't used outside
the file.

Fixes: 0508c07f5e0c9 (ipv6: Select fragment id during UFO segmentation if not set.)
Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/ipv6.h     | 2 --
 net/ipv6/output_core.c | 3 ++-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -688,8 +688,6 @@ static inline int ipv6_addr_diff(const s
 	return __ipv6_addr_diff(a1, a2, sizeof(struct in6_addr));
 }
 
-u32 __ipv6_select_ident(u32 hashrnd, struct in6_addr *dst,
-			struct in6_addr *src);
 void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt);
 void ipv6_proxy_select_ident(struct sk_buff *skb);
 
--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -9,7 +9,8 @@
 #include <net/addrconf.h>
 #include <net/secure_seq.h>
 
-u32 __ipv6_select_ident(u32 hashrnd, struct in6_addr *dst, struct in6_addr *src)
+static u32 __ipv6_select_ident(u32 hashrnd, struct in6_addr *dst,
+			       struct in6_addr *src)
 {
 	u32 hash, id;
 


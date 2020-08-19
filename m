Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0979824A794
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 22:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgHSUMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 16:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbgHSUMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 16:12:17 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33013C061757
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 13:12:17 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 3so3388407wmi.1
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 13:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qrQXRn5lOnY3rc4h/MhdAYwAb/oRdgRb50i+BRwPLlY=;
        b=smHpgz7IsNtgl7jq9W9VsX+6ttggz6oJb6oWdSsVjJA25LJOIyogl0n3MJe1FDxGze
         7Ph8UuM/nuVfZCujSW2jJHn37t68hx+LukhhBAUFW27leSkffwImrMqoLeQT0ER2/sBG
         Sl76zSwT24vbi2BD4ZV0pfeX67VLenjrjIOhChLs1Ex6DtS4OCMN3wvHv3xGu4AMUkCy
         7xmW3AKf7D0wBFAGx0v4JyIfPy4h5kAcex9BgXvQrFWIRQDfRFnwakgaOkFa9Z4taoSz
         w5WLzev78lr0bAuE+M+6FAhVfve1CChm372HqyVS7EGNpmlX/AYQ8Uw/fds9clrA31dl
         pASw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qrQXRn5lOnY3rc4h/MhdAYwAb/oRdgRb50i+BRwPLlY=;
        b=ilsOvetUXzN0HBSjhPqdXNv7btdKLVNLqaXqJvkTij7fwonOJSoc6uLF7QU2QY4kg7
         8Pve0DbkoFbsxaqOq6l4nwvWqNvwAzB/J2UWaKyP4zTsc/1mYC7Nf431UVKJi9Ozrn4E
         Ou2PROzgMr2qaGOdQJ2qZvE5AHE8vWw6SGBqT9Bg4ycq+3obuVB/jeU4C3PX88mjKHab
         NmjIxTQTIALpxAcIUgarB0djjGjYsSg90gP0cIDnKDjBHreL6LjAit/EzLEnCqcNZn3Z
         fM8GTiJB1uuDcXIBumUK0X5wysH+VOhny1vYMm1vfT9K/g1yWJLXHavSIbc0qSV/zxTj
         i8vw==
X-Gm-Message-State: AOAM530/+MBvsyJ0ZZAbkAVluZHls81o4ITQBuvtd9D3ZzspcPYbFz1B
        U1/l6TW0eDlK5l4t6KI9c85bgQ==
X-Google-Smtp-Source: ABdhPJyNi0NN5dFpKaUw7hhO1TpYlI3tXeEzIi4jz0mBwVmZTjywxAIjFA/OU39S54EtY5AY+Ed9ig==
X-Received: by 2002:a1c:ddc3:: with SMTP id u186mr14573wmg.72.1597867935874;
        Wed, 19 Aug 2020 13:12:15 -0700 (PDT)
Received: from balsini.lon.corp.google.com ([2a00:79e0:d:210:7220:84ff:fe09:7d5c])
        by smtp.gmail.com with ESMTPSA id t14sm40569209wrv.14.2020.08.19.13.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 13:12:15 -0700 (PDT)
From:   Alessio Balsini <balsini@android.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     WANG Cong <xiyou.wangcong@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        syzbot+01400f5fc51cf4747bec@syzkaller.appspotmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alessio Balsini <balsini@android.com>
Subject: [PATCH 4.4] ipv6: check skb->protocol before lookup for nexthop
Date:   Wed, 19 Aug 2020 21:11:17 +0100
Message-Id: <20200819201117.1511154-1-balsini@android.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: WANG Cong <xiyou.wangcong@gmail.com>

[ Upstream commit 199ab00f3cdb6f154ea93fa76fd80192861a821d ]

Andrey reported a out-of-bound access in ip6_tnl_xmit(), this
is because we use an ipv4 dst in ip6_tnl_xmit() and cast an IPv4
neigh key as an IPv6 address:

        neigh = dst_neigh_lookup(skb_dst(skb),
                                 &ipv6_hdr(skb)->daddr);
        if (!neigh)
                goto tx_err_link_failure;

        addr6 = (struct in6_addr *)&neigh->primary_key; // <=== HERE
        addr_type = ipv6_addr_type(addr6);

        if (addr_type == IPV6_ADDR_ANY)
                addr6 = &ipv6_hdr(skb)->daddr;

        memcpy(&fl6->daddr, addr6, sizeof(fl6->daddr));

Also the network header of the skb at this point should be still IPv4
for 4in6 tunnels, we shold not just use it as IPv6 header.

This patch fixes it by checking if skb->protocol is ETH_P_IPV6: if it
is, we are safe to do the nexthop lookup using skb_dst() and
ipv6_hdr(skb)->daddr; if not (aka IPv4), we have no clue about which
dest address we can pick here, we have to rely on callers to fill it
from tunnel config, so just fall to ip6_route_output() to make the
decision.

Fixes: ea3dc9601bda ("ip6_tunnel: Add support for wildcard tunnel endpoints.")
Reported-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: syzbot+01400f5fc51cf4747bec@syzkaller.appspotmail.com
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Alessio Balsini <balsini@android.com>
---
 net/ipv6/ip6_tunnel.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index f072a4c4575c..96563990d654 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -972,26 +972,28 @@ static int ip6_tnl_xmit2(struct sk_buff *skb,
 
 	/* NBMA tunnel */
 	if (ipv6_addr_any(&t->parms.raddr)) {
-		struct in6_addr *addr6;
-		struct neighbour *neigh;
-		int addr_type;
+		if (skb->protocol == htons(ETH_P_IPV6)) {
+			struct in6_addr *addr6;
+			struct neighbour *neigh;
+			int addr_type;
 
-		if (!skb_dst(skb))
-			goto tx_err_link_failure;
+			if (!skb_dst(skb))
+				goto tx_err_link_failure;
 
-		neigh = dst_neigh_lookup(skb_dst(skb),
-					 &ipv6_hdr(skb)->daddr);
-		if (!neigh)
-			goto tx_err_link_failure;
+			neigh = dst_neigh_lookup(skb_dst(skb),
+						 &ipv6_hdr(skb)->daddr);
+			if (!neigh)
+				goto tx_err_link_failure;
 
-		addr6 = (struct in6_addr *)&neigh->primary_key;
-		addr_type = ipv6_addr_type(addr6);
+			addr6 = (struct in6_addr *)&neigh->primary_key;
+			addr_type = ipv6_addr_type(addr6);
 
-		if (addr_type == IPV6_ADDR_ANY)
-			addr6 = &ipv6_hdr(skb)->daddr;
+			if (addr_type == IPV6_ADDR_ANY)
+				addr6 = &ipv6_hdr(skb)->daddr;
 
-		memcpy(&fl6->daddr, addr6, sizeof(fl6->daddr));
-		neigh_release(neigh);
+			memcpy(&fl6->daddr, addr6, sizeof(fl6->daddr));
+			neigh_release(neigh);
+		}
 	} else if (!fl6->flowi6_mark)
 		dst = dst_cache_get(&t->dst_cache);
 
-- 
2.28.0.297.g1956fa8f8d-goog


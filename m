Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE5E88DEB
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfHJUuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:50:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54538 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726729AbfHJUn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDS-00053P-9R; Sat, 10 Aug 2019 21:43:54 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDP-0003lq-6Q; Sat, 10 Aug 2019 21:43:51 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Rick Jones" <rick.jones2@hp.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.179170197@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 152/157] ipv4: ip_tunnel: use net namespace from
 rtable not socket
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

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 926a882f6916fd76b6f8ee858d45a2241c5e7999 upstream.

The socket parameter might legally be NULL, thus sock_net is sometimes
causing a NULL pointer dereference. Using net_device pointer in dst_entry
is more reliable.

Fixes: b6a7719aedd7e5c ("ipv4: hash net ptr into fragmentation bucket selection")
Reported-by: Rick Jones <rick.jones2@hp.com>
Cc: Rick Jones <rick.jones2@hp.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/ip_tunnel_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -74,7 +74,8 @@ int iptunnel_xmit(struct sock *sk, struc
 	iph->daddr	=	dst;
 	iph->saddr	=	src;
 	iph->ttl	=	ttl;
-	__ip_select_ident(sock_net(sk), iph, skb_shinfo(skb)->gso_segs ?: 1);
+	__ip_select_ident(dev_net(rt->dst.dev), iph,
+			  skb_shinfo(skb)->gso_segs ?: 1);
 
 	err = ip_local_out_sk(sk, skb);
 	if (unlikely(net_xmit_eval(err)))


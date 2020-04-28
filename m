Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675D01BCB4A
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbgD1Szu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728624AbgD1Sbw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:31:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B0B221707;
        Tue, 28 Apr 2020 18:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098712;
        bh=hWXN9y8ptdsh40s+if0S3OWTf+c6ujYtEvSVOBn3IzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rx/gRZmJI9rQw0CVu2SF6dgUB3zbnXdtersBddof3KKih5Wtt98k6DrOx7lTrxD4t
         POsIB0puhffUc2+Ta+970dp/kkIB5n3PEez1ZwT8Rnf9aqIUDmBf5hiKc41Hju8jwk
         sj/MSS46oHPVqQ6LThduo7l8Okuuig5GbEfU+kCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, William Dauchy <w.dauchy@criteo.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 003/168] net, ip_tunnel: fix interface lookup with no key
Date:   Tue, 28 Apr 2020 20:22:57 +0200
Message-Id: <20200428182232.126333532@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Dauchy <w.dauchy@criteo.com>

commit 25629fdaff2ff509dd0b3f5ff93d70a75e79e0a1 upstream.

when creating a new ipip interface with no local/remote configuration,
the lookup is done with TUNNEL_NO_KEY flag, making it impossible to
match the new interface (only possible match being fallback or metada
case interface); e.g: `ip link add tunl1 type ipip dev eth0`

To fix this case, adding a flag check before the key comparison so we
permit to match an interface with no local/remote config; it also avoids
breaking possible userland tools relying on TUNNEL_NO_KEY flag and
uninitialised key.

context being on my side, I'm creating an extra ipip interface attached
to the physical one, and moving it to a dedicated namespace.

Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Signed-off-by: William Dauchy <w.dauchy@criteo.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/ip_tunnel.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -142,11 +142,8 @@ struct ip_tunnel *ip_tunnel_lookup(struc
 			cand = t;
 	}
 
-	if (flags & TUNNEL_NO_KEY)
-		goto skip_key_lookup;
-
 	hlist_for_each_entry_rcu(t, head, hash_node) {
-		if (t->parms.i_key != key ||
+		if ((!(flags & TUNNEL_NO_KEY) && t->parms.i_key != key) ||
 		    t->parms.iph.saddr != 0 ||
 		    t->parms.iph.daddr != 0 ||
 		    !(t->dev->flags & IFF_UP))
@@ -158,7 +155,6 @@ struct ip_tunnel *ip_tunnel_lookup(struc
 			cand = t;
 	}
 
-skip_key_lookup:
 	if (cand)
 		return cand;
 



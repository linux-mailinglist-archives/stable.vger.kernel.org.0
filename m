Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB7885CB57
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbfGBIH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:07:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728252AbfGBIH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:07:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAED0206A2;
        Tue,  2 Jul 2019 08:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054847;
        bh=yiP3Sq6ymMeBy7v+5x8iXCXmnDROKysut4vXujWK5R0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bqd3P0BPrvbgQTIfz2su3Jnb9Un4Q2iVJaaPhtcC0itq4bHit5r40vtTFjbbbzga2
         lj2QkeUMU+nGWofV8GMU5NQK8bGO7CSLtZvl7ULB8k0mSeqzTXIh2BMngatTzE3+aE
         kluzOf/scqPLCkMHbkx1uFY10Gvj4VsAjSLImxAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 52/72] ipv4: Use return value of inet_iif() for __raw_v4_lookup in the while loop
Date:   Tue,  2 Jul 2019 10:01:53 +0200
Message-Id: <20190702080127.284904613@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>

[ Upstream commit 38c73529de13e1e10914de7030b659a2f8b01c3b ]

In commit 19e4e768064a8 ("ipv4: Fix raw socket lookup for local
traffic"), the dif argument to __raw_v4_lookup() is coming from the
returned value of inet_iif() but the change was done only for the first
lookup. Subsequent lookups in the while loop still use skb->dev->ifIndex.

Fixes: 19e4e768064a8 ("ipv4: Fix raw socket lookup for local traffic")
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/raw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -202,7 +202,7 @@ static int raw_v4_input(struct sk_buff *
 		}
 		sk = __raw_v4_lookup(net, sk_next(sk), iph->protocol,
 				     iph->saddr, iph->daddr,
-				     skb->dev->ifindex, sdif);
+				     dif, sdif);
 	}
 out:
 	read_unlock(&raw_v4_hashinfo.lock);



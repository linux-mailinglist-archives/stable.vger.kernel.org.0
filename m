Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4590B5CB12
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbfGBIKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728905AbfGBIKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:10:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD5D3206A2;
        Tue,  2 Jul 2019 08:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562055051;
        bh=yiP3Sq6ymMeBy7v+5x8iXCXmnDROKysut4vXujWK5R0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8oRPAZh2dsn1YmnLgfrjSEdHCgOyBwiM8EVvlq5Ji5VIcg1KuibgqWtVNPfCLv+O
         aICl+c5A2N961hj6Js05r6KjMyNY1oJXVJFNc+5eE9ly7g1nuhQwRwbMF22QfMF3xj
         QnlLWhPqiRh6GemOM4GwtILxea9KigcTu/eDYHg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 28/43] ipv4: Use return value of inet_iif() for __raw_v4_lookup in the while loop
Date:   Tue,  2 Jul 2019 10:02:08 +0200
Message-Id: <20190702080125.298555992@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
References: <20190702080123.904399496@linuxfoundation.org>
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



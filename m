Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C5EA8FE4
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388882AbfIDSG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388874AbfIDSG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:06:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46BC723400;
        Wed,  4 Sep 2019 18:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620387;
        bh=Q9c7BQ7RGkcTXElK5aKWVVoxFQJZ9lZOK80sIY6jcRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jAlGVgVSwXQ7UgCyKx0thBfmuqeN3MzdPunjXrYi0fNp5nnOhf2uHIy4s8waDKlo7
         ZvxXSc+R7r5QfkYMRFlNGLRxNOTz5MVC9clVEasuyte1dtek5NA1S9vRyoiYW5VFrF
         gsXYon1MaBmykPK/D4rcLPMbu7IkNuiSCCpMjOe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Julian Anastasov <ja@ssi.bg>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 38/93] ipv4/icmp: fix rt dst dev null pointer dereference
Date:   Wed,  4 Sep 2019 19:53:40 +0200
Message-Id: <20190904175306.522557233@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit e2c693934194fd3b4e795635934883354c06ebc9 ]

In __icmp_send() there is a possibility that the rt->dst.dev is NULL,
e,g, with tunnel collect_md mode, which will cause kernel crash.
Here is what the code path looks like, for GRE:

- ip6gre_tunnel_xmit
  - ip6gre_xmit_ipv4
    - __gre6_xmit
      - ip6_tnl_xmit
        - if skb->len - t->tun_hlen - eth_hlen > mtu; return -EMSGSIZE
    - icmp_send
      - net = dev_net(rt->dst.dev); <-- here

The reason is __metadata_dst_init() init dst->dev to NULL by default.
We could not fix it in __metadata_dst_init() as there is no dev supplied.
On the other hand, the reason we need rt->dst.dev is to get the net.
So we can just try get it from skb->dev when rt->dst.dev is NULL.

v4: Julian Anastasov remind skb->dev also could be NULL. We'd better
still use dst.dev and do a check to avoid crash.

v3: No changes.

v2: fix the issue in __icmp_send() instead of updating shared dst dev
in {ip_md, ip6}_tunnel_xmit.

Fixes: c8b34e680a09 ("ip_tunnel: Add tnl_update_pmtu in ip_md_tunnel_xmit")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/icmp.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -587,7 +587,13 @@ void __icmp_send(struct sk_buff *skb_in,
 
 	if (!rt)
 		goto out;
-	net = dev_net(rt->dst.dev);
+
+	if (rt->dst.dev)
+		net = dev_net(rt->dst.dev);
+	else if (skb_in->dev)
+		net = dev_net(skb_in->dev);
+	else
+		goto out;
 
 	/*
 	 *	Find the original header. It is expected to be valid, of course.



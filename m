Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10441CAB2F
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgEHMlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728779AbgEHMlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0040320731;
        Fri,  8 May 2020 12:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941665;
        bh=7WNCl6dTYw0a32ibN6iTf84kdFDF1dAkXtEfvhpDzXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scxpoMsuj0gBMYe+ltXYc271X98zi1xpczkbHYj3W46aQO/3AdoGEKlOFe08rNbKd
         y8f13IiB2KDZiJaYEZPutAY8JGVkCqaiZSKutej/eOTinwvTuvrm5IziOPuFW0BJ4Z
         9Gc2XSlPrI/6Ko3h+gmgEvf5gLeyBNHKgOoBLJc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kodanev <alexey.kodanev@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.4 123/312] net/xfrm_input: fix possible NULL deref of tunnel.ip6->parms.i_key
Date:   Fri,  8 May 2020 14:31:54 +0200
Message-Id: <20200508123133.108492280@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kodanev <alexey.kodanev@oracle.com>

commit 1625f4529957738be7d87cf157e107b8fb9d23b9 upstream.

Running LTP 'icmp-uni-basic.sh -6 -p ipcomp -m tunnel' test over
openvswitch + veth can trigger kernel panic:

  BUG: unable to handle kernel NULL pointer dereference
  at 00000000000000e0 IP: [<ffffffff8169d1d2>] xfrm_input+0x82/0x750
  ...
  [<ffffffff816d472e>] xfrm6_rcv_spi+0x1e/0x20
  [<ffffffffa082c3c2>] xfrm6_tunnel_rcv+0x42/0x50 [xfrm6_tunnel]
  [<ffffffffa082727e>] tunnel6_rcv+0x3e/0x8c [tunnel6]
  [<ffffffff8169f365>] ip6_input_finish+0xd5/0x430
  [<ffffffff8169fc53>] ip6_input+0x33/0x90
  [<ffffffff8169f1d5>] ip6_rcv_finish+0xa5/0xb0
  ...

It seems that tunnel.ip6 can have garbage values and also dereferenced
without a proper check, only tunnel.ip4 is being verified. Fix it by
adding one more if block for AF_INET6 and initialize tunnel.ip6 with NULL
inside xfrm6_rcv_spi() (which is similar to xfrm4_rcv_spi()).

Fixes: 049f8e2 ("xfrm: Override skb->mark with tunnel->parm.i_key in xfrm_input")

Signed-off-by: Alexey Kodanev <alexey.kodanev@oracle.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/xfrm6_input.c |    1 +
 net/xfrm/xfrm_input.c  |   14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -23,6 +23,7 @@ int xfrm6_extract_input(struct xfrm_stat
 
 int xfrm6_rcv_spi(struct sk_buff *skb, int nexthdr, __be32 spi)
 {
+	XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6 = NULL;
 	XFRM_SPI_SKB_CB(skb)->family = AF_INET6;
 	XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct ipv6hdr, daddr);
 	return xfrm_input(skb, nexthdr, spi, 0);
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -207,15 +207,15 @@ int xfrm_input(struct sk_buff *skb, int
 	family = XFRM_SPI_SKB_CB(skb)->family;
 
 	/* if tunnel is present override skb->mark value with tunnel i_key */
-	if (XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4) {
-		switch (family) {
-		case AF_INET:
+	switch (family) {
+	case AF_INET:
+		if (XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4)
 			mark = be32_to_cpu(XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4->parms.i_key);
-			break;
-		case AF_INET6:
+		break;
+	case AF_INET6:
+		if (XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6)
 			mark = be32_to_cpu(XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6->parms.i_key);
-			break;
-		}
+		break;
 	}
 
 	/* Allocate new secpath or COW existing one. */



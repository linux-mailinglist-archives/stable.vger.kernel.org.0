Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 970412883C
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390757AbfEWTXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390093AbfEWTXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:23:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E501217D9;
        Thu, 23 May 2019 19:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639427;
        bh=5hGuj9oFWG/ByC/GC9bzr93Du0SHDhKObtmeCXi1iI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqovKEY5Dary4hBed73ZCJK2obCthbHiT0va7oJ4mAGnyuwP8mhV3aVXy/ymD4gUV
         9Xcxr5fD9Bt3HNFVWbxw3JKZlOJP9VCxGZvS9H1Va5yJbuxgu0Hpzccss6kuo4aA/n
         76WxY9SaiXQD3mmLfOsxNudSiEz/lRU7d8Hn9lUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b69368fd933c6c592f4c@syzkaller.appspotmail.com,
        Myungho Jung <mhjungk@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 101/139] xfrm: Reset secpath in xfrm failure
Date:   Thu, 23 May 2019 21:06:29 +0200
Message-Id: <20190523181733.613808391@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6ed69184ed9c43873b8a1ee721e3bf3c08c2c6be ]

In esp4_gro_receive() and esp6_gro_receive(), secpath can be allocated
without adding xfrm state to xvec. Then, sp->xvec[sp->len - 1] would
fail and result in dereferencing invalid pointer in esp4_gso_segment()
and esp6_gso_segment(). Reset secpath if xfrm function returns error.

Fixes: 7785bba299a8 ("esp: Add a software GRO codepath")
Reported-by: syzbot+b69368fd933c6c592f4c@syzkaller.appspotmail.com
Signed-off-by: Myungho Jung <mhjungk@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4_offload.c | 8 +++++---
 net/ipv6/esp6_offload.c | 8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 8756e0e790d2a..d3170a8001b2a 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -52,13 +52,13 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 			goto out;
 
 		if (sp->len == XFRM_MAX_DEPTH)
-			goto out;
+			goto out_reset;
 
 		x = xfrm_state_lookup(dev_net(skb->dev), skb->mark,
 				      (xfrm_address_t *)&ip_hdr(skb)->daddr,
 				      spi, IPPROTO_ESP, AF_INET);
 		if (!x)
-			goto out;
+			goto out_reset;
 
 		sp->xvec[sp->len++] = x;
 		sp->olen++;
@@ -66,7 +66,7 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 		xo = xfrm_offload(skb);
 		if (!xo) {
 			xfrm_state_put(x);
-			goto out;
+			goto out_reset;
 		}
 	}
 
@@ -82,6 +82,8 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 	xfrm_input(skb, IPPROTO_ESP, spi, -2);
 
 	return ERR_PTR(-EINPROGRESS);
+out_reset:
+	secpath_reset(skb);
 out:
 	skb_push(skb, offset);
 	NAPI_GRO_CB(skb)->same_flow = 0;
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index d46b4eb645c2e..cb99f6fb79b79 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -74,13 +74,13 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 			goto out;
 
 		if (sp->len == XFRM_MAX_DEPTH)
-			goto out;
+			goto out_reset;
 
 		x = xfrm_state_lookup(dev_net(skb->dev), skb->mark,
 				      (xfrm_address_t *)&ipv6_hdr(skb)->daddr,
 				      spi, IPPROTO_ESP, AF_INET6);
 		if (!x)
-			goto out;
+			goto out_reset;
 
 		sp->xvec[sp->len++] = x;
 		sp->olen++;
@@ -88,7 +88,7 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 		xo = xfrm_offload(skb);
 		if (!xo) {
 			xfrm_state_put(x);
-			goto out;
+			goto out_reset;
 		}
 	}
 
@@ -109,6 +109,8 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 	xfrm_input(skb, IPPROTO_ESP, spi, -2);
 
 	return ERR_PTR(-EINPROGRESS);
+out_reset:
+	secpath_reset(skb);
 out:
 	skb_push(skb, offset);
 	NAPI_GRO_CB(skb)->same_flow = 0;
-- 
2.20.1




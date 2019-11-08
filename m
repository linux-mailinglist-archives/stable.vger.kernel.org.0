Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF60F54B4
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730923AbfKHSwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:52:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726394AbfKHSwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:52:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC88321924;
        Fri,  8 Nov 2019 18:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239141;
        bh=H8DwnQzxdmC9AtSbI+5z2WagDrrcQST/upFS0U/jWFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EwUxXEhECjHavc8EFErsY3t2pDqC3cMf45FRF2crPUWedRnvF2PrrTdDHNwOGh6kF
         o0qdfT66UKfnh7QoH4sY/36UN/K2W0OGwgr+Xwlq0s472KZQo+Yq6+7A9tw7Gw12Y8
         55wmeHlQgRZBtdLw3a3N9I5eigj8T2ZVJ+mGpkyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Thiemo Nagel <tnagel@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 14/75] dccp: do not leak jiffies on the wire
Date:   Fri,  8 Nov 2019 19:49:31 +0100
Message-Id: <20191108174721.443137907@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3d1e5039f5f87a8731202ceca08764ee7cb010d3 ]

For some reason I missed the case of DCCP passive
flows in my previous patch.

Fixes: a904a0693c18 ("inet: stop leaking jiffies on the wire")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Thiemo Nagel <tnagel@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dccp/ipv4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -417,7 +417,7 @@ struct sock *dccp_v4_request_recv_sock(c
 	RCU_INIT_POINTER(newinet->inet_opt, rcu_dereference(ireq->ireq_opt));
 	newinet->mc_index  = inet_iif(skb);
 	newinet->mc_ttl	   = ip_hdr(skb)->ttl;
-	newinet->inet_id   = jiffies;
+	newinet->inet_id   = prandom_u32();
 
 	if (dst == NULL && (dst = inet_csk_route_child_sock(sk, newsk, req)) == NULL)
 		goto put_and_exit;



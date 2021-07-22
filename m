Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1818F3D2808
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhGVPyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:54:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230502AbhGVPyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:54:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 124F560FDA;
        Thu, 22 Jul 2021 16:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971695;
        bh=BrVAGLnIpsRW8HJXZQkZV4ygSItkFqaNFTNVaRp/stQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IC9AKlZFFoHcxZLQRdAaNOw5FeLgTiUJ6fsdA5aY0PZmZhcHa9zxezeKR2cggRz+S
         ct8ZzH52vL1eFuQxHC56mfFkwyJyES1+cAjI6s/ZY/Hk3pI/sft9XPyYdBvtzy/5vB
         ws7yAs22FBIB2f21Lqw2XPB1t6AcTpDex8762DzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Ovechkin <ovov@yandex-team.ru>,
        Dmitry Yakunin <zeil@yandex-team.ru>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 63/71] net: send SYNACK packet with accepted fwmark
Date:   Thu, 22 Jul 2021 18:31:38 +0200
Message-Id: <20210722155620.001286938@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Ovechkin <ovov@yandex-team.ru>

commit 43b90bfad34bcb81b8a5bc7dc650800f4be1787e upstream.

commit e05a90ec9e16 ("net: reflect mark on tcp syn ack packets")
fixed IPv4 only.

This part is for the IPv6 side.

Fixes: e05a90ec9e16 ("net: reflect mark on tcp syn ack packets")
Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/tcp_ipv6.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -513,8 +513,8 @@ static int tcp_v6_send_synack(const stru
 		opt = ireq->ipv6_opt;
 		if (!opt)
 			opt = rcu_dereference(np->opt);
-		err = ip6_xmit(sk, skb, fl6, sk->sk_mark, opt, np->tclass,
-			       sk->sk_priority);
+		err = ip6_xmit(sk, skb, fl6, skb->mark ? : sk->sk_mark, opt,
+			       np->tclass, sk->sk_priority);
 		rcu_read_unlock();
 		err = net_xmit_eval(err);
 	}



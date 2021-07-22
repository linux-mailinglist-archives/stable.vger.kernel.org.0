Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20153D2919
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhGVQBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233578AbhGVP7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:59:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61E3061396;
        Thu, 22 Jul 2021 16:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971996;
        bh=xRfrSwOkKdlgNeMPUobboihd/W6Af5BoXt2BvE87T+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kd1wO8owIQKxUnt+5ZLzR5tf7Joaf9mh+WQb7uwHEx7YCfEhFF68MCcbJqp6GkKDo
         d5hGZ7CHrMi2ZFuL4yK4WoXiqljZgCqXxXViI/u0aAXs6096tOdzJ8J4p4UjJw6oXp
         XErOIFO2yes0y0UdCiQKB1PzDN6+MT05jMXxJXyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Ovechkin <ovov@yandex-team.ru>,
        Dmitry Yakunin <zeil@yandex-team.ru>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 106/125] net: send SYNACK packet with accepted fwmark
Date:   Thu, 22 Jul 2021 18:31:37 +0200
Message-Id: <20210722155628.222212323@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
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
 net/ipv6/tcp_ipv6.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -540,7 +540,7 @@ static int tcp_v6_send_synack(const stru
 		opt = ireq->ipv6_opt;
 		if (!opt)
 			opt = rcu_dereference(np->opt);
-		err = ip6_xmit(sk, skb, fl6, sk->sk_mark, opt,
+		err = ip6_xmit(sk, skb, fl6, skb->mark ? : sk->sk_mark, opt,
 			       tclass, sk->sk_priority);
 		rcu_read_unlock();
 		err = net_xmit_eval(err);



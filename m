Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443563D5EB8
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbhGZPLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237180AbhGZPK0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:10:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 417A86056C;
        Mon, 26 Jul 2021 15:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314654;
        bh=MCUk/4xCQ64cGWhnPZRBTtvoj9nAiQcd6m6fQ/aOeZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jcSpXLHV+FofZzgkMbKim+/VE5MIVWhw6vPA3h0mmN/09WlR3P+ybrW4A1EOEYPG2
         WUoV1ypzs3OQgOebg0oT6MGXAwrX2ZQB3Nuo7bDJHmH5tbNFl3iyazYO9Scgc741f0
         p8/jpbFCpQqehCY2bMDh/cJ+SFV/0AE9xaslZJOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Ovechkin <ovov@yandex-team.ru>,
        Dmitry Yakunin <zeil@yandex-team.ru>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 045/120] net: send SYNACK packet with accepted fwmark
Date:   Mon, 26 Jul 2021 17:38:17 +0200
Message-Id: <20210726153833.840336133@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
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
 net/ipv6/tcp_ipv6.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -503,7 +503,8 @@ static int tcp_v6_send_synack(const stru
 		opt = ireq->ipv6_opt;
 		if (!opt)
 			opt = rcu_dereference(np->opt);
-		err = ip6_xmit(sk, skb, fl6, sk->sk_mark, opt, np->tclass);
+		err = ip6_xmit(sk, skb, fl6, skb->mark ? : sk->sk_mark, opt,
+			       np->tclass);
 		rcu_read_unlock();
 		err = net_xmit_eval(err);
 	}



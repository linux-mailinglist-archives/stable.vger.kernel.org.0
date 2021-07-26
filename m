Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B423D5E3D
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhGZPG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235680AbhGZPGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:06:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED5D760F5B;
        Mon, 26 Jul 2021 15:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314389;
        bh=YrKWOLQFmUGWfXJuHLIh9O4HXMTVuGakYxUgEm6Caa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yPt2INw6krAUyQC8gjoHMFeBxcuITIuGokuQzgbQILu0oun4nuDoX1HDtS0WLofEh
         ZAwax7z2NuBMV4aoj69tQ3my5E01crTnM4V3fRU1BiQI2iYKPVyfME+wDAKHv6bDBF
         fQYx6QjFqE3ZIMd9ezPvcXizFbcLywRjj9fj8skQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Ovechkin <ovov@yandex-team.ru>,
        Dmitry Yakunin <zeil@yandex-team.ru>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 30/82] net: send SYNACK packet with accepted fwmark
Date:   Mon, 26 Jul 2021 17:38:30 +0200
Message-Id: <20210726153829.147015089@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
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
@@ -486,7 +486,8 @@ static int tcp_v6_send_synack(const stru
 		opt = ireq->ipv6_opt;
 		if (!opt)
 			opt = rcu_dereference(np->opt);
-		err = ip6_xmit(sk, skb, fl6, sk->sk_mark, opt, np->tclass);
+		err = ip6_xmit(sk, skb, fl6, skb->mark ? : sk->sk_mark, opt,
+			       np->tclass);
 		rcu_read_unlock();
 		err = net_xmit_eval(err);
 	}



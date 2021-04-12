Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADDF435C0BF
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241356AbhDLJPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240690AbhDLJKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 958126135C;
        Mon, 12 Apr 2021 09:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218379;
        bh=aIWSXVPs/ssgdoRjvq1cQKyT8rYYsx9cBo3Abtpr+GA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a2CqrtOwiX+x5oOvsuPVq0QH8wEvf8jc2/sLCCt6KRCxrzUxo7PX3drCa3MyUq1UB
         iREJgZKZ32XX51Ni9kqTC+FTRPLQPGTpFf6ym1tUiuZ1IqSuKPM09G1KjBQbtHlkn9
         hPXaj3TmCfMH54cjovJV/IEKWwv5UgBF8sfq1Q4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Shuang <shuali@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 176/210] tipc: increment the tmp aead refcnt before attaching it
Date:   Mon, 12 Apr 2021 10:41:21 +0200
Message-Id: <20210412084021.881024941@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 2a2403ca3add03f542f6b34bef9f74649969b06d ]

Li Shuang found a NULL pointer dereference crash in her testing:

  [] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
  [] RIP: 0010:tipc_crypto_rcv_complete+0xc8/0x7e0 [tipc]
  [] Call Trace:
  []  <IRQ>
  []  tipc_crypto_rcv+0x2d9/0x8f0 [tipc]
  []  tipc_rcv+0x2fc/0x1120 [tipc]
  []  tipc_udp_recv+0xc6/0x1e0 [tipc]
  []  udpv6_queue_rcv_one_skb+0x16a/0x460
  []  udp6_unicast_rcv_skb.isra.35+0x41/0xa0
  []  ip6_protocol_deliver_rcu+0x23b/0x4c0
  []  ip6_input+0x3d/0xb0
  []  ipv6_rcv+0x395/0x510
  []  __netif_receive_skb_core+0x5fc/0xc40

This is caused by NULL returned by tipc_aead_get(), and then crashed when
dereferencing it later in tipc_crypto_rcv_complete(). This might happen
when tipc_crypto_rcv_complete() is called by two threads at the same time:
the tmp attached by tipc_crypto_key_attach() in one thread may be released
by the one attached by that in the other thread.

This patch is to fix it by incrementing the tmp's refcnt before attaching
it instead of calling tipc_aead_get() after attaching it.

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index f4fca8f7f63f..97710ce36047 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -1941,12 +1941,13 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 			goto rcv;
 		if (tipc_aead_clone(&tmp, aead) < 0)
 			goto rcv;
+		WARN_ON(!refcount_inc_not_zero(&tmp->refcnt));
 		if (tipc_crypto_key_attach(rx, tmp, ehdr->tx_key, false) < 0) {
 			tipc_aead_free(&tmp->rcu);
 			goto rcv;
 		}
 		tipc_aead_put(aead);
-		aead = tipc_aead_get(tmp);
+		aead = tmp;
 	}
 
 	if (unlikely(err)) {
-- 
2.30.2




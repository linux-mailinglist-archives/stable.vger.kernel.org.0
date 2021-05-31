Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A89C396085
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbhEaO1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:27:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233877AbhEaOZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:25:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB6D861582;
        Mon, 31 May 2021 13:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468813;
        bh=uuSa62LUBG+sg8P1mQOXGE60OHymgz7NnUAAnjDaNZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wy8+OgpeNHOEOFRpIrpSBtGAdrRkxOvvF/LQS7F5hsjS0SjSTKrIhuZQqKC9bhZxh
         PQjidz3xSd37muNBLsJEL3XtjepxXtW+uGindW9gnHsi8FpVPMRMfik+KDM9rtChW4
         s9cTa1xpWqP6Egc80EzCEcbdw6QKzds4SlW39tgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 139/177] net: really orphan skbs tied to closing sk
Date:   Mon, 31 May 2021 15:14:56 +0200
Message-Id: <20210531130652.738472172@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 098116e7e640ba677d9e345cbee83d253c13d556 ]

If the owing socket is shutting down - e.g. the sock reference
count already dropped to 0 and only sk_wmem_alloc is keeping
the sock alive, skb_orphan_partial() becomes a no-op.

When forwarding packets over veth with GRO enabled, the above
causes refcount errors.

This change addresses the issue with a plain skb_orphan() call
in the critical scenario.

Fixes: 9adc89af724f ("net: let skb_orphan_partial wake-up waiters.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 4 +++-
 net/core/sock.c    | 8 ++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 4137fa178790..a0728f24ecc5 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2150,13 +2150,15 @@ static inline void skb_set_owner_r(struct sk_buff *skb, struct sock *sk)
 	sk_mem_charge(sk, skb->truesize);
 }
 
-static inline void skb_set_owner_sk_safe(struct sk_buff *skb, struct sock *sk)
+static inline __must_check bool skb_set_owner_sk_safe(struct sk_buff *skb, struct sock *sk)
 {
 	if (sk && refcount_inc_not_zero(&sk->sk_refcnt)) {
 		skb_orphan(skb);
 		skb->destructor = sock_efree;
 		skb->sk = sk;
+		return true;
 	}
+	return false;
 }
 
 void sk_reset_timer(struct sock *sk, struct timer_list *timer,
diff --git a/net/core/sock.c b/net/core/sock.c
index 19c178aac0ae..68f84fac63e0 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2026,10 +2026,10 @@ void skb_orphan_partial(struct sk_buff *skb)
 	if (skb_is_tcp_pure_ack(skb))
 		return;
 
-	if (can_skb_orphan_partial(skb))
-		skb_set_owner_sk_safe(skb, skb->sk);
-	else
-		skb_orphan(skb);
+	if (can_skb_orphan_partial(skb) && skb_set_owner_sk_safe(skb, skb->sk))
+		return;
+
+	skb_orphan(skb);
 }
 EXPORT_SYMBOL(skb_orphan_partial);
 
-- 
2.30.2




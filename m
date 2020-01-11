Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1F0013806D
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgAKK3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:29:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:38780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729171AbgAKK3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:29:32 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCEDE20842;
        Sat, 11 Jan 2020 10:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738571;
        bh=gvUfKMKRH/t4NRqfU6iHpf39qn7HbiZhJj6cXBk/K10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXJXSPqXv0gWdme58hCKgg2XTVcJ4V0noQU4ags7r81xFokOexH62VfZda8fMy3Dn
         OVsb1lI1LGc4UPswpDzQWbvz1PclZuMb97oxKWsS2lWV78BiK2G5e7WrV2ZR69wcgb
         8PkSC8r1L6lRoQUeD8bqtrYBH3hlxlEh3KdeCmdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 119/165] xsk: Add rcu_read_lock around the XSK wakeup
Date:   Sat, 11 Jan 2020 10:50:38 +0100
Message-Id: <20200111094933.339758468@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 06870682087b58398671e8cdc896cd62314c4399 ]

The XSK wakeup callback in drivers makes some sanity checks before
triggering NAPI. However, some configuration changes may occur during
this function that affect the result of those checks. For example, the
interface can go down, and all the resources will be destroyed after the
checks in the wakeup function, but before it attempts to use these
resources. Wrap this callback in rcu_read_lock to allow driver to
synchronize_rcu before actually destroying the resources.

xsk_wakeup is a new function that encapsulates calling ndo_xsk_wakeup
wrapped into the RCU lock. After this commit, xsk_poll starts using
xsk_wakeup and checks xs->zc instead of ndo_xsk_wakeup != NULL to decide
ndo_xsk_wakeup should be called. It also fixes a bug introduced with the
need_wakeup feature: a non-zero-copy socket may be used with a driver
supporting zero-copy, and in this case ndo_xsk_wakeup should not be
called, so the xs->zc check is the correct one.

Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP rings")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191217162023.16011-2-maximmi@mellanox.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 9044073fbf22..d426fc01c529 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -305,12 +305,21 @@ bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc)
 }
 EXPORT_SYMBOL(xsk_umem_consume_tx);
 
-static int xsk_zc_xmit(struct xdp_sock *xs)
+static int xsk_wakeup(struct xdp_sock *xs, u8 flags)
 {
 	struct net_device *dev = xs->dev;
+	int err;
+
+	rcu_read_lock();
+	err = dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id, flags);
+	rcu_read_unlock();
+
+	return err;
+}
 
-	return dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
-					       XDP_WAKEUP_TX);
+static int xsk_zc_xmit(struct xdp_sock *xs)
+{
+	return xsk_wakeup(xs, XDP_WAKEUP_TX);
 }
 
 static void xsk_destruct_skb(struct sk_buff *skb)
@@ -424,19 +433,16 @@ static unsigned int xsk_poll(struct file *file, struct socket *sock,
 	unsigned int mask = datagram_poll(file, sock, wait);
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
-	struct net_device *dev;
 	struct xdp_umem *umem;
 
 	if (unlikely(!xsk_is_bound(xs)))
 		return mask;
 
-	dev = xs->dev;
 	umem = xs->umem;
 
 	if (umem->need_wakeup) {
-		if (dev->netdev_ops->ndo_xsk_wakeup)
-			dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
-							umem->need_wakeup);
+		if (xs->zc)
+			xsk_wakeup(xs, umem->need_wakeup);
 		else
 			/* Poll needs to drive Tx also in copy mode */
 			__xsk_sendmsg(sk);
-- 
2.20.1




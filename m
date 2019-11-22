Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFCD8106E96
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbfKVLCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:02:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:56234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730991AbfKVLCf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:02:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A507220840;
        Fri, 22 Nov 2019 11:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420555;
        bh=seh6PmXvSTkNpVGMUR2DlyeDVyJ5I38GlRYzKWTGXiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m732d10en112HLLS7Qj1z4RcqAwzOvdl8Z1QSnrEsfJLqD94HxmN2h1+ISZ0RqDRd
         Xn9cZcTiRFmHEkbU/HsJIl3o1eTw2sr0v8tNqQjH53M/AWZqwCeMHyNScYTQrjkHkH
         ki3Y1BgkU5G59JtHW/pjWXoeLmXySaKdSAKQXhms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 146/220] xsk: proper AF_XDP socket teardown ordering
Date:   Fri, 22 Nov 2019 11:28:31 +0100
Message-Id: <20191122100923.263721887@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit 541d7fdd7694560404c502f64298a90ffe017e6b ]

The AF_XDP socket struct can exist in three different, implicit
states: setup, bound and released. Setup is prior the socket has been
bound to a device. Bound is when the socket is active for receive and
send. Released is when the process/userspace side of the socket is
released, but the sock object is still lingering, e.g. when there is a
reference to the socket in an XSKMAP after process termination.

The Rx fast-path code uses the "dev" member of struct xdp_sock to
check whether a socket is bound or relased, and the Tx code uses the
struct xdp_umem "xsk_list" member in conjunction with "dev" to
determine the state of a socket.

However, the transition from bound to released did not tear the socket
down in correct order.

On the Rx side "dev" was cleared after synchronize_net() making the
synchronization useless. On the Tx side, the internal queues were
destroyed prior removing them from the "xsk_list".

This commit corrects the cleanup order, and by doing so
xdp_del_sk_umem() can be simplified and one synchronize_net() can be
removed.

Fixes: 965a99098443 ("xsk: add support for bind for Rx")
Fixes: ac98d8aab61b ("xsk: wire upp Tx zero-copy functions")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xdp_umem.c | 11 +++--------
 net/xdp/xsk.c      | 13 ++++++++-----
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 8cab91c482ff5..d9117ab035f7c 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -32,14 +32,9 @@ void xdp_del_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs)
 {
 	unsigned long flags;
 
-	if (xs->dev) {
-		spin_lock_irqsave(&umem->xsk_list_lock, flags);
-		list_del_rcu(&xs->list);
-		spin_unlock_irqrestore(&umem->xsk_list_lock, flags);
-
-		if (umem->zc)
-			synchronize_net();
-	}
+	spin_lock_irqsave(&umem->xsk_list_lock, flags);
+	list_del_rcu(&xs->list);
+	spin_unlock_irqrestore(&umem->xsk_list_lock, flags);
 }
 
 int xdp_umem_query(struct net_device *dev, u16 queue_id)
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 661504042d304..ff15207036dc5 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -343,12 +343,18 @@ static int xsk_release(struct socket *sock)
 	local_bh_enable();
 
 	if (xs->dev) {
+		struct net_device *dev = xs->dev;
+
 		/* Wait for driver to stop using the xdp socket. */
-		synchronize_net();
-		dev_put(xs->dev);
+		xdp_del_sk_umem(xs->umem, xs);
 		xs->dev = NULL;
+		synchronize_net();
+		dev_put(dev);
 	}
 
+	xskq_destroy(xs->rx);
+	xskq_destroy(xs->tx);
+
 	sock_orphan(sk);
 	sock->sk = NULL;
 
@@ -707,9 +713,6 @@ static void xsk_destruct(struct sock *sk)
 	if (!sock_flag(sk, SOCK_DEAD))
 		return;
 
-	xskq_destroy(xs->rx);
-	xskq_destroy(xs->tx);
-	xdp_del_sk_umem(xs->umem, xs);
 	xdp_put_umem(xs->umem);
 
 	sk_refcnt_debug_dec(sk);
-- 
2.20.1




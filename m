Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546F62C079F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732567AbgKWMmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:42:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732878AbgKWMmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:42:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 845872065E;
        Mon, 23 Nov 2020 12:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135325;
        bh=JRRpBRnUe89QT5TyEvv1Fvee1GxXlsaqiX9/Ndugci8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAs96yjhHJJM3D6AGCQgJfGXmvItcQY0gioI+UAuM2ygo6fkONFVLALwhTHhShVUE
         e8KYmFO10BYRuwJ0Dut4XCib1ZwtB+T96zkXXNgnLxvMRb8rgvh3z0L+Wr4TAHgIlE
         d2VJUgdAKqZAMDgpej6yE1HWBRWYVFTDS6NrkgCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.9 028/252] net/mlx5e: Fix refcount leak on kTLS RX resync
Date:   Mon, 23 Nov 2020 13:19:38 +0100
Message-Id: <20201123121836.947659762@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit ea63609857321c38fd4ad096388b413b66001c6c ]

On resync, the driver calls inet_lookup_established
(__inet6_lookup_established) that increases sk_refcnt of the socket. To
decrease it, the driver set skb->destructor to sock_edemux. However, it
didn't work well, because the TCP stack also sets this destructor for
early demux, and the refcount gets decreased only once, while increased
two times (in mlx5e and in the TCP stack). It leads to a socket leak, a
TLS context leak, which in the end leads to calling tls_dev_del twice:
on socket close and on driver unload, which in turn leads to a crash.

This commit fixes the refcount leak by calling sock_gen_put right away
after using the socket, thus fixing all the subsequent issues.

Fixes: 0419d8c9d8f8 ("net/mlx5e: kTLS, Add kTLS RX resync support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -476,19 +476,22 @@ static void resync_update_sn(struct mlx5
 
 	depth += sizeof(struct tcphdr);
 
-	if (unlikely(!sk || sk->sk_state == TCP_TIME_WAIT))
+	if (unlikely(!sk))
 		return;
 
-	if (unlikely(!resync_queue_get_psv(sk)))
-		return;
+	if (unlikely(sk->sk_state == TCP_TIME_WAIT))
+		goto unref;
 
-	skb->sk = sk;
-	skb->destructor = sock_edemux;
+	if (unlikely(!resync_queue_get_psv(sk)))
+		goto unref;
 
 	seq = th->seq;
 	datalen = skb->len - depth;
 	tls_offload_rx_resync_async_request_start(sk, seq, datalen);
 	rq->stats->tls_resync_req_start++;
+
+unref:
+	sock_gen_put(sk);
 }
 
 void mlx5e_ktls_rx_resync(struct net_device *netdev, struct sock *sk,



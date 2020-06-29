Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE1D20DE08
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730889AbgF2UWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732585AbgF2TZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3176B2543E;
        Mon, 29 Jun 2020 15:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445390;
        bh=skU9NDh+rgFwQutvhIK6EC/Sh4/cl45slDMVvV4I+/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3LdZrEpi3Op48OQM9IlblQPL2y+ourTnc8XW09BTYKa0W6hW4toJPV+2ec/7bUtx
         bH2SLXTDIUJPTBh8TGRMy1eSG+Oohirvdqy1+u2DdU96ipOb9DUABWgrs8aGEQOBg2
         77KGn+RYd8og+ZbUQxoXoEVUVVi8g2voSpqQPj1M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 144/191] net: Do not clear the sock TX queue in sk_set_socket()
Date:   Mon, 29 Jun 2020 11:39:20 -0400
Message-Id: <20200629154007.2495120-145-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

[ Upstream commit 41b14fb8724d5a4b382a63cb4a1a61880347ccb8 ]

Clearing the sock TX queue in sk_set_socket() might cause unexpected
out-of-order transmit when called from sock_orphan(), as outstanding
packets can pick a different TX queue and bypass the ones already queued.

This is undesired in general. More specifically, it breaks the in-order
scheduling property guarantee for device-offloaded TLS sockets.

Remove the call to sk_tx_queue_clear() in sk_set_socket(), and add it
explicitly only where needed.

Fixes: e022f0b4a03f ("net: Introduce sk_tx_queue_mapping")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sock.h | 1 -
 net/core/sock.c    | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index d6bce19ca261c..db68c72126d54 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1631,7 +1631,6 @@ static inline int sk_tx_queue_get(const struct sock *sk)
 
 static inline void sk_set_socket(struct sock *sk, struct socket *sock)
 {
-	sk_tx_queue_clear(sk);
 	sk->sk_socket = sock;
 }
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 41794a698da66..dac9365151df9 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1403,6 +1403,7 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
 		cgroup_sk_alloc(&sk->sk_cgrp_data);
 		sock_update_classid(&sk->sk_cgrp_data);
 		sock_update_netprioidx(&sk->sk_cgrp_data);
+		sk_tx_queue_clear(sk);
 	}
 
 	return sk;
@@ -1587,6 +1588,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 		 */
 		sk_refcnt_debug_inc(newsk);
 		sk_set_socket(newsk, NULL);
+		sk_tx_queue_clear(newsk);
 		newsk->sk_wq = NULL;
 
 		if (newsk->sk_prot->sockets_allocated)
-- 
2.25.1


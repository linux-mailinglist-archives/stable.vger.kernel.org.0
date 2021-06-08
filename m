Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB103A02A8
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235778AbhFHTHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237818AbhFHTFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:05:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C9E461876;
        Tue,  8 Jun 2021 18:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177980;
        bh=r+J9dgsr+vI6MXh1oMDKeEKmapaCkU+l1kKOI/xx4GM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSTX3T6bI6dBTcCHfZF2PaAe5hMe6gEag6MdzwkDiH+wHsV4jZ8zmtRriR14CwKHv
         4/sHaz/0TydWZRnb8Mpo3wMOrEPG7LRtdZI6ISBhfz6drRILK/CRUYhNjkT/lDIphT
         jYi453cMSQEySvZ/tMCdaxA+iotl5VRf+s4Nvfw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 032/161] net/tls: Replace TLS_RX_SYNC_RUNNING with RCU
Date:   Tue,  8 Jun 2021 20:26:02 +0200
Message-Id: <20210608175946.538035302@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit 05fc8b6cbd4f979a6f25759c4a17dd5f657f7ecd ]

RCU synchronization is guaranteed to finish in finite time, unlike a
busy loop that polls a flag. This patch is a preparation for the bugfix
in the next patch, where the same synchronize_net() call will also be
used to sync with the TX datapath.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tls.h    |  1 -
 net/tls/tls_device.c | 10 +++-------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 3eccb525e8f7..6531ace2a68b 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -193,7 +193,6 @@ struct tls_offload_context_tx {
 	(sizeof(struct tls_offload_context_tx) + TLS_DRIVER_STATE_SIZE_TX)
 
 enum tls_context_flags {
-	TLS_RX_SYNC_RUNNING = 0,
 	/* Unlike RX where resync is driven entirely by the core in TX only
 	 * the driver knows when things went out of sync, so we need the flag
 	 * to be atomic.
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index d9cd229aa111..2602d61a8d28 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -680,15 +680,13 @@ static void tls_device_resync_rx(struct tls_context *tls_ctx,
 	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
 	struct net_device *netdev;
 
-	if (WARN_ON(test_and_set_bit(TLS_RX_SYNC_RUNNING, &tls_ctx->flags)))
-		return;
-
 	trace_tls_device_rx_resync_send(sk, seq, rcd_sn, rx_ctx->resync_type);
+	rcu_read_lock();
 	netdev = READ_ONCE(tls_ctx->netdev);
 	if (netdev)
 		netdev->tlsdev_ops->tls_dev_resync(netdev, sk, seq, rcd_sn,
 						   TLS_OFFLOAD_CTX_DIR_RX);
-	clear_bit_unlock(TLS_RX_SYNC_RUNNING, &tls_ctx->flags);
+	rcu_read_unlock();
 	TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXDEVICERESYNC);
 }
 
@@ -1300,9 +1298,7 @@ static int tls_device_down(struct net_device *netdev)
 			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
 							TLS_OFFLOAD_CTX_DIR_RX);
 		WRITE_ONCE(ctx->netdev, NULL);
-		smp_mb__before_atomic(); /* pairs with test_and_set_bit() */
-		while (test_bit(TLS_RX_SYNC_RUNNING, &ctx->flags))
-			usleep_range(10, 200);
+		synchronize_net();
 		dev_put(netdev);
 		list_del_init(&ctx->list);
 
-- 
2.30.2




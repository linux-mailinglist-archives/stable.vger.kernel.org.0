Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4202328E22
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241566AbhCATYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:24:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241316AbhCATT0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:19:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B434652D8;
        Mon,  1 Mar 2021 17:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620317;
        bh=XQr8aqBc77OR1K8JXKZAdE36XIhKdlILPehCZUiCqfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zpiRX952kZEUT7uthnLfucLxEmCwqm2SmYbQQ00mp3iUD+Q/7B2goZcKBWcs8kXYS
         QZZNH1X891WTUAF14rNL7usY0ajCbVAEaZgTYiW+/rr7UANxJ6CgY63XPERL7j+aq3
         mjpSnkfQzkYztW+lIlMz8cOGO1wn0+kH5SCX/RD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 110/775] net/mlx5e: kTLS, Use refcounts to free kTLS RX priv context
Date:   Mon,  1 Mar 2021 17:04:38 +0100
Message-Id: <20210301161207.102749489@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit b850bbff965129c34f50962638c0a66c82563536 ]

wait_for_resync is unreliable - if it timeouts, priv_rx will be freed
anyway. However, mlx5e_ktls_handle_get_psv_completion will be called
sooner or later, leading to use-after-free. For example, it can happen
if a CQ error happened, and ICOSQ stopped, but later on the queues are
destroyed, and ICOSQ is flushed with mlx5e_free_icosq_descs.

This patch converts the lifecycle of priv_rx to fully refcount-based, so
that the struct won't be freed before the refcount goes to zero.

Fixes: 0419d8c9d8f8 ("net/mlx5e: kTLS, Add kTLS RX resync support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 64 +++++++++----------
 1 file changed, 30 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 0f13b661f7f98..d06532d0baa43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -57,6 +57,20 @@ struct mlx5e_ktls_offload_context_rx {
 	struct mlx5e_ktls_rx_resync_ctx resync;
 };
 
+static bool mlx5e_ktls_priv_rx_put(struct mlx5e_ktls_offload_context_rx *priv_rx)
+{
+	if (!refcount_dec_and_test(&priv_rx->resync.refcnt))
+		return false;
+
+	kfree(priv_rx);
+	return true;
+}
+
+static void mlx5e_ktls_priv_rx_get(struct mlx5e_ktls_offload_context_rx *priv_rx)
+{
+	refcount_inc(&priv_rx->resync.refcnt);
+}
+
 static int mlx5e_ktls_create_tir(struct mlx5_core_dev *mdev, u32 *tirn, u32 rqtn)
 {
 	int err, inlen;
@@ -326,7 +340,7 @@ static void resync_handle_work(struct work_struct *work)
 	priv_rx = container_of(resync, struct mlx5e_ktls_offload_context_rx, resync);
 
 	if (unlikely(test_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags))) {
-		refcount_dec(&resync->refcnt);
+		mlx5e_ktls_priv_rx_put(priv_rx);
 		return;
 	}
 
@@ -334,7 +348,7 @@ static void resync_handle_work(struct work_struct *work)
 	sq = &c->async_icosq;
 
 	if (resync_post_get_progress_params(sq, priv_rx))
-		refcount_dec(&resync->refcnt);
+		mlx5e_ktls_priv_rx_put(priv_rx);
 }
 
 static void resync_init(struct mlx5e_ktls_rx_resync_ctx *resync,
@@ -377,7 +391,11 @@ unlock:
 	return err;
 }
 
-/* Function is called with elevated refcount, it decreases it. */
+/* Function can be called with the refcount being either elevated or not.
+ * It decreases the refcount and may free the kTLS priv context.
+ * Refcount is not elevated only if tls_dev_del has been called, but GET_PSV was
+ * already in flight.
+ */
 void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
 					  struct mlx5e_icosq *sq)
 {
@@ -410,7 +428,7 @@ void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
 	tls_offload_rx_resync_async_request_end(priv_rx->sk, cpu_to_be32(hw_seq));
 	priv_rx->stats->tls_resync_req_end++;
 out:
-	refcount_dec(&resync->refcnt);
+	mlx5e_ktls_priv_rx_put(priv_rx);
 	dma_unmap_single(dev, buf->dma_addr, PROGRESS_PARAMS_PADDED_SIZE, DMA_FROM_DEVICE);
 	kfree(buf);
 }
@@ -431,9 +449,9 @@ static bool resync_queue_get_psv(struct sock *sk)
 		return false;
 
 	resync = &priv_rx->resync;
-	refcount_inc(&resync->refcnt);
+	mlx5e_ktls_priv_rx_get(priv_rx);
 	if (unlikely(!queue_work(resync->priv->tls->rx_wq, &resync->work)))
-		refcount_dec(&resync->refcnt);
+		mlx5e_ktls_priv_rx_put(priv_rx);
 
 	return true;
 }
@@ -625,31 +643,6 @@ err_create_key:
 	return err;
 }
 
-/* Elevated refcount on the resync object means there are
- * outstanding operations (uncompleted GET_PSV WQEs) that
- * will read the resync / priv_rx objects once completed.
- * Wait for them to avoid use-after-free.
- */
-static void wait_for_resync(struct net_device *netdev,
-			    struct mlx5e_ktls_rx_resync_ctx *resync)
-{
-#define MLX5E_KTLS_RX_RESYNC_TIMEOUT 20000 /* msecs */
-	unsigned long exp_time = jiffies + msecs_to_jiffies(MLX5E_KTLS_RX_RESYNC_TIMEOUT);
-	unsigned int refcnt;
-
-	do {
-		refcnt = refcount_read(&resync->refcnt);
-		if (refcnt == 1)
-			return;
-
-		msleep(20);
-	} while (time_before(jiffies, exp_time));
-
-	netdev_warn(netdev,
-		    "Failed waiting for kTLS RX resync refcnt to be released (%u).\n",
-		    refcnt);
-}
-
 void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 {
 	struct mlx5e_ktls_offload_context_rx *priv_rx;
@@ -671,8 +664,7 @@ void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 		wait_for_completion(&priv_rx->add_ctx);
 	resync = &priv_rx->resync;
 	if (cancel_work_sync(&resync->work))
-		refcount_dec(&resync->refcnt);
-	wait_for_resync(netdev, resync);
+		mlx5e_ktls_priv_rx_put(priv_rx);
 
 	priv_rx->stats->tls_del++;
 	if (priv_rx->rule.rule)
@@ -680,5 +672,9 @@ void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 
 	mlx5_core_destroy_tir(mdev, priv_rx->tirn);
 	mlx5_ktls_destroy_key(mdev, priv_rx->key_id);
-	kfree(priv_rx);
+	/* priv_rx should normally be freed here, but if there is an outstanding
+	 * GET_PSV, deallocation will be delayed until the CQE for GET_PSV is
+	 * processed.
+	 */
+	mlx5e_ktls_priv_rx_put(priv_rx);
 }
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0720395F23
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbhEaOID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232871AbhEaOGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:06:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1454761966;
        Mon, 31 May 2021 13:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468331;
        bh=gO1QsXf73carFYrxAksSgpw+0XN78KBbz/MM1bI81H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rxqaz87epnejiq1IiupxkNh/sPoaOqgqOiBQBygv3RTWwOa7JLHIESv500GZYajk4
         D55L1Pmo/ZIYeRNpZ5W7/I6FgMafdD0XV7zUpTwsQ1THXEVSiTtOD32/Evkp+PMinG
         vx2AbvqhQtvDkZwJPMK2cXFUXReGVHCnBxN5MMfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/252] cxgb4/ch_ktls: Clear resources when pf4 device is removed
Date:   Mon, 31 May 2021 15:14:29 +0200
Message-Id: <20210531130704.944936529@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

[ Upstream commit 65e302a9bd57b62872040d57eea1201562a7cbb2 ]

This patch maintain the list of active tids and clear all the active
connection resources when DETACH notification comes.

Fixes: a8c16e8ed624f ("crypto/chcr: move nic TLS functionality to drivers/net")
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 80 ++++++++++++++++++-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.h |  2 +
 3 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 7fd264a6d085..23c13f34a572 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6484,9 +6484,9 @@ static void cxgb4_ktls_dev_del(struct net_device *netdev,
 
 	adap->uld[CXGB4_ULD_KTLS].tlsdev_ops->tls_dev_del(netdev, tls_ctx,
 							  direction);
-	cxgb4_set_ktls_feature(adap, FW_PARAMS_PARAM_DEV_KTLS_HW_DISABLE);
 
 out_unlock:
+	cxgb4_set_ktls_feature(adap, FW_PARAMS_PARAM_DEV_KTLS_HW_DISABLE);
 	mutex_unlock(&uld_mutex);
 }
 
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 3a50d5a62ace..f9353826b245 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -59,6 +59,7 @@ static int chcr_get_nfrags_to_send(struct sk_buff *skb, u32 start, u32 len)
 }
 
 static int chcr_init_tcb_fields(struct chcr_ktls_info *tx_info);
+static void clear_conn_resources(struct chcr_ktls_info *tx_info);
 /*
  * chcr_ktls_save_keys: calculate and save crypto keys.
  * @tx_info - driver specific tls info.
@@ -370,10 +371,14 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 				chcr_get_ktls_tx_context(tls_ctx);
 	struct chcr_ktls_info *tx_info = tx_ctx->chcr_info;
 	struct ch_ktls_port_stats_debug *port_stats;
+	struct chcr_ktls_uld_ctx *u_ctx;
 
 	if (!tx_info)
 		return;
 
+	u_ctx = tx_info->adap->uld[CXGB4_ULD_KTLS].handle;
+	if (u_ctx && u_ctx->detach)
+		return;
 	/* clear l2t entry */
 	if (tx_info->l2te)
 		cxgb4_l2t_release(tx_info->l2te);
@@ -390,6 +395,8 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 	if (tx_info->tid != -1) {
 		cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 				 tx_info->tid, tx_info->ip_family);
+
+		xa_erase(&u_ctx->tid_list, tx_info->tid);
 	}
 
 	port_stats = &tx_info->adap->ch_ktls_stats.ktls_port[tx_info->port_id];
@@ -417,6 +424,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct ch_ktls_port_stats_debug *port_stats;
 	struct chcr_ktls_ofld_ctx_tx *tx_ctx;
+	struct chcr_ktls_uld_ctx *u_ctx;
 	struct chcr_ktls_info *tx_info;
 	struct dst_entry *dst;
 	struct adapter *adap;
@@ -431,6 +439,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	adap = pi->adapter;
 	port_stats = &adap->ch_ktls_stats.ktls_port[pi->port_id];
 	atomic64_inc(&port_stats->ktls_tx_connection_open);
+	u_ctx = adap->uld[CXGB4_ULD_KTLS].handle;
 
 	if (direction == TLS_OFFLOAD_CTX_DIR_RX) {
 		pr_err("not expecting for RX direction\n");
@@ -440,6 +449,9 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	if (tx_ctx->chcr_info)
 		goto out;
 
+	if (u_ctx && u_ctx->detach)
+		goto out;
+
 	tx_info = kvzalloc(sizeof(*tx_info), GFP_KERNEL);
 	if (!tx_info)
 		goto out;
@@ -575,6 +587,8 @@ free_tid:
 	cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 			 tx_info->tid, tx_info->ip_family);
 
+	xa_erase(&u_ctx->tid_list, tx_info->tid);
+
 put_module:
 	/* release module refcount */
 	module_put(THIS_MODULE);
@@ -639,8 +653,12 @@ static int chcr_ktls_cpl_act_open_rpl(struct adapter *adap,
 {
 	const struct cpl_act_open_rpl *p = (void *)input;
 	struct chcr_ktls_info *tx_info = NULL;
+	struct chcr_ktls_ofld_ctx_tx *tx_ctx;
+	struct chcr_ktls_uld_ctx *u_ctx;
 	unsigned int atid, tid, status;
+	struct tls_context *tls_ctx;
 	struct tid_info *t;
+	int ret = 0;
 
 	tid = GET_TID(p);
 	status = AOPEN_STATUS_G(ntohl(p->atid_status));
@@ -672,14 +690,29 @@ static int chcr_ktls_cpl_act_open_rpl(struct adapter *adap,
 	if (!status) {
 		tx_info->tid = tid;
 		cxgb4_insert_tid(t, tx_info, tx_info->tid, tx_info->ip_family);
+		/* Adding tid */
+		tls_ctx = tls_get_ctx(tx_info->sk);
+		tx_ctx = chcr_get_ktls_tx_context(tls_ctx);
+		u_ctx = adap->uld[CXGB4_ULD_KTLS].handle;
+		if (u_ctx) {
+			ret = xa_insert_bh(&u_ctx->tid_list, tid, tx_ctx,
+					   GFP_NOWAIT);
+			if (ret < 0) {
+				pr_err("%s: Failed to allocate tid XA entry = %d\n",
+				       __func__, tx_info->tid);
+				tx_info->open_state = CH_KTLS_OPEN_FAILURE;
+				goto out;
+			}
+		}
 		tx_info->open_state = CH_KTLS_OPEN_SUCCESS;
 	} else {
 		tx_info->open_state = CH_KTLS_OPEN_FAILURE;
 	}
+out:
 	spin_unlock(&tx_info->lock);
 
 	complete(&tx_info->completion);
-	return 0;
+	return ret;
 }
 
 /*
@@ -2097,6 +2130,8 @@ static void *chcr_ktls_uld_add(const struct cxgb4_lld_info *lldi)
 		goto out;
 	}
 	u_ctx->lldi = *lldi;
+	u_ctx->detach = false;
+	xa_init_flags(&u_ctx->tid_list, XA_FLAGS_LOCK_BH);
 out:
 	return u_ctx;
 }
@@ -2130,6 +2165,45 @@ static int chcr_ktls_uld_rx_handler(void *handle, const __be64 *rsp,
 	return 0;
 }
 
+static void clear_conn_resources(struct chcr_ktls_info *tx_info)
+{
+	/* clear l2t entry */
+	if (tx_info->l2te)
+		cxgb4_l2t_release(tx_info->l2te);
+
+#if IS_ENABLED(CONFIG_IPV6)
+	/* clear clip entry */
+	if (tx_info->ip_family == AF_INET6)
+		cxgb4_clip_release(tx_info->netdev, (const u32 *)
+				   &tx_info->sk->sk_v6_rcv_saddr,
+				   1);
+#endif
+
+	/* clear tid */
+	if (tx_info->tid != -1)
+		cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
+				 tx_info->tid, tx_info->ip_family);
+}
+
+static void ch_ktls_reset_all_conn(struct chcr_ktls_uld_ctx *u_ctx)
+{
+	struct ch_ktls_port_stats_debug *port_stats;
+	struct chcr_ktls_ofld_ctx_tx *tx_ctx;
+	struct chcr_ktls_info *tx_info;
+	unsigned long index;
+
+	xa_for_each(&u_ctx->tid_list, index, tx_ctx) {
+		tx_info = tx_ctx->chcr_info;
+		clear_conn_resources(tx_info);
+		port_stats = &tx_info->adap->ch_ktls_stats.ktls_port[tx_info->port_id];
+		atomic64_inc(&port_stats->ktls_tx_connection_close);
+		kvfree(tx_info);
+		tx_ctx->chcr_info = NULL;
+		/* release module refcount */
+		module_put(THIS_MODULE);
+	}
+}
+
 static int chcr_ktls_uld_state_change(void *handle, enum cxgb4_state new_state)
 {
 	struct chcr_ktls_uld_ctx *u_ctx = handle;
@@ -2146,7 +2220,10 @@ static int chcr_ktls_uld_state_change(void *handle, enum cxgb4_state new_state)
 	case CXGB4_STATE_DETACH:
 		pr_info("%s: Down\n", pci_name(u_ctx->lldi.pdev));
 		mutex_lock(&dev_mutex);
+		u_ctx->detach = true;
 		list_del(&u_ctx->entry);
+		ch_ktls_reset_all_conn(u_ctx);
+		xa_destroy(&u_ctx->tid_list);
 		mutex_unlock(&dev_mutex);
 		break;
 	default:
@@ -2185,6 +2262,7 @@ static void __exit chcr_ktls_exit(void)
 		adap = pci_get_drvdata(u_ctx->lldi.pdev);
 		memset(&adap->ch_ktls_stats, 0, sizeof(adap->ch_ktls_stats));
 		list_del(&u_ctx->entry);
+		xa_destroy(&u_ctx->tid_list);
 		kfree(u_ctx);
 	}
 	mutex_unlock(&dev_mutex);
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.h b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.h
index 18b3b1f02415..10572dc55365 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.h
@@ -75,6 +75,8 @@ struct chcr_ktls_ofld_ctx_tx {
 struct chcr_ktls_uld_ctx {
 	struct list_head entry;
 	struct cxgb4_lld_info lldi;
+	struct xarray tid_list;
+	bool detach;
 };
 
 static inline struct chcr_ktls_ofld_ctx_tx *
-- 
2.30.2




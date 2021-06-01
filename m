Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA9339627A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbhEaO5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:57:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231652AbhEaOxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:53:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89A9D61CB7;
        Mon, 31 May 2021 13:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469551;
        bh=N4lgLWOjTmg/blcOwmCoquzicxCoun0gIA8CQlWI0Mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LUrONCz9i2SySWyZl5Wz+lutMaRGoCqMkK69xIvDO7VVXxyLWsWOM1xDwUb/32qYe
         Ska8qbWKFUFFP1VnLHmINAlOteCklYEW7Ph+Q6Ih7qCuVfHPBQdbCTk81Z6Z3bHN4Z
         kFLzbXF6xmVcRve6gN7by2uEmyqIyZjeNm21fU6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 239/296] cxgb4/ch_ktls: Clear resources when pf4 device is removed
Date:   Mon, 31 May 2021 15:14:54 +0200
Message-Id: <20210531130711.835359538@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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
index 6264bc66a4fc..421bd9b88028 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6480,9 +6480,9 @@ static void cxgb4_ktls_dev_del(struct net_device *netdev,
 
 	adap->uld[CXGB4_ULD_KTLS].tlsdev_ops->tls_dev_del(netdev, tls_ctx,
 							  direction);
-	cxgb4_set_ktls_feature(adap, FW_PARAMS_PARAM_DEV_KTLS_HW_DISABLE);
 
 out_unlock:
+	cxgb4_set_ktls_feature(adap, FW_PARAMS_PARAM_DEV_KTLS_HW_DISABLE);
 	mutex_unlock(&uld_mutex);
 }
 
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index a3f5b80888e5..82b0aa3d0d88 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -60,6 +60,7 @@ static int chcr_get_nfrags_to_send(struct sk_buff *skb, u32 start, u32 len)
 }
 
 static int chcr_init_tcb_fields(struct chcr_ktls_info *tx_info);
+static void clear_conn_resources(struct chcr_ktls_info *tx_info);
 /*
  * chcr_ktls_save_keys: calculate and save crypto keys.
  * @tx_info - driver specific tls info.
@@ -365,10 +366,14 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
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
@@ -385,6 +390,8 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 	if (tx_info->tid != -1) {
 		cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 				 tx_info->tid, tx_info->ip_family);
+
+		xa_erase(&u_ctx->tid_list, tx_info->tid);
 	}
 
 	port_stats = &tx_info->adap->ch_ktls_stats.ktls_port[tx_info->port_id];
@@ -412,6 +419,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct ch_ktls_port_stats_debug *port_stats;
 	struct chcr_ktls_ofld_ctx_tx *tx_ctx;
+	struct chcr_ktls_uld_ctx *u_ctx;
 	struct chcr_ktls_info *tx_info;
 	struct dst_entry *dst;
 	struct adapter *adap;
@@ -426,6 +434,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	adap = pi->adapter;
 	port_stats = &adap->ch_ktls_stats.ktls_port[pi->port_id];
 	atomic64_inc(&port_stats->ktls_tx_connection_open);
+	u_ctx = adap->uld[CXGB4_ULD_KTLS].handle;
 
 	if (direction == TLS_OFFLOAD_CTX_DIR_RX) {
 		pr_err("not expecting for RX direction\n");
@@ -435,6 +444,9 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	if (tx_ctx->chcr_info)
 		goto out;
 
+	if (u_ctx && u_ctx->detach)
+		goto out;
+
 	tx_info = kvzalloc(sizeof(*tx_info), GFP_KERNEL);
 	if (!tx_info)
 		goto out;
@@ -570,6 +582,8 @@ free_tid:
 	cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 			 tx_info->tid, tx_info->ip_family);
 
+	xa_erase(&u_ctx->tid_list, tx_info->tid);
+
 put_module:
 	/* release module refcount */
 	module_put(THIS_MODULE);
@@ -634,8 +648,12 @@ static int chcr_ktls_cpl_act_open_rpl(struct adapter *adap,
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
@@ -667,14 +685,29 @@ static int chcr_ktls_cpl_act_open_rpl(struct adapter *adap,
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
@@ -2092,6 +2125,8 @@ static void *chcr_ktls_uld_add(const struct cxgb4_lld_info *lldi)
 		goto out;
 	}
 	u_ctx->lldi = *lldi;
+	u_ctx->detach = false;
+	xa_init_flags(&u_ctx->tid_list, XA_FLAGS_LOCK_BH);
 out:
 	return u_ctx;
 }
@@ -2125,6 +2160,45 @@ static int chcr_ktls_uld_rx_handler(void *handle, const __be64 *rsp,
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
@@ -2141,7 +2215,10 @@ static int chcr_ktls_uld_state_change(void *handle, enum cxgb4_state new_state)
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
@@ -2180,6 +2257,7 @@ static void __exit chcr_ktls_exit(void)
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




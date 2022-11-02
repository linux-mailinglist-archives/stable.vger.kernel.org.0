Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25BC96159AE
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiKBDQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKBDQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:16:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763D824BC9
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:15:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1351060B72
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A289CC433C1;
        Wed,  2 Nov 2022 03:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358958;
        bh=QucadBFd1HPwLhZtuopYyitZgnw2Hkmyp4vvOQUTgpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJE/9ody/kECh8o9GhpEn8YkNgfziEeL9/CNI9EZ1iTy0Ke6zDEVbkJP61zzcpHuF
         LmS5A0djwtneF7ErS6DLeJnrJNH60WSnsIVd54qtbZzpdMfxb9eGf0pM2DS6CucfEL
         8nN8YI4v5txtZhuMUvlDrXahqPdch3FkTzT72tbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Liang <liali@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 53/91] atlantic: fix deadlock at aq_nic_stop
Date:   Wed,  2 Nov 2022 03:33:36 +0100
Message-Id: <20221102022056.532224355@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit 6960d133f66ecddcd3af2b1cbd0c7dcd104268b8 ]

NIC is stopped with rtnl_lock held, and during the stop it cancels the
'service_task' work and free irqs.

However, if CONFIG_MACSEC is set, rtnl_lock is acquired both from
aq_nic_service_task and aq_linkstate_threaded_isr. Then a deadlock
happens if aq_nic_stop tries to cancel/disable them when they've already
started their execution.

As the deadlock is caused by rtnl_lock, it causes many other processes
to stall, not only atlantic related stuff.

Fix it by introducing a mutex that protects each NIC's macsec related
data, and locking it instead of the rtnl_lock from the service task and
the threaded IRQ.

Before this patch, all macsec data was protected with rtnl_lock, but
maybe not all of it needs to be protected. With this new mutex, further
efforts can be made to limit the protected data only to that which
requires it. However, probably it doesn't worth it because all macsec's
data accesses are infrequent, and almost all are done from macsec_ops
or ethtool callbacks, called holding rtnl_lock, so macsec_mutex won't
never be much contended.

The issue appeared repeteadly attaching and deattaching the NIC to a
bond interface. Doing that after this patch I cannot reproduce the bug.

Fixes: 62c1c2e606f6 ("net: atlantic: MACSec offload skeleton")
Reported-by: Li Liang <liali@redhat.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Reviewed-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/aquantia/atlantic/aq_macsec.c    | 96 ++++++++++++++-----
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  2 +
 2 files changed, 74 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 4a6dfac857ca..7c6e0811f2e6 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -1451,26 +1451,57 @@ static void aq_check_txsa_expiration(struct aq_nic_s *nic)
 			egress_sa_threshold_expired);
 }
 
+#define AQ_LOCKED_MDO_DEF(mdo)						\
+static int aq_locked_mdo_##mdo(struct macsec_context *ctx)		\
+{									\
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);		\
+	int ret;							\
+	mutex_lock(&nic->macsec_mutex);					\
+	ret = aq_mdo_##mdo(ctx);					\
+	mutex_unlock(&nic->macsec_mutex);				\
+	return ret;							\
+}
+
+AQ_LOCKED_MDO_DEF(dev_open)
+AQ_LOCKED_MDO_DEF(dev_stop)
+AQ_LOCKED_MDO_DEF(add_secy)
+AQ_LOCKED_MDO_DEF(upd_secy)
+AQ_LOCKED_MDO_DEF(del_secy)
+AQ_LOCKED_MDO_DEF(add_rxsc)
+AQ_LOCKED_MDO_DEF(upd_rxsc)
+AQ_LOCKED_MDO_DEF(del_rxsc)
+AQ_LOCKED_MDO_DEF(add_rxsa)
+AQ_LOCKED_MDO_DEF(upd_rxsa)
+AQ_LOCKED_MDO_DEF(del_rxsa)
+AQ_LOCKED_MDO_DEF(add_txsa)
+AQ_LOCKED_MDO_DEF(upd_txsa)
+AQ_LOCKED_MDO_DEF(del_txsa)
+AQ_LOCKED_MDO_DEF(get_dev_stats)
+AQ_LOCKED_MDO_DEF(get_tx_sc_stats)
+AQ_LOCKED_MDO_DEF(get_tx_sa_stats)
+AQ_LOCKED_MDO_DEF(get_rx_sc_stats)
+AQ_LOCKED_MDO_DEF(get_rx_sa_stats)
+
 const struct macsec_ops aq_macsec_ops = {
-	.mdo_dev_open = aq_mdo_dev_open,
-	.mdo_dev_stop = aq_mdo_dev_stop,
-	.mdo_add_secy = aq_mdo_add_secy,
-	.mdo_upd_secy = aq_mdo_upd_secy,
-	.mdo_del_secy = aq_mdo_del_secy,
-	.mdo_add_rxsc = aq_mdo_add_rxsc,
-	.mdo_upd_rxsc = aq_mdo_upd_rxsc,
-	.mdo_del_rxsc = aq_mdo_del_rxsc,
-	.mdo_add_rxsa = aq_mdo_add_rxsa,
-	.mdo_upd_rxsa = aq_mdo_upd_rxsa,
-	.mdo_del_rxsa = aq_mdo_del_rxsa,
-	.mdo_add_txsa = aq_mdo_add_txsa,
-	.mdo_upd_txsa = aq_mdo_upd_txsa,
-	.mdo_del_txsa = aq_mdo_del_txsa,
-	.mdo_get_dev_stats = aq_mdo_get_dev_stats,
-	.mdo_get_tx_sc_stats = aq_mdo_get_tx_sc_stats,
-	.mdo_get_tx_sa_stats = aq_mdo_get_tx_sa_stats,
-	.mdo_get_rx_sc_stats = aq_mdo_get_rx_sc_stats,
-	.mdo_get_rx_sa_stats = aq_mdo_get_rx_sa_stats,
+	.mdo_dev_open = aq_locked_mdo_dev_open,
+	.mdo_dev_stop = aq_locked_mdo_dev_stop,
+	.mdo_add_secy = aq_locked_mdo_add_secy,
+	.mdo_upd_secy = aq_locked_mdo_upd_secy,
+	.mdo_del_secy = aq_locked_mdo_del_secy,
+	.mdo_add_rxsc = aq_locked_mdo_add_rxsc,
+	.mdo_upd_rxsc = aq_locked_mdo_upd_rxsc,
+	.mdo_del_rxsc = aq_locked_mdo_del_rxsc,
+	.mdo_add_rxsa = aq_locked_mdo_add_rxsa,
+	.mdo_upd_rxsa = aq_locked_mdo_upd_rxsa,
+	.mdo_del_rxsa = aq_locked_mdo_del_rxsa,
+	.mdo_add_txsa = aq_locked_mdo_add_txsa,
+	.mdo_upd_txsa = aq_locked_mdo_upd_txsa,
+	.mdo_del_txsa = aq_locked_mdo_del_txsa,
+	.mdo_get_dev_stats = aq_locked_mdo_get_dev_stats,
+	.mdo_get_tx_sc_stats = aq_locked_mdo_get_tx_sc_stats,
+	.mdo_get_tx_sa_stats = aq_locked_mdo_get_tx_sa_stats,
+	.mdo_get_rx_sc_stats = aq_locked_mdo_get_rx_sc_stats,
+	.mdo_get_rx_sa_stats = aq_locked_mdo_get_rx_sa_stats,
 };
 
 int aq_macsec_init(struct aq_nic_s *nic)
@@ -1492,6 +1523,7 @@ int aq_macsec_init(struct aq_nic_s *nic)
 
 	nic->ndev->features |= NETIF_F_HW_MACSEC;
 	nic->ndev->macsec_ops = &aq_macsec_ops;
+	mutex_init(&nic->macsec_mutex);
 
 	return 0;
 }
@@ -1515,7 +1547,7 @@ int aq_macsec_enable(struct aq_nic_s *nic)
 	if (!nic->macsec_cfg)
 		return 0;
 
-	rtnl_lock();
+	mutex_lock(&nic->macsec_mutex);
 
 	if (nic->aq_fw_ops->send_macsec_req) {
 		struct macsec_cfg_request cfg = { 0 };
@@ -1564,7 +1596,7 @@ int aq_macsec_enable(struct aq_nic_s *nic)
 	ret = aq_apply_macsec_cfg(nic);
 
 unlock:
-	rtnl_unlock();
+	mutex_unlock(&nic->macsec_mutex);
 	return ret;
 }
 
@@ -1576,9 +1608,9 @@ void aq_macsec_work(struct aq_nic_s *nic)
 	if (!netif_carrier_ok(nic->ndev))
 		return;
 
-	rtnl_lock();
+	mutex_lock(&nic->macsec_mutex);
 	aq_check_txsa_expiration(nic);
-	rtnl_unlock();
+	mutex_unlock(&nic->macsec_mutex);
 }
 
 int aq_macsec_rx_sa_cnt(struct aq_nic_s *nic)
@@ -1589,21 +1621,30 @@ int aq_macsec_rx_sa_cnt(struct aq_nic_s *nic)
 	if (!cfg)
 		return 0;
 
+	mutex_lock(&nic->macsec_mutex);
+
 	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
 		if (!test_bit(i, &cfg->rxsc_idx_busy))
 			continue;
 		cnt += hweight_long(cfg->aq_rxsc[i].rx_sa_idx_busy);
 	}
 
+	mutex_unlock(&nic->macsec_mutex);
 	return cnt;
 }
 
 int aq_macsec_tx_sc_cnt(struct aq_nic_s *nic)
 {
+	int cnt;
+
 	if (!nic->macsec_cfg)
 		return 0;
 
-	return hweight_long(nic->macsec_cfg->txsc_idx_busy);
+	mutex_lock(&nic->macsec_mutex);
+	cnt = hweight_long(nic->macsec_cfg->txsc_idx_busy);
+	mutex_unlock(&nic->macsec_mutex);
+
+	return cnt;
 }
 
 int aq_macsec_tx_sa_cnt(struct aq_nic_s *nic)
@@ -1614,12 +1655,15 @@ int aq_macsec_tx_sa_cnt(struct aq_nic_s *nic)
 	if (!cfg)
 		return 0;
 
+	mutex_lock(&nic->macsec_mutex);
+
 	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
 		if (!test_bit(i, &cfg->txsc_idx_busy))
 			continue;
 		cnt += hweight_long(cfg->aq_txsc[i].tx_sa_idx_busy);
 	}
 
+	mutex_unlock(&nic->macsec_mutex);
 	return cnt;
 }
 
@@ -1691,6 +1735,8 @@ u64 *aq_macsec_get_stats(struct aq_nic_s *nic, u64 *data)
 	if (!cfg)
 		return data;
 
+	mutex_lock(&nic->macsec_mutex);
+
 	aq_macsec_update_stats(nic);
 
 	common_stats = &cfg->stats;
@@ -1773,5 +1819,7 @@ u64 *aq_macsec_get_stats(struct aq_nic_s *nic, u64 *data)
 
 	data += i;
 
+	mutex_unlock(&nic->macsec_mutex);
+
 	return data;
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 926cca9a0c83..6da3efa289a3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -152,6 +152,8 @@ struct aq_nic_s {
 	struct mutex fwreq_mutex;
 #if IS_ENABLED(CONFIG_MACSEC)
 	struct aq_macsec_cfg *macsec_cfg;
+	/* mutex to protect data in macsec_cfg */
+	struct mutex macsec_mutex;
 #endif
 	/* PTP support */
 	struct aq_ptp_s *aq_ptp;
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60F6469F11
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391335AbhLFPp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390522AbhLFPm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9F9C061D60;
        Mon,  6 Dec 2021 07:27:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D31F16132F;
        Mon,  6 Dec 2021 15:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB66C34901;
        Mon,  6 Dec 2021 15:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804445;
        bh=Ulaw7TPX0/PCuzJ0naAK+QYJAEjnAj4E/FACh2uhOS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMNJSKzkro53SVtcqH8ORVS2a7ialK0+xE0r45KcVMTIKUS8xPlBBYLY1J4kgwNeH
         7nleKtB0Wu0FPwX64ABqsVn4whh1LmN/a27FtJSQc2mKRF8YHCGRWC15dNNkMWfROz
         w8MpdLOnYmzLCUuDbCv4EqhZZ4oJ335TKCyiyrjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Bogdanov <dbezrukov@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 150/207] atlantic: Fix statistics logic for production hardware
Date:   Mon,  6 Dec 2021 15:56:44 +0100
Message-Id: <20211206145615.429866696@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <dbezrukov@marvell.com>

commit 2087ced0fc3a6d45203925750a2b1bcd5402e639 upstream.

B0 is the main and widespread device revision of atlantic2 HW. In the
current state, driver will incorrectly fetch the statistics for this
revision.

Fixes: 5cfd54d7dc186 ("net: atlantic: minimal A2 fw_ops")
Signed-off-by: Dmitry Bogdanov <dbezrukov@marvell.com>
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h                    |    2 
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c                   |   10 
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c      |   15 +
 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h    |   38 +++
 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c |  101 ++++++++--
 5 files changed, 139 insertions(+), 27 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -80,6 +80,8 @@ struct aq_hw_link_status_s {
 };
 
 struct aq_stats_s {
+	u64 brc;
+	u64 btc;
 	u64 uprc;
 	u64 mprc;
 	u64 bprc;
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -903,8 +903,14 @@ u64 *aq_nic_get_stats(struct aq_nic_s *s
 	data[++i] = stats->mbtc;
 	data[++i] = stats->bbrc;
 	data[++i] = stats->bbtc;
-	data[++i] = stats->ubrc + stats->mbrc + stats->bbrc;
-	data[++i] = stats->ubtc + stats->mbtc + stats->bbtc;
+	if (stats->brc)
+		data[++i] = stats->brc;
+	else
+		data[++i] = stats->ubrc + stats->mbrc + stats->bbrc;
+	if (stats->btc)
+		data[++i] = stats->btc;
+	else
+		data[++i] = stats->ubtc + stats->mbtc + stats->bbtc;
 	data[++i] = stats->dma_pkt_rc;
 	data[++i] = stats->dma_pkt_tc;
 	data[++i] = stats->dma_oct_rc;
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -867,12 +867,20 @@ static int hw_atl_fw1x_deinit(struct aq_
 int hw_atl_utils_update_stats(struct aq_hw_s *self)
 {
 	struct aq_stats_s *cs = &self->curr_stats;
+	struct aq_stats_s curr_stats = *cs;
 	struct hw_atl_utils_mbox mbox;
+	bool corrupted_stats = false;
 
 	hw_atl_utils_mpi_read_stats(self, &mbox);
 
-#define AQ_SDELTA(_N_) (self->curr_stats._N_ += \
-			mbox.stats._N_ - self->last_stats._N_)
+#define AQ_SDELTA(_N_)  \
+do { \
+	if (!corrupted_stats && \
+	    ((s64)(mbox.stats._N_ - self->last_stats._N_)) >= 0) \
+		curr_stats._N_ += mbox.stats._N_ - self->last_stats._N_; \
+	else \
+		corrupted_stats = true; \
+} while (0)
 
 	if (self->aq_link_status.mbps) {
 		AQ_SDELTA(uprc);
@@ -892,6 +900,9 @@ int hw_atl_utils_update_stats(struct aq_
 		AQ_SDELTA(bbrc);
 		AQ_SDELTA(bbtc);
 		AQ_SDELTA(dpc);
+
+		if (!corrupted_stats)
+			*cs = curr_stats;
 	}
 #undef AQ_SDELTA
 
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
@@ -239,7 +239,8 @@ struct version_s {
 		u8 minor;
 		u16 build;
 	} phy;
-	u32 rsvd;
+	u32 drv_iface_ver:4;
+	u32 rsvd:28;
 };
 
 struct link_status_s {
@@ -424,7 +425,7 @@ struct cable_diag_status_s {
 	u16 rsvd2;
 };
 
-struct statistics_s {
+struct statistics_a0_s {
 	struct {
 		u32 link_up;
 		u32 link_down;
@@ -457,6 +458,33 @@ struct statistics_s {
 	u32 reserve_fw_gap;
 };
 
+struct __packed statistics_b0_s {
+	u64 rx_good_octets;
+	u64 rx_pause_frames;
+	u64 rx_good_frames;
+	u64 rx_errors;
+	u64 rx_unicast_frames;
+	u64 rx_multicast_frames;
+	u64 rx_broadcast_frames;
+
+	u64 tx_good_octets;
+	u64 tx_pause_frames;
+	u64 tx_good_frames;
+	u64 tx_errors;
+	u64 tx_unicast_frames;
+	u64 tx_multicast_frames;
+	u64 tx_broadcast_frames;
+
+	u32 main_loop_cycles;
+};
+
+struct __packed statistics_s {
+	union __packed {
+		struct statistics_a0_s a0;
+		struct statistics_b0_s b0;
+	};
+};
+
 struct filter_caps_s {
 	u8 l2_filters_base_index:6;
 	u8 flexible_filter_mask:2;
@@ -545,7 +573,7 @@ struct management_status_s {
 	u32 rsvd5;
 };
 
-struct fw_interface_out {
+struct __packed fw_interface_out {
 	struct transaction_counter_s transaction_id;
 	struct version_s version;
 	struct link_status_s link_status;
@@ -569,7 +597,6 @@ struct fw_interface_out {
 	struct core_dump_s core_dump;
 	u32 rsvd11;
 	struct statistics_s stats;
-	u32 rsvd12;
 	struct filter_caps_s filter_caps;
 	struct device_caps_s device_caps;
 	u32 rsvd13;
@@ -592,6 +619,9 @@ struct fw_interface_out {
 #define  AQ_HOST_MODE_LOW_POWER    3U
 #define  AQ_HOST_MODE_SHUTDOWN     4U
 
+#define  AQ_A2_FW_INTERFACE_A0     0
+#define  AQ_A2_FW_INTERFACE_B0     1
+
 int hw_atl2_utils_initfw(struct aq_hw_s *self, const struct aq_fw_ops **fw_ops);
 
 int hw_atl2_utils_soft_reset(struct aq_hw_s *self);
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -333,18 +333,22 @@ static int aq_a2_fw_get_mac_permanent(st
 	return 0;
 }
 
-static int aq_a2_fw_update_stats(struct aq_hw_s *self)
+static void aq_a2_fill_a0_stats(struct aq_hw_s *self,
+				struct statistics_s *stats)
 {
 	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
-	struct statistics_s stats;
-	int err;
-
-	err = hw_atl2_shared_buffer_read_safe(self, stats, &stats);
-	if (err)
-		return err;
-
-#define AQ_SDELTA(_N_, _F_) (self->curr_stats._N_ += \
-			stats.msm._F_ - priv->last_stats.msm._F_)
+	struct aq_stats_s *cs = &self->curr_stats;
+	struct aq_stats_s curr_stats = *cs;
+	bool corrupted_stats = false;
+
+#define AQ_SDELTA(_N, _F)  \
+do { \
+	if (!corrupted_stats && \
+	    ((s64)(stats->a0.msm._F - priv->last_stats.a0.msm._F)) >= 0) \
+		curr_stats._N += stats->a0.msm._F - priv->last_stats.a0.msm._F;\
+	else \
+		corrupted_stats = true; \
+} while (0)
 
 	if (self->aq_link_status.mbps) {
 		AQ_SDELTA(uprc, rx_unicast_frames);
@@ -363,17 +367,76 @@ static int aq_a2_fw_update_stats(struct
 		AQ_SDELTA(mbtc, tx_multicast_octets);
 		AQ_SDELTA(bbrc, rx_broadcast_octets);
 		AQ_SDELTA(bbtc, tx_broadcast_octets);
+
+		if (!corrupted_stats)
+			*cs = curr_stats;
+	}
+#undef AQ_SDELTA
+
+}
+
+static void aq_a2_fill_b0_stats(struct aq_hw_s *self,
+				struct statistics_s *stats)
+{
+	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	struct aq_stats_s *cs = &self->curr_stats;
+	struct aq_stats_s curr_stats = *cs;
+	bool corrupted_stats = false;
+
+#define AQ_SDELTA(_N, _F)  \
+do { \
+	if (!corrupted_stats && \
+	    ((s64)(stats->b0._F - priv->last_stats.b0._F)) >= 0) \
+		curr_stats._N += stats->b0._F - priv->last_stats.b0._F; \
+	else \
+		corrupted_stats = true; \
+} while (0)
+
+	if (self->aq_link_status.mbps) {
+		AQ_SDELTA(uprc, rx_unicast_frames);
+		AQ_SDELTA(mprc, rx_multicast_frames);
+		AQ_SDELTA(bprc, rx_broadcast_frames);
+		AQ_SDELTA(erpr, rx_errors);
+		AQ_SDELTA(brc, rx_good_octets);
+
+		AQ_SDELTA(uptc, tx_unicast_frames);
+		AQ_SDELTA(mptc, tx_multicast_frames);
+		AQ_SDELTA(bptc, tx_broadcast_frames);
+		AQ_SDELTA(erpt, tx_errors);
+		AQ_SDELTA(btc, tx_good_octets);
+
+		if (!corrupted_stats)
+			*cs = curr_stats;
 	}
 #undef AQ_SDELTA
-	self->curr_stats.dma_pkt_rc =
-		hw_atl_stats_rx_dma_good_pkt_counter_get(self);
-	self->curr_stats.dma_pkt_tc =
-		hw_atl_stats_tx_dma_good_pkt_counter_get(self);
-	self->curr_stats.dma_oct_rc =
-		hw_atl_stats_rx_dma_good_octet_counter_get(self);
-	self->curr_stats.dma_oct_tc =
-		hw_atl_stats_tx_dma_good_octet_counter_get(self);
-	self->curr_stats.dpc = hw_atl_rpb_rx_dma_drop_pkt_cnt_get(self);
+}
+
+static int aq_a2_fw_update_stats(struct aq_hw_s *self)
+{
+	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	struct aq_stats_s *cs = &self->curr_stats;
+	struct statistics_s stats;
+	struct version_s version;
+	int err;
+
+	err = hw_atl2_shared_buffer_read_safe(self, version, &version);
+	if (err)
+		return err;
+
+	err = hw_atl2_shared_buffer_read_safe(self, stats, &stats);
+	if (err)
+		return err;
+
+	if (version.drv_iface_ver == AQ_A2_FW_INTERFACE_A0)
+		aq_a2_fill_a0_stats(self, &stats);
+	else
+		aq_a2_fill_b0_stats(self, &stats);
+
+	cs->dma_pkt_rc = hw_atl_stats_rx_dma_good_pkt_counter_get(self);
+	cs->dma_pkt_tc = hw_atl_stats_tx_dma_good_pkt_counter_get(self);
+	cs->dma_oct_rc = hw_atl_stats_rx_dma_good_octet_counter_get(self);
+	cs->dma_oct_tc = hw_atl_stats_tx_dma_good_octet_counter_get(self);
+	cs->dpc = hw_atl_rpb_rx_dma_drop_pkt_cnt_get(self);
 
 	memcpy(&priv->last_stats, &stats, sizeof(stats));
 



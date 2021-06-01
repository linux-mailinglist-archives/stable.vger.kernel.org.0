Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF53395D95
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhEaNrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230514AbhEaNpo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:45:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2F976157E;
        Mon, 31 May 2021 13:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467800;
        bh=RBuFwwfGdOCAAjiRqMrVgJ1fiSt/++8YAw8qaANfoYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qcXJ+dD5G/6Bxi9VjrHUQaBraH6W01PycnGC+gXM4UdL+Q0mE9svdJYDSNEl0rXWO
         zln+B/V8LEvlNjXkA6CiLhP+ZrAJIigfjnJdYz9PjbL0UTeQvYMhJ8w3mgNmJsCCRZ
         6N2mRgxkiglx4WhxbyNtK+/GWk4wXSdl3tU1KMMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Edward Cree <ecree@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 78/79] drivers/net/ethernet: clean up unused assignments
Date:   Mon, 31 May 2021 15:15:03 +0200
Message-Id: <20210531130638.496995162@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

commit 7c8c0291f84027558bd5fca5729cbcf288c510f4 upstream.

As part of the W=1 compliation series, these lines all created
warnings about unused variables that were assigned a value. Most
of them are from register reads, but some are just picking up
a return value from a function and never doing anything with it.

Fixed warnings:
.../ethernet/brocade/bna/bnad.c:3280:6: warning: variable ‘rx_count’ set but not used [-Wunused-but-set-variable]
.../ethernet/brocade/bna/bnad.c:3280:6: warning: variable ‘rx_count’ set but not used [-Wunused-but-set-variable]
.../ethernet/cortina/gemini.c:512:6: warning: variable ‘val’ set but not used [-Wunused-but-set-variable]
.../ethernet/cortina/gemini.c:2110:21: warning: variable ‘config0’ set but not used [-Wunused-but-set-variable]
.../ethernet/cavium/liquidio/octeon_device.c:1327:6: warning: variable ‘val32’ set but not used [-Wunused-but-set-variable]
.../ethernet/cavium/liquidio/octeon_device.c:1358:6: warning: variable ‘val32’ set but not used [-Wunused-but-set-variable]
.../ethernet/dec/tulip/media.c:322:8: warning: variable ‘setup’ set but not used [-Wunused-but-set-variable]
.../ethernet/dec/tulip/de4x5.c:4928:13: warning: variable ‘r3’ set but not used [-Wunused-but-set-variable]
.../ethernet/micrel/ksz884x.c:1652:7: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]
.../ethernet/micrel/ksz884x.c:1652:7: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]
.../ethernet/micrel/ksz884x.c:1652:7: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]
.../ethernet/micrel/ksz884x.c:1652:7: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]
.../ethernet/micrel/ksz884x.c:4981:6: warning: variable ‘rx_status’ set but not used [-Wunused-but-set-variable]
.../ethernet/micrel/ksz884x.c:6510:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]
.../ethernet/micrel/ksz884x.c:6087: warning: cannot understand function prototype: 'struct hw_regs '
.../ethernet/microchip/lan743x_main.c:161:6: warning: variable ‘int_en’ set but not used [-Wunused-but-set-variable]
.../ethernet/microchip/lan743x_main.c:1702:6: warning: variable ‘int_sts’ set but not used [-Wunused-but-set-variable]
.../ethernet/microchip/lan743x_main.c:3041:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
.../ethernet/natsemi/ns83820.c:603:6: warning: variable ‘tbisr’ set but not used [-Wunused-but-set-variable]
.../ethernet/natsemi/ns83820.c:1207:11: warning: variable ‘tanar’ set but not used [-Wunused-but-set-variable]
.../ethernet/marvell/mvneta.c:754:6: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]
.../ethernet/neterion/vxge/vxge-traffic.c:33:6: warning: variable ‘val64’ set but not used [-Wunused-but-set-variable]
.../ethernet/neterion/vxge/vxge-traffic.c:160:6: warning: variable ‘val64’ set but not used [-Wunused-but-set-variable]
.../ethernet/neterion/vxge/vxge-traffic.c:490:6: warning: variable ‘val32’ set but not used [-Wunused-but-set-variable]
.../ethernet/neterion/vxge/vxge-traffic.c:2378:6: warning: variable ‘val64’ set but not used [-Wunused-but-set-variable]
.../ethernet/packetengines/yellowfin.c:1063:18: warning: variable ‘yf_size’ set but not used [-Wunused-but-set-variable]
.../ethernet/realtek/8139cp.c:1242:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]
.../ethernet/mellanox/mlx4/en_tx.c:858:6: warning: variable ‘ring_cons’ set but not used [-Wunused-but-set-variable]
.../ethernet/sis/sis900.c:792:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
.../ethernet/sfc/falcon/farch.c:878:11: warning: variable ‘rx_ev_pkt_type’ set but not used [-Wunused-but-set-variable]
.../ethernet/sfc/falcon/farch.c:877:23: warning: variable ‘rx_ev_mcast_pkt’ set but not used [-Wunused-but-set-variable]
.../ethernet/sfc/falcon/farch.c:877:7: warning: variable ‘rx_ev_hdr_type’ set but not used [-Wunused-but-set-variable]
.../ethernet/sfc/falcon/farch.c:876:7: warning: variable ‘rx_ev_other_err’ set but not used [-Wunused-but-set-variable]
.../ethernet/sfc/falcon/farch.c:1646:21: warning: variable ‘buftbl_min’ set but not used [-Wunused-but-set-variable]
.../ethernet/sfc/falcon/farch.c:2535:32: warning: variable ‘spec’ set but not used [-Wunused-but-set-variable]
.../ethernet/via/via-velocity.c:880:6: warning: variable ‘curr_status’ set but not used [-Wunused-but-set-variable]
.../ethernet/ti/tlan.c:656:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]
.../ethernet/ti/davinci_emac.c:1230:6: warning: variable ‘num_tx_pkts’ set but not used [-Wunused-but-set-variable]
.../ethernet/synopsys/dwc-xlgmac-common.c:516:8: warning: variable ‘str’ set but not used [-Wunused-but-set-variable]
.../ethernet/ti/cpsw_new.c:1662:22: warning: variable ‘priv’ set but not used [-Wunused-but-set-variable]

The register reads should be OK, because the current
implementation of readl and friends will always execute even
without an lvalue.

When it makes sense, just remove the lvalue assignment and the
local. Other times, just remove the offending code, and
occasionally, just mark the variable as maybe unused since it
could be used in an ifdef or debug scenario.

Only compile tested with W=1.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[fixes gcc-11 build warnings - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/brocade/bna/bnad.c           |    7 +---
 drivers/net/ethernet/dec/tulip/de4x5.c            |    4 +-
 drivers/net/ethernet/dec/tulip/media.c            |    5 ---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c        |    2 -
 drivers/net/ethernet/micrel/ksz884x.c             |    3 --
 drivers/net/ethernet/neterion/vxge/vxge-traffic.c |   32 +++++++---------------
 drivers/net/ethernet/sfc/falcon/farch.c           |   29 +++++++------------
 drivers/net/ethernet/sis/sis900.c                 |    5 +--
 drivers/net/ethernet/synopsys/dwc-xlgmac-common.c |    2 -
 drivers/net/ethernet/ti/davinci_emac.c            |    5 +--
 drivers/net/ethernet/ti/tlan.c                    |    4 --
 drivers/net/ethernet/via/via-velocity.c           |   13 --------
 12 files changed, 34 insertions(+), 77 deletions(-)

--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3292,7 +3292,7 @@ bnad_change_mtu(struct net_device *netde
 {
 	int err, mtu;
 	struct bnad *bnad = netdev_priv(netdev);
-	u32 rx_count = 0, frame, new_frame;
+	u32 frame, new_frame;
 
 	mutex_lock(&bnad->conf_mutex);
 
@@ -3308,12 +3308,9 @@ bnad_change_mtu(struct net_device *netde
 		/* only when transition is over 4K */
 		if ((frame <= 4096 && new_frame > 4096) ||
 		    (frame > 4096 && new_frame <= 4096))
-			rx_count = bnad_reinit_rx(bnad);
+			bnad_reinit_rx(bnad);
 	}
 
-	/* rx_count > 0 - new rx created
-	 *	- Linux set err = 0 and return
-	 */
 	err = bnad_mtu_set(bnad, new_frame);
 	if (err)
 		err = -EBUSY;
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -4922,11 +4922,11 @@ mii_get_oui(u_char phyaddr, u_long ioadd
 	u_char breg[2];
     } a;
     int i, r2, r3, ret=0;*/
-    int r2, r3;
+    int r2;
 
     /* Read r2 and r3 */
     r2 = mii_rd(MII_ID0, phyaddr, ioaddr);
-    r3 = mii_rd(MII_ID1, phyaddr, ioaddr);
+    mii_rd(MII_ID1, phyaddr, ioaddr);
                                                 /* SEEQ and Cypress way * /
     / * Shuffle r2 and r3 * /
     a.reg=0;
--- a/drivers/net/ethernet/dec/tulip/media.c
+++ b/drivers/net/ethernet/dec/tulip/media.c
@@ -319,13 +319,8 @@ void tulip_select_media(struct net_devic
 			break;
 		}
 		case 5: case 6: {
-			u16 setup[5];
-
 			new_csr6 = 0; /* FIXME */
 
-			for (i = 0; i < 5; i++)
-				setup[i] = get_u16(&p[i*2 + 1]);
-
 			if (startup && mtable->has_reset) {
 				struct medialeaf *rleaf = &mtable->mleaf[mtable->has_reset];
 				unsigned char *rst = rleaf->leafdata;
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -861,6 +861,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff
 	struct mlx4_en_tx_desc *tx_desc;
 	struct mlx4_wqe_data_seg *data;
 	struct mlx4_en_tx_info *tx_info;
+	u32 __maybe_unused ring_cons;
 	int tx_ind;
 	int nr_txbb;
 	int desc_size;
@@ -874,7 +875,6 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff
 	bool stop_queue;
 	bool inline_ok;
 	u8 data_offset;
-	u32 ring_cons;
 	bool bf_ok;
 
 	tx_ind = skb_get_queue_mapping(skb);
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -1657,8 +1657,7 @@ static inline void set_tx_len(struct ksz
 
 #define HW_DELAY(hw, reg)			\
 	do {					\
-		u16 dummy;			\
-		dummy = readw(hw->io + reg);	\
+		readw(hw->io + reg);		\
 	} while (0)
 
 /**
--- a/drivers/net/ethernet/neterion/vxge/vxge-traffic.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-traffic.c
@@ -29,8 +29,6 @@
  */
 enum vxge_hw_status vxge_hw_vpath_intr_enable(struct __vxge_hw_vpath_handle *vp)
 {
-	u64 val64;
-
 	struct __vxge_hw_virtualpath *vpath;
 	struct vxge_hw_vpath_reg __iomem *vp_reg;
 	enum vxge_hw_status status = VXGE_HW_OK;
@@ -83,7 +81,7 @@ enum vxge_hw_status vxge_hw_vpath_intr_e
 	__vxge_hw_pio_mem_write32_upper((u32)VXGE_HW_INTR_MASK_ALL,
 			&vp_reg->xgmac_vp_int_status);
 
-	val64 = readq(&vp_reg->vpath_general_int_status);
+	readq(&vp_reg->vpath_general_int_status);
 
 	/* Mask unwanted interrupts */
 
@@ -156,8 +154,6 @@ exit:
 enum vxge_hw_status vxge_hw_vpath_intr_disable(
 			struct __vxge_hw_vpath_handle *vp)
 {
-	u64 val64;
-
 	struct __vxge_hw_virtualpath *vpath;
 	enum vxge_hw_status status = VXGE_HW_OK;
 	struct vxge_hw_vpath_reg __iomem *vp_reg;
@@ -178,8 +174,6 @@ enum vxge_hw_status vxge_hw_vpath_intr_d
 		(u32)VXGE_HW_INTR_MASK_ALL,
 		&vp_reg->vpath_general_int_mask);
 
-	val64 = VXGE_HW_TIM_CLR_INT_EN_VP(1 << (16 - vpath->vp_id));
-
 	writeq(VXGE_HW_INTR_MASK_ALL, &vp_reg->kdfcctl_errors_mask);
 
 	__vxge_hw_pio_mem_write32_upper((u32)VXGE_HW_INTR_MASK_ALL,
@@ -486,9 +480,7 @@ void vxge_hw_device_unmask_all(struct __
  */
 void vxge_hw_device_flush_io(struct __vxge_hw_device *hldev)
 {
-	u32 val32;
-
-	val32 = readl(&hldev->common_reg->titan_general_int_status);
+	readl(&hldev->common_reg->titan_general_int_status);
 }
 
 /**
@@ -1745,8 +1737,8 @@ void vxge_hw_fifo_txdl_free(struct __vxg
 enum vxge_hw_status
 vxge_hw_vpath_mac_addr_add(
 	struct __vxge_hw_vpath_handle *vp,
-	u8 (macaddr)[ETH_ALEN],
-	u8 (macaddr_mask)[ETH_ALEN],
+	u8 *macaddr,
+	u8 *macaddr_mask,
 	enum vxge_hw_vpath_mac_addr_add_mode duplicate_mode)
 {
 	u32 i;
@@ -1808,8 +1800,8 @@ exit:
 enum vxge_hw_status
 vxge_hw_vpath_mac_addr_get(
 	struct __vxge_hw_vpath_handle *vp,
-	u8 (macaddr)[ETH_ALEN],
-	u8 (macaddr_mask)[ETH_ALEN])
+	u8 *macaddr,
+	u8 *macaddr_mask)
 {
 	u32 i;
 	u64 data1 = 0ULL;
@@ -1860,8 +1852,8 @@ exit:
 enum vxge_hw_status
 vxge_hw_vpath_mac_addr_get_next(
 	struct __vxge_hw_vpath_handle *vp,
-	u8 (macaddr)[ETH_ALEN],
-	u8 (macaddr_mask)[ETH_ALEN])
+	u8 *macaddr,
+	u8 *macaddr_mask)
 {
 	u32 i;
 	u64 data1 = 0ULL;
@@ -1913,8 +1905,8 @@ exit:
 enum vxge_hw_status
 vxge_hw_vpath_mac_addr_delete(
 	struct __vxge_hw_vpath_handle *vp,
-	u8 (macaddr)[ETH_ALEN],
-	u8 (macaddr_mask)[ETH_ALEN])
+	u8 *macaddr,
+	u8 *macaddr_mask)
 {
 	u32 i;
 	u64 data1 = 0ULL;
@@ -2404,7 +2396,6 @@ enum vxge_hw_status vxge_hw_vpath_poll_r
 	u8 t_code;
 	enum vxge_hw_status status = VXGE_HW_OK;
 	void *first_rxdh;
-	u64 val64 = 0;
 	int new_count = 0;
 
 	ring->cmpl_cnt = 0;
@@ -2432,8 +2423,7 @@ enum vxge_hw_status vxge_hw_vpath_poll_r
 			}
 			writeq(VXGE_HW_PRC_RXD_DOORBELL_NEW_QW_CNT(new_count),
 				&ring->vp_reg->prc_rxd_doorbell);
-			val64 =
-			  readl(&ring->common_reg->titan_general_int_status);
+			readl(&ring->common_reg->titan_general_int_status);
 			ring->doorbell_cnt = 0;
 		}
 	}
--- a/drivers/net/ethernet/sfc/falcon/farch.c
+++ b/drivers/net/ethernet/sfc/falcon/farch.c
@@ -873,17 +873,12 @@ static u16 ef4_farch_handle_rx_not_ok(st
 {
 	struct ef4_channel *channel = ef4_rx_queue_channel(rx_queue);
 	struct ef4_nic *efx = rx_queue->efx;
-	bool rx_ev_buf_owner_id_err, rx_ev_ip_hdr_chksum_err;
+	bool __maybe_unused rx_ev_buf_owner_id_err, rx_ev_ip_hdr_chksum_err;
 	bool rx_ev_tcp_udp_chksum_err, rx_ev_eth_crc_err;
 	bool rx_ev_frm_trunc, rx_ev_drib_nib, rx_ev_tobe_disc;
-	bool rx_ev_other_err, rx_ev_pause_frm;
-	bool rx_ev_hdr_type, rx_ev_mcast_pkt;
-	unsigned rx_ev_pkt_type;
+	bool rx_ev_pause_frm;
 
-	rx_ev_hdr_type = EF4_QWORD_FIELD(*event, FSF_AZ_RX_EV_HDR_TYPE);
-	rx_ev_mcast_pkt = EF4_QWORD_FIELD(*event, FSF_AZ_RX_EV_MCAST_PKT);
 	rx_ev_tobe_disc = EF4_QWORD_FIELD(*event, FSF_AZ_RX_EV_TOBE_DISC);
-	rx_ev_pkt_type = EF4_QWORD_FIELD(*event, FSF_AZ_RX_EV_PKT_TYPE);
 	rx_ev_buf_owner_id_err = EF4_QWORD_FIELD(*event,
 						 FSF_AZ_RX_EV_BUF_OWNER_ID_ERR);
 	rx_ev_ip_hdr_chksum_err = EF4_QWORD_FIELD(*event,
@@ -896,10 +891,6 @@ static u16 ef4_farch_handle_rx_not_ok(st
 			  0 : EF4_QWORD_FIELD(*event, FSF_AA_RX_EV_DRIB_NIB));
 	rx_ev_pause_frm = EF4_QWORD_FIELD(*event, FSF_AZ_RX_EV_PAUSE_FRM_ERR);
 
-	/* Every error apart from tobe_disc and pause_frm */
-	rx_ev_other_err = (rx_ev_drib_nib | rx_ev_tcp_udp_chksum_err |
-			   rx_ev_buf_owner_id_err | rx_ev_eth_crc_err |
-			   rx_ev_frm_trunc | rx_ev_ip_hdr_chksum_err);
 
 	/* Count errors that are not in MAC stats.  Ignore expected
 	 * checksum errors during self-test. */
@@ -919,6 +910,13 @@ static u16 ef4_farch_handle_rx_not_ok(st
 	 * to a FIFO overflow.
 	 */
 #ifdef DEBUG
+	{
+	/* Every error apart from tobe_disc and pause_frm */
+
+	bool rx_ev_other_err = (rx_ev_drib_nib | rx_ev_tcp_udp_chksum_err |
+				rx_ev_buf_owner_id_err | rx_ev_eth_crc_err |
+				rx_ev_frm_trunc | rx_ev_ip_hdr_chksum_err);
+
 	if (rx_ev_other_err && net_ratelimit()) {
 		netif_dbg(efx, rx_err, efx->net_dev,
 			  " RX queue %d unexpected RX event "
@@ -935,6 +933,7 @@ static u16 ef4_farch_handle_rx_not_ok(st
 			  rx_ev_tobe_disc ? " [TOBE_DISC]" : "",
 			  rx_ev_pause_frm ? " [PAUSE]" : "");
 	}
+	}
 #endif
 
 	/* The frame must be discarded if any of these are true. */
@@ -1646,15 +1645,11 @@ void ef4_farch_rx_push_indir_table(struc
  */
 void ef4_farch_dimension_resources(struct ef4_nic *efx, unsigned sram_lim_qw)
 {
-	unsigned vi_count, buftbl_min;
+	unsigned vi_count;
 
 	/* Account for the buffer table entries backing the datapath channels
 	 * and the descriptor caches for those channels.
 	 */
-	buftbl_min = ((efx->n_rx_channels * EF4_MAX_DMAQ_SIZE +
-		       efx->n_tx_channels * EF4_TXQ_TYPES * EF4_MAX_DMAQ_SIZE +
-		       efx->n_channels * EF4_MAX_EVQ_SIZE)
-		      * sizeof(ef4_qword_t) / EF4_BUF_SIZE);
 	vi_count = max(efx->n_channels, efx->n_tx_channels * EF4_TXQ_TYPES);
 
 	efx->tx_dc_base = sram_lim_qw - vi_count * TX_DC_ENTRIES;
@@ -2535,7 +2530,6 @@ int ef4_farch_filter_remove_safe(struct
 	enum ef4_farch_filter_table_id table_id;
 	struct ef4_farch_filter_table *table;
 	unsigned int filter_idx;
-	struct ef4_farch_filter_spec *spec;
 	int rc;
 
 	table_id = ef4_farch_filter_id_table_id(filter_id);
@@ -2546,7 +2540,6 @@ int ef4_farch_filter_remove_safe(struct
 	filter_idx = ef4_farch_filter_id_index(filter_id);
 	if (filter_idx >= table->size)
 		return -ENOENT;
-	spec = &table->spec[filter_idx];
 
 	spin_lock_bh(&efx->filter_lock);
 	rc = ef4_farch_filter_remove(efx, table, filter_idx, priority);
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -783,10 +783,9 @@ static u16 sis900_default_phy(struct net
 static void sis900_set_capability(struct net_device *net_dev, struct mii_phy *phy)
 {
 	u16 cap;
-	u16 status;
 
-	status = mdio_read(net_dev, phy->phy_addr, MII_STATUS);
-	status = mdio_read(net_dev, phy->phy_addr, MII_STATUS);
+	mdio_read(net_dev, phy->phy_addr, MII_STATUS);
+	mdio_read(net_dev, phy->phy_addr, MII_STATUS);
 
 	cap = MII_NWAY_CSMA_CD |
 		((phy->status & MII_STAT_CAN_TX_FDX)? MII_NWAY_TX_FDX:0) |
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
@@ -523,7 +523,7 @@ void xlgmac_get_all_hw_features(struct x
 
 void xlgmac_print_all_hw_features(struct xlgmac_pdata *pdata)
 {
-	char *str = NULL;
+	char __maybe_unused *str = NULL;
 
 	XLGMAC_PR("\n");
 	XLGMAC_PR("=====================================================\n");
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1240,7 +1240,7 @@ static int emac_poll(struct napi_struct
 	struct net_device *ndev = priv->ndev;
 	struct device *emac_dev = &ndev->dev;
 	u32 status = 0;
-	u32 num_tx_pkts = 0, num_rx_pkts = 0;
+	u32 num_rx_pkts = 0;
 
 	/* Check interrupt vectors and call packet processing */
 	status = emac_read(EMAC_MACINVECTOR);
@@ -1251,8 +1251,7 @@ static int emac_poll(struct napi_struct
 		mask = EMAC_DM646X_MAC_IN_VECTOR_TX_INT_VEC;
 
 	if (status & mask) {
-		num_tx_pkts = cpdma_chan_process(priv->txchan,
-					      EMAC_DEF_TX_MAX_SERVICE);
+		cpdma_chan_process(priv->txchan, EMAC_DEF_TX_MAX_SERVICE);
 	} /* TX processing */
 
 	mask = EMAC_DM644X_MAC_IN_VECTOR_RX_INT_VEC;
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -672,7 +672,6 @@ module_exit(tlan_exit);
 static void  __init tlan_eisa_probe(void)
 {
 	long	ioaddr;
-	int	rc = -ENODEV;
 	int	irq;
 	u16	device_id;
 
@@ -737,8 +736,7 @@ static void  __init tlan_eisa_probe(void
 
 
 		/* Setup the newly found eisa adapter */
-		rc = tlan_probe1(NULL, ioaddr, irq,
-				 12, NULL);
+		tlan_probe1(NULL, ioaddr, irq, 12, NULL);
 		continue;
 
 out:
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -875,26 +875,13 @@ static u32 check_connection_type(struct
  */
 static int velocity_set_media_mode(struct velocity_info *vptr, u32 mii_status)
 {
-	u32 curr_status;
 	struct mac_regs __iomem *regs = vptr->mac_regs;
 
 	vptr->mii_status = mii_check_media_mode(vptr->mac_regs);
-	curr_status = vptr->mii_status & (~VELOCITY_LINK_FAIL);
 
 	/* Set mii link status */
 	set_mii_flow_control(vptr);
 
-	/*
-	   Check if new status is consistent with current status
-	   if (((mii_status & curr_status) & VELOCITY_AUTONEG_ENABLE) ||
-	       (mii_status==curr_status)) {
-	   vptr->mii_status=mii_check_media_mode(vptr->mac_regs);
-	   vptr->mii_status=check_connection_type(vptr->mac_regs);
-	   VELOCITY_PRT(MSG_LEVEL_INFO, "Velocity link no change\n");
-	   return 0;
-	   }
-	 */
-
 	if (PHYID_GET_PHY_ID(vptr->phy_id) == PHYID_CICADA_CS8201)
 		MII_REG_BITS_ON(AUXCR_MDPPS, MII_NCONFIG, vptr->mac_regs);
 



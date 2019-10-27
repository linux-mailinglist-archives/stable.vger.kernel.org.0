Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFAEE6871
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731071AbfJ0VUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731765AbfJ0VUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:20:49 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A6C4205C9;
        Sun, 27 Oct 2019 21:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211248;
        bh=IswQNomoTlHHAm0FBwOCISP18LNq/Etgz9qumUH61Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffAuIE6rvFWvGwdojsXTIOul5MSDSA8hEKrZjgbriWm+Lut3Ii7Qmk9Ojo5ZHqXGR
         peQaj3gFJlBQPSSgLxIEUT56Gg0zONDtFKe4xeSbyFOLUnMcZXoqjJfZpMYurKxI0i
         QaU2j+8LoT4rewpJJCMzbowvmgB/7V7JoKe39IgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 082/197] net: aquantia: when cleaning hw cache it should be toggled
Date:   Sun, 27 Oct 2019 22:00:00 +0100
Message-Id: <20191027203356.136876729@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Russkikh <Igor.Russkikh@aquantia.com>

[ Upstream commit ed4d81c4b3f28ccf624f11fd66f67aec5b58859c ]

>From HW specification to correctly reset HW caches (this is a required
workaround when stopping the device), register bit should actually
be toggled.

It was previosly always just set. Due to the way driver stops HW this
never actually caused any issues, but it still may, so cleaning this up.

Fixes: 7a1bb49461b1 ("net: aquantia: fix potential IOMMU fault after driver unbind")
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c           |   16 +++++++-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c          |   17 +++++++-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h          |    7 ++-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h |   19 ++++++++++
 4 files changed, 53 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -968,14 +968,26 @@ static int hw_atl_b0_hw_interrupt_modera
 
 static int hw_atl_b0_hw_stop(struct aq_hw_s *self)
 {
+	int err;
+	u32 val;
+
 	hw_atl_b0_hw_irq_disable(self, HW_ATL_B0_INT_MASK);
 
 	/* Invalidate Descriptor Cache to prevent writing to the cached
 	 * descriptors and to the data pointer of those descriptors
 	 */
-	hw_atl_rdm_rx_dma_desc_cache_init_set(self, 1);
+	hw_atl_rdm_rx_dma_desc_cache_init_tgl(self);
+
+	err = aq_hw_err_from_flags(self);
+
+	if (err)
+		goto err_exit;
+
+	readx_poll_timeout_atomic(hw_atl_rdm_rx_dma_desc_cache_init_done_get,
+				  self, val, val == 1, 1000U, 10000U);
 
-	return aq_hw_err_from_flags(self);
+err_exit:
+	return err;
 }
 
 static int hw_atl_b0_hw_ring_tx_stop(struct aq_hw_s *self,
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -606,12 +606,25 @@ void hw_atl_rpb_rx_flow_ctl_mode_set(str
 			    HW_ATL_RPB_RX_FC_MODE_SHIFT, rx_flow_ctl_mode);
 }
 
-void hw_atl_rdm_rx_dma_desc_cache_init_set(struct aq_hw_s *aq_hw, u32 init)
+void hw_atl_rdm_rx_dma_desc_cache_init_tgl(struct aq_hw_s *aq_hw)
 {
+	u32 val;
+
+	val = aq_hw_read_reg_bit(aq_hw, HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_ADR,
+				 HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_MSK,
+				 HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_SHIFT);
+
 	aq_hw_write_reg_bit(aq_hw, HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_ADR,
 			    HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_MSK,
 			    HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_SHIFT,
-			    init);
+			    val ^ 1);
+}
+
+u32 hw_atl_rdm_rx_dma_desc_cache_init_done_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg_bit(aq_hw, RDM_RX_DMA_DESC_CACHE_INIT_DONE_ADR,
+				  RDM_RX_DMA_DESC_CACHE_INIT_DONE_MSK,
+				  RDM_RX_DMA_DESC_CACHE_INIT_DONE_SHIFT);
 }
 
 void hw_atl_rpb_rx_pkt_buff_size_per_tc_set(struct aq_hw_s *aq_hw,
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
@@ -313,8 +313,11 @@ void hw_atl_rpb_rx_pkt_buff_size_per_tc_
 					    u32 rx_pkt_buff_size_per_tc,
 					    u32 buffer);
 
-/* set rdm rx dma descriptor cache init */
-void hw_atl_rdm_rx_dma_desc_cache_init_set(struct aq_hw_s *aq_hw, u32 init);
+/* toggle rdm rx dma descriptor cache init */
+void hw_atl_rdm_rx_dma_desc_cache_init_tgl(struct aq_hw_s *aq_hw);
+
+/* get rdm rx dma descriptor cache init done */
+u32 hw_atl_rdm_rx_dma_desc_cache_init_done_get(struct aq_hw_s *aq_hw);
 
 /* set rx xoff enable (per tc) */
 void hw_atl_rpb_rx_xoff_en_per_tc_set(struct aq_hw_s *aq_hw, u32 rx_xoff_en_per_tc,
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
@@ -318,6 +318,25 @@
 /* default value of bitfield rdm_desc_init_i */
 #define HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_DEFAULT 0x0
 
+/* rdm_desc_init_done_i bitfield definitions
+ * preprocessor definitions for the bitfield rdm_desc_init_done_i.
+ * port="pif_rdm_desc_init_done_i"
+ */
+
+/* register address for bitfield rdm_desc_init_done_i */
+#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_ADR 0x00005a10
+/* bitmask for bitfield rdm_desc_init_done_i */
+#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_MSK 0x00000001U
+/* inverted bitmask for bitfield rdm_desc_init_done_i */
+#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_MSKN 0xfffffffe
+/* lower bit position of bitfield  rdm_desc_init_done_i */
+#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_SHIFT 0U
+/* width of bitfield rdm_desc_init_done_i */
+#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_WIDTH 1
+/* default value of bitfield rdm_desc_init_done_i */
+#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_DEFAULT 0x0
+
+
 /* rx int_desc_wrb_en bitfield definitions
  * preprocessor definitions for the bitfield "int_desc_wrb_en".
  * port="pif_rdm_int_desc_wrb_en_i"



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E704656FAD1
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbiGKJWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbiGKJVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:21:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4887357E25;
        Mon, 11 Jul 2022 02:13:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 753B6B80D2C;
        Mon, 11 Jul 2022 09:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBA7C34115;
        Mon, 11 Jul 2022 09:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530787;
        bh=Q2OKOD/haQ/o3d1xcNfN+9fE2JWTJc60uyvClTKxRjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9EMO46yKUqTTJwsU2kecqfS0G5VExzIkgYvTxq9unyEketS43vbFTP8Prwmmk9fl
         NKgf3GG6Y9DPAmsa0znGKrfkIInN/A2BNT0kCDhCGlZnGXKVCjC3lLOl10pk407RXF
         x13ctuArq4Xp++bhtnmfwqwHytX3Np0Ih4LK+ZBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lukasz Cieplicki <lukaszx.cieplicki@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.10 39/55] i40e: Fix dropped jumbo frames statistics
Date:   Mon, 11 Jul 2022 11:07:27 +0200
Message-Id: <20220711090542.910922495@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
References: <20220711090541.764895984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Cieplicki <lukaszx.cieplicki@intel.com>

[ Upstream commit 1adb1563e7b7ec659379a18e607e8bc3522d8a78 ]

Dropped packets caused by too large frames were not included in
dropped RX packets statistics.
Issue was caused by not reading the GL_RXERR1 register. That register
stores count of packet which was have been dropped due to too large
size.

Fix it by reading GL_RXERR1 register for each interface.

Repro steps:
Send a packet larger than the set MTU to SUT
Observe rx statists: ethtool -S <interface> | grep rx | grep -v ": 0"

Fixes: 41a9e55c89be ("i40e: add missing VSI statistics")
Signed-off-by: Lukasz Cieplicki <lukaszx.cieplicki@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h        | 16 ++++
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 73 +++++++++++++++++++
 .../net/ethernet/intel/i40e/i40e_register.h   | 13 ++++
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  1 +
 4 files changed, 103 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index effdc3361266..dd630b6bc74b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -37,6 +37,7 @@
 #include <net/tc_act/tc_mirred.h>
 #include <net/udp_tunnel.h>
 #include <net/xdp_sock.h>
+#include <linux/bitfield.h>
 #include "i40e_type.h"
 #include "i40e_prototype.h"
 #include <linux/net/intel/i40e_client.h>
@@ -991,6 +992,21 @@ static inline void i40e_write_fd_input_set(struct i40e_pf *pf,
 			  (u32)(val & 0xFFFFFFFFULL));
 }
 
+/**
+ * i40e_get_pf_count - get PCI PF count.
+ * @hw: pointer to a hw.
+ *
+ * Reports the function number of the highest PCI physical
+ * function plus 1 as it is loaded from the NVM.
+ *
+ * Return: PCI PF count.
+ **/
+static inline u32 i40e_get_pf_count(struct i40e_hw *hw)
+{
+	return FIELD_GET(I40E_GLGEN_PCIFCNCNT_PCIPFCNT_MASK,
+			 rd32(hw, I40E_GLGEN_PCIFCNCNT));
+}
+
 /* needed by i40e_ethtool.c */
 int i40e_up(struct i40e_vsi *vsi);
 void i40e_down(struct i40e_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 614f3e995100..58453f7958df 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -548,6 +548,47 @@ void i40e_pf_reset_stats(struct i40e_pf *pf)
 	pf->hw_csum_rx_error = 0;
 }
 
+/**
+ * i40e_compute_pci_to_hw_id - compute index form PCI function.
+ * @vsi: ptr to the VSI to read from.
+ * @hw: ptr to the hardware info.
+ **/
+static u32 i40e_compute_pci_to_hw_id(struct i40e_vsi *vsi, struct i40e_hw *hw)
+{
+	int pf_count = i40e_get_pf_count(hw);
+
+	if (vsi->type == I40E_VSI_SRIOV)
+		return (hw->port * BIT(7)) / pf_count + vsi->vf_id;
+
+	return hw->port + BIT(7);
+}
+
+/**
+ * i40e_stat_update64 - read and update a 64 bit stat from the chip.
+ * @hw: ptr to the hardware info.
+ * @hireg: the high 32 bit reg to read.
+ * @loreg: the low 32 bit reg to read.
+ * @offset_loaded: has the initial offset been loaded yet.
+ * @offset: ptr to current offset value.
+ * @stat: ptr to the stat.
+ *
+ * Since the device stats are not reset at PFReset, they will not
+ * be zeroed when the driver starts.  We'll save the first values read
+ * and use them as offsets to be subtracted from the raw values in order
+ * to report stats that count from zero.
+ **/
+static void i40e_stat_update64(struct i40e_hw *hw, u32 hireg, u32 loreg,
+			       bool offset_loaded, u64 *offset, u64 *stat)
+{
+	u64 new_data;
+
+	new_data = rd64(hw, loreg);
+
+	if (!offset_loaded || new_data < *offset)
+		*offset = new_data;
+	*stat = new_data - *offset;
+}
+
 /**
  * i40e_stat_update48 - read and update a 48 bit stat from the chip
  * @hw: ptr to the hardware info
@@ -619,6 +660,34 @@ static void i40e_stat_update_and_clear32(struct i40e_hw *hw, u32 reg, u64 *stat)
 	*stat += new_data;
 }
 
+/**
+ * i40e_stats_update_rx_discards - update rx_discards.
+ * @vsi: ptr to the VSI to be updated.
+ * @hw: ptr to the hardware info.
+ * @stat_idx: VSI's stat_counter_idx.
+ * @offset_loaded: ptr to the VSI's stat_offsets_loaded.
+ * @stat_offset: ptr to stat_offset to store first read of specific register.
+ * @stat: ptr to VSI's stat to be updated.
+ **/
+static void
+i40e_stats_update_rx_discards(struct i40e_vsi *vsi, struct i40e_hw *hw,
+			      int stat_idx, bool offset_loaded,
+			      struct i40e_eth_stats *stat_offset,
+			      struct i40e_eth_stats *stat)
+{
+	u64 rx_rdpc, rx_rxerr;
+
+	i40e_stat_update32(hw, I40E_GLV_RDPC(stat_idx), offset_loaded,
+			   &stat_offset->rx_discards, &rx_rdpc);
+	i40e_stat_update64(hw,
+			   I40E_GL_RXERR1H(i40e_compute_pci_to_hw_id(vsi, hw)),
+			   I40E_GL_RXERR1L(i40e_compute_pci_to_hw_id(vsi, hw)),
+			   offset_loaded, &stat_offset->rx_discards_other,
+			   &rx_rxerr);
+
+	stat->rx_discards = rx_rdpc + rx_rxerr;
+}
+
 /**
  * i40e_update_eth_stats - Update VSI-specific ethernet statistics counters.
  * @vsi: the VSI to be updated
@@ -678,6 +747,10 @@ void i40e_update_eth_stats(struct i40e_vsi *vsi)
 			   I40E_GLV_BPTCL(stat_idx),
 			   vsi->stat_offsets_loaded,
 			   &oes->tx_broadcast, &es->tx_broadcast);
+
+	i40e_stats_update_rx_discards(vsi, hw, stat_idx,
+				      vsi->stat_offsets_loaded, oes, es);
+
 	vsi->stat_offsets_loaded = true;
 }
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_register.h b/drivers/net/ethernet/intel/i40e/i40e_register.h
index 8335f151ceef..117fd9674d7f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_register.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_register.h
@@ -77,6 +77,11 @@
 #define I40E_GLGEN_MSRWD_MDIWRDATA_SHIFT 0
 #define I40E_GLGEN_MSRWD_MDIRDDATA_SHIFT 16
 #define I40E_GLGEN_MSRWD_MDIRDDATA_MASK I40E_MASK(0xFFFF, I40E_GLGEN_MSRWD_MDIRDDATA_SHIFT)
+#define I40E_GLGEN_PCIFCNCNT                0x001C0AB4 /* Reset: PCIR */
+#define I40E_GLGEN_PCIFCNCNT_PCIPFCNT_SHIFT 0
+#define I40E_GLGEN_PCIFCNCNT_PCIPFCNT_MASK  I40E_MASK(0x1F, I40E_GLGEN_PCIFCNCNT_PCIPFCNT_SHIFT)
+#define I40E_GLGEN_PCIFCNCNT_PCIVFCNT_SHIFT 16
+#define I40E_GLGEN_PCIFCNCNT_PCIVFCNT_MASK  I40E_MASK(0xFF, I40E_GLGEN_PCIFCNCNT_PCIVFCNT_SHIFT)
 #define I40E_GLGEN_RSTAT 0x000B8188 /* Reset: POR */
 #define I40E_GLGEN_RSTAT_DEVSTATE_SHIFT 0
 #define I40E_GLGEN_RSTAT_DEVSTATE_MASK I40E_MASK(0x3, I40E_GLGEN_RSTAT_DEVSTATE_SHIFT)
@@ -461,6 +466,14 @@
 #define I40E_VFQF_HKEY1_MAX_INDEX 12
 #define I40E_VFQF_HLUT1(_i, _VF) (0x00220000 + ((_i) * 1024 + (_VF) * 4)) /* _i=0...15, _VF=0...127 */ /* Reset: CORER */
 #define I40E_VFQF_HLUT1_MAX_INDEX 15
+#define I40E_GL_RXERR1H(_i)             (0x00318004 + ((_i) * 8)) /* _i=0...143 */ /* Reset: CORER */
+#define I40E_GL_RXERR1H_MAX_INDEX       143
+#define I40E_GL_RXERR1H_RXERR1H_SHIFT   0
+#define I40E_GL_RXERR1H_RXERR1H_MASK    I40E_MASK(0xFFFFFFFF, I40E_GL_RXERR1H_RXERR1H_SHIFT)
+#define I40E_GL_RXERR1L(_i)             (0x00318000 + ((_i) * 8)) /* _i=0...143 */ /* Reset: CORER */
+#define I40E_GL_RXERR1L_MAX_INDEX       143
+#define I40E_GL_RXERR1L_RXERR1L_SHIFT   0
+#define I40E_GL_RXERR1L_RXERR1L_MASK    I40E_MASK(0xFFFFFFFF, I40E_GL_RXERR1L_RXERR1L_SHIFT)
 #define I40E_GLPRT_BPRCH(_i) (0x003005E4 + ((_i) * 8)) /* _i=0...3 */ /* Reset: CORER */
 #define I40E_GLPRT_BPRCL(_i) (0x003005E0 + ((_i) * 8)) /* _i=0...3 */ /* Reset: CORER */
 #define I40E_GLPRT_BPTCH(_i) (0x00300A04 + ((_i) * 8)) /* _i=0...3 */ /* Reset: CORER */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index add67f7b73e8..446672a7e39f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -1172,6 +1172,7 @@ struct i40e_eth_stats {
 	u64 tx_broadcast;		/* bptc */
 	u64 tx_discards;		/* tdpc */
 	u64 tx_errors;			/* tepc */
+	u64 rx_discards_other;          /* rxerr1 */
 };
 
 /* Statistics collected per VEB per TC */
-- 
2.35.1




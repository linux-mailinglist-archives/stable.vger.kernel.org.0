Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0175E4CF69F
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbiCGJm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241113AbiCGJlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F08B4D;
        Mon,  7 Mar 2022 01:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28606B810B2;
        Mon,  7 Mar 2022 09:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B07C340F3;
        Mon,  7 Mar 2022 09:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646018;
        bh=EfXEDqoaenIu8ZmjzzJ9FjIo06SO7hiocNVYack6g20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NF/Aw27UrpEJ1oMSZAqmWACdgsMAC6pWZEmFbsbgJpGiC3KiQ5yqrsrDpYiKpD14u
         lr4GNyGcedE8rZNuyskjMHM8Vqmo3/lVe/eRZXDF3nFHCfpTVK/HvhkJeYfZqPk6rG
         tKN8NObVmI9E7izvT6S1yVS3DifLncwq7hfFr3h4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/262] octeontx2-af: cn10k: Use appropriate register for LMAC enable
Date:   Mon,  7 Mar 2022 10:17:31 +0100
Message-Id: <20220307091705.495024442@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit fae80edeafbbba5ef9a0423aa5e5515518626433 ]

CN10K platforms uses RPM(0..2)_MTI_MAC100(0..3)_COMMAND_CONFIG
register for lmac TX/RX enable whereas CN9xxx platforms use
CGX_CMRX_CONFIG register. This config change was missed when
adding support for CN10K RPM.

Fixes: 91c6945ea1f9 ("octeontx2-af: cn10k: Add RPM MAC support")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   |  2 +
 .../marvell/octeontx2/af/lmac_common.h        |  3 ++
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 39 +++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rpm.h   |  4 ++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  1 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 14 ++++++-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 10 ++---
 7 files changed, 66 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index d379a35c4618f..6b335139abe7f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1571,6 +1571,8 @@ static struct mac_ops	cgx_mac_ops    = {
 	.mac_enadis_pause_frm =		cgx_lmac_enadis_pause_frm,
 	.mac_pause_frm_config =		cgx_lmac_pause_frm_config,
 	.mac_enadis_ptp_config =	cgx_lmac_ptp_config,
+	.mac_rx_tx_enable =		cgx_lmac_rx_tx_enable,
+	.mac_tx_enable =		cgx_lmac_tx_enable,
 };
 
 static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index fc6e7423cbd81..b33e7d1d0851c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -107,6 +107,9 @@ struct mac_ops {
 	void			(*mac_enadis_ptp_config)(void  *cgxd,
 							 int lmac_id,
 							 bool enable);
+
+	int			(*mac_rx_tx_enable)(void *cgxd, int lmac_id, bool enable);
+	int			(*mac_tx_enable)(void *cgxd, int lmac_id, bool enable);
 };
 
 struct cgx {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index c8f20b36adc89..9ea2f6ac38ec1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -30,6 +30,8 @@ static struct mac_ops	rpm_mac_ops   = {
 	.mac_enadis_pause_frm =		rpm_lmac_enadis_pause_frm,
 	.mac_pause_frm_config =		rpm_lmac_pause_frm_config,
 	.mac_enadis_ptp_config =	rpm_lmac_ptp_config,
+	.mac_rx_tx_enable =		rpm_lmac_rx_tx_enable,
+	.mac_tx_enable =		rpm_lmac_tx_enable,
 };
 
 struct mac_ops *rpm_get_mac_ops(void)
@@ -54,6 +56,43 @@ int rpm_get_nr_lmacs(void *rpmd)
 	return hweight8(rpm_read(rpm, 0, CGXX_CMRX_RX_LMACS) & 0xFULL);
 }
 
+int rpm_lmac_tx_enable(void *rpmd, int lmac_id, bool enable)
+{
+	rpm_t *rpm = rpmd;
+	u64 cfg, last;
+
+	if (!is_lmac_valid(rpm, lmac_id))
+		return -ENODEV;
+
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	last = cfg;
+	if (enable)
+		cfg |= RPM_TX_EN;
+	else
+		cfg &= ~(RPM_TX_EN);
+
+	if (cfg != last)
+		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+	return !!(last & RPM_TX_EN);
+}
+
+int rpm_lmac_rx_tx_enable(void *rpmd, int lmac_id, bool enable)
+{
+	rpm_t *rpm = rpmd;
+	u64 cfg;
+
+	if (!is_lmac_valid(rpm, lmac_id))
+		return -ENODEV;
+
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	if (enable)
+		cfg |= RPM_RX_EN | RPM_TX_EN;
+	else
+		cfg &= ~(RPM_RX_EN | RPM_TX_EN);
+	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+	return 0;
+}
+
 void rpm_lmac_enadis_rx_pause_fwding(void *rpmd, int lmac_id, bool enable)
 {
 	rpm_t *rpm = rpmd;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index 57c8a687b488a..ff580311edd03 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -43,6 +43,8 @@
 #define RPMX_MTI_STAT_DATA_HI_CDC            0x10038
 
 #define RPM_LMAC_FWI			0xa
+#define RPM_TX_EN			BIT_ULL(0)
+#define RPM_RX_EN			BIT_ULL(1)
 
 /* Function Declarations */
 int rpm_get_nr_lmacs(void *rpmd);
@@ -57,4 +59,6 @@ int rpm_lmac_enadis_pause_frm(void *rpmd, int lmac_id, u8 tx_pause,
 int rpm_get_tx_stats(void *rpmd, int lmac_id, int idx, u64 *tx_stat);
 int rpm_get_rx_stats(void *rpmd, int lmac_id, int idx, u64 *rx_stat);
 void rpm_lmac_ptp_config(void *rpmd, int lmac_id, bool enable);
+int rpm_lmac_rx_tx_enable(void *rpmd, int lmac_id, bool enable);
+int rpm_lmac_tx_enable(void *rpmd, int lmac_id, bool enable);
 #endif /* RPM_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 8f81e468be048..a7213db38804b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -801,6 +801,7 @@ bool is_mac_feature_supported(struct rvu *rvu, int pf, int feature);
 u32  rvu_cgx_get_fifolen(struct rvu *rvu);
 void *rvu_first_cgx_pdata(struct rvu *rvu);
 int cgxlmac_to_pf(struct rvu *rvu, int cgx_id, int lmac_id);
+int rvu_cgx_config_tx(void *cgxd, int lmac_id, bool enable);
 
 int npc_get_nixlf_mcam_index(struct npc_mcam *mcam, u16 pcifunc, int nixlf,
 			     int type);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 5bdbc77aa721d..28ff67819566c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -442,16 +442,26 @@ void rvu_cgx_enadis_rx_bp(struct rvu *rvu, int pf, bool enable)
 int rvu_cgx_config_rxtx(struct rvu *rvu, u16 pcifunc, bool start)
 {
 	int pf = rvu_get_pf(pcifunc);
+	struct mac_ops *mac_ops;
 	u8 cgx_id, lmac_id;
+	void *cgxd;
 
 	if (!is_cgx_config_permitted(rvu, pcifunc))
 		return LMAC_AF_ERR_PERM_DENIED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	cgxd = rvu_cgx_pdata(cgx_id, rvu);
+	mac_ops = get_mac_ops(cgxd);
+
+	return mac_ops->mac_rx_tx_enable(cgxd, lmac_id, start);
+}
 
-	cgx_lmac_rx_tx_enable(rvu_cgx_pdata(cgx_id, rvu), lmac_id, start);
+int rvu_cgx_config_tx(void *cgxd, int lmac_id, bool enable)
+{
+	struct mac_ops *mac_ops;
 
-	return 0;
+	mac_ops = get_mac_ops(cgxd);
+	return mac_ops->mac_tx_enable(cgxd, lmac_id, enable);
 }
 
 void rvu_cgx_disable_dmac_entries(struct rvu *rvu, u16 pcifunc)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 143b554d044bf..603361c94786a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2068,8 +2068,8 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 	/* enable cgx tx if disabled */
 	if (is_pf_cgxmapped(rvu, pf)) {
 		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-		restore_tx_en = !cgx_lmac_tx_enable(rvu_cgx_pdata(cgx_id, rvu),
-						    lmac_id, true);
+		restore_tx_en = !rvu_cgx_config_tx(rvu_cgx_pdata(cgx_id, rvu),
+						   lmac_id, true);
 	}
 
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_SMQX_CFG(smq));
@@ -2092,7 +2092,7 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 	rvu_cgx_enadis_rx_bp(rvu, pf, true);
 	/* restore cgx tx state */
 	if (restore_tx_en)
-		cgx_lmac_tx_enable(rvu_cgx_pdata(cgx_id, rvu), lmac_id, false);
+		rvu_cgx_config_tx(rvu_cgx_pdata(cgx_id, rvu), lmac_id, false);
 	return err;
 }
 
@@ -3878,7 +3878,7 @@ nix_config_link_credits(struct rvu *rvu, int blkaddr, int link,
 	/* Enable cgx tx if disabled for credits to be back */
 	if (is_pf_cgxmapped(rvu, pf)) {
 		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-		restore_tx_en = !cgx_lmac_tx_enable(rvu_cgx_pdata(cgx_id, rvu),
+		restore_tx_en = !rvu_cgx_config_tx(rvu_cgx_pdata(cgx_id, rvu),
 						    lmac_id, true);
 	}
 
@@ -3918,7 +3918,7 @@ nix_config_link_credits(struct rvu *rvu, int blkaddr, int link,
 
 	/* Restore state of cgx tx */
 	if (restore_tx_en)
-		cgx_lmac_tx_enable(rvu_cgx_pdata(cgx_id, rvu), lmac_id, false);
+		rvu_cgx_config_tx(rvu_cgx_pdata(cgx_id, rvu), lmac_id, false);
 
 	mutex_unlock(&rvu->rsrc_lock);
 	return rc;
-- 
2.34.1




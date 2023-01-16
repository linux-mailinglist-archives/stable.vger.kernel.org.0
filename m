Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEAC66C5F7
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbjAPQMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbjAPQL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:11:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C70624102
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:07:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE7106102D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01ACDC433D2;
        Mon, 16 Jan 2023 16:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885249;
        bh=HCMmZuGcGoNoNakOvdHn5cYz7xR7FcG3jSUdokJ3VCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqE2tLfqlIOsDOgO/OqE5xWKLvdJqoAqYrtza7KeNI5wG86i3g4skvC2mKp3bJ+ZI
         fgZMtePMFMsDgvx9LypUg7U146cx9GwEdwTZbsAiHONjpXq8eMA081B8Siia6UmPqh
         rsWSoB0BPK2KhTJks+94SYdjmfJOChW6EtK0hQ5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 43/64] octeontx2-af: Map NIX block from CGX connection
Date:   Mon, 16 Jan 2023 16:51:50 +0100
Message-Id: <20230116154745.050400367@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit c5a73b632b901c4b07d156bb8a8a2c5517678f35 ]

Firmware configures NIX block mapping for all CGXs
to achieve maximum throughput. This patch reads
the configuration and create mapping between RVU
PF and NIX blocks. And for LBK VFs assign NIX0 for
even numbered VFs and NIX1 for odd numbered VFs.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b4e9b8763e41 ("octeontx2-af: Fix LMAC config in cgx_lmac_rx_tx_enable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 13 +++-
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  5 ++
 .../net/ethernet/marvell/octeontx2/af/rvu.c   | 61 ++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  2 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 15 +++++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 21 +++++--
 6 files changed, 107 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index fc27a40202c6..1a8f5a039d50 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -145,6 +145,16 @@ int cgx_get_cgxid(void *cgxd)
 	return cgx->cgx_id;
 }
 
+u8 cgx_lmac_get_p2x(int cgx_id, int lmac_id)
+{
+	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
+	u64 cfg;
+
+	cfg = cgx_read(cgx_dev, lmac_id, CGXX_CMRX_CFG);
+
+	return (cfg & CMR_P2X_SEL_MASK) >> CMR_P2X_SEL_SHIFT;
+}
+
 /* Ensure the required lock for event queue(where asynchronous events are
  * posted) is acquired before calling this API. Else an asynchronous event(with
  * latest link status) can reach the destination before this function returns
@@ -814,8 +824,7 @@ static int cgx_lmac_verify_fwi_version(struct cgx *cgx)
 	minor_ver = FIELD_GET(RESP_MINOR_VER, resp);
 	dev_dbg(dev, "Firmware command interface version = %d.%d\n",
 		major_ver, minor_ver);
-	if (major_ver != CGX_FIRMWARE_MAJOR_VER ||
-	    minor_ver != CGX_FIRMWARE_MINOR_VER)
+	if (major_ver != CGX_FIRMWARE_MAJOR_VER)
 		return -EIO;
 	else
 		return 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 27ca3291682b..bcfc3e5f66bb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -27,6 +27,10 @@
 
 /* Registers */
 #define CGXX_CMRX_CFG			0x00
+#define CMR_P2X_SEL_MASK		GENMASK_ULL(61, 59)
+#define CMR_P2X_SEL_SHIFT		59ULL
+#define CMR_P2X_SEL_NIX0		1ULL
+#define CMR_P2X_SEL_NIX1		2ULL
 #define CMR_EN				BIT_ULL(55)
 #define DATA_PKT_TX_EN			BIT_ULL(53)
 #define DATA_PKT_RX_EN			BIT_ULL(54)
@@ -142,5 +146,6 @@ int cgx_lmac_get_pause_frm(void *cgxd, int lmac_id,
 int cgx_lmac_set_pause_frm(void *cgxd, int lmac_id,
 			   u8 tx_pause, u8 rx_pause);
 void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable);
+u8 cgx_lmac_get_p2x(int cgx_id, int lmac_id);
 
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 9bab525ecd86..acbc67074f59 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1208,6 +1208,58 @@ int rvu_mbox_handler_detach_resources(struct rvu *rvu,
 	return rvu_detach_rsrcs(rvu, detach, detach->hdr.pcifunc);
 }
 
+static int rvu_get_nix_blkaddr(struct rvu *rvu, u16 pcifunc)
+{
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	int blkaddr = BLKADDR_NIX0, vf;
+	struct rvu_pfvf *pf;
+
+	/* All CGX mapped PFs are set with assigned NIX block during init */
+	if (is_pf_cgxmapped(rvu, rvu_get_pf(pcifunc))) {
+		pf = rvu_get_pfvf(rvu, pcifunc & ~RVU_PFVF_FUNC_MASK);
+		blkaddr = pf->nix_blkaddr;
+	} else if (is_afvf(pcifunc)) {
+		vf = pcifunc - 1;
+		/* Assign NIX based on VF number. All even numbered VFs get
+		 * NIX0 and odd numbered gets NIX1
+		 */
+		blkaddr = (vf & 1) ? BLKADDR_NIX1 : BLKADDR_NIX0;
+		/* NIX1 is not present on all silicons */
+		if (!is_block_implemented(rvu->hw, BLKADDR_NIX1))
+			blkaddr = BLKADDR_NIX0;
+	}
+
+	switch (blkaddr) {
+	case BLKADDR_NIX1:
+		pfvf->nix_blkaddr = BLKADDR_NIX1;
+		break;
+	case BLKADDR_NIX0:
+	default:
+		pfvf->nix_blkaddr = BLKADDR_NIX0;
+		break;
+	}
+
+	return pfvf->nix_blkaddr;
+}
+
+static int rvu_get_attach_blkaddr(struct rvu *rvu, int blktype, u16 pcifunc)
+{
+	int blkaddr;
+
+	switch (blktype) {
+	case BLKTYPE_NIX:
+		blkaddr = rvu_get_nix_blkaddr(rvu, pcifunc);
+		break;
+	default:
+		return rvu_get_blkaddr(rvu, blktype, 0);
+	};
+
+	if (is_block_implemented(rvu->hw, blkaddr))
+		return blkaddr;
+
+	return -ENODEV;
+}
+
 static void rvu_attach_block(struct rvu *rvu, int pcifunc,
 			     int blktype, int num_lfs)
 {
@@ -1221,7 +1273,7 @@ static void rvu_attach_block(struct rvu *rvu, int pcifunc,
 	if (!num_lfs)
 		return;
 
-	blkaddr = rvu_get_blkaddr(rvu, blktype, 0);
+	blkaddr = rvu_get_attach_blkaddr(rvu, blktype, pcifunc);
 	if (blkaddr < 0)
 		return;
 
@@ -1250,9 +1302,9 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 				       struct rsrc_attach *req, u16 pcifunc)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	int free_lfs, mappedlfs, blkaddr;
 	struct rvu_hwinfo *hw = rvu->hw;
 	struct rvu_block *block;
-	int free_lfs, mappedlfs;
 
 	/* Only one NPA LF can be attached */
 	if (req->npalf && !is_blktype_attached(pfvf, BLKTYPE_NPA)) {
@@ -1269,7 +1321,10 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 
 	/* Only one NIX LF can be attached */
 	if (req->nixlf && !is_blktype_attached(pfvf, BLKTYPE_NIX)) {
-		block = &hw->block[BLKADDR_NIX0];
+		blkaddr = rvu_get_attach_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+		if (blkaddr < 0)
+			return blkaddr;
+		block = &hw->block[blkaddr];
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (!free_lfs)
 			goto fail;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 0cb5093744fe..fc6d785b98dd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -183,6 +183,8 @@ struct rvu_pfvf {
 
 	bool	cgx_in_use; /* this PF/VF using CGX? */
 	int	cgx_users;  /* number of cgx users - used only by PFs */
+
+	u8	nix_blkaddr; /* BLKADDR_NIX0/1 assigned to this PF */
 };
 
 struct nix_txsch {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index f4ecc755eaff..6c6b411e78fd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -74,6 +74,20 @@ void *rvu_cgx_pdata(u8 cgx_id, struct rvu *rvu)
 	return rvu->cgx_idmap[cgx_id];
 }
 
+/* Based on P2X connectivity find mapped NIX block for a PF */
+static void rvu_map_cgx_nix_block(struct rvu *rvu, int pf,
+				  int cgx_id, int lmac_id)
+{
+	struct rvu_pfvf *pfvf = &rvu->pf[pf];
+	u8 p2x;
+
+	p2x = cgx_lmac_get_p2x(cgx_id, lmac_id);
+	/* Firmware sets P2X_SELECT as either NIX0 or NIX1 */
+	pfvf->nix_blkaddr = BLKADDR_NIX0;
+	if (p2x == CMR_P2X_SEL_NIX1)
+		pfvf->nix_blkaddr = BLKADDR_NIX1;
+}
+
 static int rvu_map_cgx_lmac_pf(struct rvu *rvu)
 {
 	struct npc_pkind *pkind = &rvu->hw->pkind;
@@ -117,6 +131,7 @@ static int rvu_map_cgx_lmac_pf(struct rvu *rvu)
 			rvu->cgxlmac2pf_map[CGX_OFFSET(cgx) + lmac] = 1 << pf;
 			free_pkind = rvu_alloc_rsrc(&pkind->rsrc);
 			pkind->pfchan_map[free_pkind] = ((pf) & 0x3F) << 16;
+			rvu_map_cgx_nix_block(rvu, pf, cgx, lmac);
 			rvu->cgx_mapped_pfs++;
 		}
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index f6a3cf3e6f23..9886a30e9723 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -187,8 +187,8 @@ static bool is_valid_txschq(struct rvu *rvu, int blkaddr,
 static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	int pkind, pf, vf, lbkid;
 	u8 cgx_id, lmac_id;
-	int pkind, pf, vf;
 	int err;
 
 	pf = rvu_get_pf(pcifunc);
@@ -221,13 +221,24 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 	case NIX_INTF_TYPE_LBK:
 		vf = (pcifunc & RVU_PFVF_FUNC_MASK) - 1;
 
+		/* If NIX1 block is present on the silicon then NIXes are
+		 * assigned alternatively for lbk interfaces. NIX0 should
+		 * send packets on lbk link 1 channels and NIX1 should send
+		 * on lbk link 0 channels for the communication between
+		 * NIX0 and NIX1.
+		 */
+		lbkid = 0;
+		if (rvu->hw->lbk_links > 1)
+			lbkid = vf & 0x1 ? 0 : 1;
+
 		/* Note that AF's VFs work in pairs and talk over consecutive
 		 * loopback channels.Therefore if odd number of AF VFs are
 		 * enabled then the last VF remains with no pair.
 		 */
-		pfvf->rx_chan_base = NIX_CHAN_LBK_CHX(0, vf);
-		pfvf->tx_chan_base = vf & 0x1 ? NIX_CHAN_LBK_CHX(0, vf - 1) :
-						NIX_CHAN_LBK_CHX(0, vf + 1);
+		pfvf->rx_chan_base = NIX_CHAN_LBK_CHX(lbkid, vf);
+		pfvf->tx_chan_base = vf & 0x1 ?
+					NIX_CHAN_LBK_CHX(lbkid, vf - 1) :
+					NIX_CHAN_LBK_CHX(lbkid, vf + 1);
 		pfvf->rx_chan_cnt = 1;
 		pfvf->tx_chan_cnt = 1;
 		rvu_npc_install_promisc_entry(rvu, pcifunc, nixlf,
@@ -3157,7 +3168,7 @@ int rvu_nix_init(struct rvu *rvu)
 	hw->cgx = (cfg >> 12) & 0xF;
 	hw->lmac_per_cgx = (cfg >> 8) & 0xF;
 	hw->cgx_links = hw->cgx * hw->lmac_per_cgx;
-	hw->lbk_links = 1;
+	hw->lbk_links = (cfg >> 24) & 0xF;
 	hw->sdp_links = 1;
 
 	/* Initialize admin queue */
-- 
2.35.1




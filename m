Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6596A4CF694
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237740AbiCGJmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241093AbiCGJlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841525D655;
        Mon,  7 Mar 2022 01:40:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DF726116E;
        Mon,  7 Mar 2022 09:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13467C340E9;
        Mon,  7 Mar 2022 09:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646007;
        bh=4hul46E6M13tu7nqzKV9JHzMnYCa+y8ZDlItbvwDFVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b38pec++lOYtlvsEdhM+n93Bm4e+kARxeLObnCfeuTkFAIMrlx4FxcXNrmvX+C3hR
         uiaXtcNDKSwiQBs/bPQifhigcUihtaYSPyFatoOPuTZoYIONZCkKMUM31bP8h8U2IX
         wia0WxLONJJoeWdBZ5azlv3YzX+TJGx8GEjP3kFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harman Kalra <hkalra@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/262] octeontx2-af: Reset PTP config in FLR handler
Date:   Mon,  7 Mar 2022 10:17:29 +0100
Message-Id: <20220307091705.439572677@linuxfoundation.org>
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

From: Harman Kalra <hkalra@marvell.com>

[ Upstream commit e37e08fffc373206ad4e905c05729ea6bbdcb22c ]

Upon receiving ptp config request from netdev interface , Octeontx2 MAC
block CGX is configured to append timestamp to every incoming packet
and NPC config is updated with DMAC offset change.

Currently this configuration is not reset in FLR handler. This patch
resets the same.

Signed-off-by: Harman Kalra <hkalra@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  3 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 14 ++++++++++++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index c3979ec2bb86d..8f81e468be048 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -220,6 +220,7 @@ struct rvu_pfvf {
 	u16		maxlen;
 	u16		minlen;
 
+	bool		hw_rx_tstamp_en; /* Is rx_tstamp enabled */
 	u8		mac_addr[ETH_ALEN]; /* MAC address of this PF/VF */
 	u8		default_mac[ETH_ALEN]; /* MAC address from FWdata */
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 21e5906bcc372..a5c717ad12c15 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -694,6 +694,7 @@ int rvu_mbox_handler_cgx_promisc_disable(struct rvu *rvu, struct msg_req *req,
 
 static int rvu_cgx_ptp_rx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 {
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	int pf = rvu_get_pf(pcifunc);
 	u8 cgx_id, lmac_id;
 	void *cgxd;
@@ -718,6 +719,8 @@ static int rvu_cgx_ptp_rx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 	 */
 	if (npc_config_ts_kpuaction(rvu, pf, pcifunc, enable))
 		return -EINVAL;
+	/* This flag is required to clean up CGX conf if app gets killed */
+	pfvf->hw_rx_tstamp_en = enable;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index f43df4683943d..8c94e30d0499e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4519,6 +4519,9 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	struct hwctx_disable_req ctx_req;
+	int pf = rvu_get_pf(pcifunc);
+	u8 cgx_id, lmac_id;
+	void *cgxd;
 	int err;
 
 	ctx_req.hdr.pcifunc = pcifunc;
@@ -4559,6 +4562,17 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 	rvu_npc_set_parse_mode(rvu, pcifunc, OTX2_PRIV_FLAGS_DEFAULT,
 			       (PKIND_TX | PKIND_RX), 0, 0, 0, 0);
 
+	/* Disabling CGX and NPC config done for PTP */
+	if (pfvf->hw_rx_tstamp_en) {
+		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+		cgxd = rvu_cgx_pdata(cgx_id, rvu);
+		cgx_lmac_ptp_config(cgxd, lmac_id, false);
+		/* Undo NPC config done for PTP */
+		if (npc_config_ts_kpuaction(rvu, pf, pcifunc, false))
+			dev_err(rvu->dev, "NPC config for PTP failed\n");
+		pfvf->hw_rx_tstamp_en = false;
+	}
+
 	nix_ctx_free(rvu, pfvf);
 
 	nix_free_all_bandprof(rvu, pcifunc);
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9626C40958C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244954AbhIMOmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242854AbhIMOkf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:40:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA0A56320F;
        Mon, 13 Sep 2021 13:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541376;
        bh=YVf2V0bexvNfWf0wlDySAFg1Sr3GrSOrQ+gGlduhDc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F9887o/KWgHE9/KPman3lpp3kDocouvY5KvD6M8hOrxQ88Ps1z26sltXzwTYVodEK
         iAc4Yao1ZRVqIUSY9wneqdyeJ7mZznwFDLeiB/aMqkxIsH9VlLMHHDvISuGZyAALWx
         LZ9fJmVmgPwSDo22+n3PvHqLekat87bOrXzLyeOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 240/334] octeontx2-af: cn10k: Fix SDP base channel number
Date:   Mon, 13 Sep 2021 15:14:54 +0200
Message-Id: <20210913131121.518699500@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 477b53f3f95ba5341b4320f8b7a92cedc5a67650 ]

As per hardware the base channel number configured
for programmable channels of a block must be multiple
of number of channels of that block. This condition
is not met for SDP base channel currently. Hence this
patch ensures all the base channel numbers of all
blocks are multiple of number of channels present in
the blocks. Also instead of hardcoding SDP number
of channels the same is read from the NIX_AF_CONST1
register.

Fixes: 242da439214b ("octeontx2-af: cn10k: Add support for programmable")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/common.h    |  2 --
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c | 31 +++++++++++++------
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index 47f5ed006a93..e0b43aad203c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -195,8 +195,6 @@ enum nix_scheduler {
 #define NIX_CHAN_LBK_CHX(a, b)		(0 + 0x100 * (a) + (b))
 #define NIX_CHAN_SDP_CH_START		(0x700ull)
 
-#define SDP_CHANNELS			256
-
 /* The mask is to extract lower 10-bits of channel number
  * which CPT will pass to X2P.
  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index 8d48b64485c6..28dcce7d575a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -212,9 +212,10 @@ void rvu_reset_lmt_map_tbl(struct rvu *rvu, u16 pcifunc)
 
 int rvu_set_channels_base(struct rvu *rvu)
 {
+	u16 nr_lbk_chans, nr_sdp_chans, nr_cgx_chans, nr_cpt_chans;
+	u16 sdp_chan_base, cgx_chan_base, cpt_chan_base;
 	struct rvu_hwinfo *hw = rvu->hw;
-	u16 cpt_chan_base;
-	u64 nix_const;
+	u64 nix_const, nix_const1;
 	int blkaddr;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
@@ -222,6 +223,7 @@ int rvu_set_channels_base(struct rvu *rvu)
 		return blkaddr;
 
 	nix_const = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
+	nix_const1 = rvu_read64(rvu, blkaddr, NIX_AF_CONST1);
 
 	hw->cgx = (nix_const >> 12) & 0xFULL;
 	hw->lmac_per_cgx = (nix_const >> 8) & 0xFULL;
@@ -244,14 +246,24 @@ int rvu_set_channels_base(struct rvu *rvu)
 	 * channels such that all channel numbers are contiguous
 	 * leaving no holes. This way the new CPT channels can be
 	 * accomodated. The order of channel numbers assigned is
-	 * LBK, SDP, CGX and CPT.
+	 * LBK, SDP, CGX and CPT. Also the base channel number
+	 * of a block must be multiple of number of channels
+	 * of the block.
 	 */
-	hw->sdp_chan_base = hw->lbk_chan_base + hw->lbk_links *
-				((nix_const >> 16) & 0xFFULL);
-	hw->cgx_chan_base = hw->sdp_chan_base + hw->sdp_links * SDP_CHANNELS;
+	nr_lbk_chans = (nix_const >> 16) & 0xFFULL;
+	nr_sdp_chans = nix_const1 & 0xFFFULL;
+	nr_cgx_chans = nix_const & 0xFFULL;
+	nr_cpt_chans = (nix_const >> 32) & 0xFFFULL;
 
-	cpt_chan_base = hw->cgx_chan_base + hw->cgx_links *
-				(nix_const & 0xFFULL);
+	sdp_chan_base = hw->lbk_chan_base + hw->lbk_links * nr_lbk_chans;
+	/* Round up base channel to multiple of number of channels */
+	hw->sdp_chan_base = ALIGN(sdp_chan_base, nr_sdp_chans);
+
+	cgx_chan_base = hw->sdp_chan_base + hw->sdp_links * nr_sdp_chans;
+	hw->cgx_chan_base = ALIGN(cgx_chan_base, nr_cgx_chans);
+
+	cpt_chan_base = hw->cgx_chan_base + hw->cgx_links * nr_cgx_chans;
+	hw->cpt_chan_base = ALIGN(cpt_chan_base, nr_cpt_chans);
 
 	/* Out of 4096 channels start CPT from 2048 so
 	 * that MSB for CPT channels is always set
@@ -355,6 +367,7 @@ err_put:
 
 static void __rvu_nix_set_channels(struct rvu *rvu, int blkaddr)
 {
+	u64 nix_const1 = rvu_read64(rvu, blkaddr, NIX_AF_CONST1);
 	u64 nix_const = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
 	u16 cgx_chans, lbk_chans, sdp_chans, cpt_chans;
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -364,7 +377,7 @@ static void __rvu_nix_set_channels(struct rvu *rvu, int blkaddr)
 
 	cgx_chans = nix_const & 0xFFULL;
 	lbk_chans = (nix_const >> 16) & 0xFFULL;
-	sdp_chans = SDP_CHANNELS;
+	sdp_chans = nix_const1 & 0xFFFULL;
 	cpt_chans = (nix_const >> 32) & 0xFFFULL;
 
 	start = hw->cgx_chan_base;
-- 
2.30.2




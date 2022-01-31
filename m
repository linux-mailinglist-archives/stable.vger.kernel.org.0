Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034724A4393
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376759AbiAaLWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378555AbiAaLUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCC6C0604DB;
        Mon, 31 Jan 2022 03:12:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D491B82A61;
        Mon, 31 Jan 2022 11:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD653C340F1;
        Mon, 31 Jan 2022 11:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627562;
        bh=dq29fNhTgV2I6TGTwgwj+wZlld+lEadB7ixlwNOPwP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nlys6mfyfRfRC3ymmefYePSWijT/o5N+MEZuYMm036vjb6ia3mPYKnBcPcoZMtoaD
         4ClHb0Ju5XtNIGw6CPIdOgUr3cDFO+0CWvP9JAomECTk/Un9He6KWeji5jDm8oHQpy
         A9dptYBmeVpdb3TM90a1c4VUkBuxzlTlxZhapMa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/171] octeontx2-af: verify CQ context updates
Date:   Mon, 31 Jan 2022 11:56:29 +0100
Message-Id: <20220131105234.225740469@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 14e94f9445a9e91d460f5d4b519f8892c3fb14bb ]

As per HW errata AQ modification to CQ could be discarded on heavy
traffic. This patch implements workaround for the same after each
CQ write by AQ check whether the requested fields (except those
which HW can update eg: avg_level) are properly updated or not.

If CQ context is not updated then perform AQ write again.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  2 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 78 ++++++++++++++++++-
 2 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 154877706a0e1..a8618259de943 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -698,6 +698,8 @@ enum nix_af_status {
 	NIX_AF_ERR_INVALID_BANDPROF = -426,
 	NIX_AF_ERR_IPOLICER_NOTSUPP = -427,
 	NIX_AF_ERR_BANDPROF_INVAL_REQ  = -428,
+	NIX_AF_ERR_CQ_CTX_WRITE_ERR  = -429,
+	NIX_AF_ERR_AQ_CTX_RETRY_WRITE  = -430,
 };
 
 /* For NIX RX vtag action  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 8ee324aabf2d6..9d4cc0ae61474 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -28,6 +28,7 @@ static int nix_verify_bandprof(struct nix_cn10k_aq_enq_req *req,
 static int nix_free_all_bandprof(struct rvu *rvu, u16 pcifunc);
 static void nix_clear_ratelimit_aggr(struct rvu *rvu, struct nix_hw *nix_hw,
 				     u32 leaf_prof);
+static const char *nix_get_ctx_name(int ctype);
 
 enum mc_tbl_sz {
 	MC_TBL_SZ_256,
@@ -1061,10 +1062,68 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 	return 0;
 }
 
+static int rvu_nix_verify_aq_ctx(struct rvu *rvu, struct nix_hw *nix_hw,
+				 struct nix_aq_enq_req *req, u8 ctype)
+{
+	struct nix_cn10k_aq_enq_req aq_req;
+	struct nix_cn10k_aq_enq_rsp aq_rsp;
+	int rc, word;
+
+	if (req->ctype != NIX_AQ_CTYPE_CQ)
+		return 0;
+
+	rc = nix_aq_context_read(rvu, nix_hw, &aq_req, &aq_rsp,
+				 req->hdr.pcifunc, ctype, req->qidx);
+	if (rc) {
+		dev_err(rvu->dev,
+			"%s: Failed to fetch %s%d context of PFFUNC 0x%x\n",
+			__func__, nix_get_ctx_name(ctype), req->qidx,
+			req->hdr.pcifunc);
+		return rc;
+	}
+
+	/* Make copy of original context & mask which are required
+	 * for resubmission
+	 */
+	memcpy(&aq_req.cq_mask, &req->cq_mask, sizeof(struct nix_cq_ctx_s));
+	memcpy(&aq_req.cq, &req->cq, sizeof(struct nix_cq_ctx_s));
+
+	/* exclude fields which HW can update */
+	aq_req.cq_mask.cq_err       = 0;
+	aq_req.cq_mask.wrptr        = 0;
+	aq_req.cq_mask.tail         = 0;
+	aq_req.cq_mask.head	    = 0;
+	aq_req.cq_mask.avg_level    = 0;
+	aq_req.cq_mask.update_time  = 0;
+	aq_req.cq_mask.substream    = 0;
+
+	/* Context mask (cq_mask) holds mask value of fields which
+	 * are changed in AQ WRITE operation.
+	 * for example cq.drop = 0xa;
+	 *	       cq_mask.drop = 0xff;
+	 * Below logic performs '&' between cq and cq_mask so that non
+	 * updated fields are masked out for request and response
+	 * comparison
+	 */
+	for (word = 0; word < sizeof(struct nix_cq_ctx_s) / sizeof(u64);
+	     word++) {
+		*(u64 *)((u8 *)&aq_rsp.cq + word * 8) &=
+			(*(u64 *)((u8 *)&aq_req.cq_mask + word * 8));
+		*(u64 *)((u8 *)&aq_req.cq + word * 8) &=
+			(*(u64 *)((u8 *)&aq_req.cq_mask + word * 8));
+	}
+
+	if (memcmp(&aq_req.cq, &aq_rsp.cq, sizeof(struct nix_cq_ctx_s)))
+		return NIX_AF_ERR_AQ_CTX_RETRY_WRITE;
+
+	return 0;
+}
+
 static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 			       struct nix_aq_enq_rsp *rsp)
 {
 	struct nix_hw *nix_hw;
+	int err, retries = 5;
 	int blkaddr;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, req->hdr.pcifunc);
@@ -1075,7 +1134,24 @@ static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 	if (!nix_hw)
 		return NIX_AF_ERR_INVALID_NIXBLK;
 
-	return rvu_nix_blk_aq_enq_inst(rvu, nix_hw, req, rsp);
+retry:
+	err = rvu_nix_blk_aq_enq_inst(rvu, nix_hw, req, rsp);
+
+	/* HW errata 'AQ Modification to CQ could be discarded on heavy traffic'
+	 * As a work around perfrom CQ context read after each AQ write. If AQ
+	 * read shows AQ write is not updated perform AQ write again.
+	 */
+	if (!err && req->op == NIX_AQ_INSTOP_WRITE) {
+		err = rvu_nix_verify_aq_ctx(rvu, nix_hw, req, NIX_AQ_CTYPE_CQ);
+		if (err == NIX_AF_ERR_AQ_CTX_RETRY_WRITE) {
+			if (retries--)
+				goto retry;
+			else
+				return NIX_AF_ERR_CQ_CTX_WRITE_ERR;
+		}
+	}
+
+	return err;
 }
 
 static const char *nix_get_ctx_name(int ctype)
-- 
2.34.1




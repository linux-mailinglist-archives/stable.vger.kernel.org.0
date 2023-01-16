Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2323A66C5F4
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbjAPQMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbjAPQLx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:11:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02840265A9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:07:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89D46B81077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E142CC433D2;
        Mon, 16 Jan 2023 16:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885244;
        bh=M9AmzCVkCHCAy+qyFQllss6zakYYwp1vGngqlJHIk9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvmtyW4KBskXdDqZlVL3IQ1DAEKcdpXqSjTfcnAsIV121R7jrSYAGXf+8MG89M3V0
         62/lVnTyR2pUb99ij0ZzL090WK8xISmroPZC1jJ+Ruue21uWR3x0q7/ogy9p5HNL43
         XfXmBz1qwQx5MIWb8YVAwecyLwdofaF5tsAGgo/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 42/64] octeontx2-af: Update get/set resource count functions
Date:   Mon, 16 Jan 2023 16:51:49 +0100
Message-Id: <20230116154745.009518139@linuxfoundation.org>
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

[ Upstream commit cdd41e878526797df29903fe592d6a26b096ac7d ]

Since multiple blocks of same type are present in
98xx, modify functions which get resource count and
which update resource count to work with individual
block address instead of block type.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b4e9b8763e41 ("octeontx2-af: Fix LMAC config in cgx_lmac_rx_tx_enable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.c   | 73 +++++++++++++------
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  2 +
 2 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index c26652436c53..9bab525ecd86 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -316,31 +316,36 @@ static void rvu_update_rsrc_map(struct rvu *rvu, struct rvu_pfvf *pfvf,
 
 	block->fn_map[lf] = attach ? pcifunc : 0;
 
-	switch (block->type) {
-	case BLKTYPE_NPA:
+	switch (block->addr) {
+	case BLKADDR_NPA:
 		pfvf->npalf = attach ? true : false;
 		num_lfs = pfvf->npalf;
 		break;
-	case BLKTYPE_NIX:
+	case BLKADDR_NIX0:
+	case BLKADDR_NIX1:
 		pfvf->nixlf = attach ? true : false;
 		num_lfs = pfvf->nixlf;
 		break;
-	case BLKTYPE_SSO:
+	case BLKADDR_SSO:
 		attach ? pfvf->sso++ : pfvf->sso--;
 		num_lfs = pfvf->sso;
 		break;
-	case BLKTYPE_SSOW:
+	case BLKADDR_SSOW:
 		attach ? pfvf->ssow++ : pfvf->ssow--;
 		num_lfs = pfvf->ssow;
 		break;
-	case BLKTYPE_TIM:
+	case BLKADDR_TIM:
 		attach ? pfvf->timlfs++ : pfvf->timlfs--;
 		num_lfs = pfvf->timlfs;
 		break;
-	case BLKTYPE_CPT:
+	case BLKADDR_CPT0:
 		attach ? pfvf->cptlfs++ : pfvf->cptlfs--;
 		num_lfs = pfvf->cptlfs;
 		break;
+	case BLKADDR_CPT1:
+		attach ? pfvf->cpt1_lfs++ : pfvf->cpt1_lfs--;
+		num_lfs = pfvf->cpt1_lfs;
+		break;
 	}
 
 	reg = is_pf ? block->pf_lfcnt_reg : block->vf_lfcnt_reg;
@@ -1035,7 +1040,30 @@ int rvu_mbox_handler_ready(struct rvu *rvu, struct msg_req *req,
 /* Get current count of a RVU block's LF/slots
  * provisioned to a given RVU func.
  */
-static u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blktype)
+u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blkaddr)
+{
+	switch (blkaddr) {
+	case BLKADDR_NPA:
+		return pfvf->npalf ? 1 : 0;
+	case BLKADDR_NIX0:
+	case BLKADDR_NIX1:
+		return pfvf->nixlf ? 1 : 0;
+	case BLKADDR_SSO:
+		return pfvf->sso;
+	case BLKADDR_SSOW:
+		return pfvf->ssow;
+	case BLKADDR_TIM:
+		return pfvf->timlfs;
+	case BLKADDR_CPT0:
+		return pfvf->cptlfs;
+	case BLKADDR_CPT1:
+		return pfvf->cpt1_lfs;
+	}
+	return 0;
+}
+
+/* Return true if LFs of block type are attached to pcifunc */
+static bool is_blktype_attached(struct rvu_pfvf *pfvf, int blktype)
 {
 	switch (blktype) {
 	case BLKTYPE_NPA:
@@ -1043,15 +1071,16 @@ static u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blktype)
 	case BLKTYPE_NIX:
 		return pfvf->nixlf ? 1 : 0;
 	case BLKTYPE_SSO:
-		return pfvf->sso;
+		return !!pfvf->sso;
 	case BLKTYPE_SSOW:
-		return pfvf->ssow;
+		return !!pfvf->ssow;
 	case BLKTYPE_TIM:
-		return pfvf->timlfs;
+		return !!pfvf->timlfs;
 	case BLKTYPE_CPT:
-		return pfvf->cptlfs;
+		return pfvf->cptlfs || pfvf->cpt1_lfs;
 	}
-	return 0;
+
+	return false;
 }
 
 bool is_pffunc_map_valid(struct rvu *rvu, u16 pcifunc, int blktype)
@@ -1064,7 +1093,7 @@ bool is_pffunc_map_valid(struct rvu *rvu, u16 pcifunc, int blktype)
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
 
 	/* Check if this PFFUNC has a LF of type blktype attached */
-	if (!rvu_get_rsrc_mapcount(pfvf, blktype))
+	if (!is_blktype_attached(pfvf, blktype))
 		return false;
 
 	return true;
@@ -1105,7 +1134,7 @@ static void rvu_detach_block(struct rvu *rvu, int pcifunc, int blktype)
 
 	block = &hw->block[blkaddr];
 
-	num_lfs = rvu_get_rsrc_mapcount(pfvf, block->type);
+	num_lfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
 	if (!num_lfs)
 		return;
 
@@ -1226,7 +1255,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 	int free_lfs, mappedlfs;
 
 	/* Only one NPA LF can be attached */
-	if (req->npalf && !rvu_get_rsrc_mapcount(pfvf, BLKTYPE_NPA)) {
+	if (req->npalf && !is_blktype_attached(pfvf, BLKTYPE_NPA)) {
 		block = &hw->block[BLKADDR_NPA];
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (!free_lfs)
@@ -1239,7 +1268,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 	}
 
 	/* Only one NIX LF can be attached */
-	if (req->nixlf && !rvu_get_rsrc_mapcount(pfvf, BLKTYPE_NIX)) {
+	if (req->nixlf && !is_blktype_attached(pfvf, BLKTYPE_NIX)) {
 		block = &hw->block[BLKADDR_NIX0];
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (!free_lfs)
@@ -1260,7 +1289,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 				 pcifunc, req->sso, block->lf.max);
 			return -EINVAL;
 		}
-		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->type);
+		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		/* Check if additional resources are available */
 		if (req->sso > mappedlfs &&
@@ -1276,7 +1305,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 				 pcifunc, req->sso, block->lf.max);
 			return -EINVAL;
 		}
-		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->type);
+		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (req->ssow > mappedlfs &&
 		    ((req->ssow - mappedlfs) > free_lfs))
@@ -1291,7 +1320,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 				 pcifunc, req->timlfs, block->lf.max);
 			return -EINVAL;
 		}
-		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->type);
+		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (req->timlfs > mappedlfs &&
 		    ((req->timlfs - mappedlfs) > free_lfs))
@@ -1306,7 +1335,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 				 pcifunc, req->cptlfs, block->lf.max);
 			return -EINVAL;
 		}
-		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->type);
+		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (req->cptlfs > mappedlfs &&
 		    ((req->cptlfs - mappedlfs) > free_lfs))
@@ -1942,7 +1971,7 @@ static void rvu_blklf_teardown(struct rvu *rvu, u16 pcifunc, u8 blkaddr)
 
 	block = &rvu->hw->block[blkaddr];
 	num_lfs = rvu_get_rsrc_mapcount(rvu_get_pfvf(rvu, pcifunc),
-					block->type);
+					block->addr);
 	if (!num_lfs)
 		return;
 	for (slot = 0; slot < num_lfs; slot++) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 90eed3160915..0cb5093744fe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -137,6 +137,7 @@ struct rvu_pfvf {
 	u16		ssow;
 	u16		cptlfs;
 	u16		timlfs;
+	u16		cpt1_lfs;
 	u8		cgx_lmac;
 
 	/* Block LF's MSIX vector info */
@@ -420,6 +421,7 @@ void rvu_free_rsrc(struct rsrc_bmap *rsrc, int id);
 int rvu_rsrc_free_count(struct rsrc_bmap *rsrc);
 int rvu_alloc_rsrc_contig(struct rsrc_bmap *rsrc, int nrsrc);
 bool rvu_rsrc_check_contig(struct rsrc_bmap *rsrc, int nrsrc);
+u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blkaddr);
 int rvu_get_pf(u16 pcifunc);
 struct rvu_pfvf *rvu_get_pfvf(struct rvu *rvu, int pcifunc);
 void rvu_get_pf_numvfs(struct rvu *rvu, int pf, int *numvfs, int *hwvf);
-- 
2.35.1




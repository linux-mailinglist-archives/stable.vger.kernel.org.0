Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F566658006
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbiL1QNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234649AbiL1QMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:12:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61ED618B13
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:10:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 200F7B81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DF2C433EF;
        Wed, 28 Dec 2022 16:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243833;
        bh=oTgVX5QI6QmTMaNlU2Rhod3duPRSKyCResDUBIkwI5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aI98ToN1+GbTPfN9fWdtKm4+WtZuL4XYE44KfHALjkd2o5VBsd7LwgunuRrJdEaAy
         B+LRxsQGTttYD11+176VQw8nfmrdO6sWDEBfbZQmnk4ixkFwNnKFoBCgLBaPuqqRxR
         0RTqegDvY6r8JneM/VDKymR9ew2oWwssgQ8xqipw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0596/1073] RDMA/irdma: Do not request 2-level PBLEs for CQ alloc
Date:   Wed, 28 Dec 2022 15:36:24 +0100
Message-Id: <20221228144344.235813586@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 8f7e2daa6336f9f4b6f8a4715a809674606df16b ]

When allocating PBLE's for a large CQ, it is possible
that a 2-level PBLE is returned which would cause the
CQ allocation to fail since 1-level is assumed and checked for.
Fix this by requesting a level one PBLE only.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20221115011701.1379-4-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 01d0dc4b5649..dc3f5f3fee90 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2329,9 +2329,10 @@ static bool irdma_check_mr_contiguous(struct irdma_pble_alloc *palloc,
  * @rf: RDMA PCI function
  * @iwmr: mr pointer for this memory registration
  * @use_pbles: flag if to use pble's
+ * @lvl_1_only: request only level 1 pble if true
  */
 static int irdma_setup_pbles(struct irdma_pci_f *rf, struct irdma_mr *iwmr,
-			     bool use_pbles)
+			     bool use_pbles, bool lvl_1_only)
 {
 	struct irdma_pbl *iwpbl = &iwmr->iwpbl;
 	struct irdma_pble_alloc *palloc = &iwpbl->pble_alloc;
@@ -2342,7 +2343,7 @@ static int irdma_setup_pbles(struct irdma_pci_f *rf, struct irdma_mr *iwmr,
 
 	if (use_pbles) {
 		status = irdma_get_pble(rf->pble_rsrc, palloc, iwmr->page_cnt,
-					false);
+					lvl_1_only);
 		if (status)
 			return status;
 
@@ -2385,16 +2386,10 @@ static int irdma_handle_q_mem(struct irdma_device *iwdev,
 	bool ret = true;
 
 	pg_size = iwmr->page_size;
-	err = irdma_setup_pbles(iwdev->rf, iwmr, use_pbles);
+	err = irdma_setup_pbles(iwdev->rf, iwmr, use_pbles, true);
 	if (err)
 		return err;
 
-	if (use_pbles && palloc->level != PBLE_LEVEL_1) {
-		irdma_free_pble(iwdev->rf->pble_rsrc, palloc);
-		iwpbl->pbl_allocated = false;
-		return -ENOMEM;
-	}
-
 	if (use_pbles)
 		arr = palloc->level1.addr;
 
@@ -2870,7 +2865,7 @@ static struct ib_mr *irdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
 	case IRDMA_MEMREG_TYPE_MEM:
 		use_pbles = (iwmr->page_cnt != 1);
 
-		err = irdma_setup_pbles(iwdev->rf, iwmr, use_pbles);
+		err = irdma_setup_pbles(iwdev->rf, iwmr, use_pbles, false);
 		if (err)
 			goto error;
 
-- 
2.35.1




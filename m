Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB0366488A
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239049AbjAJSMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238820AbjAJSL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:11:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4C3E79
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7681061866
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1A0C433EF;
        Tue, 10 Jan 2023 18:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374219;
        bh=NTpdms+4SVNRd3++Je1zAbFqgYt4XUXRSbb7OazERnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVkHaDoxdohxwqHeuzWAFTVFaIAPHV6Au/VJ02n/riPfa5mitfGnL4fES+CUiVV/0
         FStmwsL22JVZqQ5Z2U+yg1OnXmzVkMyJb9Bj+EGqa4IgyetgCVfvr894mxdqHHC1Lw
         jxDzALV1rCXYKjWjtRpjmiViLOeyXTULiJ56SVKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 090/148] octeontx2-pf: Fix lmtst ID used in aura free
Date:   Tue, 10 Jan 2023 19:03:14 +0100
Message-Id: <20230110180020.054957731@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 4af1b64f80fbe1275fb02c5f1c0cef099a4a231f ]

Current code uses per_cpu pointer to get the lmtst_id mapped to
the core on which aura_free() is executed. Using per_cpu pointer
without preemption disable causing mismatch between lmtst_id and
core on which pointer gets freed. This patch fixes the issue by
disabling preemption around aura_free.

Fixes: ef6c8da71eaf ("octeontx2-pf: cn10K: Reserve LMTST lines per core")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/nic/otx2_common.c       | 30 +++++++++++++------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 9c2baa437c23..2926d754ade8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -977,6 +977,7 @@ static void otx2_pool_refill_task(struct work_struct *work)
 	rbpool = cq->rbpool;
 	free_ptrs = cq->pool_ptrs;
 
+	get_cpu();
 	while (cq->pool_ptrs) {
 		if (otx2_alloc_rbuf(pfvf, rbpool, &bufptr)) {
 			/* Schedule a WQ if we fails to free atleast half of the
@@ -996,6 +997,7 @@ static void otx2_pool_refill_task(struct work_struct *work)
 		pfvf->hw_ops->aura_freeptr(pfvf, qidx, bufptr + OTX2_HEAD_ROOM);
 		cq->pool_ptrs--;
 	}
+	put_cpu();
 	cq->refill_task_sched = false;
 }
 
@@ -1333,6 +1335,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 	if (err)
 		goto fail;
 
+	get_cpu();
 	/* Allocate pointers and free them to aura/pool */
 	for (qidx = 0; qidx < hw->tot_tx_queues; qidx++) {
 		pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
@@ -1341,18 +1344,24 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 		sq = &qset->sq[qidx];
 		sq->sqb_count = 0;
 		sq->sqb_ptrs = kcalloc(num_sqbs, sizeof(*sq->sqb_ptrs), GFP_KERNEL);
-		if (!sq->sqb_ptrs)
-			return -ENOMEM;
+		if (!sq->sqb_ptrs) {
+			err = -ENOMEM;
+			goto err_mem;
+		}
 
 		for (ptr = 0; ptr < num_sqbs; ptr++) {
-			if (otx2_alloc_rbuf(pfvf, pool, &bufptr))
-				return -ENOMEM;
+			err = otx2_alloc_rbuf(pfvf, pool, &bufptr);
+			if (err)
+				goto err_mem;
 			pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr);
 			sq->sqb_ptrs[sq->sqb_count++] = (u64)bufptr;
 		}
 	}
 
-	return 0;
+err_mem:
+	put_cpu();
+	return err ? -ENOMEM : 0;
+
 fail:
 	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
 	otx2_aura_pool_free(pfvf);
@@ -1391,18 +1400,21 @@ int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
 	if (err)
 		goto fail;
 
+	get_cpu();
 	/* Allocate pointers and free them to aura/pool */
 	for (pool_id = 0; pool_id < hw->rqpool_cnt; pool_id++) {
 		pool = &pfvf->qset.pool[pool_id];
 		for (ptr = 0; ptr < num_ptrs; ptr++) {
-			if (otx2_alloc_rbuf(pfvf, pool, &bufptr))
-				return -ENOMEM;
+			err = otx2_alloc_rbuf(pfvf, pool, &bufptr);
+			if (err)
+				goto err_mem;
 			pfvf->hw_ops->aura_freeptr(pfvf, pool_id,
 						   bufptr + OTX2_HEAD_ROOM);
 		}
 	}
-
-	return 0;
+err_mem:
+	put_cpu();
+	return err ? -ENOMEM : 0;
 fail:
 	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
 	otx2_aura_pool_free(pfvf);
-- 
2.35.1




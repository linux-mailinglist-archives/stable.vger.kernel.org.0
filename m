Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A01594C27
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344511AbiHPAY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348929AbiHPAXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:23:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719D517DAA3;
        Mon, 15 Aug 2022 13:34:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B70E60EE9;
        Mon, 15 Aug 2022 20:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A13C433D6;
        Mon, 15 Aug 2022 20:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595634;
        bh=b7HQ7HYv3Nl1NaFZpDeZ1AnQeVV75qbUAncsk6g7D+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MuUfSVuFIz3noToGz8EBWeQcZBlH8bRDjZPytF39RTzgLeUMDyGa3PHnBeO0+ovC5
         Ml/aveIt36hCqKTTLXGzDQVZj/zSlk/iXyzF8MJ1fA0URnd43zVYEmY6UiHgjno5yo
         Dxtm5pFoowhCrofWb/aQqPJMOKAI0rvMCssH3nIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        =?UTF-8?q?Michal=20Kalderon=C2=A0?= <michal.kalderon@marvell.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0825/1157] RDMA/qedr: Fix potential memory leak in __qedr_alloc_mr()
Date:   Mon, 15 Aug 2022 20:03:01 +0200
Message-Id: <20220815180512.491532380@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit b3236a64ddd125a455ef5b5316c1b9051b732974 ]

__qedr_alloc_mr() allocates a memory chunk for "mr->info.pbl_table" with
init_mr_info(). When rdma_alloc_tid() and rdma_register_tid() fail, "mr"
is released while "mr->info.pbl_table" is not released, which will lead
to a memory leak.

We should release the "mr->info.pbl_table" with qedr_free_pbl() when error
occurs to fix the memory leak.

Fixes: e0290cce6ac0 ("qedr: Add support for memory registeration verbs")
Link: https://lore.kernel.org/r/20220714061505.2342759-1-niejianglei2021@163.com
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Acked-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 03ed7c0fae50..d745ce9dc88a 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -3084,7 +3084,7 @@ static struct qedr_mr *__qedr_alloc_mr(struct ib_pd *ibpd,
 		else
 			DP_ERR(dev, "roce alloc tid returned error %d\n", rc);
 
-		goto err0;
+		goto err1;
 	}
 
 	/* Index only, 18 bit long, lkey = itid << 8 | key */
@@ -3108,7 +3108,7 @@ static struct qedr_mr *__qedr_alloc_mr(struct ib_pd *ibpd,
 	rc = dev->ops->rdma_register_tid(dev->rdma_ctx, &mr->hw_mr);
 	if (rc) {
 		DP_ERR(dev, "roce register tid returned an error %d\n", rc);
-		goto err1;
+		goto err2;
 	}
 
 	mr->ibmr.lkey = mr->hw_mr.itid << 8 | mr->hw_mr.key;
@@ -3117,8 +3117,10 @@ static struct qedr_mr *__qedr_alloc_mr(struct ib_pd *ibpd,
 	DP_DEBUG(dev, QEDR_MSG_MR, "alloc frmr: %x\n", mr->ibmr.lkey);
 	return mr;
 
-err1:
+err2:
 	dev->ops->rdma_free_tid(dev->rdma_ctx, mr->hw_mr.itid);
+err1:
+	qedr_free_pbl(dev, &mr->info.pbl_info, mr->info.pbl_table);
 err0:
 	kfree(mr);
 	return ERR_PTR(rc);
-- 
2.35.1




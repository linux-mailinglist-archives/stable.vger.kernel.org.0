Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D46593815
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343633AbiHOTTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345134AbiHOTSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:18:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0A057225;
        Mon, 15 Aug 2022 11:39:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95FB7B8106C;
        Mon, 15 Aug 2022 18:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB971C433D7;
        Mon, 15 Aug 2022 18:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588778;
        bh=uRIcDpi4J9GEUAUfU38PwmHkAVgIHy+LmKqX+Q4ftWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQUpxkcMMAkhMaRt9EhGSgTtCoCcFc1j4SGFe9ku+KNupGyPMxz5/uOOD9TlsyWj9
         i/LARcs3Z+HS1SBJIN89Mz144iEU4r0J+8MDA8xjFRJLu1nJQbCnsg9Blp7jIvssih
         8KAKXptvl4rbUAQFZNdZC6R+oicol7XjGAuONhXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        =?UTF-8?q?Michal=20Kalderon=C2=A0?= <michal.kalderon@marvell.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 511/779] RDMA/qedr: Fix potential memory leak in __qedr_alloc_mr()
Date:   Mon, 15 Aug 2022 20:02:35 +0200
Message-Id: <20220815180359.091906196@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 49dfedbc5665..bb0c2b93a34d 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -3093,7 +3093,7 @@ static struct qedr_mr *__qedr_alloc_mr(struct ib_pd *ibpd,
 		else
 			DP_ERR(dev, "roce alloc tid returned error %d\n", rc);
 
-		goto err0;
+		goto err1;
 	}
 
 	/* Index only, 18 bit long, lkey = itid << 8 | key */
@@ -3117,7 +3117,7 @@ static struct qedr_mr *__qedr_alloc_mr(struct ib_pd *ibpd,
 	rc = dev->ops->rdma_register_tid(dev->rdma_ctx, &mr->hw_mr);
 	if (rc) {
 		DP_ERR(dev, "roce register tid returned an error %d\n", rc);
-		goto err1;
+		goto err2;
 	}
 
 	mr->ibmr.lkey = mr->hw_mr.itid << 8 | mr->hw_mr.key;
@@ -3126,8 +3126,10 @@ static struct qedr_mr *__qedr_alloc_mr(struct ib_pd *ibpd,
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




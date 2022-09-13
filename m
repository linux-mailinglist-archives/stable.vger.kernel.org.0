Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6D35B702C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbiIMOUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233424AbiIMOTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:19:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA0F65253;
        Tue, 13 Sep 2022 07:13:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFEF9614AE;
        Tue, 13 Sep 2022 14:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94A7C433B5;
        Tue, 13 Sep 2022 14:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078338;
        bh=+8omGchND9kWU+qyE83SJ+1kuyAlSvlfczhPTE4giek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MF6O4+GtMUjiF202g8QephPqx7NH5oC3w4zyuDZasvOJJJuUHl+BE57FNre2RnIg7
         NOsidACNNqPbGKRFUcQ8qSDAfdquNtr0hojae1OTxg/tc/hK+78TFcCaUsMTPCTqP6
         PQT6GqIEXVVPk8m/ze/PJKhAbkrrArEHmLVpZr9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Aleksei Marov <aleksei.marov@ionos.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 074/192] RDMA/rtrs-srv: Pass the correct number of entries for dma mapped SGL
Date:   Tue, 13 Sep 2022 16:03:00 +0200
Message-Id: <20220913140413.653498212@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 56c310de0b4b3aca1c4fdd9c1093fc48372a7335 ]

ib_dma_map_sg() augments the SGL into a 'dma mapped SGL'. This process
may change the number of entries and the lengths of each entry.

Code that touches dma_address is iterating over the 'dma mapped SGL'
and must use dma_nents which returned from ib_dma_map_sg().

We should use the return count from ib_dma_map_sg for futher usage.

Fixes: 9cb837480424e ("RDMA/rtrs: server: main functionality")
Link: https://lore.kernel.org/r/20220818105355.110344-4-haris.iqbal@ionos.com
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: Aleksei Marov <aleksei.marov@ionos.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 24024bce25664..ee4876bdce4ac 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -600,7 +600,7 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 		struct sg_table *sgt = &srv_mr->sgt;
 		struct scatterlist *s;
 		struct ib_mr *mr;
-		int nr, chunks;
+		int nr, nr_sgt, chunks;
 
 		chunks = chunks_per_mr * mri;
 		if (!always_invalidate)
@@ -615,19 +615,19 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 			sg_set_page(s, srv->chunks[chunks + i],
 				    max_chunk_size, 0);
 
-		nr = ib_dma_map_sg(srv_path->s.dev->ib_dev, sgt->sgl,
+		nr_sgt = ib_dma_map_sg(srv_path->s.dev->ib_dev, sgt->sgl,
 				   sgt->nents, DMA_BIDIRECTIONAL);
-		if (nr < sgt->nents) {
-			err = nr < 0 ? nr : -EINVAL;
+		if (!nr_sgt) {
+			err = -EINVAL;
 			goto free_sg;
 		}
 		mr = ib_alloc_mr(srv_path->s.dev->ib_pd, IB_MR_TYPE_MEM_REG,
-				 sgt->nents);
+				 nr_sgt);
 		if (IS_ERR(mr)) {
 			err = PTR_ERR(mr);
 			goto unmap_sg;
 		}
-		nr = ib_map_mr_sg(mr, sgt->sgl, sgt->nents,
+		nr = ib_map_mr_sg(mr, sgt->sgl, nr_sgt,
 				  NULL, max_chunk_size);
 		if (nr < 0 || nr < sgt->nents) {
 			err = nr < 0 ? nr : -EINVAL;
@@ -646,7 +646,7 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 			}
 		}
 		/* Eventually dma addr for each chunk can be cached */
-		for_each_sg(sgt->sgl, s, sgt->orig_nents, i)
+		for_each_sg(sgt->sgl, s, nr_sgt, i)
 			srv_path->dma_addr[chunks + i] = sg_dma_address(s);
 
 		ib_update_fast_reg_key(mr, ib_inc_rkey(mr->rkey));
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88255B7068
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbiIMOcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234022AbiIMObf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:31:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB22642E7;
        Tue, 13 Sep 2022 07:19:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0857B80FAC;
        Tue, 13 Sep 2022 14:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C4FC4347C;
        Tue, 13 Sep 2022 14:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078702;
        bh=FfKZSeAKBmbF/IVmgbQkN7LB0RTe/5cI7GDXbScWuAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXgTordCdY+CRpypNO9MHHFeUblAhiwSgejXXVbQpAUcYQjaVoRo+dq9GEV+O/FaI
         HFZaCsIBvx1EC6E+yZknyQyQfFXFe7HUA0LbjPmne3LpbNL77iqVbOg3if7Mnyjizk
         gq1QtQ1EyaTSUNwipxxF8AEYAZ/GXYpCr+RqwOJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Aleksei Marov <aleksei.marov@ionos.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/121] RDMA/rtrs-clt: Use the right sg_cnt after ib_dma_map_sg
Date:   Tue, 13 Sep 2022 16:04:01 +0200
Message-Id: <20220913140359.507633593@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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

[ Upstream commit b66905e04dc714825aa6cffb950e281b46bbeafe ]

When iommu is enabled, we hit warnings like this:
WARNING: at rtrs/rtrs.c:178 rtrs_iu_post_rdma_write_imm+0x9b/0x110

rtrs warn on one sge entry length is 0, which is unexpected.

The problem is ib_dma_map_sg augments the SGL into a 'dma mapped SGL'.
This process may change the number of entries and the lengths of each
entry.

Code that touches dma_address is iterating over the 'dma mapped SGL'
and must use dma_nents which returned from ib_dma_map_sg().
So pass the count return from ib_dma_map_sg.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Link: https://lore.kernel.org/r/20220818105355.110344-3-haris.iqbal@ionos.com
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: Aleksei Marov <aleksei.marov@ionos.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 9edbb309b96c0..c644617725a88 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1011,7 +1011,8 @@ rtrs_clt_get_copy_req(struct rtrs_clt_path *alive_path,
 static int rtrs_post_rdma_write_sg(struct rtrs_clt_con *con,
 				   struct rtrs_clt_io_req *req,
 				   struct rtrs_rbuf *rbuf, bool fr_en,
-				   u32 size, u32 imm, struct ib_send_wr *wr,
+				   u32 count, u32 size, u32 imm,
+				   struct ib_send_wr *wr,
 				   struct ib_send_wr *tail)
 {
 	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
@@ -1031,12 +1032,12 @@ static int rtrs_post_rdma_write_sg(struct rtrs_clt_con *con,
 		num_sge = 2;
 		ptail = tail;
 	} else {
-		for_each_sg(req->sglist, sg, req->sg_cnt, i) {
+		for_each_sg(req->sglist, sg, count, i) {
 			sge[i].addr   = sg_dma_address(sg);
 			sge[i].length = sg_dma_len(sg);
 			sge[i].lkey   = clt_path->s.dev->ib_pd->local_dma_lkey;
 		}
-		num_sge = 1 + req->sg_cnt;
+		num_sge = 1 + count;
 	}
 	sge[i].addr   = req->iu->dma_addr;
 	sge[i].length = size;
@@ -1149,7 +1150,7 @@ static int rtrs_clt_write_req(struct rtrs_clt_io_req *req)
 	 */
 	rtrs_clt_update_all_stats(req, WRITE);
 
-	ret = rtrs_post_rdma_write_sg(req->con, req, rbuf, fr_en,
+	ret = rtrs_post_rdma_write_sg(req->con, req, rbuf, fr_en, count,
 				      req->usr_len + sizeof(*msg),
 				      imm, wr, &inv_wr);
 	if (ret) {
-- 
2.35.1




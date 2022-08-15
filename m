Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB93593646
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244199AbiHOTTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345009AbiHOTR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:17:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821E63CBEF;
        Mon, 15 Aug 2022 11:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 197C06117E;
        Mon, 15 Aug 2022 18:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064E4C433D6;
        Mon, 15 Aug 2022 18:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588755;
        bh=cCMBIrlmKSsmRED1fe2ktHHoOIacQ+aXMVE7OR2xu+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Egx++DMcR6J8zE3b/c7vivqQFalAm2UvffHPgv4dFSn7w5v04fOnFN4mVco2w0h9d
         x3xayqCNjmEdq1p7VpWWOegGSBQ/34pAUyWwBfxJ/m0e6E2hOZO6rtof5HD3r98et1
         oLgK9m2JrQLSNC0T0TeDjRzWrkP8tUzgj8qqizCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Md Haris Iqbal <haris.iqbal@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 505/779] RDMA/rtrs: Introduce destroy_cq helper
Date:   Mon, 15 Aug 2022 20:02:29 +0200
Message-Id: <20220815180358.854001258@linuxfoundation.org>
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

From: Md Haris Iqbal <haris.iqbal@ionos.com>

[ Upstream commit 6f5649afd3984e35c4b862a05c4511c6d18b27af ]

The same code snip used twice, to avoid duplicate, replace it with a
destroy_cq helper.

Link: https://lore.kernel.org/r/20210922125333.351454-6-haris.iqbal@ionos.com
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/rtrs/rtrs.c
index ac83cd97f838..37952c8e768c 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -279,6 +279,17 @@ static int create_qp(struct rtrs_con *con, struct ib_pd *pd,
 	return ret;
 }
 
+static void destroy_cq(struct rtrs_con *con)
+{
+	if (con->cq) {
+		if (is_pollqueue(con))
+			ib_free_cq(con->cq);
+		else
+			ib_cq_pool_put(con->cq, con->nr_cqe);
+	}
+	con->cq = NULL;
+}
+
 int rtrs_cq_qp_create(struct rtrs_sess *sess, struct rtrs_con *con,
 		       u32 max_send_sge, int cq_vector, int nr_cqe,
 		       u32 max_send_wr, u32 max_recv_wr,
@@ -293,11 +304,7 @@ int rtrs_cq_qp_create(struct rtrs_sess *sess, struct rtrs_con *con,
 	err = create_qp(con, sess->dev->ib_pd, max_send_wr, max_recv_wr,
 			max_send_sge);
 	if (err) {
-		if (is_pollqueue(con))
-			ib_free_cq(con->cq);
-		else
-			ib_cq_pool_put(con->cq, con->nr_cqe);
-		con->cq = NULL;
+		destroy_cq(con);
 		return err;
 	}
 	con->sess = sess;
@@ -312,13 +319,7 @@ void rtrs_cq_qp_destroy(struct rtrs_con *con)
 		rdma_destroy_qp(con->cm_id);
 		con->qp = NULL;
 	}
-	if (con->cq) {
-		if (is_pollqueue(con))
-			ib_free_cq(con->cq);
-		else
-			ib_cq_pool_put(con->cq, con->nr_cqe);
-		con->cq = NULL;
-	}
+	destroy_cq(con);
 }
 EXPORT_SYMBOL_GPL(rtrs_cq_qp_destroy);
 
-- 
2.35.1




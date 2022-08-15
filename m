Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5785938EE
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241347AbiHOTTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344992AbiHOTR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:17:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6AD564E7;
        Mon, 15 Aug 2022 11:39:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A3CCB81082;
        Mon, 15 Aug 2022 18:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77B0C433C1;
        Mon, 15 Aug 2022 18:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588752;
        bh=cJvvpw2V2WkYkJe0YiSF1JkxT/yfNnJe/ox30DG6VCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGoCZv2IuFWV70AqKazG5nqSaDLy/4It6sCP91Un3b5qo4TX40yPjE/d5+KyJW/OS
         xcYNLTYba3HBtk38AfytSMpZynq1rx1IkWU0P33VnVMD8POFaxuxHgsEfM/XrfzwRy
         ZwLhC4FVqoNuIAdNR47KmVcNbSzsMUk4bT6E1pIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Md Haris Iqbal <haris.iqbal@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 504/779] RDMA/rtrs: Replace duplicate check with is_pollqueue helper
Date:   Mon, 15 Aug 2022 20:02:28 +0200
Message-Id: <20220815180358.809789868@linuxfoundation.org>
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

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 36332ded46b6292296bc7170fada6e238a0802cc ]

if (con->cid >= con->sess->irq_con_num) check can be replaced with a
is_pollqueue helper.

Link: https://lore.kernel.org/r/20210922125333.351454-5-haris.iqbal@ionos.com
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/rtrs/rtrs.c
index 9bc323490ce3..ac83cd97f838 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -222,13 +222,18 @@ static void qp_event_handler(struct ib_event *ev, void *ctx)
 	}
 }
 
+static bool is_pollqueue(struct rtrs_con *con)
+{
+	return con->cid >= con->sess->irq_con_num;
+}
+
 static int create_cq(struct rtrs_con *con, int cq_vector, int nr_cqe,
 		     enum ib_poll_context poll_ctx)
 {
 	struct rdma_cm_id *cm_id = con->cm_id;
 	struct ib_cq *cq;
 
-	if (con->cid >= con->sess->irq_con_num)
+	if (is_pollqueue(con))
 		cq = ib_alloc_cq(cm_id->device, con, nr_cqe, cq_vector,
 				 poll_ctx);
 	else
@@ -288,7 +293,7 @@ int rtrs_cq_qp_create(struct rtrs_sess *sess, struct rtrs_con *con,
 	err = create_qp(con, sess->dev->ib_pd, max_send_wr, max_recv_wr,
 			max_send_sge);
 	if (err) {
-		if (con->cid >= con->sess->irq_con_num)
+		if (is_pollqueue(con))
 			ib_free_cq(con->cq);
 		else
 			ib_cq_pool_put(con->cq, con->nr_cqe);
@@ -308,7 +313,7 @@ void rtrs_cq_qp_destroy(struct rtrs_con *con)
 		con->qp = NULL;
 	}
 	if (con->cq) {
-		if (con->cid >= con->sess->irq_con_num)
+		if (is_pollqueue(con))
 			ib_free_cq(con->cq);
 		else
 			ib_cq_pool_put(con->cq, con->nr_cqe);
-- 
2.35.1




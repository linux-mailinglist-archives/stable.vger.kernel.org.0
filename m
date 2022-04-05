Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23054F2AAD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbiDEIZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238798AbiDEITY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33A074617;
        Tue,  5 Apr 2022 01:09:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6370E60A5A;
        Tue,  5 Apr 2022 08:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F221C385A1;
        Tue,  5 Apr 2022 08:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146171;
        bh=94tCqCpDfa0GaM5Otbk7GPqMCgsyJwd3rD7HBKSUU8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KniXB16StCamlQ8bRIbY6MwFSaAsl0VzD1HAxsUJOnAxDgOk9j0lx3eFOLHM3vlVf
         bQDtWksHMwqGjY9vNbwOxS4tr7gtpobPV9C6YYPNOF2MeffXJzRKryVI9Bv+cc9R2u
         AH5ixiHbIV1hg1/uejRo7u2gwccpLtr2KPx9QYd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0667/1126] RDMA/rxe: Change variable and function argument to proper type
Date:   Tue,  5 Apr 2022 09:23:34 +0200
Message-Id: <20220405070427.205144061@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Chengguang Xu <cgxu519@mykernel.net>

[ Upstream commit 7e8e611d6a0ff228577b1167335ffefb0f44d5d8 ]

The type of wqe length is u32 so in order to avoid overflow and shadow
casting change variable and relevant function argument to proper type.

Link: https://lore.kernel.org/r/20220307145047.3235675-1-cgxu519@mykernel.net
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 5eb89052dd66..b28036a7a3b8 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -359,7 +359,7 @@ static inline int get_mtu(struct rxe_qp *qp)
 
 static struct sk_buff *init_req_packet(struct rxe_qp *qp,
 				       struct rxe_send_wqe *wqe,
-				       int opcode, int payload,
+				       int opcode, u32 payload,
 				       struct rxe_pkt_info *pkt)
 {
 	struct rxe_dev		*rxe = to_rdev(qp->ibqp.device);
@@ -449,7 +449,7 @@ static struct sk_buff *init_req_packet(struct rxe_qp *qp,
 
 static int finish_packet(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 		       struct rxe_pkt_info *pkt, struct sk_buff *skb,
-		       int paylen)
+		       u32 paylen)
 {
 	int err;
 
@@ -497,7 +497,7 @@ static void update_wqe_state(struct rxe_qp *qp,
 static void update_wqe_psn(struct rxe_qp *qp,
 			   struct rxe_send_wqe *wqe,
 			   struct rxe_pkt_info *pkt,
-			   int payload)
+			   u32 payload)
 {
 	/* number of packets left to send including current one */
 	int num_pkt = (wqe->dma.resid + payload + qp->mtu - 1) / qp->mtu;
@@ -540,7 +540,7 @@ static void rollback_state(struct rxe_send_wqe *wqe,
 }
 
 static void update_state(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
-			 struct rxe_pkt_info *pkt, int payload)
+			 struct rxe_pkt_info *pkt, u32 payload)
 {
 	qp->req.opcode = pkt->opcode;
 
@@ -612,7 +612,7 @@ int rxe_requester(void *arg)
 	struct sk_buff *skb;
 	struct rxe_send_wqe *wqe;
 	enum rxe_hdr_mask mask;
-	int payload;
+	u32 payload;
 	int mtu;
 	int opcode;
 	int ret;
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4E1594DE1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbiHPAbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiHPAaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:30:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D003F183122;
        Mon, 15 Aug 2022 13:35:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A490B811A5;
        Mon, 15 Aug 2022 20:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC55C433C1;
        Mon, 15 Aug 2022 20:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595695;
        bh=0DD4p/4boBuJc0WUfW/tRCXt/2UI7dH2bDTdd2p/vnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyEB22cPDCcCbpDtTbQeSYL3whCy8qeACyAlObdHy55YyPESp+a0SHGaS8w56gDGS
         bhmQZ7nJnFAa4SGOGPSFy84bsNfu0FYQRGVrKCqInY34UXFnYioe6YJ1mgxFlKduoN
         VpHv2wVccF/g4dsCHml/+er2IU3n+Czv4iWE+h/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Yanjun <yanjun.zhu@linux.dev>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Md Haris Iqbal <haris.iqbal@ionos.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0828/1157] RDMA/rxe: Fix BUG: KASAN: null-ptr-deref in rxe_qp_do_cleanup
Date:   Mon, 15 Aug 2022 20:03:04 +0200
Message-Id: <20220815180512.603314197@linuxfoundation.org>
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

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit 37da51efe6eaa0560f46803c8c436a48a2084da7 ]

The function rxe_create_qp calls rxe_qp_from_init. If some error
occurs, the error handler of function rxe_qp_from_init will set
both scq and rcq to NULL.

Then rxe_create_qp calls rxe_put to handle qp. In the end,
rxe_qp_do_cleanup is called by rxe_put. rxe_qp_do_cleanup directly
accesses scq and rcq before checking them. This will cause
null-ptr-deref error.

The call graph is as below:

rxe_create_qp {
  ...
  rxe_qp_from_init {
    ...
  err1:
    ...
    qp->rcq = NULL;  <---rcq is set to NULL
    qp->scq = NULL;  <---scq is set to NULL
    ...
  }

qp_init:
  rxe_put{
    ...
    rxe_qp_do_cleanup {
      ...
      atomic_dec(&qp->scq->num_wq); <--- scq is accessed
      ...
      atomic_dec(&qp->rcq->num_wq); <--- rcq is accessed
    }
}

Fixes: 4703b4f0d94a ("RDMA/rxe: Enforce IBA C11-17")
Link: https://lore.kernel.org/r/20220705225414.315478-1-yanjun.zhu@linux.dev
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Bob Pearson <rpearsonhpe@gmail.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 22e9b85344c3..b79e1b43454e 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -804,13 +804,15 @@ static void rxe_qp_do_cleanup(struct work_struct *work)
 	if (qp->rq.queue)
 		rxe_queue_cleanup(qp->rq.queue);
 
-	atomic_dec(&qp->scq->num_wq);
-	if (qp->scq)
+	if (qp->scq) {
+		atomic_dec(&qp->scq->num_wq);
 		rxe_put(qp->scq);
+	}
 
-	atomic_dec(&qp->rcq->num_wq);
-	if (qp->rcq)
+	if (qp->rcq) {
+		atomic_dec(&qp->rcq->num_wq);
 		rxe_put(qp->rcq);
+	}
 
 	if (qp->pd)
 		rxe_put(qp->pd);
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C116553A7BB
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354256AbiFAOCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354546AbiFAOAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:00:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609AD10FF5;
        Wed,  1 Jun 2022 06:57:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE15E6160E;
        Wed,  1 Jun 2022 13:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4E2C3411D;
        Wed,  1 Jun 2022 13:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091785;
        bh=Io4HhJb+Cz16sRUnVJbOtBv6IWiQnhJuRY59WG07j+s=;
        h=From:To:Cc:Subject:Date:From;
        b=I7A5nLZMKYXpbZb1QJHxcS049h13VY7fF5Osn/gcBujNd/KTWMGy9116J5GNSej7c
         fX0Y4jrwckeiTZkLTJtWCBCL8jSRC71XdVk+6wxGghto6tYLgzTvjCRPSkLOP4KIZ6
         pO3Svcj+ejPwYiOa+2AKe9O/iQx+Wv+qaPlroUYpiatvphlV7ERU9UvpYt/V2pRFUT
         cio1toR1hGV/F6i5OiNwXqYNe6QVn+rtlaJgf0WhYZxOd64cie5jFAKDthoJS2ZbEQ
         Byar09f2LvajKJ88obyDaYCm4U1qBnOeECsPgPjYTX5q78oeOzMXPE+jsvGx2JnfFL
         CsRCqcNUO/z4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niels Dossche <dossche.niels@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dennis.dalessandro@cornelisnetworks.com, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 01/37] IB/rdmavt: add missing locks in rvt_ruc_loopback
Date:   Wed,  1 Jun 2022 09:55:46 -0400
Message-Id: <20220601135622.2003939-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit 22cbc6c2681a0a4fe76150270426e763d52353a4 ]

The documentation of the function rvt_error_qp says both r_lock and
s_lock need to be held when calling that function.
It also asserts using lockdep that both of those locks are held.
rvt_error_qp is called form rvt_send_cq, which is called from
rvt_qp_complete_swqe, which is called from rvt_send_complete, which is
called from rvt_ruc_loopback in two places. Both of these places do not
hold r_lock. Fix this by acquiring a spin_lock of r_lock in both of
these places.
The r_lock acquiring cannot be added in rvt_qp_complete_swqe because
some of its other callers already have r_lock acquired.

Link: https://lore.kernel.org/r/20220228195144.71946-1-dossche.niels@gmail.com
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rdmavt/qp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 8ef112f883a7..3acab569fbb9 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -2775,7 +2775,7 @@ void rvt_qp_iter(struct rvt_dev_info *rdi,
 EXPORT_SYMBOL(rvt_qp_iter);
 
 /*
- * This should be called with s_lock held.
+ * This should be called with s_lock and r_lock held.
  */
 void rvt_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 		       enum ib_wc_status status)
@@ -3134,7 +3134,9 @@ void rvt_ruc_loopback(struct rvt_qp *sqp)
 	rvp->n_loop_pkts++;
 flush_send:
 	sqp->s_rnr_retry = sqp->s_rnr_retry_cnt;
+	spin_lock(&sqp->r_lock);
 	rvt_send_complete(sqp, wqe, send_status);
+	spin_unlock(&sqp->r_lock);
 	if (local_ops) {
 		atomic_dec(&sqp->local_ops_pending);
 		local_ops = 0;
@@ -3188,7 +3190,9 @@ void rvt_ruc_loopback(struct rvt_qp *sqp)
 	spin_unlock_irqrestore(&qp->r_lock, flags);
 serr_no_r_lock:
 	spin_lock_irqsave(&sqp->s_lock, flags);
+	spin_lock(&sqp->r_lock);
 	rvt_send_complete(sqp, wqe, send_status);
+	spin_unlock(&sqp->r_lock);
 	if (sqp->ibqp.qp_type == IB_QPT_RC) {
 		int lastwqe;
 
-- 
2.35.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6485C53A826
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354462AbiFAOGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355054AbiFAOFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:05:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A69A0067;
        Wed,  1 Jun 2022 06:59:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6E80ACE1C0A;
        Wed,  1 Jun 2022 13:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F3EC385A5;
        Wed,  1 Jun 2022 13:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091944;
        bh=Rj0CiQQ29Z8w5a5VkjUKJyJKpDxyKeVJ10N2BTko0zY=;
        h=From:To:Cc:Subject:Date:From;
        b=Csv76Oq80wCN2ifNvm5JcY9ow6EDMjK8rJMAB7kpb6W/davVIKWqrityaTqGohO28
         EbKtT3YaAYuQHA8sLRWHuTPs46Kl+cc2caMN9s02m3rdbwWllDSBLS+5kLNo5rSB4m
         Bjn/uXDXmEGRIBnHvQdQnNj8zend9YTnZBnXM0ilIthX2/QaM06UZ+0JVF3++7dvhn
         DDwt706rcG80LqqhiATQcplnbiqyDNJKUFDCWw8B8T6wmh2UIha+aoU5tBkHYrcBr8
         KQuO8z5CVu0JqZqq2NWropeM/gidBMSuLYNlbDNAa7DhHV1ZSyzAj3Ti9fPfl3Rf7K
         WkRzcVF2JKxtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niels Dossche <dossche.niels@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dennis.dalessandro@cornelisnetworks.com, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/20] IB/rdmavt: add missing locks in rvt_ruc_loopback
Date:   Wed,  1 Jun 2022 09:58:43 -0400
Message-Id: <20220601135902.2004823-1-sashal@kernel.org>
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
index 48e8612c1bc8..e97c13967174 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -2812,7 +2812,7 @@ void rvt_qp_iter(struct rvt_dev_info *rdi,
 EXPORT_SYMBOL(rvt_qp_iter);
 
 /*
- * This should be called with s_lock held.
+ * This should be called with s_lock and r_lock held.
  */
 void rvt_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 		       enum ib_wc_status status)
@@ -3171,7 +3171,9 @@ void rvt_ruc_loopback(struct rvt_qp *sqp)
 	rvp->n_loop_pkts++;
 flush_send:
 	sqp->s_rnr_retry = sqp->s_rnr_retry_cnt;
+	spin_lock(&sqp->r_lock);
 	rvt_send_complete(sqp, wqe, send_status);
+	spin_unlock(&sqp->r_lock);
 	if (local_ops) {
 		atomic_dec(&sqp->local_ops_pending);
 		local_ops = 0;
@@ -3225,7 +3227,9 @@ void rvt_ruc_loopback(struct rvt_qp *sqp)
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DF44F37C1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359505AbiDELTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349138AbiDEJtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EFD12C;
        Tue,  5 Apr 2022 02:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C848CB81B14;
        Tue,  5 Apr 2022 09:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3471BC385A3;
        Tue,  5 Apr 2022 09:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151681;
        bh=P9cAgoMeroWf2nVM2LaYjb9TMKAdQKYO1vUZvOl9bT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kNxkY9Qgzu8gltdfTD9gefy7QHYnNw0FcYP6P1epUCkQ68UIDdmTuWf+aEjRxqrI
         HOORAlvclLYNLgmv0UYU+xCheoTM2RlthZkMBSwAgXClMNqDLqMwWzg3+YbU9mhQqv
         YE6iArVZVgkj6mx0ROuQ/gv3zBRVolvbRJv2lnoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 504/913] RDMA/irdma: Remove incorrect masking of PD
Date:   Tue,  5 Apr 2022 09:26:06 +0200
Message-Id: <20220405070354.964596858@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 17850f2b0b4b806e47cc44df94186bfc2cdd490b ]

The PD id is masked with 0x7fff, while PD can be 18 bits for GEN2 HW.
Remove the masking as it should not be needed and can cause incorrect PD
id to be used.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Link: https://lore.kernel.org/r/20220225163211.127-4-shiraz.saleem@intel.com
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 8bbc4620a97a..4a6fdd5c09e3 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2506,7 +2506,7 @@ static int irdma_dealloc_mw(struct ib_mw *ibmw)
 	cqp_info = &cqp_request->info;
 	info = &cqp_info->in.u.dealloc_stag.info;
 	memset(info, 0, sizeof(*info));
-	info->pd_id = iwpd->sc_pd.pd_id & 0x00007fff;
+	info->pd_id = iwpd->sc_pd.pd_id;
 	info->stag_idx = ibmw->rkey >> IRDMA_CQPSQ_STAG_IDX_S;
 	info->mr = false;
 	cqp_info->cqp_cmd = IRDMA_OP_DEALLOC_STAG;
@@ -3018,7 +3018,7 @@ static int irdma_dereg_mr(struct ib_mr *ib_mr, struct ib_udata *udata)
 	cqp_info = &cqp_request->info;
 	info = &cqp_info->in.u.dealloc_stag.info;
 	memset(info, 0, sizeof(*info));
-	info->pd_id = iwpd->sc_pd.pd_id & 0x00007fff;
+	info->pd_id = iwpd->sc_pd.pd_id;
 	info->stag_idx = ib_mr->rkey >> IRDMA_CQPSQ_STAG_IDX_S;
 	info->mr = true;
 	if (iwpbl->pbl_allocated)
-- 
2.34.1




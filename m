Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3CD04F2C5C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243101AbiDEJi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242416AbiDEJHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:07:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E90A68FBF;
        Tue,  5 Apr 2022 01:56:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B77A61562;
        Tue,  5 Apr 2022 08:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E14C385A0;
        Tue,  5 Apr 2022 08:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148998;
        bh=1+Mngr6KGkheShOg7khTz8KoT3VtqXQ7du3xbknMR0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihTi9/7BWMSJh3WJ4qym9odvvx+hjYqnGCiLi55h3uCt1X8CIhtbVyGEZfi2pjJlG
         0o9DBPY7hgq0kDIccDzUVHlz6lbYq21IUqPQQscPZz26QGnYmT+58OXlB6LdB07c2h
         PCkP6NksZzSsT+TGKgOYEVLWUvJzLgoTqVGJDNec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0558/1017] RDMA/irdma: Remove incorrect masking of PD
Date:   Tue,  5 Apr 2022 09:24:31 +0200
Message-Id: <20220405070410.844796945@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 8cd5f9261692..03d4da16604d 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2504,7 +2504,7 @@ static int irdma_dealloc_mw(struct ib_mw *ibmw)
 	cqp_info = &cqp_request->info;
 	info = &cqp_info->in.u.dealloc_stag.info;
 	memset(info, 0, sizeof(*info));
-	info->pd_id = iwpd->sc_pd.pd_id & 0x00007fff;
+	info->pd_id = iwpd->sc_pd.pd_id;
 	info->stag_idx = ibmw->rkey >> IRDMA_CQPSQ_STAG_IDX_S;
 	info->mr = false;
 	cqp_info->cqp_cmd = IRDMA_OP_DEALLOC_STAG;
@@ -3016,7 +3016,7 @@ static int irdma_dereg_mr(struct ib_mr *ib_mr, struct ib_udata *udata)
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




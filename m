Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459894F37AE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359448AbiDELTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349166AbiDEJtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0006164D6;
        Tue,  5 Apr 2022 02:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 909E86164D;
        Tue,  5 Apr 2022 09:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E50EC385A1;
        Tue,  5 Apr 2022 09:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151717;
        bh=jYK5sFnekXCxVL58RTzjeUc9TcSXOqyPwQlvV9P1BcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHYZXIAK1tkF/d5N1ks0pF+yE15AtpZlLteVT4QuLR4oL7A16O6gNIlXpQ6OERy6A
         ssLUVQ7ihEu5bokL1s1MeFiezSgheMuJsNfTp8ttO7MCZUZk3adCVvDHZ4eWEcsRyv
         QrPwF+xBn6tNs6IHpjz0UvRh/pJkH+7va8GmgdgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 516/913] RDMA/core: Fix ib_qp_usecnt_dec() called when error
Date:   Tue,  5 Apr 2022 09:26:18 +0200
Message-Id: <20220405070355.320834170@linuxfoundation.org>
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

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit 7c4a539ec38f4ce400a0f3fcb5ff6c940fcd67bb ]

ib_destroy_qp() would called by ib_create_qp_user() if error, the former
contains ib_qp_usecnt_dec(), but ib_qp_usecnt_inc() was not called before.

So move ib_qp_usecnt_inc() into create_qp().

Fixes: d2b10794fc13 ("RDMA/core: Create clean QP creations interface for uverbs")
Link: https://lore.kernel.org/r/20220303024232.2847388-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c          | 1 -
 drivers/infiniband/core/uverbs_std_types_qp.c | 1 -
 drivers/infiniband/core/verbs.c               | 3 +--
 3 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index d1345d76d9b1..5a99e31df5f5 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1438,7 +1438,6 @@ static int create_qp(struct uverbs_attr_bundle *attrs,
 		ret = PTR_ERR(qp);
 		goto err_put;
 	}
-	ib_qp_usecnt_inc(qp);
 
 	obj->uevent.uobject.object = qp;
 	obj->uevent.event_file = READ_ONCE(attrs->ufile->default_async_file);
diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infiniband/core/uverbs_std_types_qp.c
index dd1075466f61..75353e09c6fe 100644
--- a/drivers/infiniband/core/uverbs_std_types_qp.c
+++ b/drivers/infiniband/core/uverbs_std_types_qp.c
@@ -254,7 +254,6 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 		ret = PTR_ERR(qp);
 		goto err_put;
 	}
-	ib_qp_usecnt_inc(qp);
 
 	if (attr.qp_type == IB_QPT_XRC_TGT) {
 		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object,
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 59e20936b800..b78cd65d20a6 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1253,6 +1253,7 @@ static struct ib_qp *create_qp(struct ib_device *dev, struct ib_pd *pd,
 	if (ret)
 		goto err_security;
 
+	ib_qp_usecnt_inc(qp);
 	rdma_restrack_add(&qp->res);
 	return qp;
 
@@ -1353,8 +1354,6 @@ struct ib_qp *ib_create_qp_kernel(struct ib_pd *pd,
 	if (IS_ERR(qp))
 		return qp;
 
-	ib_qp_usecnt_inc(qp);
-
 	if (qp_init_attr->cap.max_rdma_ctxs) {
 		ret = rdma_rw_init_mrs(qp, qp_init_attr);
 		if (ret)
-- 
2.34.1




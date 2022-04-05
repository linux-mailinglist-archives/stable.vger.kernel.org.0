Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A723A4F3569
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242171AbiDEIhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238926AbiDEITa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8265675610;
        Tue,  5 Apr 2022 01:09:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DEAA6062B;
        Tue,  5 Apr 2022 08:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244B8C385A0;
        Tue,  5 Apr 2022 08:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146185;
        bh=wOn7QX1/m4DzuyweVm803LERQRTqej3v3Nwq2rnjmVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1YP/SjVsFUDLZxSCic2sRUimsFY0X6m37XMUaeKNA5ybYqPi2ktmY0R2i/+CSkEB
         Di1iziiGYgkTNLhUff/IiKmsCSAfKPJLV4xqIFPC/sixXgbSw+aqan8+1TDD+weCRD
         jn6vMqsjeHDxmE5mVWG/xTsjGnAfyuIrF5t4HKIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0634/1126] RDMA/core: Fix ib_qp_usecnt_dec() called when error
Date:   Tue,  5 Apr 2022 09:23:01 +0200
Message-Id: <20220405070426.246693756@linuxfoundation.org>
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
index 6b6393176b3c..4437f834c0a7 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1437,7 +1437,6 @@ static int create_qp(struct uverbs_attr_bundle *attrs,
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
index e821dc94a43e..961055eb330d 100644
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




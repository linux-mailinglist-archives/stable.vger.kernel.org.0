Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2816D4439
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 14:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjDCMRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 08:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDCMRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 08:17:09 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1AC410243
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 05:17:07 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PqqYG3XLRzSkjS;
        Mon,  3 Apr 2023 20:13:22 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 3 Apr 2023 20:17:05 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <stable@vger.kernel.org>, <cuigaosheng1@huawei.com>
CC:     <bparrot@ti.com>, <mchehab@kernel.org>, <sashal@kernel.org>,
        <laurent.pinchart@ideasonboard.com>, <gregkh@linuxfoundation.org>,
        <patches@lists.linux.dev>
Subject: [PATCH 5.10] media: ti: cal: revert "media: ti: cal: fix possible memory leak in cal_ctx_create()"
Date:   Mon, 3 Apr 2023 20:17:04 +0800
Message-ID: <20230403121704.3017781-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit c7a218cbf67fffcd99b76ae3b5e9c2e8bef17c8c.

The memory of ctx is allocated by devm_kzalloc in cal_ctx_create,
it should not be freed by kfree when cal_ctx_v4l2_init() fails,
otherwise kfree() will cause double free, so revert this patch.

Fixes: c7a218cbf67f ("media: ti: cal: fix possible memory leak in cal_ctx_create()")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 drivers/media/platform/ti-vpe/cal.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 93121c90d76a..2eef245c31a1 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -624,10 +624,8 @@ static struct cal_ctx *cal_ctx_create(struct cal_dev *cal, int inst)
 	ctx->cport = inst;
 
 	ret = cal_ctx_v4l2_init(ctx);
-	if (ret) {
-		kfree(ctx);
+	if (ret)
 		return NULL;
-	}
 
 	return ctx;
 }
-- 
2.25.1


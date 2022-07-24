Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631B057F384
	for <lists+stable@lfdr.de>; Sun, 24 Jul 2022 08:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiGXGxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jul 2022 02:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiGXGxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jul 2022 02:53:32 -0400
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF75A18B00;
        Sat, 23 Jul 2022 23:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Dx2Ld
        mmelaSG129Gndk1nriYSQBQ1KJZz167f8rv7V0=; b=D911up3lsqiL0jdoI26JR
        yYjcKRZI5nv1gDQF0P4jbLZqx47PsFfycw9PALK4cHmT9f1ncX7luVBCHV4BAox6
        oSpfev8rkwqCt2k4j3dRHLVgbhQjSC1yzHEx9yzkAmNSEkucuISCx1zTEDa2OrzZ
        VIr6eZSWEH+bAJ2Dt5aM2A=
Received: from localhost.localdomain (unknown [123.112.69.106])
        by smtp1 (Coremail) with SMTP id GdxpCgCHoeQq7NxidFSvQA--.22213S4;
        Sun, 24 Jul 2022 14:52:41 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     sj@kernel.org, akpm@linux-foundation.org
Cc:     damon@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] mm/damon/reclaim: fix potential memory leak in damon_reclaim_init()
Date:   Sun, 24 Jul 2022 14:52:24 +0800
Message-Id: <20220724065224.2555966-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgCHoeQq7NxidFSvQA--.22213S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7GFyfKr13WF1fXF1fXF1fWFg_yoWkGFXEka
        12qr9rua1DXayFy3ZrCw1fGr1xZrW8GrykXFWIy347AFyrKrn7Xry8Xrs3Xr17u34UAry2
        vFs7Zas8Zr129jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRibAwPUUUUU==
X-Originating-IP: [123.112.69.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiWxlIjGI0VkuIuQAAs8
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

damon_reclaim_init() allocates a memory chunk for ctx with
damon_new_ctx(). When damon_select_ops() fails, ctx is not released, which
will lead to a memory leak.

We should release the ctx with damon_destroy_ctx() when damon_select_ops()
fails to fix the memory leak.

Fixes: 4d69c3457821 ("mm/damon/reclaim: use damon_select_ops() instead of damon_{v,p}a_set_operations()")
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 mm/damon/reclaim.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 4b07c29effe9..0b3c7396cb90 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -441,8 +441,10 @@ static int __init damon_reclaim_init(void)
 	if (!ctx)
 		return -ENOMEM;
 
-	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
+	if (damon_select_ops(ctx, DAMON_OPS_PADDR)) {
+		damon_destroy_ctx(ctx);
 		return -EINVAL;
+	}
 
 	ctx->callback.after_wmarks_check = damon_reclaim_after_wmarks_check;
 	ctx->callback.after_aggregation = damon_reclaim_after_aggregation;
-- 
2.25.1


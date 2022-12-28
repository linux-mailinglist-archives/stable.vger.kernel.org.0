Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47048657B4D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbiL1PUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbiL1PUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:20:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2280E13FB3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:20:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C9276155A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D867C433EF;
        Wed, 28 Dec 2022 15:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240801;
        bh=ab9fQLBubp9wKQiy5qM6q7oGlZi3g/mswJdE6Ji+eKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3cfvjkFCrSwqzCXqsrUsshqd5Pk7Xd10qUuSQrOeVQBEhH+Hm7/KzhcYn8gDDJYN
         OC8fn00f3T5UbRZR0B672x2dbemst4erHk847RSW1a/XGCJO5jx5JaCSblhv1kM2iO
         Yrq6q9jQI/Auf5MR5ptoL+WsuVoRLGMmDfmUrcew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 399/731] RDMA/hns: fix memory leak in hns_roce_alloc_mr()
Date:   Wed, 28 Dec 2022 15:38:26 +0100
Message-Id: <20221228144308.132115360@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit a115aa00b18f7b8982b8f458149632caf64a862a ]

When hns_roce_mr_enable() failed in hns_roce_alloc_mr(), mr_key is not
released. Compiled test only.

Fixes: 9b2cf76c9f05 ("RDMA/hns: Optimize PBL buffer allocation process")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221119070834.48502-1-shaozhengchao@huawei.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_mr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 20360df25771..a593c142cd6b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -415,10 +415,10 @@ struct ib_mr *hns_roce_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
 
 	return &mr->ibmr;
 
-err_key:
-	free_mr_key(hr_dev, mr);
 err_pbl:
 	free_mr_pbl(hr_dev, mr);
+err_key:
+	free_mr_key(hr_dev, mr);
 err_free:
 	kfree(mr);
 	return ERR_PTR(ret);
-- 
2.35.1




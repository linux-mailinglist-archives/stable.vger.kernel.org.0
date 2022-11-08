Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DFC621338
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbiKHNsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbiKHNsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:48:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB365F869
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:48:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A11F3615A6
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF142C433C1;
        Tue,  8 Nov 2022 13:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915284;
        bh=UmkHinw1ahJEu+HyN53vqXW05E4ANqt6KA3m0kXxsxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vk6WnpzjBKhyODkpBbPWwtcDW3UOogEwRnZcHZ7GmTrDYAax2ENj5E9cQmh5WzODo
         AcNzYHuVyOeA2klIH6kJhXgGXwsF24YjuTGZ/OAmD9LGfxo3DTCPgDnMoPpinWVpnM
         9xa7f99rJnZrdGwt2BnBdddL23rUwHSAk7wOhZCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/74] RDMA/qedr: clean up work queue on failure in qedr_alloc_resources()
Date:   Tue,  8 Nov 2022 14:38:36 +0100
Message-Id: <20221108133333.995614825@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 7a47e077e503feb73d56e491ce89aa73b67a3972 ]

Add a check for if create_singlethread_workqueue() fails and also destroy
the work queue on failure paths.

Fixes: e411e0587e0d ("RDMA/qedr: Add iWARP connection management functions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/Y1gBkDucQhhWj5YM@kili
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 93040c994e2e..50b75bd4633c 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -362,6 +362,10 @@ static int qedr_alloc_resources(struct qedr_dev *dev)
 	if (IS_IWARP(dev)) {
 		xa_init(&dev->qps);
 		dev->iwarp_wq = create_singlethread_workqueue("qedr_iwarpq");
+		if (!dev->iwarp_wq) {
+			rc = -ENOMEM;
+			goto err1;
+		}
 	}
 
 	/* Allocate Status blocks for CNQ */
@@ -369,7 +373,7 @@ static int qedr_alloc_resources(struct qedr_dev *dev)
 				GFP_KERNEL);
 	if (!dev->sb_array) {
 		rc = -ENOMEM;
-		goto err1;
+		goto err_destroy_wq;
 	}
 
 	dev->cnq_array = kcalloc(dev->num_cnq,
@@ -423,6 +427,9 @@ static int qedr_alloc_resources(struct qedr_dev *dev)
 	kfree(dev->cnq_array);
 err2:
 	kfree(dev->sb_array);
+err_destroy_wq:
+	if (IS_IWARP(dev))
+		destroy_workqueue(dev->iwarp_wq);
 err1:
 	kfree(dev->sgid_tbl);
 	return rc;
-- 
2.35.1




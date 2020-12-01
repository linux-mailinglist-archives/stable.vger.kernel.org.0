Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF2B2C9E15
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387915AbgLAJbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:31:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728989AbgLAIzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:55:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B07CB2220B;
        Tue,  1 Dec 2020 08:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606812832;
        bh=gTKyshbP7haFW/axA7l2cJWAvJHvH4GW0OUsf7URpiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=no3BkDv5DhjYFdUcYjOWcT4JNVHYaZBTnQm84Yi4juzyZso6wFg46/PDSwEchOoi9
         vYUDZiM88PWUZr/czhHH6d7M+3mD6I3NvGgmH03j+O1macGltIkWE3772cQEd5bscO
         SFDvJONdT+T8iBskLgMoT1MSbDKDruiapDW4ayys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 16/24] IB/mthca: fix return value of error branch in mthca_init_cq()
Date:   Tue,  1 Dec 2020 09:53:22 +0100
Message-Id: <20201201084638.559359825@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084637.754785180@linuxfoundation.org>
References: <20201201084637.754785180@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 6830ff853a5764c75e56750d59d0bbb6b26f1835 ]

We return 'err' in the error branch, but this variable may be set as zero
by the above code. Fix it by setting 'err' as a negative value before we
goto the error label.

Fixes: 74c2174e7be5 ("IB uverbs: add mthca user CQ support")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://lore.kernel.org/r/1605837422-42724-1-git-send-email-wangxiongfeng2@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mthca/mthca_cq.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_cq.c b/drivers/infiniband/hw/mthca/mthca_cq.c
index 40ba833381557..59e1f6ea2ede9 100644
--- a/drivers/infiniband/hw/mthca/mthca_cq.c
+++ b/drivers/infiniband/hw/mthca/mthca_cq.c
@@ -811,8 +811,10 @@ int mthca_init_cq(struct mthca_dev *dev, int nent,
 	}
 
 	mailbox = mthca_alloc_mailbox(dev, GFP_KERNEL);
-	if (IS_ERR(mailbox))
+	if (IS_ERR(mailbox)) {
+		err = PTR_ERR(mailbox);
 		goto err_out_arm;
+	}
 
 	cq_context = mailbox->buf;
 
@@ -854,9 +856,9 @@ int mthca_init_cq(struct mthca_dev *dev, int nent,
 	}
 
 	spin_lock_irq(&dev->cq_table.lock);
-	if (mthca_array_set(&dev->cq_table.cq,
-			    cq->cqn & (dev->limits.num_cqs - 1),
-			    cq)) {
+	err = mthca_array_set(&dev->cq_table.cq,
+			      cq->cqn & (dev->limits.num_cqs - 1), cq);
+	if (err) {
 		spin_unlock_irq(&dev->cq_table.lock);
 		goto err_out_free_mr;
 	}
-- 
2.27.0




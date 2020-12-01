Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BE52C9D62
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbgLAJWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:22:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388960AbgLAJHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:07:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EABB421D46;
        Tue,  1 Dec 2020 09:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813590;
        bh=+ZAL0S7uoDsCPgfkCiQpBraMg5FiTTFCPN+HIpKhNNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djR0zlowtJwDMaVE2BbIwdijcOSPjxajUUGPA0K+91RxorQAOhUVfhg5dWkj/hx2o
         KZ1CAyw3J9jPY64TFAqn5sm0oP75a2FoDwRoemCdPTIigQx86ESBX8dYBozJoyQcgl
         ZR/eoasz/SgzqDQbi/FzpLyPPbsHGE7KEusxqJTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 61/98] IB/mthca: fix return value of error branch in mthca_init_cq()
Date:   Tue,  1 Dec 2020 09:53:38 +0100
Message-Id: <20201201084658.069326923@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
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
index c3cfea243af8c..119b2573c9a08 100644
--- a/drivers/infiniband/hw/mthca/mthca_cq.c
+++ b/drivers/infiniband/hw/mthca/mthca_cq.c
@@ -803,8 +803,10 @@ int mthca_init_cq(struct mthca_dev *dev, int nent,
 	}
 
 	mailbox = mthca_alloc_mailbox(dev, GFP_KERNEL);
-	if (IS_ERR(mailbox))
+	if (IS_ERR(mailbox)) {
+		err = PTR_ERR(mailbox);
 		goto err_out_arm;
+	}
 
 	cq_context = mailbox->buf;
 
@@ -846,9 +848,9 @@ int mthca_init_cq(struct mthca_dev *dev, int nent,
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




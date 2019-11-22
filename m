Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9036107000
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbfKVKrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:47:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729714AbfKVKrB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:47:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E6FB20637;
        Fri, 22 Nov 2019 10:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419620;
        bh=7Oz3PQNUNgCniA01lkUK3vBCs4s5pP39V23TBiRS1qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2nUF9aDHCtutWgQUASCCRUfMnaDWld6uwVv0Tu9xj+rHXrOq+ZZoTftgxdTqx+dOC
         FIsSV4JqzGDkPq1O4R24NsMn3BDS0iM6KKU3WXUl9wu6XP48YNzxpt8OXxu6at5CPn
         TDM8XRvicl/2iwpxpK+ZPaUiCbkqr0SbDU3x+2fU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 176/222] IB/mthca: Fix error return code in __mthca_init_one()
Date:   Fri, 22 Nov 2019 11:28:36 +0100
Message-Id: <20191122100915.152256811@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 39f2495618c5e980d2873ea3f2d1877dd253e07a ]

Fix to return a negative error code from the mthca_cmd_init() error
handling case instead of 0, as done elsewhere in this function.

Fixes: 80fd8238734c ("[PATCH] IB/mthca: Encapsulate command interface init")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mthca/mthca_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index ded76c101dde3..834b06aacc2bf 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -989,7 +989,8 @@ static int __mthca_init_one(struct pci_dev *pdev, int hca_type)
 		goto err_free_dev;
 	}
 
-	if (mthca_cmd_init(mdev)) {
+	err = mthca_cmd_init(mdev);
+	if (err) {
 		mthca_err(mdev, "Failed to init command interface, aborting.\n");
 		goto err_free_dev;
 	}
-- 
2.20.1




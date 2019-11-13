Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71680FA5B2
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfKMCYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:24:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728144AbfKMBwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FF3A204EC;
        Wed, 13 Nov 2019 01:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609925;
        bh=6jYzS/sCvmyJyeuL5eIOqLaGaxoLEzAnVYqKHTABSoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xbEQ5VP9LLUwoNm68LUyoHmPdARpT3dmFa5Rd6wIRoqwgcJbzYpaLJTXV6FBj9UAh
         U0qiCgUShWkT6Fr8E3TlH3kY9/bV53gbpGE6rKrDeJN+7QMvXWxUshWAA5vOA6TMgy
         8fyD74uimqoniDHgkanm1nM1wgJMpqO5agDhvHfM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 071/209] IB/mthca: Fix error return code in __mthca_init_one()
Date:   Tue, 12 Nov 2019 20:48:07 -0500
Message-Id: <20191113015025.9685-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index f3e80dec13344..af7f2083d4d1a 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -986,7 +986,8 @@ static int __mthca_init_one(struct pci_dev *pdev, int hca_type)
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


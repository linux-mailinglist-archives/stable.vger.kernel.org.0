Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97B38FA322
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbfKMCIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:08:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730378AbfKMCAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:00:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB9022053B;
        Wed, 13 Nov 2019 02:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610409;
        bh=7Oz3PQNUNgCniA01lkUK3vBCs4s5pP39V23TBiRS1qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtvuPeg1Qq1LlCQvH59ZtfH9rMvzaZAjbe3moGpMTSsO5gW0NNJdyNfh2ZztC74cb
         6X/gCJaEI1mxmTQ+iVJfSBFAMKFt6YfP0H/lNiUfos94RSyZJN6kKsKRAE/Sc1Jha+
         wey+/8W41LiM0tl2cEtD9SxbNp+rzdVSrTKPwlHk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 23/68] IB/mthca: Fix error return code in __mthca_init_one()
Date:   Tue, 12 Nov 2019 20:58:47 -0500
Message-Id: <20191113015932.12655-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
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


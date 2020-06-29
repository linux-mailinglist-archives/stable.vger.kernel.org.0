Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B7920D8A4
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387680AbgF2Tk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387642AbgF2TkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C80F0248C0;
        Mon, 29 Jun 2020 15:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444416;
        bh=Xv6s/hhVZVL9IE+xoCVPrgrKTX+scJkpBD1WMF/fTJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QbcuH/quClF+jwn0WPGQTV7xcTGVMRpISM8+uA/Yatsj806KjXl9geFF7vl7upkNX
         SHpqhQiQVFPhCG1YI5H3qEQcRY30BtbhhzS9dAS2e+LPm/0Zbsia6QYJGk/DsPi+r0
         WCVBnQ4VNF02Ko85bSzsZ5WJRFb7dMNBZof+aXng=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/178] net: qede: stop adding events on an already destroyed workqueue
Date:   Mon, 29 Jun 2020 11:23:59 -0400
Message-Id: <20200629152523.2494198-95-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>

[ Upstream commit 4079c7f7a2a00ab403c177ce723b560de59139c3 ]

Set rdma_wq pointer to NULL after destroying the workqueue and check
for it when adding new events to fix crashes on driver unload.

Fixes: cee9fbd8e2e9 ("qede: Add qedr framework")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_rdma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_rdma.c b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
index 2d873ae8a234d..668ccc9d49f83 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_rdma.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
@@ -105,6 +105,7 @@ static void qede_rdma_destroy_wq(struct qede_dev *edev)
 
 	qede_rdma_cleanup_event(edev);
 	destroy_workqueue(edev->rdma_info.rdma_wq);
+	edev->rdma_info.rdma_wq = NULL;
 }
 
 int qede_rdma_dev_add(struct qede_dev *edev, bool recovery)
@@ -325,7 +326,7 @@ static void qede_rdma_add_event(struct qede_dev *edev,
 	if (edev->rdma_info.exp_recovery)
 		return;
 
-	if (!edev->rdma_info.qedr_dev)
+	if (!edev->rdma_info.qedr_dev || !edev->rdma_info.rdma_wq)
 		return;
 
 	/* We don't want the cleanup flow to start while we're allocating and
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2842F3AF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbfE3EbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729588AbfE3DNs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:48 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B2682455A;
        Thu, 30 May 2019 03:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186027;
        bh=3KyZwOyAYs33K6saAGlXC5W9EG7P+Hcz6KixGR+0cMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2KHSXh7WcGrC+7y7BXqexmIe2+xej5vdWF17kc9c+SzJwSqcsGaUAeFtT/9vCpTZ
         ZD3n33HF+tFkdtD/WS0/LEgR3G6/jZT0X7uDv9CM/aOXjCitihOoeLS8mNv1RGkmac
         F3f3vg7DrfAvbKYkGfJUuhBozgyLHz6Yxdfv4xxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 102/346] net: hns3: use atomic_t replace u32 for arqs count
Date:   Wed, 29 May 2019 20:02:55 -0700
Message-Id: <20190530030546.309878016@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 30780a8b1677e7409b32ae52a9a84f7d41ae6b43 ]

Since irq handler and mailbox task will both update arq's count,
so arq's count should use atomic_t instead of u32, otherwise
its value may go wrong finally.

Fixes: 07a0556a3a73 ("net: hns3: Changes to support ARQ(Asynchronous Receive Queue)")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h          | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c | 7 ++++---
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 691d12174902c..3c7a26bb83222 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -102,7 +102,7 @@ struct hclgevf_mbx_arq_ring {
 	struct hclgevf_dev *hdev;
 	u32 head;
 	u32 tail;
-	u32 count;
+	atomic_t count;
 	u16 msg_q[HCLGE_MBX_MAX_ARQ_MSG_NUM][HCLGE_MBX_MAX_ARQ_MSG_SIZE];
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 4e78e8812a045..b39ff5555a30e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -327,7 +327,7 @@ int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 	hdev->arq.hdev = hdev;
 	hdev->arq.head = 0;
 	hdev->arq.tail = 0;
-	hdev->arq.count = 0;
+	atomic_set(&hdev->arq.count, 0);
 	hdev->hw.cmq.csq.next_to_clean = 0;
 	hdev->hw.cmq.csq.next_to_use = 0;
 	hdev->hw.cmq.crq.next_to_clean = 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 84653f58b2d10..fbba8b83b36c9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -207,7 +207,8 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 			/* we will drop the async msg if we find ARQ as full
 			 * and continue with next message
 			 */
-			if (hdev->arq.count >= HCLGE_MBX_MAX_ARQ_MSG_NUM) {
+			if (atomic_read(&hdev->arq.count) >=
+			    HCLGE_MBX_MAX_ARQ_MSG_NUM) {
 				dev_warn(&hdev->pdev->dev,
 					 "Async Q full, dropping msg(%d)\n",
 					 req->msg[1]);
@@ -219,7 +220,7 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 			memcpy(&msg_q[0], req->msg,
 			       HCLGE_MBX_MAX_ARQ_MSG_SIZE * sizeof(u16));
 			hclge_mbx_tail_ptr_move_arq(hdev->arq);
-			hdev->arq.count++;
+			atomic_inc(&hdev->arq.count);
 
 			hclgevf_mbx_task_schedule(hdev);
 
@@ -296,7 +297,7 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 		}
 
 		hclge_mbx_head_ptr_move_arq(hdev->arq);
-		hdev->arq.count--;
+		atomic_dec(&hdev->arq.count);
 		msg_q = hdev->arq.msg_q[hdev->arq.head];
 	}
 }
-- 
2.20.1




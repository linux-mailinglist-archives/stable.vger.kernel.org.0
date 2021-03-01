Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B0D3288CF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbhCARo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:44:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:33924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238022AbhCARkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:40:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EF5564FC5;
        Mon,  1 Mar 2021 16:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617802;
        bh=1HDIA4BmOyZxIVeBKMPTGphOKaZaWG/AbsVn5IQifeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9AbD4jcGdtBKWp1zIz/M6KLfsVgCD3aRGHpXvF/NmN+cMKLamDS5Tav3Tv4udvRL
         iaB0ENCYYx3AsY5LLt9RJ2JsJEKow1MElTRz3T5w7Id+iem5XtTwR7cMUDu0fzJSy5
         enTeFgTUX+wHL+4YzQCOn0tzJ2uXwSFPUba91NVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Cheng <chenglang@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 194/340] RDMA/hns: Fixes missing error code of CMDQ
Date:   Mon,  1 Mar 2021 17:12:18 +0100
Message-Id: <20210301161057.857753079@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

[ Upstream commit 8f86e2eadac968200a6ab1d7074fc0f5cbc1e075 ]

When posting a multi-descriptors command, the error code of previous
failed descriptors may be rewrote to 0 by a later successful descriptor.

Fixes: a04ff739f2a9 ("RDMA/hns: Add command queue support for hip08 RoCE driver")
Link: https://lore.kernel.org/r/1612688143-28226-3-git-send-email-liweihang@huawei.com
Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index e8933daab4995..d01e3222c00cf 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1009,7 +1009,7 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 	u32 timeout = 0;
 	int handle = 0;
 	u16 desc_ret;
-	int ret = 0;
+	int ret;
 	int ntc;
 
 	spin_lock_bh(&csq->lock);
@@ -1054,15 +1054,14 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 	if (hns_roce_cmq_csq_done(hr_dev)) {
 		complete = true;
 		handle = 0;
+		ret = 0;
 		while (handle < num) {
 			/* get the result of hardware write back */
 			desc_to_use = &csq->desc[ntc];
 			desc[handle] = *desc_to_use;
 			dev_dbg(hr_dev->dev, "Get cmq desc:\n");
 			desc_ret = le16_to_cpu(desc[handle].retval);
-			if (desc_ret == CMD_EXEC_SUCCESS)
-				ret = 0;
-			else
+			if (unlikely(desc_ret != CMD_EXEC_SUCCESS))
 				ret = -EIO;
 			priv->cmq.last_status = desc_ret;
 			ntc++;
-- 
2.27.0




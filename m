Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67BF329051
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239577AbhCAUGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:06:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242616AbhCATyR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:54:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C88D65369;
        Mon,  1 Mar 2021 17:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621277;
        bh=r3gIPw+fhaExyriqAza8k07LhVU/C1ETKrYOQHIt9/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXgR+LyADN6gKCbDRkSV/dgpj5wNUhTxF3011iohQWgGp6LBXTxdq8aRI3tQspdQW
         CnXEh+S+tzJxggY2j46Nb3+ssepomHvI/E4odmPbgaXRBDUY8Ya3ARjMM8DP5xUrLn
         a6/VhWyT7dujRXyMcTPMXxxkUvTyFGt+py8ujOf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Cheng <chenglang@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 457/775] RDMA/hns: Fixes missing error code of CMDQ
Date:   Mon,  1 Mar 2021 17:10:25 +0100
Message-Id: <20210301161224.139555665@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 43ed927860569..0f76e193317e6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1264,7 +1264,7 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 	u32 timeout = 0;
 	int handle = 0;
 	u16 desc_ret;
-	int ret = 0;
+	int ret;
 	int ntc;
 
 	spin_lock_bh(&csq->lock);
@@ -1309,15 +1309,14 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F330C3CA6D8
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239492AbhGOSu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:50:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239767AbhGOSuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:50:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02BBD613DC;
        Thu, 15 Jul 2021 18:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374847;
        bh=7/plm/tzYzzz1A7ZW2gp/3VNcfsU1ANn7Tth/YrQCjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VnYlxJYr4AFr91HefcGfRvPhqDJ449KewdLsuEGcY+8+ck6wc7R1b89R2Cw6bHxj1
         JKa2XnHqR7rf2X5ulHLEsvxbH9GYYNcqu/ps8sazmlkkdwkehkhL35gAY8uOcexqD7
         r9+rlbyDaS+LMe1Ulh+aU4bHWTfMtiOk7dHDtUFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/215] RDMA/cxgb4: Fix missing error code in create_qp()
Date:   Thu, 15 Jul 2021 20:37:02 +0200
Message-Id: <20210715182608.255315550@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit aeb27bb76ad8197eb47890b1ff470d5faf8ec9a5 ]

The error code is missing in this code scenario so 0 will be returned. Add
the error code '-EINVAL' to the return value 'ret'.

Eliminates the follow smatch warning:

drivers/infiniband/hw/cxgb4/qp.c:298 create_qp() warn: missing error code 'ret'.

Link: https://lore.kernel.org/r/1622545669-20625-1-git-send-email-jiapeng.chong@linux.alibaba.com
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/qp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 5df4bb52bb10..861e19fdfeb4 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -295,6 +295,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	if (user && (!wq->sq.bar2_pa || (need_rq && !wq->rq.bar2_pa))) {
 		pr_warn("%s: sqid %u or rqid %u not in BAR2 range\n",
 			pci_name(rdev->lldi.pdev), wq->sq.qid, wq->rq.qid);
+		ret = -EINVAL;
 		goto free_dma;
 	}
 
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7C43BD277
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239448AbhGFLmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:42:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237786AbhGFLhV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:37:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EA3261F57;
        Tue,  6 Jul 2021 11:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570988;
        bh=WAQuxWIlNPd2b0uqYifXkaNozvCoZsBxDPZ2UQs77LI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bcPge6+g2V5VGK8yYnbonbN9TRtzjWzAVV4dJY1kOofzMCkjwRdxf/DwFXBeR3JlQ
         mCsikVe05XrUZtN+2OJxDnTodKT1VuEHnvJgY2Ub1NN6w+dZVpE8KkDkr+GbrG6OsF
         DR0A1ST5Z/jjHZgFSedIHlKYsGv7mher7H1lufwHFXRTz1X7q4Jw4/FISYBYV+tyOp
         b6BBB6S3yBfJc3Bezk7M8McwR/rif+ZmCV9vhIhXyWmmQ4+W0bECT5wyqk8qw+TlkA
         p/kl1Be4gNsZ+nVSWUcRe2LC0xeL0Rg09PDuJvZwYXECVb8fMJlqumppjSB3doCqhZ
         +mlWhtdigLcFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 13/31] RDMA/cxgb4: Fix missing error code in create_qp()
Date:   Tue,  6 Jul 2021 07:29:13 -0400
Message-Id: <20210706112931.2066397-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112931.2066397-1-sashal@kernel.org>
References: <20210706112931.2066397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 07579e31168c..67e4002bd776 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -277,6 +277,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	if (user && (!wq->sq.bar2_pa || !wq->rq.bar2_pa)) {
 		pr_warn(MOD "%s: sqid %u or rqid %u not in BAR2 range.\n",
 			pci_name(rdev->lldi.pdev), wq->sq.qid, wq->rq.qid);
+		ret = -EINVAL;
 		goto free_dma;
 	}
 
-- 
2.30.2


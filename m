Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8B440E61E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346398AbhIPRSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243910AbhIPRP6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:15:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 754F461B62;
        Thu, 16 Sep 2021 16:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810395;
        bh=cBJWFyV6EyLbG/4VrZy8SeVrYZV28j/07wIWkvWr7a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6orn9N3LM2BAVec4Qp6B0OZgz1J3jpXc5pJNPByehf1PuawoYrRhnU0ffRwe1Js+
         hgpUmgLSlyKvYZ/pTO92Rzbqk9qFgmKIrBvDCjAQVdF6XiIBh+7l51GYR/xMvreIbL
         5iTSo0PeDuuVieli0GR9LXIWTZe5QQ+RTFBvnbNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 124/432] RDMA/hns: Fix return in hns_roce_rereg_user_mr()
Date:   Thu, 16 Sep 2021 17:57:53 +0200
Message-Id: <20210916155814.959044887@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit c4c7d7a43246a42b0355692c3ed53dff7cbb29bb ]

If re-registering an MR in hns_roce_rereg_user_mr(), we should return NULL
instead of passing 0 to ERR_PTR for clarity.

Fixes: 4e9fc1dae2a9 ("RDMA/hns: Optimize the MR registration process")
Link: https://lore.kernel.org/r/20210804125939.20516-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_mr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 006c84bb3f9f..7089ac780291 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -352,7 +352,9 @@ struct ib_mr *hns_roce_rereg_user_mr(struct ib_mr *ibmr, int flags, u64 start,
 free_cmd_mbox:
 	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
 
-	return ERR_PTR(ret);
+	if (ret)
+		return ERR_PTR(ret);
+	return NULL;
 }
 
 int hns_roce_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
-- 
2.30.2




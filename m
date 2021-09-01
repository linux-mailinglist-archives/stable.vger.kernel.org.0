Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106AC3FDC12
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345646AbhIAMqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345637AbhIAMow (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:44:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75BA16113E;
        Wed,  1 Sep 2021 12:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499929;
        bh=gE9y4BMgno56b6Di4lUpJzX78/XLtt4GCu8UQGSu1NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWjAP9ilQqu8JIQpdfE5Ma4RxxftP77OW/x59o5mVa+poCrPr1HpNIb6g4WSiS0fS
         IMiJV35R71cGTR1s70rU+Ub3FrdyKJ05AAgroV/ZXMBp+IKSklZHN3X071T1Nh4iC8
         qJiV21HckKRoyRUnc/Z95ArJj6+c5xlZS9ohMKzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 039/113] RDMA/bnxt_re: Remove unpaired rtnl unlock in bnxt_re_dev_init()
Date:   Wed,  1 Sep 2021 14:27:54 +0200
Message-Id: <20210901122303.288818109@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit a036ad088306a88de87e973981f2b9224e466c3f ]

The fixed commit removes all rtnl_lock() and rtnl_unlock() calls in
function bnxt_re_dev_init(), but forgets to remove a rtnl_unlock() in the
error handling path of bnxt_re_register_netdev(), which may cause a
deadlock. This bug is suggested by a static analysis tool.

Fixes: c2b777a95923 ("RDMA/bnxt_re: Refactor device add/remove functionalities")
Link: https://lore.kernel.org/r/20210816085531.12167-1-dinghao.liu@zju.edu.cn
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Selvin Xavier <selvin.xavier@broadcom.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 25550d982238..8097a8d8a49f 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1406,7 +1406,6 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 wqe_mode)
 	memset(&rattr, 0, sizeof(rattr));
 	rc = bnxt_re_register_netdev(rdev);
 	if (rc) {
-		rtnl_unlock();
 		ibdev_err(&rdev->ibdev,
 			  "Failed to register with netedev: %#x\n", rc);
 		return -EINVAL;
-- 
2.30.2




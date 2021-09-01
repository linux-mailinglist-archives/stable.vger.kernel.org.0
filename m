Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44893FDB47
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245640AbhIAMkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343687AbhIAMiH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:38:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9E9D6113E;
        Wed,  1 Sep 2021 12:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499677;
        bh=Gq1uqw7EOpqM9jl39hUIj6+zhqPhG3mu8XA/ET/BxaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1iJgKube4LECWD4cjy4XWfoJlcDy0Di1D3byunB4qmPiuzGlnPdjz+qnlOp31bqyn
         5mXxk+ufwNyq4bQ/OQzFXN4OhBm+KOvR/Hd0U34QFJSYzHaVKEGTNf9vA+CKRw3ge0
         XCp3v2GB/nRNqNg2+YsE2iAdcVH+MYY438jBzZ5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/103] RDMA/bnxt_re: Remove unpaired rtnl unlock in bnxt_re_dev_init()
Date:   Wed,  1 Sep 2021 14:27:35 +0200
Message-Id: <20210901122301.363670060@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
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
index 1fadca8af71a..9ef6aea29ff1 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1410,7 +1410,6 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 wqe_mode)
 	memset(&rattr, 0, sizeof(rattr));
 	rc = bnxt_re_register_netdev(rdev);
 	if (rc) {
-		rtnl_unlock();
 		ibdev_err(&rdev->ibdev,
 			  "Failed to register with netedev: %#x\n", rc);
 		return -EINVAL;
-- 
2.30.2




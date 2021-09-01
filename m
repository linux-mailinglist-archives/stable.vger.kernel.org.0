Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FCD3FDB6A
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243979AbhIAMlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344640AbhIAMju (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:39:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 272A86102A;
        Wed,  1 Sep 2021 12:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499735;
        bh=p0sK5D8Q+TYYIViGSLpRcHKYImVJPzRcGIILvkNfRkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJDX7xdG0dhbtkQggWRauyrAqXxhSN0KZUJlgJyzVUDZuIkSsUAvAQiHedYhpYxxL
         MiQq+Rb4hoPKMm4BJ99MZTU7/LJP/MYtCWlx2ZtXaIFzkg95V3deFF83nxOpWI9Jmf
         Yt6BVCT5PgzHQv/v6hfMVeY0u8ETp3N03wMaofjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Firas JahJah <firasj@amazon.com>,
        Yossi Leybovich <sleybo@amazon.com>,
        Gal Pressman <galpress@amazon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/103] RDMA/efa: Free IRQ vectors on error flow
Date:   Wed,  1 Sep 2021 14:27:42 +0200
Message-Id: <20210901122301.632764792@linuxfoundation.org>
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

From: Gal Pressman <galpress@amazon.com>

[ Upstream commit dbe986bdfd6dfe6ef24b833767fff4151e024357 ]

Make sure to free the IRQ vectors in case the allocation doesn't return
the expected number of IRQs.

Fixes: b7f5e880f377 ("RDMA/efa: Add the efa module")
Link: https://lore.kernel.org/r/20210811151131.39138-2-galpress@amazon.com
Reviewed-by: Firas JahJah <firasj@amazon.com>
Reviewed-by: Yossi Leybovich <sleybo@amazon.com>
Signed-off-by: Gal Pressman <galpress@amazon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
index 6faed3a81e08..ffdd18f4217f 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -377,6 +377,7 @@ static int efa_enable_msix(struct efa_dev *dev)
 	}
 
 	if (irq_num != msix_vecs) {
+		efa_disable_msix(dev);
 		dev_err(&dev->pdev->dev,
 			"Allocated %d MSI-X (out of %d requested)\n",
 			irq_num, msix_vecs);
-- 
2.30.2




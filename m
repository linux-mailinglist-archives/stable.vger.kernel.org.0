Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9473FDAA7
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343559AbhIAMdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245025AbhIAMcU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:32:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52A6C610CF;
        Wed,  1 Sep 2021 12:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499483;
        bh=v98xaDog+4rSDrwX6oStY+2c9IVmLIiXLQ0YS0Vilzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3mME06qaTKOWY+jbwb6o4Apyzefrl7c3OuZ6bmWUSiN7SBIuYV2pnj26a6s85H3e
         7ZjC7w1Ghjls4QRHlXbLWgINxNrtK4SebyLyrHlNKN/2AibuDVPVXnOp2SjAlkyhnb
         O1EKfEhCiE/qk1ju5Q9TQV8uFIA5KwRXvuSuBDCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Firas JahJah <firasj@amazon.com>,
        Yossi Leybovich <sleybo@amazon.com>,
        Gal Pressman <galpress@amazon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/48] RDMA/efa: Free IRQ vectors on error flow
Date:   Wed,  1 Sep 2021 14:28:07 +0200
Message-Id: <20210901122253.970935072@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
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
index 83858f7e83d0..75dfe9d1564c 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -340,6 +340,7 @@ static int efa_enable_msix(struct efa_dev *dev)
 	}
 
 	if (irq_num != msix_vecs) {
+		efa_disable_msix(dev);
 		dev_err(&dev->pdev->dev,
 			"Allocated %d MSI-X (out of %d requested)\n",
 			irq_num, msix_vecs);
-- 
2.30.2




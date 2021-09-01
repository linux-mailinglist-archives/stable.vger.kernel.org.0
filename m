Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6803FDC1C
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344640AbhIAMqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345671AbhIAMoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:44:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D899D60232;
        Wed,  1 Sep 2021 12:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499954;
        bh=tQD3A6yE/2wZBu1OnHoxU1+z1993gzCtABlXW7ufpp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enN72HogZcrqW4YSyFblrk89A+UZ5ONvoiQoYwxzhPisheU2108fgoWJVeSwSeAoO
         RHjz/N6d4kRa5T73oRrJOuUazkh9BkP0GF+gfLpOzidl0B/58wdJnO7F1Ooi1kb2ji
         RgBzkFfDd2o/W1P/d6QANyYn7Pa95pDYAqm6q9sU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Firas JahJah <firasj@amazon.com>,
        Yossi Leybovich <sleybo@amazon.com>,
        Gal Pressman <galpress@amazon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 047/113] RDMA/efa: Free IRQ vectors on error flow
Date:   Wed,  1 Sep 2021 14:28:02 +0200
Message-Id: <20210901122303.544459168@linuxfoundation.org>
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
index 816cfd65b7ac..0b61ef0d5983 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -356,6 +356,7 @@ static int efa_enable_msix(struct efa_dev *dev)
 	}
 
 	if (irq_num != msix_vecs) {
+		efa_disable_msix(dev);
 		dev_err(&dev->pdev->dev,
 			"Allocated %d MSI-X (out of %d requested)\n",
 			irq_num, msix_vecs);
-- 
2.30.2




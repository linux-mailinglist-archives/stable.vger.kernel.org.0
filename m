Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF2227C37D
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgI2LGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728806AbgI2LF5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:05:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47AA121941;
        Tue, 29 Sep 2020 11:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377556;
        bh=1KKzDc20o8aDiN1xzsaNGjip393iEygRX8kvP7uo80Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOw8kkgBiKfe0QajkLEai50DzhqZUQy6xgH87NuBkShTl4zXuWHYnlDbJisQZlfd5
         Kw/+yRzMk4FeocOWUOsyLOfLAjsY/cA1pqzpRWCppoHNdY0eOQ0Roe5MjsZkT78nyB
         njLjBkz7ETC8MEEGPb52vjcbRf8T6cEWkcYetEZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 76/85] atm: eni: fix the missed pci_disable_device() for eni_init_one()
Date:   Tue, 29 Sep 2020 13:00:43 +0200
Message-Id: <20200929105931.995203053@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit c2b947879ca320ac5505c6c29a731ff17da5e805 ]

eni_init_one() misses to call pci_disable_device() in an error path.
Jump to err_disable to fix it.

Fixes: ede58ef28e10 ("atm: remove deprecated use of pci api")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/eni.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index ad591a2f7c822..340a1ee79d280 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -2242,7 +2242,7 @@ static int eni_init_one(struct pci_dev *pci_dev,
 
 	rc = dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(32));
 	if (rc < 0)
-		goto out;
+		goto err_disable;
 
 	rc = -ENOMEM;
 	eni_dev = kmalloc(sizeof(struct eni_dev), GFP_KERNEL);
-- 
2.25.1




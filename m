Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4868727CC3E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732961AbgI2Meo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:34:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729133AbgI2LVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:21:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14B2A23A54;
        Tue, 29 Sep 2020 11:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378375;
        bh=9unsS3q9tEXWTm/0zoqbuwZLlylY7BWahi7QGaNDA+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YwVDIeZ7qj9YVH0hX/nTshWg8T8jDyoEkTD+Gmv+8pSyIbEErSFpciRWx1862PNw3
         HBbRCkOubY8beDZad0o87LlxPspNDfwjf78n7BnPWlLF3WgJAScwvC7BAGwcHww/Vt
         D1LI6SNERvZ21zhS72W/V4B52YAVIZYhTeB1P6iA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 151/166] atm: eni: fix the missed pci_disable_device() for eni_init_one()
Date:   Tue, 29 Sep 2020 13:01:03 +0200
Message-Id: <20200929105942.730186310@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
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
index a106d15f6def0..ba549d9454799 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -2243,7 +2243,7 @@ static int eni_init_one(struct pci_dev *pci_dev,
 
 	rc = dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(32));
 	if (rc < 0)
-		goto out;
+		goto err_disable;
 
 	rc = -ENOMEM;
 	eni_dev = kmalloc(sizeof(struct eni_dev), GFP_KERNEL);
-- 
2.25.1




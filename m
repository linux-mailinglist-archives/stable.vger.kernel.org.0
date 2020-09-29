Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E301627C6BD
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbgI2LsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731102AbgI2Lr4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:47:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E0FC2074A;
        Tue, 29 Sep 2020 11:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380075;
        bh=Of9+htbdfTv+wMbAcfBFvj8pqzC1G2Lf5UtUAdqooiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AzTa+2E9hew1aduYaKyzMOEAIFvR0vPVSO2AvnI/4vEXRbG6wXaZO7VReCVrBLrCm
         rsf+LvbpfhpTk46PygtKR7xrmsJklgWiDiAsvLWT1D5/vtUJTjBhaTNZjZji8OxpGR
         ssfxehMYHv+z2r8/aF0QetlfTRSMSHVMK72nwpP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 27/99] atm: eni: fix the missed pci_disable_device() for eni_init_one()
Date:   Tue, 29 Sep 2020 13:01:10 +0200
Message-Id: <20200929105931.065626647@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
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
index 17d47ad03ab79..de50fb0541a20 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -2239,7 +2239,7 @@ static int eni_init_one(struct pci_dev *pci_dev,
 
 	rc = dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(32));
 	if (rc < 0)
-		goto out;
+		goto err_disable;
 
 	rc = -ENOMEM;
 	eni_dev = kmalloc(sizeof(struct eni_dev), GFP_KERNEL);
-- 
2.25.1




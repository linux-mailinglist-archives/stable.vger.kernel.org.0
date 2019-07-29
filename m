Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAEBE79559
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389367AbfG2Tlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:41:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389363AbfG2Tlb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:41:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DD7221655;
        Mon, 29 Jul 2019 19:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429290;
        bh=v7sks2e6muLIM6cZO40Wu7vtz4iGZ6tb3NNZnvw9x8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xrp0CFmBGOPQnE/Ve38nLrFxjC+KE+7kQKLMIYxwz/V+sfIXeWe9no+Qdn6l1tTKG
         wJqy87lhH/N+75/ESa8Y/EwXHVRgasrwZ9dzMLb3z2IKDYfv2+QebuQn89Mx5947IR
         ZwonZOGiOlgfxSrPh0s6GNhyf6FeG2CPIqbSMvgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Chen Feng <puck.chen@hisilicon.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/113] mfd: hi655x-pmic: Fix missing return value check for devm_regmap_init_mmio_clk
Date:   Mon, 29 Jul 2019 21:22:18 +0200
Message-Id: <20190729190707.758914907@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7efd105c27fd2323789b41b64763a0e33ed79c08 ]

Since devm_regmap_init_mmio_clk can fail, add return value checking.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Chen Feng <puck.chen@hisilicon.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/hi655x-pmic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/hi655x-pmic.c b/drivers/mfd/hi655x-pmic.c
index 96c07fa1802a..6693f74aa6ab 100644
--- a/drivers/mfd/hi655x-pmic.c
+++ b/drivers/mfd/hi655x-pmic.c
@@ -112,6 +112,8 @@ static int hi655x_pmic_probe(struct platform_device *pdev)
 
 	pmic->regmap = devm_regmap_init_mmio_clk(dev, NULL, base,
 						 &hi655x_regmap_config);
+	if (IS_ERR(pmic->regmap))
+		return PTR_ERR(pmic->regmap);
 
 	regmap_read(pmic->regmap, HI655X_BUS_ADDR(HI655X_VER_REG), &pmic->ver);
 	if ((pmic->ver < PMU_VER_START) || (pmic->ver > PMU_VER_END)) {
-- 
2.20.1




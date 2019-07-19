Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C017D6DAF4
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfGSEFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:05:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730232AbfGSEFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:05:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3178921852;
        Fri, 19 Jul 2019 04:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509113;
        bh=aLsdwTpMpfOml35aRANSXramiq7HO3wnjV9fDK1SdcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMyQC3XWrFLn80dZ/4xrCiuDoDGhPjAdIjz2q0IkTd1a2vTIe2Dfha8TTsOaSjfD2
         /VZcWLFebDIbBE4EEopskvBf8bGb82eHX5H2WOou1a2FaxGs7F4CTXBcLSux7dIBnO
         zsSTpw9dkpJuVF6vXo7OGLsUDlZe1kyGxAfLtEnA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>,
        Chen Feng <puck.chen@hisilicon.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 077/141] mfd: hi655x-pmic: Fix missing return value check for devm_regmap_init_mmio_clk
Date:   Fri, 19 Jul 2019 00:01:42 -0400
Message-Id: <20190719040246.15945-77-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

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


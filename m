Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AD66DBE6
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387930AbfGSEMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729594AbfGSEMN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:12:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2B4921873;
        Fri, 19 Jul 2019 04:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509532;
        bh=aLsdwTpMpfOml35aRANSXramiq7HO3wnjV9fDK1SdcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1h+e7l8kYP0Q9L+3OixhfauDz5RiiJd26ydFVrrR5MNELQwSWdI31UQpFfRBcT7M2
         p7QilAYw9Q8d23yZ+Op+2XaE5gXQ81cvGQ34OaA3mOlFmf2Ngmp0tAS+fxSvKP2ecf
         Sza99/OXtD10HvTSR5/7AD3QXeK0YmaWoMeH7Ip8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>,
        Chen Feng <puck.chen@hisilicon.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 35/60] mfd: hi655x-pmic: Fix missing return value check for devm_regmap_init_mmio_clk
Date:   Fri, 19 Jul 2019 00:10:44 -0400
Message-Id: <20190719041109.18262-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041109.18262-1-sashal@kernel.org>
References: <20190719041109.18262-1-sashal@kernel.org>
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


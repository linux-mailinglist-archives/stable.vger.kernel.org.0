Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0AE404EC4
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349053AbhIIMOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347750AbhIIMLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:11:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2853861A10;
        Thu,  9 Sep 2021 11:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188120;
        bh=Mgk6zcJV3cp/1FnKDc4HTUGsqHEyT0cD/bodCBNyz7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwBxedil7rElwXcglHXS6UMObIEBKrzR53sSahsc5lgtf/TIviMZuu8CCmQ0YKat3
         xUm1pbJio4tVC3SHCJ/HufG4C6kI3RR6K2OhTY2L4JkjC879/Q47HSMHbkg8zzGHaa
         WIeLygSIiYF414U1UqRdJ3+Aqd/CZJfGv6zczoDkeQl/vgRDtjKfj+4OBDyBqxRDbp
         ULaHkrJHGCVPpspOn0b8JRBROExemY5G4NVJTwBeuzDiJYqKEyij9BjbBkxsR9JPXM
         0pyPuss52+wGfI9xrJ/NC3+ArIsRNrmUPx55XpT1PFKidrWCDjvsNnjVzwA3LaiHVm
         /VE/Brs4y1vjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 096/219] media: tegra-cec: Handle errors of clk_prepare_enable()
Date:   Thu,  9 Sep 2021 07:44:32 -0400
Message-Id: <20210909114635.143983-96-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 38367073c796a37a61549b1f66a71b3adb03802d ]

tegra_cec_probe() and tegra_cec_resume() ignored possible errors of
clk_prepare_enable(). The patch fixes this.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/tegra/tegra_cec.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/cec/platform/tegra/tegra_cec.c b/drivers/media/cec/platform/tegra/tegra_cec.c
index 1ac0c70a5981..5e907395ca2e 100644
--- a/drivers/media/cec/platform/tegra/tegra_cec.c
+++ b/drivers/media/cec/platform/tegra/tegra_cec.c
@@ -366,7 +366,11 @@ static int tegra_cec_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	clk_prepare_enable(cec->clk);
+	ret = clk_prepare_enable(cec->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to prepare clock for CEC\n");
+		return ret;
+	}
 
 	/* set context info. */
 	cec->dev = &pdev->dev;
@@ -446,9 +450,7 @@ static int tegra_cec_resume(struct platform_device *pdev)
 
 	dev_notice(&pdev->dev, "Resuming\n");
 
-	clk_prepare_enable(cec->clk);
-
-	return 0;
+	return clk_prepare_enable(cec->clk);
 }
 #endif
 
-- 
2.30.2


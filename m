Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF5840532D
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346720AbhIIMuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353691AbhIIMrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:47:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD33563217;
        Thu,  9 Sep 2021 11:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188574;
        bh=zSV7DOOWFw3nSUmyFh+zYk2R/S1ll/DHgGt+nt/QXng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+mUvfoGqshRSZVZ37KPwz4xf2+3KecnPNwhHQnquMwdT2x/DNIPTYR7vMyOWhpLO
         Ni33msmQuQadiptEZC8FTIDozTKd2qb2MoEALP0rQpW5ZrYaVgS4RDiyD79JIoyLV8
         g/y08ubyxtsMPpBk/oI0wbK0A5G7Is4jrRNhaIJ4Xpm14YDqwJHc84rVYRajcNqz/u
         d6OgDUJTInOmdwUoxCXUUMZ1PXt9XwinuqaR8rDygyKqWnPG7PQhtMRBtLRdrmE59w
         1lNk2O0WyoshQ+Ci5afVyZO+41kVpxSLp6RPX5F/v0Xmu7O03ss0D+izzx/IrMLnPn
         rHdmtQa5xuY0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 053/109] media: tegra-cec: Handle errors of clk_prepare_enable()
Date:   Thu,  9 Sep 2021 07:54:10 -0400
Message-Id: <20210909115507.147917-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
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
 drivers/media/platform/tegra-cec/tegra_cec.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/tegra-cec/tegra_cec.c b/drivers/media/platform/tegra-cec/tegra_cec.c
index a632602131f2..efb80a78d2fa 100644
--- a/drivers/media/platform/tegra-cec/tegra_cec.c
+++ b/drivers/media/platform/tegra-cec/tegra_cec.c
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


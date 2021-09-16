Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0611140E061
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240967AbhIPQVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236927AbhIPQSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:18:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F876613CD;
        Thu, 16 Sep 2021 16:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808769;
        bh=Mgk6zcJV3cp/1FnKDc4HTUGsqHEyT0cD/bodCBNyz7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00KzxR//zt1/jyeBFO8/AcwEO8pM7g7mKi9KPwbvhbL+AZ4ISVPN3fDdjRNHYJivq
         fn+R0iBoJ20I2B+s5Kh5YvPLALbBTku69AjMwE1yGgHVSuUAjrrQ3GEsdJImlfT1MH
         Eee1fqgsIDBn3MH64DXRsY2vSOKM8a0y6QFq/q+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 183/306] media: tegra-cec: Handle errors of clk_prepare_enable()
Date:   Thu, 16 Sep 2021 17:58:48 +0200
Message-Id: <20210916155800.320804646@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




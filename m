Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E316AF4B5
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbjCGTS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbjCGTS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:18:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B486C3E01
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:02:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC6C36152E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E21C433D2;
        Tue,  7 Mar 2023 19:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215744;
        bh=Hw5QfoakXNLEy6GSZj+5wQlFv8k8rjL6ttV4LN9kdus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wO28NG2eri2Z5RQ2YMfjx1aNwF5HfZBB/oa+KDfjha25/2If+VUsR4dLZqX+QCGkK
         MB+yI52Fh2dT0NIYCwgIdyK5iRKPSwq5t+VTYxF/lwxBQnED7JR7Fl3chYTwQbkMWZ
         3pix+HWqPMz3yGjZtAlwel0FtB1aReWTDvvkjwXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 359/567] media: imx-jpeg: Apply clk_bulk api instead of operating specific clk
Date:   Tue,  7 Mar 2023 18:01:35 +0100
Message-Id: <20230307165921.441100320@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 61fe43dc9f454bc3caa99dbdd8f5fa3ba813981a ]

using the api of clk_bulk can simplify the code.
and the clock of the jpeg codec may be changed,
the clk_bulk api can be compatible with the future change.

Fixes: 4c2e5156d9fa ("media: imx-jpeg: Add pm-runtime support for imx-jpeg")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imx-jpeg/mxc-jpeg.c | 35 +++++-----------------
 drivers/media/platform/imx-jpeg/mxc-jpeg.h |  4 +--
 2 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index 984fcdfa0f098..e515325683a47 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -2105,19 +2105,12 @@ static int mxc_jpeg_probe(struct platform_device *pdev)
 	jpeg->mode = mode;
 
 	/* Get clocks */
-	jpeg->clk_ipg = devm_clk_get(dev, "ipg");
-	if (IS_ERR(jpeg->clk_ipg)) {
-		dev_err(dev, "failed to get clock: ipg\n");
-		ret = PTR_ERR(jpeg->clk_ipg);
-		goto err_clk;
-	}
-
-	jpeg->clk_per = devm_clk_get(dev, "per");
-	if (IS_ERR(jpeg->clk_per)) {
-		dev_err(dev, "failed to get clock: per\n");
-		ret = PTR_ERR(jpeg->clk_per);
+	ret = devm_clk_bulk_get_all(&pdev->dev, &jpeg->clks);
+	if (ret < 0) {
+		dev_err(dev, "failed to get clock\n");
 		goto err_clk;
 	}
+	jpeg->num_clks = ret;
 
 	ret = mxc_jpeg_attach_pm_domains(jpeg);
 	if (ret < 0) {
@@ -2214,32 +2207,20 @@ static int mxc_jpeg_runtime_resume(struct device *dev)
 	struct mxc_jpeg_dev *jpeg = dev_get_drvdata(dev);
 	int ret;
 
-	ret = clk_prepare_enable(jpeg->clk_ipg);
-	if (ret < 0) {
-		dev_err(dev, "failed to enable clock: ipg\n");
-		goto err_ipg;
-	}
-
-	ret = clk_prepare_enable(jpeg->clk_per);
+	ret = clk_bulk_prepare_enable(jpeg->num_clks, jpeg->clks);
 	if (ret < 0) {
-		dev_err(dev, "failed to enable clock: per\n");
-		goto err_per;
+		dev_err(dev, "failed to enable clock\n");
+		return ret;
 	}
 
 	return 0;
-
-err_per:
-	clk_disable_unprepare(jpeg->clk_ipg);
-err_ipg:
-	return ret;
 }
 
 static int mxc_jpeg_runtime_suspend(struct device *dev)
 {
 	struct mxc_jpeg_dev *jpeg = dev_get_drvdata(dev);
 
-	clk_disable_unprepare(jpeg->clk_ipg);
-	clk_disable_unprepare(jpeg->clk_per);
+	clk_bulk_disable_unprepare(jpeg->num_clks, jpeg->clks);
 
 	return 0;
 }
diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.h b/drivers/media/platform/imx-jpeg/mxc-jpeg.h
index 542993eb8d5b0..495000800d552 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.h
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.h
@@ -112,8 +112,8 @@ struct mxc_jpeg_dev {
 	spinlock_t			hw_lock; /* hardware access lock */
 	unsigned int			mode;
 	struct mutex			lock; /* v4l2 ioctls serialization */
-	struct clk			*clk_ipg;
-	struct clk			*clk_per;
+	struct clk_bulk_data		*clks;
+	int				num_clks;
 	struct platform_device		*pdev;
 	struct device			*dev;
 	void __iomem			*base_reg;
-- 
2.39.2




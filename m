Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7AE6AEB39
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbjCGRlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjCGRlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:41:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1920AA6BD8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:37:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BBB2B819A3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2EDC433D2;
        Tue,  7 Mar 2023 17:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210640;
        bh=HCsaa4soqzc9TBLolkjNWarmzGTNmP/a+maQRm91VWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfBXLhxmSJw/smlQIeQVG5TuFXr/uYaWQFJvHIC6sjMkxv5ZgNnEy2evJnPSY44om
         0uZYu7HMZlJaUyILoj5otj67Yj8gVTB6irGzN4zKdWMuj3ZrLhd8v5UrruUN69DHof
         u3Pb2F8xtU5O1KzjlSK2idHnYyp2oJEbx/nMhk4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0607/1001] media: imx-jpeg: Apply clk_bulk api instead of operating specific clk
Date:   Tue,  7 Mar 2023 17:56:19 +0100
Message-Id: <20230307170047.856281637@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.c    | 35 +++++--------------
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.h    |  4 +--
 2 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index 6cd015a35f7c4..f085f14d676ad 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -2472,19 +2472,12 @@ static int mxc_jpeg_probe(struct platform_device *pdev)
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
@@ -2581,32 +2574,20 @@ static int mxc_jpeg_runtime_resume(struct device *dev)
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
diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
index 8fa8c0aec5a2d..87157db780826 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
@@ -120,8 +120,8 @@ struct mxc_jpeg_dev {
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




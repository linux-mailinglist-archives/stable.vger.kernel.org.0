Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08AB24510C2
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239837AbhKOSzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:55:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242985AbhKOSwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:52:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0673263472;
        Mon, 15 Nov 2021 18:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999798;
        bh=rXrC95nwVbI6k6o1JvNF/OGvaEjc0s4y3JP4f6MEW7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISPEl2Um0MfbB1SYEGNeK4bkiBxN5Khn3jbaCC7uT8DZwvRlIB8fRf08wRQXkbm6U
         ePIiXm7I6kjfbkOdjv4tewvJHNxoyriujAVGkOhmKXflnRXlptH4o2GDTqjB8NwvOw
         zJiY6DV5BE0PMse0Rp245jRdPs4AkeujMWAl6NbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 395/849] media: atmel: fix the ispck initialization
Date:   Mon, 15 Nov 2021 17:57:58 +0100
Message-Id: <20211115165433.611648070@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit d7f26849ed7cc875d0ff7480c2efebeeccea2bad ]

The runtime enabling of the ISPCK (internally clocks the pipeline inside
the ISC) has to be done after the pm_runtime for the ISC dev has been
started.

After the commit by Mauro:
the ISC failed to probe with the error:

atmel-sama5d2-isc f0008000.isc: failed to enable ispck: -13
atmel-sama5d2-isc: probe of f0008000.isc failed with error -13

This is because the enabling of the ispck is done too early in the probe,
and the PM runtime returns invalid request.
Thus, moved this clock enabling after pm_runtime_idle is called.

The ISPCK is required only for sama5d2 type of ISC.
Thus, add a bool inside the isc struct that is platform dependent.
For the sama7g5-isc, the enabling of the ISPCK is wrong and does not make
sense. Removed it from the sama7g5 probe. In sama7g5-isc, there is only
one clock, the MCK, which also clocks the internal pipeline of the ISC.

Adapted the clk_prepare and clk_unprepare to request the runtime PM
for both clocks (MCK and ISPCK) in case of sama5d2-isc, and the single
clock (MCK) in case of sama7g5-isc.

Fixes: dd97908ee350 ("media: atmel: properly get pm_runtime")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isc-base.c | 25 ++++++------
 drivers/media/platform/atmel/atmel-isc.h      |  2 +
 .../media/platform/atmel/atmel-sama5d2-isc.c  | 39 ++++++++++---------
 .../media/platform/atmel/atmel-sama7g5-isc.c  | 22 ++---------
 4 files changed, 38 insertions(+), 50 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc-base.c b/drivers/media/platform/atmel/atmel-isc-base.c
index 136ab7cf36edc..ebf264b980f91 100644
--- a/drivers/media/platform/atmel/atmel-isc-base.c
+++ b/drivers/media/platform/atmel/atmel-isc-base.c
@@ -123,11 +123,9 @@ static int isc_clk_prepare(struct clk_hw *hw)
 	struct isc_clk *isc_clk = to_isc_clk(hw);
 	int ret;
 
-	if (isc_clk->id == ISC_ISPCK) {
-		ret = pm_runtime_resume_and_get(isc_clk->dev);
-		if (ret < 0)
-			return ret;
-	}
+	ret = pm_runtime_resume_and_get(isc_clk->dev);
+	if (ret < 0)
+		return ret;
 
 	return isc_wait_clk_stable(hw);
 }
@@ -138,8 +136,7 @@ static void isc_clk_unprepare(struct clk_hw *hw)
 
 	isc_wait_clk_stable(hw);
 
-	if (isc_clk->id == ISC_ISPCK)
-		pm_runtime_put_sync(isc_clk->dev);
+	pm_runtime_put_sync(isc_clk->dev);
 }
 
 static int isc_clk_enable(struct clk_hw *hw)
@@ -186,16 +183,13 @@ static int isc_clk_is_enabled(struct clk_hw *hw)
 	u32 status;
 	int ret;
 
-	if (isc_clk->id == ISC_ISPCK) {
-		ret = pm_runtime_resume_and_get(isc_clk->dev);
-		if (ret < 0)
-			return 0;
-	}
+	ret = pm_runtime_resume_and_get(isc_clk->dev);
+	if (ret < 0)
+		return 0;
 
 	regmap_read(isc_clk->regmap, ISC_CLKSR, &status);
 
-	if (isc_clk->id == ISC_ISPCK)
-		pm_runtime_put_sync(isc_clk->dev);
+	pm_runtime_put_sync(isc_clk->dev);
 
 	return status & ISC_CLK(isc_clk->id) ? 1 : 0;
 }
@@ -325,6 +319,9 @@ static int isc_clk_register(struct isc_device *isc, unsigned int id)
 	const char *parent_names[3];
 	int num_parents;
 
+	if (id == ISC_ISPCK && !isc->ispck_required)
+		return 0;
+
 	num_parents = of_clk_get_parent_count(np);
 	if (num_parents < 1 || num_parents > 3)
 		return -EINVAL;
diff --git a/drivers/media/platform/atmel/atmel-isc.h b/drivers/media/platform/atmel/atmel-isc.h
index 19cc60dfcbe0f..2bfcb135ef13b 100644
--- a/drivers/media/platform/atmel/atmel-isc.h
+++ b/drivers/media/platform/atmel/atmel-isc.h
@@ -178,6 +178,7 @@ struct isc_reg_offsets {
  * @hclock:		Hclock clock input (refer datasheet)
  * @ispck:		iscpck clock (refer datasheet)
  * @isc_clks:		ISC clocks
+ * @ispck_required:	ISC requires ISP Clock initialization
  * @dcfg:		DMA master configuration, architecture dependent
  *
  * @dev:		Registered device driver
@@ -252,6 +253,7 @@ struct isc_device {
 	struct clk		*hclock;
 	struct clk		*ispck;
 	struct isc_clk		isc_clks[2];
+	bool			ispck_required;
 	u32			dcfg;
 
 	struct device		*dev;
diff --git a/drivers/media/platform/atmel/atmel-sama5d2-isc.c b/drivers/media/platform/atmel/atmel-sama5d2-isc.c
index b66f1d174e9d7..e29a9193bac81 100644
--- a/drivers/media/platform/atmel/atmel-sama5d2-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama5d2-isc.c
@@ -454,6 +454,9 @@ static int atmel_isc_probe(struct platform_device *pdev)
 	/* sama5d2-isc - 8 bits per beat */
 	isc->dcfg = ISC_DCFG_YMBSIZE_BEATS8 | ISC_DCFG_CMBSIZE_BEATS8;
 
+	/* sama5d2-isc : ISPCK is required and mandatory */
+	isc->ispck_required = true;
+
 	ret = isc_pipeline_init(isc);
 	if (ret)
 		return ret;
@@ -476,22 +479,6 @@ static int atmel_isc_probe(struct platform_device *pdev)
 		dev_err(dev, "failed to init isc clock: %d\n", ret);
 		goto unprepare_hclk;
 	}
-
-	isc->ispck = isc->isc_clks[ISC_ISPCK].clk;
-
-	ret = clk_prepare_enable(isc->ispck);
-	if (ret) {
-		dev_err(dev, "failed to enable ispck: %d\n", ret);
-		goto unprepare_hclk;
-	}
-
-	/* ispck should be greater or equal to hclock */
-	ret = clk_set_rate(isc->ispck, clk_get_rate(isc->hclock));
-	if (ret) {
-		dev_err(dev, "failed to set ispck rate: %d\n", ret);
-		goto unprepare_clk;
-	}
-
 	ret = v4l2_device_register(dev, &isc->v4l2_dev);
 	if (ret) {
 		dev_err(dev, "unable to register v4l2 device.\n");
@@ -545,19 +532,35 @@ static int atmel_isc_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	pm_request_idle(dev);
 
+	isc->ispck = isc->isc_clks[ISC_ISPCK].clk;
+
+	ret = clk_prepare_enable(isc->ispck);
+	if (ret) {
+		dev_err(dev, "failed to enable ispck: %d\n", ret);
+		goto cleanup_subdev;
+	}
+
+	/* ispck should be greater or equal to hclock */
+	ret = clk_set_rate(isc->ispck, clk_get_rate(isc->hclock));
+	if (ret) {
+		dev_err(dev, "failed to set ispck rate: %d\n", ret);
+		goto unprepare_clk;
+	}
+
 	regmap_read(isc->regmap, ISC_VERSION + isc->offsets.version, &ver);
 	dev_info(dev, "Microchip ISC version %x\n", ver);
 
 	return 0;
 
+unprepare_clk:
+	clk_disable_unprepare(isc->ispck);
+
 cleanup_subdev:
 	isc_subdev_cleanup(isc);
 
 unregister_v4l2_device:
 	v4l2_device_unregister(&isc->v4l2_dev);
 
-unprepare_clk:
-	clk_disable_unprepare(isc->ispck);
 unprepare_hclk:
 	clk_disable_unprepare(isc->hclock);
 
diff --git a/drivers/media/platform/atmel/atmel-sama7g5-isc.c b/drivers/media/platform/atmel/atmel-sama7g5-isc.c
index f2785131ff569..9c05acafd0724 100644
--- a/drivers/media/platform/atmel/atmel-sama7g5-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama7g5-isc.c
@@ -447,6 +447,9 @@ static int microchip_xisc_probe(struct platform_device *pdev)
 	/* sama7g5-isc RAM access port is full AXI4 - 32 bits per beat */
 	isc->dcfg = ISC_DCFG_YMBSIZE_BEATS32 | ISC_DCFG_CMBSIZE_BEATS32;
 
+	/* sama7g5-isc : ISPCK does not exist, ISC is clocked by MCK */
+	isc->ispck_required = false;
+
 	ret = isc_pipeline_init(isc);
 	if (ret)
 		return ret;
@@ -470,25 +473,10 @@ static int microchip_xisc_probe(struct platform_device *pdev)
 		goto unprepare_hclk;
 	}
 
-	isc->ispck = isc->isc_clks[ISC_ISPCK].clk;
-
-	ret = clk_prepare_enable(isc->ispck);
-	if (ret) {
-		dev_err(dev, "failed to enable ispck: %d\n", ret);
-		goto unprepare_hclk;
-	}
-
-	/* ispck should be greater or equal to hclock */
-	ret = clk_set_rate(isc->ispck, clk_get_rate(isc->hclock));
-	if (ret) {
-		dev_err(dev, "failed to set ispck rate: %d\n", ret);
-		goto unprepare_clk;
-	}
-
 	ret = v4l2_device_register(dev, &isc->v4l2_dev);
 	if (ret) {
 		dev_err(dev, "unable to register v4l2 device.\n");
-		goto unprepare_clk;
+		goto unprepare_hclk;
 	}
 
 	ret = xisc_parse_dt(dev, isc);
@@ -549,8 +537,6 @@ cleanup_subdev:
 unregister_v4l2_device:
 	v4l2_device_unregister(&isc->v4l2_dev);
 
-unprepare_clk:
-	clk_disable_unprepare(isc->ispck);
 unprepare_hclk:
 	clk_disable_unprepare(isc->hclock);
 
-- 
2.33.0




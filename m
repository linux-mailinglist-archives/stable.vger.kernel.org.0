Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444315936C6
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243592AbiHOSoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243284AbiHOSnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:43:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F652F666;
        Mon, 15 Aug 2022 11:26:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39E3260FCC;
        Mon, 15 Aug 2022 18:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26410C433D7;
        Mon, 15 Aug 2022 18:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588018;
        bh=bY9QZ16eAawxiTewKuMnGgnKDZ3/A95yXiW9idzT2OM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kp2Fn/zBWnbfbnkiphcDzhnR6K0aYXlBfsgaZZXLMzrMhzFDwOAqBFjicoHR7ZByr
         jUXaqgQVMfEwrE+zoF6CFkDX3CMzkl2/+L10PKFlKXiePjxjLVpxI0+vcaVgAaMmKy
         EgyFRs1ymKf3e3u4Gz16LjVzTSrgNSInQJCd5+HQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mirela Rabulea <mirela.rabulea@oss.nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 270/779] media: imx-jpeg: Add pm-runtime support for imx-jpeg
Date:   Mon, 15 Aug 2022 19:58:34 +0200
Message-Id: <20220815180348.871974141@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mirela Rabulea <mirela.rabulea@oss.nxp.com>

[ Upstream commit 4c2e5156d9fa63a3f41c2bf56b694ad42df825d7 ]

Save some power by disabling/enabling the jpeg clocks with
every stream stop/start.
Do not use DL_FLAG_RPM_ACTIVE in mxc_jpeg_attach_pm_domains,
to ensure power domains are off after probe.

Signed-off-by: Mirela Rabulea <mirela.rabulea@oss.nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imx-jpeg/mxc-jpeg.c | 73 +++++++++++++++++++++-
 drivers/media/platform/imx-jpeg/mxc-jpeg.h |  2 +
 2 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index 5289a822bcb1..bc66c09b807a 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -49,6 +49,7 @@
 #include <linux/slab.h>
 #include <linux/irqreturn.h>
 #include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
 #include <linux/pm_domain.h>
 #include <linux/string.h>
 
@@ -1074,10 +1075,17 @@ static int mxc_jpeg_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct mxc_jpeg_ctx *ctx = vb2_get_drv_priv(q);
 	struct mxc_jpeg_q_data *q_data = mxc_jpeg_get_q_data(ctx, q->type);
+	int ret;
 
 	dev_dbg(ctx->mxc_jpeg->dev, "Start streaming ctx=%p", ctx);
 	q_data->sequence = 0;
 
+	ret = pm_runtime_resume_and_get(ctx->mxc_jpeg->dev);
+	if (ret < 0) {
+		dev_err(ctx->mxc_jpeg->dev, "Failed to power up jpeg\n");
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -1095,9 +1103,10 @@ static void mxc_jpeg_stop_streaming(struct vb2_queue *q)
 		else
 			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 		if (!vbuf)
-			return;
+			break;
 		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
 	}
+	pm_runtime_put_sync(&ctx->mxc_jpeg->pdev->dev);
 }
 
 static int mxc_jpeg_valid_comp_id(struct device *dev,
@@ -1957,8 +1966,7 @@ static int mxc_jpeg_attach_pm_domains(struct mxc_jpeg_dev *jpeg)
 
 		jpeg->pd_link[i] = device_link_add(dev, jpeg->pd_dev[i],
 						   DL_FLAG_STATELESS |
-						   DL_FLAG_PM_RUNTIME |
-						   DL_FLAG_RPM_ACTIVE);
+						   DL_FLAG_PM_RUNTIME);
 		if (!jpeg->pd_link[i]) {
 			ret = -EINVAL;
 			goto fail;
@@ -2023,6 +2031,19 @@ static int mxc_jpeg_probe(struct platform_device *pdev)
 	jpeg->dev = dev;
 	jpeg->mode = mode;
 
+	/* Get clocks */
+	jpeg->clk_ipg = devm_clk_get(dev, "ipg");
+	if (IS_ERR(jpeg->clk_ipg)) {
+		dev_err(dev, "failed to get clock: ipg\n");
+		goto err_clk;
+	}
+
+	jpeg->clk_per = devm_clk_get(dev, "per");
+	if (IS_ERR(jpeg->clk_per)) {
+		dev_err(dev, "failed to get clock: per\n");
+		goto err_clk;
+	}
+
 	ret = mxc_jpeg_attach_pm_domains(jpeg);
 	if (ret < 0) {
 		dev_err(dev, "failed to attach power domains %d\n", ret);
@@ -2091,6 +2112,7 @@ static int mxc_jpeg_probe(struct platform_device *pdev)
 			  jpeg->dec_vdev->minor);
 
 	platform_set_drvdata(pdev, jpeg);
+	pm_runtime_enable(dev);
 
 	return 0;
 
@@ -2107,9 +2129,52 @@ static int mxc_jpeg_probe(struct platform_device *pdev)
 	mxc_jpeg_detach_pm_domains(jpeg);
 
 err_irq:
+err_clk:
+	return ret;
+}
+
+#ifdef CONFIG_PM
+static int mxc_jpeg_runtime_resume(struct device *dev)
+{
+	struct mxc_jpeg_dev *jpeg = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_prepare_enable(jpeg->clk_ipg);
+	if (ret < 0) {
+		dev_err(dev, "failed to enable clock: ipg\n");
+		goto err_ipg;
+	}
+
+	ret = clk_prepare_enable(jpeg->clk_per);
+	if (ret < 0) {
+		dev_err(dev, "failed to enable clock: per\n");
+		goto err_per;
+	}
+
+	return 0;
+
+err_per:
+	clk_disable_unprepare(jpeg->clk_ipg);
+err_ipg:
 	return ret;
 }
 
+static int mxc_jpeg_runtime_suspend(struct device *dev)
+{
+	struct mxc_jpeg_dev *jpeg = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(jpeg->clk_ipg);
+	clk_disable_unprepare(jpeg->clk_per);
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops	mxc_jpeg_pm_ops = {
+	SET_RUNTIME_PM_OPS(mxc_jpeg_runtime_suspend,
+			   mxc_jpeg_runtime_resume, NULL)
+};
+
 static int mxc_jpeg_remove(struct platform_device *pdev)
 {
 	unsigned int slot;
@@ -2118,6 +2183,7 @@ static int mxc_jpeg_remove(struct platform_device *pdev)
 	for (slot = 0; slot < MXC_MAX_SLOTS; slot++)
 		mxc_jpeg_free_slot_data(jpeg, slot);
 
+	pm_runtime_disable(&pdev->dev);
 	video_unregister_device(jpeg->dec_vdev);
 	v4l2_m2m_release(jpeg->m2m_dev);
 	v4l2_device_unregister(&jpeg->v4l2_dev);
@@ -2134,6 +2200,7 @@ static struct platform_driver mxc_jpeg_driver = {
 	.driver = {
 		.name = "mxc-jpeg",
 		.of_match_table = mxc_jpeg_match,
+		.pm = &mxc_jpeg_pm_ops,
 	},
 };
 module_platform_driver(mxc_jpeg_driver);
diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.h b/drivers/media/platform/imx-jpeg/mxc-jpeg.h
index 4c210852e876..9fb2a5aaa941 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.h
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.h
@@ -109,6 +109,8 @@ struct mxc_jpeg_dev {
 	spinlock_t			hw_lock; /* hardware access lock */
 	unsigned int			mode;
 	struct mutex			lock; /* v4l2 ioctls serialization */
+	struct clk			*clk_ipg;
+	struct clk			*clk_per;
 	struct platform_device		*pdev;
 	struct device			*dev;
 	void __iomem			*base_reg;
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243174F277D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbiDEIGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiDEH7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4EA55772;
        Tue,  5 Apr 2022 00:53:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68BDF615C3;
        Tue,  5 Apr 2022 07:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E91C340EE;
        Tue,  5 Apr 2022 07:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145219;
        bh=2YqmjfgACSAiMKpptSA+uHShsOTwHaNS6ZVX8GBgU6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kn3k7kpnhJUPx3fttekBsrC5faMihhKpMSdaCDD37A8/JxQTtMxKXQLqrKZUT4RpZ
         3PaNcs3Si9QaGIHAKtupMD1yBFKzL/SU6LfexH9YTwnkyJLZ9EkJ4RaVjdmTmszQLD
         A7T9wY/eSnOq5bQzCUB82MKkn2hcgdns0jKWEaBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0301/1126] media: imx: imx8mq-mipi_csi2: fix system resume
Date:   Tue,  5 Apr 2022 09:17:28 +0200
Message-Id: <20220405070416.449920304@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Martin Kepplinger <martin.kepplinger@puri.sm>

[ Upstream commit f0c2ba1ed4ad868331d8c6ea9119669a729b01a9 ]

during system resume, interconnect bandwidth would currently be requested
even though the device is runtime suspended. This leaves the system in an
unbalanced state.

Fix that by only doing that in runtimem pm and splitting up runtime and
system suspend to be a more readable:
imx8mq_mipi_csi_pm_*() does the generic things called from system- and
runtime functions that each do specific things on top.

Fixes: f33fd8d77dd0 ("media: imx: add a driver for i.MX8MQ mipi csi rx phy and controller")
Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx8mq-mipi-csi2.c | 71 +++++++++++++-------
 1 file changed, 47 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/media/imx/imx8mq-mipi-csi2.c b/drivers/staging/media/imx/imx8mq-mipi-csi2.c
index 8f3cc138c52c..3b9fa75efac6 100644
--- a/drivers/staging/media/imx/imx8mq-mipi-csi2.c
+++ b/drivers/staging/media/imx/imx8mq-mipi-csi2.c
@@ -693,7 +693,7 @@ static int imx8mq_mipi_csi_async_register(struct csi_state *state)
  * Suspend/resume
  */
 
-static int imx8mq_mipi_csi_pm_suspend(struct device *dev, bool runtime)
+static int imx8mq_mipi_csi_pm_suspend(struct device *dev)
 {
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct csi_state *state = mipi_sd_to_csi2_state(sd);
@@ -705,36 +705,21 @@ static int imx8mq_mipi_csi_pm_suspend(struct device *dev, bool runtime)
 		imx8mq_mipi_csi_stop_stream(state);
 		imx8mq_mipi_csi_clk_disable(state);
 		state->state &= ~ST_POWERED;
-		if (!runtime)
-			state->state |= ST_SUSPENDED;
 	}
 
 	mutex_unlock(&state->lock);
 
-	ret = icc_set_bw(state->icc_path, 0, 0);
-	if (ret)
-		dev_err(dev, "icc_set_bw failed with %d\n", ret);
-
 	return ret ? -EAGAIN : 0;
 }
 
-static int imx8mq_mipi_csi_pm_resume(struct device *dev, bool runtime)
+static int imx8mq_mipi_csi_pm_resume(struct device *dev)
 {
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct csi_state *state = mipi_sd_to_csi2_state(sd);
 	int ret = 0;
 
-	ret = icc_set_bw(state->icc_path, 0, state->icc_path_bw);
-	if (ret) {
-		dev_err(dev, "icc_set_bw failed with %d\n", ret);
-		return ret;
-	}
-
 	mutex_lock(&state->lock);
 
-	if (!runtime && !(state->state & ST_SUSPENDED))
-		goto unlock;
-
 	if (!(state->state & ST_POWERED)) {
 		state->state |= ST_POWERED;
 		ret = imx8mq_mipi_csi_clk_enable(state);
@@ -755,22 +740,60 @@ static int imx8mq_mipi_csi_pm_resume(struct device *dev, bool runtime)
 
 static int __maybe_unused imx8mq_mipi_csi_suspend(struct device *dev)
 {
-	return imx8mq_mipi_csi_pm_suspend(dev, false);
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct csi_state *state = mipi_sd_to_csi2_state(sd);
+	int ret;
+
+	ret = imx8mq_mipi_csi_pm_suspend(dev);
+	if (ret)
+		return ret;
+
+	state->state |= ST_SUSPENDED;
+
+	return ret;
 }
 
 static int __maybe_unused imx8mq_mipi_csi_resume(struct device *dev)
 {
-	return imx8mq_mipi_csi_pm_resume(dev, false);
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct csi_state *state = mipi_sd_to_csi2_state(sd);
+
+	if (!(state->state & ST_SUSPENDED))
+		return 0;
+
+	return imx8mq_mipi_csi_pm_resume(dev);
 }
 
 static int __maybe_unused imx8mq_mipi_csi_runtime_suspend(struct device *dev)
 {
-	return imx8mq_mipi_csi_pm_suspend(dev, true);
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct csi_state *state = mipi_sd_to_csi2_state(sd);
+	int ret;
+
+	ret = imx8mq_mipi_csi_pm_suspend(dev);
+	if (ret)
+		return ret;
+
+	ret = icc_set_bw(state->icc_path, 0, 0);
+	if (ret)
+		dev_err(dev, "icc_set_bw failed with %d\n", ret);
+
+	return ret;
 }
 
 static int __maybe_unused imx8mq_mipi_csi_runtime_resume(struct device *dev)
 {
-	return imx8mq_mipi_csi_pm_resume(dev, true);
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct csi_state *state = mipi_sd_to_csi2_state(sd);
+	int ret;
+
+	ret = icc_set_bw(state->icc_path, 0, state->icc_path_bw);
+	if (ret) {
+		dev_err(dev, "icc_set_bw failed with %d\n", ret);
+		return ret;
+	}
+
+	return imx8mq_mipi_csi_pm_resume(dev);
 }
 
 static const struct dev_pm_ops imx8mq_mipi_csi_pm_ops = {
@@ -918,7 +941,7 @@ static int imx8mq_mipi_csi_probe(struct platform_device *pdev)
 	/* Enable runtime PM. */
 	pm_runtime_enable(dev);
 	if (!pm_runtime_enabled(dev)) {
-		ret = imx8mq_mipi_csi_pm_resume(dev, true);
+		ret = imx8mq_mipi_csi_runtime_resume(dev);
 		if (ret < 0)
 			goto icc;
 	}
@@ -931,7 +954,7 @@ static int imx8mq_mipi_csi_probe(struct platform_device *pdev)
 
 cleanup:
 	pm_runtime_disable(&pdev->dev);
-	imx8mq_mipi_csi_pm_suspend(&pdev->dev, true);
+	imx8mq_mipi_csi_runtime_suspend(&pdev->dev);
 
 	media_entity_cleanup(&state->sd.entity);
 	v4l2_async_nf_unregister(&state->notifier);
@@ -955,7 +978,7 @@ static int imx8mq_mipi_csi_remove(struct platform_device *pdev)
 	v4l2_async_unregister_subdev(&state->sd);
 
 	pm_runtime_disable(&pdev->dev);
-	imx8mq_mipi_csi_pm_suspend(&pdev->dev, true);
+	imx8mq_mipi_csi_runtime_suspend(&pdev->dev);
 	media_entity_cleanup(&state->sd.entity);
 	mutex_destroy(&state->lock);
 	pm_runtime_set_suspended(&pdev->dev);
-- 
2.34.1




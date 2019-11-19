Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD8781017B2
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbfKSFkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:40:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730393AbfKSFkX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:40:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 815ED21783;
        Tue, 19 Nov 2019 05:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142022;
        bh=oNMpK4uCT6FqDAbQaOrbyYV5qSgpW9C8QAqC4iyX9LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGjgvlP0caNDgRTbOwhp6a6Ejz0BDtwAslkdAAzFd7AR3Kq2czry2CVk8EiNkUSB9
         /9M/f5FbvXv57jsMzNy6t3cO++BjB9hPhWFsECXPWssU/xDiKJo3nYCPbXDux2k4ZO
         IJ+Tk9ttcc4A6ebVznivXhepU6tri2snFh+SyfVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 354/422] silmbus: ngd: register controller after power up.
Date:   Tue, 19 Nov 2019 06:19:11 +0100
Message-Id: <20191119051421.958702318@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 94fe5f2b45c4108885e4b71f6b181068632ec904 ]

Register slimbus controller only after finishing powerup sequnce so that we
do not endup in situation where core starts sending transactions before
the controller is ready.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index e587be9064e74..d72f8eed2e8b7 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1234,8 +1234,17 @@ static int qcom_slim_ngd_enable(struct qcom_slim_ngd_ctrl *ctrl, bool enable)
 			pm_runtime_resume(ctrl->dev);
 		pm_runtime_mark_last_busy(ctrl->dev);
 		pm_runtime_put(ctrl->dev);
+
+		ret = slim_register_controller(&ctrl->ctrl);
+		if (ret) {
+			dev_err(ctrl->dev, "error adding slim controller\n");
+			return ret;
+		}
+
+		dev_info(ctrl->dev, "SLIM controller Registered\n");
 	} else {
 		qcom_slim_qmi_exit(ctrl);
+		slim_unregister_controller(&ctrl->ctrl);
 	}
 
 	return 0;
@@ -1360,11 +1369,6 @@ static int qcom_slim_ngd_probe(struct platform_device *pdev)
 	int ret;
 
 	ctrl->ctrl.dev = dev;
-	ret = slim_register_controller(&ctrl->ctrl);
-	if (ret) {
-		dev_err(dev, "error adding slim controller\n");
-		return ret;
-	}
 
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_set_autosuspend_delay(dev, QCOM_SLIM_NGD_AUTOSUSPEND);
@@ -1374,7 +1378,7 @@ static int qcom_slim_ngd_probe(struct platform_device *pdev)
 	ret = qcom_slim_ngd_qmi_svc_event_init(ctrl);
 	if (ret) {
 		dev_err(&pdev->dev, "QMI service registration failed:%d", ret);
-		goto err;
+		return ret;
 	}
 
 	INIT_WORK(&ctrl->m_work, qcom_slim_ngd_master_worker);
@@ -1386,8 +1390,6 @@ static int qcom_slim_ngd_probe(struct platform_device *pdev)
 	}
 
 	return 0;
-err:
-	slim_unregister_controller(&ctrl->ctrl);
 wq_err:
 	qcom_slim_ngd_qmi_svc_event_deinit(&ctrl->qmi);
 	if (ctrl->mwq)
@@ -1460,7 +1462,7 @@ static int qcom_slim_ngd_remove(struct platform_device *pdev)
 	struct qcom_slim_ngd_ctrl *ctrl = platform_get_drvdata(pdev);
 
 	pm_runtime_disable(&pdev->dev);
-	slim_unregister_controller(&ctrl->ctrl);
+	qcom_slim_ngd_enable(ctrl, false);
 	qcom_slim_ngd_exit_dma(ctrl);
 	qcom_slim_ngd_qmi_svc_event_deinit(&ctrl->qmi);
 	if (ctrl->mwq)
-- 
2.20.1




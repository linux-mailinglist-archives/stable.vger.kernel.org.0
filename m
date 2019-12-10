Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3EA11966A
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbfLJVZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:25:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729241AbfLJVZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:25:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A002D208C3;
        Tue, 10 Dec 2019 21:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013118;
        bh=ceSWH49Z1fn5M+WPTJEUWplL1sTDSb98CQd+itGpjPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMzdKMSeHQ1hgd71UYyNleEFSMROAceg/3CYWM2VruuMuWX/+hpEtGStNVWfxCfVw
         l4cvVgc3ur5kFeQNCDdts2qfHzNOTGQQNmExKpdpWBaFWZH2p7v1VK0uy+J3/wqs6n
         R6OWHX7Ii5FSU41bT8kmyBJ9XrINsXUqG27jSZlQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dariusz Marcinkiewicz <darekm@google.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 005/292] drm: exynos: exynos_hdmi: use cec_notifier_conn_(un)register
Date:   Tue, 10 Dec 2019 16:20:24 -0500
Message-Id: <20191210212511.11392-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210212511.11392-1-sashal@kernel.org>
References: <20191210212511.11392-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dariusz Marcinkiewicz <darekm@google.com>

[ Upstream commit 71137bfd98973efb7b762ba168df077b87b34311 ]

Use the new cec_notifier_conn_(un)register() functions to
(un)register the notifier for the HDMI connector, and fill in
the cec_connector_info.

Changes since v7:
	- err_runtime_disable -> err_rpm_disable
Changes since v2:
	- removed unnecessary call to invalidate phys address before
	deregistering the notifier,
	- use cec_notifier_phys_addr_invalidate instead of setting
	invalid address on a notifier.

Signed-off-by: Dariusz Marcinkiewicz <darekm@google.com>
Tested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[hverkuil-cisco@xs4all.nl: use 'if (!hdata->notifier)' instead of '== NULL']
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Link: https://patchwork.freedesktop.org/patch/msgid/20190828123415.139441-1-darekm@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c | 31 ++++++++++++++++------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index bc1565f1822ab..09aa73c0f2add 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -852,6 +852,10 @@ static enum drm_connector_status hdmi_detect(struct drm_connector *connector,
 
 static void hdmi_connector_destroy(struct drm_connector *connector)
 {
+	struct hdmi_context *hdata = connector_to_hdmi(connector);
+
+	cec_notifier_conn_unregister(hdata->notifier);
+
 	drm_connector_unregister(connector);
 	drm_connector_cleanup(connector);
 }
@@ -935,6 +939,7 @@ static int hdmi_create_connector(struct drm_encoder *encoder)
 {
 	struct hdmi_context *hdata = encoder_to_hdmi(encoder);
 	struct drm_connector *connector = &hdata->connector;
+	struct cec_connector_info conn_info;
 	int ret;
 
 	connector->interlace_allowed = true;
@@ -957,6 +962,15 @@ static int hdmi_create_connector(struct drm_encoder *encoder)
 			DRM_DEV_ERROR(hdata->dev, "Failed to attach bridge\n");
 	}
 
+	cec_fill_conn_info_from_drm(&conn_info, connector);
+
+	hdata->notifier = cec_notifier_conn_register(hdata->dev, NULL,
+						     &conn_info);
+	if (!hdata->notifier) {
+		ret = -ENOMEM;
+		DRM_DEV_ERROR(hdata->dev, "Failed to allocate CEC notifier\n");
+	}
+
 	return ret;
 }
 
@@ -1528,8 +1542,8 @@ static void hdmi_disable(struct drm_encoder *encoder)
 		 */
 		mutex_unlock(&hdata->mutex);
 		cancel_delayed_work(&hdata->hotplug_work);
-		cec_notifier_set_phys_addr(hdata->notifier,
-					   CEC_PHYS_ADDR_INVALID);
+		if (hdata->notifier)
+			cec_notifier_phys_addr_invalidate(hdata->notifier);
 		return;
 	}
 
@@ -2006,12 +2020,6 @@ static int hdmi_probe(struct platform_device *pdev)
 		}
 	}
 
-	hdata->notifier = cec_notifier_get(&pdev->dev);
-	if (hdata->notifier == NULL) {
-		ret = -ENOMEM;
-		goto err_hdmiphy;
-	}
-
 	pm_runtime_enable(dev);
 
 	audio_infoframe = &hdata->audio.infoframe;
@@ -2023,7 +2031,7 @@ static int hdmi_probe(struct platform_device *pdev)
 
 	ret = hdmi_register_audio_device(hdata);
 	if (ret)
-		goto err_notifier_put;
+		goto err_rpm_disable;
 
 	ret = component_add(&pdev->dev, &hdmi_component_ops);
 	if (ret)
@@ -2034,8 +2042,7 @@ static int hdmi_probe(struct platform_device *pdev)
 err_unregister_audio:
 	platform_device_unregister(hdata->audio.pdev);
 
-err_notifier_put:
-	cec_notifier_put(hdata->notifier);
+err_rpm_disable:
 	pm_runtime_disable(dev);
 
 err_hdmiphy:
@@ -2054,12 +2061,10 @@ static int hdmi_remove(struct platform_device *pdev)
 	struct hdmi_context *hdata = platform_get_drvdata(pdev);
 
 	cancel_delayed_work_sync(&hdata->hotplug_work);
-	cec_notifier_set_phys_addr(hdata->notifier, CEC_PHYS_ADDR_INVALID);
 
 	component_del(&pdev->dev, &hdmi_component_ops);
 	platform_device_unregister(hdata->audio.pdev);
 
-	cec_notifier_put(hdata->notifier);
 	pm_runtime_disable(&pdev->dev);
 
 	if (!IS_ERR(hdata->reg_hdmi_en))
-- 
2.20.1


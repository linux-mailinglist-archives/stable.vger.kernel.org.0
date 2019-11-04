Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598DFEEC79
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388574AbfKDV5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:57:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388568AbfKDV5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:57:23 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46990214D8;
        Mon,  4 Nov 2019 21:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904641;
        bh=2K3Nhn17oyQlttcoEwq3Au9rsNdUXZ/WhlXS/lb70BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmEiOEMR4EPmST5Pnylvv3fW6hzK2XJ30TADNB7n0MR7pSVOyxZXeSbTa0OW3djKA
         QZiEYENmtN8T0Q23KeyssihVVnq6Ez6shDNdPLFor5tGTt0I72Y11pfmqecx+I6CbF
         KoAZK0wMcMhwGSrXReUQT7kV7MtpuTrTFT6eaA64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeykumar Sankaran <jsanka@codeaurora.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 019/149] drm/msm/dpu: handle failures while initializing displays
Date:   Mon,  4 Nov 2019 22:43:32 +0100
Message-Id: <20191104212136.271271541@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeykumar Sankaran <jsanka@codeaurora.org>

[ Upstream commit a802ee99c448ca0496fa307f3e46b834ae2a46a3 ]

Bail out KMS hw init on display initialization failures with
proper error logging.

changes in v3:
    - introduced in the series
changes in v4:
    - avoid duplicate return on errors (Sean Paul)
    - avoid spamming errors on failures (Jordon Crouse)

Signed-off-by: Jeykumar Sankaran <jsanka@codeaurora.org>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c | 31 ++++++++++++++-----------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
index 74cc204b07e80..2d9b7b5fb49c8 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -442,35 +442,38 @@ static void dpu_kms_wait_for_commit_done(struct msm_kms *kms,
 	}
 }
 
-static void _dpu_kms_initialize_dsi(struct drm_device *dev,
+static int _dpu_kms_initialize_dsi(struct drm_device *dev,
 				    struct msm_drm_private *priv,
 				    struct dpu_kms *dpu_kms)
 {
 	struct drm_encoder *encoder = NULL;
-	int i, rc;
+	int i, rc = 0;
+
+	if (!(priv->dsi[0] || priv->dsi[1]))
+		return rc;
 
 	/*TODO: Support two independent DSI connectors */
 	encoder = dpu_encoder_init(dev, DRM_MODE_ENCODER_DSI);
-	if (IS_ERR_OR_NULL(encoder)) {
+	if (IS_ERR(encoder)) {
 		DPU_ERROR("encoder init failed for dsi display\n");
-		return;
+		return PTR_ERR(encoder);
 	}
 
 	priv->encoders[priv->num_encoders++] = encoder;
 
 	for (i = 0; i < ARRAY_SIZE(priv->dsi); i++) {
-		if (!priv->dsi[i]) {
-			DPU_DEBUG("invalid msm_dsi for ctrl %d\n", i);
-			return;
-		}
+		if (!priv->dsi[i])
+			continue;
 
 		rc = msm_dsi_modeset_init(priv->dsi[i], dev, encoder);
 		if (rc) {
 			DPU_ERROR("modeset_init failed for dsi[%d], rc = %d\n",
 				i, rc);
-			continue;
+			break;
 		}
 	}
+
+	return rc;
 }
 
 /**
@@ -481,16 +484,16 @@ static void _dpu_kms_initialize_dsi(struct drm_device *dev,
  * @dpu_kms:    Pointer to dpu kms structure
  * Returns:     Zero on success
  */
-static void _dpu_kms_setup_displays(struct drm_device *dev,
+static int _dpu_kms_setup_displays(struct drm_device *dev,
 				    struct msm_drm_private *priv,
 				    struct dpu_kms *dpu_kms)
 {
-	_dpu_kms_initialize_dsi(dev, priv, dpu_kms);
-
 	/**
 	 * Extend this function to initialize other
 	 * types of displays
 	 */
+
+	return _dpu_kms_initialize_dsi(dev, priv, dpu_kms);
 }
 
 static void _dpu_kms_drm_obj_destroy(struct dpu_kms *dpu_kms)
@@ -552,7 +555,9 @@ static int _dpu_kms_drm_obj_init(struct dpu_kms *dpu_kms)
 	 * Create encoder and query display drivers to create
 	 * bridges and connectors
 	 */
-	_dpu_kms_setup_displays(dev, priv, dpu_kms);
+	ret = _dpu_kms_setup_displays(dev, priv, dpu_kms);
+	if (ret)
+		goto fail;
 
 	max_crtc_count = min(catalog->mixer_count, priv->num_encoders);
 
-- 
2.20.1




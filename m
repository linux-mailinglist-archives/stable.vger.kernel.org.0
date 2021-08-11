Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE5F3E968D
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 19:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhHKRId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 13:08:33 -0400
Received: from ixit.cz ([94.230.151.217]:49082 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhHKRId (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Aug 2021 13:08:33 -0400
Received: from newone.lan (ixit.cz [94.230.151.217])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id E407824A25;
        Wed, 11 Aug 2021 19:08:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1628701687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RTynIOCegowRvakGso+RzQODzzmcY92VKZvDOOfU8MY=;
        b=23/BInf8vB5I5xiyTTIt4tNDQeVudHEhmPTbOtfJ8S6dzuPoDo3zUCL/zHU0ZWMT5Sl0cp
        aj5AIxgQGDH9PHkcsN1cuWtRWCkTu157wVyAjECxw/M3F4fYpsAJoeLStCTj6Zyi3w6+rI
        vW0WqDEX6WoeHs0zSn4xbtRfLQnGNTA=
From:   David Heidelberg <david@ixit.cz>
To:     Jonathan Marek <jonathan@marek.ca>,
        robdclark <robdclark@chromium.org>
Cc:     linux-arm-msm@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        stable@vger.kernel.org
Subject: [PATCH] drm/msi/mdp4: populate priv->kms in mdp4_kms_init
Date:   Wed, 11 Aug 2021 19:06:31 +0200
Message-Id: <20210811170631.39296-1-david@ixit.cz>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Without this fix boot throws NULL ptr exception at msm_dsi_manager_setup_encoder
on devices like Nexus 7 2013 (MDP4 v4.4).

Fixes: 03436e3ec69c ("drm/msm/dsi: Move setup_encoder to modeset_init")

Cc: <stable@vger.kernel.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
---
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
index 1f12bccee2b8..cdcaf470f148 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
@@ -399,6 +399,7 @@ struct msm_kms *mdp4_kms_init(struct drm_device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev->dev);
 	struct mdp4_platform_config *config = mdp4_get_config(pdev);
+	struct msm_drm_private *priv = dev->dev_private;
 	struct mdp4_kms *mdp4_kms;
 	struct msm_kms *kms = NULL;
 	struct msm_gem_address_space *aspace;
@@ -418,7 +419,8 @@ struct msm_kms *mdp4_kms_init(struct drm_device *dev)
 		goto fail;
 	}
 
-	kms = &mdp4_kms->base.base;
+	priv->kms = &mdp4_kms->base.base;
+	kms = priv->kms;
 
 	mdp4_kms->dev = dev;
 
-- 
2.30.2


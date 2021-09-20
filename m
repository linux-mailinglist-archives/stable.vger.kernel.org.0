Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA5F4122E8
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377435AbhITSS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1359525AbhITSQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:16:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F62161A87;
        Mon, 20 Sep 2021 17:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158521;
        bh=Qs+rCZgSbeIX30we6YkEYJZERXgavSYfK3BMtfypwMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTWHOGdfPubqLGuCnlj12jshzGdx4IoS4xWuFpxf1ZlA+W2Wz/ofgUdTWuAc3XMcg
         zcAB0KmqDBq3MIGONQQ7c2ZOyYSz8LqEqJEUWfKsQYpfjB0R9GjWQQgRtnw1qh1eNw
         9bqq/llXASqrpOLvdR64yCYOuDeI0/7tU9YBygl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.4 187/260] drm/msi/mdp4: populate priv->kms in mdp4_kms_init
Date:   Mon, 20 Sep 2021 18:43:25 +0200
Message-Id: <20210920163937.468950314@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Heidelberg <david@ixit.cz>

commit cb0927ab80d224c9074f53d1a55b087d12ec5a85 upstream.

Without this fix boot throws NULL ptr exception at msm_dsi_manager_setup_encoder
on devices like Nexus 7 2013 (MDP4 v4.4).

Fixes: 03436e3ec69c ("drm/msm/dsi: Move setup_encoder to modeset_init")

Cc: <stable@vger.kernel.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://lore.kernel.org/r/20210811170631.39296-1-david@ixit.cz
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
@@ -405,6 +405,7 @@ struct msm_kms *mdp4_kms_init(struct drm
 {
 	struct platform_device *pdev = to_platform_device(dev->dev);
 	struct mdp4_platform_config *config = mdp4_get_config(pdev);
+	struct msm_drm_private *priv = dev->dev_private;
 	struct mdp4_kms *mdp4_kms;
 	struct msm_kms *kms = NULL;
 	struct msm_gem_address_space *aspace;
@@ -419,7 +420,8 @@ struct msm_kms *mdp4_kms_init(struct drm
 
 	mdp_kms_init(&mdp4_kms->base, &kms_funcs);
 
-	kms = &mdp4_kms->base.base;
+	priv->kms = &mdp4_kms->base.base;
+	kms = priv->kms;
 
 	mdp4_kms->dev = dev;
 



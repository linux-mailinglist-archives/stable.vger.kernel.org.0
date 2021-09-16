Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529BB40E108
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241265AbhIPQ0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241262AbhIPQYu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:24:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1C17613D5;
        Thu, 16 Sep 2021 16:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808988;
        bh=lKfQLl80sJAtRksVLfOVG9Ax5WTP8K6CA8bju2R/rjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d9BGWFrLqMNc+0+KSgj9gZ3jFjpk9IGkwkM0fsos0SU/Diwb/6go7uN/aityEARtZ
         dcDXcitMyN1tyNetcn0BfHbwYIUmG/uyLWWxp/yeBp3aXN/+3AJOsHpI7ZXpNdxUtb
         HzwuM5P6V2kx0y5ohVPnOt6dsBUuM34GVk4bj8hA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.10 297/306] drm/msi/mdp4: populate priv->kms in mdp4_kms_init
Date:   Thu, 16 Sep 2021 18:00:42 +0200
Message-Id: <20210916155804.220512364@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
@@ -397,6 +397,7 @@ struct msm_kms *mdp4_kms_init(struct drm
 {
 	struct platform_device *pdev = to_platform_device(dev->dev);
 	struct mdp4_platform_config *config = mdp4_get_config(pdev);
+	struct msm_drm_private *priv = dev->dev_private;
 	struct mdp4_kms *mdp4_kms;
 	struct msm_kms *kms = NULL;
 	struct msm_gem_address_space *aspace;
@@ -412,7 +413,8 @@ struct msm_kms *mdp4_kms_init(struct drm
 
 	mdp_kms_init(&mdp4_kms->base, &kms_funcs);
 
-	kms = &mdp4_kms->base.base;
+	priv->kms = &mdp4_kms->base.base;
+	kms = priv->kms;
 
 	mdp4_kms->dev = dev;
 



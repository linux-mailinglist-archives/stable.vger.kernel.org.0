Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5969B3CA85E
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241838AbhGOTAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242373AbhGOS7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:59:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA2D3613CA;
        Thu, 15 Jul 2021 18:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375403;
        bh=MbgXbctIS4MN5Fco/wMzsI2RvzamO0gMcpHWVPZjc5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c8gih07Eb4k9TOoEj58YbjeEsSG6cpAUHUKpp5A3WvcO4qycxAl7DY7Xc369V/m4y
         FuUvHDF5Ko5mKBCC7UTQrYJqeAx5umSSetO+W0SewUxJRMccHrnubGYU/2VZKINViT
         gNF7bsSwOow3pt9ysXpNIUQSun3YKNSAqF23+KEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 030/242] drm/vc4: hdmi: Fix PM reference leak in vc4_hdmi_encoder_pre_crtc_co()
Date:   Thu, 15 Jul 2021 20:36:32 +0200
Message-Id: <20210715182557.219795791@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 5e4322a8b266bc9f5ee7ea4895f661c01dbd7cb3 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/1621840854-105978-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index e94730beb15b..23e7cfd987bb 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -745,7 +745,7 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 	unsigned long pixel_rate, hsm_rate;
 	int ret;
 
-	ret = pm_runtime_get_sync(&vc4_hdmi->pdev->dev);
+	ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
 	if (ret < 0) {
 		DRM_ERROR("Failed to retain power domain: %d\n", ret);
 		return;
-- 
2.30.2




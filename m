Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93253BD108
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbhGFLiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236085AbhGFLcM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:32:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9688761C84;
        Tue,  6 Jul 2021 11:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570564;
        bh=HpFaar7DaVS/qmS2yM1k2WY/BzgjrB04GP/oePOaOH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5Q+X/gMvbGCma3aXtslOBxF0cF0MlkiOss4edCwg19ars/CwT1pLbzUdOJuMd/Vy
         fP9iHs81vlPXtvV+42pAAjhDNJIxkqdofF/ATR2leigqceG0Ynh4Vcsffyv12NcBP4
         Aul6y4vWKV3bo3tzrSnPqLb4Gl9AV4g0MP/bYfEUGyVQoY+YZyTckDobgM7JT9lJ98
         9RlG7n9Oe0Yh6rvI1LJ6uh8uQEv9BsERy+lUmBXPp7RSwcaQd2b66RudUIqvI9cFbZ
         UpINe2mYbRyL0dH/WBKjo5NUZAnjtkhqAkXokiztmAoHt/oYTT35oaRGLiNwXAw+RZ
         +i7m/NpL5jl9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 031/137] drm/vc4: hdmi: Fix PM reference leak in vc4_hdmi_encoder_pre_crtc_co()
Date:   Tue,  6 Jul 2021 07:20:17 -0400
Message-Id: <20210706112203.2062605-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 88a8cb840cd5..22e0757cce95 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -627,7 +627,7 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder)
 	unsigned long pixel_rate, hsm_rate;
 	int ret;
 
-	ret = pm_runtime_get_sync(&vc4_hdmi->pdev->dev);
+	ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
 	if (ret < 0) {
 		DRM_ERROR("Failed to retain power domain: %d\n", ret);
 		return;
-- 
2.30.2


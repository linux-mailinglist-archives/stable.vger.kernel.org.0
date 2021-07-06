Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE773BCEFD
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbhGFL1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234912AbhGFLZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ACA461C78;
        Tue,  6 Jul 2021 11:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570354;
        bh=dt0lmIzopvOs6fP5lPadlUl/1tb7ZOp1dDHOIVae8BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfMyvQu3YbjIWd6VHyFtqx+X7UYFSTHoYTYouv2v3/Zre2plxkxvVJhoTzMDmYATy
         hfDQduE5m47Dlon4e47RNDazw42fW1cS3utWDbwkiDgaSXccCv3xEkpT46SsiV/Z2o
         tq88v4WeN6x97ae4nOHGyGB7EL9YAHBUBtuPTPVj6MO5cVKcHyypgMv3qBXUvKtc79
         2TF4MBILX+NnQyMdG3I5vz4MWRCvmYU6inpXh5JtDiMGUXKlpA6MUWoaCHPUg06mVG
         3rvWghbjBYG4oyhlWuC5SHxIEdcy7JFZyDXAMMR/68NHysqRxpGbynlVj7bCuUh+0G
         9Q7qyV2Uq/qvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 035/160] drm/vc4: hdmi: Fix PM reference leak in vc4_hdmi_encoder_pre_crtc_co()
Date:   Tue,  6 Jul 2021 07:16:21 -0400
Message-Id: <20210706111827.2060499-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 8106b5634fe1..d1c9819ea9f9 100644
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


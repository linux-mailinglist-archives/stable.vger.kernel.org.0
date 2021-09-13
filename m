Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9922F4094DD
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345314AbhIMOgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345773AbhIMOdQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:33:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C1CF61BD0;
        Mon, 13 Sep 2021 13:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541150;
        bh=+jozNEgeDozdsFYBZqGwW+s/aqVLJxgjBKEITXl2c5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDw7hquoKxdZnpc8xhixyNdpqFRXK+o7cH08Ynxg9niv1DBTbbFii0QHHgSUJ0Xbo
         T82JaBL/8mQ0odOHjhfqr5oVgUddQYWM+itkoVI3mQkBM2XoQo6p7BB+Y0+jEAK7f6
         VoflBsdRh9gfFDMGvkzycJcU1ZL8vhqCGsyN+/No=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 184/334] drm/msm/mdp4: refactor HW revision detection into read_mdp_hw_revision
Date:   Mon, 13 Sep 2021 15:13:58 +0200
Message-Id: <20210913131119.566794132@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 4d319afe666b0fc9a9855ba9bdf9ae3710ecf431 ]

Inspired by MDP5 code.
Also use DRM_DEV_INFO for MDP version as MDP5 does.

Cosmetic change: uint32_t -> u32 - checkpatch suggestion.

Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://lore.kernel.org/r/20210705231641.315804-1-david@ixit.cz
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c | 27 ++++++++++++++++--------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
index 4a5b518288b0..3a7a01d801aa 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
@@ -19,20 +19,13 @@ static int mdp4_hw_init(struct msm_kms *kms)
 {
 	struct mdp4_kms *mdp4_kms = to_mdp4_kms(to_mdp_kms(kms));
 	struct drm_device *dev = mdp4_kms->dev;
-	uint32_t version, major, minor, dmap_cfg, vg_cfg;
+	u32 major, minor, dmap_cfg, vg_cfg;
 	unsigned long clk;
 	int ret = 0;
 
 	pm_runtime_get_sync(dev->dev);
 
-	mdp4_enable(mdp4_kms);
-	version = mdp4_read(mdp4_kms, REG_MDP4_VERSION);
-	mdp4_disable(mdp4_kms);
-
-	major = FIELD(version, MDP4_VERSION_MAJOR);
-	minor = FIELD(version, MDP4_VERSION_MINOR);
-
-	DBG("found MDP4 version v%d.%d", major, minor);
+	read_mdp_hw_revision(mdp4_kms, &major, &minor);
 
 	if (major != 4) {
 		DRM_DEV_ERROR(dev->dev, "unexpected MDP version: v%d.%d\n",
@@ -411,6 +404,22 @@ fail:
 	return ret;
 }
 
+static void read_mdp_hw_revision(struct mdp4_kms *mdp4_kms,
+				 u32 *major, u32 *minor)
+{
+	struct drm_device *dev = mdp4_kms->dev;
+	u32 version;
+
+	mdp4_enable(mdp4_kms);
+	version = mdp4_read(mdp4_kms, REG_MDP4_VERSION);
+	mdp4_disable(mdp4_kms);
+
+	*major = FIELD(version, MDP4_VERSION_MAJOR);
+	*minor = FIELD(version, MDP4_VERSION_MINOR);
+
+	DRM_DEV_INFO(dev->dev, "MDP4 version v%d.%d", *major, *minor);
+}
+
 struct msm_kms *mdp4_kms_init(struct drm_device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev->dev);
-- 
2.30.2




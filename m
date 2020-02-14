Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49A3315ECE0
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390747AbgBNRaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:30:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390726AbgBNQHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:07:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 035832067D;
        Fri, 14 Feb 2020 16:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696458;
        bh=fnx7SJY0GVFCyYRf53hfDuerPrwVmGYhI3JvugVoLLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLOwjpdfHF7/xpWJya84oDKURXrNR1RVpOUNVnnhSmhbE36Q1AisPvkA9XE9/MyiR
         5+laB7HTARYErJI064hu7uvDBUaHdSXCiMKY730qEgY5ABhyb6vtRzjVUFpPpc6gOt
         4or7blyzk3egUFwZwNnG6rGNypc3cxqrEumma05k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongqiang Niu <yongqiang.niu@mediatek.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>, CK Hu <ck.hu@mediatek.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 270/459] drm/mediatek: Add gamma property according to hardware capability
Date:   Fri, 14 Feb 2020 10:58:40 -0500
Message-Id: <20200214160149.11681-270-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongqiang Niu <yongqiang.niu@mediatek.com>

[ Upstream commit 4cebc1de506fa753301266a5a23bb21bca52ad3a ]

If there is no gamma function in the crtc
display path, don't add gamma property
for crtc

Fixes: 2f3f4dda747c ("drm/mediatek: Add gamma correction.")
Signed-off-by: Yongqiang Niu <yongqiang.niu@mediatek.com>
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Signed-off-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index 0b3d284d19569..e6c049f4f08bb 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -537,6 +537,7 @@ int mtk_drm_crtc_create(struct drm_device *drm_dev,
 	int pipe = priv->num_pipes;
 	int ret;
 	int i;
+	uint gamma_lut_size = 0;
 
 	if (!path)
 		return 0;
@@ -587,6 +588,9 @@ int mtk_drm_crtc_create(struct drm_device *drm_dev,
 		}
 
 		mtk_crtc->ddp_comp[i] = comp;
+
+		if (comp->funcs && comp->funcs->gamma_set)
+			gamma_lut_size = MTK_LUT_SIZE;
 	}
 
 	mtk_crtc->layer_nr = mtk_ddp_comp_layer_nr(mtk_crtc->ddp_comp[0]);
@@ -609,8 +613,10 @@ int mtk_drm_crtc_create(struct drm_device *drm_dev,
 				NULL, pipe);
 	if (ret < 0)
 		return ret;
-	drm_mode_crtc_set_gamma_size(&mtk_crtc->base, MTK_LUT_SIZE);
-	drm_crtc_enable_color_mgmt(&mtk_crtc->base, 0, false, MTK_LUT_SIZE);
+
+	if (gamma_lut_size)
+		drm_mode_crtc_set_gamma_size(&mtk_crtc->base, gamma_lut_size);
+	drm_crtc_enable_color_mgmt(&mtk_crtc->base, 0, false, gamma_lut_size);
 	priv->num_pipes++;
 
 	return 0;
-- 
2.20.1


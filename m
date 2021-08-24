Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3F03F63D2
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhHXQ6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:58:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235233AbhHXQ5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22D376140A;
        Tue, 24 Aug 2021 16:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824216;
        bh=3oKcd3whPpj8OtABgp78YnwXXbD1aeSROsTPtwZYaUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7M5s2NIyRrq/1qN/O6xH6vl/sw/sWZstWeaJqzjjPwp8di2E2BQX0td/8EGjrUrS
         KxBoZQvZUOFPr8YWDp3GIrjvXzYsdxI3fM4rh5h4VpEBZAr5bBDAi48Roc/Uaypl3w
         8BbsDAMmWYgTukMeTn12KK8e+YU85AfIAXPL5QTkpq9bMKsSYMCLWnYgGBjsafCs5q
         devrEh7x4tprrtW4Sr1OO30J2+QJv5ymuUSVsypKm0Unp+13cAzM+907jA9hxhe3MO
         0cQgg/RpsuqaqcbqzrR5YAl1m5F4ignXUpsOQ489q1wbtQTwcIc0/hM3J+j9nXvu2V
         rqrPt9ObrOwrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "jason-jh.lin" <jason-jh.lin@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 049/127] drm/mediatek: Add component_del in OVL and COLOR remove function
Date:   Tue, 24 Aug 2021 12:54:49 -0400
Message-Id: <20210824165607.709387-50-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "jason-jh.lin" <jason-jh.lin@mediatek.com>

[ Upstream commit da4d4517ba70216799e3eb3b9bd71aa9dca065da ]

Add component_del in OVL and COLOR remove function.

Fixes: ff1395609e20 ("drm/mediatek: Move mtk_ddp_comp_init() from sub driver to DRM driver")
Signed-off-by: jason-jh.lin <jason-jh.lin@mediatek.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_disp_color.c | 2 ++
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c   | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_disp_color.c b/drivers/gpu/drm/mediatek/mtk_disp_color.c
index 63f411ab393b..bcb470caf009 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_color.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_color.c
@@ -134,6 +134,8 @@ static int mtk_disp_color_probe(struct platform_device *pdev)
 
 static int mtk_disp_color_remove(struct platform_device *pdev)
 {
+	component_del(&pdev->dev, &mtk_disp_color_component_ops);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
index 961f87f8d4d1..32a2922bbe5f 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
@@ -424,6 +424,8 @@ static int mtk_disp_ovl_probe(struct platform_device *pdev)
 
 static int mtk_disp_ovl_remove(struct platform_device *pdev)
 {
+	component_del(&pdev->dev, &mtk_disp_ovl_component_ops);
+
 	return 0;
 }
 
-- 
2.30.2


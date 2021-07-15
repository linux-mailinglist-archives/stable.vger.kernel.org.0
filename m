Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3963CA5B4
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhGOSoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230410AbhGOSoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:44:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16F8D613D0;
        Thu, 15 Jul 2021 18:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374467;
        bh=dSmWd6JDaIXsyNmO6nukxpLK2YjQpLaYW/+Aqz8eNic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rILZona6aAozAZBmjVf3kmYOFff3ebPVNzzhUw3raYnwjUB4d2YflRdkGIqxcRWPJ
         QPX8Mzx4oG1RMgNTF0muZOJaGkytKrL78yVjG97JXziS0S9Wtw5wvbtdx5qBotGpKY
         T604Lo883lo+6bYcNczGMk5IvE6T2SyJ7HCTRAww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Li <wangli74@huawei.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/122] drm/mediatek: Fix PM reference leak in mtk_crtc_ddp_hw_init()
Date:   Thu, 15 Jul 2021 20:37:39 +0200
Message-Id: <20210715182452.162628326@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Li <wangli74@huawei.com>

[ Upstream commit 69777e6ca396f0a7e1baff40fcad4a9d3d445b7a ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Li <wangli74@huawei.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index f9455f2724d2..f370d41b3d04 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -240,7 +240,7 @@ static int mtk_crtc_ddp_hw_init(struct mtk_drm_crtc *mtk_crtc)
 		drm_connector_list_iter_end(&conn_iter);
 	}
 
-	ret = pm_runtime_get_sync(crtc->dev->dev);
+	ret = pm_runtime_resume_and_get(crtc->dev->dev);
 	if (ret < 0) {
 		DRM_ERROR("Failed to enable power domain: %d\n", ret);
 		return ret;
-- 
2.30.2




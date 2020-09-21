Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D47272CFC
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgIUQg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728976AbgIUQg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:36:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91A03206DC;
        Mon, 21 Sep 2020 16:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706186;
        bh=jdRlnaY6vPBTfETmeS2VOahyt4KO7/6kWOm/9d1nv0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v4J5Qm+bOPy1uteR6YWTRrgFqArHm+ABRWmS4FqPC04/5ZxrpT4aCa2mp8s9TIHpU
         IjuS8WKHXPhMfDcwYlPDye3t9POihLLZKk8FApCQ/Z+YJuflNwgi/cIPuZ6a5aJvaW
         yEI9JsYYUHm6WZx6IEsBNcXlByNfwH11Aku8UUwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 62/70] drm/mediatek: Add exception handing in mtk_drm_probe() if component init fail
Date:   Mon, 21 Sep 2020 18:28:02 +0200
Message-Id: <20200921162037.969480551@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 64c194c00789889b0f9454f583712f079ba414ee ]

mtk_ddp_comp_init() is called in a loop in mtk_drm_probe(), if it
fail, previous successive init component is not proccessed.

Thus uninitialize valid component and put their device if component
init failed.

Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index 2865876079315..0f8f9a784b1be 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -457,8 +457,13 @@ err_pm:
 	pm_runtime_disable(dev);
 err_node:
 	of_node_put(private->mutex_node);
-	for (i = 0; i < DDP_COMPONENT_ID_MAX; i++)
+	for (i = 0; i < DDP_COMPONENT_ID_MAX; i++) {
 		of_node_put(private->comp_node[i]);
+		if (private->ddp_comp[i]) {
+			put_device(private->ddp_comp[i]->larb_dev);
+			private->ddp_comp[i] = NULL;
+		}
+	}
 	return ret;
 }
 
-- 
2.25.1




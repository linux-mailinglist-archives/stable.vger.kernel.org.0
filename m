Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C40272DAB
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgIUQmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729475AbgIUQl5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:41:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D117238E6;
        Mon, 21 Sep 2020 16:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706517;
        bh=Kr/P0uRJ7+elaXq9uS0DpM4PsjGS8tLYatiuM8Tr35A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qO7EZhMSstUkWAjxOC+wXFC1W8IHaJUBcviSUgKdqSeFQaTS3lgxKlsBf0yKIbR7E
         3O1zbvE6XQrY/sCe0uVeksAuMOud6+9ErlqaV2Ej25nwkwW8me4bHayoU6R7dWEP4U
         VVx0ObUCeqtF22Jj3Hfm6hI3kNh7agEOZsljtwCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 35/49] drm/mediatek: Add exception handing in mtk_drm_probe() if component init fail
Date:   Mon, 21 Sep 2020 18:28:19 +0200
Message-Id: <20200921162036.209603125@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
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
index 947bc6d623020..d143217636071 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -600,8 +600,13 @@ err_pm:
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




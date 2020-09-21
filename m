Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42053272E0C
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgIUQpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbgIUQpY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:45:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D16B239A1;
        Mon, 21 Sep 2020 16:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706723;
        bh=+vimZqOlSQC2uw0NxTs6No+vi69RoyYtGBfHuTLw9Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIYl6aYaLMOBdZ2wvXshnsGjhu6+euVnlMjb13LfgMAmDKK6hUMFss0w7tgwudYSb
         YnuYveduGb9raT4LThSRkCWgcTy/srjZBWj7zGT5aOcjW/oeDlFpyMSP6MgaKS226m
         xhA3vIwd2IrIpzXZ/QBf5c7RNuSdVlf3qUWo8D50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 069/118] drm/mediatek: Add exception handing in mtk_drm_probe() if component init fail
Date:   Mon, 21 Sep 2020 18:28:01 +0200
Message-Id: <20200921162039.550035153@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
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
index 040a8f393fe24..7ad0433539f45 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -544,8 +544,13 @@ err_pm:
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3ED2E420B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392464AbgL1PRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:17:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437430AbgL1OEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C859207B6;
        Mon, 28 Dec 2020 14:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164265;
        bh=q9UHE/jghekoTwyREwTZUqFmidHEY1kTRxGvPYx6XgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=negabh9ILN7IEZmJrFIlyunlIUe41I9riEa/S07Vct4r8rrvrmuvVWxEFZK2ZkfX/
         xYVbUKgpbwhP8QZW7HQiy+8K3WpBq3oCHQYM3zhOg2HtY/PtAIApwHcoUveOb2eh39
         +FDE7Zn84yzBV5p69+AeA3zRXHb+NGROibYlPBZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/717] media: mtk-vcodec: add missing put_device() call in mtk_vcodec_init_dec_pm()
Date:   Mon, 28 Dec 2020 13:41:58 +0100
Message-Id: <20201228125026.711782945@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 5d4fa2c50125c9cda9e380d89268757cc5fa743d ]

if of_find_device_by_node() succeed, mtk_vcodec_init_dec_pm() doesn't have
a corresponding put_device(). Thus add jump target to fix the exception
handling for this function implementation.

Fixes: 590577a4e525 ("[media] vcodec: mediatek: Add Mediatek V4L2 Video Decoder Driver")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/mtk-vcodec/mtk_vcodec_dec_pm.c    | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
index 36dfe3fc056a4..f6a6b42865fbd 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
@@ -47,11 +47,14 @@ int mtk_vcodec_init_dec_pm(struct mtk_vcodec_dev *mtkdev)
 		dec_clk->clk_info = devm_kcalloc(&pdev->dev,
 			dec_clk->clk_num, sizeof(*clk_info),
 			GFP_KERNEL);
-		if (!dec_clk->clk_info)
-			return -ENOMEM;
+		if (!dec_clk->clk_info) {
+			ret = -ENOMEM;
+			goto put_device;
+		}
 	} else {
 		mtk_v4l2_err("Failed to get vdec clock count");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_device;
 	}
 
 	for (i = 0; i < dec_clk->clk_num; i++) {
@@ -60,19 +63,22 @@ int mtk_vcodec_init_dec_pm(struct mtk_vcodec_dev *mtkdev)
 			"clock-names", i, &clk_info->clk_name);
 		if (ret) {
 			mtk_v4l2_err("Failed to get clock name id = %d", i);
-			return ret;
+			goto put_device;
 		}
 		clk_info->vcodec_clk = devm_clk_get(&pdev->dev,
 			clk_info->clk_name);
 		if (IS_ERR(clk_info->vcodec_clk)) {
 			mtk_v4l2_err("devm_clk_get (%d)%s fail", i,
 				clk_info->clk_name);
-			return PTR_ERR(clk_info->vcodec_clk);
+			ret = PTR_ERR(clk_info->vcodec_clk);
+			goto put_device;
 		}
 	}
 
 	pm_runtime_enable(&pdev->dev);
-
+	return 0;
+put_device:
+	put_device(pm->larbvdec);
 	return ret;
 }
 
-- 
2.27.0




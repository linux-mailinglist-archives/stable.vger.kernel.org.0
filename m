Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEE02E3C9D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437477AbgL1OEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:04:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437468AbgL1OEq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41A202063A;
        Mon, 28 Dec 2020 14:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164270;
        bh=70SNqzPb0kY4difMU7R6ZK1YJCbByF32JvJL1s9LbGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0pTdPB24RQDWElljoqPWf9yn8qe12l2sEpjxDNGdFiUv8KKLcAMqtfFNehb38Zmki
         bvt65khg43qhC0PCQiHkw05/OMRcWmX+KlEYWheBCXtRDLUtSxZW/K87nmRbuEmbjs
         /v1ulBxY/AMIJeZucRnMHP+pfLbORSB0nh1Q9bYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/717] media: mtk-vcodec: add missing put_device() call in mtk_vcodec_init_enc_pm()
Date:   Mon, 28 Dec 2020 13:42:00 +0100
Message-Id: <20201228125026.800913364@linuxfoundation.org>
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

[ Upstream commit 4affafd7bec7c65da31777f18bd20420f1aeb5f8 ]

if of_find_device_by_node() succeed, mtk_vcodec_init_enc_pm() doesn't have
a corresponding put_device(). Thus add jump target to fix the exception
handling for this function implementation.

Fixes: 4e855a6efa54 ("[media] vcodec: mediatek: Add Mediatek V4L2 Video Encoder Driver")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/mtk-vcodec/mtk_vcodec_enc_pm.c   | 26 ++++++++++++++-----
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
index ee22902aaa71c..1a047c25679fa 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
@@ -47,14 +47,16 @@ int mtk_vcodec_init_enc_pm(struct mtk_vcodec_dev *mtkdev)
 	node = of_parse_phandle(dev->of_node, "mediatek,larb", 1);
 	if (!node) {
 		mtk_v4l2_err("no mediatek,larb found");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto put_larbvenc;
 	}
 
 	pdev = of_find_device_by_node(node);
 	of_node_put(node);
 	if (!pdev) {
 		mtk_v4l2_err("no mediatek,larb device found");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto put_larbvenc;
 	}
 
 	pm->larbvenclt = &pdev->dev;
@@ -67,11 +69,14 @@ int mtk_vcodec_init_enc_pm(struct mtk_vcodec_dev *mtkdev)
 		enc_clk->clk_info = devm_kcalloc(&pdev->dev,
 			enc_clk->clk_num, sizeof(*clk_info),
 			GFP_KERNEL);
-		if (!enc_clk->clk_info)
-			return -ENOMEM;
+		if (!enc_clk->clk_info) {
+			ret = -ENOMEM;
+			goto put_larbvenclt;
+		}
 	} else {
 		mtk_v4l2_err("Failed to get venc clock count");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_larbvenclt;
 	}
 
 	for (i = 0; i < enc_clk->clk_num; i++) {
@@ -80,17 +85,24 @@ int mtk_vcodec_init_enc_pm(struct mtk_vcodec_dev *mtkdev)
 			"clock-names", i, &clk_info->clk_name);
 		if (ret) {
 			mtk_v4l2_err("venc failed to get clk name %d", i);
-			return ret;
+			goto put_larbvenclt;
 		}
 		clk_info->vcodec_clk = devm_clk_get(&pdev->dev,
 			clk_info->clk_name);
 		if (IS_ERR(clk_info->vcodec_clk)) {
 			mtk_v4l2_err("venc devm_clk_get (%d)%s fail", i,
 				clk_info->clk_name);
-			return PTR_ERR(clk_info->vcodec_clk);
+			ret = PTR_ERR(clk_info->vcodec_clk);
+			goto put_larbvenclt;
 		}
 	}
 
+	return 0;
+
+put_larbvenclt:
+	put_device(pm->larbvenclt);
+put_larbvenc:
+	put_device(pm->larbvenc);
 	return ret;
 }
 
-- 
2.27.0




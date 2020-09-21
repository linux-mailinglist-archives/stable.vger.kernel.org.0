Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74A2272D76
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgIUQkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728315AbgIUQkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:40:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9D05239D0;
        Mon, 21 Sep 2020 16:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706400;
        bh=xUQSWHTQ2Hq+DXgU9icpSwq4lUHttMxUJ9nzTMmdyaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SkCmzgwmwdPOcvmqO2wmUjNFpHSyqSo6wCOGX9VSvssT8FMGDZvU4zqq26cNVAF/8
         7UAnuFhWifC9VP8nXDMKT4w1GN6loIXb++Qkm6OghC13RqDRrUapD4fM6cPcGSPZIX
         HXGtYM5ZGaTZFcCs2J/43SEcI5qFWcisnSNhVJbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 83/94] drm/mediatek: Add missing put_device() call in mtk_hdmi_dt_parse_pdata()
Date:   Mon, 21 Sep 2020 18:28:10 +0200
Message-Id: <20200921162039.342702062@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 0680a622318b8d657323b94082f4b9a44038dfee ]

if of_find_device_by_node() succeed, mtk_drm_kms_init() doesn't have
a corresponding put_device(). Thus add jump target to fix the exception
handling for this function implementation.

Fixes: 8f83f26891e1 ("drm/mediatek: Add HDMI support")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi.c b/drivers/gpu/drm/mediatek/mtk_hdmi.c
index 3c69c73fbd473..f1a376c34e713 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi.c
@@ -1476,25 +1476,30 @@ static int mtk_hdmi_dt_parse_pdata(struct mtk_hdmi *hdmi,
 		dev_err(dev,
 			"Failed to get system configuration registers: %d\n",
 			ret);
-		return ret;
+		goto put_device;
 	}
 	hdmi->sys_regmap = regmap;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	hdmi->regs = devm_ioremap_resource(dev, mem);
-	if (IS_ERR(hdmi->regs))
-		return PTR_ERR(hdmi->regs);
+	if (IS_ERR(hdmi->regs)) {
+		ret = PTR_ERR(hdmi->regs);
+		goto put_device;
+	}
 
 	remote = of_graph_get_remote_node(np, 1, 0);
-	if (!remote)
-		return -EINVAL;
+	if (!remote) {
+		ret = -EINVAL;
+		goto put_device;
+	}
 
 	if (!of_device_is_compatible(remote, "hdmi-connector")) {
 		hdmi->next_bridge = of_drm_find_bridge(remote);
 		if (!hdmi->next_bridge) {
 			dev_err(dev, "Waiting for external bridge\n");
 			of_node_put(remote);
-			return -EPROBE_DEFER;
+			ret = -EPROBE_DEFER;
+			goto put_device;
 		}
 	}
 
@@ -1503,7 +1508,8 @@ static int mtk_hdmi_dt_parse_pdata(struct mtk_hdmi *hdmi,
 		dev_err(dev, "Failed to find ddc-i2c-bus node in %pOF\n",
 			remote);
 		of_node_put(remote);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_device;
 	}
 	of_node_put(remote);
 
@@ -1511,10 +1517,14 @@ static int mtk_hdmi_dt_parse_pdata(struct mtk_hdmi *hdmi,
 	of_node_put(i2c_np);
 	if (!hdmi->ddc_adpt) {
 		dev_err(dev, "Failed to get ddc i2c adapter by node\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_device;
 	}
 
 	return 0;
+put_device:
+	put_device(hdmi->cec_dev);
+	return ret;
 }
 
 /*
-- 
2.25.1




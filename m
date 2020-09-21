Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECC1272F45
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgIUQzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729307AbgIUQp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:45:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1312923998;
        Mon, 21 Sep 2020 16:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706728;
        bh=6AovKmixp/XkjlNLYCnK4Tn3EsCKjq4UKUkbPrRSzCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BroCUCCujGLzzhWqh7UgrTMDZ7MWRKNqRX6+564jrNfePIqnrbxmOz3BDZJ/AAk7P
         8ig4X/3DUd7d0DeEZkLzHmBGj2Qskb9lKPXD+JN0JJjVTzDOTKbZyQQomYZ/VhHaSS
         +ZtJNBBMGON2CsURPDSJUUlnSFGbiJOymAGguqgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 071/118] drm/mediatek: Add missing put_device() call in mtk_hdmi_dt_parse_pdata()
Date:   Mon, 21 Sep 2020 18:28:03 +0200
Message-Id: <20200921162039.625667927@linuxfoundation.org>
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
index 1eebe310470af..a9704822c0334 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi.c
@@ -1507,25 +1507,30 @@ static int mtk_hdmi_dt_parse_pdata(struct mtk_hdmi *hdmi,
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
 
@@ -1534,7 +1539,8 @@ static int mtk_hdmi_dt_parse_pdata(struct mtk_hdmi *hdmi,
 		dev_err(dev, "Failed to find ddc-i2c-bus node in %pOF\n",
 			remote);
 		of_node_put(remote);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_device;
 	}
 	of_node_put(remote);
 
@@ -1542,10 +1548,14 @@ static int mtk_hdmi_dt_parse_pdata(struct mtk_hdmi *hdmi,
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




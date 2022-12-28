Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFDA6582FA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbiL1Qnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbiL1QnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:43:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657241FF87
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:37:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C54D8B81707
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22530C43396;
        Wed, 28 Dec 2022 16:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245455;
        bh=XaMmYE28cw6KO7oP3jZT8Dmiaw8VJ3ASpLNnG1IIEmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTgGTTp6C2jdW8wRYnNkwEssrudIJiIv12XGK6dcJ8lNDs6TusisoYssYOSuHN0KA
         /CN5Ml46T+OQE1dWd9AtrL1qyE1eg3F3TPzYkrgJkH5oCJtY551+/EOGVrbGLlL8dd
         pHBRnCu4NYHaFLkHi+bzrjcogixymIZRBiIC3EYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Guenter Roeck <groeck@chromium.org>,
        Yong Wu <yong.wu@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0864/1146] iommu/mediatek: Validate number of phandles associated with "mediatek,larbs"
Date:   Wed, 28 Dec 2022 15:40:03 +0100
Message-Id: <20221228144353.630717301@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <groeck@chromium.org>

[ Upstream commit ef693a8440926884bfd9cc3d6d36f65719513350 ]

Fix the smatch warnings:
drivers/iommu/mtk_iommu.c:878 mtk_iommu_mm_dts_parse() error: uninitialized
symbol 'larbnode'.

If someone abuse the dtsi node(Don't follow the definition of dt-binding),
for example "mediatek,larbs" is provided as boolean property, "larb_nr"
will be zero and cause abnormal.

To fix this problem and improve the code safety, add some checking
for the invalid input from dtsi, e.g. checking the larb_nr/larbid valid
range, and avoid "mediatek,larb-id" property conflicts in the smi-larb
nodes.

Fixes: d2e9a1102cfc ("iommu/mediatek: Contain MM IOMMU flow with the MM TYPE")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20221018024258.19073-5-yong.wu@mediatek.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index f4a315da4535..f1547199026c 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -1051,6 +1051,8 @@ static int mtk_iommu_mm_dts_parse(struct device *dev, struct component_match **m
 	larb_nr = of_count_phandle_with_args(dev->of_node, "mediatek,larbs", NULL);
 	if (larb_nr < 0)
 		return larb_nr;
+	if (larb_nr == 0 || larb_nr > MTK_LARB_NR_MAX)
+		return -EINVAL;
 
 	for (i = 0; i < larb_nr; i++) {
 		u32 id;
@@ -1069,6 +1071,11 @@ static int mtk_iommu_mm_dts_parse(struct device *dev, struct component_match **m
 		ret = of_property_read_u32(larbnode, "mediatek,larb-id", &id);
 		if (ret)/* The id is consecutive if there is no this property */
 			id = i;
+		if (id >= MTK_LARB_NR_MAX) {
+			of_node_put(larbnode);
+			ret = -EINVAL;
+			goto err_larbdev_put;
+		}
 
 		plarbdev = of_find_device_by_node(larbnode);
 		of_node_put(larbnode);
@@ -1076,6 +1083,11 @@ static int mtk_iommu_mm_dts_parse(struct device *dev, struct component_match **m
 			ret = -ENODEV;
 			goto err_larbdev_put;
 		}
+		if (data->larb_imu[id].dev) {
+			platform_device_put(plarbdev);
+			ret = -EEXIST;
+			goto err_larbdev_put;
+		}
 		data->larb_imu[id].dev = &plarbdev->dev;
 
 		if (!plarbdev->dev.driver) {
-- 
2.35.1




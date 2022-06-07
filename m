Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2BD540E36
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353074AbiFGSxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347427AbiFGStJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:49:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D95419034;
        Tue,  7 Jun 2022 11:03:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DD7BB82182;
        Tue,  7 Jun 2022 18:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD784C34115;
        Tue,  7 Jun 2022 18:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624986;
        bh=1fnCYEHFdDXiebIMF3JIQlXednadZc3hyC/x3Lsi5wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1DZI2QnCiQ0W34YoiTQT4xDeWfqYIxtmJHJGMKFwSCXUL10DcwOuotwbLmRkrIsIx
         70pD2fyRhCasoMzJaZE0rmW+AiK9lxpKm1z17/j4iUypgbJbiqNq7djg9r95BBFZHk
         LA82sTFc/rjL46x/SUSukJRMPonmSrK8tTQ0LPfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfei Wang <yf.wang@mediatek.com>,
        Yong Wu <yong.wu@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 484/667] iommu/mediatek: Add mutex for m4u_group and m4u_dom in data
Date:   Tue,  7 Jun 2022 19:02:29 +0200
Message-Id: <20220607164949.217726478@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Wu <yong.wu@mediatek.com>

[ Upstream commit 0e5a3f2e630b28e88e018655548212ef8eb4dfcb ]

Add a mutex to protect the data in the structure mtk_iommu_data,
like ->"m4u_group" ->"m4u_dom". For the internal data, we should
protect it in ourselves driver. Add a mutex for this.
This could be a fix for the multi-groups support.

Fixes: c3045f39244e ("iommu/mediatek: Support for multi domains")
Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20220503071427.2285-8-yong.wu@mediatek.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 13 +++++++++++--
 drivers/iommu/mtk_iommu.h |  2 ++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index b9d690327eae..9b3ded518f83 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -469,15 +469,16 @@ static int mtk_iommu_attach_device(struct iommu_domain *domain,
 		dom->data = data;
 	}
 
+	mutex_lock(&data->mutex);
 	if (!data->m4u_dom) { /* Initialize the M4U HW */
 		ret = pm_runtime_resume_and_get(m4udev);
 		if (ret < 0)
-			return ret;
+			goto err_unlock;
 
 		ret = mtk_iommu_hw_init(data);
 		if (ret) {
 			pm_runtime_put(m4udev);
-			return ret;
+			goto err_unlock;
 		}
 		data->m4u_dom = dom;
 		writel(dom->cfg.arm_v7s_cfg.ttbr & MMU_PT_ADDR_MASK,
@@ -485,9 +486,14 @@ static int mtk_iommu_attach_device(struct iommu_domain *domain,
 
 		pm_runtime_put(m4udev);
 	}
+	mutex_unlock(&data->mutex);
 
 	mtk_iommu_config(data, dev, true, domid);
 	return 0;
+
+err_unlock:
+	mutex_unlock(&data->mutex);
+	return ret;
 }
 
 static void mtk_iommu_detach_device(struct iommu_domain *domain,
@@ -627,6 +633,7 @@ static struct iommu_group *mtk_iommu_device_group(struct device *dev)
 	if (domid < 0)
 		return ERR_PTR(domid);
 
+	mutex_lock(&data->mutex);
 	group = data->m4u_group[domid];
 	if (!group) {
 		group = iommu_group_alloc();
@@ -635,6 +642,7 @@ static struct iommu_group *mtk_iommu_device_group(struct device *dev)
 	} else {
 		iommu_group_ref_get(group);
 	}
+	mutex_unlock(&data->mutex);
 	return group;
 }
 
@@ -909,6 +917,7 @@ static int mtk_iommu_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, data);
+	mutex_init(&data->mutex);
 
 	ret = iommu_device_sysfs_add(&data->iommu, dev, NULL,
 				     "mtk-iommu.%pa", &ioaddr);
diff --git a/drivers/iommu/mtk_iommu.h b/drivers/iommu/mtk_iommu.h
index f81fa8862ed0..f413546ac6e5 100644
--- a/drivers/iommu/mtk_iommu.h
+++ b/drivers/iommu/mtk_iommu.h
@@ -80,6 +80,8 @@ struct mtk_iommu_data {
 
 	struct dma_iommu_mapping	*mapping; /* For mtk_iommu_v1.c */
 
+	struct mutex			mutex; /* Protect m4u_group/m4u_dom above */
+
 	struct list_head		list;
 	struct mtk_smi_larb_iommu	larb_imu[MTK_LARB_NR_MAX];
 };
-- 
2.35.1




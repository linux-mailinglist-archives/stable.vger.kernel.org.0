Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E43B549650
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356874AbiFMMAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358185AbiFML7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:59:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197A84EA1D;
        Mon, 13 Jun 2022 03:56:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95522B80EA7;
        Mon, 13 Jun 2022 10:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FA9C3411C;
        Mon, 13 Jun 2022 10:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117791;
        bh=gFfJF2bRjxyuM9AhQvZuf6nGxSs3UhC8y75I7Cld0M8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djID4/Ao54MqXFbra6HYrOQbvH/xABozsqSmXU6meAcftYwSdmLBDgr8AWdzEKEvO
         CI/r5VzEx7xyvs2p00Q/rHYcOwvXzEihJdGrviC+4l+dUunEOr4hiqP3lcYkO3wUG0
         3wG+itBBZudXRxm6/1HwGQ0+fOcbox6AFIJadHL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Wu <yong.wu@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 133/287] iommu/mediatek: Add list_del in mtk_iommu_remove
Date:   Mon, 13 Jun 2022 12:09:17 +0200
Message-Id: <20220613094927.912666506@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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

[ Upstream commit ee55f75e4bcade81d253163641b63bef3e76cac4 ]

Lack the list_del in the mtk_iommu_remove, and remove
bus_set_iommu(*, NULL) since there may be several iommu HWs.
we can not bus_set_iommu null when one iommu driver unbind.

This could be a fix for mt2712 which support 2 M4U HW and list them.

Fixes: 7c3a2ec02806 ("iommu/mediatek: Merge 2 M4U HWs into one iommu domain")
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20220503071427.2285-6-yong.wu@mediatek.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 8e75f34ac886..7304ad88f126 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -702,8 +702,7 @@ static int mtk_iommu_remove(struct platform_device *pdev)
 	iommu_device_sysfs_remove(&data->iommu);
 	iommu_device_unregister(&data->iommu);
 
-	if (iommu_present(&platform_bus_type))
-		bus_set_iommu(&platform_bus_type, NULL);
+	list_del(&data->list);
 
 	clk_disable_unprepare(data->bclk);
 	devm_free_irq(&pdev->dev, data->irq, data);
-- 
2.35.1




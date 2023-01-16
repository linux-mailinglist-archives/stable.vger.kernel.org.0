Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C7566C4B8
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbjAPP5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjAPP5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:57:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AE922A11
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:57:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A04DB8105C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB66C433EF;
        Mon, 16 Jan 2023 15:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884644;
        bh=899du6+45N6OuEVxtgT2Z2yGwg8QM2EBW8P3Miek+6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0f7ULzx6K9uQt8UvuJ7ZP2XD8MH8NEsIX7qXerGjVDn/9Z5vI3iNxWfPc37G4l6f
         7zEVQT3+jByi1nry9mbpiV4SsuNNKLFjt0Ot4sncxqhq7NfB1b2OhZHGtf0QtWKESY
         fQx/TqujEyZLoSVraXmEuVMqJTVSjdJL/XPTqJP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Yong Wu <yong.wu@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.1 085/183] iommu/mediatek-v1: Fix an error handling path in mtk_iommu_v1_probe()
Date:   Mon, 16 Jan 2023 16:50:08 +0100
Message-Id: <20230116154807.020656795@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 142e821f68cf5da79ce722cb9c1323afae30e185 upstream.

A clk, prepared and enabled in mtk_iommu_v1_hw_init(), is not released in
the error handling path of mtk_iommu_v1_probe().

Add the corresponding clk_disable_unprepare(), as already done in the
remove function.

Fixes: b17336c55d89 ("iommu/mediatek: add support for mtk iommu generation one HW")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Yong Wu <yong.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/593e7b7d97c6e064b29716b091a9d4fd122241fb.1671473163.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/mtk_iommu_v1.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -685,7 +685,7 @@ static int mtk_iommu_v1_probe(struct pla
 	ret = iommu_device_sysfs_add(&data->iommu, &pdev->dev, NULL,
 				     dev_name(&pdev->dev));
 	if (ret)
-		return ret;
+		goto out_clk_unprepare;
 
 	ret = iommu_device_register(&data->iommu, &mtk_iommu_v1_ops, dev);
 	if (ret)
@@ -700,6 +700,8 @@ out_dev_unreg:
 	iommu_device_unregister(&data->iommu);
 out_sysfs_remove:
 	iommu_device_sysfs_remove(&data->iommu);
+out_clk_unprepare:
+	clk_disable_unprepare(data->bclk);
 	return ret;
 }
 



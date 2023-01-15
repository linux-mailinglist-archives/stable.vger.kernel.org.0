Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C17A66AFD2
	for <lists+stable@lfdr.de>; Sun, 15 Jan 2023 08:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjAOH6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Jan 2023 02:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjAOH6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Jan 2023 02:58:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332FC8A77
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 23:58:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEF35B8095B
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 07:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0321CC433EF;
        Sun, 15 Jan 2023 07:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673769530;
        bh=jBKec5lMlwRZyqmnHo2dAyb2aeTH99ic4ZNeB4dpI1c=;
        h=Subject:To:Cc:From:Date:From;
        b=V2CcKafKVYLMZG/MBUtcEhGquJlQ6CJqeTbfWLVPolFZ4QjSGcz++ITSSC4psgXhv
         CQD70g1E3LiW46FzzBuMcA4UJU6gKIbTLA9GDluFjtGMS21M/P1FCuDVGzzTPb9uX0
         zeS7aQNTmDKfN5l3+26czZgUQc4EdG8dv6xkmeJw=
Subject: FAILED: patch "[PATCH] iommu/mediatek-v1: Fix an error handling path in" failed to apply to 5.10-stable tree
To:     christophe.jaillet@wanadoo.fr,
        angelogioacchino.delregno@collabora.com, jroedel@suse.de,
        matthias.bgg@gmail.com, yong.wu@mediatek.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Jan 2023 08:58:42 +0100
Message-ID: <167376952231161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

142e821f68cf ("iommu/mediatek-v1: Fix an error handling path in mtk_iommu_v1_probe()")
ac304c070c54 ("iommu/mediatek-v1: Add error handle for mtk_iommu_probe")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 142e821f68cf5da79ce722cb9c1323afae30e185 Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Mon, 19 Dec 2022 19:06:22 +0100
Subject: [PATCH] iommu/mediatek-v1: Fix an error handling path in
 mtk_iommu_v1_probe()

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

diff --git a/drivers/iommu/mtk_iommu_v1.c b/drivers/iommu/mtk_iommu_v1.c
index 69682ee068d2..ca581ff1c769 100644
--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -683,7 +683,7 @@ static int mtk_iommu_v1_probe(struct platform_device *pdev)
 	ret = iommu_device_sysfs_add(&data->iommu, &pdev->dev, NULL,
 				     dev_name(&pdev->dev));
 	if (ret)
-		return ret;
+		goto out_clk_unprepare;
 
 	ret = iommu_device_register(&data->iommu, &mtk_iommu_v1_ops, dev);
 	if (ret)
@@ -698,6 +698,8 @@ out_dev_unreg:
 	iommu_device_unregister(&data->iommu);
 out_sysfs_remove:
 	iommu_device_sysfs_remove(&data->iommu);
+out_clk_unprepare:
+	clk_disable_unprepare(data->bclk);
 	return ret;
 }
 


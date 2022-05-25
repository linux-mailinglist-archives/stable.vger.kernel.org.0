Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA99F533991
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 11:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbiEYJLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 05:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243693AbiEYJKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 05:10:46 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05D1AEE24;
        Wed, 25 May 2022 02:07:16 -0700 (PDT)
X-UUID: c4e318a7abdd47259b7c01f9e6332cd6-20220525
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.5,REQID:6d40d7f1-4c22-4948-9b73-bd026cb52021,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:0
X-CID-META: VersionHash:2a19b09,CLOUDID:d2126a47-4fb1-496b-8f1d-39e733fed1ea,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:0,BEC:nil
X-UUID: c4e318a7abdd47259b7c01f9e6332cd6-20220525
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <mark-pk.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 705624325; Wed, 25 May 2022 17:07:10 +0800
Received: from MTKMBS07N2.mediatek.inc (172.21.101.141) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Wed, 25 May 2022 17:07:09 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 25 May 2022 17:07:09 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Wed, 25 May 2022 17:07:09 +0800
From:   Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To:     <stable@vger.kernel.org>
CC:     <mchehab@kernel.org>, <matthias.bgg@gmail.com>,
        <hverkuil-cisco@xs4all.nl>, <mark-pk.tsai@mediatek.com>,
        <sakari.ailus@linux.intel.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <yj.chiang@mediatek.com>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 1/2] media: vim2m: Register video device after setting up internals
Date:   Wed, 25 May 2022 17:07:01 +0800
Message-ID: <20220525090702.29035-2-mark-pk.tsai@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220525090702.29035-1-mark-pk.tsai@mediatek.com>
References: <20220525090702.29035-1-mark-pk.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Prevent NULL (or close to NULL) pointer dereference in various places by
registering the video device only when the V4L2 m2m framework has been set
up.

Fixes: commit 96d8eab5d0a1 ("V4L/DVB: [v5,2/2] v4l: Add a mem-to-mem videobuf framework test device")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
(cherry picked from commit cf7f34777a5b4100a3a44ff95f3d949c62892bdd)
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
---
 drivers/media/test-drivers/vim2m.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/test-drivers/vim2m.c b/drivers/media/test-drivers/vim2m.c
index a776bb8e0e09..331a9053a0ed 100644
--- a/drivers/media/test-drivers/vim2m.c
+++ b/drivers/media/test-drivers/vim2m.c
@@ -1325,12 +1325,6 @@ static int vim2m_probe(struct platform_device *pdev)
 	vfd->lock = &dev->dev_mutex;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 
-	ret = video_register_device(vfd, VFL_TYPE_VIDEO, 0);
-	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		goto error_v4l2;
-	}
-
 	video_set_drvdata(vfd, dev);
 	v4l2_info(&dev->v4l2_dev,
 		  "Device registered as /dev/video%d\n", vfd->num);
@@ -1345,6 +1339,12 @@ static int vim2m_probe(struct platform_device *pdev)
 		goto error_dev;
 	}
 
+	ret = video_register_device(vfd, VFL_TYPE_VIDEO, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		goto error_m2m;
+	}
+
 #ifdef CONFIG_MEDIA_CONTROLLER
 	dev->mdev.dev = &pdev->dev;
 	strscpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
@@ -1358,7 +1358,7 @@ static int vim2m_probe(struct platform_device *pdev)
 						 MEDIA_ENT_F_PROC_VIDEO_SCALER);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller\n");
-		goto error_dev;
+		goto error_v4l2;
 	}
 
 	ret = media_device_register(&dev->mdev);
@@ -1373,11 +1373,13 @@ static int vim2m_probe(struct platform_device *pdev)
 error_m2m_mc:
 	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
 #endif
-error_dev:
+error_v4l2:
 	video_unregister_device(&dev->vfd);
 	/* vim2m_device_release called by video_unregister_device to release various objects */
 	return ret;
-error_v4l2:
+error_m2m:
+	v4l2_m2m_release(dev->m2m_dev);
+error_dev:
 	v4l2_device_unregister(&dev->v4l2_dev);
 error_free:
 	kfree(dev);
-- 
2.18.0


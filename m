Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D61533866
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 10:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbiEYI1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 04:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiEYI1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 04:27:45 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B598C53B6C;
        Wed, 25 May 2022 01:27:43 -0700 (PDT)
X-UUID: 20978dcf23574726b024092d67c1fc90-20220525
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.5,REQID:42c35ea1-b8c4-439e-9d71-94b11be78b20,OB:10,L
        OB:0,IP:0,URL:5,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,RULE:Release_Ham,
        ACTION:release,TS:100
X-CID-INFO: VERSION:1.1.5,REQID:42c35ea1-b8c4-439e-9d71-94b11be78b20,OB:10,LOB
        :0,IP:0,URL:5,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,RULE:Spam_GS981B3D,
        ACTION:quarantine,TS:100
X-CID-META: VersionHash:2a19b09,CLOUDID:8af82bb8-3c45-407b-8f66-25095432a27a,C
        OID:2c476e24ec2d,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,QS:0,BEC:nil
X-UUID: 20978dcf23574726b024092d67c1fc90-20220525
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <mark-pk.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 788039644; Wed, 25 May 2022 16:27:39 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Wed, 25 May 2022 16:27:37 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 May 2022 16:27:37 +0800
From:   Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To:     <stable@vger.kernel.org>
CC:     <mchehab@kernel.org>, <matthias.bgg@gmail.com>,
        <hverkuil-cisco@xs4all.nl>, <mark-pk.tsai@mediatek.com>,
        <sakari.ailus@linux.intel.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <yj.chiang@mediatek.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 2/2] media: vim2m: initialize the media device earlier
Date:   Wed, 25 May 2022 16:27:31 +0800
Message-ID: <20220525082731.28235-3-mark-pk.tsai@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220525082731.28235-1-mark-pk.tsai@mediatek.com>
References: <20220525082731.28235-1-mark-pk.tsai@mediatek.com>
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

commit 1a28dce222a6ece725689ad58c0cf4a1b48894f4 upstream.

Before the video device node is registered, the v4l2_dev.mdev
pointer must be set in order to correctly associate the video
device with the media device. Move the initialization of the
media device up.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
[ backport to 5.4 LTS]
CC: stable@vger.kernel.org
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
---
 drivers/media/platform/vim2m.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 02f5bc82ba46..6fba00e03c67 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1347,12 +1347,6 @@ static int vim2m_probe(struct platform_device *pdev)
 		goto error_dev;
 	}
 
-	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
-	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		goto error_m2m;
-	}
-
 #ifdef CONFIG_MEDIA_CONTROLLER
 	dev->mdev.dev = &pdev->dev;
 	strscpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
@@ -1361,7 +1355,15 @@ static int vim2m_probe(struct platform_device *pdev)
 	media_device_init(&dev->mdev);
 	dev->mdev.ops = &m2m_media_ops;
 	dev->v4l2_dev.mdev = &dev->mdev;
+#endif
 
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		goto error_m2m;
+	}
+
+#ifdef CONFIG_MEDIA_CONTROLLER
 	ret = v4l2_m2m_register_media_controller(dev->m2m_dev, vfd,
 						 MEDIA_ENT_F_PROC_VIDEO_SCALER);
 	if (ret) {
-- 
2.18.0


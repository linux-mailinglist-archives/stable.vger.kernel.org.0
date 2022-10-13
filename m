Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D095FD24F
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 03:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiJMBMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 21:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiJMBMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 21:12:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFCF11A12;
        Wed, 12 Oct 2022 18:11:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D5E9B81CD8;
        Thu, 13 Oct 2022 00:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC6FC433D6;
        Thu, 13 Oct 2022 00:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620502;
        bh=i1lndpiEkYrYAtQpDMBbdOudkzLK1aVb7W6EgX5Yd3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2BLZLyggaDgsax3xO3TQy9M+dyFbP4ZpSPjKD6trFqlic0eMh9Pp+Qfs31bGEqWV
         i9yl+hF79wtvVvoH4FWMQgZsqnXhkPtvwDanO+iW2H9Pi67xYKT/9TjMcFnALHPMbu
         EBPCYZy+/0N/Q3Joi9Ga4gA0iPRTtaJs+6vk/bVKS43SGLIImnlN7YOv+J0XZfdcOQ
         FlgmIXlGBMe03hkbZBhI6joIiPjcT1W+SC/ogg8Z09hkwhdNhltVrlWWmWvagNPiVu
         S7d+4D73pewDj/eOPfq11kmynWlHSpWFGVun1FFEsapkgv0AnYBVtSYEaaJuMLwE81
         IZnVKVuC5GO/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, neil.armstrong@linaro.org,
        khilman@baylibre.com, matthias.bgg@gmail.com,
        dafna.hirschfeld@collabora.com, vulab@iscas.ac.cn,
        rick.chang@mediatek.com, yong.wu@mediatek.com,
        colin.i.king@gmail.com, christophe.jaillet@wanadoo.fr,
        prabhakar.mahadev-lad.rj@bp.renesas.com, andrzej.hajda@intel.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 03/47] media: platform: fix some double free in meson-ge2d and mtk-jpeg and s5p-mfc
Date:   Wed, 12 Oct 2022 20:20:38 -0400
Message-Id: <20221013002124.1894077-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002124.1894077-1-sashal@kernel.org>
References: <20221013002124.1894077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit c65c3f3a2cbf21ed429d9b9c725bdb5dc6abf4cf ]

video_unregister_device will release device internally. There is no need to
call video_device_release after video_unregister_device.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/meson/ge2d/ge2d.c        | 1 -
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c | 1 -
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 3 +--
 3 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/platform/meson/ge2d/ge2d.c b/drivers/media/platform/meson/ge2d/ge2d.c
index a373dea9866b..a885cbc99e38 100644
--- a/drivers/media/platform/meson/ge2d/ge2d.c
+++ b/drivers/media/platform/meson/ge2d/ge2d.c
@@ -1032,7 +1032,6 @@ static int ge2d_remove(struct platform_device *pdev)
 
 	video_unregister_device(ge2d->vfd);
 	v4l2_m2m_release(ge2d->m2m_dev);
-	video_device_release(ge2d->vfd);
 	v4l2_device_unregister(&ge2d->v4l2_dev);
 	clk_disable_unprepare(ge2d->clk);
 
diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
index a89c7b206eef..470f8f167744 100644
--- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
@@ -1457,7 +1457,6 @@ static int mtk_jpeg_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 	video_unregister_device(jpeg->vdev);
-	video_device_release(jpeg->vdev);
 	v4l2_m2m_release(jpeg->m2m_dev);
 	v4l2_device_unregister(&jpeg->v4l2_dev);
 	mtk_jpeg_clk_release(jpeg);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index f336a9543273..4fc135d9f38b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1406,6 +1406,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 /* Deinit MFC if probe had failed */
 err_enc_reg:
 	video_unregister_device(dev->vfd_dec);
+	dev->vfd_dec = NULL;
 err_dec_reg:
 	video_device_release(dev->vfd_enc);
 err_enc_alloc:
@@ -1451,8 +1452,6 @@ static int s5p_mfc_remove(struct platform_device *pdev)
 
 	video_unregister_device(dev->vfd_enc);
 	video_unregister_device(dev->vfd_dec);
-	video_device_release(dev->vfd_enc);
-	video_device_release(dev->vfd_dec);
 	v4l2_device_unregister(&dev->v4l2_dev);
 	s5p_mfc_unconfigure_dma_memory(dev);
 
-- 
2.35.1


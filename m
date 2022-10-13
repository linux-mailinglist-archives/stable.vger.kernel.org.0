Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072E05FD1E0
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiJMAz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbiJMAzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:55:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853E5127429;
        Wed, 12 Oct 2022 17:52:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44BD5B81CC9;
        Thu, 13 Oct 2022 00:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3EFC433D7;
        Thu, 13 Oct 2022 00:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620337;
        bh=Hn/ow9Xin3Od8mQZtZIgLBDPeR+Aq7EySKsOMGbYcTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WX1aorpMg7A04PbTajcFidpWBFG0DCs0QjxcHNpBIBSUPv6Rj/tEh2HAZjaf5CUZM
         bjKme4V5PZMTaR1Btp7Sxv9set0hvFSweJEqRUeXwl2wTUFLBLtbwPgiXD0c0qYROR
         wEzAjazsxg3AFq6hq2bXiO+3btUJShxh9OUr663nQH08dKAGq0RTWDYDzzyPdWhMkJ
         7fMVz4b48U2Hp5iAIt3orxTNOz9aIlst+1FuMkoyMeq5LNkK7M+NwAD/VJzV6HqKHa
         lo3ScuafCXla0C1mugkstub0XnM58bXbXukhoPNl8sJLEojdXMN23kecsWHFKccKTG
         lLDvr+9Xcti5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, neil.armstrong@linaro.org,
        khilman@baylibre.com, bin.liu@mediatek.com, matthias.bgg@gmail.com,
        m.szyprowski@samsung.com, andrzej.hajda@intel.com,
        linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 04/63] media: platform: fix some double free in meson-ge2d and mtk-jpeg and s5p-mfc
Date:   Wed, 12 Oct 2022 20:17:38 -0400
Message-Id: <20221013001842.1893243-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
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
 drivers/media/platform/amlogic/meson-ge2d/ge2d.c     | 1 -
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c | 1 -
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c     | 3 +--
 3 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/platform/amlogic/meson-ge2d/ge2d.c b/drivers/media/platform/amlogic/meson-ge2d/ge2d.c
index 5e7b319f300d..142d421a8d76 100644
--- a/drivers/media/platform/amlogic/meson-ge2d/ge2d.c
+++ b/drivers/media/platform/amlogic/meson-ge2d/ge2d.c
@@ -1030,7 +1030,6 @@ static int ge2d_remove(struct platform_device *pdev)
 
 	video_unregister_device(ge2d->vfd);
 	v4l2_m2m_release(ge2d->m2m_dev);
-	video_device_release(ge2d->vfd);
 	v4l2_device_unregister(&ge2d->v4l2_dev);
 	clk_disable_unprepare(ge2d->clk);
 
diff --git a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
index bc5b0a0168ec..6aa73f1cde18 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1411,7 +1411,6 @@ static int mtk_jpeg_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 	video_unregister_device(jpeg->vdev);
-	video_device_release(jpeg->vdev);
 	v4l2_m2m_release(jpeg->m2m_dev);
 	v4l2_device_unregister(&jpeg->v4l2_dev);
 
diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
index 761341934925..f85d1eebafac 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
@@ -1399,6 +1399,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 /* Deinit MFC if probe had failed */
 err_enc_reg:
 	video_unregister_device(dev->vfd_dec);
+	dev->vfd_dec = NULL;
 err_dec_reg:
 	video_device_release(dev->vfd_enc);
 err_enc_alloc:
@@ -1444,8 +1445,6 @@ static int s5p_mfc_remove(struct platform_device *pdev)
 
 	video_unregister_device(dev->vfd_enc);
 	video_unregister_device(dev->vfd_dec);
-	video_device_release(dev->vfd_enc);
-	video_device_release(dev->vfd_dec);
 	v4l2_device_unregister(&dev->v4l2_dev);
 	s5p_mfc_unconfigure_dma_memory(dev);
 
-- 
2.35.1


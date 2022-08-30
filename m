Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCA85A6577
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 15:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbiH3NuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 09:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiH3NtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 09:49:24 -0400
Received: from www.linuxtv.org (www.linuxtv.org [130.149.80.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DEF20BC0
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 06:47:26 -0700 (PDT)
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1oT1Io-005ToO-Eg; Tue, 30 Aug 2022 13:29:14 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Tue, 30 Aug 2022 12:48:14 +0000
Subject: [git:media_stage/master] media: cedrus: Set the platform driver data earlier
To:     linuxtv-commits@linuxtv.org
Cc:     Samuel Holland <samuel@sholland.org>, stable@vger.kernel.org,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1oT1Io-005ToO-Eg@www.linuxtv.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: cedrus: Set the platform driver data earlier
Author:  Dmitry Osipenko <dmitry.osipenko@collabora.com>
Date:    Thu Aug 18 22:33:07 2022 +0200

The cedrus_hw_resume() crashes with NULL deference on driver probe if
runtime PM is disabled because it uses platform data that hasn't been
set up yet. Fix this by setting the platform data earlier during probe.

Cc: stable@vger.kernel.org
Fixes: 50e761516f2b (media: platform: Add Cedrus VPU decoder driver)
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Samuel Holland <samuel@sholland.org>
Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/staging/media/sunxi/cedrus/cedrus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index 960a0130cd62..55c54dfdc585 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -448,6 +448,8 @@ static int cedrus_probe(struct platform_device *pdev)
 	if (!dev)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, dev);
+
 	dev->vfd = cedrus_video_device;
 	dev->dev = &pdev->dev;
 	dev->pdev = pdev;
@@ -521,8 +523,6 @@ static int cedrus_probe(struct platform_device *pdev)
 		goto err_m2m_mc;
 	}
 
-	platform_set_drvdata(pdev, dev);
-
 	return 0;
 
 err_m2m_mc:

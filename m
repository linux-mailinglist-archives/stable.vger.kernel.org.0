Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1974F2B40
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353510AbiDEKIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344365AbiDEJTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:19:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF092BA;
        Tue,  5 Apr 2022 02:08:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56AFEB81A22;
        Tue,  5 Apr 2022 09:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48E9C385A0;
        Tue,  5 Apr 2022 09:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149680;
        bh=aduOYBaXcm3bJGU5ljNOOCD1XxWS7V29veFoK8jq2cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxUApaUuGvK82xX4pI+K9eQQkajdLvjOXeRnVNpVVx1jboeQofuENF/NkfKNxLzuT
         LSj0Kqf/Rw31yKjZxbVb4syIvGlr+KpqqrAYElYDfFsFs+/rbiHi6iG93JWOVsWnJx
         twcBuXDkg7SHJLz3DfjVwSqJgAKcqnecD95f/cWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0803/1017] media: staging: media: zoran: move videodev alloc
Date:   Tue,  5 Apr 2022 09:28:36 +0200
Message-Id: <20220405070418.085770417@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 82e3a496eb56da0b9f29fdc5b63cedb3289e91de ]

Move some code out of zr36057_init() and create new functions for handling
zr->video_dev. This permit to ease code reading and fix a zr->video_dev
memory leak.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/zoran/zoran.h        |  2 +-
 drivers/staging/media/zoran/zoran_card.c   | 80 ++++++++++++++--------
 drivers/staging/media/zoran/zoran_driver.c |  5 +-
 3 files changed, 54 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/media/zoran/zoran.h b/drivers/staging/media/zoran/zoran.h
index b1ad2a2b914c..50d5a7acfab6 100644
--- a/drivers/staging/media/zoran/zoran.h
+++ b/drivers/staging/media/zoran/zoran.h
@@ -313,6 +313,6 @@ static inline struct zoran *to_zoran(struct v4l2_device *v4l2_dev)
 
 #endif
 
-int zoran_queue_init(struct zoran *zr, struct vb2_queue *vq);
+int zoran_queue_init(struct zoran *zr, struct vb2_queue *vq, int dir);
 void zoran_queue_exit(struct zoran *zr);
 int zr_set_buf(struct zoran *zr);
diff --git a/drivers/staging/media/zoran/zoran_card.c b/drivers/staging/media/zoran/zoran_card.c
index c578ef3c32f5..a83314b16548 100644
--- a/drivers/staging/media/zoran/zoran_card.c
+++ b/drivers/staging/media/zoran/zoran_card.c
@@ -803,6 +803,52 @@ int zoran_check_jpg_settings(struct zoran *zr,
 	return 0;
 }
 
+static int zoran_init_video_device(struct zoran *zr, struct video_device *video_dev, int dir)
+{
+	int err;
+
+	/* Now add the template and register the device unit. */
+	*video_dev = zoran_template;
+	video_dev->v4l2_dev = &zr->v4l2_dev;
+	video_dev->lock = &zr->lock;
+	video_dev->device_caps = V4L2_CAP_STREAMING | dir;
+
+	strscpy(video_dev->name, ZR_DEVNAME(zr), sizeof(video_dev->name));
+	/*
+	 * It's not a mem2mem device, but you can both capture and output from one and the same
+	 * device. This should really be split up into two device nodes, but that's a job for
+	 * another day.
+	 */
+	video_dev->vfl_dir = VFL_DIR_M2M;
+	zoran_queue_init(zr, &zr->vq, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+
+	err = video_register_device(video_dev, VFL_TYPE_VIDEO, video_nr[zr->id]);
+	if (err < 0)
+		return err;
+	video_set_drvdata(video_dev, zr);
+	return 0;
+}
+
+static void zoran_exit_video_devices(struct zoran *zr)
+{
+	video_unregister_device(zr->video_dev);
+	kfree(zr->video_dev);
+}
+
+static int zoran_init_video_devices(struct zoran *zr)
+{
+	int err;
+
+	zr->video_dev = video_device_alloc();
+	if (!zr->video_dev)
+		return -ENOMEM;
+
+	err = zoran_init_video_device(zr, zr->video_dev, V4L2_CAP_VIDEO_CAPTURE);
+	if (err)
+		kfree(zr->video_dev);
+	return err;
+}
+
 void zoran_open_init_params(struct zoran *zr)
 {
 	int i;
@@ -874,17 +920,11 @@ static int zr36057_init(struct zoran *zr)
 	zoran_open_init_params(zr);
 
 	/* allocate memory *before* doing anything to the hardware in case allocation fails */
-	zr->video_dev = video_device_alloc();
-	if (!zr->video_dev) {
-		err = -ENOMEM;
-		goto exit;
-	}
 	zr->stat_com = dma_alloc_coherent(&zr->pci_dev->dev,
 					  BUZ_NUM_STAT_COM * sizeof(u32),
 					  &zr->p_sc, GFP_KERNEL);
 	if (!zr->stat_com) {
-		err = -ENOMEM;
-		goto exit_video;
+		return -ENOMEM;
 	}
 	for (j = 0; j < BUZ_NUM_STAT_COM; j++)
 		zr->stat_com[j] = cpu_to_le32(1); /* mark as unavailable to zr36057 */
@@ -897,26 +937,9 @@ static int zr36057_init(struct zoran *zr)
 		goto exit_statcom;
 	}
 
-	/* Now add the template and register the device unit. */
-	*zr->video_dev = zoran_template;
-	zr->video_dev->v4l2_dev = &zr->v4l2_dev;
-	zr->video_dev->lock = &zr->lock;
-	zr->video_dev->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE;
-
-	strscpy(zr->video_dev->name, ZR_DEVNAME(zr), sizeof(zr->video_dev->name));
-	/*
-	 * It's not a mem2mem device, but you can both capture and output from one and the same
-	 * device. This should really be split up into two device nodes, but that's a job for
-	 * another day.
-	 */
-	zr->video_dev->vfl_dir = VFL_DIR_M2M;
-
-	zoran_queue_init(zr, &zr->vq);
-
-	err = video_register_device(zr->video_dev, VFL_TYPE_VIDEO, video_nr[zr->id]);
-	if (err < 0)
+	err = zoran_init_video_devices(zr);
+	if (err)
 		goto exit_statcomb;
-	video_set_drvdata(zr->video_dev, zr);
 
 	zoran_init_hardware(zr);
 	if (!pass_through) {
@@ -931,9 +954,6 @@ static int zr36057_init(struct zoran *zr)
 	dma_free_coherent(&zr->pci_dev->dev, BUZ_NUM_STAT_COM * sizeof(u32) * 2, zr->stat_comb, zr->p_scb);
 exit_statcom:
 	dma_free_coherent(&zr->pci_dev->dev, BUZ_NUM_STAT_COM * sizeof(u32), zr->stat_com, zr->p_sc);
-exit_video:
-	kfree(zr->video_dev);
-exit:
 	return err;
 }
 
@@ -965,7 +985,7 @@ static void zoran_remove(struct pci_dev *pdev)
 	dma_free_coherent(&zr->pci_dev->dev, BUZ_NUM_STAT_COM * sizeof(u32) * 2, zr->stat_comb, zr->p_scb);
 	pci_release_regions(pdev);
 	pci_disable_device(zr->pci_dev);
-	video_unregister_device(zr->video_dev);
+	zoran_exit_video_devices(zr);
 exit_free:
 	v4l2_ctrl_handler_free(&zr->hdl);
 	v4l2_device_unregister(&zr->v4l2_dev);
diff --git a/drivers/staging/media/zoran/zoran_driver.c b/drivers/staging/media/zoran/zoran_driver.c
index 46382e43f1bf..551db338c7f7 100644
--- a/drivers/staging/media/zoran/zoran_driver.c
+++ b/drivers/staging/media/zoran/zoran_driver.c
@@ -1008,7 +1008,7 @@ static const struct vb2_ops zr_video_qops = {
 	.wait_finish            = vb2_ops_wait_finish,
 };
 
-int zoran_queue_init(struct zoran *zr, struct vb2_queue *vq)
+int zoran_queue_init(struct zoran *zr, struct vb2_queue *vq, int dir)
 {
 	int err;
 
@@ -1016,7 +1016,8 @@ int zoran_queue_init(struct zoran *zr, struct vb2_queue *vq)
 	INIT_LIST_HEAD(&zr->queued_bufs);
 
 	vq->dev = &zr->pci_dev->dev;
-	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	vq->type = dir;
+
 	vq->io_modes = VB2_USERPTR | VB2_DMABUF | VB2_MMAP | VB2_READ | VB2_WRITE;
 	vq->drv_priv = zr;
 	vq->buf_struct_size = sizeof(struct zr_buffer);
-- 
2.34.1




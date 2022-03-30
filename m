Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A490D4EC017
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343794AbiC3Lso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343774AbiC3Lsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:48:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EE225DA80;
        Wed, 30 Mar 2022 04:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 573C2CE1C71;
        Wed, 30 Mar 2022 11:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF4BC340F3;
        Wed, 30 Mar 2022 11:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640812;
        bh=FFoYu9xD39rqkIZEOepdvzpRGpwFoRxIoNbHOu8iJoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKgwZs6wPkm7S+UFEqbNwWgwJbqxYXO/ZJQexDgqp1FGc8bapkOC35SExCGr8bc0f
         BYPpmXZ8KTPzxGWps8xzyWTld3J4CMCg26hEdlD795dsJS5y32tqpT7jnIMmsYee9+
         NBxftNkVchLPWiY0PIFn0FKj/WPag9EG7qEunjTbQblvymJiRtCubP+MUWpPtUi2Ul
         RnM/PyxNrr8vaHB/bjFIMjp6RTbWBNnXbKHqJzAMtGw5g0u8DJ/UsjrDpi9xG6I0vh
         emAD7zyFWpbDYcHswA4jVgqv2BLy7k+5TdLbNYCWSymxbuDYy9aAYfSXnS1mdHu+wM
         V3paNvGZ5cxWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Corentin Labbe <clabbe@baylibre.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.17 03/66] media: staging: media: zoran: fix various V4L2 compliance errors
Date:   Wed, 30 Mar 2022 07:45:42 -0400
Message-Id: <20220330114646.1669334-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 914941827aad5ecddf9bf3a6dee67fbec1af1fff ]

This fixes several issues found with 'v4l2-compliance -s':

1) read()/write() is supported, but not reported in the capabilities
2) S_STD(G_STD()) failed: setting the same standard should just return 0.
3) G_PARM failed to set readbuffers.
4) different field values in the format vs. what v4l2_buffer reported.
5) zero the sequence number when starting streaming.
6) drop VB_USERPTR: makes no sense with dma_contig streaming.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/zoran/zoran_card.c   |  2 +-
 drivers/staging/media/zoran/zoran_driver.c | 13 ++++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/zoran/zoran_card.c b/drivers/staging/media/zoran/zoran_card.c
index 677d3a26cef4..175654d104c5 100644
--- a/drivers/staging/media/zoran/zoran_card.c
+++ b/drivers/staging/media/zoran/zoran_card.c
@@ -811,7 +811,7 @@ static int zoran_init_video_device(struct zoran *zr, struct video_device *video_
 	*video_dev = zoran_template;
 	video_dev->v4l2_dev = &zr->v4l2_dev;
 	video_dev->lock = &zr->lock;
-	video_dev->device_caps = V4L2_CAP_STREAMING | dir;
+	video_dev->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_READWRITE | dir;
 
 	strscpy(video_dev->name, ZR_DEVNAME(zr), sizeof(video_dev->name));
 	/*
diff --git a/drivers/staging/media/zoran/zoran_driver.c b/drivers/staging/media/zoran/zoran_driver.c
index 551db338c7f7..84665637ebb7 100644
--- a/drivers/staging/media/zoran/zoran_driver.c
+++ b/drivers/staging/media/zoran/zoran_driver.c
@@ -255,8 +255,6 @@ static int zoran_querycap(struct file *file, void *__fh, struct v4l2_capability
 	strscpy(cap->card, ZR_DEVNAME(zr), sizeof(cap->card));
 	strscpy(cap->driver, "zoran", sizeof(cap->driver));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s", pci_name(zr->pci_dev));
-	cap->device_caps = zr->video_dev->device_caps;
-	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
@@ -582,6 +580,9 @@ static int zoran_s_std(struct file *file, void *__fh, v4l2_std_id std)
 	struct zoran *zr = video_drvdata(file);
 	int res = 0;
 
+	if (zr->norm == std)
+		return 0;
+
 	if (zr->running != ZORAN_MAP_MODE_NONE)
 		return -EBUSY;
 
@@ -739,6 +740,7 @@ static int zoran_g_parm(struct file *file, void *priv, struct v4l2_streamparm *p
 	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
+	parm->parm.capture.readbuffers = 9;
 	return 0;
 }
 
@@ -869,6 +871,10 @@ int zr_set_buf(struct zoran *zr)
 		vbuf = &buf->vbuf;
 
 		buf->vbuf.field = V4L2_FIELD_INTERLACED;
+		if (BUZ_MAX_HEIGHT < (zr->v4l_settings.height * 2))
+			buf->vbuf.field = V4L2_FIELD_INTERLACED;
+		else
+			buf->vbuf.field = V4L2_FIELD_TOP;
 		vb2_set_plane_payload(&buf->vbuf.vb2_buf, 0, zr->buffer_size);
 		vb2_buffer_done(&buf->vbuf.vb2_buf, VB2_BUF_STATE_DONE);
 		zr->inuse[0] = NULL;
@@ -928,6 +934,7 @@ static int zr_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 		zr->stat_com[j] = cpu_to_le32(1);
 		zr->inuse[j] = NULL;
 	}
+	zr->vbseq = 0;
 
 	if (zr->map_mode != ZORAN_MAP_MODE_RAW) {
 		pci_info(zr->pci_dev, "START JPG\n");
@@ -1018,7 +1025,7 @@ int zoran_queue_init(struct zoran *zr, struct vb2_queue *vq, int dir)
 	vq->dev = &zr->pci_dev->dev;
 	vq->type = dir;
 
-	vq->io_modes = VB2_USERPTR | VB2_DMABUF | VB2_MMAP | VB2_READ | VB2_WRITE;
+	vq->io_modes = VB2_DMABUF | VB2_MMAP | VB2_READ | VB2_WRITE;
 	vq->drv_priv = zr;
 	vq->buf_struct_size = sizeof(struct zr_buffer);
 	vq->ops = &zr_video_qops;
-- 
2.34.1


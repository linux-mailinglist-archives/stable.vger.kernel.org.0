Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7194F2776
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbiDEIGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235656AbiDEH77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A978A1CB0C;
        Tue,  5 Apr 2022 00:57:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58120B81B14;
        Tue,  5 Apr 2022 07:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A031C340EE;
        Tue,  5 Apr 2022 07:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145422;
        bh=Ps1nATeswKaRTByy9Vpj0FarmADqO69/M4NEGtVD1Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBoC1ewtbZZLDJS19fX52dKXgejzHg1yfKXkxlrkcNnY0BU1CVOjTnOsKJVw9G4oy
         yU0yYLgg3RDjcanHFirAptUnMGQReK9JAmRKbykdf/zcawWdamu9WsI3Q8UN2tqSxb
         9Q/+H2IE2d9adtkyGm5KIHG9XtyFBwaW5aPutmgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Martin Dauskardt <martin.dauskardt@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0400/1126] ivtv: fix incorrect device_caps for ivtvfb
Date:   Tue,  5 Apr 2022 09:19:07 +0200
Message-Id: <20220405070419.368281582@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 25e94139218c0293b4375233c14f2256d7dcfaa8 ]

The VIDIOC_G_FBUF and related overlay ioctls no longer worked (-ENOTTY was
returned).

The root cause was the introduction of the caps field in ivtv-driver.h.
While loading the ivtvfb module would update the video_device device_caps
field with V4L2_CAP_VIDEO_OUTPUT_OVERLAY it would not update that caps
field, and that's what the overlay ioctls would look at.

It's a bad idea to keep information in two places, so drop the caps field
and only use vdev.device_caps.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Martin Dauskardt <martin.dauskardt@gmx.de>
Fixes: 2161536516ed (media: media/pci: set device_caps in struct video_device)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ivtv/ivtv-driver.h  |  1 -
 drivers/media/pci/ivtv/ivtv-ioctl.c   | 10 +++++-----
 drivers/media/pci/ivtv/ivtv-streams.c | 11 ++++-------
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-driver.h b/drivers/media/pci/ivtv/ivtv-driver.h
index 4cf92dee6527..ce3a7ca51736 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.h
+++ b/drivers/media/pci/ivtv/ivtv-driver.h
@@ -330,7 +330,6 @@ struct ivtv_stream {
 	struct ivtv *itv;		/* for ease of use */
 	const char *name;		/* name of the stream */
 	int type;			/* stream type */
-	u32 caps;			/* V4L2 capabilities */
 
 	struct v4l2_fh *fh;		/* pointer to the streaming filehandle */
 	spinlock_t qlock;		/* locks access to the queues */
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 0cdf6b3210c2..fee460e2ca86 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -438,7 +438,7 @@ static int ivtv_g_fmt_vid_out_overlay(struct file *file, void *fh, struct v4l2_f
 	struct ivtv_stream *s = &itv->streams[fh2id(fh)->type];
 	struct v4l2_window *winfmt = &fmt->fmt.win;
 
-	if (!(s->caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
+	if (!(s->vdev.device_caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
 		return -EINVAL;
 	if (!itv->osd_video_pbase)
 		return -EINVAL;
@@ -549,7 +549,7 @@ static int ivtv_try_fmt_vid_out_overlay(struct file *file, void *fh, struct v4l2
 	u32 chromakey = fmt->fmt.win.chromakey;
 	u8 global_alpha = fmt->fmt.win.global_alpha;
 
-	if (!(s->caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
+	if (!(s->vdev.device_caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
 		return -EINVAL;
 	if (!itv->osd_video_pbase)
 		return -EINVAL;
@@ -1383,7 +1383,7 @@ static int ivtv_g_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *fb)
 		0,
 	};
 
-	if (!(s->caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
+	if (!(s->vdev.device_caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
 		return -ENOTTY;
 	if (!itv->osd_video_pbase)
 		return -ENOTTY;
@@ -1450,7 +1450,7 @@ static int ivtv_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuffe
 	struct ivtv_stream *s = &itv->streams[fh2id(fh)->type];
 	struct yuv_playback_info *yi = &itv->yuv_info;
 
-	if (!(s->caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
+	if (!(s->vdev.device_caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
 		return -ENOTTY;
 	if (!itv->osd_video_pbase)
 		return -ENOTTY;
@@ -1470,7 +1470,7 @@ static int ivtv_overlay(struct file *file, void *fh, unsigned int on)
 	struct ivtv *itv = id->itv;
 	struct ivtv_stream *s = &itv->streams[fh2id(fh)->type];
 
-	if (!(s->caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
+	if (!(s->vdev.device_caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
 		return -ENOTTY;
 	if (!itv->osd_video_pbase)
 		return -ENOTTY;
diff --git a/drivers/media/pci/ivtv/ivtv-streams.c b/drivers/media/pci/ivtv/ivtv-streams.c
index 6e455948cc77..13d7d55e6594 100644
--- a/drivers/media/pci/ivtv/ivtv-streams.c
+++ b/drivers/media/pci/ivtv/ivtv-streams.c
@@ -176,7 +176,7 @@ static void ivtv_stream_init(struct ivtv *itv, int type)
 	s->itv = itv;
 	s->type = type;
 	s->name = ivtv_stream_info[type].name;
-	s->caps = ivtv_stream_info[type].v4l2_caps;
+	s->vdev.device_caps = ivtv_stream_info[type].v4l2_caps;
 
 	if (ivtv_stream_info[type].pio)
 		s->dma = DMA_NONE;
@@ -299,12 +299,9 @@ static int ivtv_reg_dev(struct ivtv *itv, int type)
 		if (s_mpg->vdev.v4l2_dev)
 			num = s_mpg->vdev.num + ivtv_stream_info[type].num_offset;
 	}
-	s->vdev.device_caps = s->caps;
-	if (itv->osd_video_pbase) {
-		itv->streams[IVTV_DEC_STREAM_TYPE_YUV].vdev.device_caps |=
-			V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
-		itv->streams[IVTV_DEC_STREAM_TYPE_MPG].vdev.device_caps |=
-			V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
+	if (itv->osd_video_pbase && (type == IVTV_DEC_STREAM_TYPE_YUV ||
+				     type == IVTV_DEC_STREAM_TYPE_MPG)) {
+		s->vdev.device_caps |= V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
 		itv->v4l2_cap |= V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
 	}
 	video_set_drvdata(&s->vdev, s);
-- 
2.34.1




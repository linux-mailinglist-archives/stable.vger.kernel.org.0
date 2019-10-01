Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D27DC41A5
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 22:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfJAUQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 16:16:20 -0400
Received: from www.linuxtv.org ([130.149.80.248]:48132 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfJAUQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 16:16:20 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1iFOZF-0005n0-R0; Tue, 01 Oct 2019 20:16:17 +0000
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Tue, 01 Oct 2019 19:54:55 +0000
Subject: [git:media_tree/master] media: vivid: Set vid_cap_streaming and vid_out_streaming to true
To:     linuxtv-commits@linuxtv.org
Cc:     Vandana BN <bnvandana@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1iFOZF-0005n0-R0@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: vivid: Set vid_cap_streaming and vid_out_streaming to true
Author:  Vandana BN <bnvandana@gmail.com>
Date:    Mon Sep 9 06:43:31 2019 -0300

When vbi stream is started, followed by video streaming,
the vid_cap_streaming and vid_out_streaming were not being set to true,
which would cause the video stream to stop when vbi stream is stopped.
This patch allows to set vid_cap_streaming and vid_out_streaming to true.
According to Hans Verkuil it appears that these 'if (dev->kthread_vid_cap)'
checks are a left-over from the original vivid development and should never
have been there.

Signed-off-by: Vandana BN <bnvandana@gmail.com>
Cc: <stable@vger.kernel.org>      # for v3.18 and up
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 drivers/media/platform/vivid/vivid-vid-cap.c | 3 ---
 drivers/media/platform/vivid/vivid-vid-out.c | 3 ---
 2 files changed, 6 deletions(-)

---

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 8cbaa0c998ed..2d030732feac 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -223,9 +223,6 @@ static int vid_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 	if (vb2_is_streaming(&dev->vb_vid_out_q))
 		dev->can_loop_video = vivid_vid_can_loop(dev);
 
-	if (dev->kthread_vid_cap)
-		return 0;
-
 	dev->vid_cap_seq_count = 0;
 	dprintk(dev, 1, "%s\n", __func__);
 	for (i = 0; i < VIDEO_MAX_FRAME; i++)
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 148b663a6075..a0364ac497f9 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -161,9 +161,6 @@ static int vid_out_start_streaming(struct vb2_queue *vq, unsigned count)
 	if (vb2_is_streaming(&dev->vb_vid_cap_q))
 		dev->can_loop_video = vivid_vid_can_loop(dev);
 
-	if (dev->kthread_vid_out)
-		return 0;
-
 	dev->vid_out_seq_count = 0;
 	dprintk(dev, 1, "%s\n", __func__);
 	if (dev->start_streaming_error) {

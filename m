Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8405FF5E09
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 09:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbfKIILN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 03:11:13 -0500
Received: from www.linuxtv.org ([130.149.80.248]:46128 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbfKIILN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 03:11:13 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1iTLpu-0002zX-92; Sat, 09 Nov 2019 08:11:10 +0000
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Sat, 09 Nov 2019 08:08:30 +0000
Subject: [git:media_tree/master] media: venus: remove invalid compat_ioctl32 handler
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1iTLpu-0002zX-92@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: venus: remove invalid compat_ioctl32 handler
Author:  Arnd Bergmann <arnd@arndb.de>
Date:    Wed Nov 6 10:06:54 2019 +0100

v4l2_compat_ioctl32() is the function that calls into
v4l2_file_operations->compat_ioctl32(), so setting that back to the same
function leads to a trivial endless loop, followed by a kernel
stack overrun.

Remove the incorrect assignment.

Cc: stable@vger.kernel.org
Fixes: 7472c1c69138 ("[media] media: venus: vdec: add video decoder files")
Fixes: aaaa93eda64b ("[media] media: venus: venc: add video encoder files")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 drivers/media/platform/qcom/venus/vdec.c | 3 ---
 drivers/media/platform/qcom/venus/venc.c | 3 ---
 2 files changed, 6 deletions(-)

---

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 3bd6d5030598..8feaf5daece9 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1416,9 +1416,6 @@ static const struct v4l2_file_operations vdec_fops = {
 	.unlocked_ioctl = video_ioctl2,
 	.poll = v4l2_m2m_fop_poll,
 	.mmap = v4l2_m2m_fop_mmap,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl32 = v4l2_compat_ioctl32,
-#endif
 };
 
 static int vdec_probe(struct platform_device *pdev)
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 501fb8ca55fb..453edf966d4f 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1239,9 +1239,6 @@ static const struct v4l2_file_operations venc_fops = {
 	.unlocked_ioctl = video_ioctl2,
 	.poll = v4l2_m2m_fop_poll,
 	.mmap = v4l2_m2m_fop_mmap,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl32 = v4l2_compat_ioctl32,
-#endif
 };
 
 static int venc_probe(struct platform_device *pdev)

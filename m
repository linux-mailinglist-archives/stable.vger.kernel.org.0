Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 814FFF67CE
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 07:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfKJGmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 01:42:51 -0500
Received: from www.linuxtv.org ([130.149.80.248]:56077 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbfKJGmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Nov 2019 01:42:51 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1iTgvx-0005GO-40; Sun, 10 Nov 2019 06:42:49 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Tue, 05 Nov 2019 11:50:02 +0000
Subject: [git:media_tree/master] media: bdisp: fix memleak on release
To:     linuxtv-commits@linuxtv.org
Cc:     stable <stable@vger.kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Johan Hovold <johan@kernel.org>,
        Fabien Dessenne <fabien.dessenne@st.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1iTgvx-0005GO-40@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: bdisp: fix memleak on release
Author:  Johan Hovold <johan@kernel.org>
Date:    Thu Oct 10 10:13:31 2019 -0300

If a process is interrupted while accessing the video device and the
device lock is contended, release() could return early and fail to free
related resources.

Note that the return value of the v4l2 release file operation is
ignored.

Fixes: 28ffeebbb7bd ("[media] bdisp: 2D blitter driver using v4l2 mem2mem framework")
Cc: stable <stable@vger.kernel.org>     # 4.2
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Fabien Dessenne <fabien.dessenne@st.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/media/platform/sti/bdisp/bdisp-v4l2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

---

diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index e90f1ba30574..675b5f2b4c2e 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -651,8 +651,7 @@ static int bdisp_release(struct file *file)
 
 	dev_dbg(bdisp->dev, "%s\n", __func__);
 
-	if (mutex_lock_interruptible(&bdisp->lock))
-		return -ERESTARTSYS;
+	mutex_lock(&bdisp->lock);
 
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 

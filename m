Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8505DCAAEB
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404509AbfJCRPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391026AbfJCQ0J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:26:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E6D52133F;
        Thu,  3 Oct 2019 16:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119969;
        bh=dojeDYxDcSaMAmdiQPqZM0xxtY9cfX6MMKaYkfr+Zbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CidUrJPMFZ9cRlU/aBTpEhMpPc8a383ipNhZY5/oSU/Yt/hMGWjo7IzX2vZ515S1N
         VYuKKy62RrDqVxAsPX+TLvNxUIxdhw1WfzjUfdBAQVO5f/Cs1xDb3aI14Q682UYAcG
         1p7bHeXGtPn3hiEwMXfD8C+UR9En7H9vv2VWVIWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Tretter <m.tretter@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 049/313] media: vb2: reorder checks in vb2_poll()
Date:   Thu,  3 Oct 2019 17:50:27 +0200
Message-Id: <20191003154537.945046902@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Tretter <m.tretter@pengutronix.de>

[ Upstream commit 8d86a15649957c182e90fa2b1267c16699bc12f1 ]

When reaching the end of stream, V4L2 clients may expect the
V4L2_EOS_EVENT before being able to dequeue the last buffer, which has
the V4L2_BUF_FLAG_LAST flag set.

If the vb2_poll() function first checks for events and afterwards if
buffers are available, a driver can queue the V4L2_EOS_EVENT event and
return the buffer after the check for events but before the check for
buffers. This causes vb2_poll() to signal that the buffer with
V4L2_BUF_FLAG_LAST can be read without the V4L2_EOS_EVENT being
available.

First, check for available buffers and afterwards for events to ensure
that if vb2_poll() signals POLLIN | POLLRDNORM for the
V4L2_BUF_FLAG_LAST buffer, it also signals POLLPRI for the
V4L2_EOS_EVENT.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index fb9ac7696fc6e..bd9bfeee385fb 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -872,17 +872,19 @@ EXPORT_SYMBOL_GPL(vb2_queue_release);
 __poll_t vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 {
 	struct video_device *vfd = video_devdata(file);
-	__poll_t res = 0;
+	__poll_t res;
+
+	res = vb2_core_poll(q, file, wait);
 
 	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
 		struct v4l2_fh *fh = file->private_data;
 
 		poll_wait(file, &fh->wait, wait);
 		if (v4l2_event_pending(fh))
-			res = EPOLLPRI;
+			res |= EPOLLPRI;
 	}
 
-	return res | vb2_core_poll(q, file, wait);
+	return res;
 }
 EXPORT_SYMBOL_GPL(vb2_poll);
 
-- 
2.20.1




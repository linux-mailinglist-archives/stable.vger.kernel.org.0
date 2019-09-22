Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 914C4BA5B1
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388930AbfIVSpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388919AbfIVSpD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:45:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19AAE21D7F;
        Sun, 22 Sep 2019 18:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177902;
        bh=YRxLwZTD2kyRklJzSvxmQ6ggHmLqbT6T6h2wJ2/43pQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJzkjo2BqLxh0Re+Tnf+rybnnci1L/xMY/gVeU1ddAJkgLW7ykm2QQ30ith0CDhP3
         CNgg+orYejNHef5kT0+eTtNG3ItV8yikUUpAXYSQKgnITHd0wL/UaeBDLfTF3xTA4V
         8leYdk6GaxP7Y5NoXj3ONgES/xITtg65lgJeJUyI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Tretter <m.tretter@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 020/203] media: vb2: reorder checks in vb2_poll()
Date:   Sun, 22 Sep 2019 14:40:46 -0400
Message-Id: <20190922184350.30563-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 40d76eb4c2fe7..5a9ba3846f0a5 100644
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


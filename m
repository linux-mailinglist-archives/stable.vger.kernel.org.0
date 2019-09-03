Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13FB5A7027
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731051AbfICQhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730699AbfICQ0n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C097023789;
        Tue,  3 Sep 2019 16:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528002;
        bh=SebfApjkwn1FtARA0bW+W3QhdPA0kSbofoRWILz9//k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exo/CpjhndAhqYDRinw3Nn8NFh+8It3G8hqp6KRMFkqTRvuW1gYAxJkctfWRYQ3yi
         6XZysL7gyVqlr+tajulalyj+MYUN3p+hxlnv8ZCa+M8RzTlOpcelNXZYl1b6r+g35q
         03MbKVV6oGR4Ica8J7WEeFfKOhGLBYvwl6d/Rvx8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 048/167] media: vim2m: only cancel work if it is for right context
Date:   Tue,  3 Sep 2019 12:23:20 -0400
Message-Id: <20190903162519.7136-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>

[ Upstream commit 240809ef6630a4ce57c273c2d79ffb657cd361eb ]

cancel_delayed_work_sync() was called for any queue, but it should only
be called for the queue that is associated with the currently running job.

Otherwise, if two filehandles are streaming at the same time, then closing the
first will cancel the work which might still be running for a job from the
second filehandle. As a result the second filehandle will never be able to
finish the job and an attempt to stop streaming on that second filehandle will
stall.

Fixes: 52117be68b82 ("media: vim2m: use cancel_delayed_work_sync instead of flush_schedule_work")

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>      # for v4.20 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vim2m.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index de7f9fe7e7cd9..7b8cf661f2386 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -801,7 +801,9 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
 	struct vb2_v4l2_buffer *vbuf;
 	unsigned long flags;
 
-	cancel_delayed_work_sync(&dev->work_run);
+	if (v4l2_m2m_get_curr_priv(dev->m2m_dev) == ctx)
+		cancel_delayed_work_sync(&dev->work_run);
+
 	for (;;) {
 		if (V4L2_TYPE_IS_OUTPUT(q->type))
 			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
-- 
2.20.1


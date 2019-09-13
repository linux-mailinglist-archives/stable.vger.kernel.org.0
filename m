Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E528B1F11
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389703AbfIMNPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388516AbfIMNP2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:15:28 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93F58214AE;
        Fri, 13 Sep 2019 13:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380528;
        bh=vTdVsNPKkUlHm6AOYAvlhxqREr7KE/SfGvR4OKX7EOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dxi3X4U+xTy2L2XvbDZKuc4zJJZ2oKCuJnUwkEhuq3xbVlAqZ8MT+aXBVOQ6RUXk6
         0T2xvo3OkRnCfrM5nSJpYI4FEqJiNcfhy+B/R53ZHe/WoQ2uy/tGgWHiP0inQlhTBo
         aJiqfi830CLS5oOvXX/ILq4AVbSsJvDsSZIKUmJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 075/190] media: vim2m: only cancel work if it is for right context
Date:   Fri, 13 Sep 2019 14:05:30 +0100
Message-Id: <20190913130605.553804911@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6B0B2005
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389405AbfIMNNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:13:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389400AbfIMNNt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:13:49 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D01C20CC7;
        Fri, 13 Sep 2019 13:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380428;
        bh=t78fak2R3hbe2qC8ZGzJ96szizI5PDtkkaJ2FnNMvBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6DqiIfhs+bJFqYFRWmCuwzcAN5uk6L2EuiYtgJ6SlCpOfHh7obPKpJPdvjIWS6d+
         4xQaBucIgmDZowIjr3Zooazeo3PiO0GJwXhfsFMhZa/xTrH4GZSDyZzdMO1MXSlkpM
         +j79L//CXd/BqVWlAupLnY4KfrBbU3XTS9eMPi/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+69780d144754b8071f4b@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/190] media: vim2m: use cancel_delayed_work_sync instead of flush_schedule_work
Date:   Fri, 13 Sep 2019 14:05:16 +0100
Message-Id: <20190913130604.633527485@linuxfoundation.org>
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

[ Upstream commit 52117be68b82ee05c96da0a7beec319906ccf6cc ]

The use of flush_schedule_work() made no sense and caused a syzkaller error.
Replace with the correct cancel_delayed_work_sync().

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: syzbot+69780d144754b8071f4b@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>      # for v4.20 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vim2m.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 6f87ef025ff19..de7f9fe7e7cd9 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -797,10 +797,11 @@ static int vim2m_start_streaming(struct vb2_queue *q, unsigned count)
 static void vim2m_stop_streaming(struct vb2_queue *q)
 {
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(q);
+	struct vim2m_dev *dev = ctx->dev;
 	struct vb2_v4l2_buffer *vbuf;
 	unsigned long flags;
 
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&dev->work_run);
 	for (;;) {
 		if (V4L2_TYPE_IS_OUTPUT(q->type))
 			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
-- 
2.20.1




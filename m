Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 219DE13EE3D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395004AbgAPSHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:07:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393394AbgAPRi4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:38:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E22EF246C3;
        Thu, 16 Jan 2020 17:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196335;
        bh=RxwM+6dQQiPlDK/OlqLM0wNGJJ+mVuVkfE7h3sIO5Yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQyCYORMZGDZ9WrCSfpK5hqhb7JKSsMPqGbFE7C1YPOarFijNfRxbVS82dEsH2K1h
         L/vcsH2E5JrDgFCaDXaKnycK42jCspk2L9Ryscb69VVEeDfpeTcJ4F75Qnc+O6aFrd
         FzNLjjmR1NZXyiFfQAMu0rHngJgUw0zrR7l4hiLI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 134/251] media: omap_vout: potential buffer overflow in vidioc_dqbuf()
Date:   Thu, 16 Jan 2020 12:34:43 -0500
Message-Id: <20200116173641.22137-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit dd6e2a981bfe83aa4a493143fd8cf1edcda6c091 ]

The "b->index" is a u32 the comes from the user in the ioctl.  It hasn't
been checked.  We aren't supposed to use it but we're instead supposed
to use the value that gets written to it when we call videobuf_dqbuf().

The videobuf_dqbuf() first memsets it to zero and then re-initializes it
inside the videobuf_status() function.  It's this final value which we
want.

Hans Verkuil pointed out that we need to check the return from
videobuf_dqbuf().  I ended up doing a little cleanup related to that as
well.

Fixes: 72915e851da9 ("[media] V4L2: OMAP: VOUT: dma map and unmap v4l2 buffers in qbuf and dqbuf")

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/omap/omap_vout.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index a31b95cb3b09..77ec70f5fef6 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -1526,23 +1526,20 @@ static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 	unsigned long size;
 	struct videobuf_buffer *vb;
 
-	vb = q->bufs[b->index];
-
 	if (!vout->streaming)
 		return -EINVAL;
 
-	if (file->f_flags & O_NONBLOCK)
-		/* Call videobuf_dqbuf for non blocking mode */
-		ret = videobuf_dqbuf(q, (struct v4l2_buffer *)b, 1);
-	else
-		/* Call videobuf_dqbuf for  blocking mode */
-		ret = videobuf_dqbuf(q, (struct v4l2_buffer *)b, 0);
+	ret = videobuf_dqbuf(q, b, !!(file->f_flags & O_NONBLOCK));
+	if (ret)
+		return ret;
+
+	vb = q->bufs[b->index];
 
 	addr = (unsigned long) vout->buf_phy_addr[vb->i];
 	size = (unsigned long) vb->size;
 	dma_unmap_single(vout->vid_dev->v4l2_dev.dev,  addr,
 				size, DMA_TO_DEVICE);
-	return ret;
+	return 0;
 }
 
 static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
-- 
2.20.1


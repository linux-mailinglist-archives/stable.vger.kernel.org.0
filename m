Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA4EB925D
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388374AbfITOcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:32:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36690 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388334AbfITOZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:13 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqP-0004y7-Kz; Fri, 20 Sep 2019 15:25:09 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqF-0007vP-Sc; Fri, 20 Sep 2019 15:24:59 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        "Hans Verkuil" <hverkuil-cisco@xs4all.nl>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.127004184@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 085/132] media: omap_vout: potential buffer overflow
 in vidioc_dqbuf()
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit dd6e2a981bfe83aa4a493143fd8cf1edcda6c091 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/platform/omap/omap_vout.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -1596,23 +1596,20 @@ static int vidioc_dqbuf(struct file *fil
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


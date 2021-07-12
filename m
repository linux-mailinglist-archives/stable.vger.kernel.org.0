Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BD63C4851
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236832AbhGLGhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235244AbhGLGgb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:36:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C897D610A6;
        Mon, 12 Jul 2021 06:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071593;
        bh=TaoS9g5TrRsUhghe3xa90/jrdsLyfglBekaPaQsb4d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pD0izl3ub+gUXdLh5qcXRkqVal8D8darechDSweH3N48E2CkOND0u1HfOfB6QZMrQ
         HB8XrbhzScXgiGZi3QwgFijZChEvbbsGc7oiwkwMDE2yp+gUn/9W88Sa6pa9CqAo9b
         SQoXYS6+i4x9fHYfq7QbFi5LdCCnBi/65MUwIe9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/593] media: cedrus: Fix .buf_prepare
Date:   Mon, 12 Jul 2021 08:04:56 +0200
Message-Id: <20210712060858.067072501@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

[ Upstream commit d84b9202d712309840f8b5abee0ed272506563bd ]

The driver should only set the payload on .buf_prepare if the
buffer is CAPTURE type. If an OUTPUT buffer has a zero bytesused
set by userspace then v4l2-core will set it to buffer length.

If we overwrite bytesused for OUTPUT buffers, too, then
vb2_get_plane_payload() will return incorrect value which might be then
written to hw registers by the driver in cedrus_h264.c or cedrus_vp8.c.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus_video.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index 911f607d9b09..16327be904d1 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -449,7 +449,13 @@ static int cedrus_buf_prepare(struct vb2_buffer *vb)
 	if (vb2_plane_size(vb, 0) < pix_fmt->sizeimage)
 		return -EINVAL;
 
-	vb2_set_plane_payload(vb, 0, pix_fmt->sizeimage);
+	/*
+	 * Buffer's bytesused must be written by driver for CAPTURE buffers.
+	 * (for OUTPUT buffers, if userspace passes 0 bytesused, v4l2-core sets
+	 * it to buffer length).
+	 */
+	if (V4L2_TYPE_IS_CAPTURE(vq->type))
+		vb2_set_plane_payload(vb, 0, pix_fmt->sizeimage);
 
 	return 0;
 }
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D52F3BB131
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhGDXLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232113AbhGDXKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48AA061941;
        Sun,  4 Jul 2021 23:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440033;
        bh=v4eR9eBfNJKTlaalPEbz0PmDz4ulYk8/v1YOXOn6Qy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGll1PnmWQGvmoLqXvhUs9ih9ftKqj4Svp2XG9r/RbP4ncJSsjCOafQWa2hSUP+R9
         3UUDDPotFgOc+w/wtj1xdZhGFiYmMX9Kp6TEHpNevNVashJxFskJswkDcXPloVYuSp
         YuE9NTP+pvq6VuyxBAdIYwEMhywtP1K65Zp47yOImahCaZ5YLRNk+Ck9+o8q0FmyCx
         hmhjooNrlcmIPstxZLC7fkHJcTBACNa2w8Y6RSAEhGVARD4Vy9xgzs7F7U2eZQiGeL
         J0O9QGDFQj+b73OrGy4AtQsmto2BRBHoRYL+0b1HxgQv3xYK0n58MCgIGxhJoCcSDG
         gv+iSaf6CpJ4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: [PATCH AUTOSEL 5.12 41/80] media: cedrus: Fix .buf_prepare
Date:   Sun,  4 Jul 2021 19:05:37 -0400
Message-Id: <20210704230616.1489200-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b62eb8e84057..bf731caf2ed5 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -457,7 +457,13 @@ static int cedrus_buf_prepare(struct vb2_buffer *vb)
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


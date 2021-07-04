Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0953BB215
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhGDXNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230458AbhGDXMy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:12:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F2A96195E;
        Sun,  4 Jul 2021 23:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440135;
        bh=HlMWwFUjkv9kRDxxoRQ0bxzJXMOvK+avXOn8miRFB+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6RTZu2VR9Eb23t4ojSzjY5Ivg1lxIvj1mvbtiiZj1Tf8yoy9ysNQoc7o+0fUPVbk
         pB+zE6+fDWAK6bS4rNk1UqC+sy7XUDm299+TjWv+d0D2gEQ0AupxgLJt3Ep86UV20u
         pENoKK5zm+pbq//T5ZJO8ZKKm/l6XNeZ2SaaTZkaL9MXvJaDGJ6WbUEYXUdlrFKnwK
         DXseSVzdkRmoS97//ieZ41i2/Tr7VyN9Y3vEbN0+dHYUVYI8Tf0YuU69VM7iR2wPxR
         ETxNYT+STZ74cHAIsWg37D54uhC5n1Wr7TUo2fsg8M53a9T6i0ALW4998CiueRsxTl
         aHdt7jafDCw/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-rockchip@lists.infradead.org, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 37/70] media: hantro: Fix .buf_prepare
Date:   Sun,  4 Jul 2021 19:07:30 -0400
Message-Id: <20210704230804.1490078-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

[ Upstream commit 082aaecff35fbe1937531057911b1dd1fc6b496e ]

The driver should only set the payload on .buf_prepare if the
buffer is CAPTURE type. If an OUTPUT buffer has a zero bytesused
set by userspace then v4l2-core will set it to buffer length.

If we overwrite bytesused for OUTPUT buffers, too, then
vb2_get_plane_payload() will return incorrect value which might be then
written to hw registers by the driver in hantro_g1_h264_dec.c.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_v4l2.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/hantro/hantro_v4l2.c b/drivers/staging/media/hantro/hantro_v4l2.c
index f5fbdbc4ffdb..5c2ca61add8e 100644
--- a/drivers/staging/media/hantro/hantro_v4l2.c
+++ b/drivers/staging/media/hantro/hantro_v4l2.c
@@ -639,7 +639,14 @@ static int hantro_buf_prepare(struct vb2_buffer *vb)
 	ret = hantro_buf_plane_check(vb, pix_fmt);
 	if (ret)
 		return ret;
-	vb2_set_plane_payload(vb, 0, pix_fmt->plane_fmt[0].sizeimage);
+	/*
+	 * Buffer's bytesused must be written by driver for CAPTURE buffers.
+	 * (for OUTPUT buffers, if userspace passes 0 bytesused, v4l2-core sets
+	 * it to buffer length).
+	 */
+	if (V4L2_TYPE_IS_CAPTURE(vq->type))
+		vb2_set_plane_payload(vb, 0, pix_fmt->plane_fmt[0].sizeimage);
+
 	return 0;
 }
 
-- 
2.30.2


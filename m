Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47173C4D12
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242211AbhGLHLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243941AbhGLHKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0E8A6128C;
        Mon, 12 Jul 2021 07:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073530;
        bh=Q6uplDChbEBqte+TK32Zhd+p4+vSYHTt4Dj9koKMMvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=04U05or+PJOubIlmUfeCkpfISQrUviSPpFGw3jDEzxN6zKH+f1L8zgTaIhHr2GXxN
         MVzXpFMWOE1LQpyLiSVZAgj99sqZBUT8Cv963l7WB8JjLwcGqbKKapQzUpRiwCRag3
         BgSpamvjS35yEcHWx68bQzpfBlmD8bC23+CpyQo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 274/700] media: rkvdec: Fix .buf_prepare
Date:   Mon, 12 Jul 2021 08:05:57 +0200
Message-Id: <20210712061005.413101068@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit ba1ed4ae760a81caf39f54232e089d95157a0dba ]

The driver should only set the payload on .buf_prepare if the
buffer is CAPTURE type. If an OUTPUT buffer has a zero bytesused
set by userspace then v4l2-core will set it to buffer length.

If we overwrite bytesused for OUTPUT buffers, too, then
vb2_get_plane_payload() will return incorrect value which might be then
written to hw registers by the driver in rkvdec-h264.c.

[Changed the comment and used V4L2_TYPE_IS_CAPTURE macro]

Fixes: cd33c830448ba ("media: rkvdec: Add the rkvdec driver")
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Adrian Ratiu <adrian.ratiu@collabora.com>
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkvdec/rkvdec.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/rkvdec/rkvdec.c b/drivers/staging/media/rkvdec/rkvdec.c
index 8c17615f3a7a..7131156c1f2c 100644
--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -481,7 +481,15 @@ static int rkvdec_buf_prepare(struct vb2_buffer *vb)
 		if (vb2_plane_size(vb, i) < sizeimage)
 			return -EINVAL;
 	}
-	vb2_set_plane_payload(vb, 0, f->fmt.pix_mp.plane_fmt[0].sizeimage);
+
+	/*
+	 * Buffer's bytesused must be written by driver for CAPTURE buffers.
+	 * (for OUTPUT buffers, if userspace passes 0 bytesused, v4l2-core sets
+	 * it to buffer length).
+	 */
+	if (V4L2_TYPE_IS_CAPTURE(vq->type))
+		vb2_set_plane_payload(vb, 0, f->fmt.pix_mp.plane_fmt[0].sizeimage);
+
 	return 0;
 }
 
-- 
2.30.2




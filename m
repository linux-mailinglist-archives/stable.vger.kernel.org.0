Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3045D29B7E1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901406AbgJ0P1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797404AbgJ0PXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:23:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 609B22064B;
        Tue, 27 Oct 2020 15:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812202;
        bh=COzXjeP2t5yg39+A+MrUW470iAfirS3n43vG/ABDRUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSiX3+pTzb9asNvAwuQ9+W1X2fhOc5YP7gXKuAyQJlh4SbsmHwNNvo+pSx4VILMqM
         VzWQ3j1Qh69EuotcXZC8QkfKZtQwqj3HLjyD4RKsOSPwIzvo4r+CT/5VmGrA4Rgnhv
         Ifrt7v7fcf6/pobuJ3C5cQtjLDOdxHD6h8Mnl2nM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 127/757] media: hantro: h264: Get the correct fallback reference buffer
Date:   Tue, 27 Oct 2020 14:46:17 +0100
Message-Id: <20201027135456.536573669@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit 6d9e8cd0553bb03e8ab9d4d2d7d17f3fb639bd86 ]

If the bitstream and the application are incorrectly configuring
the reference pictures, the hardware will need to fallback
to using some other reference picture.

When the post-processor is enabled, the fallback buffer
should be a shadow buffer (postproc.dec_q), and not a
CAPTURE queue buffer, since the latter is post-processed
and not really the output of the decoder core.

Fixes: 8c2d66b036c77 ("media: hantro: Support color conversion via post-processing")
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_h264.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/hantro/hantro_h264.c b/drivers/staging/media/hantro/hantro_h264.c
index 194d058480777..6dcd47bd9ed3f 100644
--- a/drivers/staging/media/hantro/hantro_h264.c
+++ b/drivers/staging/media/hantro/hantro_h264.c
@@ -325,7 +325,7 @@ dma_addr_t hantro_h264_get_ref_buf(struct hantro_ctx *ctx,
 		 */
 		dst_buf = hantro_get_dst_buf(ctx);
 		buf = &dst_buf->vb2_buf;
-		dma_addr = vb2_dma_contig_plane_dma_addr(buf, 0);
+		dma_addr = hantro_get_dec_buf_addr(ctx, buf);
 	}
 
 	return dma_addr;
-- 
2.25.1




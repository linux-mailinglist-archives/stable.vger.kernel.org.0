Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53BFA2F4BC
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbfE3ElH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729030AbfE3DM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:28 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BDE623C5A;
        Thu, 30 May 2019 03:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185947;
        bh=BV20e+OC80Fj1qO36WZBQ7yWjyZjhNk+3OIm08cdVsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F8UmVDTDcQMkJBUYM+jpKMkYSf3sFJR6yDmfcfu1sAyiwOgx+CKyo+85dYCSk7Z8a
         7/WBGjLMyhfm3x/XQWu0Xy6oWpvXyz1Zqxs+Upr62I5jvuYZ76lYMOFKEl6IUcXb+m
         w0r8SJ1ZpeXytxy596iS3vW0NCAcfQvArfCbpMNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 357/405] media: mtk-vcodec: fix access to vb2_v4l2_buffer struct
Date:   Wed, 29 May 2019 20:05:55 -0700
Message-Id: <20190530030558.688634539@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3235d3946429f64b19addfd89fc926a36eaec06a ]

Commit 0650a91499e0 ("media: mtk-vcodec: Correct return type for mem2mem
buffer helpers") fixed the return types for mem2mem buffer helper
functions, but omitted two occurrences that are accessed in the
mtk_v4l2_debug() macro. These only trigger compiler errors when DEBUG is
defined.

Fixes: 0650a91499e0 ("media: mtk-vcodec: Correct return type for mem2mem buffer helpers")

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index 49babf994cb75..e20b340855e76 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -1158,7 +1158,7 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 	src_mem.size = (size_t)src_buf->vb2_buf.planes[0].bytesused;
 	mtk_v4l2_debug(2,
 			"[%d] buf id=%d va=%p dma=%pad size=%zx",
-			ctx->id, src_buf->index,
+			ctx->id, src_buf->vb2_buf.index,
 			src_mem.va, &src_mem.dma_addr,
 			src_mem.size);
 
@@ -1182,7 +1182,7 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 		}
 		mtk_v4l2_debug(ret ? 0 : 1,
 			       "[%d] vdec_if_decode() src_buf=%d, size=%zu, fail=%d, res_chg=%d",
-			       ctx->id, src_buf->index,
+			       ctx->id, src_buf->vb2_buf.index,
 			       src_mem.size, ret, res_chg);
 		return;
 	}
-- 
2.20.1




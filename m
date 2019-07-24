Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA31373D8F
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391507AbfGXTtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:49:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391503AbfGXTtW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:49:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 449F520659;
        Wed, 24 Jul 2019 19:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997761;
        bh=Kkvq8HF2PdQJOysh0E/srbZf1ptLqlyUIzHkyNKcgBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTvLdFehdm6TY5ELhI2sRIgskV9TyN8RFc//1ql1oQgWZqKNFVCdLWh6M+pZ89PTd
         armyCwvhbPF5ERMpjKlY+rUNjFSq4I08aCo6khEdBh6//dTEwCbC+GURsU2rzqZt9B
         C8lTeVF8I16qeAPyMWVVqa4z9g+4L5XUXH9FMh3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 135/371] media: coda: fix mpeg2 sequence number handling
Date:   Wed, 24 Jul 2019 21:18:07 +0200
Message-Id: <20190724191735.070786550@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 56d159a4ec6d8da7313aac6fcbb95d8fffe689ba ]

Sequence number handling assumed that the BIT processor frame number
starts counting at 1, but this is not true for the MPEG-2 decoder,
which starts at 0. Fix the sequence counter offset detection to handle
this.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-bit.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index eaa86737fa04..5eb93ac060d5 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1743,6 +1743,7 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 		v4l2_err(&dev->v4l2_dev, "CODA_COMMAND_SEQ_INIT timeout\n");
 		return ret;
 	}
+	ctx->sequence_offset = ~0U;
 	ctx->initialized = 1;
 
 	/* Update kfifo out pointer from coda bitstream read pointer */
@@ -2155,7 +2156,9 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		v4l2_err(&dev->v4l2_dev,
 			 "decoded frame index out of range: %d\n", decoded_idx);
 	} else {
-		val = coda_read(dev, CODA_RET_DEC_PIC_FRAME_NUM) - 1;
+		val = coda_read(dev, CODA_RET_DEC_PIC_FRAME_NUM);
+		if (ctx->sequence_offset == -1)
+			ctx->sequence_offset = val;
 		val -= ctx->sequence_offset;
 		spin_lock(&ctx->buffer_meta_lock);
 		if (!list_empty(&ctx->buffer_meta_list)) {
-- 
2.20.1




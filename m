Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D15307F430
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404981AbfHBJms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404978AbfHBJmr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:42:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4435120880;
        Fri,  2 Aug 2019 09:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738966;
        bh=s7r6NELEe5AW6tUCCOHo36l4AASce67jjMnPj/LE3pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJUcV2TQfbAGDmraRZ8mf2noH9KJ4wYojoRKG8fU0EftortqmIFy1+Yzx0CMsR/kA
         2s+Xfo9OHxqFd/e2qYUfgiNJ1cda2pgm+09LKjD/c3PXqkDwGBqHrvwGRakgiptWns
         mHdB0Ykq24nHT/Y3NeDZ7uTI+va7JKqET/pfwow4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 050/223] media: coda: fix mpeg2 sequence number handling
Date:   Fri,  2 Aug 2019 11:34:35 +0200
Message-Id: <20190802092242.147357776@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
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
index 717ee9a6a80e..1b8024f86b0f 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1581,6 +1581,7 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 		coda_write(dev, 0, CODA_REG_BIT_BIT_STREAM_PARAM);
 		return -ETIMEDOUT;
 	}
+	ctx->sequence_offset = ~0U;
 	ctx->initialized = 1;
 
 	/* Update kfifo out pointer from coda bitstream read pointer */
@@ -1971,7 +1972,9 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		v4l2_err(&dev->v4l2_dev,
 			 "decoded frame index out of range: %d\n", decoded_idx);
 	} else {
-		val = coda_read(dev, CODA_RET_DEC_PIC_FRAME_NUM) - 1;
+		val = coda_read(dev, CODA_RET_DEC_PIC_FRAME_NUM);
+		if (ctx->sequence_offset == -1)
+			ctx->sequence_offset = val;
 		val -= ctx->sequence_offset;
 		spin_lock_irqsave(&ctx->buffer_meta_lock, flags);
 		if (!list_empty(&ctx->buffer_meta_list)) {
-- 
2.20.1




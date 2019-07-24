Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC94873C0A
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392747AbfGXUFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:05:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392741AbfGXUFp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:05:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD64C214AF;
        Wed, 24 Jul 2019 20:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998745;
        bh=KmkclNezV2op1CgSQtxZTvXyzxMbexaUhsnCHEqFBTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMqVCy/ItwaRfTm9JQ5kniYXBhOHH4D6gfsIvi2aXKr6bBAjMsPykoyj3hmsv/Urr
         DyW+S+NeD8GkgNr3nwe2fFxnas9AHcRDLEeWAwTnOn7jRjAw6Z26pnXuyZiUaLLn5X
         qt8lzbOMsT/t5hwOutlQVwNdW53wKNoWOgzJYgOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/271] media: coda: fix mpeg2 sequence number handling
Date:   Wed, 24 Jul 2019 21:19:28 +0200
Message-Id: <20190724191703.703404229@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
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
index a3cfefdbee12..25ef0c928a81 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1728,6 +1728,7 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 		v4l2_err(&dev->v4l2_dev, "CODA_COMMAND_SEQ_INIT timeout\n");
 		return ret;
 	}
+	ctx->sequence_offset = ~0U;
 	ctx->initialized = 1;
 
 	/* Update kfifo out pointer from coda bitstream read pointer */
@@ -2147,7 +2148,9 @@ static void coda_finish_decode(struct coda_ctx *ctx)
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




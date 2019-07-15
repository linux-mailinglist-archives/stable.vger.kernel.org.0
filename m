Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD6D86955B
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390316AbfGOOXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:23:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390340AbfGOOXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:23:51 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7FE720896;
        Mon, 15 Jul 2019 14:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200631;
        bh=Vch4FLZExbIttm4bnQJbOXv7PFICLBmwk6CJZ9mV89M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/EfPmYuzf+5czc1SoRDQk7fR5UPGR2ZIkfzTggZ0hGx1XicokbjDLYIXMcmzIQkv
         80ZDtqHR20LDEX/1mQCWAYK3KH/QIVBqYa5+wswZQ6wvDwCXBJQz/y3AufYmU8R8Ya
         QJyi4AKE4yd9hXouSHt95uEpGC9jF3tB2gWD1CxA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 097/158] media: coda: fix mpeg2 sequence number handling
Date:   Mon, 15 Jul 2019 10:17:08 -0400
Message-Id: <20190715141809.8445-97-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

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


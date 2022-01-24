Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B911249A930
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322277AbiAYDVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57536 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355506AbiAXUSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:18:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AC4BB81257;
        Mon, 24 Jan 2022 20:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A001C36AE3;
        Mon, 24 Jan 2022 20:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055490;
        bh=RqxmOMV1jbbNks5l2G4rA7iTPry5Lj3BtD4JRhgmkPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LlByAVNuocctxJQrUTYh0BIi+9nCQzlhSIjiFTbnLMEmNNDr268vG42lWzQEKGJwp
         Ivfsr5/gzCcP34BDE9TbIXFuN5tsUa21RGudXRwqZ4/aJieBuXo1O4BMpqjOtZ5Amz
         jVJ08DdYBVSziR2e0zLFu6gftUsr2Q+9WDe5rgIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Weber <martin.weber@br-automation.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 168/846] media: coda: fix CODA960 JPEG encoder buffer overflow
Date:   Mon, 24 Jan 2022 19:34:45 +0100
Message-Id: <20220124184106.770269998@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 1a59cd88f55068710f6549bee548846661673780 ]

Stop the CODA960 JPEG encoder from overflowing capture buffers.
The bitstream buffer overflow interrupt doesn't seem to be connected,
so this has to be handled via timeout instead.

Reported-by: Martin Weber <martin.weber@br-automation.com>
Fixes: 96f6f62c4656 ("media: coda: jpeg: add CODA960 JPEG encoder support")
Tested-by: Martin Weber <martin.weber@br-automation.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-common.c |  8 +++++---
 drivers/media/platform/coda/coda-jpeg.c   | 21 ++++++++++++++++++++-
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 0e312b0842d7f..9a2640a9c75c6 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1537,11 +1537,13 @@ static void coda_pic_run_work(struct work_struct *work)
 
 	if (!wait_for_completion_timeout(&ctx->completion,
 					 msecs_to_jiffies(1000))) {
-		dev_err(dev->dev, "CODA PIC_RUN timeout\n");
+		if (ctx->use_bit) {
+			dev_err(dev->dev, "CODA PIC_RUN timeout\n");
 
-		ctx->hold = true;
+			ctx->hold = true;
 
-		coda_hw_reset(ctx);
+			coda_hw_reset(ctx);
+		}
 
 		if (ctx->ops->run_timeout)
 			ctx->ops->run_timeout(ctx);
diff --git a/drivers/media/platform/coda/coda-jpeg.c b/drivers/media/platform/coda/coda-jpeg.c
index b11cfbe166dd3..a72f4655e5ad5 100644
--- a/drivers/media/platform/coda/coda-jpeg.c
+++ b/drivers/media/platform/coda/coda-jpeg.c
@@ -1127,7 +1127,8 @@ static int coda9_jpeg_prepare_encode(struct coda_ctx *ctx)
 	coda_write(dev, 0, CODA9_REG_JPEG_GBU_BT_PTR);
 	coda_write(dev, 0, CODA9_REG_JPEG_GBU_WD_PTR);
 	coda_write(dev, 0, CODA9_REG_JPEG_GBU_BBSR);
-	coda_write(dev, 0, CODA9_REG_JPEG_BBC_STRM_CTRL);
+	coda_write(dev, BIT(31) | ((end_addr - start_addr - header_len) / 256),
+		   CODA9_REG_JPEG_BBC_STRM_CTRL);
 	coda_write(dev, 0, CODA9_REG_JPEG_GBU_CTRL);
 	coda_write(dev, 0, CODA9_REG_JPEG_GBU_FF_RPTR);
 	coda_write(dev, 127, CODA9_REG_JPEG_GBU_BBER);
@@ -1257,6 +1258,23 @@ static void coda9_jpeg_finish_encode(struct coda_ctx *ctx)
 	coda_hw_reset(ctx);
 }
 
+static void coda9_jpeg_encode_timeout(struct coda_ctx *ctx)
+{
+	struct coda_dev *dev = ctx->dev;
+	u32 end_addr, wr_ptr;
+
+	/* Handle missing BBC overflow interrupt via timeout */
+	end_addr = coda_read(dev, CODA9_REG_JPEG_BBC_END_ADDR);
+	wr_ptr = coda_read(dev, CODA9_REG_JPEG_BBC_WR_PTR);
+	if (wr_ptr >= end_addr - 256) {
+		v4l2_err(&dev->v4l2_dev, "JPEG too large for capture buffer\n");
+		coda9_jpeg_finish_encode(ctx);
+		return;
+	}
+
+	coda_hw_reset(ctx);
+}
+
 static void coda9_jpeg_release(struct coda_ctx *ctx)
 {
 	int i;
@@ -1276,6 +1294,7 @@ const struct coda_context_ops coda9_jpeg_encode_ops = {
 	.start_streaming = coda9_jpeg_start_encoding,
 	.prepare_run = coda9_jpeg_prepare_encode,
 	.finish_run = coda9_jpeg_finish_encode,
+	.run_timeout = coda9_jpeg_encode_timeout,
 	.release = coda9_jpeg_release,
 };
 
-- 
2.34.1




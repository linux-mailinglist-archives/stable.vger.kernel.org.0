Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0276313E1F2
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgAPQwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:52:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgAPQwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:52:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0132205F4;
        Thu, 16 Jan 2020 16:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193552;
        bh=w25Sz8SICwQl+XrqV3Xr7Ksv5FbWlYC8zU9L6OzLX84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+PtpmpXtJKv+UFrPBYbLiNzzKN/NZak7+MJg3dBK7p4rCaHGeCpJWa88HrZTUc6T
         TpMxDkGq/C4oz01EWG+YabBr7kR0PGUOo+u86p40JM8FkX4uoeSKk3nIlVB++CKDVa
         a/ffwNKiZnTz8uTft27j0vqrOfUDf6hHwKgBzKwY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 101/205] media: coda: fix deadlock between decoder picture run and start command
Date:   Thu, 16 Jan 2020 11:41:16 -0500
Message-Id: <20200116164300.6705-101-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit a3fd80198de6ab98a205cf7fb148d88e9e1c44bb ]

The BIT decoder picture run temporarily locks the bitstream mutex while
the coda device mutex is locked, to refill the bitstream ring buffer.
Consequently, the decoder start command, which locks both mutexes when
flushing the bitstream ring buffer, must lock the coda device mutex
first as well, to avoid an ABBA deadlock.

Fixes: e7fd95849b3c ("media: coda: flush bitstream ring buffer on decoder restart")
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 73222c0615c0..834f11fe9dc2 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1084,16 +1084,16 @@ static int coda_decoder_cmd(struct file *file, void *fh,
 
 	switch (dc->cmd) {
 	case V4L2_DEC_CMD_START:
-		mutex_lock(&ctx->bitstream_mutex);
 		mutex_lock(&dev->coda_mutex);
+		mutex_lock(&ctx->bitstream_mutex);
 		coda_bitstream_flush(ctx);
-		mutex_unlock(&dev->coda_mutex);
 		dst_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
 					 V4L2_BUF_TYPE_VIDEO_CAPTURE);
 		vb2_clear_last_buffer_dequeued(dst_vq);
 		ctx->bit_stream_param &= ~CODA_BIT_STREAM_END_FLAG;
 		coda_fill_bitstream(ctx, NULL);
 		mutex_unlock(&ctx->bitstream_mutex);
+		mutex_unlock(&dev->coda_mutex);
 		break;
 	case V4L2_DEC_CMD_STOP:
 		stream_end = false;
-- 
2.20.1


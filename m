Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 599A2119BD4
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbfLJWDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:03:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:34226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728165AbfLJWDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:03:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E3AF214AF;
        Tue, 10 Dec 2019 22:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015429;
        bh=SGz8r9eKX9gBJ68+HikN3ji8vq9hVDcvAiYpnhVEZjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yIY4Xr4IKiZFaO8AYc7dyPYIOSM4IYM599z7OCBRJCPGhmXKN4lXsMuJplOpYnHAd
         PRigRA90Q5r/oqMpdCY6OPkAIrL2RsKz0X0jmvACeU9BGodaj04C1PiPp9FELrLwY9
         1nq1iZbtC4KCuUgIUqCng9xbpxlmP1sWQ7VPKmzI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benoit Parrot <bparrot@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 040/130] media: ti-vpe: vpe: fix a v4l2-compliance failure about invalid sizeimage
Date:   Tue, 10 Dec 2019 17:01:31 -0500
Message-Id: <20191210220301.13262-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benoit Parrot <bparrot@ti.com>

[ Upstream commit 0bac73adea4df8d34048b38f6ff24dc3e73e90b6 ]

v4l2-compliance fails with this message:

   fail: v4l2-test-formats.cpp(463): !pfmt.sizeimage
   fail: v4l2-test-formats.cpp(736): \
	Video Capture Multiplanar is valid, \
	but TRY_FMT failed to return a format
   test VIDIOC_TRY_FMT: FAIL

This failure is causd by the driver failing to handle out range
'bytesperline' values from user space applications.

VPDMA hardware is limited to 64k line stride (16 bytes aligned, so 65520
bytes). So make sure the provided or calculated 'bytesperline' is
smaller than the maximum value.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti-vpe/vpdma.h | 1 +
 drivers/media/platform/ti-vpe/vpe.c   | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
index 7e611501c2916..f29074c849155 100644
--- a/drivers/media/platform/ti-vpe/vpdma.h
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -60,6 +60,7 @@ struct vpdma_data_format {
 						 * line stride of source and dest
 						 * buffers should be 16 byte aligned
 						 */
+#define VPDMA_MAX_STRIDE		65520	/* Max line stride 16 byte aligned */
 #define VPDMA_DTD_DESC_SIZE		32	/* 8 words */
 #define VPDMA_CFD_CTD_DESC_SIZE		16	/* 4 words */
 
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 7af66fe95a542..2e8970c7e22da 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1702,6 +1702,10 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 		if (stride > plane_fmt->bytesperline)
 			plane_fmt->bytesperline = stride;
 
+		plane_fmt->bytesperline = clamp_t(u32, plane_fmt->bytesperline,
+						  stride,
+						  VPDMA_MAX_STRIDE);
+
 		plane_fmt->bytesperline = ALIGN(plane_fmt->bytesperline,
 						VPDMA_STRIDE_ALIGN);
 
-- 
2.20.1


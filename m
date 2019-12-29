Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0738F12C485
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbfL2RaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:30:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728946AbfL2RaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:30:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B36220722;
        Sun, 29 Dec 2019 17:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640620;
        bh=G5oNyWpNmFEsSlsz7KFmJQDCVyjsY8Q9iaSYiYXTJhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMQ1qED9Rk1ZzN3YmWn9/diRM91NSqJZpIpBXjfLWXtoxMXqpnmauViCMxLOf53+0
         3LcQaZ9Ff7kMnHKxBCElbCHAgsyP+U29EuR7m1V0tFImLcQS59KSJEpeI2vwwvJZlr
         Ge3rdoU4UfH0bMwCAoxLrhNmOA4WNW1P5ykpD4vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 070/219] media: ti-vpe: vpe: fix a v4l2-compliance failure about invalid sizeimage
Date:   Sun, 29 Dec 2019 18:17:52 +0100
Message-Id: <20191229162516.981223051@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7e611501c291..f29074c84915 100644
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
index 52d5aebe0fb8..a285b9db7ee8 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1685,6 +1685,10 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
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




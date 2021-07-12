Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B8C3C5260
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346005AbhGLHpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343923AbhGLHno (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:43:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55FE56117A;
        Mon, 12 Jul 2021 07:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075640;
        bh=etad3JAoRPIXjltlF68p6ni082LsitwveM50pBQPlMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nptMPJpNhAKGrhlc+OQkZNS6d9nymAn1YzZXWELg7NbfE/oeVfZ0ZJzW47XKquFOh
         UEgUD5jRfK83fN04/wtrRO8OEmznlBgl+c5m0fe8QzYnmEIp+YxfWPaCFbsgxfBLmE
         xJkiSpm6uf6QiNNAZ88MspYJJLiS8xAsAA++Dyv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Richey <joerichey@google.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 302/800] media: vicodec: Use _BITUL() macro in UAPI headers
Date:   Mon, 12 Jul 2021 08:05:25 +0200
Message-Id: <20210712060957.417955189@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Richey <joerichey@google.com>

[ Upstream commit ce67eaca95f8ab5c6aae41a10adfe9a6e8efa58c ]

Replace BIT() in v4l2's UPAI header with _BITUL(). BIT() is not defined
in the UAPI headers and its usage may cause userspace build errors.

Fixes: 206bc0f6fb94 ("media: vicodec: mark the stateless FWHT API as stable")
Signed-off-by: Joe Richey <joerichey@google.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/v4l2-controls.h | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index d43bec5f1afd..5afc19c68704 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -50,6 +50,7 @@
 #ifndef __LINUX_V4L2_CONTROLS_H
 #define __LINUX_V4L2_CONTROLS_H
 
+#include <linux/const.h>
 #include <linux/types.h>
 
 /* Control classes */
@@ -1602,30 +1603,30 @@ struct v4l2_ctrl_h264_decode_params {
 #define V4L2_FWHT_VERSION			3
 
 /* Set if this is an interlaced format */
-#define V4L2_FWHT_FL_IS_INTERLACED		BIT(0)
+#define V4L2_FWHT_FL_IS_INTERLACED		_BITUL(0)
 /* Set if this is a bottom-first (NTSC) interlaced format */
-#define V4L2_FWHT_FL_IS_BOTTOM_FIRST		BIT(1)
+#define V4L2_FWHT_FL_IS_BOTTOM_FIRST		_BITUL(1)
 /* Set if each 'frame' contains just one field */
-#define V4L2_FWHT_FL_IS_ALTERNATE		BIT(2)
+#define V4L2_FWHT_FL_IS_ALTERNATE		_BITUL(2)
 /*
  * If V4L2_FWHT_FL_IS_ALTERNATE was set, then this is set if this
  * 'frame' is the bottom field, else it is the top field.
  */
-#define V4L2_FWHT_FL_IS_BOTTOM_FIELD		BIT(3)
+#define V4L2_FWHT_FL_IS_BOTTOM_FIELD		_BITUL(3)
 /* Set if the Y' plane is uncompressed */
-#define V4L2_FWHT_FL_LUMA_IS_UNCOMPRESSED	BIT(4)
+#define V4L2_FWHT_FL_LUMA_IS_UNCOMPRESSED	_BITUL(4)
 /* Set if the Cb plane is uncompressed */
-#define V4L2_FWHT_FL_CB_IS_UNCOMPRESSED		BIT(5)
+#define V4L2_FWHT_FL_CB_IS_UNCOMPRESSED		_BITUL(5)
 /* Set if the Cr plane is uncompressed */
-#define V4L2_FWHT_FL_CR_IS_UNCOMPRESSED		BIT(6)
+#define V4L2_FWHT_FL_CR_IS_UNCOMPRESSED		_BITUL(6)
 /* Set if the chroma plane is full height, if cleared it is half height */
-#define V4L2_FWHT_FL_CHROMA_FULL_HEIGHT		BIT(7)
+#define V4L2_FWHT_FL_CHROMA_FULL_HEIGHT		_BITUL(7)
 /* Set if the chroma plane is full width, if cleared it is half width */
-#define V4L2_FWHT_FL_CHROMA_FULL_WIDTH		BIT(8)
+#define V4L2_FWHT_FL_CHROMA_FULL_WIDTH		_BITUL(8)
 /* Set if the alpha plane is uncompressed */
-#define V4L2_FWHT_FL_ALPHA_IS_UNCOMPRESSED	BIT(9)
+#define V4L2_FWHT_FL_ALPHA_IS_UNCOMPRESSED	_BITUL(9)
 /* Set if this is an I Frame */
-#define V4L2_FWHT_FL_I_FRAME			BIT(10)
+#define V4L2_FWHT_FL_I_FRAME			_BITUL(10)
 
 /* A 4-values flag - the number of components - 1 */
 #define V4L2_FWHT_FL_COMPONENTS_NUM_MSK		GENMASK(18, 16)
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94191328A34
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239513AbhCASN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:13:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239197AbhCASHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:07:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 439A96501D;
        Mon,  1 Mar 2021 17:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618717;
        bh=0LQaJDatT3YDnwsGDdgp5WMdhDrI7e+IHtxQjvuU2pQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipPEiyGq/NKfxxFbh5YgJNyr+q56o21+t76GMKC3tAjIETo+Og4IXfOYIAiC0ep5h
         XDWmOkZ+VHbTw0nilqQxITDGrL2df+Pl1tuG3wA2ZSewb5XE/3W+udl4FU82iNXRB7
         O7GCT2MZBPHZYvkX2hVmS2q3M+/ZXDjvLn6E2s8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/663] media: atomisp: Fix a buffer overflow in debug code
Date:   Mon,  1 Mar 2021 17:07:18 +0100
Message-Id: <20210301161151.176045166@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 625993166b551d633917ca35d4afb7b46d7451b4 ]

The "pad" variable is a user controlled string and we haven't properly
clamped it at this point so the debug code could print from beyond the
of the array.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/atomisp/pci/atomisp_subdev.c        | 24 ++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_subdev.c b/drivers/staging/media/atomisp/pci/atomisp_subdev.c
index 52b9fb18c87f0..dcc2dd981ca60 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_subdev.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_subdev.c
@@ -349,12 +349,20 @@ static int isp_subdev_get_selection(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static char *atomisp_pad_str[] = { "ATOMISP_SUBDEV_PAD_SINK",
-				   "ATOMISP_SUBDEV_PAD_SOURCE_CAPTURE",
-				   "ATOMISP_SUBDEV_PAD_SOURCE_VF",
-				   "ATOMISP_SUBDEV_PAD_SOURCE_PREVIEW",
-				   "ATOMISP_SUBDEV_PAD_SOURCE_VIDEO"
-				 };
+static const char *atomisp_pad_str(unsigned int pad)
+{
+	static const char *const pad_str[] = {
+		"ATOMISP_SUBDEV_PAD_SINK",
+		"ATOMISP_SUBDEV_PAD_SOURCE_CAPTURE",
+		"ATOMISP_SUBDEV_PAD_SOURCE_VF",
+		"ATOMISP_SUBDEV_PAD_SOURCE_PREVIEW",
+		"ATOMISP_SUBDEV_PAD_SOURCE_VIDEO",
+	};
+
+	if (pad >= ARRAY_SIZE(pad_str))
+		return "ATOMISP_INVALID_PAD";
+	return pad_str[pad];
+}
 
 int atomisp_subdev_set_selection(struct v4l2_subdev *sd,
 				 struct v4l2_subdev_pad_config *cfg,
@@ -378,7 +386,7 @@ int atomisp_subdev_set_selection(struct v4l2_subdev *sd,
 
 	dev_dbg(isp->dev,
 		"sel: pad %s tgt %s l %d t %d w %d h %d which %s f 0x%8.8x\n",
-		atomisp_pad_str[pad], target == V4L2_SEL_TGT_CROP
+		atomisp_pad_str(pad), target == V4L2_SEL_TGT_CROP
 		? "V4L2_SEL_TGT_CROP" : "V4L2_SEL_TGT_COMPOSE",
 		r->left, r->top, r->width, r->height,
 		which == V4L2_SUBDEV_FORMAT_TRY ? "V4L2_SUBDEV_FORMAT_TRY"
@@ -612,7 +620,7 @@ void atomisp_subdev_set_ffmt(struct v4l2_subdev *sd,
 	enum atomisp_input_stream_id stream_id;
 
 	dev_dbg(isp->dev, "ffmt: pad %s w %d h %d code 0x%8.8x which %s\n",
-		atomisp_pad_str[pad], ffmt->width, ffmt->height, ffmt->code,
+		atomisp_pad_str(pad), ffmt->width, ffmt->height, ffmt->code,
 		which == V4L2_SUBDEV_FORMAT_TRY ? "V4L2_SUBDEV_FORMAT_TRY"
 		: "V4L2_SUBDEV_FORMAT_ACTIVE");
 
-- 
2.27.0




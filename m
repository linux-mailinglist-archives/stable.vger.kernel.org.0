Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69264328F85
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242234AbhCATwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:52:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242195AbhCAToD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B98AF65331;
        Mon,  1 Mar 2021 17:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620641;
        bh=yipmLDPX++Vgs3DyJzfFZI1ob+nU2Nt66N67mLpbWXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXsytlrQyJiHztmOZQ5rkm3FnenD8SQClj3v4gWd6yiR9Md7AtZnbC4SzVi4TzU5r
         NKMwkShpyomMfbuEgq1K7Lt9ZEAt1uO84J0rk7oA7STNFWl2sIagAUg6f/QS9CkT/K
         G+DIa6BiQqqyWJvYJsk3CF/KEmTlqx5ydWNdtec0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 226/775] media: atomisp: Fix a buffer overflow in debug code
Date:   Mon,  1 Mar 2021 17:06:34 +0100
Message-Id: <20210301161212.797422485@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index b666cb23e5ca1..2ef5f44e4b6b6 100644
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




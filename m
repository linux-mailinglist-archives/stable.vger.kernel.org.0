Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8EA12C636
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730448AbfL2Rol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:44:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730718AbfL2Roj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:44:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7387206DB;
        Sun, 29 Dec 2019 17:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641478;
        bh=J3PtyRf/ZI0zepofmBAriBZdow65cwDHi6mKXctDZkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7qRZfatRf5JlS7ErIx76eN8+/QlizKeBzq3zF1Sz4P9P+GZ7TyQsug6cJS//k2pc
         pzRNbvuGr7H5mu6H9XkrHFaaFE2bGQOXU8+TDyd+x1j2quL0HAMqKOqGpIUWwppk01
         wcjB9IaEZobhT9tcMF1msbNwTyvXUN/hkPUJh/MM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/434] media: ov6650: Fix crop rectangle alignment not passed back
Date:   Sun, 29 Dec 2019 18:22:15 +0100
Message-Id: <20191229172707.004767368@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

[ Upstream commit 7b188d6ba27a131e7934a51a14ece331c0491f18 ]

Commit 4f996594ceaf ("[media] v4l2: make vidioc_s_crop const")
introduced a writable copy of constified user requested crop rectangle
in order to be able to perform hardware alignments on it.  Later
on, commit 10d5509c8d50 ("[media] v4l2: remove g/s_crop from video
ops") replaced s_crop() video operation using that const argument with
set_selection() pad operation which had a corresponding argument not
constified, however the original behavior of the driver was not
restored.  Since that time, any hardware alignment applied on a user
requested crop rectangle is not passed back to the user calling
.set_selection() as it should be.

Fix the issue by dropping the copy and replacing all references to it
with references to the crop rectangle embedded in the user argument.

Fixes: 10d5509c8d50 ("[media] v4l2: remove g/s_crop from video ops")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov6650.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index 68776b0710f9..c6af72553258 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -465,38 +465,37 @@ static int ov6650_set_selection(struct v4l2_subdev *sd,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov6650 *priv = to_ov6650(client);
-	struct v4l2_rect rect = sel->r;
 	int ret;
 
 	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
 	    sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
-	v4l_bound_align_image(&rect.width, 2, W_CIF, 1,
-			      &rect.height, 2, H_CIF, 1, 0);
-	v4l_bound_align_image(&rect.left, DEF_HSTRT << 1,
-			      (DEF_HSTRT << 1) + W_CIF - (__s32)rect.width, 1,
-			      &rect.top, DEF_VSTRT << 1,
-			      (DEF_VSTRT << 1) + H_CIF - (__s32)rect.height, 1,
-			      0);
+	v4l_bound_align_image(&sel->r.width, 2, W_CIF, 1,
+			      &sel->r.height, 2, H_CIF, 1, 0);
+	v4l_bound_align_image(&sel->r.left, DEF_HSTRT << 1,
+			      (DEF_HSTRT << 1) + W_CIF - (__s32)sel->r.width, 1,
+			      &sel->r.top, DEF_VSTRT << 1,
+			      (DEF_VSTRT << 1) + H_CIF - (__s32)sel->r.height,
+			      1, 0);
 
-	ret = ov6650_reg_write(client, REG_HSTRT, rect.left >> 1);
+	ret = ov6650_reg_write(client, REG_HSTRT, sel->r.left >> 1);
 	if (!ret) {
-		priv->rect.left = rect.left;
+		priv->rect.left = sel->r.left;
 		ret = ov6650_reg_write(client, REG_HSTOP,
-				(rect.left + rect.width) >> 1);
+				       (sel->r.left + sel->r.width) >> 1);
 	}
 	if (!ret) {
-		priv->rect.width = rect.width;
-		ret = ov6650_reg_write(client, REG_VSTRT, rect.top >> 1);
+		priv->rect.width = sel->r.width;
+		ret = ov6650_reg_write(client, REG_VSTRT, sel->r.top >> 1);
 	}
 	if (!ret) {
-		priv->rect.top = rect.top;
+		priv->rect.top = sel->r.top;
 		ret = ov6650_reg_write(client, REG_VSTOP,
-				(rect.top + rect.height) >> 1);
+				       (sel->r.top + sel->r.height) >> 1);
 	}
 	if (!ret)
-		priv->rect.height = rect.height;
+		priv->rect.height = sel->r.height;
 
 	return ret;
 }
-- 
2.20.1



